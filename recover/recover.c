#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./recover FILE\n");
        return 1;
    }
    char image[20];
    int file_count = 0;
    FILE *img = NULL;
    FILE *card = fopen(argv[1], "r");
    uint8_t buffer[512];
    while (fread(buffer, 1, 512, card) == 512)
    {
        if (buffer[0] == 0xff &&
            buffer[1] == 0xd8 &&
            buffer[2] == 0xff &&
           (buffer[3] & 0xf0) == 0xe0)
        {
            if (img != NULL)
            {
                fclose(img);
            }
            sprintf(image,"%03i.jpg", file_count++);
            img = fopen(image, "w");
        }
        if (img != NULL)
        {
            fwrite(buffer, 1, 512, img);
        }
    }
    fclose(img);
    fclose(card);
}
