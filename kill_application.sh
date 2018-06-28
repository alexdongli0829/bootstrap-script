#!/bin/bash
yarn application -kill `yarn application -list all 2>null | grep application_ |awk '{print $1}'`
