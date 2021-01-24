; Insert.asm - insert a word into text
; Name: XXXXXXXXXXXX
; Date: mm/dd/yy
;
; IO.INC CALLS
;===================================================================================
;PRINT_UDEC size, data
;PRINT_DEC size, data
;	Print number data in decimal representation. size – number, giving size of
;	 data in bytes - 1, 2, 4 or 8 (x64). data must be number or symbol 
;	constant, name of variable, register or address expression without size 
;	qualifier (byte[], etc.). PRINT_UDEC print number as unsigned, PRINT_DEC 
;	-- as signed.
;PRINT_HEX size, data 
;	Similarly previous, but data is printed in hexadecimal representation.
;PRINT_CHAR ch 
;	Print symbol ch. ch - number or symbol constant, name of variable,
;	register or address expression without size qualifier (byte[], etc.).
;PRINT_STRING data 
;	Print null-terminated text string. data - string constant, name of
;	variable or address expression without size qualifier (byte[], etc.).
;NEWLINE 
;	Print newline ('\n').
;GET_UDEC size, data
;GET_DEC size, data
;	Input number data in decimal representation from stdin. size – number, 
;	giving size of data in bytes - 1, 2, 4 or 8 (x64). data must be name of 
;	variable or register or address expression without size qualifier (byte[],
;	 etc.). GET_UDEC input number as unsigned, GET_DEC — as signed. It is not 
;	allowed to use esp register.
;GET_HEX size, data 
;	Similarly previous, but data is entered in hexadecimal representation with
;	 0x prefix.
;GET_CHAR data 
;	Similarly previous, but macro reads one symbol only.
;GET_STRING data, maxsz 
;	Input string with length less than maxsz. Reading stop on EOF or newline 
;	and "\n" writes in buffer. In the end of string 0 character is added to 
;	the end. data - name of variable or address expression without size 
;	qualifier (byte[], etc.). maxsz - register or number constant.
;===================================================================================
        CPU 386
%include "io.inc"

section .data
;                0123456789012
text:	DB	'The data is convincing. '
endTxt:	DB	0
are:	DB	'are'

section .text
global CMAIN
CMAIN:
    PRINT_STRING text
    NEWLINE

    ;TODO: write your code here
    ;esi is endTxt-2 period
    lea esi, [endTxt-2]
    ;edi is endTxt-1 
    lea edi, [endTxt-1]
    ;ecx is endTxt-text-9
    lea ecx, [endTxt-text-9]
    ;std for decrement, then do rep movsb
    std
    rep movsb   
    ;esi is are address
    lea esi, [are]
    ;edi is text+9
    lea edi, [text+9]
    ;ecc is 3
    lea ecx, [3]
    ;cld for increment, then rep movsb
    cld
    rep movsb

    ;print the modified string again
    PRINT_STRING text
    NEWLINE
	
    ret
