global get_words
global compare_func
global sort

section .data
    delimiter db " _.,!?", 0

section .text
    extern qsort
    extern strlen 
    extern strtok
    extern strcmp



my_compare:
    enter 0, 0

    ;; save register
    push edi

    ;; first argument
    mov eax, [ebp + 8]
    mov eax, [eax]

    ;; get the length
    push eax
    call strlen
    add esp, 4

    ;; save first argument length in edx
    mov edi, eax

    ;; second argument
    mov eax, [ebp + 12]
    mov eax, [eax]

    ;; get the lenght and store in eax
    push eax
    call strlen
    add esp, 4

    cmp edi, eax
    je same_length

    sub eax, edi
    test eax, eax
    js positive

    mov eax, -1
    jmp exit_my_comp

positive:
    mov eax, 1

    jmp exit_my_comp

same_length:
    ;; return strcmp(a,b)
    mov eax, [ebp + 8]
    mov eax, [eax]

    mov edx, [ebp + 12]
    mov edx, [edx]

    push edx
    push eax

    call strcmp
    add esp, 8

exit_my_comp:

    pop edi

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    push my_compare
    push dword [ebp + 16]
    push dword [ebp + 12]
    push dword [ebp + 8]
    call qsort
    add esp, 16
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov eax, delimiter
    push eax
    push dword [ebp + 8]

    call strtok
    add esp, 8

    ;; edx will hold the index of the curernt word in **words
    mov ecx, eax
    xor edi, edi
    jmp verification

loop_get_words:

    ;; words[k] = token

    ;; address of **words
    mov eax, [ebp + 12]

    lea ebx, [edi * 4]
    add ebx, eax

    mov eax, ecx
    ;; address of words[k]
    mov [ebx] , eax

    

    ;; put at the add the string
    ;; k++
    inc edi


    ;; token = strtok(NULL, delimiter)
    push delimiter
    push 0
    call strtok
    add esp, 8
    mov ecx, eax

verification:
    cmp ecx, 0
    jne loop_get_words ;; check end of line

    ;; delete last character of last word
    push dword [ebx]
    call strlen
    mov edx, [ebx]

    mov byte[edx + eax], byte 0
    mov dword [ebx], edx

    leave
    ret
