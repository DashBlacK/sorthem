all: sorthem

sorthem: sorthem.o asm_io.o driver.c
	gcc -m32 -o sorthem sorthem.o driver.c asm_io.o
asm_io.o: asm_io.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
sorthem.o: sorthem.asm
	nasm -f elf32 -o sorthem.o sorthem.asm
clean:
	rm *.o sorthem
