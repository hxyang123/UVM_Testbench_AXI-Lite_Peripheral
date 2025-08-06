vlib work
vlog +acc +cover=bcest -sv \
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

vsim -coverage axi_tb_top
run -all
vcover report -html -details -output covhtmlreport/index.html