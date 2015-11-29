vsim SomeAssemblyRequired_lab7
view wave
add wave A
add wave B
add wave alu_op
add wave a_inv
add wave b_inv
add wave fOut
add wave C
add wave V
add wave N
add wave Z

force A 00000000000000000111111111111111 0
force B 00001111111111111000000000000000 0
force a_inv 0 0
force b_inv 0 0
force alu_op 00 0
force alu_op 01 30
force alu_op 10 60
force alu_op 11 90
force a_inv 1 120
force alu_op 00 120
force alu_op 01 150
force alu_op 10 180
force alu_op 11 210
force a_inv  0 240
force b_inv  1 240
force alu_op 00 240
force alu_op 01 270
force alu_op 10 300
force alu_op 11 330
run 360
