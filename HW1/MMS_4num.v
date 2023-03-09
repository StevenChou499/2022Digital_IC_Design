module MMS_4num(result, select, number0, number1, number2, number3);

input        select;
input  [7:0] number0;
input  [7:0] number1;
input  [7:0] number2;
input  [7:0] number3;
output reg [7:0] result; 

reg [7:0] compare_1, compare_2;

always @(select, number0, number1, number2, number3) begin
	if (select == 0) begin // find the maximum
		compare_1 = (number0 > number1) ? number0 : number1;
		compare_2 = (number2 > number3) ? number2 : number3;
	end
	else begin // find the minimum
		compare_1 = (number0 > number1) ? number1 : number0;
		compare_2 = (number2 > number3) ? number3 : number2;
	end
end

always @(compare_1, compare_2) begin
	if (select == 0) begin // find the maximum
		result = (compare_1 > compare_2) ? compare_1 : compare_2;
	end
	else begin // find the minimum
		result = (compare_1 > compare_2) ? compare_2 : compare_1;
	end
end

endmodule