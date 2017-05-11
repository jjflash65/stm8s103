# ---------------------------------------------------------------
#     einfaches Makefile zum Uebersetzen und Linken von
#     STM8S Programmen mittels SDCC
# ---------------------------------------------------------------

# hier den Namen der Quelldatei ohne Endung ".c" angeben
SRC_NAME     =  rda5807_uart

# hier alle Dateien angeben, die hinzugelinkt werden sollen
# Objektdateien enden im Gegensatz zu GCC / AVR-GCC / ARM-NONE-EABI-GCC nicht mit .o sondern mit .rel
ADD_LIBS     = ../src/stm8_init.rel
ADD_LIBS    += ../src/sw_i2c.rel
ADD_LIBS    += ../src/uart.rel
ADD_LIBS    += ../src/my_printf.rel

include ../makefile.mk
