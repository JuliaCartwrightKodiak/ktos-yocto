# Copyright (C) 2019-2020 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

create_sparse_file() {

    rootfs=$1
    sdcard=$2

    if [ -z "${rootfs}" ]; then
        bberror "${rootfs} is undefined."
        exit 1
    fi

    bbdebug 1 "rootfs=${rootfs}"

    ROOTFS_SIZE=$(stat -L --printf="%s" ${rootfs})

    bbdebug 1 "ROOTFS_SIZE=${ROOTFS_SIZE}"

    SDCARD_SIZE=$(expr ${ROOTFS_SIZE} + 256 \* 1024)

    PART_START=$(expr 64 \* 2048)

    bbdebug 1 "sdcard=${sdcard}"
    bbdebug 1 "SDCARD_SIZE=${SDCARD_SIZE}"
    bbdebug 1 "PART_START=${PART_START}s"

    # Initialize a sparse file
    dd if=/dev/zero of=${sdcard} bs=1k count=0 seek=${SDCARD_SIZE}

    echo $PART_START
}

partition_sparse_file() {

    sdcard=$1
    part_start=$2

    parted --script ${sdcard} mklabel msdos
    parted ${sdcard} mkpart primary ext4 ${part_start}s 100%
    bbdebug 1 $(parted ${sdcard} print)
}

IMAGE_CMD_tfa-sdcard () {

    PART_START=$(create_sparse_file ${SDCARD_ROOTFS} ${SDCARD})

    partition_sparse_file ${SDCARD} ${PART_START}

    dd if=${DEPLOY_DIR_IMAGE}/atf/bl2_sd.pbl conv=notrunc,fsync of=${SDCARD} bs=512 seek=8

    dd if=${DEPLOY_DIR_IMAGE}/atf/fip_uboot.bin of=${SDCARD} conv=notrunc,fsync bs=512 seek=2048
    dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc,fsync seek=${PART_START} bs=512
}

IMAGE_TYPEDEP_tfa-sdcard_append = " ${@d.getVar('SDCARD_ROOTFS', 1).split('.')[-1]}"

IMAGE_CMD_sdcard_mpxs32g274a () {

    PART_START=$(create_sparse_file ${SDCARD_ROOTFS} ${SDCARD})

    partition_sparse_file ${SDCARD} ${PART_START}

    dd if=${DEPLOY_DIR_IMAGE}/${UBOOT_NAME_SDCARD} of=${SDCARD} conv=notrunc,fsync bs=256 seek=0 count=1
    dd if=${DEPLOY_DIR_IMAGE}/${UBOOT_NAME_SDCARD} of=${SDCARD} conv=notrunc,fsync bs=512 seek=1 skip=1
    dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc,fsync seek=${PART_START} bs=512
}

IMAGE_TYPEDEP_sdcard_mpxs32g274a_append = " ${@d.getVar('SDCARD_ROOTFS', 1).split('.')[-1]}"

IMAGE_CMD_qspi () {

    QSPIIMG="${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.qspi"

    IMG_SIZE=$(expr 3 \* 1024) # == 3MB

    dd if=/dev/zero of=${QSPIIMG} bs=1k count=0 seek=${IMG_SIZE}
    dd if=${DEPLOY_DIR_IMAGE}/${FLASHIMAGE_UBOOT_FILE} of=${QSPIIMG} conv=notrunc,fsync bs=512 seek=0
}
