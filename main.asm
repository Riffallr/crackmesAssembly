.386

.model flat, stdcall
option casemap:none

GetStdHandle PROTO :DWORD
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ReadConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ExitProcess PROTO :DWORD
Sleep PROTO :DWORD

includelib kernel32.lib

STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11

.data
	enterPw db "Enter Password: ", 0
	enterPwLen equ $ - enterPw

	correctPw db "sexmhhh", 0Dh, 0Ah, 0


	msgOk db "Nice!", 0Dh, 0Ah
	msgOkLen equ $ - msgOk


	msgFail db "Bad!", 0Dh, 0Ah
	msgFailLen equ $ - msgFail

.data?
	hStdIn dd ?
	hStdOut dd ?
	bytes_read dd ?
	bytes_write dd ?
	user_input db 32 dup(?)

.code
main proc
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov hStdOut, eax
	
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov hStdIn, eax


	invoke WriteConsoleA, hStdOut, addr enterPw, enterPwLen, addr bytes_write, 0

	invoke ReadConsoleA, hStdIn, addr user_input, 32, addr bytes_read, 0

	lea esi, user_input
	lea edi, correctPw

	compare_loop:
		mov al, [esi]
		mov bl, [edi]
		cmp al, bl
		jne access_denied
		test al, al
		jz access_granted

		inc esi
		inc edi
		jmp compare_loop

	access_granted:
		invoke WriteConsoleA, hStdOut, addr msgOk, msgOkLen, addr bytes_write, 0
		jmp exit_prog

	access_denied:
		invoke WriteConsoleA, hStdOut, addr msgFail, msgFailLen, addr bytes_write, 0
	

	exit_prog:
		invoke Sleep, 3000
		invoke ExitProcess, 0


main endp
end main