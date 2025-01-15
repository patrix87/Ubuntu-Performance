#!/bin/bash

# Power Settings
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'

# Disable Sleep
sudo mkdir -p /etc/systemd/sleep.conf.d
sudo cp "./payload/disable-sleep.conf" "/etc/systemd/sleep.conf.d/disable-sleep.conf"


# Check if intel_pstate is used and disable it.
if [ -d "/sys/devices/system/cpu/intel_pstate" ]; then
    echo "intel_pstate is used"
    echo off | sudo tee /sys/devices/system/cpu/intel_pstate/status
fi

# Set Performance Mode on Startup
sudo cp "./payload/set-performance-mode.sh" "/usr/local/sbin/set-performance-mode.sh"
sudo chmod u+x "/usr/local/sbin/set-performance-mode.sh"
sudo cp "./payload/set-performance-mode.service" "/etc/systemd/system/set-performance-mode.service"
sudo systemctl start set-performance-mode
sudo systemctl enable set-performance-mode

# Installing low latency optimisations
# Add preempt=full nohz_full=all disable intel_pstate disable PCIe Active State Power Management
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="preempt=full nohz_full=all pcie_aspm=off intel_pstate=disable /' /etc/default/grub
sudo update-grub

# disable proactive memory compaction:
echo 0 | sudo tee /proc/sys/vm/compaction_proactiveness

# disable kernel samepage merging
echo 0 | sudo tee /sys/kernel/mm/ksm/run

# trashing mitigation (prevent working set from getting evicted for 1000 millisec, this can help to mitigate stuttering behavior under memory pressure conditions):
echo 1000 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms

# prevent stuttering behavior during intense I/O writes that may involve massive page cache flushing:
echo 5 | sudo tee /proc/sys/vm/dirty_ratio
echo 5 | sudo tee /proc/sys/vm/dirty_background_ratio

