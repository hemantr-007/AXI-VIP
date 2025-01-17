#set MAS_PKG "../ENV/AXI_SLAVE_AGENT/axi_slv_pkg.sv"
#set ENV_PKG "../ENV/axi_env_pkg.sv"
#set TEST_PKG "../TEST/axi_test_pkg.sv"
#set TOP_TB "../TOP/axi_tb_top.sv"
#set TOP_MODULE_NAME "axi_tb_top"
#set AGENT_DIR "+incdir+../ENV/AXI_SLAVE_AGENT"
#set ENV_DIR "+incdir+../ENV"
#set TEST_DIR "+incdir+../TEST"
#set TEST_NAME ${1}
#set SEED ${2}

#vlog $(SLV_PKG) $(ENV_PKG) $(TEST_PKG) $(TOP_TB) $(AGENT_DIR) $(ENV_DIR) $(TEST_DIR)
#vsim -novopt $(TOP_MODULE_NAME) +UVM_TESTNAME=$(TEST_NAME) -sv_seed $(SEED) 
vlog ../ENV/AXI_MASTER_AGENT/axi_mas_pkg.sv ../ENV/AXI_SLAVE_AGENT/axi_slv_pkg.sv ../ENV/axi_env_pkg.sv ../TEST/axi_test_pkg.sv ../TOP/axi_tb_top.sv +incdir+../ENV/AXI_MASTER_AGENT +incdir+../ENV/AXI_SLAVE_AGENT +incdir+../ENV +incdir+../TEST
vsim -novopt axi_tb_top +UVM_TESTNAME=${1} -l ${1}.log -sv_seed ${2}
do ./wave.do
run -all