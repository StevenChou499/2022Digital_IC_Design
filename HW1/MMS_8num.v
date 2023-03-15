module MMS_8num(result, select, number0, number1, number2, number3, number4, number5, number6, number7);

input        select;
input  [7:0] number0;
input  [7:0] number1;
input  [7:0] number2;
input  [7:0] number3;
input  [7:0] number4;
input  [7:0] number5;
input  [7:0] number6;
input  [7:0] number7;
output reg [7:0] result; 

wire [7:0] compare_1, compare_2;
	
// call MMS_4num module	
MMS_4num MMS_4num_1(.result(compare_1), .select(select), .number0(number0), .number1(number1), .number2(number2), .number3(number3));
MMS_4num MMS_4num_2(.result(compare_2), .select(select), .number0(number4), .number1(number5), .number2(number6), .number3(number7));

always @(select, compare_1, compare_2) begin

	if (select == 0) begin // find the maximum
		result = (compare_1 > compare_2) ? compare_1 : compare_2;
	end
	else begin // find the minimum
		result = (compare_1 > compare_2) ? compare_2 : compare_1;
	end
end

endmodule