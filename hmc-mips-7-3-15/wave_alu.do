onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/ph1
add wave -noupdate -format Logic /testbench/ph2
add wave -noupdate -format Logic -radix hexadecimal /testbench/reset
add wave -noupdate -format Literal -radix hexadecimal /testbench/writedata
add wave -noupdate -format Literal -radix hexadecimal /testbench/dataadr
add wave -noupdate -format Logic -radix hexadecimal /testbench/memwrite
add wave -noupdate -format Literal -radix hexadecimal /testbench/dut/thechip/mips/instrF
add wave -noupdate -format Logic -radix hexadecimal /testbench/dut/thechip/mips/activeexception
add wave -noupdate -format Literal -radix hexadecimal /testbench/dut/thechip/mips/pcF
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24854 ps} 0}
configure wave -namecolwidth 294
configure wave -valuecolwidth 73
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
update
WaveRestoreZoom {394907714 ps} {395004858 ps}
