# ---------------------------------------------------------------
#     einfaches Makefile zum Uebersetzen und Linken von
#     STM8S Programmen mittels SDCC
# ---------------------------------------------------------------

# hier den Namen der Quelldatei ohne Endung ".c" angeben
SRC_NAME     =  dht11b_uart

# hier alle Dateien angeben, die hinzugelinkt werden sollen
# Objektdateien enden im Gegensatz zu GCC / AVR-GCC / ARM-NONE-EABI-GCC nicht mit .o sondern mit .rel
SRCS          = ../src/stm8_init.rel
SRCS         += ../src/uart.rel
#SRCS         += ../src/ssd1306.rel
SRCS         += ../src/my_printf.rel
SRCS         += ../src/dht11.rel

FLASHERPROG  = 0

include ../makefile.mk
