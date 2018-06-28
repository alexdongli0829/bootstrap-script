#!/bin/bash
aws s3 cp s3://dongaws/bootstrap/generatedata/dongaws-sdy.pem ~/ 
chmod 600 ~/dongaws-sdy.pem
aws s3 cp s3://dongaws/bootstrap/generatedata/gen.sh ~/
chmod +x ~/gen.sh
aws s3 cp s3://dongaws/bootstrap/generatedata/gendata.py ~/ 
aws s3 cp s3://dongaws/bootstrap/generatedata/batch_run.sh ~/
chmod +x ~/batch_run.sh
