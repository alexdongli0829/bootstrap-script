#!/bin/bash
set -x

sudo groupadd test

sudo useradd -d /home/dong -m -G test dong

sudo -u dong mkdir /home/dong/.ssh
sudo -u dong chmod 700 /home/dong/.ssh

sudo -u dong touch /home/dong/.ssh/authorized_keys

sudo -u dong bash -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsOujB9YtRgB92M2hkZdLWHsAj/6kGSyjmiprhXO9K7JhC2TLpInLFSZjnaVkj1bVpUq5HGsG3ZusiiUiGl2R6cXi4FE3jPY1nxYc0Xs4uNvqpDJUvwSo8CyTUTCKdUvvkTdHD/6hnxJ72FYo+pKTjws6LJ4C4LCKRC5PbiECT+X1/A5/ntKF6zQ84AyIE93noR1X7wzOX59Vae6x4aSXeYpv+FrZPL3rcd0WWmToXKNgcF85bWxwocivkIOcMTJuaKx/vO54aD5wjG5Y8G3iVH2l70PgYxyAV8lh1bGewEQBvY3C8cGAIBYvGpJIt/2Gh5HNYabMNCyIc7b2BR0sZ dongaws@c4b301b9a755.ant.amazon.com" >> /home/dong/.ssh/authorized_keys'

sudo -u dong chmod 600 /home/dong/.ssh/authorized_keys
