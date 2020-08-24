#!/bin/bash

URL=https://github.com/intel/linux-intel-lts
BRANCH=5.4/idv_dev
WDIR=idv-dev
CDIR=/root
DEBIAN_FRONTEND=noninteractive

# git shallow clone linux kernel at v4.19.65 with single history depth
cd /mount
if [ ! -d $WDIR ]; then
	git clone --depth 1 $URL --branch $BRANCH --single-branch $WDIR
fi

# Run kernel package building using Ubuntu kernel packaging convention, \
# this will take a long time
( cd $WDIR && yes '' | make oldconfig )
( cd $WDIR && CONCURRENCY_LEVEL=`nproc` fakeroot make-kpkg --initrd --append-to-version=-custom \
	--revision 2.1.0 --overlay-dir=/usr/share/kernel-package kernel_image kernel_headers )

