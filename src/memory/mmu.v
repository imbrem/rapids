// A simple memory management module for the Rapids microprocessor.
// For now, this is just a segment of linear memory, but if possible we plan to
// implement paging.
//
// Jad Ghalayini, March 2019

module MMU(
  input clk, // The clk
  input reset_n,
  input[31:0] instr_addr, // Instruction address
  input[31:0] data_addr, // Data address
  input[31:0] data_in, // Data to write
  input rd, // Read-enable for data (to save on unecessary paging)
  input wd, // Write-enable for data
  output reg[31:0] instr, // The read instruction
  output reg[31:0] data, // The read data
  output wait_instr, // High if the instruction needs time to load
  output wait_data, // High if the data needs time to load
  output instr_segv, // High if invalid instruction address
  output data_segv // High if invalid data address
  );

  reg[31:0] special[14:0];
  reg[31:0] memory[127:0];

  wire[6:0] t_instr_addr = (instr_addr - 16);
  wire[6:0] t_data_addr = (data_addr - 16);
  wire[3:0] s_data_addr = (data_addr - 1);

  wire instr_special = t_instr_addr < 16;
  wire data_special = t_data_addr < 16;
  wire instr_too_high = t_instr_addr >= 128;
  wire data_too_high = t_data_addr >= 128;

  assign instr_segv = (instr_addr == 0) | instr_too_high | instr_special;
  assign data_segv = (data_addr == 0) | data_too_high;

  assign wait_data = 1'b0;
  assign wait_instr = 1'b0;

  //reset entire memory

  genvar i;
  for(i = 0; i < 128; i = i + 1) begin : reset_memory
  always @(reset_n) begin
    if(reset_n) memory[i] = 32'b0;
  end
  end
  genvar j;
  for(j = 0; j < 15; j = j + 1) begin : reset_special_memory
    always @(reset_n) begin
      if(reset_n) special[j] = 32'b0;
    end
  end


  always@(posedge clk) begin
    if(data_segv) begin
      data = 32'hXXXXXXXX;
    end
    else if(data_special) begin
      if(wd) special[s_data_addr] = data_in;
      if(rd) data = special[s_data_addr];
      else data = 32'hXXXXXXXX;
    end
    else begin
      if(wd) memory[t_data_addr] = data_in;
      if(rd) data = memory[t_data_addr];
      else data = 32'hXXXXXXXX;
    end
    if(instr_segv) begin
      instr = 32'hXXXXXXXX;
    end
    else begin
      instr = memory[t_instr_addr];
    end
  end

endmodule
