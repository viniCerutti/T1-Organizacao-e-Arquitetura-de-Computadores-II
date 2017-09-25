onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /serial_tb/serial_inst/reset
add wave -noupdate /serial_tb/serial_inst/clock
add wave -noupdate -height 30 -expand -group {MEF Autobaud} /serial_tb/serial_inst/Sreg
add wave -noupdate -height 30 -expand -group {MEF Autobaud} -radix unsigned /serial_tb/serial_inst/ctr0
add wave -noupdate -height 30 -expand -group {MEF Autobaud} -radix unsigned /serial_tb/serial_inst/counter
add wave -noupdate -height 30 -expand -group {MEF Autobaud} -radix unsigned /serial_tb/serial_inst/host_cycles
add wave -noupdate -height 30 -expand -group Sender /serial_tb/serial_inst/txd
add wave -noupdate -height 30 -expand -group Sender /serial_tb/serial_inst/tx_av
add wave -noupdate -height 30 -expand -group Sender -radix hexadecimal /serial_tb/serial_inst/tx_data
add wave -noupdate -height 30 -expand -group Receiver -radix hexadecimal /serial_tb/serial_inst/rx_data
add wave -noupdate -height 30 -expand -group Receiver /serial_tb/serial_inst/rx_busy
add wave -noupdate -height 30 -expand -group Receiver /serial_tb/serial_inst/serial_clk
add wave -noupdate -height 30 -expand -group Receiver /serial_tb/serial_inst/rx_start
add wave -noupdate -height 30 -expand -group Receiver /serial_tb/serial_inst/rxd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11069484388 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 322
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
WaveRestoreZoom {0 ps} {360569526 ps}
