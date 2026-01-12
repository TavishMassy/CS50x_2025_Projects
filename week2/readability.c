#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

float grade(string);

int main(void)
{
    string text = get_string("Text: ");
    int score = grade(text) + 0.5;
    
    if (score > 1 && score < 16)
    {
        printf("Grade %d\n", score);
    }
    else if (score <= 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade 16+\n");
    }
    return 0;
}

float grade(string para)
{
    int len = strlen(para);
    float W = 0;
    float S = 0;
    float chars = 0;

    for (int i = 0; i < len; i++)
    {
        if (para[i] == ' ' && para[i - 1] != ' ')
        {
            W++;
        }
        else if ((para[i] == '.' && para[i - 1] != '.') || (para[i] == '?' && para[i - 1] != '?') ||
                 (para[i] == '!' && para[i - 1] != '!'))
        {
            S++;
        }
        if (para[i] >= 'A' && para[i] <= 'z')
        {
            chars++;
        }
    }
    W++;
    float L = 0;
    L = (chars / W) * 100;
    S = (S / W) * 100;

    float index = (0.0588 * L) - (0.296 * S) - 15.8;
    return index;
}
