#!/bin/bash
file="./scope.txt"
scope=$(cat $file)
if [ ! -f $file ]
then
	echo "Make sure a scope.txt file is in the current directory!"
fi
if [ ! -d "./amass-subdomains" ]
then
	mkdir "amass-subdomains"
fi
for line in $scope
do
	all=./'amass-subdomains/all-'$line
	live=./'amass-subdomains/live-'$line
	echo "Starting on "$line
	echo "Finding subdomains..."
	amass enum -passive -silent -d $line
	amass db -names -d $line > $all
	echo "Checking for live hosts..."
	cat $all | httprobe -t 5000 > $live
	echo "Grabbing body and header info..."
	cat $live | fff --ignore-empty -d 500 -S -o metadata
	echo -e "\n"
done
echo "Done!"
