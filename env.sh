#!/usr/bin/env bash

export PATH=$PATH:$PWD/scripts

export EULA=yes

branch=release/bsp28.0
upstream=https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp

layers=(meta-microsys-auto meta-ktos)
machine=s32g274asbc
distro=microsys-auto

repo init -u "$upstream" -b "$branch"
repo sync --force-sync --no-clone-bundle

source nxp-setup-alb.sh -e "${layers[@]}" -m "$machine" -D "$distro"
