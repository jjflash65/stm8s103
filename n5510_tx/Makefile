# ---------------------------------------------------------------
#     einfaches Makefile zum Uebersetzen und Linken von
#     STM8S Programmen mittels SDCC
# ---------------------------------------------------------------

# hier den Namen der Quelldatei ohne Endung ".c" angeben
SRC_NAME     =  n5510_txdemo

# hier alle Dateien angeben, die hinzugelinkt werden sollen
# Objektdateien enden im Gegensatz zu GCC / AVR-GCC / ARM-NONE-EABI-GCC nicht mit .o sondern mit .rel
ADD_LIBS  = ../src/stm8_init.rel
ADD_LIBS += ../src/spi.rel
ADD_LIBS += ../src/stm8_nokia.rel
ADD_LIBS += ../src/my_printf.rel

include ../makefile.mk

