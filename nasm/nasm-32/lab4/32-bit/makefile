# Makefile for multiple 32-bit NASM programs with dynamic discovery

# Variables
ASM = nasm
ASMFLAGS = -f elf32 -g #-F dwarf
LD = ld
LDFLAGS = -m elf_i386 -g
SRCS = $(wildcard *.asm)
TARGETS = $(SRCS:.asm=)
OBJS = $(TARGETS:.asm=.o)

# Default target: build all programs
all: $(TARGETS)

# Pattern rule for linking executables
%: %.o
	$(LD) $(LDFLAGS) -o $@ $^

# Pattern rule for assembling .asm to .o
%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Clean target to remove all object files & executables
clean:
	rm -f $(OBJS) $(TARGETS)

# Phony targets
.PHONY: all clean
