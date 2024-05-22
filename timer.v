`timescale 1ns / 1ps
////////////////////////////////////////////////////
// Count-down timer that keeps track of game time
//
// Input clk - system clock
// Input rst_n - active low
// input load - active high
// input [3:0] load_tens_digit - bcd
// input [3:0] load_ones_digit - bcd
// output reg [3:0] tens_digit - bcd
// output reg [3:0] ones_digit - bcd
////////////////////////////////////////////////////
module timer(
    input clk,
    input rst_n,
    input load,
    input [3:0] load_tens_digit,
    input [3:0] load_ones_digit,
    output reg [3:0] tens_digit,
    output reg [3:0] ones_digit
    );

    parameter CLOCK_FREQ = 50000000; // 50 MHz clock frequency
    parameter SEC = 1;
    localparam COUNTDOWN = CLOCK_FREQ * SEC;

    reg [31:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 32'd0;
            tens_digit <= 4'd6; // Default to 60 seconds
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
endmodule
