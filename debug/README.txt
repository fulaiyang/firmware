usage:
    1、enter firmware dir and exc "make BUILDTARGET=DEBUG"
    2、exc "./startdebug.sh",start qemu and gdb connect and load ovmf symbols
    3、set the breakpoints,continue gdb
    4、create a new shell window, run "telnet 0.0.0.0 44444",then exc "system_reset" restart the vm

