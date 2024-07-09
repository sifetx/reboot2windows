#!/bin/bash


# prompts for confirmation before rebooting
CONFIRM_PROMPT=true

# delay before continuing with reboot
DELAY=5

# set a default boot ID; this way, the script will automatically launch into that OS without checking for Windows Boot Manager
# keep it empty in most use cases
DEFAULT=


reboot_with_id() {
    # confirming before continuing
    if [ "$CONFIRM_PROMPT" = true ] ; then
        echo "Press ENTER to reboot or CTRL+C to exit..."; read
    fi

    # waiting before rebooting
    if [ $DELAY -gt 0 ]; then
        echo "Rebooting in $DELAY seconds..."; sleep $DELAY
    fi

    # configuring the system to boot with Windows on the next reboot
    sudo efibootmgr --bootnext $1 > /dev/null 2>&1
    sleep 0.5

    # rebooting
    echo "Bye"
    sudo reboot

    exit 0
}

# checking for sudo permissions
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo permissions."
    # exec sudo "$0" "$@"
    exit 1
fi

# checking if efibootmgr is installed
if ! command -v efibootmgr >/dev/null 2>&1; then
    echo "efibootmgr not found."
    exit 1
fi

# if the default id is defined, the script will try to use it
if [ -n "$DEFAULT" ]; then
    # getting only the numeric part of the ID
    DEFAULT=$(echo "$DEFAULT" | grep -o '[0-9]\+')

    # getting the OS with the id inserted int the DEFAULT constant
    default_id_output=$(sudo efibootmgr | grep "Boot$DEFAULT")

    # checking if the id is a valid OS
    if [ -z "$default_id_output" ]; then
        echo "Invalid DEFAULT boot option. Check DEFAULT constant on the script and try again. Closing."
        exit 1
    fi

    reboot_with_id $DEFAULT
fi

# checking for windows installations
efibootmgr_output=$(sudo efibootmgr | grep -i "Windows Boot Manager")

if [ -z "$efibootmgr_output" ]; then
    # windows installation was not found
    echo "Windows installation not found."; echo
    echo "Press ENTER to proceed or CTRL+C to exit..."; read
    echo "Running efibootmgr"
    echo
    sudo efibootmgr
    echo
    echo "Locate the Windows installation ID (BootXXXX*, example: 0001)"
    echo "Insert the Windows ID (or CTRL+C to exit): "; read input_id

    # getting only the numeric part of the input_id
    input_id=$(echo "$input_id" | grep -o '[0-9]\+')

    # checking if the input_id is valid
    if [ -z "$input_id" ]; then
        echo "Invalid input. Closing."
        exit 1
    fi

    # getting the OS with the id inserted by the user
    input_id_output=$(sudo efibootmgr | grep "Boot$input_id")

    # checking if the id is a valid OS
    if [ -z "$input_id_output" ]; then
        echo "ID $input_id not found. Closing."
        exit 1
    fi

    echo "Using ID $input_id as next boot option."
    reboot_with_id $input_id

else
    # the installation was found correctly
    # grabbing the boot id for windows
    windows_boot=$(echo "$efibootmgr_output" | awk '{print $1}' | cut -d 't' -f 2 | cut -d '*' -f 1)
    reboot_with_id $windows_boot
fi
