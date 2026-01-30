#!/data/data/com.termux/files/usr/bin/sh

apt update && apt full-upgrade

apt install x11-repo openssh proot-distro

apt install pulseaudio termux-x11-nightly bspwm

pd i debian

passwd

rm $PREFIX/etc/motd

mkdir -p ~/.config/bspwm
