# Copyright (C) 2020-2021 MicroSys Electronics GmbH
# Author: Kay Potthoff <kay.potthoff@microsys.de>

def microsys_get_rcw_machine(d):
    import re

    machine = d.getVar('MACHINE').replace('-64b','').replace('-32b','').replace('-${SITEINFO_ENDIANNESS}','')

    m = re.match(r"\bmpxls1046adxcirrus\b", machine)
    if m: return "mpxls1046"

    m = re.match(r"(mpxl(s|x)\d+a?).*", machine)
    if m: return m[1]

    m = re.match(r"(comels\d+a).*", machine)
    if m: return m[1]

    return machine

def microsys_get_its_file(d):
    import os

    source = d.getVar('S')
    platform = d.getVar('PLATFORM')

    its_file = source + "/kernel-" + platform + ".its"

    if os.path.isfile(its_file):
        return its_file

    if platform.startswith('comels1046a'):
        return source + "/kernel-comels1046a.its"

    return source + "/kernel-mpxls10xx.its"

def microsys_get_atf_platform(d):

    machine = d.getVar('MACHINE')

    if machine == "comels1046aritec":
        machine = "comels1046a_ram_4gb_ritec"

    return machine

def microsys_get_image_fstypes(d):

    fstypes = "tar.gz ext4"

    machine = d.getVar('MACHINE')

    if machine.startswith("comels1046a"):
        fstypes += " tfa-qspi jffs2 tfa-sdcard"
    elif machine.startswith("mpxls1046"):
        fstypes += " tfa-qspi jffs2 tfa-sdcard"
    elif machine.startswith("mpxl"):
        fstypes += " tfa-qspi jffs2 tfa-sdcard"

    return fstypes

def microsys_var_remove(d, var, vexpr, _expand=False):
    import re
    v = d.getVar(var, expand=_expand)
    vlist = v.split()
    p = re.compile(vexpr)
    return " ".join([x for x in vlist if not p.match(x)])

EXPORT_FUNCTIONS microsys_get_rcw_machine microsys_get_its_file microsys_get_atf_platform
EXPORT_FUNCTIONS microsys_get_image_fstypes microsys_var_remove
