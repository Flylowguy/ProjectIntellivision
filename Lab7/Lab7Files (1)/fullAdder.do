vsim fullAdder

view wave

add wave a
add wave b
add wave s
add wave cIn
add wave cOut

force cIn 0 0
force a 0 0
force b 0 0
force a 0 30
force b 1 30
force a 1 60
force b 0 60
force a 1 90
force b 1 90

force cIn 1 120
force a 0 120
force b 0 120
force a 0 150
force b 1 150
force a 1 180
force b 0 180
force a 1 210
force b 1 210

run 240
