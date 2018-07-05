#!/bin/bash
#######################################
# Server Shepherd
# Date: 06.2018
#
#   creep through IP addresses and ports, report application bound to port on server. See readme for more information
#   Output:
#       ./Output/serverDetails.log
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
chmod +x serverHerder.sh
# Log File Creator
outputFile="$outputDir/serverDetails.log" #create output file
#######################################
###     CodeBlock: Init variables
#######################################
# Command Variables
./serverHerder.sh "$outputFile" "$curServ"
