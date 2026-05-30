# Multi-Stage x86 BIOS Bootloader

A multi-stage bootloader written in x86 Assembly (NASM) that demonstrates BIOS booting, disk sector loading, interactive shell commands, and kernel handoff. The project is developed and tested using QEMU.

## Features

* BIOS-compatible boot sector
* Multi-stage bootloader architecture
* Interactive shell environment
* Command parsing and keyboard input handling
* Shell commands:

  * `help`
  * `clear`
  * `echo`
* Tiny kernel environment
* Kernel commands:

  * `help`
  * `info`
  * `clear`
  * `reboot`
* Disk sector loading using BIOS interrupt `0x13`
* Screen output using BIOS interrupt `0x10`
* Keyboard input using BIOS interrupt `0x16`

## Architecture

```text
BIOS
 ↓
Stage 1 Bootloader
 ├─ Shell
 │    ├─ help
 │    ├─ clear
 │    └─ echo
 │
 └─ Kernel
      ├─ help
      ├─ info
      ├─ clear
      └─ reboot
```

## Project Structure

```text
bootloader-project/
│
├── boot/
│   ├── boot.asm
│   ├── shell.asm
│   └── kernel.asm
│
├── build/
│
├── Makefile
├── README.md
└── .gitignore
```

## Building

```bash
make
```

## Running

```bash
make run
```

## Cleaning

```bash
make clean
```

## Commands

### Shell

```text
help
echo hello
clear
```

### Kernel

```text
help
info
clear
reboot
```

## Learning Outcomes

This project helped develop an understanding of:

* x86 real-mode programming
* BIOS interrupts
* Boot sectors and boot signatures
* Memory addressing
* Disk sector loading
* Command parsing
* Multi-stage bootloader design
* Kernel handoff mechanisms

## Future Improvements

* Protected mode support
* C-based kernel
* Memory map detection
* Simple filesystem support
* Basic process management
