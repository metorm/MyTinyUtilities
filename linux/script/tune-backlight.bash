#!/bin/bash

# On ubuntu 16.04 (Maybe above), installing official NVIDIA driver results in not being able to tune screen brightness
# using Fn key on some laptop
# This simple script would make brightness tuning work again
# This script is originally written by http://sub-pop.net/post/fedora-23-on-system76-oryx-pro/
# I fixed it to make it work with my laptop 

# To use this, you need to make sure:
# 1. You have a /sys/class/backlight/* directory
# 1. In the directory these files exists: actual_brightness  brightness max_brightness
# 3. The value in 'actual_brightness' file changes when you press Fn + F5 or other keys
# 4. Using the follwoing command:
#
# nvidia-settings -n -a BacklightBrightness=50
#
# actually changes your screen brightness

# This script just watch the change of sys/class/backlight/*/actual_brightness and write it to nvidia-settings,
# a simple but broken mechanism in ubuntu16.04 / NVIDIA system

# Begain to use:

# Make sure the 'export DISPLAY=:1' line fits the main screen of your system. Modify as you want
# Make sure the 'max=...' and 'level=...' lines fit your system. Modify as you want
# Install 'inotify-tools' package to make sure there is 'inotifywait' command to watch file change
# Run this script and enjoy

# You can use supervisor or systemd to run this script in background
# Here is an example supervisor config file:
#
# [program:backlight]
# command=/bin/bash /home/metorm/script/tune-backlight.bash
# autostart=true
# autorestart=true
# redirect_stderr=true
# user=###-> Your user name goes here <-###
# stdout_logfile=/var/log/supervisor/tune-backlight.log


export DISPLAY=:1

max=/sys/class/backlight/acpi_video0/max_brightness
level=/sys/class/backlight/acpi_video0/actual_brightness
factor=$(awk '{print $1/100}' <<< $(<$max)) 

xblevel() { awk '{print int($1/$2)}' <<< "$(<$level) $factor"; }
nvidia-settings -n -a 0/BacklightBrightness=$(xblevel)
inotifywait -m -qe modify $level | while read -r file event; do
    nvidia-settings -n -a 0/BacklightBrightness=$(xblevel)
done

