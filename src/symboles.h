#ifndef SYMBOLES_H
#define SYMBOLES_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Symbol {
    char* name;     // Nom de la variable
    char* type;     // Type de la variable (NUM, REAL, etc.)
    int value;      // Valeur de la variable (utilisée pour les types numériques)
    struct Symbol* next;
} Symbol;

typedef struct SymbolTable {
    Symbol* head;   // Liste chainée pour stocker les symboles
} SymbolTable;

// Création d'une table des symboles vide
SymbolTable* create_symbol_table();

// Recherche d'un symbole par son nom
Symbol* lookup_symbol(SymbolTable* table, const char* name);

// Insertion d'un nouveau symbole dans la table
void insert_symbol(SymbolTable* table, const char* name, const char* type);

// Libération de la mémoire de la table des symboles
void free_symbol_table(SymbolTable* table);

#endif
