#!/bin/bash
sleep 120
powerprofilesctl set performance
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor