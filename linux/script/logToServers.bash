#!/bin/sh
# convinient way to login in to different ssh servers
# when ssh key is not available

# require: sshpass

# USE sshpass HERE IS NOT SAFE, DO NOT USE FOR IMPORTANT SERVERS

if [ $# -lt 1 ]; then
    echo "No server name is provided!"
elif [ $1 = "ff" ]; then
    sshpass -p XXXXX ssh root@xxx.xxx.xxx.xxx
elif [ $1 = "qt" ]; then # QiTian
	ssh -p 1402 metorm@xxx.xxx.xxx.xxx
elif [ $1 = "al" ]; then # Aliyun
    ssh root@xxx.xxx.xxx.xxx
else
    echo "Unknow server $1"
fi

exit 0;
