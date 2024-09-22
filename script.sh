#!/bin/bash

rm -rf .repo/local_manifests/

# repo init rom
repo init -u https://github.com/alphadroid-project/manifest -b alpha-14 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Masood-J/local_manifests.git -b Sigma-14 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Export
export BUILD_USERNAME=Masood
export BUILD_HOSTNAME=crave
export ALPHA_MAINTAINER=Masood
export ALPHA_BUILD_TYPE=Official
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true


echo "======= Export Done ======"

# Set up build environment
. build/envsetup.sh
echo "====== Envsetup Done ======="

# Step 3: Modify and rename files after creation

# List all files in a10 directory
# Create or overwrite miku_a10.mk with the desired content
echo "Creating or overwriting lineage_a10.mk..."
cat > device/samsung/a10/lineage_a10.mk << 'EOF'
# Copyright (C) 2018 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_p.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/a10/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# Rom Specific Flags
TARGET_HAS_UDFPS := true
TARGET_ENABLE_BLUR := false
TARGET_EXCLUDES_AUDIOFX := true
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_BUILD_PACKAGE := 1
TARGET_LAUNCHER := 1

# Maintainer
ALPHA_BUILD_TYPE := Official
ALPHA_MAINTAINER := Masood

# Device identifier
PRODUCT_DEVICE := a10
PRODUCT_NAME := lineage_a10
PRODUCT_MODEL := SM-A105F
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_GMS_CLIENTID_BASE := android-samsung
EOF

# Modify AndroidProducts.mk for A10
if [ -f "device/samsung/a10/AndroidProducts.mk" ]; then
    echo "Modifying AndroidProducts.mk for A10..."
    
    # Overwrite AndroidProducts.mk with the desired contents
    cat > device/samsung/a10/AndroidProducts.mk << 'EOF'
PRODUCT_MAKEFILES := \
    device/samsung/a10/lineage_a10.mk

COMMON_LUNCH_CHOICES := \
    lineage_a10-eng \
    lineage_a10-user \
    lineage_a10-userdebug
EOF
fi


# Step 4: Continue with the build process

# Build for A10
lunch lineage_a10-user && make installclean && make bacon 
