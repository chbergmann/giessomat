###############################################################################
# Makefile for the project giessomat
###############################################################################

## General Flags
PROJECT = giessomat
MCU = atmega8
TARGET = giessomat.elf
CC = avr-gcc

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -O2 -fsigned-char
# -gdwarf-2
CFLAGS += -Wp,-M,-MP,-MT,$(*F).o,-MF,dep/$(@F).d 

## Assembly specific flags
ASMFLAGS = $(COMMON)
ASMFLAGS += -x assembler-with-cpp -Wa,-gdwarf2

## Linker flags
LDFLAGS = $(COMMON)
LDFLAGS += 


## Intel Hex file production flags
HEX_FLASH_FLAGS = -R .eeprom

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0


## Objects that must be built in order to link
OBJECTS = giessomat.o uart.o clock.o 

## Build
all: $(TARGET) giessomat.hex giessomat.eep
	avr-size giessomat.elf

## Compile
giessomat.o: giessomat.c main.h
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

uart.o: uart.c uart.h
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<
	
clock.o: clock.c clock.h
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<
		
##Link
$(TARGET): $(OBJECTS)
	 $(CC) $(LDFLAGS) $(OBJECTS) $(LIBDIRS) $(LIBS) -o $(TARGET)

%.hex: $(TARGET)
	avr-objcopy -O ihex $(HEX_FLASH_FLAGS)  $< $@

%.eep: $(TARGET)
	avr-objcopy $(HEX_EEPROM_FLAGS) -O ihex $< $@

%.lss: $(TARGET)
	avr-objdump -h -S $< > $@

#size: ${TARGET}
#	@echo
#	@sh avr-mem.sh ${TARGET} ${MCU}

## Clean target
.PHONY: clean
clean:
	-rm -rf $(OBJECTS) giessomat.elf dep/ giessomat.hex giessomat.eep

## Other dependencies
-include $(shell mkdir dep 2>/dev/null) $(wildcard dep/*)

#Programmer
download: giessomat.hex
	avrdude -p m8 -c pony-stk200 -U flash:w:giessomat.hex:i
	
upload:
	avrdude -p m8 -c pony-stk200 -U flash:r:backup.hex:i
	
