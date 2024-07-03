#!/bin/bash

kdmx -p /dev/ttyUSB0 -b 115200 &

gdb-multiarch vmlinux -tui
# enter gdb and connect
# `set serial baud 115200`
# `target remote /dev/pts/9`
