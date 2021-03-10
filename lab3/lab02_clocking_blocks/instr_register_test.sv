/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 *
 * SystemVerilog Training Workshop.
 * Copyright 2006, 2013 by Sutherland HDL, Inc.
 * Tualatin, Oregon, USA.  All rights reserved.
 * www.sutherland-hdl.com
 **********************************************************************/

module instr_register_test (tb_ifc io);  // interface port

  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  int seed = 555;

  initial begin
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    io.write_pointer = 5'h00;      // initialize write pointer
    io.read_pointer  = 5'h1F;      // initialize read pointer
    io.load_en       = 1'b0;       // initialize load control line
    io.reset_n       = 1'b0;       // assert reset_n (active low)
    repeat (2) @(posedge io.clk) ;  // hold in reset for 2 clock cycles
    io.reset_n       = 1'b1;       // assert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge io.clk) io.load_en = 1'b1;  // enable writing to register
    repeat (3) begin
      @(posedge io.clk) randomize_transaction;
      @(negedge io.clk) print_transaction;
    end
    @(posedge io.clk) io.load_en = 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=0; i<=2; i++) begin
      // A later lab will replace this loop with iterating through a
      // scoreboard to determine which address were written and the
      // expected values to be read back
      @(posedge io.clk) io.read_pointer = i;
      @(negedge io.clk) print_results;
    end

    @(posedge io.clk) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  end

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    io.operand_a     = $random(seed)%16;                 // between -15 and 15
    io.operand_b     = $unsigned($random)%16;            // between 0 and 15
    io.opcode        = opcode_t'($unsigned($random)%8);  // between 0 and 7, cast to opcode_t type
    io.write_pointer = temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", io.write_pointer);
    $display("  opcode = %0d (%s)", io.opcode, io.opcode.name);
    $display("  operand_a = %0d",   io.operand_a);
    $display("  operand_b = %0d\n", io.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", io.read_pointer);
    $display("  opcode = %0d (%s)", io.instruction_word.opc, io.instruction_word.opc.name);
    $display("  operand_a = %0d",   io.instruction_word.op_a);
    $display("  operand_b = %0d\n", io.instruction_word.op_b);
  endfunction: print_results

endmodule: instr_register_test
