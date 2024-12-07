#include "symboles.h"

// Table des symboles
Symbole table[MAX_SYMBOLS];
int nb_symbols = 0;  // Nombre d'éléments dans la table des symboles

// Fonction pour ajouter un symbole dans la table des symboles
int ajouterSymbole(char *nom, Type type, Statut statut, int taille, int modifiable, void *valeur) {
    if (nb_symbols >= MAX_SYMBOLS) {
        printf("Erreur: La table des symboles est pleine.\n");
        return -1;
    }

    // Vérifier si le symbole existe déjà dans la table
    for (int i = 0; i < nb_symbols; i++) {
        if (strcmp(table[i].nom, nom) == 0) {
            printf("Erreur: Le symbole '%s' est déjà déclaré.\n", nom);
            return -1;
        }
    }

    // Ajouter le symbole dans la table
    strcpy(table[nb_symbols].nom, nom);
    table[nb_symbols].type = type;
    table[nb_symbols].statut = statut;
    table[nb_symbols].taille = taille;
    table[nb_symbols].modifiable = modifiable;
    table[nb_symbols].declaree = 1;  // Indiquer que le symbole est déclaré

    // Assignation de la valeur en fonction du type
    if (type == NUM) {
        table[nb_symbols].int_val = *(int *)valeur;
    } else if (type == REAL) {
        table[nb_symbols].real_val = *(float *)valeur;
    } else if (type == TEXT) {
        strcpy(table[nb_symbols].text_val, (char *)valeur);
    } else if (type == TABLEAU) {
        table[nb_symbols].tableau_val = valeur;  // Pointeur vers un tableau
    }

    nb_symbols++;
    return 0;
}

// Fonction pour rechercher un symbole dans la table des symboles
Symbole* rechercherSymbole(char *nom) {
    for (int i = 0; i < nb_symbols; i++) {
        if (strcmp(table[i].nom, nom) == 0) {
            return &table[i];
        }
    }
    return NULL;  // Symbole non trouvé
}

// Fonction pour afficher la table des symboles (utile pour le débogage)
void afficherTableDesSymboles() {
    printf("Table des symboles:\n");
    for (int i = 0; i < nb_symbols; i++) {
        printf("Nom: %s, Type: %d, Statut: %d, Taille: %d, Modifiable: %d, Déclarée: %d\n", 
            table[i].nom, table[i].type, table[i].statut, table[i].taille, 
            table[i].modifiable, table[i].declaree);
        if (table[i].type == NUM) {
            printf("Valeur: %d\n", table[i].int_val);
        } else if (table[i].type == REAL) {
            printf("Valeur: %.2f\n", table[i].real_val);
        } else if (table[i].type == TEXT) {
            printf("Valeur: %s\n", table[i].text_val);
        } else if (table[i].type == TABLEAU) {
            printf("Valeur: Tableau à %p\n", table[i].tableau_val);
        }
    }
}

// Fonction pour supprimer un symbole de la table des symboles
int supprimerSymbole(char *nom) {
    for (int i = 0; i < nb_symbols; i++) {
        if (strcmp(table[i].nom, nom) == 0) {
            // Décaler les éléments suivants dans la table
            for (int j = i; j < nb_symbols - 1; j++) {
                table[j] = table[j + 1];
            }
            nb_symbols--;
            return 0;  // Succès
        }
    }
    printf("Erreur: Symbole '%s' non trouvé pour suppression.\n", nom);
    return -1;
}

// Fonction pour réinitialiser la table des symboles
void reinitialiserTableDesSymboles() {
    nb_symbols = 0;  // Réinitialiser le nombre de symboles
    printf("Table des symboles réinitialisée.\n");
}
