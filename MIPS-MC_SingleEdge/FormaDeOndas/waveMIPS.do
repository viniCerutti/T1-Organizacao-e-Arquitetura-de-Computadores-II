onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/reset
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/clock
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/i_address
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/instruction
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/ce
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/rw
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/bw
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/d_address
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/data
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/ct/i
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/ct/PS
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/ct/IR
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/NPC_IN
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/RS
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/RT
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/IMED
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/RALU
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/HI
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/LO
add wave -noupdate -radix hexadecimal /cpu_tb/cpu/dp/MDR
add wave -noupdate -label {$at} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(1)
add wave -noupdate -label {$t0} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(8)
add wave -noupdate -label {$t1} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(9)
add wave -noupdate -label {$t2} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(10)
add wave -noupdate -label {$t3} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(11)
add wave -noupdate -label {$t4} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(12)
add wave -noupdate -label {$t5} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(13)
add wave -noupdate -label {$t6} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(14)
add wave -noupdate -label {$t7} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(15)
add wave -noupdate -label {$ra} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(31)
add wave -noupdate -label {$sp} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(29)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 230
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1795 ps}
