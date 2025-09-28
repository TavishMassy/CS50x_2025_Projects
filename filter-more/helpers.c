#include "helpers.h"
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    float avg;
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            avg =
                ((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0) + 0.5;
            image[i][j].rgbtRed = avg;
            image[i][j].rgbtGreen = avg;
            image[i][j].rgbtBlue = avg;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp[1][1];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            int k = width - 1 - j;
            temp[0][0] = image[i][j];
            image[i][j] = image[i][k];
            image[i][k] = temp[0][0];
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float n = 0, avgr = 0, avgg = 0, avgb = 0;
            for (int k = i - 1; k <= i + 1; k++)
            {
                for (int l = j - 1; l <= j + 1; l++)
                {
                    if ((k >= 0 && k < height) && (l >= 0 && l < width))
                    {
                        avgr += image[k][l].rgbtRed;
                        avgg += image[k][l].rgbtGreen;
                        avgb += image[k][l].rgbtBlue;
                        n++;
                    }
                }
            }
            temp[i][j].rgbtRed = (avgr / n) + 0.5;
            temp[i][j].rgbtGreen = (avgg / n) + 0.5;
            temp[i][j].rgbtBlue = (avgb / n) + 0.5;
        }
    }
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j] = temp[i][j];
        }
    }
    return;
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp[height][width];
    float x[3][3];
    x[0][0] = -1;
    x[0][1] = 0;
    x[0][2] = 1;
    x[1][0] = -2;
    x[2][1] = 0;
    x[1][2] = 2;
    x[2][0] = -1;
    x[2][1] = 0;
    x[2][2] = 1;

    float y[3][3];
    y[0][0] = -1;
    y[0][1] = -2;
    y[0][2] = -1;
    y[1][0] = 0;
    y[1][1] = 0;
    y[1][2] = 0;
    y[2][0] = 1;
    y[2][1] = 2;
    y[2][2] = 1;

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float erx = 0, egx = 0, ebx = 0;
            float ery = 0, egy = 0, eby = 0;
            for (int k = i - 1; k <= i + 1; k++)
            {
                for (int l = j - 1; l <= j + 1; l++)
                {
                    if ((k >= 0 && k < height) && (l >= 0 && l < width))
                    {
                        int m = k - i + 1, n = l - j + 1;
                        int Gx = x[m][n];
                        int Gy = y[m][n];

                        erx += image[k][l].rgbtRed * Gx;
                        egx += image[k][l].rgbtGreen * Gx;
                        ebx += image[k][l].rgbtBlue * Gx;
                        ery += image[k][l].rgbtRed * Gy;
                        egy += image[k][l].rgbtGreen * Gy;
                        eby += image[k][l].rgbtBlue * Gy;
                    }
                }
            }
            temp[i][j].rgbtRed = fmin(round(sqrt(pow(erx, 2) + pow(ery, 2))), 255);
            temp[i][j].rgbtGreen = fmin(round(sqrt(pow(egx, 2) + pow(egy, 2))), 255);
            temp[i][j].rgbtBlue = fmin(round(sqrt(pow(ebx, 2) + pow(eby, 2))), 255);
        }
    }
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j] = temp[i][j];
        }
    }
    return;
}
