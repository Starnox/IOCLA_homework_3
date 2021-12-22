section .text

global expression
global term
global factor

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        
        ;; make some space for local variable
        sub esp, 4

        mov [ebp - 4], dword 0

        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]

        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]

        ;; check if p[*i] == '('
        cmp cl, '('
        jne factor_else
        inc eax

        mov edx, [ebp + 12]
        mov [edx], eax

        ;; call expression (p, i)
        push dword [ebp + 12]
        push dword [ebp + 8]
        call expression
        add esp, 8

        ;; store the result of the function in the local variable
        mov [ebp - 4], eax

        ;; increment again i to go over the '('
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]

        ;; increment and store
        inc eax
        mov edx, [ebp + 12]
        mov [edx], eax

        jmp factor_end

factor_else:
        ;; we have a number we need to parse in a loop
        ;; we will update the local variable at [ebp - 4] with
        ;; each iteration like in this formula
        ;; result = result * 10 + (p[*i] - '0);

        jmp factor_condition

factor_loop:
        ;; cl holds the character
        sub cl, byte '0'
        mov eax, [ebp - 4]

        mov edi, dword 10
        mul edi
        
        add eax, ecx

        ;; store the new result
        mov [ebp - 4], eax

        ;; increment i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]
        inc eax

        mov edx, [ebp + 12]
        mov [edx], eax

factor_condition:
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]
        
        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        
        xor ecx, ecx
        mov cl, byte [edx + eax]
        ;; if it is smaller then '0' then we exit
        cmp cl, '0'
        jl factor_end

        ;; if it is bigger then '9' then we exit
        cmp cl, '9'
        ja factor_end

        jmp factor_loop

factor_end:

        ;; the return value is at [ebp - 4]
        mov eax, [ebp - 4]

        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp

        ;; make some space for local variable
        sub esp, 4

        ;; call factor(p, i)
        push dword [ebp + 12]
        push dword [ebp + 8]
        call factor
        add esp, 8


        ;; result is stored in eax
        ;; move it in a local variable called result
        mov [ebp - 4], eax
        jmp check_term

loop_term:
        ;; check if p[*i] == '*'
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]

        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]

        ;; compare with '*'
        cmp cl, '*'
        jne next2

        ;; the character is *
        ;; increment i and store
        inc eax
        mov edx, [ebp + 12]
        mov [edx], eax

        push dword [ebp + 12]
        push dword [ebp + 8]

        ;; recursive call to factor
        call factor
        add esp, 8

        ;; result from factor(p, i) is now stored in eax
        ;; multiply eax to the local variable stored at ebp - 4
        
        ;; mov the values stored in eax in ecx
        mov ecx, eax

        ;; get the result stored in local variable
        mov eax, [ebp - 4]
        imul eax, ecx

        ;; update the result
        mov [ebp - 4], eax

next2:
        ;; check if p[*i] == '/'
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]

        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]

        ;; compare with '/'
        cmp cl, '/'
        jne check_term

        ;; the character is /
        ;; increment i and store
        inc eax
        mov edx, [ebp + 12]
        mov [edx], eax

        push dword [ebp + 12]
        push dword [ebp + 8]

        ;; recursive call to factor
        call factor
        add esp, 8

        ;; result from factor(p, i) is now stored in eax
        ;; divide the local variable stored at ebp-4 with eax
        
        ;; mov the values stored in eax in ecx
        mov ecx, eax

        ;; get the result stored in local variable
        mov eax, [ebp - 4]

        ;; divide
        cdq
        idiv ecx
        ;; update the result
        mov [ebp - 4], eax


check_term:
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]
        
        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]

        ;; check if it is * or /
        cmp ecx , byte '*' 
        je loop_term
        cmp ecx, byte '/'
        je loop_term

        ;; set the return register set in eax
        ;; to the local variable we defined

        mov eax, [ebp - 4]

        add esp, 4

        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp

        ;; make some space for local variable
        sub esp, 4

        ;; call term(p, i)
        push dword [ebp + 12]
        push dword [ebp + 8]
        call term
        add esp, 8

        ;; result is stored in eax
        ;; move it in a local variable called result
        mov [ebp - 4], eax
        jmp check_expression

loop_expression:

        ;; check if p[*i] == '+'
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]

        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]

        ;; compare with '+'
        cmp cl, '+'
        jne next1

        ;; increment i and store
        inc eax
        mov edx, [ebp + 12]
        mov [edx], eax

        push dword [ebp + 12]
        push dword [ebp + 8]

        ;; recursive call to term
        call term
        add esp, 8

        ;; result from term(p, i) is now stored in eax
        ;; add eax to the local variable stored at ebp - 4
        mov edx, dword[ebp - 4]
        add edx, eax
        mov [ebp - 4], edx

next1:      

        ;; check if p[*i] == '-'
        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]

        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]
        cmp cl, '-'
        jne check_expression

        ;; increment i and store
        inc eax
        mov edx, [ebp + 12]
        mov [edx], eax

        push dword [ebp + 12]
        push dword [ebp + 8]

        ;; recursive call to term
        call term
        add esp, 8

        ;; result from term(p, i) is now stored in eax
        ;; substract eax to the local variable stored at ebp - 4
        mov edx, dword [ebp - 4]
        sub edx, eax
        mov [ebp - 4], edx

check_expression:

        ;; put in eax *i
        mov eax, [ebp + 12]
        ;; get the value of *i
        mov eax, [eax]
        
        ;; get p
        mov edx, [ebp + 8]
        ;; get the character at p[*i]
        xor ecx, ecx
        mov cl, byte [edx + eax]

        ;; check if it is + or -
        cmp ecx , byte '+' 
        je loop_expression
        cmp ecx, byte '-'
        je loop_expression

        ;; set the return register set in eax
        ;; to the local variable we defined

        mov eax, [ebp - 4]

        add esp, 4

        leave
        ret
