# Apple-2-Plus
This repository contains a system verilog and C (for the NIOS 2e) implementation of an Apple 2 plus system.

The system is composed of a clock generator, DRAM, ROM, video display, system bus, keyboard interface, sound driver, and emulated disk using the on-board SD card slot. It uses the NIOS II CPU to interface with a USB keyboard to take input. On startup, the hardware runs the bios which loads the system monitor prompt which can be redirected to a BASIC prompt using the input “Ctrl+B”. From the BASIC prompt, the user can load programs from the peripheral slots using the input “PR#6” which attempts to print data from peripheral 6 where the disc emulator is connected which ends up executing the program stored on the disk. Disk image selection is handled by the switches on the front of the FPGA.

A technical report of the Apple 2 plus with details about each System verilog module is provided at:
https://docs.google.com/document/d/1WMu4IS11twmCRbFr2ggmz9mQZFseY7czSIhU_vw9Kys/edit?usp=sharing


