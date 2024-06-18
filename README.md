# What is it?

This is a tool to create an initrd with fixed DSDT and SSDT3 ACPI tables for
Dell XPS 15 7590

XPS 15 7590 has two issues with its ACPI tables:

1) SSDT3 has `Stall(250)` call which violates ACPI spec resulting in Linux
complaining:

```dmesg
ACPI Warning: Time parameter 250 us > 100 us violating ACPI spec, please fix the firmware. (20230628/exsystem-141)
```

The fix is to replace `Stall(250)` with `Sleep(250)`

2) DSDT has missing symbol `\_SB.PCI0.PEG0.PEGP.BRT6.LCD` at least on models
with OLED screen, so if when you use the keys to increase/decrease screen
brightness, ACPI interpreter complains:

```dmesg
ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.PEG0.PEGP.BRT6.LCD], AE_NOT_FOUND (20230628/psargs-330)
ACPI Error: Aborting method \_SB.PCI0.PEG0.PEGP.BRT6 due to previous error (AE_NOT_FOUND) (20230628/psparse-529)
ACPI Error: Aborting method \EV5 due to previous error (AE_NOT_FOUND) (20230628/psparse-529)
ACPI Error: Aborting method \SMEE due to previous error (AE_NOT_FOUND) (20230628/psparse-529)
ACPI Error: Aborting method \SMIE due to previous error (AE_NOT_FOUND) (20230628/psparse-529)
ACPI Error: Aborting method \NEVT due to previous error (AE_NOT_FOUND) (20230628/psparse-529)
```

The fix is to skip calling `\_SB.PCI0.PEG0.PEGP.BRT6` method

# How to use

If you previously used the tool and booted with `patched_acpi_tables.cpio`
initrd, edit your bootloader configuration to disable it, since the tool needs
unpatched DSDT and SSDT3 tables.

Run `make all`, it will create `patched_acpi_tables.cpio` that can be used to
patch ACPI tables in Linux in runtime, just add it as the first initrd in your
bootloader config. Please refer to your bootloader documentation on how to do
so.

**Note**: it is important to rebuild `patched_acpi_tables.cpio` each time after
you update the BIOS.
