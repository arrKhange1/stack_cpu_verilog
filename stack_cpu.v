`include "stack_cpu_defs.vh"

module stack_cpu (
    input  wire                    clk_i,
    input  wire                    reset_i,

    input  wire [`INSTR_WIDTH-1:0] instr_i,

    output wire [`DATA_WIDTH-1:0]  top_o,
    output wire [`ADDR_WIDTH-1:0]  pc_o,

    output reg                     fault_o
);

    reg [`ADDR_WIDTH-1:0] pc;

    reg [`DATA_WIDTH-1:0] data_stack [0:`STACK_DEPTH-1];

    reg [`STACK_PTR_WIDTH-1:0] sp;

    reg [`ADDR_WIDTH-1:0] return_stack [0:`RSTACK_DEPTH-1];

    reg [`RSTACK_PTR_WIDTH-1:0] rsp;

    wire [`OPCODE_WIDTH-1:0] opcode;
    wire [`DATA_WIDTH-1:0] immediate;

    assign opcode =
        instr_i[`INSTR_WIDTH-1 -: `OPCODE_WIDTH];

    assign immediate =
        instr_i[`DATA_WIDTH-1:0];

    assign pc_o = pc;

    assign top_o =
        (sp > 0)
        ? data_stack[sp - 1]
        : 0;


    always @(posedge clk_i) begin

        if (reset_i) begin

            pc <= 0;
            sp <= 0;
            rsp <= 0;
            fault_o <= 0;

        end
        else begin

            case (opcode)

                `INSTR_OP_NOP: begin
                    pc <= pc + 1;
                end

                `INSTR_OP_PUSH: begin

                    if (sp < `STACK_DEPTH) begin

                        data_stack[sp] <= immediate;

                        sp <= sp + 1;

                        pc <= pc + 1;

                    end
                    else begin

                        fault_o <= 1;
                    end

                end

                `INSTR_OP_POP: begin

                    if (sp > 0) begin

                        sp <= sp - 1;
                        pc <= pc + 1;

                    end
                    else begin

                        fault_o <= 1;
                    end

                end

                `INSTR_OP_ADD: begin

                    if (sp >= 2) begin

                        data_stack[sp - 2] <=
                            data_stack[sp - 2] +
                            data_stack[sp - 1];

                        sp <= sp - 1;

                        pc <= pc + 1;

                    end
                    else begin

                        fault_o <= 1;
                    end

                end

                `INSTR_OP_JPUSH: begin

                    if (sp < `STACK_DEPTH) begin
                        data_stack[sp] <= immediate;
                        sp <= sp + 1;
                    end

                    pc <= pc + 1;

                end

                `INSTR_OP_IF: begin

                    if (sp >= 2) begin

                        if (data_stack[sp - 2] != 0) begin
                            pc <= data_stack[sp - 1][`ADDR_WIDTH-1:0];
                        end
                        else begin
                            pc <= pc + 1;
                        end

                        sp <= sp - 2;

                    end
                    else begin

                        fault_o <= 1;
                    end

                end

                `INSTR_OP_CALL: begin

                    if (rsp < `RSTACK_DEPTH) begin

                        return_stack[rsp] <= pc + 1;

                        rsp <= rsp + 1;

                        pc <= immediate[`ADDR_WIDTH-1:0];

                    end
                    else begin

                        fault_o <= 1;
                    end

                end

                `INSTR_OP_RET: begin

                    if (rsp > 0) begin

                        pc <= return_stack[rsp - 1];

                        rsp <= rsp - 1;

                    end
                    else begin

                        fault_o <= 1;
                    end

                end

                default: begin
                    pc <= pc + 1;
                end

            endcase

        end

    end

endmodule