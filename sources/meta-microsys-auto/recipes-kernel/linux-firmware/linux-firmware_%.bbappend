# Copyright (C) 2021 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

inherit microsys

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE_append = "|mpxs32g274a"

NXP_FIRMWARE_LOCAL_DIR := "${THISDIR}/${PN}"

LIC_FILES_CHKSUM := "file://LLCE-License.txt;md5=3efaacbb2298460a2345c5950a9ebb6a"

SRC_URI := "file://LLCE-License.txt"

do_populate_lic_prepend() {
    import os
    import shutil

    shutil.copy2(os.path.join(d.getVar("NXP_FIRMWARE_LOCAL_DIR"),
                              "LLCE-License.txt"),
                 os.path.join(d.getVar("S"), "LLCE-License.txt"))
}

do_install_prepend() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'llce-can', 'true', 'false', d)}; then
       mkdir -p ${D}/lib/firmware
       install -m 0644 ${NXP_FIRMWARE_LOCAL_DIR}/dte.bin ${D}/lib/firmware/dte.bin
       install -m 0644 ${NXP_FIRMWARE_LOCAL_DIR}/frpe.bin ${D}/lib/firmware/frpe.bin
       install -m 0644 ${NXP_FIRMWARE_LOCAL_DIR}/ppe_tx.bin ${D}/lib/firmware/ppe_tx.bin
       install -m 0644 ${NXP_FIRMWARE_LOCAL_DIR}/ppe_rx.bin ${D}/lib/firmware/ppe_rx.bin
    fi
    exit 0
}
