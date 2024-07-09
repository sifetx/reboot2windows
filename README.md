# reboot2windows
A simple Bash script that checks for a Windows installation on the system and, if found, reboots into it.


## Prerequisites and some info
To use this script you must have Windows already installed (on another drive or another partition) and your primary boot option must be Linux, not Windows. This script also assumes that the system does not have any other dual-boot setup *(although not tested)*, and that the only way to switch between systems would be through the BIOS or the boot selector.

## Installation

1. Download the script to your home folder using `curl`.

   `curl -L -o ~/reboot2windows.sh https://raw.githubusercontent.com/sifetx/reboot2windows/main/reboot2windows.sh`
2. Make the script executable.

   `chmod +x ~/reboot2windows.sh`
3. Add an alias for the command to the `.bashrc` file.

   `echo "alias reboot2windows='sudo ~/reboot2windows.sh'" >> ~/.bashrc`
4. Source the `.bashrc` file using `source ~/.bashrc` or simply restart the terminal.

## Usage
To use the script just type `reboot2windows` in the terminal and it enter. The script will then try to find an existing Windows installation on the BIOS Boot Menu and, if found, reboot into it. To go back to Linux just restart your computer again and the system should go back to the main OS.

## Some errors that might appear
- **"This script requires sudo permissions."** - Check if you have the necessary sudo permissions and if the command alias was successfully added to the `.bashrc` file. *(Installation, step 3)*
- **"efibootmgr not found."** - Check if you have `efibootmgr` installed using `efibootmgr --version`, and if you don´t, just install it and try to run the script again.
- **"Windows installation not found."** - This error indicates that `efibootmgr` couldn´t find your windows installation. Follow the steps to manually try to find a Windows installation.

----
This repository is a mirror. Original repository in [Codeberg.org](https://codeberg.org/sifet/reboot2windows).
