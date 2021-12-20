section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	pop ecx ; [esp]
	pop eax ; [esp + 4]
	pop ebx ; [esp + 8]

	;; iterate throught the string and maintain a counter in edi
	;; edi increments when there is an open bracket and decrements when is a close one
	;; if at any point during the loop edi goes below 0 than the string is incorrect 
	;; and we exit, other we continue. If by the end we didn't encounter an error return true

	;; remake the stack
	push ebx
	push eax
	push ecx

	xor edx, edx
	xor edi, edi
	;; eax = str_length , ebx = str

loop:
	;; check the parentheses
	cmp byte[ebx + edx] , 40
	jne closed

open:
	;; it means is open
	inc edi
	jmp continue

closed:
	;; it is closed
	dec edi


continue:
	;; check if the string is invalid
	cmp edi, 0xffffffff
	je neg_result

	inc edx
	cmp edx,  eax
	jne loop
	jmp pos_result


neg_result:
	push 0
	pop eax
	jmp finish


pos_result:
	push 1
	pop eax

finish:

	ret
