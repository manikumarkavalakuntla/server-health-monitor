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
LOG_FILE="/home/manikumar/server-health-monitor/logs/health.log"

# -------------------- Threshold Configuration --------------------

CRITICAL_THRESHOLD=90
WARNING_THRESHOLD=75
GLOBAL_EXIT_CODE=0


echo "------------------------------------------------------------------------------------------------------------------------------"

echo "Server Health Check Report"
echo "Date & Time : $DATE"
echo "Hostname    : $HOSTNAME"

echo "------------------------------------------------------------------------------------------------------------------------------"

get_metric_status(){
	
	local METRIC_VALUE=$1
	local STATUS=""
        local CODE=0

	if awk "BEGIN {exit !($METRIC_VALUE >= $CRITICAL_THRESHOLD)}";then
		
		echo "[	CRITICAL ]"
		exit 2

	elif awk "BEGIN {exit !($METRIC_VALUE >= $WARNING_THRESHOLD)}";then

		echo "[ WARNING ]"
		exit 1
	
	else
		echo "[ OK ]"
		exit 0
	
	fi

#----------------------------- Track highest severity ----------------------------------------

    if [[ $CODE -gt $GLOBAL_EXIT_CODE ]]; then

        GLOBAL_EXIT_CODE=$CODE
    fi

    echo "$STATUS"
}

log_message() {
    local MESSAGE="$1"
    echo "$MESSAGE" >> "$LOG_FILE"
}


print_server_health_metrics(){

	GET_CPU=$(check_cpu_usage)
        GET_MEM=$(check_memory_usage)
        GET_DISK=$(check_disk_usage)

 	CPU_STATUS=$(get_metric_status "$GET_CPU")
        MEM_STATUS=$(get_metric_status "$GET_MEM")
        DISK_STATUS=$(get_metric_status "$GET_DISK")

#       printf "%-15s : %s%% %s\n" "CPU Usage" "$GET_CPU" "$CPU_STATUS"
#       printf "%-15s : %s%% %s\n" "Memory Usage" "$GET_MEM" "$MEM_STATUS"
#       printf "%-15s : %s%% %s\n" "DISK Usage" "$GET_DISK" "$DISK_STATUS"

	CPU_LINE=$(printf "%-15s : %s%% %s" "CPU Usage" "$GET_CPU" "$CPU_STATUS")
        MEM_LINE=$(printf "%-15s : %s%% %s" "Memory Usage" "$GET_MEM" "$MEM_STATUS")
        DISK_LINE=$(printf "%-15s : %s%% %s" "DISK Usage" "$GET_DISK" "$DISK_STATUS")

	echo "$CPU_LINE"
        echo "$MEM_LINE"
        echo "$DISK_LINE"

	# Log them
        log_message "$DATE - $CPU_LINE"
        log_message "$DATE - $MEM_LINE"
        log_message "$DATE - $DISK_LINE"

}


check_cpu_usage(){

	mpstat 1 1 | awk '/Average/ {printf "%.2f\n", 100 - $NF}'
}

check_memory_usage(){

	free  | awk '/Mem:/ {printf "%.2f", (($2-$7)/$2)*100}'
}

check_disk_usage(){

	df -h / | awk 'NR==2 {gsub("%",""); print $5}'
}

print_server_health_metrics
exit $GLOBAL_EXIT_CODE
