`timescale 1 ns/10 ps

module eq1(
  input wire i0, i1,
  output wire eq
);

  wire p0, p1;
  
  assign p0 = ~i0 & ~i1; 
  assign p1 = i0 & i1;
  assign eq = p0 | p1;

endmodule



