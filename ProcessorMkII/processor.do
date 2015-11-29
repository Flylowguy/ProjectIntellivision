vsim processor
view

add wave -hex instructionIn
add wave clock
add wave reset
add wave -dec raOut
add wave -dec rbOut
add wave -dec rzOut
add wave -dec ryOut
add wave bInvOut
add wave rfWriteOut


force clock 0 0, 1 1 -repeat 2
force reset 0 0

force instructionIn 00000000000001000000000000000000 0
force instructionIn 00000000100001100000000000000000 10
force instructionIn 00011000100010000000010000000000 20
force instructionIn 00100000000010100001000000000000 30
force instructionIn 00011000100011000000110000000000 40
force instructionIn 00100000110011100000100000000000 50

run 60
