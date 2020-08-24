#!/bin/bash
#Based on 3.2/3.4 from 
#https://github.com/intel/gvt-linux/wiki/GVTg_Setup_Guide

if [[ ! `cat /etc/default/grub` =~ "i915.enable_gvt=1 intel_iommu=on i915.force=probe=*" ]]; then
	echo "Changing /etc/default/grub"
	sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"i915.enable_gvt=1 intel_iommu=on i915.force=probe=*/g" /etc/default/grub
	sudo update-grub
fi

if [[ ! `cat /etc/initramfs-tools/modules` =~ "kvmgt" ]]; then
	echo "Changing /etc/initramfs-tools/modules"
	sudo bash -c "echo -e \"\nkvmgt\nvfio-iommu-type1\nvfio-mdev\n\" >> /etc/initramfs-tools/modules"
	sudo update-initramfs -u -k all
fi
