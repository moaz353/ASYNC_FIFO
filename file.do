quit -sim 

vlib work 

vlog 2FF_synchronizers_module.v  FIFO_module.v Read_pointer_handler.v Write_pointer_handler.v TOP_module.v TOP_module_TP.v

vsim -voptargs=+acc Top_module_tb 

add wave -position insertpoint  \
sim:/Top_module_tb/DATA_WIDTH_P \
sim:/Top_module_tb/MEM_DEPTH_P \
sim:/Top_module_tb/ADDR_SIZE_P \
sim:/Top_module_tb/wclk \
sim:/Top_module_tb/rclk \
sim:/Top_module_tb/wrst_n \
sim:/Top_module_tb/rrst_n \
sim:/Top_module_tb/wr_en \
sim:/Top_module_tb/rd_en \
sim:/Top_module_tb/data_in \
sim:/Top_module_tb/data_out \
sim:/Top_module_tb/full \
sim:/Top_module_tb/empty
add wave -position insertpoint  \
sim:/Top_module_tb/DUT/FIFO/mem
add wave -position insertpoint  \
sim:/Top_module_tb/DUT/write_pointer/b_r_ptr_sync
add wave -position insertpoint  \
sim:/Top_module_tb/DUT/read_pointer/b_w_ptr_sync


add wave -position insertpoint  \
sim:/Top_module_tb/DUT/b_w_ptr \
sim:/Top_module_tb/DUT/b_r_ptr
add wave -position insertpoint  \
sim:/Top_module_tb/DUT/FIFO/b_w_ptr \
sim:/Top_module_tb/DUT/FIFO/b_r_ptr


run -all
