// `include "Memory_Interface.v"
// `include "..\\Memory_Interface.v"

module Fetch_Unit
#(
    parameter ADDRESS_WIDTH = 8
)
(
    input CLK,
	input enable,                                       // Memory Interface module enable pin (from Control Unit)

    input [31 : 0] PC,

	input [31 : 0] address,                             // Branch or Jump address generated in Address Generator
	input jump_branch_enable,                           // Generated in Branch Unit module

    output [31 : 0] next_PC,                            // next instruction PC output
	output reg [31 : 0] fetched_instruction,            // output "data" in Memory Interface module
    
    //////////////////////////////
    // Memory Interface Signals //
    //////////////////////////////

    output  reg  memory_interface_enable,
    output  reg  memory_interface_memory_state,
    output  reg  memory_interface_frame_mask,
    output  reg  memory_interface_address,
    input   memory_interface_data,
    input   memory_interface_memory_done

);
    localparam  READ        = 1'b0,
                WRITE       = 1'b1;

    always @(*) 
    begin
        memory_interface_enable = enable;
        memory_interface_memory_state = READ;
        memory_interface_frame_mask = 4'b1111;
        memory_interface_address = PC;  
    end

    assign next_PC = jump_branch_enable ? address : PC + 32'd4;

    always @(posedge memory_interface_memory_done) 
    begin
        fetched_instruction <= memory_interface_data;
    end

endmodule