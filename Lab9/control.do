vsim controlUnit
view wave

add wave opCode
add wave Cond
add wave opx
add wave clock
add wave reset
add wave mfc


add wave alu_op
add wave rf_write
add wave b_inv
add wave ir_enable
add wave pc_enable

force clock 0 0, 1 10 -repeat 20
force reset 0 0
force mfc 1 0
force Cond 1111

force opCode 00000 0
force opx 0000000 0, 0000001 100, 0000010 200, 0000011 300, 0000100 400

run 500
