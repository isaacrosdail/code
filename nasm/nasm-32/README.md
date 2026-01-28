# NASM 32-bit Assembly Projects

Collection of 32-bit x86 assembly programs written in NASM.

## Setup

**Install NASM and tools:**
```bash
sudo apt install nasm gcc-multilib gdb
```

**Optional GUI debugger:**
```bash
sudo apt install kdbg
```

## Quick Start

**Assemble and link:**
```bash
nasm -f elf32 program.asm -o program.o
ld -m elf_i386 program.o -o program
```

**Run:**
```bash
./program
```

**Debug:**
```bash
gdb program
# Or with GUI:
kdbg program
```

## Projects

- `project1/` - Basic I/O operations
- `project2/` - Arithmetic and logic
- `project3/` - Loops and conditionals
(etc...)

---
*Note: These programs target 32-bit x86 architecture and require a compatible environment or multilib support.*
