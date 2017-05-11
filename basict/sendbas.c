#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <termios.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <ncurses.h>

int porthandle;

#define my_usleep(anz)     ({ fflush(stdout); usleep(anz);} )

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


int set_interface_attribs (int fd, int speed, int parity)
{
  struct termios tty;
  memset (&tty, 0, sizeof tty);
  if (tcgetattr (fd, &tty) != 0)
  {
    printf ("Error: %d from tcgetattr", errno);
    return -1;
  }

  cfsetospeed (&tty, speed);
  cfsetispeed (&tty, speed);

  tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
  // disable IGNBRK for mismatched speed tests; otherwise receive break
  // as \000 chars

  tty.c_iflag &= ~IGNBRK;                         // disable break processing

  tty.c_lflag = 0;                                // no signaling chars, no echo,
                                                  // no canonical processing
  tty.c_oflag = 0;                                // no remapping, no delays
  tty.c_cc[VMIN]  = 0;                            // read doesn't block
  tty.c_cc[VTIME] = 5;                            // 0.5 seconds read timeout

  tty.c_iflag &= ~(IXON | IXOFF | IXANY);         // shut off xon/xoff ctrl

  tty.c_cflag |= (CLOCAL | CREAD);                // ignore modem controls,
                                                  // enable reading
  tty.c_cflag &= ~(PARENB | PARODD);              // shut off parity
  tty.c_cflag |= parity;
  tty.c_cflag &= ~CSTOPB;
  tty.c_cflag &= ~CRTSCTS;

  if (tcsetattr (fd, TCSANOW, &tty) != 0)
  {
    printf ("Error: %d from tcsetattr", errno);
    return -1;
  }
  return 0;
}

void set_blocking (int fd, int should_block)
{
  struct termios tty;
  memset (&tty, 0, sizeof tty);
  if (tcgetattr (fd, &tty) != 0)
  {
    printf ("Error: %d from tggetattr", errno);
    return;
  }

  tty.c_cc[VMIN]  = should_block ? 1 : 0;
  tty.c_cc[VTIME] = 5;                               // 0.5 seconds read timeout

  if (tcsetattr (fd, TCSANOW, &tty) != 0)
    printf ("Error: %d Attribute settings", errno);
}

// ####################################################################

char init_uart(char *portname)
{
  int baudrlist[20] = {0, 50, 75, 110, 134, 150, 200, 300, 600,     \
                      1200, 1800, 2400, 4800, 9600, 19200, 38400,   \
                      57600, 115200, 230400, -1 };
  char sttycall[512];
  struct termios tp, orgtp;

  char cmdportname[128];
  int  baudr, i, b;


  baudr= 115200;
  strcat(sttycall,"stty -F ");
  strcat(sttycall,portname);
  strcat(sttycall," hupcl cooked");

  for (i= 0; ((i< 19) && (baudr != baudrlist[i])); i++);       // sucht Eintrag in der zulaessigen Baudratenliste

  if (i== 19)
  {
    printf("\nZulaessige Baudraten sind: \n\n");
    for (b= 1; b < 19; b++)
    {
      printf("%d",baudrlist[b]);
      if (b < 18) { printf(", "); }
    }
    printf("\n\n");
    return -2;
  }

  if (i> 15) { i+= 4081; }                                     // Baudraten > 38400 haben Nummer ab 4097
  baudr= i;

//  system(sttycall);

  if (tcgetattr(STDIN_FILENO, &tp) == -1)
  {
    printf("Error in: tcgetattr");
    return -1;
  }
  orgtp = tp;                                        // Konsolenparameter sichern
  tp.c_lflag &= ~ECHO;                               // Konsolenecho ausschalten :  ECHO off
  if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &tp) == -1)
  {
    printf("Error in: tcsetattr");
    return -1;
  }

  porthandle = open(portname, O_RDWR | O_NOCTTY | O_SYNC | O_NDELAY);
  if (porthandle < 0)
  {
    printf (" Error %d\n\r Portname %s:  %s\n\r", errno, portname, strerror (errno));
    return -1;
  }

  set_interface_attribs (porthandle, baudr, 0);              // set speed to xxxxx bps, 8n1 (no parity) : Speed is NOT the baudrate,
                                                     //                                           it is the "speed-index" of LINUX
  set_blocking (porthandle, 0);                              // set no blocking

  return 0;
}

// #########################################################################

char readfile(char* dname)
{
  FILE     *tdat;
  char     tx[256], cpybuffer[256];
  int      zeil;
  int      b, b2, banz;
  uint8_t  codbyte, cb;
  int      fadress;


  zeil= 0;
  tdat= fopen(dname,"r");
  if (tdat== 0)
  {
    printf("\n\r%s: no such file\n\r",dname);
    return 1;
  }

  b= 0;
  do
  {
    fgets(tx,255,tdat);

    do                                 // CR entfernen
    {
      b= strcpos(tx,0x0a);
      if (b)
      {
        strdel(tx,b,1);
        tx[b]= 0;
      }
    } while (b);

  banz= 0;
  while(tx[banz])
  {
    putchar(tx[banz]);
    write (porthandle, &tx[banz], 1);
    banz++;
    my_usleep(1000);
  }
  b= '\r';
  write (porthandle, &b, 1);
  putchar('\n');
  putchar('\r');
  my_usleep(20);

  }while (!feof(tdat));
  fclose(tdat);
}


// #########################################################################


int main(int argc, char **argv)

{
  char datnam[255];
  char portnam[255];

  if (argc != 3)
  {
    printf("\n\r Syntax:  sendbas basicdatei.bas serialport");
    printf("\n\r Example: sendbas testprog.bas /dev/ttyUSB0\n\r");
    return 1;
  }
  initscr();
  cbreak();


  strcpy(datnam,argv[1]);
  strcpy(portnam,argv[2]);

  if (init_uart(&portnam[0])) return 2;

  readfile(datnam);

  close(porthandle);
  endwin();
//  system("tset");
  return 0;
}
