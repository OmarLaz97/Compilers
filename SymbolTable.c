#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>

#include "stack.c"
#include "Structs.h"
#define HASH_SIZE 60

union Value {
	int MyintValue;	    /* integer value */
	float MyfloatValue;    /* float value */
	char* MycharValue;    /* char value */
	char* MystringValue;    /* string value*/
	char* Myidentifier;       /* identifier name */
	/*char* Myarrayidentifier;*/
	char* Mycomment;
	nodeType* nPtr;
 };

struct SymbolInfo {
    char * Sym_Name;
    int Sym_Type;
    int Sym_Scope;
    union Value Sym_Value;

    struct SymbolInfo *Next;
}*HashTable[HASH_SIZE];
//we have a hash table of size HASH_SIZE to point to different symbol tables

//HashFun to return the index of new symbol table in the hash table
//HashFun takes the name of the symbol and add its ASCII code % HASH_SIZE to get its index

int HashFun(char *Name){
    int index= 0;
    for (int i=0; Name[i]; ++i){
        index += Name[i];
    }
    return (index % HASH_SIZE);
}

//Search Hash Table to check whether the exact info exists before or not
//that is return true only if a symbol having the same name, same type, same scope exists
bool SearchTable(char *Name, int Type, int Scope){
    //get index
    int HashIndex = HashFun(Name);

    struct SymbolInfo *symbolEntry = HashTable[HashIndex];
    
    //strcmp compares 2 strings (2 *char) and return 0 if they are identical
    while (symbolEntry != NULL){
        if (!strcmp(symbolEntry->Sym_Name, Name) && symbolEntry->Sym_Type==Type && symbolEntry->Sym_Scope == Scope){
            return true; //found
        }
        symbolEntry = symbolEntry->Next;  
    }

     return false; //not found
}

//insert in hash table, return false if insertion failed as the symbol already exists
//or return true if insertion was successful
bool InsertTable(struct SymbolInfo *newEntry){
    printf("GOWA INSERT");
    char *newName = newEntry->Sym_Name;
    int index= HashFun(newName);

    if(SearchTable(newName, newEntry->Sym_Type, newEntry->Sym_Scope)){
        printf("Symbol with name %s is already declared in this scope\n", newName);
        return false;
    }
        

    //by here, symbol wasn't found in hash table, so we will add a new one
    //if HashTable[index]==NULL, then we insert newEntry immediately
    //otherwise we resolve collision by chaining, we put new node at first and make it point to the rest of the symbols having same index

    if (HashTable[index] == NULL){
        HashTable[index] = newEntry;
        HashTable[index]->Next = NULL;
        return true;
    }    
    else {
        struct SymbolInfo *temp = HashTable[index];
        HashTable[index] = newEntry;
        HashTable[index]->Next = temp;
        return true;
    }
}

//same as SearchTable but returns the Value if found and Found is true
//otherwise Found = false
union Value SearchTableVal(char *Name, int Type, int Scope, bool *Found){
    //get index
    int HashIndex = HashFun(Name);

    struct SymbolInfo *symbolEntry = HashTable[HashIndex];
    
    //strcmp compares 2 strings (2 *char) and return 0 if they are identical
    while (symbolEntry != NULL){
        if (!strcmp(symbolEntry->Sym_Name, Name) && symbolEntry->Sym_Type== Type && symbolEntry->Sym_Scope == Scope){
            (*Found) = true;
            return symbolEntry->Sym_Value; //found
        }
        symbolEntry = symbolEntry->Next;  
    }

    (*Found) = false;
    union Value result;
    result.MycharValue = '#';
    return result; //not found
}

void PrintSymbolTable(){
    for (int HashIndex=0; HashIndex< HASH_SIZE; HashIndex++){
        printf("HashIndex= %d", HashIndex);
        printf("\n---------------------------\n");

        struct SymbolInfo *temp= HashTable[HashIndex];
        while (temp != NULL){
            printf("Name= %s    Type=%d     Scope=%d \n", temp->Sym_Name, temp->Sym_Type, temp->Sym_Scope);
            temp= temp->Next;
        }
        printf("\n\n"); 
    }
}


/*
int main(){
    int Scope=0;
   FILE *fptr;

   if ((fptr = fopen("program.txt","r")) == NULL){
       printf("Error! opening file");

       // Program exits if the file pointer returns NULL.
       exit(1);
   }

   while (!feof(fptr)){
        char *Name[50];
        char *Type[50];
        char *unknown[50];

        fscanf(fptr,"%s", &unknown);
        printf(".");
        printf(unknown);
         printf(".");
        printf("\n");
        if (!strcmp(unknown,"{")) Scope++;
        else if (!strcmp(unknown,"}")) Scope--;
        else if (!strcmp(unknown,"3ayem")){
           
            strcpy(Type, unknown); 
            fscanf(fptr,"%s", &Name);
            struct SymbolInfo *temp= malloc(sizeof(struct SymbolInfo)); 
            
            temp->Sym_Name = Name;
            temp->Sym_Type = Type;
            temp->Sym_Scope = Scope;
            InsertTable(temp);
        }
   }

   fclose(fptr); 
  
   PrintSymbolTable();
   return 0;
}
*/