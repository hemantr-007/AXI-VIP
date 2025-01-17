onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {INTERFACE } -radix hexadecimal /axi_tb_top/axi_mas_vif_0/ACLK
add wave -noupdate -expand -group {INTERFACE } -radix hexadecimal /axi_tb_top/axi_mas_vif_0/ARESETn
add wave -noupdate -expand -group {INTERFACE } -radix hexadecimal /axi_tb_top/axi_mas_vif_0/ADDR_WIDTH
add wave -noupdate -expand -group {INTERFACE } -radix hexadecimal /axi_tb_top/axi_mas_vif_0/DATA_WIDTH
add wave -noupdate -expand -group {INTERFACE } -radix hexadecimal /axi_tb_top/axi_mas_vif_0/SIZE
add wave -noupdate -expand -group WRITE_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AWVALID
add wave -noupdate -expand -group WRITE_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AWREADY
add wave -noupdate -expand -group WRITE_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AW_ID
add wave -noupdate -expand -group WRITE_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AW_BURST
add wave -noupdate -expand -group WRITE_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AW_LEN
add wave -noupdate -expand -group WRITE_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AW_SIZE
add wave -noupdate -expand -group WRITE_DATA_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/WVALID
add wave -noupdate -expand -group WRITE_DATA_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/WREADY
add wave -noupdate -expand -group WRITE_DATA_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_ID
add wave -noupdate -expand -group WRITE_DATA_MAS -radix unsigned /axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_DATA
add wave -noupdate -expand -group WRITE_DATA_MAS -radix hexadecimal -childformat {{{/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[3]} -radix unsigned} {{/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[2]} -radix unsigned} {{/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[1]} -radix unsigned} {{/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[0]} -radix unsigned}} -subitemconfig {{/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[3]} {-height 15 -radix unsigned} {/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[2]} {-height 15 -radix unsigned} {/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[1]} {-height 15 -radix unsigned} {/axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB[0]} {-height 15 -radix unsigned}} /axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_STRB
add wave -noupdate -expand -group WRITE_DATA_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/W_LAST
add wave -noupdate -expand -group WRITE_RESP_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/BVALID
add wave -noupdate -expand -group WRITE_RESP_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/BREADY
add wave -noupdate -expand -group READ_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AR_VALID
add wave -noupdate -expand -group READ_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AR_READY
add wave -noupdate -expand -group READ_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AR_ID
add wave -noupdate -expand -group READ_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AR_BURST
add wave -noupdate -expand -group READ_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AR_LEN
add wave -noupdate -expand -group READ_REQ_MAS -radix hexadecimal /axi_tb_top/axi_mas_vif_0/mas_drv_cb/AR_SIZE
add wave -noupdate -expand -group READ_DATA_MAS /axi_tb_top/axi_mas_vif_0/mas_drv_cb/RVALID
add wave -noupdate -expand -group READ_DATA_MAS /axi_tb_top/axi_mas_vif_0/mas_drv_cb/RREADY
add wave -noupdate -expand -group READ_DATA_MAS /axi_tb_top/axi_mas_vif_0/mas_drv_cb/R_RESP
add wave -noupdate -expand -group READ_DATA_MAS /axi_tb_top/axi_mas_vif_0/mas_drv_cb/R_LAST
add wave -noupdate -expand -group READ_DATA_MAS /axi_tb_top/axi_mas_vif_0/mas_drv_cb/R_ID
add wave -noupdate -expand -group READ_DATA_MAS /axi_tb_top/axi_mas_vif_0/mas_drv_cb/R_DATA
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AWVALID
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AWREADY
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AW_SIZE
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AW_ADDR_q
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AW_LEN
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AW_ID
add wave -noupdate -expand -group WRITE_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AW_BURST
add wave -noupdate -expand -group WRITE_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/WVALID
add wave -noupdate -expand -group WRITE_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/WREADY
add wave -noupdate -expand -group WRITE_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/W_DATA
add wave -noupdate -expand -group WRITE_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/W_STRB
add wave -noupdate -expand -group WRITE_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/W_LAST
add wave -noupdate -expand -group WRITE_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/W_ID
add wave -noupdate -expand -group WRITE_RSP_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/BVALID
add wave -noupdate -expand -group WRITE_RSP_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/BREADY
add wave -noupdate -expand -group WRITE_RSP_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/B_ID
add wave -noupdate -expand -group WRITE_RSP_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/B_RESP
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_VALID
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_READY
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_SIZE
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_LEN
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_ID
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_ADDR_q
add wave -noupdate -expand -group READ_REQ_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/AR_BURST
add wave -noupdate -expand -group READ_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/RVALID
add wave -noupdate -expand -group READ_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/RREADY
add wave -noupdate -expand -group READ_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/R_RESP
add wave -noupdate -expand -group READ_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/R_LAST
add wave -noupdate -expand -group READ_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/R_ID
add wave -noupdate -expand -group READ_DATA_SLV /axi_tb_top/axi_slv_vif_0/slv_mon_cb/R_DATA
add wave -noupdate -expand -label sim:/axi_tb_top/axi_slv_vif_0/Group1 -group {Region: sim:/axi_tb_top/axi_slv_vif_0} /axi_tb_top/axi_slv_vif_0/WVALID
add wave -noupdate -expand -label sim:/axi_tb_top/axi_slv_vif_0/Group1 -group {Region: sim:/axi_tb_top/axi_slv_vif_0} /axi_tb_top/axi_slv_vif_0/WREADY
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/WVALID
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/WREADY
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/RVALID
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/RREADY
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/BVALID
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/BREADY
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/AWVALID
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/AWREADY
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/AR_VALID
add wave -noupdate -expand -group SLV_DRV_CB_SIGNAL /axi_tb_top/axi_slv_vif_0/slv_drv_cb/AR_READY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {1050 ns}
