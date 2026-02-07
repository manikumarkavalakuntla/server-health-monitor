#!/bin/bash

######################################################################################################################################
# Author	: Mani Kumar
# Date		: 05/02/2026
# Project Name	: Server Health Monitor
# Purpose	: To collects the system health metrics, saves it to files, and tracks everything using git & github
# Usage 	: sh /home/manikumar/server-health-monitor/scripts/health_check.sh
# Constraints 	:
# ----------------------------------------------------------------------------------------------------------------------------------
# 1.print date and time
# 2.show:
# 	CPU Usage
# 	Memory Usage
# 	Disk Usage
# 3.Append output to /logs/health.log
# 4.use:
# 	Variables
# 	Functions
# 	At least one if condition
#
#####################################################################################################################################

DATE=$(date +"%Y-%m-%d %H:%M:%S")
HOSTNAME=$(hostname)

echo "------------------------------------------------------------------------------------------------------------------------------"

echo "Server Health Check Report"
echo "Date & Time : $DATE"
echo "Hostname    : $HOSTNAME"

echo "------------------------------------------------------------------------------------------------------------------------------"

