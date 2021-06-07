Copyright (C) 2020-2021 MicroSys Electronics GmbH

Yocto Build Setup
=================

This text describes how to setup a Yocto build environment for
the s32g274asbc2 board.

Download and clone NXP's Yocto Repository
-----------------------------------------

    1. Create and go to a directory of your choice

    2. Install 'repo' if not already done:

       # curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
       # chmod a+x /usr/local/bin/repo

    3. Execute the following commands:

       # repo init -u https://source.codeaurora.org/external/autobsps32/auto_yocto_bsp -b release/bsp28.0
       # repo sync --force-sync --no-clone-bundle

       After executing these two commands you should have a directory called sources/
       and a script called nxp-setup-alb.sh in your current directory.

Install MicroSys' Layer for S32G
--------------------------------

    1. Go to the directory sources/ and copy or unpack the layer
       'meta-microsys-auto' there. You should then have a directory
       with the layer name in sources/

    2. Source the script nxp-setup-alb.sh:

       # . nxp-setup-alb.sh -e meta-microsys-auto -m s32g274asbc2 -D microsys-auto

       You are now ready for starting to build the s32g274asbc2 image.

    3. Start the build for the image 'microsys-image-auto':

       # bitbake microsys-image-auto

Program QSPI Flash with U-Boot
------------------------------

    1. Boot from SD-card into the U-Boot prompt

    2. Load the QSPI build of U-Boot from SD-card:

       => ext4load mmc 0:1 $loadaddr boot/u-boot-s32g274asbc2.s32-qspi

    3. Probe the QSPI flash:

       => sf probe 6:0

    4. Update QSPI flash with U-Boot image:

       => sf update $loadaddr 0 $filesize

    5. Set DIP-switch 1-on. This is the DIP-switch close to the reset
       button on CRX-S32G and CPCIs-S32G with 4 switches.

Notes for Software Developers
=============================

Create Your Own Layer <span id="create-layer"/>
-----------------------------------------------

Before you start modifying recipes it is the best when you create your own layer which
is supposed to contain your changes.

    1. If not already done go to the build directory of the machine and call:

       # . SOURCE_THIS

       This configures and starts bitbake.

    2. Go to the sources/ directory and create your layer there:

       # bitbake-layers create-layer --priority 20 meta-mylayer

       Note 1: because the priority of meta-microsys-auto is 10, it is recommended
       to choose a higher number as priority for your own layer (but less than 99).

       Note 2: it is a good practice to prefix the layer name with "meta-".

       Note 3: this is an optional step. You can remove the directory
       recipes-example in the directory meta-mylayer/.

    3. Go to the build directory of the machine and add your new layer with:

       # bitbake-layers add-layer ../sources/meta-mylayer

Now you are ready for modifying sources.

Modifying U-Boot
----------------

You can modify the sources of U-Boot using the Yocto tool devtool. This task assumes that you have
created your own layer as described in the section [Create Your Own Layer](#create-layer).

    1. If not already done go to the build directory of the machine and call:

       # . SOURCE_THIS

       This configures and starts bitbake.

    2. Call devtool with the recipe for U-Boot as argument:

       # devtool modify u-boot-s32

       This creates a layer called "workspace" which contains the U-Boot
       sources as a GIT-repository. The sources can be found in the directory
       workspace/sources/u-boot-s32.

       Note: if you have done this step before, for example from a previous
       modification, then you have to call:

           # devtool modify --no-extract u-boot-s32

       with the additional option '--no-extract'. In this case devtool expects that
       the source tree already exists.

    3. Modify the sources with your favourite editor.
       Build your U-Boot with:

       # devtool build u-boot-s32

       You can find the results in workspace/sources/u-boot-s32/oe-workdir/image/boot.
       The resulting U-Boot images are:

           - u-boot.s32-sdcard
           - u-boot.s32-qspi

       If you now want to test your new U-Boot you can create a new boot image with:

       # devtool build-image microsys-image-auto

       You can find the output files in tmp/deploy/images/s32g274asbc2.

    4. Once you're done with your changes finish your work

       - go to workspace/sources/u-boot-s32 and commit your changes using 'git'

       - Update the recipe with:

           # devtool finish u-boot-s32 meta-mylayer

       If you plan to make more modifications to U-Boot it's better not to delete
       the source tree from the 'workspace' directory. Keep it.

    5. Now you can rebuild your image including your changes with:

       # bitbake microsys-image-auto

Generating the Cross-Toolchain
------------------------------

For cross-development on the host you can generate and install a cross-toolchain
using Yocto build environment.

    # bitbake -c populate_sdk microsys-image-auto

This generates a self-extractor (shar) in the directory tmp/deploy/sdk called
`microsys-auto-glibc-x86_64-aarch64-toolchain-<version>.sh` which can be installed on your host.
