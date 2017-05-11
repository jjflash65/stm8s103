10 print "Lauflicht mit Array-Muster"
20 w= 3
30 for z= 1 to 6
40 @(z)= w
50 w= w*2
60 next z
70 @(7)= 129
80 for z= 1 to 7
90 w= @(z)
95 print w
100 scall 3,w
110 gosub 300
120 next z
130 goto 80
300 rem ##############
310 rem DELAY
320 rem ##############
330 for d= 1 to 20000
335 a= a+1
340 next d
350 return
