module maindec
(input [5:0] opcode, output branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, link, [1:0] alu_op);
    reg [9:0] ctrl;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, link, alu_op} = ctrl;
    always @ (opcode)
    begin
        case (opcode)
            6'b00_0000: ctrl = 10'b0_0_1_1_0_0_0_0_10; // R-type
            6'b00_1000: ctrl = 10'b0_0_0_1_1_0_0_0_00; // ADDI
            6'b00_0100: ctrl = 10'b1_0_0_0_0_0_0_0_01; // BEQ
            6'b00_0010: ctrl = 10'b0_1_0_0_0_0_0_0_00; // J
            6'b00_0011: ctrl = 10'b0_1_0_0_0_0_0_1_00; // JAL
            6'b10_1011: ctrl = 10'b0_0_0_0_1_1_0_0_00; // SW
            6'b10_0011: ctrl = 10'b0_0_0_1_1_0_1_0_00; // LW
            default:    ctrl = 10'bx_x_x_x_x_x_x_x_xx;
        endcase
    end
endmodule

module auxdec
(input [1:0] alu_op, [5:0] funct, output [2:0] alu_ctrl, output jr, HLwrite, HLmux, mult_to_reg);
    reg [6:0] ctrl;
    assign {alu_ctrl, jr, HLwrite, HLmux, mult_to_reg} = ctrl;
    always @ (alu_op, funct)
    begin
        case (alu_op)
            2'b00: ctrl = 7'b010_0_0_0_0; // add
            2'b01: ctrl = 7'b110_0_0_0_0; // sub
            default: case (funct)
                6'b10_0100: ctrl = 7'b000_0_0_0_0; // AND
                6'b10_0101: ctrl = 7'b001_0_0_0_0; // OR
                6'b10_0000: ctrl = 7'b010_0_0_0_0; // ADD
                6'b10_0010: ctrl = 7'b110_0_0_0_0; // SUB
                6'b10_1010: ctrl = 7'b111_0_0_0_0; // SLT
                6'b01_1001: ctrl = 7'b000_0_1_0_0; // mult
                6'b00_1010: ctrl = 7'b000_0_1_0_1; // mfhi
                6'b00_1100: ctrl = 7'b000_0_1_1_1; // mflo
                6'b00_1000: ctrl = 7'b000_1_0_0_0; // jr
                default:    ctrl = 7'bxxxxxxx;
            endcase
        endcase
    end
endmodule



/* //original
module maindec
(input [5:0] opcode, output branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, [1:0] alu_op);
    reg [13:0] ctrl;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, alu_op} = ctrl;
    always @ (opcode)
    begin
        case (opcode)
            6'b00_0000: ctrl = 14'b0_0_1_1_0_0_0_0_0_0_0_0_10; // R-type
            6'b00_1000: ctrl = 14'b0_0_0_1_1_0_0_0_0_0_0_0_00; // ADDI
            6'b00_0100: ctrl = 14'b1_0_0_0_0_0_0_0_0_0_0_0_01; // BEQ
            6'b00_0010: ctrl = 14'b0_1_0_0_0_0_0_0_0_0_0_0_00; // J
            6'b00_0011: ctrl = 14'b0_1_0_0_0_0_0_0_0_0_0_1_00; // JAL
            6'b10_1011: ctrl = 14'b0_0_0_0_1_1_0_0_0_0_0_0_00; // SW
            6'b10_0011: ctrl = 14'b0_0_0_1_1_0_1_0_0_0_0_0_00; // LW
            default:    ctrl = 14'bx_x_x_x_x_x_x_x_x_x_x_x_xx;
        endcase
    end
endmodule

module auxdec
(input [1:0] alu_op, [5:0] funct, output [2:0] alu_ctrl);
    reg [2:0] ctrl;
    assign {alu_ctrl} = ctrl;
    always @ (alu_op, funct)
    begin
        case (alu_op)
            2'b00: ctrl = 3'b010; // add
            2'b01: ctrl = 3'b110; // sub
            default: case (funct)
                6'b10_0100: ctrl = 3'b000; // AND
                6'b10_0101: ctrl = 3'b001; // OR
                6'b10_0000: ctrl = 3'b010; // ADD
                6'b10_0010: ctrl = 3'b110; // SUB
                6'b10_1010: ctrl = 3'b111; // SLT
               // 6'b00_1000: ctrl
                default:    ctrl = 3'bxxx;
            endcase
        endcase
    end
endmodule
*/
/*
// DOSENT WORK
module maindec
(input [5:0] opcode, funct, output branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, [1:0] alu_op);
    reg [13:0] ctrl;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, alu_op} = ctrl;
    always @ (opcode)
    begin
        case (opcode)
            6'b00_0000: ctrl = 14'b0_0_1_1_0_0_0_0_0_0_0_0_10; // R-type
            6'b00_1000: ctrl = 14'b0_0_0_1_1_0_0_0_0_0_0_0_00; // ADDI
            6'b00_0100: ctrl = 14'b1_0_0_0_0_0_0_0_0_0_0_0_01; // BEQ
            6'b00_0010: ctrl = 14'b0_1_0_0_0_0_0_0_0_0_0_0_00; // J
            6'b00_0011: ctrl = 14'b0_1_0_0_0_0_0_0_0_0_0_1_00; // JAL
            6'b10_1011: ctrl = 14'b0_0_0_0_1_1_0_0_0_0_0_0_00; // SW
            6'b10_0011: ctrl = 14'b0_0_0_1_1_0_1_0_0_0_0_0_00; // LW
             default: case (funct)
                        6'b01_1001: ctrl = 14'b0_0_0_0_0_0_0_0_1_0_0_0_00; // mult
                        6'b00_1010: ctrl = 14'b0_0_0_0_0_0_0_0_1_0_1_0_00; // mfhi
                        6'b00_1100: ctrl = 14'b0_0_0_0_0_0_0_0_1_1_1_0_00; // mflo
                        6'b00_1000: ctrl = 14'b0_1_0_0_0_0_0_1_0_0_0_0_00; // jr
             
            default:    ctrl = 14'bx_x_x_x_x_x_x_x_x_x_x_x_xx;
        endcase
        endcase
    end
endmodule

module auxdec
(input [1:0] alu_op, [5:0] funct, output [2:0] alu_ctrl);
    reg [2:0] ctrl;
    assign {alu_ctrl} = ctrl;
    always @ (alu_op, funct)
    begin
        case (alu_op)
            2'b00: ctrl = 3'b010; // add
            2'b01: ctrl = 3'b110; // sub
            default: case (funct)
                6'b10_0100: ctrl = 3'b000; // AND
                6'b10_0101: ctrl = 3'b001; // OR
                6'b10_0000: ctrl = 3'b010; // ADD
                6'b10_0010: ctrl = 3'b110; // SUB
                6'b10_1010: ctrl = 3'b111; // SLT
               // 6'b00_1000: ctrl
                default:    ctrl = 3'bxxx;
            endcase
        endcase
    end
endmodule
*/