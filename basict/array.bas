10 print "Geben Sie 4 Zahlen ein"
20 for i= 1 to 4
30 print "Zahl ",i,": ",
40 input z
50 @(i)= z
60 next i
70 print "Die Zahlen waren:"
80 for i= 1 to 4
90 z= @(i)
100 print "Zahl ",i,": ",z
110 next i
