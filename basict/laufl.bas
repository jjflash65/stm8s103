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
