Softwaremodul ws2812.c / ws2812.h
____________________________________________________________________________________________

Text und Software von R. Seelig

Inhaltsverzeichnis:

        - Vorwort
        - WS2812b Leuchtdioden
        - Make

_______________________________________________

Vorwort
_______________________________________________

Seit geraumer Zeit schon gibt es Leuchtdioden mit "integriertem seriellen Controller". Diese
weerden oft fuer sehr kleines Geld (und absolut haeufig auch aus China auf EBAY) angeboten.

Genausooft (und noch guenstiger) werden Microcontroller der Familie STM8S angeboten und
der zweitpreiswerteste ist ein STM8S103F3P6 (auf EBAY werden 2 Stueck Minimumboards mit
dieser MCU fuer ca. 1,40 Euro angeboten, eigentlich unglaublich.

Leider ist die Unterstuetzung fuer diese MCU im Netz verglichen mit AVR und STM32 relativ
duerftig.

Auch freie Compiler hierfuer sind fast nicht verfuegbar und ausser dem SDCC habe ich
keinen freien (zumindest nicht limitierten) Compiler hierfuer gefunden. Von Cosmic gibt
es zwar einen "no limits compiler" aber ich habe nirgendwo einen Compiler fuer Linux auf
deren Seite entdeckt und so programmiere ich den STM8S eben mit SDCC.

Die Verwendung des Softwaremoduls kann somit mit:

Compiler         :  SDCC (ab Version 3.5.0)
MCU              :  STM8S103F3P6
Taktfrequenz MCU :  16MHz
LEDs             :  WS2812b
Betriebssystem   :  Linux
IDE              :  Make

betrieben werden. Eine IDE ist nicht zwingend notwendig, die Software wird mithilfe eines
Makefiles generiert.

_______________________________________________

WS2812b Leuchtdioden
_______________________________________________

WS2812b LEDs sind Vollfarb-LEDs (gruen / rot / blau) und besitzen einen "integrierten
seriellen Controller". Deren Funktionsweise ist in der Theorie relativ einfach (das
Programmieren fand ich dann doch relativ kniffelig).

Mittels einer einzigen Datenleitung empfaengt innerhalb einer Leuchtdiodenreihe die erste
LED Informationen. Diese sind 3 Bytes, jeweils eines fuer den Farbanteil von gruen, rot
und blau. Treffen nach diesen 3 Bytes weitere Bytes ein, werden die empfangenen Bytes
an den Ausgang der LED geschoben und einer weiteren nachgeschalteten LED uebergeben.

Reist der Datenstrom fuer eine gewisse Zeit ab (in der Regel betraegt diese Zeit
50 uSekunden) wird ein neuer Datenframe als Frame fuer die erste LED gewertet.

Eine WS2812b Leuchtdiode hat somit 4 Anschluesse: +Vcc, GND, Data_in und Data_out.

Beispiel: LED-Strang mit 4 LEDs

       +Vcc
       o------------+--------------+---------------+--------------+---------
                    |Vcc           |Vcc            |Vcc           |Vcc
                    |              |               |              |
       Data    +----+----+    +----+----+     +----+----+    +----+----+
       o-------| in  out |----| in  out |-----| in  out |----| in  out |----
               +----+----+    +----+----+     +----+----+    +----+----+
                    |              |               |              |
       GND       GND|           GND|            GND|           GND|
       o------------+--------------+---------------+--------------+---------

In welcher Form liegen die Daten fuer WS2812 Leuchtdioden vor?

Es ist ein relativ einfaches Protokoll, welches jedoch recht ordentlich zeitkritisch ist.
Fuer ein Byte muessen 8 Bits uebertragen werden. Nachdem am Data-Input fuer min.
50 uSekunden ein Lo-Signal angelegt wird, beginnt die Datenuebertragung mit der ersten
Lo-Hi Flanke.

Ein Datenbit wird innerhalb einer Zeitspanne von 1,25 uSekunden uebertragen. Betraegt
die Pulsdauer des Signals 350 nSekunden (n= nano !!!) und 900 nSekunden die Pausedauer,
so wertet die WS2812 dieses als eingehende 0.

Betraegt die Pulsdauer 900nS und die Pausedauer 350nS, wird dieses als eingehende 1
gewertet.

Die Informationen werden in die LED in der Folge: gruen, rot und blau und die einzelnen
Bits mit der hoeheren Wertigkeit uebertragen. 3 Byte zu je 8 Bit benoetigen somit 24
Impulse (mit dem oben beschriebenen Timing).

Dieses Timing mit einem STM8S einzuhalten ist nicht ganz einfach und aus diesem Grund
wurde dieses Softwaremodul fuer einen mit 16 MHz betriebenen STM8 geschrieben.

Der Teil, der fuer den Datenstrom in die erste LED zustaendig ist, wurde mittels Bit-
banging in Assembler kodiert.

Das vorliegende ZIP-Archiv, zu dem diese Readme Datei gehoert, enthaellt alle Dateien,
die zum einfachen Uebersetzen des Demoprogrammes notwendig sind (ein installierter
SDCC Compiler wird vorausgesetzt).

_______________________________________________

Make
_______________________________________________

Bei der Programmierung hat es sich mehr oder weniger durchgesetzt, eine Uebersetzung
eines Quellprogramms die Steuerung der Uebersetzung einer sogenannten Make Datei zu
ueberlassen. Auf Betriebssystemebene wird auf einer Kommandozeile

                                      make

in dem Ordner aufgerufen, in dem sich das Quellprogramm befindet. Selbst bei Be-
nutzung einer IDE wird dieses einem Make ueberlassen, welches jedoch haeufig in die
IDE integriert ist und die Makedatei aus Projekteinstelldaten erzeugt wird. Ueber-
sichtlicher finde ich jedoch, wenn die Makedatei im Text vorliegt um entsprechend
direkt mittels Texteingaben die Programmgenerierung steuern zu koennen.

Zu diesem Zwecke wurde hier Make in 2 Dateien aufgeteilt (case sensitiv):

      - Makefile
      - makefile.mk

Das Makefile ist sehr einfach gestaltet und an sich selbsterklaerend. Hier koennen
Angaben gemacht werden, welche Programmmodule zum Hauptprogramm hinzugefuegt werden
sollen, sowie die Pfade, in denen diese Module liegen koennen.

Im Vorliegenden Falle gibt es fuer einen Upload in die MCU zwei Moeglichkeiten, zum
einen mit der Verwendung eines STLINK v2 oder ueber einen selbst geschriebenen
Bootloader.

                                 FLASHERPROG = 0

verwendet einen Bootloader, der an /dev/ttyUSB0 angeschlossen sein muss,

                                 FLASHERPROG = 1

verwendet einen STLIN v2.

Weitere Sourcesoftware kann mittels

                                 SRCS   +=  nocheinedatei.rel

hinzugefuegt werden. Hier ist zu sagen, dass es hierfuer eine Datei Namens
nocheinedatei.c in den angegebenen Suchpfaden geben muss. Diese wird zu
nocheinedatei.rel uebersetzt.

Makefile inkludiert eine weitere Datei: makefile.mk. Diese wertet die Benutzer-
angaben aus und generiert das Programm im Intel Hex-Format.


