#### Tema 3 Iocla
## Elev: Mihailescu Eduard-Florin
## Grupa: 322CB

### Descriere Generala
Acest cod are ca scop rezolvarea temei 3 propusa in cadrul cursului de IOCLA
din anul II, seria CB de la Facultatea de Automatica si Calculatoare.
Voi descrie modul general de functionare al programelor, detaliile de implementare
se pot regasi in comentarii. Specific faptul ca tema a obtinut un punctaj
maxim la rularea locala (100/100)

### Task-1
Pentru a sorta vectorul de structuri m-am folosit de Selection
Sort -> cu ajutorul a doua registre iterez prin fiecare pozitie a vectorului [0...n-1], dupa care caut minimul de la
pozitie curenta pana la sfarsit. Dupa ce il gasesc plasez la cele doua adrese valorile corespunzatoare si trec la urmatoarea pozitie. Dupa ce vectorul este sortat, mai iterez
odata de la baza vectorului pentru a crea legaturile dintre
noduri. Pentru ultimul nod setez `next` la `null`.

### Task-2

#### P1
Cel mai mic multiplu comun are urmatoarea formula:
`lcm(a,b) = a * b / gcd(a,b)` -> unde gcd este cel mai mare
divizor comun. Astfel incep calcularea lui in mod iterativ cu algoritmul lui euclid dupa care aplic formula si stochez rezultatul in eax

#### P2
Se aplica un algoritm simplu ce ruleaza in O(n) care retine
intr-o variabila globala un numar indicator care se incrementeaza cu o unitate atunci cand se gaseste o paranteza deschisa si scade cu o unitate in momentul in care gaseste o paranteza inchisa. Daca in orice punct al rularii, acest numar este mai mic decat zero atunci secventa nu este una valida. La final numarul trebuie sa fie 0 pentru ca secventa sa fie valida

### Task-3
In completarea acestui task m-am folosit de urmatoarele functii din libraria standard C -> `qsort`, `strlen` `strtok`, `strcmp`. Astfel pentru separarea propozitiei in cuvinte am folosit strtok cu delimitatorii precizati in enunt si le-am stocat in tabloul words. Dupa care am sortat acest tablou de cuvinte cu ajutorul lui `qsort` care primeste ca parametru si un comparator creat de mine numit `my_compare`
care are urmatorul echivalent in limbajul C:

```
static int myCompare(const void* a, const void* b)
{
    const char *a_string = *(const char **)a;
    const char *b_string = *(const char **)b;
    int len_a = strlen(a_string);
    int len_b = strlen(b_string);
    if(len_a == len_b)
        return strcmp(a_string, b_string);
    return len_a - len_b;
}
```
### Task-4
In realizarea taskului 4 a trebuit sa imi creez initial un echivalent in C pentru a ma ghida. Astfel am ajuns la urmatoarea
implementare pe care ulterior am transpus-o in assembly:
```
int expression(char *p , int *i){
    int result = term(p, i);

    while(p[*i] == '+' || p[*i] == '-'){

        if(p[*i] == '+')
        {
            (*i)++;
            result += term(p,i);
        }
        if(p[*i] == '-'){
            (*i)++;
            result -= term(p,i);
        }
    }

    return result;
    
}

// Evaluates "factor" * "factor" or "factor" / "factor" expressions 
int term(char *p, int *i){
    int result = factor(p, i);
    while(p[*i] == '*' || p[*i] == '/'){
        if(p[*i] == '*'){
            (*i)++;
            result *= factor(p, i);
        }
        if(p[*i] == '/'){
            (*i)++;
            result /= factor(p, i);
        }
    }
    return result;
    
}

// Evaluates "(expression)" or "number" expressions 
int factor(char *p, int *i){
    int result = 0;
    if(p[*i] == '('){
        (*i)++;
        result = expression(p, i);
        (*i)++;
    }
    else{
        while(p[*i] >= '0' && p[*i] <= '9'){
            int digit = (p[*i] - '0');
            result = result * 10 + digit;
            (*i)++;
        }
    }
    return result;
}
```


