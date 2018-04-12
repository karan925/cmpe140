module mips
(input clk, rst, [4:0] ra3, [31:0] instr, rd_dm, output we_dm, [31:0] pc_current, alu_mult, wd_dm, rd3);
wire pc_src, we_reg, alu_src, dm2reg, jump, reg_dst;
wire [2:0] alu_ctrl;
wire jr_sel, link, HI_en, LO_en, HiLo_sel, alu_HiLo_sel;


datapath DP (clk,rst, pc_src, jump, reg_dst, we_reg, alu_src, dm2reg, jr_sel, link, HI_en, LO_en, HiLo_sel,
alu_HiLo_sel, alu_ctrl, ra3, instr, rd_dm, zero, pc_current, alu_mult, wd_dm, rd3);

controlunit CU (zero, instr[31:26], instr[5:0], pc_src, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, HI_en, LO_en,
HiLo_sel, alu_HiLo_sel, jr_sel, link, alu_ctrl);

endmodule



/*module mips
(input clk, rst, [4:0] ra3, [31:0] instr, rd_dm, output we_dm, [31:0] pc_current, alu_out, wd_dm, rd3);
    wire       pc_src, jump, reg_dst, we_reg, alu_src, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, branch, zero;
    wire [2:0] alu_ctrl;
    datapath dp (clk, rst, pc_src, jump, reg_dst, we_reg, alu_src, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, alu_ctrl, ra3, instr, rd_dm, zero, pc_current, alu_out, wd_dm, rd3);
    controlunit cu (zero, instr[31:26], instr[5:0], pc_src, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, alu_ctrl);
endmodule
*/