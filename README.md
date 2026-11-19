# TWRP device tree for ADT-3 (adt3 / diana_p1)

Allwinner sun55iw3p1. Recovery in **vendor_boot**.

## Action-TWRP-Builder settings

- BUILD_TARGET = **vendorboot**
- MAKEFILE_NAME = twrp_adt3
- DEVICE_NAME = adt3
- DEVICE_PATH = device/askey/adt3

## Manual build

```bash
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
lunch twrp_adt3-eng
mka vendorbootimage -j$(nproc)
```

Output: `out/target/product/adt3/vendor_boot.img`
