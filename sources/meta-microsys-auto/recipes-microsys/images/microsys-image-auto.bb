# Copyright (C) 2020-2021 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

require recipes-fsl/images/fsl-image-auto.bb
inherit deploy setuptools

IMAGE_INSTALL_append_mpxs32g274a = "${@bb.utils.contains('DISTRO_FEATURES', 'pfe', ' pfe', '', d)}"
IMAGE_INSTALL_append_mpxs32g274a = "${@bb.utils.contains('DISTRO_FEATURES', 'sja1110', ' sja1110 vlan', '', d)}"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS_mpxs32g274a += "kernel-module-pfe"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS_s32g274asbc2 += "kernel-module-sja1110"

MICROSYS_IMAGE_EXTRA_INSTALL += " \
    parted e2fsprogs-resize2fs bashprofile \
"

MICROSYS_IMAGE_EXTRA_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', \
                                   'systemd', 'systemd', '', d)}"

IMAGE_INSTALL += "${MICROSYS_IMAGE_EXTRA_INSTALL}"

IMAGE_INSTALL_remove = "kernel-devicetree"
IMAGE_INSTALL_remove = "gnuplot"
IMAGE_INSTALL_remove = "u-boot-environment"

SDCARD_ROOTFS = "${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}.ext4"

DEPENDS += " parted-native u-boot "

do_image_ext4[depends] += "e2fsprogs-native:do_populate_sysroot"
do_image_ext3[depends] += "e2fsprogs-native:do_populate_sysroot"
do_image_sdcard[rdeptask] += "do_rootfs"
do_image_sdcard[rdeptask] += "do_image_ext4"
do_image_sdcard[rdeptask] += "do_image_qspi"
do_rootfs_kernelitb[rdeptask] += "virtual/kernel:do_deploy"

IMAGE_FSTYPES_remove = "cpio.gz.u-boot"
IMAGE_FSTYPES_remove = "ext3"
IMAGE_FSTYPES += "ext4"
IMAGE_FSTYPES_append_mpxs32g274a = " qspi"

do_rootfs_kernelitb() {
    cp -a ${DEPLOY_DIR_IMAGE}/fitImage*.itb ${IMAGE_ROOTFS}/boot
    rm -f ${IMAGE_ROOTFS}/boot/vmlinux*
    rm -f ${IMAGE_ROOTFS}/boot/fsl-image-*
    rm -f ${IMAGE_ROOTFS}/boot/Image*
}
addtask rootfs_kernelitb after do_rootfs before do_image

do_rootfs_firmware() {
}

do_rootfs_firmware_mpxs32g274a() {
    # PFE firmware:
    cp -a ${DEPLOY_DIR_IMAGE}/${SDCARDIMAGE_BOOT_EXTRA2_FILE} ${IMAGE_ROOTFS}

    # QSPI U-Boot:
    mkdir -p ${IMAGE_ROOTFS}/boot
    cp ${DEPLOY_DIR_IMAGE}/${FLASHIMAGE_UBOOT_FILE} ${IMAGE_ROOTFS}/boot
}
addtask rootfs_firmware after do_rootfs before do_image
