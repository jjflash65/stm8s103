# stm8s103
STM8S103F3P6 - Hardwareanbindung und Demoprogramme

Dieses hier soll all denjenigen helfen, die zum ersten Mal mit einem (vor der Pandemie) aeusserst preiswerten STM8S103 experimentieren wollen.
Hier finden sich Beispielprogramme zu den gaengigen ersten Versuchen in Verbindung mit der Mikrocontrollerprogrammierung:

- SPI Anbindung
- I2C Anbindung
- UART (serielle Schnittstelle)
- eigenes printf
- Standardtextdisplays
- farbige graphische Displays
- N5110 Display
- ansprechen der GPIO

Dieses Setup hier koennte man als kleines "Framework" bezeichnen, da es die Hardware der STM8 Controller sehr stark abstrahiert. Am besten schaut man sich
die einzelnen Verzeichnisse durch und schaut sich dort den Sourcecode an. Sehr schnell duerfte hier dann klar werden (bspw. im Verzeichnis blinky) wie
die einzelnen GPIO's angesprochen werden. Saemtliche Libraries finden sich im Ordner ./src , die hierzu passenden Header im Ordner ./include

Um ein eigenes neues Projekt zu beginnen, ist es ratsam, einen bestehenden Ordner unter neuem Namen zu speichern und das hierin enthaltene
Makefile den eigenen Beduerfnissen anzupassen. Die einzelnen Makefiles ihrerseits sind - denke ich - selbsterklaerend: es werden nur Angaben zur
Frequenz, dem Bausteinetype und den einzubindenen Source-Bibliotheken erwartet. Der funktionale Teil eines Makefiles liegt im STM8 Stammverzeichnis und 
heißt: makefile.mk

Fuer diejenigen, die gerne mit einem Bootloader arbeiten gibt es unter:

https://www.mikrocontroller.net/topic/425431#5745227

einen Bootloader, mittels dem der STM8 fast schon so einfach geflasht werden kann, wie ein Arduino. Einzig der Bootloader muß ein einziges mal,
bspw. mittels eines ST-LINK v2 auf den Controller gebracht werden.
