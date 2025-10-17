// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>
#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;

int count = 0;

// TODO: Choose number of buckets in hash table
const unsigned int N = 26;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    int h = hash(word);
    node *pointer = table[h];
    while (pointer != NULL)
    {
        if (strcasecmp(pointer->word, word) == 0)
        {
            return true;
        }
        else
        {
            pointer = pointer->next;
        }
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO: Improve this hash function
    return toupper(word[0]) - 'A';
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // TODO
    for (int i = 0; i < N; i++)
    {
        table[i] = NULL;
    }
    FILE *source = fopen(dictionary, "r");
    if (source == NULL)
    {
        return false;
    }
    char tmp[LENGTH + 1];
    while (fscanf(source, "%s", tmp) == 1)
    {
        int h = hash(tmp);
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            return false;
        }
        strcpy(n->word, tmp);
        n->next = table[h];
        table[h] = n;
        count++;
    }
    fclose(source);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return count;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // TODO
    for (int i = 0; i < N; i++)
    {
        node *tmp = table[i];
        node *pointer = table[i];
        while (pointer != NULL)
        {
            pointer = pointer->next;
            free(tmp);
            tmp = pointer;
        }
    }
    return true;
}
