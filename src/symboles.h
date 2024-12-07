#ifndef SYMBOLES_H
#define SYMBOLES_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Taille de la table des symboles (peut être dynamique si nécessaire)
#define MAX_SYMBOLS 100

// Types de données possibles
typedef enum { NUM, REAL, TEXT, TABLEAU, FONCTION, STRUCTURE } Type;

// Statut de la variable (modifiable ou constante)
typedef enum { VARIABLE, CONSTANTE } Statut;

// Structure représentant une entrée dans la table des symboles
typedef struct {
    char nom[20];     // Nom de la variable/constante
    Type type;        // Type de la donnée (NUM, REAL, TEXT, etc.)
    union {
        int int_val;       // Valeur de type NUM
        float real_val;    // Valeur de type REAL
        char text_val[20]; // Valeur de type TEXT
        void *tableau_val; // Pointeur pour les tableaux dynamiques
    };
    Statut statut;    // Si la variable est constante ou modifiable
    int taille;       // Taille pour les tableaux, sinon 0
    int modifiable;   // 1 si modifiable, 0 si constante
    int declaree;     // 1 si la variable a été déclarée
} Symbole;

// Déclaration de la table des symboles
extern Symbole table[MAX_SYMBOLS];
extern int nb_symbols;  // Nombre d'éléments dans la table

// Déclarations des fonctions
int ajouterSymbole(char *nom, Type type, Statut statut, int taille, int modifiable, void *valeur);
Symbole* rechercherSymbole(char *nom);
void afficherTableDesSymboles();
int supprimerSymbole(char *nom);
void reinitialiserTableDesSymboles();

#endif
