/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

tb_ifc tb_if(
.clk(test_clk)
);  

  // instantiate testbench and connect ports
  instr_register_test test (
    .clk(test_clk),
    .load_en(tb_if.load_en),
    .reset_n(tb_if.reset_n),
    .operand_a(tb_if.operand_a),
    .operand_b(tb_if.operand_b),
    .opcode(tb_if.opcode),
    .write_pointer(tb_if.write_pointer),
    .read_pointer(tb_if.read_pointer),
    .instruction_word(tb_if.instruction_word)
   );

 

  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(tb_if.load_en),
    .reset_n(tb_if.reset_n),
    .operand_a(tb_if.operand_a),
    .operand_b(tb_if.operand_b),
    .opcode(tb_if.opcode),
    .write_pointer(tb_if.write_pointer),
    .read_pointer(tb_if.read_pointer),
    .instruction_word(tb_if.instruction_word)
   );

  // clock oscillators
  initial begin
    clk <= 0;
    forever #5  clk = ~clk;
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top
