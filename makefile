###############################################################################
# This makefile was generated by the project wizard of VisualTeensy 
# Generation Time: 8/30/2017 6:24:47 PM
# 
#
# NOTE: VisualTeensy will not touch this makefile after generation. 
# It therefore is safe to manually apply any required changes to this file.  
###############################################################################

include flags.mk

#******************************************************************************
# PATHS and FILES
#******************************************************************************
TARGET_NAME     := vscode_test
LIB_PATHS       := Audio Audio\Utility SD SD\Utility SPI SerialFlash Wire 

# Make can not use folders with spaces in the name. Either use the old 8.3 naming scheme for the folder
# or copy the compiler and core files to some other place as shown below 
#ARDUINO_BASE	  := C:/Develop/_Tools/arduino-1.8.9
#ARDUINO_BASE	  := D:/Develop/_Tools/arduino-1.8.9

export ARDUINO_BASE

GCC_BASE 	 	    := $(ARDUINO_BASE)\hardware\tools\arm

CORE_BASE		    := $(ARDUINO_BASE)\hardware\teensy\avr\cores\teensy3
UPL_BASE_PJRC	  := $(ARDUINO_BASE)\hardware\tools

USR_SRC         := src
CORE_SRC        := $(CORE_BASE)

BIN             := bin
USR_BIN         := $(BIN)\src
CORE_BIN        := $(BIN)\core
CORE_LIB        := $(BIN)\core.a
TARGET_HEX      := $(BIN)\$(TARGET_NAME).hex
TARGET_ELF      := $(BIN)\$(TARGET_NAME).elf
TARGET_LST      := $(BIN)\$(TARGET_NAME).lst


#******************************************************************************
# BINARIES
#******************************************************************************
CC              := $(GCC_BASE)\bin\arm-none-eabi-gcc
CXX             := $(GCC_BASE)\bin\arm-none-eabi-g++
AR              := $(GCC_BASE)\bin\arm-none-eabi-gcc-ar
OBJCOPY         := $(GCC_BASE)\bin\arm-none-eabi-objcopy
SIZE            := $(GCC_BASE)\bin\arm-none-eabi-size
OBJDUMP         := $(GCC_BASE)\bin\arm-none-eabi-objdump
UPL_PJRC	      :="$(UPL_BASE_PJRC)\teensy_post_compile" -test -file=./$(TARGET_NAME) -path=$(BIN) -tools="$(UPL_BASE_PJRC)" -board=$(BOARD_ID) -reboot

#******************************************************************************
# Source and Include Files
#******************************************************************************
# Recursively create list of source and object files in USR_SRC and CORE_SRC 
# and corresponding subdirectories. 
# The function rwildcard is taken from http://stackoverflow.com/a/12959694)

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

#User Sources -----------------------------------------------------------------
USR_C_FILES     := $(call rwildcard,$(USR_SRC)/,*.c)
USR_CPP_FILES   := $(call rwildcard,$(USR_SRC)/,*.cpp)
USR_S_FILES     := $(call rwildcard,$(USR_SRC)/,*.S)
USR_OBJ         := $(USR_S_FILES:$(USR_SRC)/%.S=$(USR_BIN)/%.o) $(USR_C_FILES:$(USR_SRC)/%.c=$(USR_BIN)/%.o) $(USR_CPP_FILES:$(USR_SRC)/%.cpp=$(USR_BIN)/%.o) 

# Core library sources -------------------------------------------------------- 
CORE_CPP_FILES  := $(call rwildcard,$(CORE_SRC)/,*.cpp)
CORE_S_FILES    := $(call rwildcard,$(CORE_SRC)/,*.S)
CORE_C_FILES    := $(call rwildcard,$(CORE_SRC)/,*.c)
CORE_OBJ        := $(CORE_S_FILES:$(CORE_SRC)/%.S=$(CORE_BIN)/%.o) $(CORE_C_FILES:$(CORE_SRC)/%.c=$(CORE_BIN)/%.o) $(CORE_CPP_FILES:$(CORE_SRC)/%.cpp=$(CORE_BIN)/%.o) 

LIB_INC_PARAMS  := $(foreach d, $(LIB_PATHS), -I$(USR_SRC)/$d)
INCLUDE         := -I.\$(USR_SRC) -I$(CORE_SRC) $(LIB_INC_PARAMS) -I.\$(USR_SRC)\mctl_lib\src 

#******************************************************************************
# Rules:
#******************************************************************************
.PHONY: build rebuild upload clean cleanUser cleanCore 

all:     $(TARGET_HEX)
rebuild: cleanUser all
clean:   cleanUser cleanCore

upload:
	@$(UPL_PJRC)
	
# Core library ----------------------------------------------------------------
$(CORE_BIN)/%.o: $(CORE_SRC)/%.S
	@echo [ASM]	CORE $(notdir $<)
	@if not exist $(dir $@)  @mkdir "$(dir $@)"
	@"$(CC)" $(S_FLAGS) $(INCLUDE) -o $@ -c $< 

$(CORE_BIN)/%.o: $(CORE_SRC)/%.c
	@echo [CC]  CORE $(notdir $<)
	@if not exist $(dir $@)  @mkdir "$(dir $@)"
	@"$(CC)" $(C_FLAGS) $(INCLUDE) -o $@ -c $< 

$(CORE_BIN)/%.o: $(CORE_SRC)/%.cpp
	@echo [CPP] CORE $(notdir $<)
	@if not exist $(dir $@)  @mkdir "$(dir $@)"
	@"$(CXX)" $(CPP_FLAGS) $(INCLUDE) -o $@ -c $< 

$(CORE_LIB) : $(CORE_OBJ)
	@echo [AR]  $@
	@$(AR) $(AR_FLAGS) $@ $^
	@echo Teensy core built successfully &&echo.

# Handle user sources ---------------------------------------------------------
$(USR_BIN)/%.o: $(USR_SRC)/%.S
	@echo [ASM] $<
	@if not exist $(dir $@)  @mkdir "$(dir $@)"
	@"$(CC)" $(S_FLAGS) $(INCLUDE) -o $@ -c $<

$(USR_BIN)/%.o: $(USR_SRC)/%.c
	@echo [CC]  $(notdir $<)
	@if not exist $(dir $@)  @mkdir "$(dir $@)"
	@"$(CC)" $(C_FLAGS) $(INCLUDE) -o "$@" -c $<

$(USR_BIN)/%.o: $(USR_SRC)/%.cpp
	@echo [CPP] $<
	@if not exist $(dir $@)  @mkdir "$(dir $@)"
	@"$(CXX)" $(CPP_FLAGS) $(INCLUDE) -o "$@" -c $<


# Linking ---------------------------------------------------------------
$(TARGET_ELF): $(CORE_LIB) $(USR_OBJ) 
	@echo [LD]  $@
	@$(CC) $(LD_FLAGS) -T$(CORE_SRC)/$(LD_SCRIPT) -o "$@" $(USR_OBJ) $(CORE_LIB) $(LIBS)
	@$(OBJDUMP) -d -S --demangle --no-show-raw-insn --syms $@  > "$(@:.elf=.lst)"
	@echo User code built successfully &&echo.

%.hex: %.elf
	@echo [HEX] $@
	@$(SIZE) "$<"
	@$(OBJCOPY) -O ihex -R .eeprom "$<" "$@"

# compiler generated dependency info
 -include $(CORE_OBJ:.o=.d)
 -include $(USR_OBJ:.o=.d)


# Cleaning --------------------------------------------------------------------
cleanUser:
	@echo Cleaning user binaries...
	@if exist $(USR_BIN) rd "$(USR_BIN)" /s /q
	@if exist $(TARGET_HEX) del  $(TARGET_HEX)
	@if exist $(TARGET_ELF) del  $(TARGET_ELF)
	@if exist $(TARGET_LST) del  $(TARGET_LST)	

cleanCore:
	@echo Cleaning core binaries...
	@if exist $(CORE_BIN) rd /s/q "$(CORE_BIN)"
	@if exist $(CORE_LIB) del  "$(CORE_LIB)"
