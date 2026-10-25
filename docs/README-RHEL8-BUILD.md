# GorillasEX Linux ELF64 build — Docker / RHEL 8 ABI

Copy `docker/` and `Build-Linux-RHEL8.bat` to the GorillasEX project root.

Run `Build-Linux-RHEL8.bat` from Windows 11 with Docker Desktop running in Linux container mode. First run builds the **builder image** (QB64-PE v4.6.0); later runs reuse it and start a disposable container (`--rm`). Output is `bin/GorillasEX-linux-x86_64` and `.sha256`. The container does not run the game.

Based on Rocky Linux 8, with a RHEL 8-generation glibc and system dependencies. Linux target compatibility is **not guaranteed until the binary has been checked on RHEL 8**. Runtime system libraries (X11/OpenGL/audio) may be required.

## Notes / possible adaptations

- Building QB64-PE from tagged repository source may require dependencies not included in the initial `dnf install`; review logs and extend image if needed. No actual Docker compile has been performed in the assistant environment.
- Ensure the current BASIC source contains no Windows-only native API calls or unguarded Windows-only directives. Linux-specific conditional compilation may be needed.
- The game's load paths for PNG/JSON/config must also be tested when running from `bin`.
- On first build, the image is assembled using `make OS=lnx BITS=64 BUILD_QB64=y`, not `setup_lnx.sh` (which refuses root).
- To force rebuild of the toolchain image: `docker image rm gorillasex-builder:rhel8-qb64pe-4.6.0` and rerun the BAT.
- Inspect dependencies on an RHEL8 machine: `ldd ./GorillasEX-linux-x86_64`.
- For greater compatibility confidence, inspect required glibc symbols: `objdump -T bin/GorillasEX-linux-x86_64 | grep GLIBC_` within a Linux environment.
