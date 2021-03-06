`timescale 1ns / 1ps

module transmit(
input [7:0] word, 
input clk, 
input rst, 
input connection_status,
output reg transmit_ready,
output reg txd);

reg [7:0] transmissive_data;
reg [9:0] counter = 0;

always @(posedge clk)
begin
	if (rst)
		begin
			txd = 1;
			counter = 0;
			transmissive_data = 0;
			transmit_ready = 1;
		end
	else if (connection_status)
		begin
			if (transmit_ready)
				begin
					transmissive_data = word;
					transmit_ready = 0;
				end
			else if (counter >= 10 && counter < 23)
				begin
					txd = 1;
					counter = counter + 1;
				end
			else if (counter == 23)
				begin 
					counter = 0;
					transmit_ready = 1;
					transmissive_data = 0;
				end
			else
				begin
					if(counter == 0)
						txd = 1;
					else if(counter == 1)
						txd = 0;
					else
						begin
							//txd = transmissive_data[7];
							//transmissive_data = transmissive_data << 1;
							txd = transmissive_data[0];
							transmissive_data = transmissive_data >> 1;
						end
					counter = counter + 1;
				end
			end
		else
			begin
				txd = 1;
				counter = 0;
				transmit_ready = 1;
			end
end

endmodule
