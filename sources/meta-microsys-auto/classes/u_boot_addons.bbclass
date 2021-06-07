# Copyright (C) 2019-2020 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

def u_boot_env_dump(d, builddir, envbin_file):

    import sys
    import re
    import binascii

    bb.debug(2, "u_boot_env_dump(",builddir,",",envbin_file,")")

    u_boot_map = os.path.join(builddir, "u-boot.map")

    if not os.path.isfile(u_boot_map):
        bb.debug(1, "Error: %s: no such file!" % u_boot_map)
        return

    u_boot_bin = os.path.join(builddir, d.getVar("UBOOT_BINARY"))

    if not os.path.isfile(u_boot_bin):
        bb.error("Error: %s: no such file!" % u_boot_bin)
        return

    u_boot_cfg = os.path.join(builddir, "u-boot.cfg")

    if not os.path.isfile(u_boot_cfg):
        bb.error("Error: %s: no such file!" % u_boot_cfg)
        return

    image_env_offset = 0
    image_env_size = 0
    image_start = 0
    env_size = 0x2000
    env_offset = 0xffffffff

    last_line = ''
    with open(u_boot_map, "r") as map:
        for line in map:
            ln = re.findall(r"[^\.]default_environment", line)
            if ln:
                ln = line.strip().split()
                image_env_offset = int(ln[0], 16)
                if last_line:
                    ln = last_line.strip().split()
                    image_env_size = int(ln[1], 16)
            ln = re.findall(r"[^\.]__image_copy_start", line)
            if ln:
                ln = line.strip().split()
                image_start = int(ln[0], 16)
            last_line = line

    with open(u_boot_cfg, "r") as cfg:
        for line in cfg:
            ln = re.findall(r"^#define\s+CONFIG_ENV_SIZE", line)
            if ln:
                ln = line.strip().split()
                if ln[2][0] == '(': ln[2] = ln[2][1:]
                if ln[2][-1] == ')': ln[2] = ln[2][:-1]
                env_size = int(ln[2], 16)
            ln = re.findall(r"^#define\s+CONFIG_ENV_OFFSET", line)
            if ln:
                ln = line.strip().split()
                if ln[2][0] == '(': ln[2] = ln[2][1:]
                if ln[2][-1] == ')': ln[2] = ln[2][:-1]
                env_offset = int(ln[2], 16)
                d.setVar("UBOOT_ENV_OFFSET", str(env_offset))

    image_env_offset -= image_start

    env = b''
    crc32 = 0

    with open(u_boot_bin, "rb") as img:
        img.seek(image_env_offset)
        env = img.read(image_env_size)

    env = bytearray(env)

    while (len(env) < env_size-4):
        env.append(0)

    crc32 = binascii.crc32(bytes(env)) & 0xffffffff

    endian = bb.utils.contains('TUNE_FEATURES', 'bigendian', 'big', 'little', d)

    with open(envbin_file, "wb") as envbin:
        envbin.write((crc32).to_bytes(4, byteorder=endian))
        envbin.write(env)

    return 0

def do_u_boot_env_dump(d):

    b = d.getVar("B")

    machines = d.getVar("UBOOT_MACHINE").strip().split()
    configs = d.getVar("UBOOT_CONFIG").strip().split()

    if len(machines) < len(configs):
        print("Error: length of UBOOT_MACHINE is less than UBOOT_CONFIG!",
              file=sys.stderr)
        return

    uboot_envbin = d.getVar("UBOOT_ENVBIN")

    if not uboot_envbin: return 1

    for i in range(len(configs)):
        build = os.path.join(b, machines[i])
        u_boot_env_dump(d, build, os.path.join(build, uboot_envbin+"-"+configs[i]))

u_boot_addons_do_u_boot_envbin_compile() {
    RV=${@do_u_boot_env_dump(d)}
}

u_boot_addons_do_u_boot_envbin_install() {

    install -d ${D}/boot

    for m in ${UBOOT_MACHINE}; do
        install -m 0644 ${B}/${m}/${UBOOT_ENVBIN}-* ${D}/boot
    done
}

u_boot_addons_do_u_boot_envbin_deploy() {

    install -d ${DEPLOY_DIR_IMAGE}

    for m in ${UBOOT_MACHINE}; do
        install -m 0644 ${B}/${m}/${UBOOT_ENVBIN}-* ${DEPLOY_DIR_IMAGE}
    done
}

u_boot_addons_do_u_boot_envbin_clean() {

    for c in ${UBOOT_CONFIG}; do
        rm -f ${DEPLOY_DIR_IMAGE}/${UBOOT_ENVBIN}-${c}
    done
}

do_compile_append() {
    do_u_boot_envbin_compile
}

do_install_append() {
    do_u_boot_envbin_install
}

do_deploy_append() {
    do_u_boot_envbin_deploy
}

do_clean_append() {
    bb.build.exec_func("do_u_boot_envbin_clean", d)
}

EXPORT_FUNCTIONS do_u_boot_envbin_compile do_u_boot_envbin_install
EXPORT_FUNCTIONS do_u_boot_envbin_deploy do_u_boot_envbin_clean
