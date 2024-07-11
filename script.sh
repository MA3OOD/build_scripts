#!/bin/bash

rm -rf .repo/local_manifests/

# repo init rom
repo init --depth=1 --no-repo-verify -u https://github.com/AfterLifePrjkt13/android_manifest.git -b LTS -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Gtajisan/local_manifests -b afterlife .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

# Export
export BUILD_USERNAME=FARHAN
export BUILD_HOSTNAME=crave
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
echo "======= Export Done ======"

# Set up build environment
. build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch afterlife_Mi439_4_19-uerdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m afterlife






