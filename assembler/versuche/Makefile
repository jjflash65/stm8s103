###############################################################################
#   einfaches Makefile fuer Versuche mit naken_asm
#   Hier zu assemblierender Dateiname OHNE Anhang .asm eingeben
###############################################################################

PROJECT = stm8_vers_1


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

