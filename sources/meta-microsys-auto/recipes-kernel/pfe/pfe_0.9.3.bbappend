# Copyright (C) 2020-2021 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

inherit microsys

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

NXP_FIRMWARE_LOCAL_DIR := "${THISDIR}/${PN}"

LIC_FILES_CHKSUM += "file://PFE-License.txt;md5=3efaacbb2298460a2345c5950a9ebb6a"

COMPATIBLE_MACHINE_append = "|mpxs32g274a"

do_compile[depends] += "virtual/kernel:do_deploy"

SRC_URI := "${@microsys_var_remove(d, 'SRC_URI', '.*\\bNXP_FIRMWARE_LOCAL_DIR\\b.*')}"

do_patch_append() {
    import os
    import shutil

    shutil.copy2(os.path.join(d.getVar("NXP_FIRMWARE_LOCAL_DIR"),
                              "PFE-License.txt"),
                 os.path.join(d.getVar("S"), "PFE-License.txt"))

    shutil.copy2(os.path.join(d.getVar("NXP_FIRMWARE_LOCAL_DIR"),
                              d.getVar("PFE_FW_CLASS_BIN")),
                 os.path.join(d.getVar("S"), d.getVar("FW_INSTALL_CLASS_NAME")))

    shutil.copy2(os.path.join(d.getVar("NXP_FIRMWARE_LOCAL_DIR"),
                              d.getVar("PFE_FW_UTIL_BIN")),
                 os.path.join(d.getVar("S"), d.getVar("FW_INSTALL_UTIL_NAME")))
}

module_do_install() {
    install -D ${MDIR}/pfeng.ko ${INSTALL_DIR}/pfeng.ko
    mkdir -p "${FW_INSTALL_DIR}"
    install -D "${NXP_FIRMWARE_LOCAL_DIR}/${PFE_FW_CLASS_BIN}" "${FW_INSTALL_DIR}/${FW_INSTALL_CLASS_NAME}"
    install -D "${NXP_FIRMWARE_LOCAL_DIR}/${PFE_FW_UTIL_BIN}" "${FW_INSTALL_DIR}/${FW_INSTALL_UTIL_NAME}"
}
