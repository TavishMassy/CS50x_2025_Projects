#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

int score(string word);

int main(void)
{
    // Player 1
    string word = get_string("Player 1: ");
    int p1_score = score(word);

    // Player 2
    word = get_string("Player 2: ");
    int p2_score = score(word);

    if (p1_score > p2_score)
    {
        printf("Player 1 wins!\n");
    }
    else if (p1_score < p2_score)
    {
        printf("Player 2 wins!\n");
    }
    else
    {
        printf("Tie!\n");
    }

    return 0;
}

int score(string word)
{
    int count = strlen(word);
    int alpha_point[26] = {1, 3, 3, 2,  1, 4, 2, 4, 1, 8, 5, 1, 3,
                           1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};
    int tot_score = 0;

    for (int i = 0; i < count; i++)
    {
        word[i] = toupper(word[i]);

        if (word[i] < 'A' || word[i] > 'Z')
        {
            tot_score += 0;
        }
        else
        {
            tot_score += alpha_point[(word[i]) - 'A'];
        }
    }

    return tot_score;
}
