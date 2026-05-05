module alu #(parameter WIDTH=4)(input clk,rst,M,C_En,C_in,
input [WIDTH-1:0] Op_A,Op_B,
input [1:0] In_V,
input [3:0] Cmd,
output reg [2*WIDTH-1:0] Res,
output reg OFlow,C_out, G, L, E, Err);

reg [2*WIDTH-1:0]Inter,Inter1,Inter2;
reg OFlow1, G1, L1, F1, E1, Err1;

always @ (posedge clk or posedge rst) begin
        if (rst) begin
                Inter<={(2*WIDTH){1'b0}};
		OFlow1<=1'b0;
                G1<=1'b0;
                L1<=1'b0;
                E1<=1'b0;
		F1=1'b0;
                Err1<=1'b0;
        end else if (C_En) begin
                OFlow1<=1'b0;
                G1<=1'b0;
                L1<=1'b0;
                E1<=1'b0;
		F1<=1'b0;
                Err1<=1'b0;
		Inter<={(2*WIDTH){1'b0}};
		if (M) begin
			case(Cmd)
			4'd0:begin
				if (In_V==2'b11) begin
					Inter<=Op_A+Op_B;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd1:begin
				if (In_V==2'b11) begin
					Inter<=Op_A-Op_B;
					OFlow1<=(Op_A<Op_B);
				end else begin
					Err1<=1'b1;
				end
			end
			4'd2:begin
				if (In_V==2'b11) begin
					Inter<=Op_A+Op_B+C_in;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd3:begin
				if (In_V==2'b11) begin
					Inter<=Op_A-Op_B-C_in;
					OFlow1<=(Op_A<(Op_B+C_in));
				end else begin
					Err1<=1'b1;
				end
			end
			4'd4:begin
				if ((In_V==2'b11)||(In_V==2'b01)) begin
					Inter<=Op_A+1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd5:begin
				if ((In_V==2'b11)||(In_V==2'b01)) begin
					Inter<=Op_A-1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd6:begin
				if ((In_V==2'b11)||(In_V==2'b10)) begin
					Inter<=Op_B+1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd7:begin
				if ((In_V==2'b11)||(In_V==2'b10)) begin
					Inter<=Op_B-1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd8:begin
				if (In_V==2'b11) begin
					G1<=(Op_A>Op_B);
					L1<=(Op_A<Op_B);
					E1<=(Op_A==Op_B);
				end else begin
					Err1<=1'b1;
				end
			end
			4'd9:begin
				if (In_V==2'b11) begin
					Inter<=Inter1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd10:begin
				if (In_V==2'b11) begin
					Inter<=Inter2;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd11:begin
				if (In_V==2'b11) begin
					Inter<=Op_A+Op_B;
					OFlow1<=(Op_A[WIDTH-1]==Op_B[WIDTH-1]);
					F1<=Op_A[WIDTH-1];
				end else begin
					Err1<=1'b1;
				end
			end
			4'd12:begin
				if (In_V==2'b11) begin
					Inter<=Op_A-Op_B;
					OFlow1<=(Op_A[WIDTH-1]!=Op_B[WIDTH-1]);
					F1<=Op_A[WIDTH-1];
				end else begin
					Err1<=1'b1;
				end
			end
			default:Err1<=1'b1;
			endcase
		end else begin
			case(Cmd)
			4'd0:begin
				if (In_V==2'b11) begin
					Inter<=Op_A&Op_B;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd1:begin
				if (In_V==2'b11) begin
					Inter<=~(Op_A&Op_B);
				end else begin
					Err1<=1'b1;
				end
			end
			4'd2:begin
				if (In_V==2'b11) begin
					Inter<=Op_A|Op_B;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd3:begin
				if (In_V==2'b11) begin
					Inter<=~(Op_A|Op_B);
				end else begin
					Err1<=1'b1;
				end
			end
			4'd4:begin
				if (In_V==2'b11) begin
					Inter<=Op_A^Op_B;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd5:begin
				if (In_V==2'b11) begin
					Inter<=~(Op_A^Op_B);
				end else begin
					Err1<=1'b1;
				end
			end
			4'd6:begin
				if ((In_V==2'b11)||(In_V==2'b01)) begin
					Inter<=~Op_A;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd7:begin
				if ((In_V==2'b11)||(In_V==2'b10)) begin
					Inter<=~Op_B;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd8:begin
				if ((In_V==2'b11)||(In_V==2'b01)) begin
					Inter<=Op_A>>1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd9:begin
				if ((In_V==2'b11)||(In_V==2'b01)) begin
					Inter<=Op_A<<1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd10:begin
				if ((In_V==2'b11)||(In_V==2'b10)) begin
					Inter<=Op_B>>1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd11:begin
				if ((In_V==2'b11)||(In_V==2'b10)) begin
					Inter<=Op_B<<1;
				end else begin
					Err1<=1'b1;
				end
			end
			4'd12:begin
				if ((In_V==2'b11)&&(Op_B[WIDTH-1:($clog2(WIDTH)+1)]=={(WIDTH-1-($clog2(WIDTH))){1'b0}})) begin
					Inter <= (Op_A<<Op_B[$clog2(WIDTH)-1:0]) | (Op_A>>(WIDTH-Op_B[$clog2(WIDTH)-1:0]));
				end else begin
					Err1<=1'b1;
				end
			end
			4'd13:begin
				if ((In_V==2'b11)&&(Op_B[WIDTH-1:($clog2(WIDTH)+1)]=={(WIDTH-1-($clog2(WIDTH))){1'b0}})) begin
					Inter <= (Op_A>>Op_B[$clog2(WIDTH)-1:0]) | (Op_A<<(WIDTH-Op_B[$clog2(WIDTH)-1:0]));
				end else begin
					Err1<=1'b1;
				end
			end
			default:Err1<=1'b1;
			endcase
		end
        end
end
always @ (posedge clk or negedge rst) begin
	if (rst) begin
		Res<={(2*WIDTH){1'b0}};
                OFlow<=1'b0;
                C_out<=1'b0;
                G<=1'b0;
                L<=1'b0;
                E<=1'b0;
                Err<=1'b0;
	end else if (C_En) begin
		Res<=Inter;
        G<=G1;
        L<=L1;
        E<=E1;
        Err<=Err1;
		case({M,Cmd})
		5'b10000:C_out<=Inter[WIDTH];
		5'b10001:OFlow<=OFlow1;
		5'b10010:C_out<=Inter[WIDTH];
		5'b10011:OFlow<=OFlow1;
		5'b11011:begin
			OFlow<=OFlow1&&(F1!=Inter[WIDTH-1]);
		end
		5'b11100:begin
			OFlow<=OFlow1&&(F1!=Inter[WIDTH-1]);
		end
		default:begin
			C_out<=1'b0;
			OFlow<=1'b0;
		end
		endcase
	end
end
always @ (posedge clk or negedge rst) begin
	if (rst) begin
		Inter1<={(2*WIDTH){1'bx}};
	end else if ((C_En)&&({M,Cmd}==5'b11001)) begin
		Inter1<=((Op_A+1)*(Op_B+1));
	end else begin
		Inter1<={(2*WIDTH){1'bx}};
	end
end
always @ (posedge clk or negedge rst) begin
	if (rst) begin
		Inter2<={(2*WIDTH){1'bx}};
	end else if ((C_En)&&({M,Cmd}==5'b11010)) begin
		Inter2<=((Op_A<<1)*(Op_B));
		end else begin
		Inter2<={(2*WIDTH){1'bx}};
	end
end
endmodule
