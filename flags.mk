#*****************************************************************
# Generated by Board2Make (https://github.com/luni64/Board2Make)
#
# Board              Teensy LC
# USB Type           Serial
# CPU Speed          48 MHz
# Optimize           Smallest Code
# Keyboard Layout    US English
#
# 29.08.2018 11:00
#*****************************************************************

BOARD_ID   := TEENSYLC

FLAGS_CPU  := -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant
FLAGS_OPT  := -O2 --specs=nosys.specs
FLAGS_COM  := -g -Wall -ffunction-sections -fdata-sections -nostdlib -MMD
FLAGS_LSP  := 

FLAGS_CPP  :=  -fno-exceptions -fpermissive -felide-constructors -std=gnu++14 -fno-rtti
FLAGS_C    := 
FLAGS_S    := -x assembler-with-cpp
FLAGS_LD   := -Wl,--gc-sections,--relax,--defsym=__rtc_localtime=0,-lstdc++
#--start-group

LIBS       := -larm_cortexM4lf_math -lm
LD_SCRIPT  := mk66fx1m0.ld

DEFINES    := -D__MK66FX1M0__ -DTEENSYDUINO=146 -DARDUINO=10809
DEFINES    += -DF_CPU=180000000 -DUSB_SERIAL -DLAYOUT_US_ENGLISH

CPP_FLAGS  := $(FLAGS_CPU) $(FLAGS_OPT) $(FLAGS_COM) $(DEFINES) $(FLAGS_CPP)
C_FLAGS    := $(FLAGS_CPU) $(FLAGS_OPT) $(FLAGS_COM) $(DEFINES) $(FLAGS_C)
S_FLAGS    := $(FLAGS_CPU) $(FLAGS_OPT) $(FLAGS_COM) $(DEFINES) $(FLAGS_S)
LD_FLAGS   := $(FLAGS_CPU) $(FLAGS_OPT) $(FLAGS_LSP) $(FLAGS_LD)
AR_FLAGS   := rcs
