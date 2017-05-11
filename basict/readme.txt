"Fuer die einen ist es ein Microcontroller, fuer die anderen der wahrscheinlich
billigste BASIC-COMPUTER der Welt! "

######################################################################################

                             TinyBasic fuer STM8S103F3P6
                     Ein ultraminimalistischer Basic-Interpreter


                             Ausgangsdatei von T. Suzuki
                      STM8S Port und Erweiterungen von R. Seelig

######################################################################################


Im Rahmen eines kleinen privaten "Wettbewerbs" ging es darum, wie billig der billigste
BASIC-Computer ausfallen kann. Vordergruendig war dieses durch die extrem preiswerten
(billigen) Teile aus China initiiert worden.

Da bei solchen Dingen der Spieltrieb und der Ehrgeiz geweckt wird habe ich mich an
das Werk gemacht und das hier ist das Resultat.

Den preiswertesten Microcontroller den ich gefunden (und sogar verfuegbar) hatte war
ein:

                                  STM8S103F3P6

Diesen gibt es als "minimales Entwicklungsboard" auf einer Platine Montiert, 2 Stueck
zum Preis von sage und schreibe 1,51 Euro (also sind wir hier bei 76 Cent fuer den
Controller, Suchbegriffe fuer Ebay: "2pcs stm8s102 minimum").

Den einzelnen Chip gibts noch preiswerter, ist auch in meinem "Sammelsurium" vorhanden,
hier kosten 5 Stueck sage und schreibe 1,91 Euro, macht 38 Cent per Stueck, irre.

Ich habe mich fuer das "Board" entschieden, weil auf diesem gleich eine Resettaste und
viel wichtiger ein 3,3V Spannungsreger verbaut ist.

Um ein Basic-Programm eingeben zu koennen bedarf es einer Eingabemoeglichkeit und hier-
fuer verwende ich standardmaessig den

                                    CH340G

Dieser Chip ist eine USB2RS232 Bruecke und leistet mir unter Linux super gute Dienste.
5 Stueck hiervon kosten 1,57 Euro. Dieser Chip benoetigt einen 12 MHz Quarz, 20 Stueck
kosten 1,49 Euro.


Ebay Suchbegriffe:

2pcs stm8s103 minimum
5pcs ch340g
20pcs 12 mhz crystal
5pcs mini-usb pcb adapter
10pcs adapter smd dip16

Zum Flashen des Controllers benoetigt man einen ST-LINK v2 (den ich jedoch fuer die
STM32 Programmierung auch hier habe): 2,29 Euro

Suchbegriff:

st-link v2

Sucheinstellungen: Weltweit, niedrigster Preis inkl. Versand



Die Kosten des Basic-Computers
----------------------------------------------------------------------------------------------------

Komplette Bauteile fuer den Basic-Computer sind:

1 Stck.        STM8S103F3P6 Board                  / 0,76 Euro        1,52 Euro /  2 Stck.
1 Stck.        CH340G                              / 0,32 Euro        1,57 Euro /  5 Stck.

1 Stck.        12 MHz Quarz                        / 0,08 Euro        1,49 Euro / 20 Stck.
2 Stck.        100nF                               / 0,06 Euro
1 Stck.        47uF / 16V                          / 0,05 Euro
1 Stck.        (Mini) USB-Buchse auf PCB           / 0,23 Euro        1,15 Euro /  5 Stck.
1 Stck.        DIP 16 PCB                          / 0,15 Euro        1,47 Euro / 10 Stck.
                                                ---------------     -------------
                                                     1,65 Euro        7,20 Euro

1 Stck.        ST-Link v2                                             2,29 Euro
                                                                    -------------
                                                                      9,49 Euro

Die Zusammenstellung zeigt auf, dass, selbst wenn man ausser einem Breadboard nichts
zur Verfuegung hat, man mit unter 10 Euro dabei ist und man hier dann schon eine
groessere Menge Bastelmaterial auf einmal hat. Vor allem die Quarze, die Schnittstellen-
bausteine und die "Controllerboards" koennen fuer vieles anderes verwendet werden
(bspw. wird gerade ein Tetris und ein Snake auf diesem STM8S103 realisiert).


Der Schaltplan
----------------------------------------------------------------------------------------------------


             +---------------------------------------+----------------+
             |                                       |                |
+--------+   |       +---------------------+         |     +----------------------+ 3,3V
| U  +5V | --+       |                     | +3,3V         |         5V           |---------
| S   D+ | ----------|  6               16 |---------------| 3,3V                 | SWIM
| B   D- | ----------|  5    CH340G        | TxD           |                      |---------
|    GND |           |                   2 |---------------| D6   STM8S103F3P6    | GND        ==> ST-Link v2
+--------+ --+   +---|  4                3 |---------------| D5     Board         |---------
             |   |   |    7       8        | RxD           |                      | NRST
             |  ===  +---------------------+         |     |         GND          |---------
             |   |100n    |       |    |             |     +----------------------+
            --- ---       +--|#|--+    |          +------+           |
                          |       |    |     100n |     +| 47uF      |
                          | 12MHz |    |         ===    ===          |
                         ===     ===   |          |      |           |
                          |       |    |          |      |           |
                         ---     ---  ---        ---    ---         ---


Die Basic-Firmware
----------------------------------------------------------------------------------------------------

Die Firmware ist in der gepackten ZIP-Datei enthalten. Es benoetigt ein Linux um dieses zu ueber-
setzen.

Der hierfuer verwendete Compiler fuer die Firmware ist SDCC in der Version 3.50. Er kann
gedownloaded werden unter:

              https://sourceforge.net/projects/sdcc/files/sdcc-linux-x86

Hier die Version 3.50 waehlen (Vertraeglichkeiten mit neueren Versionen sind nicht getestet). Den
Installationsanweisungen auf Sourceforge folgen um den Compiler zu installieren.


Ein Verzeichnis der Wahl erstellen, bpsw.:

             cd ~
             mkdir stm8projects


und das Firmwarepackage in dieses Verzeichnis entpacken

Hier entstehen dann folgende Verzeichnissstruktur:

          basict ---------- Makefile
                            sendbas57600
                            compile_sendbas
                            tbasic.c
                            laufl.bas
                            testinput.bas
                            testprog.bas
                            fakul.bas

          include --------- stm8s.h
                            stm8_init.h
                            stm8_gpio.h
                            stm8_systimer.h

          src ------------- stm8_systimer.c
                            stm8_init

          stm8unlock
          stm8unlock.bin
          stm8lock
          stm8lock.bin
          stm8flash
          st8readihx
          picocom

Leider sind bei Auslieferung der STM8S103 Boards diese "gelockt", so dass dieses aufgehoben
werden muss. Das geschieht jedoch relativ einfach in Verbindung mit dem ST-Link v2.

Verbinden sie die 4 Leitungen des Boards mit dem ST-Link. Die Leitungen sind bezeichnet mit

                                 SWIM, RST, GND, 3.3V

und rufen sie das Programm stm8unlock auf:

                                 ./stm8unlock

Der Lock wurde somit aufgehoben.

Wechseln sie in das Verzeichnis basict

                                 cd basict

und fuehren sie das Makefile mittels Make aus:

                                 make all

Ist der SDCC korrekt installiert wird nun ein Binarie erzeugt, dieses kann mittels

                                 make flash

in den Controller uebertragen werden.

Der Basic-Interpreter ist nun betriebsbereit und an sich wird nun der ST-Link nicht mehr
benoetigt und kann, wenn die USB-Leitung angeschlossen ist, abgezogen werden.

Oeffnen sie ein weiteres Konsolenfenster und wechseln sie in das Verzeichnis

                             stm8projects/basict

Starten Sie das Terminal picocom mittels

                          ../picocom -b 57600 /dev/ttyUSB0

Sollten sie mehrere USB2RS232 - Bruecken installiert haben, kann der Name ttyUSB0 abweichen,
abhaengig davon, wieviele Adapter gerade aktiv sind (bspw. koennte es auch ttyUSB1 heissen).

Picocom ist ein superkleines und sehr spartanisches serielles Terminalprogramm, es kann
beendet werden mit der Tastenkombination (alle gleichzeitig druecken):

                                 STRG A X

Wenn sie die Resettaste des STM8S103 Boards druecken, meldet sich der Basic-Interpreter mit

                 STM8S103F3P6 -- TBasic -- 57600Bd 8n1

Sie koennen nun hier ein Basicprogramm eingeben, oder

oeffnen sie ein weiteres Terminal und wechseln in das Verzeichnis

                            stm8projects/tbasic

Hier koennen sie mittels sendbas57600 eine Textdatei, die ein lauffaehiges Basic-Programm
darstellt ueber die serielle Schnittstelle an den Basic-Interpreter uebermitteln:

                ./sendbas57600 testprog.bas /dev/ttyUSB0


Der Basic-Interpreter
----------------------------------------------------------------------------------------------------

Der Interpreter ist aufgrund der minimalen Hardware extrem "abgespeckt". Jeder Programmzeile muss
eine Zeilennummer vorangestellt werden. Variablename bestehen aus einem einzelnen Buchstaben und
koennen von a..z reichen. Ein laufendes Programm kann mit der ESC-Taste abgebrochen werden.

Es stehen folgende Programmbefehle zur Verfuegung:

#######################
        PRINT
#######################
   Gibt Texte, Variableninhalte oder numerische Zahlen aus

   10 print "Text"
   20 print "Variable", a

   Wird dem Print-Befehl ein Komma nachgestellt, erfolgt kein Zeilenvorschub:

   30 print "Zahl: ",
   40 print 4*3

#######################
        INPUT
#######################
   Eine Variable ueber die serielle Schnittstelle einlesen

   10 print "Zahl eingeben ",
   20 input x
   30 print "Die Zahl war: ",x

#######################
     GOSUB / RETURN
#######################
   Ein Unterprogramm aufrufen

   10 out(0)= 0
   20 gosub 200
   30 out(0)= 1
   40 gosub 200
   50 goto 10
   200 rem ###########
   210 rem delay
   220 rem ###########
   230 for x= 1 to 8000
   240 next x
   250 return


#######################
         OUT
#######################
   Einem Ausgangsportpin einen Wert zuweisen

   out(pinnummer)= 0  setzt den Portpin auf logsich 0,
                 = 1  setzt den Portpin auf logisch 1

   Das Pinmapping der Portpins

         0   ....   PA3
         1   ....   PB4
         2   ....   PB5
         3   ....   PC3
         4   ....   PC4
         5   ....   PC5
         6   ....   PC6
         7   ....   PC7
         8   ....   PD3
         9   ....   PD4

   Das Beispiel in GOSUB / RETURN schaltet den Portpin PA3
   abwechselnd ein und aus.

#######################
         IN
#######################
   Einen Portpin einlesen

   10 i= in(3)
   20 if i=0 goto 10
   30 print "Pin ist 1"
   40 goto 10

#######################
         IF
#######################
   Bedingte Programmverzweigung

   Der IF - Befehl ist in seiner Funktion eingeschraenkt, er kennt
   nicht wie bei BASIC ueblich ein THEN und ein ELSE, er kann lediglich
   bei erfuellter Bedingung zu einer anderen Programmzeile verweisen.

   Befehlsbedingungen sind groesser, kleiner, gleich (es gibt kein ungleich)

#######################
       FOR / NEXT
#######################
   Programmschleife

   Fuehrt Anweisungen wiederholt aus:

   10 for z= 1 to 10
   20 print z," * ",z," = ",z*z
   30 next z


#######################
       ABS
#######################
   Gebe den Absolutwert einer Zahl aus

   i= abs(-12)
   print i

   Die Ausgabe ist 12


#######################
       SCALL
#######################
   fuehrt einen "Systemaufruf" durch. Aufgrund der begrenzten Resourcen ist
   derzeit nur ein einziger Systemaufruf vorhanden

   SCALL Nummer, Argument

   Systemfunktion

         1  : gebe Asciizeichen aus
                  Argument: auszugebendes Ascii-Zeichen

   10 for a= 65 to 90
   20 scall 1,a
   30 next a


#######################
       Array
#######################
   TBasic verfuegt ueber ein einzelnes Array das ueber das @ - Zeichen an-
   gesprochen werden kann. Dieses Array kann max. 32 Werte aufnehmen

   @(index)= Wert


   10 print "Geben Sie 4 Zahlen ein"
   20 for i= 1 to 4
   30 print "Zahl ",i,": "
   40 input z
   50 @(i)= z
   60 next i
   70 print "Die Zahlen waren:"
   80 for i= 1 to 4
   90 z= @(i)
   100 print "Zahl ",i,": ",z
   110 next i

#######################
       SIZE
#######################
   gibt den freien Verfuegbaren Speicher zurueck

   print size()


###############################################################
Interpreterbefehlseingaben
###############################################################


LIST       : listet das aktuelle Programm auf
SAVE       : speichert das aktuelle Programm im internen EEPROM
             des Microcontrollers
LOAD       : laedt das aktuelle Programm aus dem internen EEPROM


-----------------------------------------------------------------------------------------------
Anhang
-----------------------------------------------------------------------------------------------

##############################################################################################
Basic-Programm: Knight-Riderlauflich

10 print "Knightrider-Lauflicht mit TBasic"
20 for l= 0 to 7
30 out(l)= 1
40 next l
50 l= 0
60 out(l)= 0
70 gosub 300
80 out(l)= 1
90 l= l+1
100 if l< 8 goto 60
110 l= 6
120 out(l)= 0
130 gosub 300
140 out(l)= 1
150 l= l-1
160 if l= 0 goto 60
170 goto 120
300 rem ##############
310 rem DELAY
320 rem ##############
330 for d= 1 to 3000
340 next d
350 return


##############################################################################################
Basic-Programm: Testprogramm mit ASCII-Ausgabe und Blinklicht

5 gosub 300
7 print
10 print "Blinky auf PB5"
20 print "PC3 (Input-Pin) bestimmt Frequenz"
30 print "high = langsam  low = schnell"
40 f=2500
50 if in(3)= 1 f=12500
60 out(2)=0
65 out(4)=1
70 gosub 200
80 out(2)=1
85 out(4)=0
90 gosub 200
100 goto 40
200 rem Delay
210 for i= 1 to f
220 a=a+1
230 next i
240 return
300 print "Die Ascii Tabelle"
302 print
305 b= 0
310 for a= 32 to 127
315 if a> 99 goto 320
317 scall 1,32
320 print a,": ",
325 scall 1,a
330 print "  ",
340 b= b+1
350 if b< 10 goto 380
360 scall 1,10
370 scall 1,13
375 b= 0
380 next a
390 print
400 return

##############################################################################################
Basic-Programm: Fakultaetberechnung

10 rem ##################
20 rem Fakultaet
30 rem ##################
40 input "Eingabe Fakultaet : " x
50 f=1
60 for z=1 to x
70 f= f*z
80 next z
90 print "Fakultaet ",x," = ",f
100 stop


##############################################################################################

Pinmapping STM8S103F3P6

                            ------------
UART1_CK / TIM2_CH1 / PD4  |  1     20  |  PD3 / AIN4 / TIM2_CH2 / ADC_ETR
    UART1_TX / AIN5 / PD5  |  2     19  |  PD2 / AIN3
    UART1_RX / AIN6 / PD6  |  3     18  |  PD1 / SWIM
                     NRST  |  4     17  |  PC7 / SPI_MISO
              OSCIN / PA1  |  5     16  |  PC6 / SPI_MOSI
             OSCOUT / PA2  |  6     15  |  PC5 / SPI_CLK
                Vss (GND)  |  7     14  |  PC4 / TIM1_CH4 / CLK_CCO / AIN2
                VCAP (*1)  |  8     13  |  PC3 / TIM1_CH3 /
                Vdd (+Ub)  |  9     12  |  PB4 / I2C_SCL
           TIM2_CH3 / PA3  | 10     11  |  PB5 / I2C_SDA
                            -----------

*1 :  Ist mit min. 1uF gegen GND zu verschalten


STM8S103F3P6 Minimal-Board (China)  alternative Pinfunktionen
Hinweis: VCAP ist NICHT auf dem Board aufgelegt !!!


Minimum-Board       =====    Funktion

d4                  -----    PD4 / UART1_CK / TIM2_CH1 / BEEP(HS)
d5                  -----    PD5 / UART1_TX / AIN5 / HS
d6                  -----    PD6 / UART1_RX / AIN6 / HS
rst                 -----    NRST ( auch fuer ST-Link)
a1                  -----    PA1 / OSCIN (Quarz)
a2                  -----    PA2 / OSCOUT (Ouarz)
gnd                 -----    Vss
5V                  -----    Betriebsspannung
3V3                 -----    3,3V Ausgangsspannung AMS1117 3.3
a3                  -----    PA3 / SPI_NSS / TIM2_CH3(HS)

b5                  -----    PB5 / T / I2C_SDA / TIM1_BKIN
b4                  -----    PB4 / T / I2C_SCL / ADC_ETR
c3                  -----    PC3 / HS / TIM1_CH3 / TLI / TIM1_CH1N
c4                  -----    PC4 / HS / TIM1_CH4 / CLK_CC0 / AIN2 / TIM1_CH2N
c5                  -----    PC5 / HS / SPI_SCK
c6                  -----    PC6 / HS / SPI_MOSI / TIM1_CH1
c7                  -----    PC7 / HS / SPI_MISO / TIM1_CH2
d1                  -----    PD1 / HS / SWIM ( ST-Link )
d2                  -----    PD2 / HS / AIN3 / TIM2_CH3
d3                  -----    PD3 / HS / AIN4 / TIM2_CH2 / ADC_ETR

