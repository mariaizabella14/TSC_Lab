onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/test_clk
add wave -noupdate /top/tb_if/cb/instruction_word
add wave -noupdate /top/tb_if/cb/read_pointer
add wave -noupdate /top/tb_if/cb/write_pointer
add wave -noupdate /top/tb_if/cb/operand_b
add wave -noupdate /top/tb_if/cb/operand_a
add wave -noupdate /top/tb_if/cb/opcode
add wave -noupdate /top/tb_if/cb/reset_n
add wave -noupdate /top/tb_if/cb/load_en
add wave -noupdate /top/tb_if/cb/cb_event
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {57130 ps} {647625 ps}
