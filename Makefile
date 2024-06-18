XPS15_ACPI_TABLES=DSDT.aml SSDT3.aml
XPS15_ACPI_SRC=${XPS15_ACPI_TABLES:.aml=.dsl}
OUTPUT=patched_acpi_xps15.cpio
KERNEL_TOP_DIR=kernel
KERNEL_FW_DIR=${KERNEL_TOP_DIR}/firmware/acpi

%.dsl:
	sudo iasl -p $@ -d /sys/firmware/acpi/tables/$(basename $@ .dsl)
	sudo chmod a+rw $@

.patched: ${XPS15_ACPI_SRC} xps15_acpi.patch
	patch -Np1 < xps15_acpi.patch
	touch $@

%.aml: %.dsl .patched
	iasl -sa $<

${OUTPUT}: ${XPS15_ACPI_TABLES}
	mkdir -p ${KERNEL_FW_DIR}
	cp $^ ${KERNEL_FW_DIR}/
	find ${KERNEL_TOP_DIR} | cpio -H newc --create > $@

all: .patched ${OUTPUT}

clean:
	rm -rf *.aml *.dsl *.asm .patched ${KERNEL_TOP_DIR} ${OUTPUT}
