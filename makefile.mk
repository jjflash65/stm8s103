# ---------------------------------------------------------------
#                           makefile.mk
#
#    gemeinsames Makefile fuer alle STM8-Projekte, wird von
#    den entsprechenden Makefiles der Projekte includiert
#
#    Die Makefiles der Projekte enthalten lediglich den
#    Quelldateinamen des Programms aus dem ein auf dem
#    STM8 lauffaehiges Programm generiert werden soll
#
#    August 2016    R. Seelig
#
# ---------------------------------------------------------------

# Pfad zu Include Dateien
INCLUDE_PATH = -I../include/

# Compilersymbole (defines)
CC_SYMBOLS   =-DF_CPU=16000000

# -----------------------------------------------------------------------------------------------------
#  hier endet das "User-Interface des Makefiles und es sollte  ab hier nur mit Bedacht Aenderungen
#  vorgenommen werden !!!
# -----------------------------------------------------------------------------------------------------

# Typename Flasherprogramm fuer den STLINK/V2
DEVICE_NAME  = stm8s103f3

# Pfad zu Bibliothekn
LIBSPEC      =-lstm8 -mstm8


OBJS         = $(SRC_NAME).rel $(ADD_LIBS)

CC_FLAGS     =--std-c99 --opt-code-size --disable-warning 197 --disable-warning 84 --disable-warning 185

CC = sdcc
LD = sdld

ADD_LIBS += $(SRCS)


.PHONY: all compile clean flash complete

all: $(OBJS)
	@echo "Linking $(SRC_NAME).c with libs, Intel-Hex-File: $(SRC_NAME).ihx"
	$(CC) $(LIBSPEC) $(INCLUDE_PATH) --out-fmt-ihx $(OBJS)
	@rm -f ../src/*.asm
	@rm -f ../src/*.rst
	@rm -f ../src/*.rel
	@rm -f ../src/*.sym
	@rm -f ../src/*.lst
	@rm -f ../src/*.map
	@rm -f ../src/*.cdb
	@rm -f ../src/*.lk
	@rm -f ../src/*.mem
	@echo "  " 1>&2
	@echo " ------ Programm build sucessfull -----" 1>&2
	@echo "  " 1>&2
	@../st8readihx $(SRC_NAME).ihx

compile:
	$(CC) $(LIBSPEC) $(CC_FLAGS) $(CC_SYMBOLS) $(INCLUDE_PATH) $(SRC_NAME).c -o $(SRC_NAME).rel

clean:
	@rm -f *.asm
	@rm -f *.rst
	@rm -f *.ihx
	@rm -f *.rel
	@rm -f *.sym
	@rm -f *.lst
	@rm -f *.map
	@rm -f *.cdb
	@rm -f *.lk
	@rm -f *.mem
	@rm -f ../src/*.asm
	@rm -f ../src/*.rst
	@rm -f ../src/*.rel
	@rm -f ../src/*.sym
	@rm -f ../src/*.lst
	@rm -f ../src/*.map
	@rm -f ../src/*.cdb
	@rm -f ../src/*.lk
	@rm -f ../src/*.mem
	@rm -f /usr/share/sdcc/lib/src/*.lst
	@rm -f /usr/share/sdcc/lib/src/*.rel
	@rm -f /usr/share/sdcc/lib/src/*.rst
	@rm -f /usr/share/sdcc/lib/src/*.sym

	@echo "Cleaning done..."

%.rel: %.c
	$(CC) $(LIBSPEC) $(CC_FLAGS) $(CC_SYMBOLS) $(INCLUDE_PATH) -c $< -o $@

flash:
ifeq ($(FLASHERPROG), 1)
	stm8_bootflash /dev/ttyUSB0 $(SRC_NAME).ihx notxbar
else
	../stm8flash -c stlinkv2 -p $(DEVICE_NAME) -w $(SRC_NAME).ihx
endif

complete: clean all flash
