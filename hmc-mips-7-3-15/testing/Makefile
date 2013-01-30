CC = mips-idt-elf-gcc
AS = mips-idt-elf-as
DUMP = mips-idt-elf-objdump
CFLAGS = -Wall -msoft-float 

all: test_000.dat test_001.dat test_002.dat test_003.dat test_004.dat test_005.dat test_006.dat test_007.dat test_008.dat test_009.dat test_010.dat test_011.dat test_012.dat test_012.asm test_013.dat test_014.dat test_015.dat test_016.dat test_fp_001.dat test_017.dat test_020.dat test_021.dat test_022.dat test_023.dat test_024.dat test_025.dat test_026.dat

# All c-compiled programs must have their first instruction changed so that it
# sets the stack pointer

# This line prevents make from automatically deleting these files as temporary
.PRECIOUS: %.dat %.dump %.o %.s %.asm

%.dat: %.dump
	cat $< | grep --only-matching "^ *[0-9a-fA-F]\+:[^0-9a-fA-F]*[0-9a-fA-F ]\+" | tr -d " " | grep --only-matching "[0-9a-fA-F]\{8\}" > $@

%.dump: %.o
	$(DUMP) -d --disassemble-zeroes $< > $@

# ".set noreorder" in the assembly code prevents the removal of unneeded nops 
# and swapping branches
%.o: %.asm
	$(AS) -c $< -o $@

%.asm: %.c
	$(CC) $(CFLAGS) -S -c $< -o $@

clean:
	rm *.o *.dump
