`include "stack_cpu_defs.vh"

module stack_cpu_tb;

    reg clk;
    reg reset;

    reg [`INSTR_WIDTH-1:0] instr;

    wire [`DATA_WIDTH-1:0] top;
    wire [`ADDR_WIDTH-1:0] pc;
    wire fault;


    stack_cpu uut (
        .clk_i(clk),
        .reset_i(reset),
        .instr_i(instr),
        .top_o(top),
        .pc_o(pc),
        .fault_o(fault)
    );


    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end


    initial begin

        reset = 1;
        instr = 0;

        #10;

        reset = 0;


        instr = {
            `INSTR_OP_POP,
            16'd0
        };

        #10;

        $display(
            "After invalid POP: PC=%d TOP=%d FAULT=%d",
            pc,
            top,
            fault
        );

        // PUSH 10
        instr = {
            `INSTR_OP_PUSH,
            16'd10
        };

        #10;

        $display(
            "After PUSH 10: PC=%d TOP=%d",
            pc,
            top
        );


        // PUSH 20
        instr = {
            `INSTR_OP_PUSH,
            16'd20
        };

        #10;

        $display(
            "After PUSH 20: PC=%d TOP=%d",
            pc,
            top
        );


        // ADD
        instr = {
            `INSTR_OP_ADD,
            16'd0
        };

        #10;

        $display(
            "After ADD: PC=%d TOP=%d",
            pc,
            top
        );


        $finish;

    end

endmodule