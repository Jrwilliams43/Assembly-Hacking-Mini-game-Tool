	.NOLIST
	.386

	EXTRN print_strings_proc	: Near32
	EXTRN str_num_matches_proc	: Near32
	EXTRN swap_strings_proc		: Near32

	;PRECONDITIONS:
	;str1 represents a string. Must be a BYTE array, the length of str1 should be equal to len 
	;str2 represents a string. Must be a BYTE array, the length of str2 should be equal to len 
	;len represents the length of both str1 and str2. It is WORD sized. Must be the length of string + carriage & line feed
	;len may not be negative and should be greater than 0.
	;POSTCONDITIONS:
	;the number of matched characters between str1 and str2 should be returned in ax
		
	num_matches MACRO str1,str2,len,xtra
		
		
			IFB <str1>
				.ERR <missing "str1" operand in num_matches>
			ELSEIFB <str2>
				.ERR <missing "str2" operand in num_matches>
			ELSEIFB <len>
				.ERR <missing "len" operand in num_matches>
			ELSEIFNB <xtra>
				.ERR <extra operand(s) in num_matches>
			ELSE
		
		push ebx
			lea ebx,str1
			push ebx	;[ebp+14]
			lea ebx,str2
			push ebx	;[ebp+10]
			push len	;[ebp+8]
			call str_num_matches_proc
		pop ebx
			
		ENDIF
		ENDM

	;PRECONDITIONS:	
	;str1 represents a string. Must be a BYTE array, the length of str1 should be equal to len 
	;str2 represents a string. Must be a BYTE array, the length of str2 should be equal to len 
	;len represents the length of both str1 and str2. It is WORD sized. Must be the length of string + carriage & line feed
	;len may not be negative and should be greater than 0.
	;POSTCONDITIONS:
	;the contents of str1 and str2 should be swapped
		
	swap_passwords MACRO str1,str2,len,xtra

			IFB <str1>
				.ERR <missing "str1" operand in num_matches>
			ELSEIFB <str2>
				.ERR <missing "str2" operand in num_matches>
			ELSEIFB <pass_len>
				.ERR <missing "len" operand in num_matches>
			ELSEIFNB <xtra>
				.ERR <extra operand(s) in num_matches>
			ELSE
			push ebx
				lea ebx,str1
				push ebx
				lea ebx,str2
				push ebx
				push len
				call swap_strings_proc
			pop ebx
			
			ENDIF
			ENDM
			
			
	;PRECONDITIONS:
	;pass_array represents a list of passwords.It is BYTE array. 
	;array_size represents the number of passwords in the list of passwords.It is WORD sized.
	;len represents the length of passwords in pass_array.It is WORD sized. Must be the length of string + carriage & line feed
	;array_size and len may not be negative and should be greater than 0.
	;POSTCONDITIONS:
	;The contents of pass_array should be displayed to the screen

	print_passwords MACRO pass_array,array_size,len,xtra

			IFB <pass_array>
				.ERR <missing "pass_array" operand in print_passwords >
			ELSEIFB <array_size>
				.ERR <missing "array_size" operand in print_passwords>
			ELSEIFB <pass_len>
				.ERR <missing "len" operand in print_passwords>
			ELSEIFNB <xtra>
				.ERR <extra operand(s) in print_passwords>
			ELSE
			push ebx
			lea ebx, pass_array
			
				push ebx		;[ebp+12]
				push array_size	;[ebp+10]
				push len		;[ebp+8]
				
				call print_strings_proc
			pop ebx
			
		ENDIF
		ENDM
		
	.NOLISTMACRO
	.LIST