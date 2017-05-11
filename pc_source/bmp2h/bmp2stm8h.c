/* -------------------  bmp2stm8h.c  -----------------

         erstellt aus einer s/w BMP-Datei eine
         von Headerdatei, die die Bilddaten der BMP-
         Datei enthaellt und mittels der Showimage-
         Funktion in stm8_nokia_glcd angezeigt werden
         kann.

         07.12.2015  R. Seelig
   --------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


uint8_t swapbits(uint8_t b)
{
  uint8_t cnt, w;

  w= 0;
  for (cnt= 0; cnt< 8; cnt++)
  {
    w |= (b & 1);
    b = b >> 1;
    if (cnt != 7) {w = w << 1;}
  }
  return w;
}

void printbinbyte(uint8_t b)
{
  char cnt;
  for (cnt= 7; cnt> -1; cnt--)
  {
    if (b & 0x80) { putchar('1'); } else { putchar('0'); }
    b= b << 1;
  }
}


uint32_t fgetint32(FILE *binfile)
{

  uint32_t     datvalue;

  datvalue= fgetc(binfile);
  datvalue |= (fgetc(binfile)<< 8);
  datvalue |= (fgetc(binfile)<< 16);
  datvalue |= (fgetc(binfile)<< 24);
  return datvalue;
}

uint16_t fgetint16(FILE *binfile)
{

  uint16_t     datvalue;

  datvalue= fgetc(binfile);
  datvalue |= (fgetc(binfile)<< 8);
  return datvalue;
}

uint32_t fread32(FILE *binfile, uint32_t bytepos)
{
  fseek(binfile,bytepos,SEEK_SET);                       // Dateizeiger auf Byteposition in der Datei setzen
  return fgetint32(binfile);
}

uint16_t fread16(FILE *binfile, uint32_t bytepos)
{
  fseek(binfile,bytepos,SEEK_SET);                       // Dateizeiger auf Byteposition in der Datei setzen
  return fgetint32(binfile);
}

void loadswbmp(char* datnam)
{

  uint16_t       bmpid;
  uint32_t       filesize;
  uint32_t       bmpbreite;
  uint32_t       bmphoehe;
  uint16_t       bppx;                                 // Bit per Pixel
  uint32_t       bdatptr;                              // Offset an dem die Bilddaten abgelegt sind

  FILE           *binfile;
  unsigned char  bmpdat[0x7fff];


  uint8_t        pixbytex, dbyte;
  int            x, xw, xanz, y, datanz;
  int            i, cnt, icnt, b, ch;
  int            rcnt;


  binfile= fopen(datnam, "r+b");                   // Datei zum Lesen oeffnen
  if (binfile== (NULL))
  {
    printf("\n\nDatei %s wurde nicht gefunden ... \n\n",datnam);
    return;
  }
  fseek(binfile,0,SEEK_SET);                       // Dateizeiger auf Anfang der Datei setzen

  bmpid= fread16(binfile,0);
  filesize= fread32(binfile,2);
  bmpbreite= fread32(binfile,18);
  bmphoehe= fread32(binfile,22);
  bppx= fread16(binfile,28);
  bdatptr= fread32(binfile,10);


  fseek(binfile,bdatptr,SEEK_SET);                                                 // Dateizeiger auf Anfang Farbpalette setzen
  xanz= bmpbreite / 32;
  pixbytex= bmpbreite / 8;
  if (bmpbreite % 32) { xanz++; }                                                  // wenn X Aufloesung kein Vielfaches von 32 ist
                                                                                   // (BMP-Datei hat eine Speicherblock von 4 Bytes)
  if (bmpbreite % 8) { pixbytex++; }                                               // wenn X Aufloesung kein Vielfaches von 8 ist
                                                                                   // fuer die zu erstellende Headerdatei werden
                                                                                   // volle Bytes per Linie erzeugt, der Rest eines
                                                                                   // Bytes ist mit Nullen aufgefuellt
  xanz= xanz*4;
  datanz= bmphoehe*xanz;
  i= fread(&bmpdat,datanz,1,binfile);

/* nur zu Testzwecken

  printf("\nBMP-ID       : 0x%x = %c%c",bmpid,bmpid & 0xff,bmpid>>8);              // ist die ID NICHT 0x4d42  ("BM") dann ist es keine BMP-Datei
  printf("\nDateigroesse : %d",filesize);
  printf("\nBitmapbreite : %d",bmpbreite);
  printf("\nBitmapbreite : %d",bmphoehe);
  printf("\nBit per Pixel: %d",bppx);
  printf("\nDatenzeiger  : 0x%.4X\n",bdatptr);
  printf("Anzahl Bytes per X-Reihe (BMP-Datei): %d\n",xanz);
  printf("Anzahl Bytes per X-Reihe (Header): %d\n",pixbytex);
  printf("Anzahl Bitmap Datenbytes: %d\n",i*datanz);
  printf("Byte an 0x3E: %.2X\n",bmpdat[0x3e]);
  ch= getchar(); */


  printf("static const unsigned char bmppic [] = {\n");
  printf("  0x%.2X, 0x%.2X,\n  ",bmpbreite,bmphoehe);

  icnt= datanz;
  for (y= 0; y < bmphoehe; y++)
  {
    icnt -= xanz;
    xw= 0;
    for (x= 0; x < pixbytex; x++)
    {
      b= bmpdat[icnt+x];
      dbyte= 0;
      for (cnt = 7; cnt > -1; cnt--)
      {
        if ((xw < bmpbreite))
        {
          if (!(b & (1 << cnt)))
          {
            dbyte |= 1;
          }
        }
        if (cnt != 0) { dbyte = dbyte << 1;}
        xw++;
      }
      if ((y == bmphoehe-1) && (x == pixbytex-1))
      {
        printf("0x%.2X };\n",dbyte);
      }
      else
      {
        printf("0x%.2X, ",dbyte);
      }
    }
    printf("\n  ");
  }


//  Zu Testzwecken das BMP als "Ascii-Bildchen" ausgeben

/*  ch= getchar();

  icnt= datanz;
  for (y= 0; y < bmphoehe; y++)
  {
    printf("\n");
    icnt -= xanz;
    xw= 0;
    for (x= 0; x < xanz; x++)
    {
      b= bmpdat[icnt+x];
      for (cnt = 7; cnt > -1; cnt--)
      {
        if ((xw < bmpbreite))
        {
          if (b & (1 << cnt)) { putchar(' '); } else { putchar('o'); }
        }
        xw++;
      }
    }
  } */


  fclose(binfile);
}



int main(int argc, char **argv)
{

  uint8_t c1,c2;

  if (argc!= 2)
  {
    printf("\n\nBMP2STM8H 0.01\n");
    printf("-------------\n\n");
    printf("Dateikonverter: \n");
    printf("   Konvertiert eine s/w BMP-Datei in ein C- Headerfile.\n");
    printf("   Hierfuer wird ein Array im Header generiert. Die Ausgabe des \n");
    printf("   Headerfiles geschieht auf dem Standard-Output-Stream. Soll eine Datei\n");
    printf("   geschrieben werden, so kann diese mittels Pipe Funktion in eine\n");
    printf("   Datei umgeleitet werden.\n");
    printf("   Syntax:   bmp2stm8h BMP-Dateiname\n");
    printf("\nBeispiel:  bmp2stm8h mybmp.bmp > myheader.h\n\n");
    return -2;
  }

  loadswbmp(argv[1]);
  printf("\n");

}
