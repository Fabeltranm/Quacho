# ----------------------------------------------------------------------------
#         ATMEL Microcontroller Software Support 
# ----------------------------------------------------------------------------
# Copyright (c) 2010, Atmel Corporation
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice,
# this list of conditions and the disclaimer below.
#
# Atmel's name may not be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# DISCLAIMER: THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
# DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ----------------------------------------------------------------------------

# Makefile for compiling libchip
.SUFFIXES: .o .a .c .s
SUB_MAKEFILES=debug.mk gcc.mk iar.mk mdk.mk release.mk win.mk linux.mk atsam3s.mk

LIBNAME=libchip
TOOLCHAIN=gcc

ifeq ($(CHIP),)
$(error CHIP not defined)
endif

#-------------------------------------------------------------------------------
# we detect OS (Linux/Windows/Cygwin)
# not defined for Cygwin
#ifdef $(OS)
ifeq ($(OS), Windows_NT)
include win.mk
else
include linux.mk
endif
#else
## Cygwin case
#include linux.mk
#endif

#-------------------------------------------------------------------------------
# Path
#-------------------------------------------------------------------------------

# Output directories
OUTPUT_BIN = ../../lib

# Libraries
PROJECT_BASE_PATH = ../..

#-------------------------------------------------------------------------------
# Files
#-------------------------------------------------------------------------------

vpath %.h $(PROJECT_BASE_PATH)/include $(PROJECT_BASE_PATH)/cmsis $(PROJECT_BASE_PATH)/../usb/include
vpath %.c $(PROJECT_BASE_PATH)/source $(PROJECT_BASE_PATH)/cmsis
vpath %.s $(PROJECT_BASE_PATH)/source $(PROJECT_BASE_PATH)/cmsis

VPATH+=$(PROJECT_BASE_PATH)/source
VPATH+=$(PROJECT_BASE_PATH)/cmsis

INCLUDES = -I$(PROJECT_BASE_PATH)
INCLUDES += -I$(PROJECT_BASE_PATH)/include
INCLUDES += -I$(PROJECT_BASE_PATH)/cmsis
INCLUDES += -I$(PROJECT_BASE_PATH)/../usb/include

#-------------------------------------------------------------------------------
ifdef DEBUG
include debug.mk
else
include release.mk
endif

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------

include $(TOOLCHAIN).mk


#-------------------------------------------------------------------------------
ifdef DEBUG
OUTPUT_OBJ=debug
OUTPUT_LIB=$(LIBNAME)_$(CHIP)_$(TOOLCHAIN)_dbg.a
else
OUTPUT_OBJ=release
OUTPUT_LIB=$(LIBNAME)_$(CHIP)_$(TOOLCHAIN)_rel.a
endif

OUTPUT_PATH=$(OUTPUT_OBJ)_$(CHIP)

#-------------------------------------------------------------------------------
# C source files and objects
#-------------------------------------------------------------------------------
C_SRC=$(wildcard $(PROJECT_BASE_PATH)/source/*.c)
C_SRC+=$(wildcard $(PROJECT_BASE_PATH)/cmsis/*.c)

#C_OBJ_TEMP=$(addprefix $(OUTPUT_PATH)/,$(patsubst %.c,%.o,$(notdir $(C_SRC))))
C_OBJ_TEMP=$(patsubst %.c, %.o, $(notdir $(C_SRC)))
#C_OBJ_TEMP=$(C_SRC:%.c=%.o)

# during development, remove some files
C_OBJ_FILTER=hsmci.o hsmci_pdc.o mci_cmd.o supc.o USBDCallbacks_Initialized.o USBDCallbacks_Resumed.o USBDCallbacks_Suspended.o

C_OBJ=$(filter-out $(C_OBJ_FILTER), $(C_OBJ_TEMP))
#C_OBJ=$(addprefix $(OUTPUT_PATH)/,$(filter-out $(C_OBJ_FILTER), $(C_OBJ_TEMP)))

#-------------------------------------------------------------------------------
# Assembler source files and objects
#-------------------------------------------------------------------------------
A_SRC=$(wildcard $(PROJECT_BASE_PATH)/source/*.s)
A_SRC+=$(wildcard $(PROJECT_BASE_PATH)/cmsis/*.s)

#A_OBJ_TEMP=$(addprefix $(OUTPUT_PATH)/,$(patsubst %.s,%.o,$(notdir $(A_SRC))))
A_OBJ_TEMP=$(patsubst %.s, %.o, $(notdir $(A_SRC)))
#A_OBJ_TEMP=$(S_SRC:%.s=%.o)

# during development, remove some files
A_OBJ_FILTER=

A_OBJ=$(filter-out $(A_OBJ_FILTER), $(A_OBJ_TEMP))
#A_OBJ=$(addprefix $(OUTPUT_PATH)/,$(filter-out $(A_OBJ_FILTER), $(A_OBJ_TEMP)))

#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------
all: $(CHIP)

$(CHIP): create_output $(OUTPUT_LIB)

#debug: create_output $(OUTPUT_LIB)

#release: create_output $(OUTPUT_LIB)

.PHONY: create_output
#create_output: $(subst /,$(SEP),$(OUTPUT_BIN)) $(OUTPUT_PATH)
create_output:
#	@echo --- Preparing $(CHIP) files $(OUTPUT_PATH)  $(OUTPUT_BIN)
#	@echo -------------------------
#	@echo *$(C_SRC)
#	@echo -------------------------
#	@echo *$(C_OBJ)
#	@echo -------------------------
#	@echo *$(addprefix $(OUTPUT_PATH)/, $(C_OBJ))
#	@echo -------------------------
#	@echo *$(A_SRC)
#	@echo -------------------------
#	echo	"SEP		$(SEP)"
#	echo	"OUTPUT_BIN	$(OUTPUT_BIN)"
#	echo	"OUTPUT_PATH	$(OUTPUT_PATH)"
	-@$(MKDIR)	$(subst /,$(SEP),$(OUTPUT_BIN)) 1>$(NULL) 2>&1
	-@$(MKDIR)	$(OUTPUT_PATH) 1>$(NULL) 2>&1

#%.o : %.c %.h chip.h $(SUB_MAKEFILES)
#	$(CC) -c $(CFLAGS) $< -o $(OUTPUT_PATH)/$@
#$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o : %.c %.h chip.h $(SUB_MAKEFILES)
#$(O_DST): %.o: %.c %.h chip.h $(SUB_MAKEFILES)

$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o: %.c
	@$(CC) -c $(CFLAGS) $< -o $@
#	@$(CC) $(CFLAGS) $<

$(addprefix $(OUTPUT_PATH)/,$(A_OBJ)): $(OUTPUT_PATH)/%.o: %.s
	@$(AS) -c $(ASFLAGS) $< -o $@

$(OUTPUT_LIB): $(addprefix $(OUTPUT_PATH)/, $(C_OBJ)) $(addprefix $(OUTPUT_PATH)/, $(A_OBJ))
#	$(AR) -r $(OUTPUT_BIN)/$@ $(addprefix $(OUTPUT_PATH)/,$^)
#$(OUTPUT_LIB): $(addprefix $(OUTPUT_PATH)/,$(O_DST))
	@$(AR) -r $(OUTPUT_BIN)/$@ $^
	@$(NM) $(OUTPUT_BIN)/$@ > $(OUTPUT_BIN)/$@.txt

.PHONY: clean
clean:
	@echo --- Cleaning $(CHIP) files
	-@$(CS_RM) -Rf $(OUTPUT_PATH) 1>$(NULL) 2>&1
	-@$(CS_RM) -Rf $(subst /,$(SEP),$(OUTPUT_BIN)/$(OUTPUT_LIB)) 1>$(NULL) 2>&1

$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o: $(PROJECT_BASE_PATH)/chip.h $(wildcard $(PROJECT_BASE_PATH)/include/*.h) $(wildcard $(PROJECT_BASE_PATH)/cmsis/*.h)
