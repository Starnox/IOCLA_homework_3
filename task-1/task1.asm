section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list


sort:
	enter 0, 0

	;; save registers to respect the cdecl calling convention
	push ebx
	push edi

	;; [ebp + 8] the number of nodes
	;; [ebp + 12] node pointer
	;; values of the nodes will be stored at [ebp + 8 * k + 12]

	;; we will sort with selection sort algorithm

	;; ecx will iterate through all of the vectors positions
	xor ecx, ecx

	;; edx will iterate from ecx + 1 to n
	xor edx, edx

	;; get the base address of the struct
	mov esi, [ebp + 12]
	push esi

	;; ecx = i ; edx = j = i + 1
main_loop:


	mov eax, ecx
	mov edx, ecx
	inc edx
aux_loop:

	;; load the values in order to compare

	mov edi, [esi + 8 * eax]
	mov ebx, [esi + 8 * edx]
	

	cmp edi, ebx
	jg smaller
	jmp continue

smaller:
	mov eax, edx


continue:

	inc edx
	cmp edx, [ebp + 8]
	jne aux_loop

	;; modify the values at the selected indexes eax and ecx
	mov ebx, [esi + 8 * eax]
	mov edx, [esi + 8 * ecx]

	mov [esi + 8 * eax], edx
	mov [esi + 8 * ecx], ebx


	inc ecx
	mov edx, [ebp + 8]
	dec edx
	cmp ecx, edx 
	jne main_loop


final:
	;; this will be the base address of the struct
	;; connect the nodes

	;; iterate through the vector (n - 1) and set the next varabile
	;; the last element will point to null

	xor ecx, ecx
	mov edx, [ebp + 8]
	dec edx

final_loop:

	;; ebx = ecx + 1 <=> (j = i + 1)
	mov ebx, ecx
	inc ebx

	lea eax, [esi + 8 * ebx]
	mov [esi + 8 * ecx + 4], eax

	inc ecx
	cmp ecx, edx
	jne final_loop

	inc ecx

	;; set the next of last node to null
	mov [esi + 8 * ecx + 4], dword 0
	pop eax


	;; restore values to respect the standards
	pop edi
	pop ebx

	leave
	ret
