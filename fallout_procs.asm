	.386
	.MODEL FLAT

	INCLUDE debug.h

	.CODE
	len					EQU	[ebp+8]
	str1_address		EQU	[ebp+10]
	str2_address		EQU	[ebp+14]
	
	;Counts the number of matches between to two strings
	;PRECONDITIONS:
	;str1 represents a string. Must be a BYTE array, the length of str1 should be equal to len 
	;str2 represents a string. Must be a BYTE array, the length of str2 should be equal to len 
	;len represents the length of both str1 and str2. It is WORD sized. Must be the length of string + carriage & line feed
	;len may not be negative and should be greater than 0.
	;POSTCONDITIONS:
	;the number of matched characters between str1 and str2 should be returned in ax
	str_num_matches_proc	PROC	Near32

	entry_code:
	push ebp 
	mov ebp,esp
	push esi
	push edi
	push ecx
	pushf

	mov eax,0
	mov esi,DWORD PTR str1_address
	mov edi,DWORD PTR str2_address
	mov ecx,DWORD PTR len
	
	dec ecx;don't want to compare carriage
	cld
	
	_start_loop:
	repne cmpsb
	cmp cx,0
	je exit_code
	inc ax
	jmp _start_loop

	exit_code:
	popf
	pop ecx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 10
	str_num_matches_proc ENDP

	;Swaps the contents of two strings 
	;PRECONDITIONS:	
	;str1 represents a string. Must be a BYTE array, the length of str1 should be equal to len 
	;str2 represents a string. Must be a BYTE array, the length of str2 should be equal to len 
	;len represents the length of both str1 and str2. It is WORD sized. Must be the length of string + carriage & line feed
	;len may not be negative and should be greater than 0.
	;POSTCONDITIONS:
	;the contents of str1 and str2 should be swapped
	swap_strings_proc PROC Near32	;shares equ's with str_num_matches_proc
	entry_code:
	push ebp 
	mov ebp,esp
	push esi
	push edi
	push ecx
	push eax
	pushf

	movzx ecx,WORD PTR len
	mov esi,str1_address
	mov edi,str2_address
	cld
	
	;either one should work
	
	;Swap using al
	; begin:
	; cmp ecx,0
	; je exit_code
	; mov al,[edi]
	; movsb
	; dec esi
	; mov [esi],al
	; inc esi
	; dec ecx 
	; jmp begin
	
	;Swap using stack
	movzx eax,WORD PTR len
	dec eax					;to prevent unesscary copy of carriage

	mov ecx,eax				;putting str1 on the stack
	mov esi,str1_address			
	add esi,ecx				;esi points the beginning of a string
	dec esi					;put esi back to last character
	mov edi,esp				
	std						;can't write up on the stack increasing address
	rep movsb				
	
	mov ecx,eax				;overwritting str1 with str2
	inc esi					;put esi back to the beginning of the string 
	mov edi,esi				;the contents of the str1_address are to be overwritten
	mov esi,str2_address
	cld 					;str_address to str_address cld is fine
	rep movsb

	mov ecx,eax				;overwritting str2 with str1 thats on the stack
	mov edi,str2_address	
	mov esi,esp				;esp remains the same 

	add edi,ecx				;str1 is on the stack backwards 
	dec edi					;edi off by one
	std
	rep movsb
	;stack swap ends here
	
	cld
	exit_code:
	popf
	pop eax
	pop ecx
	pop edi
	pop esi
	mov esp,ebp
	pop ebp
	ret 10
	swap_strings_proc ENDP



	array_size		EQU	[ebp+10]
	array_address	EQU	[ebp+12]
	
	;Prints an array of strings to the screen
	;PRECONDITIONS:
	;pass_array represents a list of passwords.It is BYTE array. 
	;array_size represents the number of passwords in the list of passwords.It is WORD sized.
	;len represents the length of passwords in pass_array.It is WORD sized. Must be the length of string + carriage & line feed
	;array_size and len may not be negative and should be greater than 0.
	;POSTCONDITIONS:
	;The contents of pass_array should be displayed to the screen
	print_strings_proc	PROC	Near32
	entry_code:
	push ebp 
	mov ebp,esp
	push ebx
	push ecx
	push edx
	pushf
	mov ebx,array_address
	mov ecx,0
	mov edx,len
	movzx edx,WORD PTR len

	_loopStart:
	cmp cx,array_size
	je exit_code
	output[ebx]
	output carriage
	inc cx
	add ebx,edx
	jmp _loopStart

	exit_code:
	popf
	pop edx
	pop ecx
	pop ebx
	mov esp,ebp
	pop ebp
	ret 8
	print_strings_proc ENDP
	END