`timescale 1ns / 1ps

module recieve(
input rxd, 
input clk,
input rst, 
output [7:0] word,
output word_on_line);

reg [7:0] recieved_data_1 = 0;
reg [7:0] recieved_data = 0;
reg [3:0] counter = 0;

reg word_on_line = 0;
reg recieve_ready = 1;

always @(posedge clk)
begin		
	if (rst)
		begin
			recieved_data = 0;
			counter = 0;
			recieve_ready = 1;
			recieved_data_1 = 0;
			word_on_line = 0;
		end
	else if (counter == 9 && rxd == 0 && recieve_ready == 0) // STOP BIT && REGISTER WRITING
		begin
			recieved_data = recieved_data_1;
			counter = 0;
			recieve_ready = 1;
			word_on_line = 1;
		end
	else if (counter == 9 && rxd == 1 && recieve_ready == 0) // NO STOP BIT 
		begin
			recieved_data = 8'b1000_0001;
			counter = 0;
			recieve_ready = 1;
			word_on_line = 0;
		end
	else if(rxd == 0 && counter == 0 && recieve_ready == 1) // START BIT
		begin
			recieve_ready = 0;
			counter = counter + 1;
			word_on_line = 0;
		end
	else if(recieve_ready == 0 && counter < 9) // WRITING CYCLE 
		begin
			recieved_data_1 = recieved_data_1 << 1;
			recieved_data_1[0] = rxd;
			counter = counter + 1;
			word_on_line = 0;
		end
	else
		word_on_line = 0;
	end
assign word = recieved_data;
endmodule