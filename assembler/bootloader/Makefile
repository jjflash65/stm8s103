###############################################################################
#   einfaches Makefile fuer Versuche mit naken_asm
#   Hier zu kompilierender Dateiname OHNE Anhang .asm eingeben
###############################################################################

PROJECT     = bootloader_v04

FLASHERPROG = 0


DEVICE_NAME  = stm8s103s3


AS      = naken_asm


.PHONY: all flash clean


all:
	$(AS) -l -h -o $(PROJECT).ihx $(PROJECT).asm 1>&2

flash:
	stm8flash -c stlinkv2 -p $(DEVICE_NAME) -w $(PROJECT).ihx

clean:
	@rm  -f $(PROJECT).ihx
	@rm  -f $(PROJECT).lst

