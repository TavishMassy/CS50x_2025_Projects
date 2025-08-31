#include <cs50.h>
#include <stdio.h>

int main(void)
{
    long long int num = get_long_long("Number: ");

    long long int num1 = num;
    long long int num3 = num;
    int odd = 1;
    int sumodd = 0;
    int sumeven = 0;

    while (num1 > 0)
    {

        if (odd == 1)
        {
            sumodd += num1 % 10;
            odd = 0;
        }
        else if (odd == 0)
        {
            int num2 = (num1 % 10) * 2;
            if (num2 > 9)
            {
                sumeven += num2 % 10;
                num2 /= 10;
                sumeven += num2 % 10;
            }
            else
            {
                sumeven += num2;
            }
            odd = 1;
        }
        num1 /= 10;
    }

    if (((sumodd + sumeven) % 10 != 0) || (num < 999999999999 || num > 9999999999999999))
    {
        printf("INVALID\n");
    }
    else
    {
        while (num3 > 100)
        {
            num3 /= 10;
        }

        if ((num3 == 34 || num3 == 37) && (num > 99999999999999 && num < 999999999999999))
        {
            printf("AMEX\n");
        }

        else if (num3 > 50 && num3 < 56 && (num > 999999999999999 && num < 9999999999999999))
        {
            printf("MASTERCARD\n");
        }

        else if (num3 > 39 && num3 < 50 &&
                 ((num > 999999999999 && num < 9999999999999) ||
                  (num > 999999999999999 && num < 9999999999999999)))
        {
            printf("VISA\n");
        }
        else
        {
            printf("INVALID\n");
        }
    }
    return 0;
}
