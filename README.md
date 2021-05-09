Instal NASM on linux:

`sudo apt-get install nasm`

Running on linux:

`nasm -f elf32 linux.asm`

`ld -m elf_i386 -o s linux.o`

`./s`
