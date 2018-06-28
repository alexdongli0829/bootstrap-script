#!/bin/bash
folder=`hostname`
filename="/mnt/""$folder""_$RANDOM""_db.txt"
python ~/gendata.py 1000000000 $filename
aws s3 cp $filename s3://dongaws/hive/npetest/
