#!/bin/bash
# License Query Script for PBS Scheduler to check StarCCM License Availability
#This script must output a single Value that is used to match resources against a value specified in the qsub submission script
feature="standard"

# note for FLEXNet licenses with many features it will be slow to parse through lmstat -a, hence querying only the specific feature
#Pipe through bc so it comes out typedef as a number
/opt/simulia/Commands/abaqus licensing lmstat -f ${feature} | awk '/Users/{ licenses = $6-$11} END { print licenses }' | bc -l
