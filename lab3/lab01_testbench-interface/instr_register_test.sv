/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

module instr_register_test(tb_ifc tb_ifc);
  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  
  
  

  //timeunit 1ns/1ns;

  int seed = 555;

  initial begin
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    tb_ifc.cb.write_pointer  <= 5'h00;         // initialize write pointer
    tb_ifc.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    tb_ifc.cb.load_en        <= 1'b0;          // initialize load control line
    tb_ifc.cb.reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @tb_ifc.cb ;     // hold in reset for 2 clock cycles
    tb_ifc.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @tb_ifc.cb tb_ifc.cb.load_en <= 1'b1;  // enable writing to register
    repeat (3) begin
      @tb_ifc.cb randomize_transaction;
      @tb_ifc.cb print_transaction;
    end
    @tb_ifc.cb tb_ifc.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=0; i<=2; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @tb_ifc.cb tb_ifc.cb.read_pointer <= i;
      @tb_ifc.cb print_results;
    end

    @tb_ifc.cb ;
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
    tb_ifc.cb.operand_a     <= $random(seed)%16;                 // between -15 and 15
    tb_ifc.cb.operand_b     <= $unsigned($random)%16;            // between 0 and 15
    tb_ifc.cb.opcode        <= opcode_t'($unsigned($random)%8);  // between 0 and 7, cast to opcode_t type
    tb_ifc.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ",tb_ifc.cb.write_pointer);
    $display("  opcode = %0d (%s)", tb_ifc.cb.opcode, tb_ifc.cb.opcode.name);
    $display("  operand_a = %0d",   tb_ifc.cb.operand_a);
    $display("  operand_b = %0d\n", tb_ifc.cb.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", tb_ifc.cb.read_pointer);
    $display("  opcode = %0d (%s)", tb_ifc.cb.instruction_word.opc, tb_ifc.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   tb_ifc.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", tb_ifc.cb.instruction_word.op_b);
  endfunction: print_results

endmodule: instr_register_test
