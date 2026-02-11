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

	CPU_STATUS=""
	MEM_STATUS=""
	DISK_STATUS=""

	if awk "BEGIN {exit !($GET_CPU >= 90)}"; then

		CPU_STATUS=$(printf "%-15s : %s%% %s" "CPU Usage" "$GET_CPU" "[ CRITICAL ]")

	elif awk "BEGIN {exit !($GET_CPU >= 75)}";then

		CPU_STATUS=$(printf "%-15s : %s%% %s" "CPU Usage" "$GET_CPU" "[ WARNING ]")

	else
		CPU_STATUS=$(printf "%-15s : %s%% %s" "CPU Usage" "$GET_CPU" "[ OK ]")	

	fi

	printf "%s\n" "$CPU_STATUS"

	if awk "BEGIN {exit !($GET_MEM >= 90)}"; then

		MEM_STATUS=$(printf "%-15s : %s%% %s" "Memory Usage" "$GET_MEM" "[ CRITICAL ]")

	elif awk "BEGIN {exit !($GET_MEM >= 75)}"; then

		MEM_STATUS=$(printf "%-15s : %s%% %s" "Memory Usage" "$GET_MEM" "[ WARNING ]")
	
	else
		MEM_STATUS=$(printf "%-15s : %s%% %s" "Memory Usage" "$GET_MEM" "[ OK ]")

	fi

	printf "%s\n" "$MEM_STATUS"

	if awk "BEGIN {exit !($GET_DISK >= 90)}"; then

                DISK_STATUS=$(printf "%-15s : %s%% %s" "DISK Usage" "$GET_DISK" "[ CRITICAL ]")

        elif awk "BEGIN {exit !($GET_DISK >= 75)}";then

                DISK_STATUS=$(printf "%-15s : %s%% %s" "DISK Usage" "$GET_DISK" "[ WARNING ]")

        else
                DISK_STATUS=$(printf "%-15s : %s%% %s" "DISK Usage" "$GET_DISK" "[ OK ]")

        fi

	printf "%s\n" "$DISK_STATUS"


}

check_cpu_usage(){

	#top -bn1 | grep "%Cpu(s)" | awk '{print 100-$8}'
	mpstat 1 1 | awk '/Average/ {printf "%.2f\n", 100 - $NF}'
}

check_memory_usage(){

	free  | awk '/Mem:/ {printf "%.2f", (($2-$7)/$2)*100}'
}

check_disk_usage(){

	df -h / | awk 'NR==2 {gsub("%",""); print $5}'
}

print_server_health_metrics

