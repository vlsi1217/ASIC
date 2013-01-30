onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /multdivtest/dut/ph1
add wave -noupdate -format Logic /multdivtest/dut/ph2
add wave -noupdate -format Logic /multdivtest/dut/reset
add wave -noupdate -format Logic /multdivtest/dut/start
add wave -noupdate -format Logic /multdivtest/dut/muldivb
add wave -noupdate -format Logic /multdivtest/dut/signedop
add wave -noupdate -format Logic /multdivtest/dut/cin
add wave -noupdate -format Logic /multdivtest/dut/yzero
add wave -noupdate -format Logic /multdivtest/dut/srchinv
add wave -noupdate -format Logic /multdivtest/dut/qi
add wave -noupdate -format Logic /multdivtest/dut/run
add wave -noupdate -format Logic /multdivtest/dut/done
add wave -noupdate -format Logic /multdivtest/dut/init
add wave -noupdate -format Logic /multdivtest/dut/muldivbsaved
add wave -noupdate -format Logic /multdivtest/dut/signedopsaved
add wave -noupdate -format Logic /multdivtest/dut/cout
add wave -noupdate -format Literal /multdivtest/dut/prodhextra
add wave -noupdate -format Literal /multdivtest/dut/prodhsel
add wave -noupdate -format Literal /multdivtest/dut/prodlsel
add wave -noupdate -format Literal /multdivtest/dut/srchsel
add wave -noupdate -format Literal /multdivtest/dut/ysel
add wave -noupdate -format Literal /multdivtest/dut/y
add wave -noupdate -format Literal /multdivtest/dut/prodh
add wave -noupdate -format Literal /multdivtest/dut/ysaved
add wave -noupdate -format Literal /multdivtest/dut/prodlsh
add wave -noupdate -format Literal /multdivtest/dut/nextprodl
add wave -noupdate -format Literal /multdivtest/dut/x
add wave -noupdate -format Literal /multdivtest/dut/prodl
add wave -noupdate -format Literal /multdivtest/dut/nextprodh
add wave -noupdate -format Literal /multdivtest/dut/yy
add wave -noupdate -format Literal /multdivtest/dut/srchplusyy
add wave -noupdate -format Literal /multdivtest/dut/srch1
add wave -noupdate -format Literal /multdivtest/dut/prodhsh
add wave -noupdate -format Literal /multdivtest/dut/srch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
update
WaveRestoreZoom {39999050 ps} {40000050 ps}
