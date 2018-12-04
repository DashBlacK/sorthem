%include "asm_io.inc"

extern rconf

section .data
errorMsg: dd "Invalid argument. sorthem takes exactly 1 argument. Argument must be >= 2 and <= 9.",10,0
line1:	db "          o|o          ",10,0
line2:	db "         oo|oo         ",10,0
line3:	db "        ooo|ooo        ",10,0
line4:	db "       oooo|oooo       ",10,0
line5:	db "      ooooo|ooooo      ",10,0
line6:	db "     oooooo|oooooo     ",10,0
line7:	db "    ooooooo|ooooooo    ",10,0
line8:	db "   oooooooo|oooooooo   ",10,0
line9:	db "  ooooooooo|ooooooooo  ",10,0
line10:	db "XXXXXXXXXXXXXXXXXXXXXXX",10,0

section .text
global asm_main

dispError:
	mov eax, errorMsg
	call print_string
	call print_nl
	jmp endProgram

asm_main:
	enter 0,0
	mov eax, dword[ebp+8]
	cmp eax, 2
	jne dispError

	mov ebx, [ebp+12]
	mov eax, [ebx+4]
	cmp [eax], byte '9'
	ja dispError
	cmp [eax], byte '2'
	jl dispError
	cmp [eax+1], byte 0
	jne dispError

endProgram:
	mov eax, 0
	leave
	ret
