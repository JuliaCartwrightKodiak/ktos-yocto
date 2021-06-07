# Copyright (C) 2019 MicroSys Electronics GmbH, Author Kay Potthoff
# Author: Kay Potthoff <kay.potthoff@microsys.de>

SUMMARY = "Shell profiles"
DESCRIPTION = "Installs profiles for user root"
LICENSE = "CLOSED"

inherit allarch

FILES_${PN} += "${ROOT_HOME}/.bashrc"
FILES_${PN} += "${ROOT_HOME}/.profile"
FILES_${PN} += "${ROOT_HOME}/.xdg"

do_unpack[noexec] = "1"
do_fetch[noexec] = "1"
do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
  install -d ${D}${ROOT_HOME}
  install -d -m 0700 ${D}${ROOT_HOME}/.xdg

  echo "export XDG_RUNTIME_DIR=~/.xdg" > ${WORKDIR}/bashrc
  echo "alias ll='ls -lF --time-style=long-iso'" >> ${WORKDIR}/bashrc
  install -m 0644 ${WORKDIR}/bashrc ${D}${ROOT_HOME}/.bashrc

  echo "source ~/.bashrc" > ${WORKDIR}/profile
  install -m 0644 ${WORKDIR}/profile ${D}${ROOT_HOME}/.profile
}

do_clean() {
  for p in ${WORKDIR}/bashrc ${WORKDIR}/profile; do
    if [ -f ${p} ]; then rm -f ${p}; fi
  done
}
