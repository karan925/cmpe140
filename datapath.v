module datapath
(input clk, rst, pc_src, jump, reg_dst, we_reg, alu_src, dm2reg, jr_sel, link, HI_en, LO_en, HiLo_sel, alu_HiLo_sel,[2:0]
alu_ctrl, [4:0] ra3, [31:0] instr, rd_dm, output zero, [31:0]
pc_current, alu_out, wd_dm, rd3);
wire [4:0] rf_wa, rf_wa2;
wire [31:0] pc_plus4, pc_pre, pc_next, sext_imm, ba, bta, jta, alu_pa, alu_pb, wd_rf, jr_a, alu_mult, HI_out, LO_out,
hilo_out, write_to_Rf, pc_plus8;
wire [63:0] mult_out;
assign ba = {sext_imm[29:0], 2'b00};
assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};

// --- PC Logic --- //
dreg pc_reg (clk, rst, jr_a, pc_current);
adder pc_plus_4 (pc_current, 4, pc_plus4);
adder pc_plus_br (pc_plus4, ba, bta);
mux2 #(32) pc_src_mux (pc_src, pc_plus4, bta, pc_pre);
mux2 #(32) pc_jmp_mux (jump, pc_pre, jta, pc_next);

// --- RF Logic --- //
mux2 #(5) rf_wa_mux (reg_dst, instr[20:16], instr[15:11],
rf_wa);
regfile rf (clk, we_reg, instr[25:21],
instr[20:16], ra3, rf_wa2, write_to_Rf, alu_pa, wd_dm, rd3);
signext se (instr[15:0], sext_imm);

// Mult
multiply mult (alu_pa, wd_dm, mult_out);
dreg_with_En Hi (clk, rst, HI_en, mult_out[63:32], HI_out);
dreg_with_En Lo (clk, rst, LO_en, mult_out[31:0], LO_out);

// MFLO & MFHI
mux2 #(32) HiLo_mux (HiLo_sel, HI_out, LO_out, hilo_out);
mux2 #(32) alu_HiLo_Mux (alu_HiLo_sel, hilo_out, wd_rf, alu_mult);
mux2 #(32) write_to_reg (link, alu_mult, pc_plus4, write_to_Rf);


// --- ALU Logic --- //
mux2 #(32) alu_pb_mux (alu_src, wd_dm, sext_imm, alu_pb);
alu alu (alu_ctrl, alu_pa, alu_pb, zero,
alu_out);

// --- MEM Logic --- //
mux2 #(32) rf_wd_mux (dm2reg, alu_out, rd_dm, wd_rf);

//  JR
mux2 #(32) jra_mux1 (jr_sel, pc_next, alu_pa, jr_a);

// JAL
adder pc_plus_8 (pc_current, 8, pc_plus8);
mux2 #(5) link_mux (link, rf_wa, 31, rf_wa2);

endmodule



// jal = link
//  jra_mux = jr_sel
// hilo_mux = HiLo_sel
// alu_hilo_mux = alu_HiLo_sel


/* // test modifications
module datapath
(input clk, rst, pc_src, jump, reg_dst, we_reg, alu_src, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, Hi_en, Lo_en, hilo_mux, alu_hilo, [2:0] alu_ctrl, [4:0] ra3, [31:0] instr, rd_dm, output zero, [31:0] pc_current, alu_out, wd_dm, rd3);
    wire [4:0]  rf_wa, rf_wa2;
    wire [31:0] pc_plus4, pc_pre, pc_next, sext_imm, ba, bta, jta, alu_pa, alu_pb, wd_rf, jr_out, hi_reg, lo_reg, mult_result, wd_to_mult, result, rf_mux_out, write2Rf, pc_plus8, alu_mult;
    wire [63:0] mult_out;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    // --- PC Logic --- //
    dreg       pc_reg     (clk, rst, jr_out, pc_current);
    adder      pc_plus_4  (pc_current, 4, pc_plus4);
    adder      pc_plus_br (pc_plus4, ba, bta);
    // added mult below
    multiply    mult(alu_pa, wd_dm, mult_out);
    D_Reg    hi(clk, rst, Hi_en, mult_out[63:32], hi_reg);
    D_Reg    lo(clk, rst, Lo_en, mult_out[31:0], lo_reg);
    mux2 #(32) hiloMux (hiloMux, hi_reg, lo_reg, hilo_out);
    mux2 #(32) aluhiloMux (aLU_hiki_mux, hilo_out, wd_rf, alu_mult); mux2 #(32)
    
    mux2 #(32) pc_src_mux (pc_src, pc_plus4, bta, pc_pre);
    mux2 #(32) pc_jmp_mux (jump, pc_pre, jta, pc_next);
    mux2 #(32) jr_mux (jr, pc_next, alu_pa, jr_out);
    mux2 #(32) mult_mux (HLmux, hi_reg, lo_reg, mult_result);
    mux2 #(32) mult_toreg (mult_to_reg, mult_result, wd_to_mult, result);
    
    mux2 #(32) link_to_Rf (link, pc_plus4, result, wd_rf);
    mux2 #(32) link_to_A3 (link, rf_wa, 31, rf_wa2);
    
    adder pc_plus_8(pc_current, 8, pc_plus8);
    // --- RF Logic --- //
    mux2 #(5)  rf_wa_mux  (reg_dst, instr[20:16], instr[15:11], rf_wa);
    regfile    rf         (clk, we_reg, instr[25:21], instr[20:16], ra3, rf_wa2, write2Rf, alu_pa, wd_dm, rd3);
    signext    se         (instr[15:0], sext_imm);
    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (alu_src, wd_dm, sext_imm, alu_pb);
    alu        alu        (alu_ctrl, alu_pa, alu_pb, zero, alu_out);
    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux  (dm2reg, alu_out, rd_dm, wd_rf);
endmodule
*/
/*module datapath
(input clk, rst, pc_src, jump, reg_dst, we_reg, alu_src, dm2reg, jr, HLwrite, HLmux, mult_to_reg, link, [2:0] alu_ctrl, [4:0] ra3, [31:0] instr, rd_dm, output zero, [31:0] pc_current, alu_out, wd_dm, rd3);
    wire [4:0]  rf_wa;
    wire [31:0] pc_plus4, pc_pre, pc_next, sext_imm, ba, bta, jta, alu_pa, alu_pb, wd_rf, jr_out, hi_reg, lo_reg, mult_result, wd_to_mult, result, rf_mux_out;
    wire [63:0] mult_out;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    // --- PC Logic --- //
    dreg       pc_reg     (clk, rst, pc_next, pc_current);
    adder      pc_plus_4  (pc_current, 4, pc_plus4);
    adder      pc_plus_br (pc_plus4, ba, bta);
    // added mult below
    multiply    mult(alu_pa, wd_dm, mult_out);
    D_Reg    hi(clk, rst, HLwrite, mult_out[63:32], hi_reg);
    D_Reg    lo(clk, rst, HLwrite, mult_out[31:0], lo_reg);
    mux2 #(32) pc_src_mux (pc_src, jr_out, bta, pc_pre);
    mux2 #(32) pc_jmp_mux (jump, pc_pre, jta, pc_next);
    mux2 #(32) jr_mux (jr, pc_plus4, alu_pa, jr_out);
    mux2 #(32) mult_mux (HLmux, hi_reg, lo_reg, mult_result);
    mux2 #(32) mult_toreg (mult_to_reg, mult_result, wd_to_mult, result);
    
    mux2 #(32) link_to_Rf (link, pc_plus4, result, wd_rf);
    mux2 #(32) link_to_A3 (link, rf_mux_out, 31, rf_wa);
    // --- RF Logic --- //
    mux2 #(5)  rf_wa_mux  (reg_dst, instr[20:16], instr[15:11], rf_mux_out);
    regfile    rf         (clk, we_reg, instr[25:21], instr[20:16], ra3, rf_wa, wd_rf, alu_pa, wd_dm, rd3);
    signext    se         (instr[15:0], sext_imm);
    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (alu_src, wd_dm, sext_imm, alu_pb);
    alu        alu        (alu_ctrl, alu_pa, alu_pb, zero, alu_out);
    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux  (dm2reg, alu_out, rd_dm, wd_to_mult);
endmodule
*/