`timescale 1ns / 1ps
////////////////////////////////////////////////////
// Count-down timer that keeps track of game time
//
// Input clk - system clock
// Input rst_n - active low
// input load - active high
// input [3:0] load_tens_digit - bcd
// input [3:0] load_ones_digit - bcd
// output [3:0] tens_digit - bcd
// output [3:0] ones_digit - bcd
////////////////////////////////////////////////////
module timer(
    input clk,
    input rst_n,
    input load,
    input [3:0] load_tens_digit,
    input [3:0] load_ones_digit,
    output [3:0] tens_digit,
    output [3:0] ones_digit
    );

    //state param
    reg [3:0] state;
    parameter START = 2'd2;
    parameter RESET = 2'd0;
    parameter LOAD = 2'd2;
    parameter CLOCK_FREQ = 50000000;
    parameter SEC = 1;

    localparam COUNTDOWN = CLOCK_FREQ * SEC ;
    
        reg[31:0] counter;

    always @(state[START] == 1'b1) begin
        if (state[RESET] == 1'b1)begin
        sec_timer.counter =0;
        accumulator.time =60;
        always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 32'd0;
            tens_digit <= 4'd6;
            ones_digit <= 4'd0;
        end else if (load) begin
            counter <= 32'd0;
            tens_digit <= load_tens_digit;
            ones_digit <= load_ones_digit;
        end else begin
            if (counter < COUNTDOWN - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 32'd0;
                if (ones_digit > 0) begin
                    ones_digit <= ones_digit - 1;
                end else if (tens_digit > 0) begin
                    tens_digit <= tens_digit - 1;
                    ones_digit <= 4'd9;
                end
            end
            end
        end
        end
    end
endmodule
