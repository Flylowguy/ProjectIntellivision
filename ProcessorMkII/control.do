vsim controlUnit
view

add wave clock
add wave opCode
add wave opx
add wave alu_op
add wave b_inv
add wave rf_write
add wave reset
add wave stage
add wave mfc


force clock 0 0, 1 40 -repeat 80
force reset 0 0

force mfc 1 0
force opCode 00000 0
force opx 0000001 0

run 500
