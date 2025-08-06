# Makefile for AXI-Lite UVM Testbench using Questa/Modelsim

TOP_MODULE = axi_tb_top
SIM_LIB = work
UVM_HOME ?= $(QUESTA_HOME)/uvm-1.2

SV_FILES = \
	axi_transaction.sv \
	axi_sequence.sv \
	axi_driver.sv \
	axi_monitor.sv \
	axi_sequencer.sv \
	axi_agent.sv \
	axi_env.sv \
	axi_scoreboard.sv \
	axi_test.sv \
	axi_lite_if.sv \
	axi_lite_slave.v \
	axi_tb_top.sv

all: compile run coverage

compile:
	vlib $(SIM_LIB)
	vlog +acc +cover=bcest -sv -work $(SIM_LIB) $(SV_FILES)

run:
	vsim -c -coverage -assertdebug -do "run -all; quit -f" $(TOP_MODULE)

coverage:
	vcover report -details -html coverage.ucdb

clean:
	rm -rf transcript vsim.wlf work *.ucdb covhtmlreport

# make # Compile, run, and generate coverage report
# make compile
# make run
# make coverage
# make clean