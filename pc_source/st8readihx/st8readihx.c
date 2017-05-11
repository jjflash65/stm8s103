/* ------------------  st8readihx.c ----------------

        Intel Hexfile lesen und anzeigen

   ------------------------------------------------- */


#include <stdio.h>
#include <string.h>
#include <stdint.h>

/* -------------------------- STRDEL ------------------------
     loescht eine Anzahl n Zeichen aus dem String s ab der
     Position pos (inklusive des Zeichens an pos)
     Erstes Zeichen hat Postion (pos) = 1 (und nicht 0) !!!
   ----------------------------------------------------------*/
char *strdel(char *s, int pos, int n)
{
  pos--;
  if (pos> strlen(s)) return s;
  if ((pos+n) > strlen(s))
  {
    n= strlen(s)-pos;
  }
  memmove(s+pos, s+pos+n, strlen(s)-pos-n+1);
  return s;
}

/* -------------------------- STRSPOS ------------------------
     sucht den String srcstr nach dem Substring substr ab
     und liefert die erste Position an der der Substring
     enthalten ist (0 bei Nichtvorhandensein)
   ----------------------------------------------------------*/
int strspos(char *srcstr, char *substr)
// liefert 0 zurueck, wenn Teilstring nicht vorhanden
{
  char *p;
  p= strstr(srcstr, substr);
  if ((p-srcstr+1)> strlen(srcstr)) return 0;
  return (p-srcstr+1);
}

/* -------------------------- STRCPOS ------------------------
     sucht den String srcstr nach dem Zeichen ch ab
     und liefert die erste Position an der das Zeichen
     enthalten ist (0 bei Nichtvorhandensein)
   ----------------------------------------------------------*/
int strcpos(char *srcstr, char ch)
{
  char *p;
  p= strchr(srcstr,ch);
  if ((p-srcstr+1)> strlen(srcstr)) return 0;
  return (p-srcstr+1);
}


/* -------------------------- STRCOPY -----------------------
     kopiert aus dem String src ab der Position pos
     (inklusive) die Anzahl anz Zeichen in den String dest
   ----------------------------------------------------------*/
char *strcopy(char *src, char *dest, int pos, int anz)
{
  int l;

  l= strlen(src);
  if ((pos> l) || (!pos))
  {
    *dest= 0;
    return dest;
  }
  src= src+(pos-1);
  strncpy(dest, src, anz);
  if ( (l-pos+1) < anz) anz= l-pos+1;
  dest[anz]= 0;                         // im Zielstring das Endezeichen setzen
}


char existfile(char *dname)
{
  FILE    *tdat;

  tdat= fopen(dname,"r");
  if (tdat== 0)
  {
    return 0;
  }
  else
  {
    fclose(tdat);
    return 1;
  }
}

/* ------------------- READHEXFILE ------------------

     liest Intel-Hexdatei und stellt die hoechste
     verwendete Seicheradresse fest.

     dname  :        zu lesende Datei auf Massenspeicher
   -------------------------------------------------- */
int readhexfile(char* dname, char hexdumpenable)
{
  FILE     *tdat;
  char     tx[256], cpybuffer[256];
  int      zeil;
  int      b, b2, banz;
  uint8_t  codbyte, cb;
  int      fadress, highestadr;


  zeil= 0;
  tdat= fopen(dname,"r");
  if (tdat== 0)
  {
//    printf("\n\r%s: no such file\n\r",dname);
    return 1;
  }

  b= 0;
  highestadr= 0;
  do
  {
    fgets(tx,255,tdat);

    do                                 // CR entfernen
    {
      b= strcpos(tx,0x0d);
      if (b) strdel(tx,b,1);
    } while (b);
    do                                 // LF entfernen
    {
      b= strcpos(tx,0x0a);
      if (b) strdel(tx,b,1);
    } while (b);

//    printf("\n%s",tx);

    // Hier jede gelesene Zeile der Hexdatei interpretieren und die hoechste
    // und niedrigste Speicheradresse speichern
    if (tx[0]== ':')                   // korrekter Beginn einer Hexzeile ?
    {
      strcopy(tx,cpybuffer,8,2);
      if (!(strcmp(cpybuffer,"00")))   // wenn es normale Datenbytes sind...
      {                                // ... diese auswerten
        zeil++;

        strcopy(tx,cpybuffer,2,2);                // Anzahl Datenbytes in dieser Zeile
        banz= strtol(cpybuffer,0,16);             // hexstring to longint, Basis 16 (Hex)

        strcopy(tx,cpybuffer,4,4);                // Speicheradresse der Datenbytes dieser Zeile
        fadress= strtol(cpybuffer,0,16);

        for (b= 0; b< banz; b++)
        {
          codbyte= strtol(cpybuffer,0,16);
          fadress++;
          if (fadress> highestadr) highestadr= fadress;
        }
      }
    }

  }while (!feof(tdat));
  fclose(tdat);

  return highestadr;
}


int main(int argc, char **argv)

{
  int        byteanz;
  char       b;
  char       filename[256];


  if (argc < 2)
  {
    printf("\n Syntax: st8readihx ihxfile\n\n");
    return 1;
  }


  strcpy(filename,argv[1]);

  b= existfile(&filename[0]);
  if (!b)
  {
//    printf("\n   No such file: %s\n\n", filename);
    return 2;
  }

  byteanz= readhexfile(&filename[0],0)-0x8000;
  fprintf(stderr,"Device   : STM8S103F3\n");
  fprintf(stderr,"Program  : at address 0x8000 %d Bytes (%.1f%% full)\n",byteanz, (float)(byteanz*100)/0x2000);

  return 0;
}

