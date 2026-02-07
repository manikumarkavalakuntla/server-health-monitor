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

print_server_health_metrics(){

	GET_CPU=$(check_cpu_usage)
	GET_MEM=$(check_memory_usage)
	GET_DISK=$(check_disk_usage)

	#echo "CPU Usage	: $GET_CPU%"
	#echo "Memory Usage : $GET_MEM%"
	#echo "Disk Usage : $GET_DISK"
	

	printf "%-15s : %s%% %s\n" "CPU Usage" "$GET_CPU" "[ WARNING ]"
	printf "%-15s : %s\n" "Memory Usage" "$GET_MEM"
	printf "%-15s : %s\n" "Disk Usage" "$GET_DISK"
}

check_cpu_usage(){

	#top -bn1 | grep "%Cpu(s)" | awk '{print 100-$8}'
	mpstat 1 1 | awk '/Average/ {printf "%.2f\n", 100 - $NF}'
}

check_memory_usage(){

	free  | awk '/Mem:/ {printf "%.2f", (($2-$7)/$2)*100}'
}

check_disk_usage(){

	df -Th | awk '/\/dev\/sdd/ {printf $6}'
}

print_server_health_metrics
