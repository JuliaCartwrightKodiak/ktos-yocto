# Copyright (C) 2020 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
PATCH_COMMIT_FUNCTIONS = "1"

SRCREV = "469149903ab3ca644a944e0f6b203eb0ab2862ab"

python do_patch_prepend() {
    if d.getVar('PATCHTOOL') == 'git':
        srcsubdir = d.getVar('S')
        bb.process.run('git config am.threeWay true', cwd=srcsubdir)
        bb.process.run('git config am.keepcr true', cwd=srcsubdir)
        bb.process.run('git config apply.whitespace fix', cwd=srcsubdir)
        bb.process.run('git config apply.ignoreWhitespace change', cwd=srcsubdir)
}

PLATFORM ?= "${MACHINE}"

do_install[depends] += "u-boot-tools-native:do_populate_sysroot"

INSTALL_MOD_PATH = "${D}"
EXTRA_OEMAKE += 'INSTALL_MOD_PATH="${D}"'

do_install_append() {
    if [ -f "arch/${ARCH}/boot/Image" ]; then
        install -m 0644 arch/${ARCH}/boot/Image ${D}/boot/Image-${KERNEL_VERSION}
        ln -sf  Image-${KERNEL_VERSION} ${D}/boot/Image
    fi
    its_file=${S}/kernel-${PLATFORM}.its
    if [ ! -f ${its_file} ]; then
        its_file = ${S}/kernel-mpxls10xx.its
    fi
    default="            default = \"${ITS_DEVICETREE_CFG}\";"
    if [ -n "${ITS_DEVICETREE_CFG}" ]; then
        sed -e "s/^ *default *=.*$/${default}/g" ${its_file} > kernel-${PLATFORM}.its
    else
        cp ${its_file} kernel-${PLATFORM}.its
    fi
    mkimage -f kernel-${PLATFORM}.its fitImage.itb
    install -m 0644 fitImage.itb ${D}/boot/fitImage-${KERNEL_VERSION}.itb
    ln -sf fitImage-${KERNEL_VERSION}.itb ${D}/boot/fitImage.itb

    bbdebug 1 "Installing fitImage-${KERNEL_VERSION}.itb\n"
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 0644 ${D}/boot/fitImage-${KERNEL_VERSION}.itb ${DEPLOY_DIR_IMAGE}/fitImage-${KERNEL_VERSION}.itb
    ln -sf fitImage-${KERNEL_VERSION}.itb ${DEPLOY_DIR_IMAGE}/fitImage.itb
}

do_deploy_append() {
    bbdebug 1 "Deploying fitImage-${KERNEL_VERSION}.itb\n"
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 0644 ${D}/boot/fitImage-${KERNEL_VERSION}.itb ${DEPLOY_DIR_IMAGE}/fitImage-${KERNEL_VERSION}.itb
    ln -sf fitImage-${KERNEL_VERSION}.itb ${DEPLOY_DIR_IMAGE}/fitImage.itb
}

FILES_${KERNEL_PACKAGE_NAME}-image += "/boot/Image*"
FILES_${KERNEL_PACKAGE_NAME}-image-fitimage += "/boot/fitImage*"

PACKAGES += "${PN}-images"
FILES_${PN}-images += "/boot"
#COMPATIBLE_MACHINE = "(s32)"

FILES_${PN} += "/boot/fitImage*"

SRC_URI += "file://0001-s32g274asbc-added-configuration.patch;name=patch0001"
SRC_URI += "file://0002-s32g274acpcis-added-configuration.patch;name=patch0002"
SRC_URI += "file://0003-s32g274asbc2-added-configuration.patch;name=patch0003"
SRC_URI += "file://0004-s32g274a-added-make-of-devicetrees.patch;name=patch0004"
SRC_URI += "file://0005-gpio-fxl6408-added-driver.patch;name=patch0005"
SRC_URI += "file://0006-hwmon-lm90-added-IRQ-support.patch;name=patch0006"
SRC_URI += "file://0007-net-phy-fixed-IRQ-handling.patch;name=patch0007"
SRC_URI += "file://0008-phy-marvell10g-added-XGMII-support.patch;name=patch0008"
SRC_URI += "file://0009-phy-marvell-support-for-88E1548P-and-88Q2112.patch;name=patch0009"
SRC_URI += "file://0010-spi-nor-fsl-quadspi-fixed-build-issue.patch;name=patch0010"
SRC_URI += "file://0011-net-stmicro-check-for-MDIO-bus.patch;name=patch0011"
SRC_URI += "file://0012-localversion-update-to-4.1.patch;name=patch0012"
SRC_URI += "file://0013-dts-s32g274asbc2-configured-GPIO7-to-high.patch;name=patch0013"
SRC_URI += "file://0014-localversion-update-4.1.2.patch;name=patch0014"
SRC_URI += "file://0015-s32g274asbc-fixed-naming-in-ITS.patch;name=patch0015"
SRC_URI += "file://0016-dts-s32g274asbc-added-PFE1-pin-configuration.patch;name=patch0016"
SRC_URI += "file://0017-configs-s32g274asbc-updated-configuration.patch;name=patch0017"
SRC_URI += "file://0018-configs-s32g274asbc2-updated-configuration.patch;name=patch0018"
SRC_URI += "file://0019-localversion-update-4.1.3.patch;name=patch0019"

SRC_URI[patch0001.md5sum] = "811bbf84360bc5676c6df433e42a26ef"
SRC_URI[patch0002.md5sum] = "0c662585e28c9b83285fa1ebc78c4e71"
SRC_URI[patch0003.md5sum] = "c54ae1a2d9eb829d263c9bc31fbc1077"
SRC_URI[patch0004.md5sum] = "1faffd957b373bcd11dc01b9a6991b60"
SRC_URI[patch0005.md5sum] = "9797ad85c3e24a17ded0195d57f77156"
SRC_URI[patch0006.md5sum] = "e0e1ef810d59ebaf89dc3fcac5ec6392"
SRC_URI[patch0007.md5sum] = "40f1ab00b392c453c2b4f15edda41d90"
SRC_URI[patch0008.md5sum] = "932880eda07e1132a08c77d511c0373c"
SRC_URI[patch0009.md5sum] = "634533a923ee0d7cfecaba2fd64a89e1"
SRC_URI[patch0010.md5sum] = "46c1997805c6fdd252ac3bf9a98d37ef"
SRC_URI[patch0011.md5sum] = "f4777f060487ae462ca415811e8fd920"
SRC_URI[patch0012.md5sum] = "7e6ecdfeaf0e54f609c8e3ab409cf2b6"
SRC_URI[patch0013.md5sum] = "f5dfd4fe115e077d62fbb88073e18dc7"
SRC_URI[patch0014.md5sum] = "9590bef5d45ed9d61e7dbce5393e481d"
SRC_URI[patch0015.md5sum] = "709698f5edc349184679210766abd50f"
SRC_URI[patch0016.md5sum] = "d8d2eff31dd239f0147aa97d771a9636"
SRC_URI[patch0017.md5sum] = "e2fad8bc373cff8b347552b5d91557ec"
SRC_URI[patch0018.md5sum] = "fe624faaa79cd5726fed9b691bead945"
SRC_URI[patch0019.md5sum] = "5c9b8663fa5d90614d6edf445e89af0c"
