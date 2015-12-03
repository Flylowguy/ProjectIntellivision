vsim processor
view wave

add wave clock
add wave -hex raOut
add wave -hex rbOut
add wave -hex rdOut
add wave -hex instructionout
add wave -hex muxMOut
add wave -hex muxMSel
add wave psOutput

add wave KEY
add wave SW
add wave LEDG
add wave HEX

force KEY 1011 0

force clock 0 0, 1 1000 -repeat 2000

run 200000
