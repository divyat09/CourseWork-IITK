`timescale 1 ns/10 ps

module alu4_test;

reg signed [3:0] inp1, inp2;
reg [1:0] inp3;
wire signed [3:0] alu_out;
wire flag1, flag2, flag3;

alu4 uut (.n1(inp1), .n2(inp2), .op(inp3), .out(alu_out), .carryf(flag1), .zerof(flag2), .negativef(flag3));

initial
begin

  inp1 = 4'b0111;
  inp2 = 4'b0111;
  inp3 = 2'b10;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  inp1 = 4'b1000;
  inp2 = 4'b1000;
  inp3 = 2'b10;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  inp1 = 4'b1100;
  inp2 = 4'b1100;
  inp3 = 2'b10;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);
    
  inp1 = 4'b0100;
  inp2 = 4'b0100;
  inp3 = 2'b10;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  inp1 = 4'b1100;
  inp2 = 4'b1000;
  inp3 = 2'b01;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  inp1 = 4'b1000;
  inp2 = 4'b1000;
  inp3 = 2'b00;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  inp1 = 4'b0100;
  inp2 = 4'b0010;
  inp3 = 2'b11;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  inp1 = 4'b0010;
  inp2 = 4'b0100;
  inp3 = 2'b11;
  #200;
  $display("Result = %d %d %d %d", alu_out, flag1, flag2, flag3);

  $stop;

end

endmodule
