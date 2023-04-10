module rails(clk, reset, data, valid, result);

input        clk;
input        reset;
input  [3:0] data;
output reg   valid;
output reg   result; 

// store the current state and the next state
reg [2:0] current_state = 3'b000;
reg [2:0] next_state = 3'b001;

reg [9:0] outputted_element = 10'b0000000000;

// store the actual receiving data length
reg [3:0] remain_length = 4'b0000;
reg [3:0] max_data = 4'b0000;

reg valid_or_not = 1'b1;
reg received_all = 1'b0;
reg [4:0] i;
reg [4:0] j;

// The state names
parameter [2:0] state_s0 = 3'b000, state_s1 = 3'b001, state_s2 = 3'b010;
// state_s0 represents the waiting state, which is waiting for the first input
// state_s1 represents the receiving state, which is getting the data length and the output sequence
// state_s2 represents the output state, which will output whether the sequence is legal or not

// next state logic
always @(current_state, received_all) begin
	next_state = state_s0;
	case (current_state)
		state_s0: next_state <= state_s1;
		state_s1: begin
			if (received_all)
				next_state <= state_s2;
			else
				next_state <= state_s1;
		end
		state_s2: next_state <= state_s0;
		default: next_state <= state_s0;
	endcase
end

// state registers
always @(posedge clk, posedge reset) begin
	if (reset == 1'b1)
		current_state <= state_s0;
	else
		current_state <= next_state;
	case (current_state)
		state_s0: begin
			outputted_element = 10'b0000000000;
			remain_length = data;
			max_data = 4'b0000;
			valid_or_not <= 1'b1;
			for (i = data; i < 10; i = i + 1)
				outputted_element[i] = 1'b1;
		end
		state_s1: begin
			remain_length <= remain_length - 4'b0001;
			outputted_element[data - 1] = 1'b1;
			if (max_data < data) begin
				max_data <= data; // we have to change the max data
			end
			else begin
				for (j = max_data - 1; j >= data; j = j - 1)
					valid_or_not = outputted_element[j] & valid_or_not;
			end
		end
		state_s2: begin
			outputted_element = 10'b0000000000;
			max_data <= 4'b0000;
		end
		default: begin
		end
	endcase
	if (remain_length == 4'b0001)
		received_all = 1'b1;
	else
		received_all = 1'b0;
end

// output logic
always @(current_state) begin
	case (current_state)
		state_s0, state_s1: begin
			valid <= 1'b0;
			result <= 1'b0;
		end
		state_s2: begin
			valid <= 1'b1;
			if (valid_or_not)
				result <= 1'b1;
			else
				result <= 1'b0;
		end
		default: begin
			valid <= 1'b0;
			result <= 1'b0;
		end
	endcase
end

endmodule