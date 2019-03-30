module memory_decoder(
  input[29:0] instruction,
  output[3:0] reg_addr,
  output[3:0] mem_loca_addr,
  output rd,
  output wd,
  output[3:0] ld_select,
  )
