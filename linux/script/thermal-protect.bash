#!/bin/bash
# Check tempreture every few seconds
# If tempreture is higher than specific value, then bound /sys/devices/system/cpu/intel_pstate/max_perf_pct
# require: sensors, sed, a CPU which supports /sys/devices/system/cpu/intel_pstate/max_perf_pct
# must run using root

# Deal with sensors output like this:

#coretemp-isa-0000
#Adapter: ISA adapter
#Physical id 0:  +52.0°C  (high = +87.0°C, crit = +105.0°C)
#Core 0:         +51.0°C  (high = +87.0°C, crit = +105.0°C)
#Core 1:         +56.0°C  (high = +87.0°C, crit = +105.0°C)
#
#acpitz-virtual-0
#Adapter: Virtual device
#temp1:         +0.0°C  (crit = +127.0°C)
#

# modify following your output

max_temp=64 #°C
check_interval=1 #seconds

# max allowed cpu frequency in percentage under normal condition
high_cpu_frq=100
# max allowed cpu frequency in percentage under when cpu is hot
low_cpu_frq=70

target_cpu_frq=$high_cpu_frq

# main loop
while :
do
    # take tempreture value, split by space
    str_=$(sensors | sed -n '3,5p')
    str__=$(echo $str_ | sed 's/(high = .....°C, crit = ......°C)//g')
    nums=$(echo $str__ | sed 's/°C//g;s/+//g;s/[0-9]://g;s/\.0//g;s/[^0-9]/ /g')

    # get single value
    tmp1=$(echo $nums|cut -f 1 -d " ")
    tmp2=$(echo $nums|cut -f 2 -d " ")
    tmp3=$(echo $nums|cut -f 3 -d " ")

    # judge
    if [ "$tmp1" -gt "$max_temp" ] || [ "$tmp2" -gt "$max_temp" ] || [ "$tmp2" -gt "$max_temp" ]; then
        target_cpu_frq=$low_cpu_frq
    else
        target_cpu_frq=$high_cpu_frq
    fi

    # set new value if necessary
    current_cpu_frq=$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct)
    if [ "$target_cpu_frq" -ne "$current_cpu_frq" ]; then
        time_now=$(date +%m-%d\ %H:%M:%S)
        echo "$time_now max_perf_pct <- $target_cpu_frq"
        echo "$target_cpu_frq" > /sys/devices/system/cpu/intel_pstate/max_perf_pct
    fi
    
    sleep $check_interval
done
