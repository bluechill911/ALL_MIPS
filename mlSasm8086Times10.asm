; Times10.asm - Multiply by 10
; Name: XXXXXXXXXXXX
; Date: mm/dd/yy
;
; IO.INC CALLS
;===================================================================================
;PRINT_DEC size, data
;	Print number data in decimal representation. size – number, giving size of
;	 data in bytes - 1, 2, 4 or 8 (x64). data must be number or symbol 
;	constant, name of variable, register or address expression without size 
;	qualifier (byte[], etc.). PRINT_UDEC print number as unsigned, PRINT_DEC 
;	-- as signed.
;NEWLINE 
;===================================================================================
        CPU 386
%include "io.inc"

section .data
value		DD	7	

section .text
global CMAIN
CMAIN:
    mov  ebp, esp            ; for correct debugging

    ;TODO: write your code here
    mov     eax, [value]   ;[] is the value, no [] is the address
    mov     ebx, eax
    shl     ebx, 1
    shl     ebx, 1      ;*4
    add     eax, ebx    ;1* + 4* = 5*
    shl     eax, 1      ;*10


    ;print the results
    PRINT_DEC 4, eax
    NEWLINE
	
    ret
