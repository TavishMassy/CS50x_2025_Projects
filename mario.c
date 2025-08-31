#include <cs50.h>
#include <stdio.h>
int main(void)
{
    int height = get_int("Hright: ");
    if (height < 1 || height > 8)
    {
        height = get_int("Hright: ");
    }
    int i = 0;
    while (i < height)
    {
        i++;
        int space = height - i;
        int hash1 = i;
        int hash2 = hash1;
        while (space > 0)
        {
            printf(" ");
            space--;
        }
        while (hash1 > 0)
        {
            printf("#");
            hash1--;
        }
        printf("  ");
        while (hash2 > 0)
        {
            printf("#");
            hash2--;
        }
        printf("\n");
    }
}
