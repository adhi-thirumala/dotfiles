#!/bin/bash

# Function to set the power profile
set_power_profile() {
    local profile="$1"
    powerprofilesctl set "$profile" 2>/dev/null
}

# Check initial power state (in case of service restart or system boot)
if on_ac_power; then
    set_power_profile performance
else
    set_power_profile power-saver
fi

# Monitor for power changes using udevadm
udevadm monitor --environment --udev --subsystem-match=power_supply | \
while read -r line; do
    if [[ "$line" =~ "POWER_SUPPLY_ONLINE=1" ]]; then
        set_power_profile performance
    elif [[ "$line" =~ "POWER_SUPPLY_ONLINE=0" ]]; then
        set_power_profile power-saver
    fi
done
