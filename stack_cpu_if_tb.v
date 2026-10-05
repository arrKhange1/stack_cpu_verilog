`include "stack_cpu_defs.vh"

module stack_cpu_if_tb;

    reg clk;
    reg reset;

    reg [`INSTR_WIDTH-1:0] instr;

    wire [`DATA_WIDTH-1:0] top;
    wire [`ADDR_WIDTH-1:0] pc;


    // Создаём экземпляр нашего процессора
    stack_cpu uut (
        .clk_i(clk),
        .reset_i(reset),
        .instr_i(instr),
        .top_o(top),
        .pc_o(pc)
    );


    // Генерация тактового сигнала
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    // Сам тест
    initial begin

        // Сначала сбрасываем процессор
        reset = 1;
        instr = 0;

        #10;

        reset = 0;


        // --------------------------------
        // PUSH 1
        // condition = true
        // --------------------------------

        instr = {
            `INSTR_OP_PUSH,
            16'd1
        };

        #10;

        $display(
            "After PUSH 1:    PC=%d TOP=%d",
            pc,
            top
        );


        // --------------------------------
        // JPUSH 10
        // адрес перехода = 10
        // --------------------------------

        instr = {
            `INSTR_OP_JPUSH,
            16'd10
        };

        #10;

        $display(
            "After JPUSH 10: PC=%d TOP=%d",
            pc,
            top
        );


        // --------------------------------
        // IF
        // --------------------------------

        instr = {
            `INSTR_OP_IF,
            16'd0
        };

        #10;

        $display(
            "After IF:       PC=%d TOP=%d",
            pc,
            top
        );


        $finish;

    end

endmodule