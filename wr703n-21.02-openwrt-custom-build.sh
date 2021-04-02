#!/bin/sh

# Exit immediately if a simple command exits with a non-zero status
set -e

echo "Cloning OpenWrt ${OPENWRT_TAG}"
git clone --branch ${OPENWRT_TAG} https://github.com/openwrt/openwrt.git
cd openwrt
./scripts/feeds update
./scripts/feeds install

# Add tl-wr703n-v1-16m defination
echo '
define Device/tplink_tl-wr703n-v1                                                                                   
  $(Device/tplink-16mlzma)                                                                                           
  SOC := ar9331                                                                                                     
  DEVICE_MODEL := TL-WR703N                                                                                         
  DEVICE_VARIANT := v1                                                                                              
  DEVICE_PACKAGES := kmod-usb-chipidea2 kmod-usb-ledtrig-usbport                                                    
  TPLINK_HWID := 0x07030101                                                                                         
  SUPPORTED_DEVICES += tl-wr703n                                                                                    
endef                                                                                                               
TARGET_DEVICES += tplink_tl-wr703n-v1
' >> target/linux/ath79/image/generic-tp-link.mk

# Download .config
wget https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/ath79/generic/config.buildinfo -O config.buildinfo
rm -rf .config*
mv config.buildinfo .config

make defconfig

# Remove other devices
sed -i '/CONFIG_TARGET_DEVICE_*/d' .config

# Select tl-wr703n-v1 only
echo '
CONFIG_TARGET_BOARD="ath79"
CONFIG_TARGET_SUBTARGET="generic"
CONFIG_TARGET_ath79_generic_DEVICE_tl-wr703n-v1=y
CONFIG_TARGET_PROFILE="DEVICE_tl-wr703n-v1"
' >> .config

make defconfig
