#!/bin/bash
#######################################
# Server Shepherd
# Date: 06.22.2018
#
#   creep through IP addresses and ports, report application bound to port on server
#   Output:
#       ./Output/serverShepherdOutput*.log
###   Run script as follows
###     chmod +x <namehere>.sh
###     ./<namehere>.sh

#######################################
###     CodeBlock: Directory operations
#######################################
# Define directories as variables (env dependent)
curDir=$(pwd)
curServ=$(hostname)
# Make logging and output directories
mkdir "$curDir/serverShepherdOutput"
outputDir="$curDir/serverShepherdOutput"
# Setup peripheral scripts to execute
chmod +x serverHerder_CA.sh
# Log File Creator
now=$(date +"%m%d%y") #set timestamp as variable
outputFile="$outputDir/serverDetails.$now.log" #create output file
#######################################
###     CodeBlock: Init variables
#######################################
# Command Variables
./serverHerder_CA.sh "$outputFile" "$curServ"
