module meta_test;
  reg err;
  reg clk; // The clock
  reg[31:0] instr_addr; // Instruction address
  reg[31:0] data_addr; // Data address
  reg[31:0] data_in; // Data to write
  reg rd; // Read-enable for data (to save on unecessary paging)
  reg wd; // Write-enable for data
  wire[31:0] instr; // The read instruction
  wire[31:0] data; // The read data
  wire wait_instr; // High if the instruction needs time to load
  wire wait_data; // High if the data needs time to load
  wire instr_segv; // High if invalid instruction address
  wire data_segv; // High if invalid data address

  MMU mmu(
    .clk(clk),
    .instr_addr(instr_addr),
    .data_addr(data_addr),
    .data_in(data_in),
    .rd(rd),
    .wd(wd),
    .instr(instr),
    .data(data),
    .wait_instr(wait_instr),
    .wait_data(wait_data),
    .instr_segv(instr_segv),
    .data_segv(data_segv)
  );

  always begin
    clk = 1'b0; #1; clk = 1'b1; #1;
  end

  initial begin;
    $dumpfile("build/mmu_test.vcd");
    $dumpvars;
    err = 0;
    if (!err) begin
      $display("MMU TEST: All good!"); end
    else begin
      $display("MMU TEST: Had errors!"); end
    $finish;
  end
endmodule
