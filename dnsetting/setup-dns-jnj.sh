#!/bin/sh
#
# Set up DNS for EMR master/slave instance in VPC. 
# This script also set up DNS in us-east-1 for non-VPC to handle ec2 instances, 
# whose host name begin with domU, with invalid dns domain name (TT0055043598).
# 
set -x

curl="curl --connect-timeout 2 -q -f --retry-delay 2 --retry 5"

resolv_conf="/etc/resolv.conf"
dhclient_conf="/etc/dhcp/dhclient.conf"
localhost="127.0.0.1"
metadata="http://169.254.169.254/latest/meta-data"

restart_network="false"

mac_address="$($curl $metadata/mac/ | tr '[:upper:]' '[:lower:]')"
region="$($curl http://169.254.169.254/latest/dynamic/instance-identity/document \
          | jq -r .region)"

get_search_domains()
{
    awk '$1 ~ /^search/ { sub(/^search /,""); print }' "$resolv_conf"
}

get_vpc_cidrs()
{
    echo $($curl \
         "$metadata/network/interfaces/macs/$mac_address/vpc-ipv4-cidr-blocks")
}

get_first_nameserver()
{
    awk '$1 ~ /^nameserver/ { print $2; exit }' "$resolv_conf"
}

run_dnsmasq()
{
    all_domains="$(get_search_domains)"

    if ps uww -C dnsmasq >/dev/null 2>&1; then
        pid="$(ps uww -C dnsmasq | awk '/synth-domain/ { print $2 }')"
        sudo kill "$pid"
    fi

    for d in $all_domains; do
        for c in $(get_vpc_cidrs); do
            syn_domains="$syn_domains --synth-domain=$d,$c,ip- "
        done
    done
    sudo dnsmasq --listen-address=127.0.0.1 $syn_domains
    status="$?"

    if [ "$status" = "0" ]; then
        echo "started dnsmasq."
    fi

    first_nameserver="$(get_first_nameserver)"

    if [ "$first_nameserver" != "$localhost" ]; then
        prepend_domain_server "$localhost"
    fi

    return $status
}

get_hostname()
{
    hostname -f
    return $?
}

check_reverse()
{
    fqdn="$1"

    nameserver="$(get_first_nameserver)"
    ip_addr="$(host $hostname \
               | awk "\$0 ~ /^$fqdn has address/ { print \$4; exit }")"
    reverse="$(dig +short @$nameserver -x $ip_addr)"

    if [ -z "$reverse" -o \
    "$reverse" = ";; connection timed out; no servers could be reached" ]; then
        return 1
    fi

    if [ "$reverse" != "$hostname." ]; then
        return 1
    fi

    return 0
}

show_dns_status()
{
    type="$1"
    echo "------------ $type $resolv_conf ------------"
    cat "$resolv_conf"
    echo "------------ $type $dhclient_conf ------------"
    cat "$dhclient_conf"
    hostname="$(get_hostname)"
    status="$?"
    echo "'hostname -f' returns : $hostname"

    if [ "$status" != "0" ]; then
        return $status
    fi

    check_reverse "$hostname"
    status="$?"
    if [ "$status" = "0" ]; then
        echo "Reverse DNS works and matches."
    else
        echo "Reverse DNS is incorrect."
    fi
    return $status
}

restart_network_if_needed()
{
    if "$restart_network"; then
        echo "Updating DNS settings."
        sudo service network restart
        restart_network="false"
    fi
}

append_line_to_dhclient_conf()
{
    echo "$1" | sudo tee -a "$dhclient_conf"
}

prepend_domain()
{
    #sample line : prepend domain-name "ec2.internal  ";
    if grep -Eq "^prepend domain-name \"$1 +\";$" "$dhclient_conf"; then
        return
    else
        append_line_to_dhclient_conf "prepend domain-name \"$1 \";"
        restart_network="true"
    fi
}

prepend_domain_server()
{
    #sample line : prepend domain-name-servers 127.0.0.1;
    if grep -Eq "^prepend domain-name-servers $1;$" "$dhclient_conf"; then
        return
    fi
    append_line_to_dhclient_conf "prepend domain-name-servers $1;"
    restart_network="true"
}

main()
{
    rundnsmasq="$1"

    # wait for the network to come up before proceeding
    if [ -e /usr/bin/nm-online ]; then
        sudo /usr/bin/nm-online
    fi

    if ! grep -q ^search "$resolv_conf"; then
        echo "Domain is missing, exiting."
        return 1
    fi

    show_dns_status "BeforeSetup"

    old_domains="$(get_search_domains)"

    default_domain="ec2.internal"
    if [ "$region" != "us-east-1" ]; then
        default_domain="$region.compute.internal"
    fi

    in_vpc="false"
    if $curl "$metadata/network/interfaces/macs/$mac_address/" \
        | grep -q vpc; then
        in_vpc="true"
    fi

    if [ "$in_vpc" = "false" ]; then
        # NON-VPC
        if [ "$region" = "us-east-1" ]; then
            for i in $old_domains; do
                if [ "$i" = "$default_domain" ]; then
                    echo "$default_domain is already used in us-east-1."
                    break
                fi
            done

            echo "Making sure $default_domain is used in us-east-1."
            prepend_domain $default_domain
        else
            echo "Not in VPC, do nothing and exit."
        fi
    else
        # VPC
        if [ "$rundnsmasq" != "rundnsmasq" ]; then
            resolving_host_name="$(get_hostname)"
            hostname_works="$?"

            if [ -z "$resolving_host_name" -o "$hostname_works" != "0" ]; then
                rundnsmasq=rundnsmasq
            else
                check_reverse "$resolving_host_name"
                reverse_works="$?"

                if [ "$reverse_works" != "0" ]; then
                    rundnsmasq=rundnsmasq
                fi
            fi 
        fi

        if [ "$rundnsmasq" = "rundnsmasq" ]; then
            run_dnsmasq || return $?
        else
            printf "Resolving hostname(${resolving_host_name}) successfully, "
            echo "do nothing and exit."
        fi
    fi

    restart_network_if_needed
    show_dns_status "AfterSetup"
    return $?
}

main "$@"
exit $?
