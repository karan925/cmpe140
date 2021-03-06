module controlunit
(input zero, [5:0] opcode, funct, output pc_src, jump, reg_dst,we_reg, alu_src, we_dm, dm2reg, HI_en, LO_en, HiLo_sel,
alu_HiLo_sel, jr_sel, link, [2:0] alu_ctrl );
wire [1:0] alu_op;
assign pc_src = branch & zero;

// instaniate
maindec md (opcode, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, link, alu_op);
// instaniate
auxdec ad (alu_op, funct, alu_ctrl, HI_en, LO_en, HiLo_sel, alu_HiLo_sel, jr_sel);

endmodule




/*module controlunit
(input zero, [5:0] opcode, funct, output pc_src, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, [2:0] alu_ctrl);
    wire [1:0] alu_op;
    assign pc_src = branch & zero;
    maindec md (opcode, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, link, alu_op);
    auxdec ad (alu_op, funct, alu_ctrl, jr, HLwrite, HLmux, mult_to_reg);
    
endmodule
*/