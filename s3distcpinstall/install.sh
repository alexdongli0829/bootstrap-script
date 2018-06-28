#!/bin/bash
set -x
sudo mkdir -p /usr/share/aws/emr/s3-dist-cp/
sudo aws s3 cp s3://dongaws/s3-dist-cp/install/ /usr/share/aws/emr/s3-dist-cp/ --recursive
sudo aws s3 cp s3://dongaws/s3-dist-cp/bin/s3-dist-cp /usr/bin/s3-dist-cp
sudo chmod +x /usr/bin/s3-dist-cp
sudo chmod +x /usr/share/aws/emr/s3-dist-cp/bin/s3-dist-cp

