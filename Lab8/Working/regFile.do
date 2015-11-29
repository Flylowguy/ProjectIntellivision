vsim regFile
view wave
add wave reset
add wave enable
add wave clock
add wave regD
add wave regS
add wave regT
add wave dataD
add wave dataS
add wave dataT
force reset 0 0
force clock 1 0, 0 10 -repeat 20
force dataD 00010010010010010100100010010010 0
force enable 1 0
force regD 10001 0
force regS 10001 30
force regD 11111 60
force dataD 10010010010010010100100010011110 60
force regS 11111 90
force regD 00011 120
force dataD 01111111111111111111111111111111 120
force regT 00011 150
run 180
