DESCRIPTION = "tricorder initramfs"
LICENSE = "MIT"

inherit core-image

export IMAGE_BASENAME = "tricorder-initramfs"
IMAGE_FSTYPES = "cpio cpio.gz"

PACKAGE_INSTALL = " \
  initramfs-live-boot \
  "

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""
