###############################################################################
#   Hier zu kompilierender Dateiname OHNE Anhang .c eingeben
###############################################################################
PROJECT = bmp2stm8h

###############################################################################
#   alle benoetigten .o (Objekt)Dateien die zusammengelinkt werden sollen
###############################################################################
OBJECTS = ./bmp2stm8h.o

###############################################################################
#   hinzuzulinkende Modulde
#
#   1 = Modul ist verfuegbar, 0 = nicht verfuegbar
#
#       MATH      Funktionen von math.h werden mit eingebunden ( -lm )
#       NCURSES   Funktionen der NCurses Bibliothek (-lncurses -lpanel -lmenu )
#       SDL       Funktionen der SimpleDirectLayer Library (Grafik) Bibliothek
#                 ( -lSDL -lSDL_image )
#
###############################################################################
MATH     = 0
NCURSES  = 0
SDL      = 0

###############################################################################
#   Suchpfad nach .h Dateien
###############################################################################
INCLUDE_PATHS = -I.                      \
                -I../include

###############################################################################
#   Library - Pfade
###############################################################################
LIBRARY_PATHS =
LIBRARIES =

###############################################################################
#       zu verwendende Compiler / Assembler / Linker
###############################################################################
AS      = as
CC      = gcc
CPP     = g++
LD      = gcc


CC_FLAGS = -c -Os

###############################################################################
#       Symbole, die im Quelltext ein #define Name waeren und in 
#       allen zu uebersetzenden Dateien gueltig sind
###############################################################################
CC_SYMBOLS = -Djjflash
LD_FLAGS = -lc -lgcc

ifeq ($(MATH), 1)
  LD_FLAGS += -lm
endif

ifeq ($(NCURSES), 1)
  LD_FLAGS += -lncurses -lpanel -lmenu
endif

ifeq ($(SDL), 1)
  LD_FLAGS += -lSDL -lSDL_image
endif

.PHONY: all compile clean

all: $(PROJECT)

compile:
	$(CC) $(CC_FLAGS) $(CC_SYMBOLS) -std=c99 $(INCLUDE_PATHS) -o $(PROJECT).o $(PROJECT).c


clean:
	rm -f $(PROJECT).o $(PROJECT)


$(PROJECT): $(OBJECTS)
	$(LD) $(LD_FLAGS) $(LIBRARY_PATHS) -o $@ $^ $(LIBRARIES)
