`include "stack_cpu_defs.vh"

module stack_cpu_call_tb;

    reg clk;
    reg reset;

    reg [`INSTR_WIDTH-1:0] instr;

    wire [`DATA_WIDTH-1:0] top;
    wire [`ADDR_WIDTH-1:0] pc;


    stack_cpu uut (
        .clk_i(clk),
        .reset_i(reset),
        .instr_i(instr),
        .top_o(top),
        .pc_o(pc)
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


        // --------------------------------
        // PUSH 5
        // --------------------------------
        instr = {
            `INSTR_OP_PUSH,
            16'd5
        };

        #10;

        $display(
            "After PUSH 5:   PC=%d TOP=%d",
            pc,
            top
        );


        // --------------------------------
        // CALL 10
        // --------------------------------
        instr = {
            `INSTR_OP_CALL,
            16'd10
        };

        #10;

        $display(
            "After CALL 10:  PC=%d TOP=%d",
            pc,
            top
        );


        // --------------------------------
        // PUSH 100
        // условно: команда внутри функции
        // --------------------------------
        instr = {
            `INSTR_OP_PUSH,
            16'd100
        };

        #10;

        $display(
            "Inside func:    PC=%d TOP=%d",
            pc,
            top
        );


        // --------------------------------
        // RET
        // --------------------------------
        instr = {
            `INSTR_OP_RET,
            16'd0
        };

        #10;

        $display(
            "After RET:      PC=%d TOP=%d",
            pc,
            top
        );


        // --------------------------------
        // PUSH 7
        // условно: продолжаем после CALL
        // --------------------------------
        instr = {
            `INSTR_OP_PUSH,
            16'd7
        };

        #10;

        $display(
            "After PUSH 7:   PC=%d TOP=%d",
            pc,
            top
        );


        $finish;

    end

endmodule