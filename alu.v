// module half_adder (S, C, x, y); 
// output S, C;
// input x, y;
module half_adder ( output S, C, input x, y); 
// Instantiate primitive gates
xor (S, x, y);
and (C, x, y);
endmodule
// Description of full adder 
// module full_adder (S, C, x, y, z);
// output S, C;
// input x, y, z;
module full_adder ( output S, C, input x, y, z); // Verilog 2001, 2005 syntax
wire S1, C1, C2;
// Instantiate half adders
half_adder HA1 (S1, C1, x, y);
half_adder HA2 (S, C2, S1, z);
or G1 (C, C2, C1);
endmodule
// Description of four-bit adder ( Fig. 4.9 ) // Verilog 1995 syntax
// module ripple_carry_4_bit_adder (Sum, C4, A, B, C0);
// output [3: 0] Sum;
// output C4;
// input [3: 0] A, B;
// input C0;
// Alternative Verilog 2001, 2005 syntax:
module ripple_carry_4_bit_adder ( output [3: 0] Sum, output C4,
input [3: 0] A, B, input C0);
wire C1, C2, C3; // Intermediate carries
// Instantiate chain of full adders
full_adder FA0 (Sum[0], C1, A[0], B[0], C0),
FA1 (Sum[1], C2, A[1], B[1], C1),
FA2 (Sum[2], C3, A[2], B[2], C2),
FA3 (Sum[3], C4, A[3], B[3], C3);
endmodule

module mux4to1 ( input [3:0] a, // 4-bit input called a
 input [3:0] b, // 4-bit input called b
 input [3:0] c, // 4-bit input called c
 input [3:0] d, // 4-bit input called d
 input [1:0] sel, // input sel used to select between a,b,c,d
 output reg [3:0] out); // 4-bit output based on input sel
 // This always block gets executed whenever a/b/c/d/sel changes value
 // When that happens, based on value in sel, output is assigned to either a/b/c/d
 always @ (a or b or c or d or sel) begin
 case (sel)
 2'b00 : out = a;
 2'b01 : out = b;
 2'b10 : out = c;
 2'b11 : out = d;
 endcase
 end
endmodule

module mux2to1 ( input [3:0] a, // 4-bit input called a
 input [3:0] b, // 4-bit input called b
 input sel, // input sel used to select between a,b
 output reg [3:0] out); // 4-bit output based on input sel
 // This always block gets executed whenever a/b/sel changes value
 // When that happens, based on value in sel, output is assigned to either a/b
 always @ (a or b or sel) begin
 case (sel)
 1'b0 : out = a;
 1'b1 : out = b;
 endcase
 end
endmodule


module alu4bit(input [3:0] a, b, input [0:3] sel, output [3:0] out, output cout);
	wire [3:0] w1, w2, w3, w4, w5, cin, w6, adder_in;
	mux2to1 M1(a, ~a, sel[0], w1);
	mux2to1 M2(b, ~b, sel[1], w2);
	ripple_carry_4_bit_adder Adder( w3, cout,w1, adder_in,cin);
	assign w4= w1&w2;
	assign w5= w1|w2;
	assign cin= sel[3];
	mux2to1 M3(w4, w5, sel[3], w6);
	mux2to1 MAdder(w2, ~w2, sel[3], adder_in);
	mux2to1 M4(w3, w6, sel[2], out);
endmodule
