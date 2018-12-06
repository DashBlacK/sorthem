%include "asm_io.inc"

extern rconf

section .data
errorMsg: dd "Invalid argument. sorthem takes exactly 1 argument. Argument must be >= 2 and <= 9.",10,0
initMsg: dd "initial configuration",10,0
finishMsg: dd "final configuration",10,0
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
maxPegs: dd 0
pegArray: times 10 dd 0

section .bss

section .text
global asm_main

dispError:
	mov eax, errorMsg
	call print_string
	call print_nl
	jmp endProgram

showp:
	enter 0,0
	pusha
	mov ecx, [ebp+8]
	add ecx, 32
	mov edx, 9

printNextLine:
	cmp [ecx], dword 0
	je nextLine

	cmp [ecx], dword 1
	jne check2
	mov eax, line1
	call print_string
	jmp nextLine

check2:
	cmp [ecx], dword 2
	jne check3
	mov eax, line2
	call print_string
	jmp nextLine

check3:
	cmp [ecx], dword 3
	jne check4
	mov eax, line3
	call print_string
	jmp nextLine

check4:
	cmp [ecx], dword 4
	jne check5
	mov eax, line4
	call print_string
	jmp nextLine

check5:
	cmp [ecx], dword 5
	jne check6
	mov eax, line5
	call print_string
	jmp nextLine

check6:
	cmp [ecx], dword 6
	jne check7
	mov eax, line6
	call print_string
	jmp nextLine

check7:
	cmp [ecx], dword 7
	jne check8
	mov eax, line7
	call print_string
	jmp nextLine

check8:
	cmp [ecx], dword 8
	jne check9
	mov eax, line8
	call print_string
	jmp nextLine

check9:
	mov eax, line9
	call print_string

nextLine:
	dec edx
	sub ecx, 4
	cmp edx, 0
	jne printNextLine
	mov eax, line10
	call print_string
	call read_char
	jmp endProgram

sorthem:
	mov ecx, [esp+4]
	mov edx, [esp+8]
	push ecx
	push edx
	mov eax, [maxPegs]
	push eax
	push pegArray
	call showp
	add esp, 8
	pop edx
	pop ecx
	call sorthemRec
	ret

sorthemRec:
	cmp edx, dword 2
	je sorthemSwap
	push edx
	push ecx
	add ecx, 4
	dec edx
	call sorthemRec
	pop ecx
	pop edx

sorthemSwap:
	mov eax, [ecx]
	cmp eax, [ecx+4]
	jna sorthemCont

sorthemEnd:
	push ecx
	push edx
	mov eax, [maxPegs]
	push eax
	push pegArray
	call showp
	add esp, 8
	pop edx
	pop ecx
	ret

sorthemCont:
	mov eax, [ecx]
	mov edi, ecx
	add edi, 4
	mov ebx, [edi]
	mov [ecx], ebx
	mov [edi], eax
	add ecx, 4
	dec edx
	cmp edx, dword 1
	ja sorthemSwap
	jmp sorthemEnd

asm_main:
	enter 0,0
	pusha
	mov eax, dword [ebp+8]
	cmp eax, 2
	jne dispError

	mov eax, [ebp+12]
	mov ebx, [eax+4]
	cmp [ebx], byte '9'
	ja dispError
	cmp [ebx], byte '2'
	jl dispError
	cmp [ebx+1], byte 0
	jne dispError

	mov ebx, dword [ebp+12]
	mov eax, [ebx+4]
	mov bl, byte [eax]
	mov eax, 0
	mov al, bl
	sub al, 48
	mov [maxPegs], eax

	push eax
	push pegArray
	call rconf
	add esp, 8

	mov eax, initMsg
	call print_string
	call print_nl
	push maxPegs
	push pegArray
	call showp
	add esp, 8

	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	mov edx, [ebx+4]
	mov al, byte [edx]
	sub eax, dword '0'
	mov [maxPegs], eax

	mov eax, [maxPegs]
	push eax
	push pegArray
	call sorthem
	add esp, 8

	mov eax, finishMsg
	call print_string
	call print_nl

	mov eax, [maxPegs]
	push eax
	push pegArray
	call showp
	add esp, 8

endProgram:
	mov eax, 0
	leave
	ret
