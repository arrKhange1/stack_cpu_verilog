`include "stack_cpu_defs.vh"

module stack_cpu_final_tb;

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


    // Тактовый сигнал
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin

        // =========================================
        // RESET
        // =========================================

        reset = 1;
        instr = 0;

        #10;

        reset = 0;

        $display("===== START TEST =====");


        // =========================================
        // PUSH 10
        // =========================================

        instr = {
            `INSTR_OP_PUSH,
            16'd10
        };

        #10;

        $display(
            "PUSH 10     PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // PUSH 20
        // =========================================

        instr = {
            `INSTR_OP_PUSH,
            16'd20
        };

        #10;

        $display(
            "PUSH 20     PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // ADD
        //
        // 10 + 20 = 30
        // =========================================

        instr = {
            `INSTR_OP_ADD,
            16'd0
        };

        #10;

        $display(
            "ADD         PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // PUSH 5
        // =========================================

        instr = {
            `INSTR_OP_PUSH,
            16'd5
        };

        #10;

        $display(
            "PUSH 5      PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // POP
        //
        // удаляем 5
        // TOP снова должен быть 30
        // =========================================

        instr = {
            `INSTR_OP_POP,
            16'd0
        };

        #10;

        $display(
            "POP         PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // PUSH condition = 1
        //
        // готовимся проверить IF
        // =========================================

        instr = {
            `INSTR_OP_PUSH,
            16'd1
        };

        #10;

        $display(
            "PUSH 1      PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // JPUSH 15
        //
        // кладём адрес 15
        // =========================================

        instr = {
            `INSTR_OP_JPUSH,
            16'd15
        };

        #10;

        $display(
            "JPUSH 15    PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // IF
        //
        // условие = 1,
        // поэтому PC должен стать 15
        // =========================================

        instr = {
            `INSTR_OP_IF,
            16'd0
        };

        #10;

        $display(
            "IF          PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // Проверяем переход
        if (pc == 15)
            $display("IF TEST:   OK");
        else
            $display("IF TEST:   ERROR");


        // =========================================
        // CALL 25
        //
        // Сейчас PC = 15.
        //
        // return address = 16
        // PC должен стать 25
        // =========================================

        instr = {
            `INSTR_OP_CALL,
            16'd25
        };

        #10;

        $display(
            "CALL 25     PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        if (pc == 25)
            $display("CALL TEST: OK");
        else
            $display("CALL TEST: ERROR");


        // =========================================
        // PUSH 100
        //
        // как будто выполняем что-то
        // внутри подпрограммы
        // =========================================

        instr = {
            `INSTR_OP_PUSH,
            16'd100
        };

        #10;

        $display(
            "PUSH 100    PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        // =========================================
        // RET
        //
        // CALL был при PC = 15,
        // поэтому вернуться должны на PC = 16
        // =========================================

        instr = {
            `INSTR_OP_RET,
            16'd0
        };

        #10;

        $display(
            "RET         PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );


        if (pc == 16)
            $display("RET TEST:  OK");
        else
            $display("RET TEST:  ERROR");


        // =========================================
        // Финальная проверка
        // =========================================

        $display("");
        $display("===== FINAL STATE =====");

        $display(
            "PC=%d TOP=%d FAULT=%d",
            pc, top, fault
        );

        $finish;

    end

endmodule