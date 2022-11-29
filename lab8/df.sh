#! /bin/bash
mkdir -p /webdta
while true
do
	df -h / > /webdata/index.html
	sleep 10
done

