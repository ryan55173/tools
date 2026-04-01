#!/bin/bash


## Check if root
if [[ "$EUID" != 0 ]]; then
	echo "This needs to be ran as root"
	exit 1
fi

## Upgrade and update bootloader
pacman -Syyu --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
echo "System is now upgraded and bootloader is updated"

## Prompt for restart
read -rp "Restart now? (y/n): " answer
answer="${answer,,}"
restart=0
while [[ "$restart" == 0 ]]; do
	case "$answer" in
    	y|yes)
        	restart=1
        	;;
    	n|no)
        	restart=2
        	;;
    	"")
        	restart=2
        	;;
    	*)
        	read -rp "Invalid input, restart now? (y/n): " answer
			answer="${answer,,}"
        	;;
	esac
done
if [[ "$restart" == 1 ]]; then
	echo "Rebooting now"
	sleep 1
	reboot now
elif [[ "$restart" == 2 ]]; then
	echo "Skipping restart..."
fi

