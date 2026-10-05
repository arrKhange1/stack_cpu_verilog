`ifndef STACK_CPU_DEFS_VH
`define STACK_CPU_DEFS_VH

`define DATA_WIDTH       16
`define ADDR_WIDTH       8
`define OPCODE_WIDTH     4
`define INSTR_WIDTH      20

`define STACK_DEPTH      16
`define STACK_PTR_WIDTH  5

`define RSTACK_DEPTH      16
`define RSTACK_PTR_WIDTH  5

`define INSTR_OP_CALL     4'h6
`define INSTR_OP_RET      4'h7

`define INSTR_OP_NOP     4'h0
`define INSTR_OP_PUSH    4'h1
`define INSTR_OP_POP     4'h2
`define INSTR_OP_ADD     4'h3
`define INSTR_OP_JPUSH   4'h4
`define INSTR_OP_IF      4'h5

`endif