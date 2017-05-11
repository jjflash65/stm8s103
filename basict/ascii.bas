300 print "Die Ascii Tabelle"
302 print 
305 b= 0
310 for a= 32 to 127
315 if a> 99 goto 320
317 func 1,32
320 print a,": ",
325 func 1,a
330 print "  ",
340 b= b+1
350 if b< 10 goto 380
360 func 1,10
370 func 1,13
375 b= 0
380 next a
390 print
400 stop
