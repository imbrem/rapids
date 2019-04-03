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
  output data_segv, // High if invalid data address
  output[8:0] vga_x,
  output[7:0] vga_y,
  output[23:0] vga_color,
  output vga_plot
  );

  localparam VGA_POS = 15'h1;

  reg[31:0] special[14:0];
  reg[31:0] memory[127:0];

  wire data_rd_segv;
  wire data_wd_segv;

  assign data_segv = (rd & data_rd_segv) | (wd & data_wd_segv);

  wire[6:0] t_instr_addr = (instr_addr - 16);
  wire[6:0] t_data_addr = (data_addr - 16);
  wire[3:0] s_data_addr = (data_addr - 1);

  wire init_instr = instr_addr == 0;
  wire instr_special = instr_addr < 16 & instr_addr != 0;
  wire data_special = data_addr < 16;
  wire instr_too_high = t_instr_addr >= 128;
  wire data_too_high = t_data_addr >= 128;

  // Plot to the VGA if and only if we write to the appropriate range
  assign vga_plot = (data_addr[31:17] == VGA_POS) & wd;
  // X, Y on the VGA are just the first 17 bits of the address
  assign vga_y = data_addr[16:9];
  assign vga_x = data_addr[8:0];
  // Color is just the data being written, or rather the first 24 bits of it
  assign vga_color = data_in[23:0];

  assign instr_segv = instr_too_high | instr_special;
  assign data_rd_segv = (data_addr == 0) | data_too_high;
  assign data_wd_segv = (data_addr == 0)
    | ((data_addr[31:17] != VGA_POS) & data_too_high);

  assign wait_data = 1'b0;
  assign wait_instr = 1'b0;

  //reset entire memory
  generate
  
  genvar i;
  for(i = 0; i < 128; i = i + 1) begin : reset_memory
    initial begin
      memory[i] = 32'b0;
    end
  end  
	endgenerate
	
	generate 
	for(i = 0; i < 15; i = i + 1) begin : reset_special_mem
		always @(posedge clk) begin
			if(reset_n) special[i] <= 0;
			else begin
				if(data_special) begin
					if(i == s_data_addr) begin
						if(wd) special[i] <= data_in;
					end
				end 
			end
		end
	end	
	endgenerate
	
  always@(posedge clk) begin
	if(~data_special) begin
      if(wd) memory[t_data_addr] = data_in;
	 end
  end

  always @(*) begin
    if(data_segv)
      data = 32'hXXXXXXXX;
    else if(data_special) begin
      if (rd) data = special[s_data_addr];
      else data = 32'hXXXXXXXX;
    end
    else begin
      if(rd) data = memory[t_data_addr];
      else data = 32'hXXXXXXXX;
    end
    if(instr_segv) begin
      instr = 32'hXXXXXXXX;
    end
    else begin
      if (init_instr) begin
        instr = memory[instr_addr];
      end
      else instr = memory[t_instr_addr];
    end
  end

endmodule
