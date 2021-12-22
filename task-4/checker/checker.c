#include <stdio.h>
#include <stdlib.h>
#define MAX_LINE 100001

int expression(char *p, int *i);
int term(char *p, int *i);
int factor(char *p, int *i);

int main()
{
    char s[MAX_LINE];
    char *p;
    int i = 0;  
    scanf("%s", s);
    p = s;
    printf("%d\n", expression(p, &i));
    return 0;
}

/*
// this evaluates term + term or term - term
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
*/