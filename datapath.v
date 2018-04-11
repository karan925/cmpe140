module datapath
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
    hiloreg    hilo(mult_out, hi_reg, lo_reg);
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