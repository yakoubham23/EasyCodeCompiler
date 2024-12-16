#include "symboles.h"

// Création d'une table des symboles vide
SymbolTable* create_symbol_table() {
    SymbolTable* table = (SymbolTable*)malloc(sizeof(SymbolTable));
    table->head = NULL;
    return table;
}

// Recherche d'un symbole dans la table par son nom
Symbol* lookup_symbol(SymbolTable* table, const char* name) {
    Symbol* current = table->head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL; // Si le symbole n'est pas trouvé
}

// Insertion d'un nouveau symbole dans la table
void insert_symbol(SymbolTable* table, const char* name, const char* type) {
    // Vérifie si le symbole existe déjà
    if (lookup_symbol(table, name) != NULL) {
        return;  // Symbole déjà existant, on ne l'ajoute pas
    }

    Symbol* new_symbol = (Symbol*)malloc(sizeof(Symbol));
    new_symbol->name = strdup(name);  // Copie du nom
    new_symbol->type = strdup(type);  // Copie du type
    new_symbol->value = 0;            // Valeur initiale à 0 (on peut l'initialiser à un autre nombre)
    new_symbol->next = table->head;
    table->head = new_symbol;
}

// Libération de la mémoire utilisée par la table des symboles
void free_symbol_table(SymbolTable* table) {
    Symbol* current = table->head;
    Symbol* next;
    
    while (current != NULL) {
        next = current->next;
        free(current->name);
        free(current->type);
        free(current);
        current = next;
    }

    free(table);  // Libération de la table elle-même
}
