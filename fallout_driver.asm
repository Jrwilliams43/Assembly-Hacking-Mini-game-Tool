;Program 4 
;Author: Jerrold Williams	DATE:12/02/15
;Purpose: Help users crack fallout hacking minigame

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
	.STACK 4096

	MAX EQU 25
	LEN EQU 13

	.DATA
	temp_add 		DWORD	?
	index			WORD	?
	user_matches	WORD	?
	password_array	BYTE (MAX*LEN) DUP(?),0
	input_line		BYTE LEN DUP(?),0	
	temp_word		BYTE LEN DUP(?),0
	prompt1			BYTE "Enter a string: ",0
	prompt2 		BYTE "The number strings entered is ",0
	prompt3 		BYTE "You may enter up to 20, up to one at a time.",0
	prompt4 		BYTE "Enter the index for the test password(1-based):",0
	prompt5			BYTE "Enter the number of exact character matches:",0

	INCLUDE debug.h
	INCLUDE fallout.h
	INCLUDE strutils.h

	.CODE

	_start:
	lea ebx,password_array
	mov ecx,0

	_loopStart:

	cmp cx,WORD PTR MAX
	jg _done
	output prompt1
	input[ebx],LEN
	output[ebx]
	output carriage
	cmp BYTE PTR [ebx],'x'
	je _done
	inc cx
	add ebx,LEN
	jmp _loopStart
	_done:

	output carriage
	output prompt2
	outputW cx

	guess:
	output carriage
	print_passwords password_array,cx,WORD PTR LEN
	
	cmp cx,1		
	jle _completely_done

	mov dx,0
	;reading in index
	output prompt4
	input input_line,LEN
	output input_line
	atoi input_line
	dec ax
	mov index,ax
	;reading in matches
	output carriage
	output prompt5
	input input_line,LEN
	output input_line
	atoi input_line
	mov user_matches,ax

	movzx eax,index				;acquire the password that will be standard for testing
	mov ebx,LEN
	imul ebx
	 
	lea ebx,password_array
	mov temp_add,ebx
	add eax,ebx
	mov esi,eax
	lea edi,temp_word
	strcopy [esi],[edi];so copy the word that is being used as the standard for testing in the case
						;it is overwritten while swapping
		word_loop:	;This loop goes through the remaining words in the array
					;and cmp num_matches,user_matches
			cmp cx,0
			je _exit				
		
			num_matches [ebx],[edi],WORD PTR LEN;ax contains num_matches
			
			cmp ax, user_matches
			jne _next_word

			_swap:
			inc dx	; the number of swaps is equal to the number of remaining_words
			mov esi,temp_add
			swap_passwords [ebx],[esi],WORD PTR LEN;
			add temp_add,DWORD PTR LEN; update temp_add to next available spot in array

			_next_word:
			dec cx
			add ebx,DWORD PTR LEN
		 jmp word_loop
	 _exit:

	mov cx,dx; dx contains the number of remaining_words
	output carriage
	jmp guess
	
	 _completely_done:
	INVOKE  ExitProcess, 0
	PUBLIC _start
	END         