all: work rtl agents tb sim_all 
#以空格为间隙
work:
	vlib work 
	#该命令的作用是在该目录下建立一个work目录，请注意不要用操作系统来新建一个work的文件夹，因为用操作系统建立的work文件夹并没有ModelSim SE自动生成的_info文件。

rtl:
	vlog ../rtl/uart/*.sv +cover=sbf
	#vlog 该命令的作用是编译这些文件，要注意的是文件可以单独分开编译，但是一定要先编译被调用的文件。
	#+cover=sbf 
	
agents:
	vlog ../src/module_if.sv
	vlog ../src/param_def.v
	vlog +incdir+../src/apb_agent ../src/apb_agent/apb_agent_pkg.sv
	#vlog +incdir+../ 为后面的编译添加文件


tb:
	vlog +incdir+../src/apb_agent ../src/reg_env.sv
	vlog +incdir+../src/apb_agent ../src/base_test.sv
	vlog +incdir+../src/apb_agent ../src/apb_test.sv
	vlog +incdir+../src/apb_agent ../src/tb.sv

sim_all: sim_apb_test

sim_apb_test:
	vsim tb +UVM_TESTNAME=apb_test -do "run -all"
	#tb，运行tb中的apb_test任务


clean:
	rm -r work
	rm *.log transcript vsim.* *.ucdb
	rm -r covhtmlreport

tarball: clean tgz

tgz:
	@(cd ../..; \
	tar -zcf uart_example/sim/uart_example.tgz \
	uart_example/agents \
	uart_example/docs \
	uart_example/protocol_monitor \
	uart_example/rtl \
	uart_example/uvm_tb \
	uart_example/README \
	uart_example/sim/Makefile)

