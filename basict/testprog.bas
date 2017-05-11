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
