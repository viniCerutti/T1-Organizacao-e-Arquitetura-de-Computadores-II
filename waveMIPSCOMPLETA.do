onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/reset
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/clock
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/i_address
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/instruction
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/ce
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/rw
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/bw
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/d_address
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/data
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/ct/i
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/ct/PS
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/ct/IR
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/NPC_IN
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/RS
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/RT
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/IMED
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/RALU
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/HI
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/LO
add wave -noupdate -height 22 -expand -group Mips -radix hexadecimal /cpu_tb/cpu/dp/MDR
add wave -noupdate -height 22 -expand -group Mips -label {$at} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(1)
add wave -noupdate -height 22 -expand -group Mips -label {$t0} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(8)
add wave -noupdate -height 22 -expand -group Mips -label {$t1} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(9)
add wave -noupdate -height 22 -expand -group Mips -label {$t2} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(10)
add wave -noupdate -height 22 -expand -group Mips -label {$t3} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(11)
add wave -noupdate -height 22 -expand -group Mips -label {$t4} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(12)
add wave -noupdate -height 22 -expand -group Mips -label {$t5} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(13)
add wave -noupdate -height 22 -expand -group Mips -label {$t6} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(14)
add wave -noupdate -height 22 -expand -group Mips -label {$t7} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(15)
add wave -noupdate -height 22 -expand -group Mips -label {$ra} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(31)
add wave -noupdate -height 22 -expand -group Mips -label {$sp} -radix hexadecimal /cpu_tb/cpu/dp/REGS/reg(29)
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/clock
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/reset
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/rw
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/ce
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/address
add wave -noupdate -height 22 -expand -group {Logica de Cola} -radix hexadecimal /cpu_tb/Logica_cola/data
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/mem_ce
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/ce_Serial
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/valor_tx_av
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/tx_dado_ja_lido
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/loadTx_dataReg
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/loadRxDataReg
add wave -noupdate -height 22 -expand -group {Logica de Cola} -radix hexadecimal /cpu_tb/Logica_cola/tx_dataReg
add wave -noupdate -height 22 -expand -group {Logica de Cola} -radix hexadecimal /cpu_tb/Logica_cola/rx_dataReg
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/tx_data
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/tx_av
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/rx_busy
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/rx_start
add wave -noupdate -height 22 -expand -group {Logica de Cola} -radix hexadecimal /cpu_tb/Logica_cola/rx_data
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/State_next
add wave -noupdate -height 22 -expand -group {Logica de Cola} /cpu_tb/Logica_cola/State
add wave -noupdate -height 22 -expand -group {Logica de Cola} -radix hexadecimal /cpu_tb/Logica_cola/auxData
add wave -noupdate -height 22 -expand -group {Interface Serial} /cpu_tb/Interface_Serial/clock
add wave -noupdate -height 22 -expand -group {Interface Serial} /cpu_tb/Interface_Serial/reset
add wave -noupdate -height 22 -expand -group {Interface Serial} -height 22 -expand -group {MEF Autobaud} /cpu_tb/Interface_Serial/Sreg
add wave -noupdate -height 22 -expand -group {Interface Serial} -height 22 -expand -group {MEF Autobaud} /cpu_tb/Interface_Serial/ctr0
add wave -noupdate -height 22 -expand -group {Interface Serial} -height 22 -expand -group {MEF Autobaud} /cpu_tb/Interface_Serial/counter
add wave -noupdate -height 22 -expand -group {Interface Serial} -height 22 -expand -group {MEF Autobaud} /cpu_tb/Interface_Serial/host_cycles
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Receiver /cpu_tb/Interface_Serial/rx_data
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Receiver /cpu_tb/Interface_Serial/rx_busy
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Receiver /cpu_tb/Interface_Serial/serial_clk
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Receiver /cpu_tb/Interface_Serial/rx_start
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Receiver /cpu_tb/Interface_Serial/rxd
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Sender /cpu_tb/Interface_Serial/txd
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Sender /cpu_tb/Interface_Serial/tx_av
add wave -noupdate -height 22 -expand -group {Interface Serial} -expand -group Sender /cpu_tb/Interface_Serial/tx_data
add wave -noupdate -expand -group Periferico /cpu_tb/perifericoMap/clock
add wave -noupdate -expand -group Periferico /cpu_tb/perifericoMap/reset
add wave -noupdate -expand -group Periferico /cpu_tb/perifericoMap/enviar_dado_sinc
add wave -noupdate -expand -group Periferico /cpu_tb/perifericoMap/contVetor
add wave -noupdate -expand -group Periferico /cpu_tb/perifericoMap/memInf
add wave -noupdate -expand -group Periferico /cpu_tb/perifericoMap/State
add wave -noupdate -expand -group Periferico -expand -group SenderPeriferico /cpu_tb/perifericoMap/contBitsSend
add wave -noupdate -expand -group Periferico -expand -group SenderPeriferico /cpu_tb/perifericoMap/txd
add wave -noupdate -expand -group Periferico -expand -group ReceiverPeriferico /cpu_tb/perifericoMap/contBitsReceiver
add wave -noupdate -expand -group Periferico -expand -group ReceiverPeriferico /cpu_tb/perifericoMap/rxd
add wave -noupdate -expand -group Periferico -expand -group ReceiverPeriferico /cpu_tb/perifericoMap/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {113826567 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 294
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
WaveRestoreZoom {113528135 ps} {113968337 ps}
