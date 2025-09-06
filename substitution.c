#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

int verify(string key);

void encipher(string key);

int main(int argc, string argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }
    int len = strlen(argv[1]);
    if ((len > 0 && len != 26))
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }
    else
    {
        int result = verify(argv[1]);
        if (result == 0)
        {
            encipher(argv[1]);
            return 0;
        }
        else
        {
            return 1;
        }
    }
}

int verify(string key)
{
    int alpha[25];
    for (int i = 0; i < 26;)
    {
        if (isalpha(key[i]))
        {
            alpha[toupper(key[i]) - 'A'] += 1;
        }
        else
        {
            printf("Key must only contain alphabetic characters.\n");
            return 1;
        }
        i++;
    }
    for (int j = 0; j < 26; j++)
    {
        if (alpha[j] != 1)
        {
            return 1;
            printf("Key must not contain reapeated characters.\n");
        }
    }
    return 0;
}

void encipher(string key)
{
    string msg = get_string("plaintext: ");
    char enmsg[10000];
    int C = 0;
    int A = 'A';
    int a = 'a';
    for (int i = 0; i < strlen(msg); i++)
    {
        if (msg[i] >= 'A' && msg[i] <= 'Z')
        {
            C = msg[i];
            enmsg[i] = toupper(key[C - A]);
        }
        else if (msg[i] >= 'a' && msg[i] <= 'z')
        {
            C = msg[i];
            enmsg[i] = tolower(key[C - a]);
        }
        else
        {
            enmsg[i] = msg[i];
        }
    }
    printf("ciphertext: %s\n", enmsg);
}
