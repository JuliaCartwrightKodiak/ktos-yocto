Copyright (C) 2020-2021 MicroSys Electronics GmbH

Release Notes for MPXS32G274A Modules
=====================================

Supported Platforms
-------------------

- S32G274ASBC2 with MPXS32G274A (Rev. 2) on carrier CRXS32G (Rev. 2)
- S32G274ACPCIS with MPXS32G274A on carrier CPCIs
- S32G274ASBC with MPXS32G274A on carrier CRXS32G

Limitations
===========

- PFE firmware can only be loaded from MMC
- S32G274ASBC2: GMAC0 not supported
- S32G274ASBC2: PFE0 with M.2 configuration not supported, as a consequence if this configuration
                is selected then there is no Ethernet connection from S32G274A to the SJA1110.
- S32G274ASBC2: No support for PCIe endpoint operation
- S32G274ASBC: PFE1, PFE2 not supported
- S32G274ASBC: PCIe operations of both slots (MiniPCIe and M.2) at the same time are not supported;
               PCIe in M.2 slot might work without guarantee
- Currently not supported in BSP28.0: S32G274ACPCIS

Change History
==============

V4.1.3: 2021-04-13
------------------

- BSP28.0: support for S32G274ASBC

V4.1.2: 2021-04-12
------------------

- Fixed standby mode of CAN tranceivers
  The CAN tranceivers are now out of sleep state and are functional.

V4.1.1: 2021-03-25
------------------

- Updated SJA1110 firmware images
  There are now two firmware images provided:
     - one for the M.2 configuration
     - one for the 2G5 configuration

V4.1: 2021-03-22
------------------

- Update to automotive BSP28.0
    - U-Boot 2020.04
    - Linux 5.4.69
    - Yocto 3.2.1 (gatesgarth)
    - PFE 0.9.3
    - LLCE 0.9.1
    - Firmware support for SJA1110 TSN switch
    - QSPI boot of U-Boot

V3.1.4: 2021-02-25
------------------

- Added platform S32G274ASBC2 with
     - MPXS32G274A Rev. 2
     - CRXS32G Rev. 2

V3.1.3: 2021-02-02
------------------

- Based on Automotive BSP27.0 from NXP
- U-Boot: added 64bit support for PCIe (patches from NXP)

V3.1.2: 2021-01-18
------------------

- Based on Automotive BSP27.0 from NXP
- U-Boot: PFE2: Fixed: Invalid operation mode - rgmii

V3.1.1: 2020-12-16
------------------

- Based on Automotive BSP27.0 from NXP
- Linux: fixed initialization of FXL6408 GPIO-expander.
  The initialization of the I/O-direction register is now the
  last action in the driver. This avoids glitches when switching
  an input pin to output.

V3.1: 2020-12-08
----------------

- Based on Automotive BSP27.0 from NXP:
    - U-Boot 2020.04
    - Linux 5.4
    - Yocto 3.0 (zeus)
    - PFE 0.9.2
    - Firmware support for SJA1110 TSN switch
    - QSPI boot of U-Boot

Note: when booting from QSPI and the PFE firmware should be loaded this can
only be done from MMC. The U-Boot environment variable 'pfengfw' has to be
set to point to the location:

`(U-Boot) => setenv pfengfw 'mmc@0:1:s32g_pfe_class.fw'`

V2.0: 2020-09-29
----------------

- Based on Automotive BSP26.0 from NXP:
    - U-Boot 2020.04
    - Linux 5.4
    - Yocto 3.0 (zeus)
    - PFE 0.9.0

V1.0: 2020-09-23
----------------

- Based on Automotive BSP25.2 from NXP:
    - U-Boot 2019.04
    - Linux 4.19
    - Yocto 3.0 (zeus)
    - PFE 0.8.0
- s32g274acpcis: Initial version
- s32g274asbc: Initial version
