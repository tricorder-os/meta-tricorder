inherit image_types

do_image_bootimg[depends] += " \
  mkbootimg-native:do_populate_sysroot \
  virtual/kernel:do_deploy \
  "

# must be defined in machine config
KERNEL_CMDLINE ?= ""
KERNEL_RAMBASE ?= ""
KERNEL_PAGESIZE ?= ""
RAMDISK_OFFSET ?= ""
TAGS_OFFSET ?= ""

BOOTIMG_BASE_NAME ?= "${PKGV}-${PKGR}-${MACHINE}-${DATETIME}"
BOOTIMG_BASE_NAME[vardepsexclude] = "DATETIME"

BOOTIMG_KERNEL = "$(readlink -f ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE})"
BOOTIMG_DTB = "$(readlink -f ${DEPLOY_DIR_IMAGE}/${KERNEL_DEVICETREE})"
BOOTIMG_INITRAMFS = "$(readlink -f ${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE}-${MACHINE}.cpio.gz)"

BOOTIMG_KERNEL_WITH_DTB = "${KERNEL_IMAGETYPE}-dtb-${BOOTIMG_BASE_NAME}.bin"
BOOTIMG_IMAGE = "${PN}-boot-${BOOTIMG_BASE_NAME}.img"

IMAGE_CMD_bootimg() {
  install -d ${DEPLOY_DIR_IMAGE}

  cat ${BOOTIMG_KERNEL} \
    ${BOOTIMG_DTB} > \
    ${B}/${KERNEL_IMAGETYPE}-dtb

  if [ -z "${INITRAMFS_IMAGE}" ]; then
    dd if=/dev/zero of=${B}/dummy.img bs=4096 count=1
    BOOTIMG_INITRAMFS="${B}/dummy.img"
  fi

  mkbootimg \
    --kernel "${B}/${KERNEL_IMAGETYPE}-dtb" \
    --cmdline "${KERNEL_CMDLINE}" \
    --ramdisk ${BOOTIMG_INITRAMFS} \
    --base ${KERNEL_RAMBASE} \
    --pagesize ${KERNEL_PAGESIZE} \
    --ramdisk_offset ${RAMDISK_OFFSET} \
    --tags_offset ${TAGS_OFFSET} \
    --output ${B}/boot.img \
    --board ${MACHINE}

  install ${B}/boot.img \
    ${DEPLOY_DIR_IMAGE}/${BOOTIMG_IMAGE}

  ln -sf ${BOOTIMG_IMAGE} \
    ${DEPLOY_DIR_IMAGE}/${PN}-boot-${MACHINE}.img

  ln -sf ${BOOTIMG_IMAGE} \
    ${DEPLOY_DIR_IMAGE}/${PN}-boot.img
}
