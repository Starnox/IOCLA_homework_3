section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b

gcd:
	pop ecx
	pop eax
	pop ebx


	push ebx
	push eax
	push ecx


	leave
	ret

cmmmc:
	;; get the parameters by popping
	pop ecx ; [esp]
	pop eax ; [esp + 4]
	pop ebx ; [esp + 8]


	;; remake the stack
	push ebx
	push eax
	push ecx

	;; set argumets for gcd
	; push ebx
	; push eax
	; call gcd
	; pop eax
	; pop ebx

	push ebx
	push eax
	;; eax = a , ebx = b

	;; check if a is 0
	cmp eax, 0
	jne label2
	;; return b
	mov eax, ebx
	jmp end

label2:
	;; check if b is 0
	cmp ebx, 0
	jne label3
	;; return a
	jmp end

label3:
	cmp eax, ebx
	jle label4
	sub eax, ebx
	jmp label5

label4:
	sub ebx, eax

label5:
	cmp eax, ebx
	jne label3
	;; lcm = (a * b) / gcd(a,b)

end:
	;; gcd is stored in eax
	;; calculate multiplication
	pop ebx
	pop ecx

	push eax
	pop edi

	push ebx
	pop eax

	mul ecx
	xor edx, edx
	div edi

	;; eax holds the multiplication a * b
	;; edi hols the gcd

	ret
