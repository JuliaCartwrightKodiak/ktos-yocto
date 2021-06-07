# Copyright (C) 2020-2021 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SJA1110_UC_FW = "sja1110_rev2_m2_flash_image.bin"

SRC_URI += "file://${SJA1110_UC_FW}"
SRC_URI += "file://sja1110_flash_image_20201201.bin"
SRC_URI += "file://sja1110_rev2_2g5_flash_image.bin"

COMPATIBLE_MACHINE_append = "|s32g274asbc2|s32g274asbc|s32g274acpcis"

do_compile[depends] += "virtual/kernel:do_deploy"

module_do_install_append() {
    install -d ${D}/lib/firmware
    if [ -f "${WORKDIR}/${SJA1110_UC_FW}" ]; then
        cp -f ${WORKDIR}/${SJA1110_UC_FW} ${D}/lib/firmware/sja1110_uc.bin
    fi
    if [ -f "${WORKDIR}/${SJA1110_SWITCH_FW}" ]; then
        cp -f ${WORKDIR}/${SJA1110_SWITCH_FW} ${D}/lib/firmware/sja1110_switch.bin
    fi
    if [ -f "${WORKDIR}/sja1110_flash_image_20201201.bin" ]; then
        cp -f ${WORKDIR}/sja1110_flash_image_20201201.bin ${D}/lib/firmware/sja1110_uc_rev1.bin
    fi
    if [ -f "${WORKDIR}/sja1110_rev2_m2_flash_image.bin" ]; then
        cp -f ${WORKDIR}/sja1110_rev2_m2_flash_image.bin ${D}/lib/firmware/sja1110_uc_m2.bin
    fi
    if [ -f "${WORKDIR}/sja1110_rev2_2g5_flash_image.bin" ]; then
        cp -f ${WORKDIR}/sja1110_rev2_2g5_flash_image.bin ${D}/lib/firmware/sja1110_uc_2g5.bin
    fi
}
