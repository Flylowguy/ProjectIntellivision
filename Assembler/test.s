lw  r2,20(r0)
lw  r3,21(r0)
addi  r5,r0,4 
addi  r6,r0,12 
LOOP lw  r4,0(r2) 
sw  r5,0(r3) 
cmp  r5,r4 
b eq LEDS
b  LOOP
LEDS stw  r6,0(r3)
lw  r4,0(r2) 
cmp  r5,r4 
b eq LEDS
b  LOOP
