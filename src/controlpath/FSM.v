module FSM(
  input clk,
  input reset_n,
  input go,
  input halt,
  input instr_alu,
  input instr_pc,
  input ld,
  input st,
  input wait_data,
  input wait_instr,
  input data_segv,
  input instr_segv,
  input invalid_instruction,
  output reg[4:0] current_state
  );

  wire trap;
  wire ld_st = (current_state == WAIT_LOAD | current_state == WAIT_STORE);
  assign trap = (data_segv | instr_segv) & ld_st | invalid_instruction;

  reg[4:0]  next_state;
  localparam
    HALT = 5'b00000,
    READ_INS = 5'b01000,
    WAIT_LOAD = 5'b01010,
    WAIT_STORE = 5'b01100,
    DO = 5'b01001,
    TRAP = 5'b10000;

  always @(*)begin: state_table
    case(current_state)
      HALT: next_state = go ? READ_INS : HALT;
      READ_INS: begin
        if(wait_instr)
          next_state = READ_INS;
        else begin
          if(~instr_pc & ~instr_alu) begin
            if(ld)
              next_state = WAIT_LOAD;
            else if(st)
              next_state = WAIT_STORE;
            else
              next_state = HALT;
          end
          else if(~instr_alu & instr_pc) begin
            next_state = HALT;
          end
          else
            next_state = DO;
        end
      end
      WAIT_LOAD: next_state = data_segv ? TRAP : DO;
      WAIT_STORE: next_state = data_segv ? TRAP : DO;
      DO: begin
        if(~halt)
          next_state = trap ? TRAP : READ_INS;
        else
          next_state = HALT;
      end
      default: next_state = HALT;
    endcase
  end
  //reset block
  always @(posedge clk) begin
		if(reset_n) current_state <= HALT;
      else current_state <= next_state;
  end
endmodule
