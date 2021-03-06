# Copyright (C) 2020-2021 MicroSys Electronics GmbH

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
PATCH_COMMIT_FUNCTIONS = "1"

SRCREV = "eef88755a719c802f9dbfceaa06190abb96e74d1"

inherit u_boot_addons

python do_patch_prepend() {
    if d.getVar('PATCHTOOL') == 'git':
        srcsubdir = d.getVar('S')
        bb.process.run('git config am.threeWay true', cwd=srcsubdir)
        bb.process.run('git config am.keepcr true', cwd=srcsubdir)
        bb.process.run('git config apply.whitespace fix', cwd=srcsubdir)
        bb.process.run('git config apply.ignoreWhitespace change', cwd=srcsubdir)
}

SRC_URI += "file://0001-mpxs32g274a-added-module-support.patch;name=patch0001"
SRC_URI += "file://0002-s32g274asbc-added-support-for-S32G274ASBC.patch;name=patch0002"
SRC_URI += "file://0003-s32g274acpcis-added-support-for-S32G274ACPCIS.patch;name=patch0003"
SRC_URI += "file://0004-s32g274asbc2-added-support-for-S32G274ASBC2.patch;name=patch0004"
SRC_URI += "file://0005-bsp28-support-for-S32G274ASBC-S32G274ASBC2-and-S32G2.patch;name=patch0005"
SRC_URI += "file://0006-gpio-fxl6408-added-driver.patch;name=patch0006"
SRC_URI += "file://0007-env-eeprom-fixed-support-for-environment-in-I2C-EEPR.patch;name=patch0007"
SRC_URI += "file://0008-net-phy-fixed-PHY-detection.patch;name=patch0008"
SRC_URI += "file://0009-phy-marvell-update-to-latest-version.patch;name=patch0009"
SRC_URI += "file://0010-localversion-update-to-version-4.1.patch;name=patch0010"
SRC_URI += "file://0011-dts-fsl-s32g274a-added-SerDes-clocks.patch;name=patch0011"
SRC_URI += "file://0012-s32g274asbc2-added-SJA1110-configuration.patch;name=patch0012"
SRC_URI += "file://0013-localversion-updated-to-4.1.1.patch;name=patch0013"
SRC_URI += "file://0014-mpxs32g274a-added-M2-as-configuration-option.patch;name=patch0014"
SRC_URI += "file://0015-dts-s32g274asbc2-configured-GPIO7-to-high.patch;name=patch0015"
SRC_URI += "file://0016-localversion-update-4.1.2.patch;name=patch0016"
SRC_URI += "file://0017-dts-s32g274asbc2-removed-unused-pins.patch;name=patch0017"
SRC_URI += "file://0018-i2c-mxc_i2c-added-delay-until-clock-is-stable.patch;name=patch0018"
SRC_URI += "file://0019-localversion-update-4.1.3.patch;name=patch0019"
SRC_URI += "file://0020-i2c-mxc_i2c-increased-delay.patch;name=patch0020"
SRC_URI += "file://0021-mpxs32g274a-added-delay-in-early-init.patch;name=patch0021"
SRC_URI += "file://0022-localversion-update-4.1.4.patch;name=patch0022"
SRC_URI += "file://0023-mpxs32g274a-removed-delay.patch;name=patch0023"
SRC_URI += "file://0024-i2c-mxc_i2c.c-removed-delay.patch;name=patch0024"
SRC_URI += "file://0025-s32g274asbc2-Kconfig-fixed-SYS_DATA_BASE.patch;name=patch0025"
SRC_URI += "file://0026-configs-s32g274asbc.h-fixed-boot-flow-configuration.patch;name=patch0026"
SRC_URI += "file://0027-configs-s32g274asbc2-added-ATF-configuration.patch;name=patch0027"
SRC_URI += "file://0028-s32g274a-fix-for-QSPI-on-rev.-1.patch;name=patch0028"
SRC_URI += "file://0029-mpxs32g274a-fixes-for-boot-with-ATF.patch;name=patch0029"
SRC_URI += "file://0030-dts-s32g274asbc2-removed-obsolete-compatible.patch;name=patch0030"
SRC_URI += "file://0031-mpxs32g274a-added-misc_init_f-hook.patch;name=patch0031"
SRC_URI += "file://0032-dts-fsl-s32g274a.dtsi-fixed-clocks-for-SBC2.patch;name=patch0032"
SRC_URI += "file://0033-mpxs32g274a-fixed-DIP-switch-handling.patch;name=patch0033"
SRC_URI += "file://0034-drivers-pfeng_cmd.c-added-defines-for-SBC-rev.-1.patch;name=patch0034"
SRC_URI += "file://0035-s32g274asbc-fixed-support-for-BSP28.0.patch;name=patch0035"
SRC_URI += "file://0036-localversion-updated-to-version-4.1.5.patch;name=patch0036"
SRC_URI += "file://0037-configs-s32g274asbc-updated-QSPI-configuration.patch;name=patch0037"
SRC_URI += "file://0038-s32g274asbc2-removed-include.patch;name=patch0038"

SRC_URI[patch0001.md5sum] = "9d664614c6b70c20a1ddcac739909d00"
SRC_URI[patch0002.md5sum] = "b1f91fe12f0098a73ac04e256975406e"
SRC_URI[patch0003.md5sum] = "eb265b8ce9722033460d5acb72752f01"
SRC_URI[patch0004.md5sum] = "9a3db18950bfb4c2db903e3e5b0c38a6"
SRC_URI[patch0005.md5sum] = "2249e0c5d5e85782c502d263b8c72bb7"
SRC_URI[patch0006.md5sum] = "293bd404fde5f5dc0b413d78839c95f4"
SRC_URI[patch0007.md5sum] = "3d4c7b491d842f3627c8297c8b047b87"
SRC_URI[patch0008.md5sum] = "0807dcb0e586082f4a3a1f51ef45e63f"
SRC_URI[patch0009.md5sum] = "7c5c54d29278fb69ac572d54cd56ed07"
SRC_URI[patch0010.md5sum] = "a7735426cd2c90823d8a0e19708c234f"
SRC_URI[patch0011.md5sum] = "b0bdaa9c0b66deaebc32662730eabe09"
SRC_URI[patch0012.md5sum] = "df3b222ef25e327def0b8ecc4962e409"
SRC_URI[patch0013.md5sum] = "2d00baf47aaf95a8ded77a0810236529"
SRC_URI[patch0014.md5sum] = "bcdec0860e44871102f7dcfddf2d2321"
SRC_URI[patch0015.md5sum] = "a8536a7301e74a76000ae1acf0199795"
SRC_URI[patch0016.md5sum] = "53b08b43802678a4ef15a0e1176b8cf2"
SRC_URI[patch0017.md5sum] = "5975e4507fe42822a22d7e28f83e4ea3"
SRC_URI[patch0018.md5sum] = "f8f24e448988e13ce94c4f952c7b9d7d"
SRC_URI[patch0019.md5sum] = "c9787970a6e58f25b6f1c2623de56283"
SRC_URI[patch0020.md5sum] = "58f354161c00a11c177d93b8db76af0d"
SRC_URI[patch0021.md5sum] = "43434733f57931d2b5bc42c0f5ed07c4"
SRC_URI[patch0022.md5sum] = "a3d005d84296d2d2967e4bb93181e679"
SRC_URI[patch0023.md5sum] = "35467b8da8392736712bb998f973cafc"
SRC_URI[patch0024.md5sum] = "a445cf5f899c82ecc6182c5d8cff75bd"
SRC_URI[patch0025.md5sum] = "f43299de2f2ed3b67a3eb4536e27041c"
SRC_URI[patch0026.md5sum] = "7cac6137a32b7435d2797e11e4fe068f"
SRC_URI[patch0027.md5sum] = "46b7db5d5d8f6197084a3b8ba3ae3f3b"
SRC_URI[patch0028.md5sum] = "6ec92fcf1949a0ecb2f67999440a74ee"
SRC_URI[patch0029.md5sum] = "bcd77d99ba58a436e7e361d802fdc8d2"
SRC_URI[patch0030.md5sum] = "e7c2e82a55939b2c07aa3d3c44cc6a85"
SRC_URI[patch0031.md5sum] = "93dba28cb80870bb88b8816c0e4f5ac6"
SRC_URI[patch0032.md5sum] = "fa2dce970e063faba87d63c03713f63b"
SRC_URI[patch0033.md5sum] = "3b281993bee7e3b6f91f766a645b27fe"
SRC_URI[patch0034.md5sum] = "0cca626dd0dbf60dd2c22934cfe23962"
SRC_URI[patch0035.md5sum] = "44686aca0a04049dd8ba16d3527c5566"
SRC_URI[patch0036.md5sum] = "b13c5056de6c5c378f30a8ec57eca46d"
SRC_URI[patch0037.md5sum] = "5a3747f634f93edf196340cb411940cf"
SRC_URI[patch0038.md5sum] = "74aa3ba82d338021e675ccd620239b7a"
