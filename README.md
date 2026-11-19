# TWRP device tree for ADT-3 (adt3 / diana_p1)

Allwinner sun55iw3p1 based device (Askey ADT-3).

## How to build

```bash
# Sync TWRP 14.1
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-14.1
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

# Place this tree
mkdir -p device/askey
# put the content of this zip into device/askey/adt3

# Build
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
lunch twrp_adt3-eng
mka bootimage -j$(nproc)
```

Output: `out/target/product/adt3/boot.img`

Kernel is already included as prebuilt (extracted from stock boot.fex).
