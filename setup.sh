#!/data/data/com.termux/files/usr/bin/sh

# Enabling exit on error to ensure the script stops if any command fails
set -e

# Disabling SSH installation by default
INSTALL_SSH=false

# Setting positional parameters for package installation
# x11-repo is required for X11 packages
# proot-distro is required to install and manage Linux distributions in Termux
set -- x11-repo proot-distro

# Checking if the argument to install SSH is provided
if [ "$1" = "--ssh" ]; then
    INSTALL_SSH=true

    # Adding openssh to the list of packages to be installed
    set -- openssh $@
fi

# Upgrading existing packages along with updating package lists
echo "Upgrading existing packages..."
apt update && apt full-upgrade -y

# Installing required packages specified in the positional parameters
echo "\nInstalling required packages: $@"
apt install $@

# Installing necessary packages: pulseaudio for audio support,
# termux-x11-nightly for X11 server, bspwm as the window manager
# Note: sxhkd is included with bspwm package which is required for termux bspwm package to work,
# but if it's not termux then you may need to install it separately.
echo "\nInstalling additional required packages: pulseaudio, termux-x11-nightly, bspwm"
apt install pulseaudio termux-x11-nightly bspwm

# Installing Debian distribution using proot-distro
echo "\nInstalling Debian proot-distro..."
proot-distro install debian

# Creating configuration directory for bspwm
mkdir -p ~/.config/bspwm

# Downloading custom configuration files for bash and bspwm
echo "\nDownloading configuration files..."
curl -o ~/.bashrc https://raw.githubusercontent.com/IQuarks/xenos/main/.bashrc
curl -o ~/.config/bspwm/bspwmrc https://raw.githubusercontent.com/IQuarks/xenos/main/.bspwmrc

# Making the bashrc and bspwmrc files executable
chmod +x ~/.bashrc
chmod +x ~/.config/bspwm/bspwmrc

# Cleaning up unnecessary files to free up space
echo "\nCleaning up..."
apt-get clean
proot-distro clear
rm $PREFIX/etc/motd

# Launching the xenify script inside the Debian proot-distro environment
echo "\nLaunching xenify script inside Debian proot-distro..."
proot-distro login debian -- bash <(curl -sL https://raw.githubusercontent.com/IQuarks/xenos/main/xenify.sh) $INSTALL_SSH
