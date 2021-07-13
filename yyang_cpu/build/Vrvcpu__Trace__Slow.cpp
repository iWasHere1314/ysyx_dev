// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vrvcpu__Syms.h"


//======================

void Vrvcpu::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vrvcpu::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vrvcpu::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vrvcpu::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vrvcpu::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+65,"clk", false,-1);
        tracep->declBit(c+66,"rst", false,-1);
        tracep->declBus(c+67,"inst", false,-1, 31,0);
        tracep->declQuad(c+68,"inst_addr", false,-1, 63,0);
        tracep->declBit(c+70,"inst_ena", false,-1);
        tracep->declBit(c+65,"rvcpu clk", false,-1);
        tracep->declBit(c+66,"rvcpu rst", false,-1);
        tracep->declBus(c+67,"rvcpu inst", false,-1, 31,0);
        tracep->declQuad(c+68,"rvcpu inst_addr", false,-1, 63,0);
        tracep->declBit(c+70,"rvcpu inst_ena", false,-1);
        tracep->declBus(c+71,"rvcpu rs1_index", false,-1, 4,0);
        tracep->declBus(c+72,"rvcpu rs2_index", false,-1, 4,0);
        tracep->declBit(c+85,"rvcpu rs1_ena", false,-1);
        tracep->declBit(c+86,"rvcpu rs2_ena", false,-1);
        tracep->declBus(c+73,"rvcpu rd_index", false,-1, 4,0);
        tracep->declBit(c+85,"rvcpu rd_ena", false,-1);
        tracep->declQuad(c+74,"rvcpu imm_data", false,-1, 63,0);
        tracep->declBit(c+85,"rvcpu alu_src", false,-1);
        tracep->declQuad(c+76,"rvcpu rd_data", false,-1, 63,0);
        tracep->declQuad(c+78,"rvcpu rs1_data", false,-1, 63,0);
        tracep->declQuad(c+87,"rvcpu rs2_data", false,-1, 63,0);
        tracep->declBit(c+65,"rvcpu my_if_top clk", false,-1);
        tracep->declBit(c+66,"rvcpu my_if_top rst", false,-1);
        tracep->declQuad(c+68,"rvcpu my_if_top inst_addr", false,-1, 63,0);
        tracep->declBit(c+70,"rvcpu my_if_top inst_ena", false,-1);
        tracep->declQuad(c+80,"rvcpu my_if_top nxt_inst_addr", false,-1, 63,0);
        tracep->declBit(c+65,"rvcpu my_if_top my_if_pc clk", false,-1);
        tracep->declBit(c+66,"rvcpu my_if_top my_if_pc rst", false,-1);
        tracep->declQuad(c+80,"rvcpu my_if_top my_if_pc nxt_inst_addr", false,-1, 63,0);
        tracep->declQuad(c+68,"rvcpu my_if_top my_if_pc cur_inst_addr", false,-1, 63,0);
        tracep->declQuad(c+1,"rvcpu my_if_top my_if_pc cur_inst_addr_r", false,-1, 63,0);
        tracep->declBus(c+67,"rvcpu my_id_top inst", false,-1, 31,0);
        tracep->declBus(c+71,"rvcpu my_id_top rs1_index", false,-1, 4,0);
        tracep->declBus(c+72,"rvcpu my_id_top rs2_index", false,-1, 4,0);
        tracep->declBit(c+85,"rvcpu my_id_top rs1_ena", false,-1);
        tracep->declBit(c+86,"rvcpu my_id_top rs2_ena", false,-1);
        tracep->declBus(c+73,"rvcpu my_id_top rd_index", false,-1, 4,0);
        tracep->declBit(c+85,"rvcpu my_id_top rd_ena", false,-1);
        tracep->declQuad(c+74,"rvcpu my_id_top imm_data", false,-1, 63,0);
        tracep->declBit(c+85,"rvcpu my_id_top alu_src", false,-1);
        tracep->declBus(c+82,"rvcpu my_id_top imm_pre", false,-1, 11,0);
        tracep->declBit(c+85,"rvcpu my_ex_top alu_src", false,-1);
        tracep->declQuad(c+78,"rvcpu my_ex_top oprand1", false,-1, 63,0);
        tracep->declQuad(c+87,"rvcpu my_ex_top oprand2", false,-1, 63,0);
        tracep->declQuad(c+74,"rvcpu my_ex_top imm_data", false,-1, 63,0);
        tracep->declQuad(c+76,"rvcpu my_ex_top rd_data", false,-1, 63,0);
        tracep->declQuad(c+78,"rvcpu my_ex_top op1", false,-1, 63,0);
        tracep->declQuad(c+74,"rvcpu my_ex_top op2", false,-1, 63,0);
        tracep->declBit(c+65,"rvcpu my_regfile clk", false,-1);
        tracep->declBit(c+66,"rvcpu my_regfile rst", false,-1);
        tracep->declBit(c+85,"rvcpu my_regfile rd_ena", false,-1);
        tracep->declBus(c+71,"rvcpu my_regfile rs1_index", false,-1, 4,0);
        tracep->declBus(c+72,"rvcpu my_regfile rs2_index", false,-1, 4,0);
        tracep->declBit(c+85,"rvcpu my_regfile rs1_ena", false,-1);
        tracep->declBit(c+86,"rvcpu my_regfile rs2_ena", false,-1);
        tracep->declBus(c+73,"rvcpu my_regfile rd_index", false,-1, 4,0);
        tracep->declQuad(c+76,"rvcpu my_regfile rd_data", false,-1, 63,0);
        tracep->declQuad(c+78,"rvcpu my_regfile rs1_data", false,-1, 63,0);
        tracep->declQuad(c+87,"rvcpu my_regfile rs2_data", false,-1, 63,0);
        {int i; for (i=0; i<31; i++) {
                tracep->declQuad(c+3+i*2,"rvcpu my_regfile regfile_r", true,(i+1), 63,0);}}
        tracep->declQuad(c+78,"rvcpu my_regfile rs1_data_pre", false,-1, 63,0);
        tracep->declQuad(c+83,"rvcpu my_regfile rs2_data_pre", false,-1, 63,0);
    }
}

void Vrvcpu::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vrvcpu::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vrvcpu::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullQData(oldp+1,(vlTOPp->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r),64);
        tracep->fullQData(oldp+3,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0]),64);
        tracep->fullQData(oldp+5,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[1]),64);
        tracep->fullQData(oldp+7,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[2]),64);
        tracep->fullQData(oldp+9,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[3]),64);
        tracep->fullQData(oldp+11,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[4]),64);
        tracep->fullQData(oldp+13,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[5]),64);
        tracep->fullQData(oldp+15,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[6]),64);
        tracep->fullQData(oldp+17,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[7]),64);
        tracep->fullQData(oldp+19,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[8]),64);
        tracep->fullQData(oldp+21,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[9]),64);
        tracep->fullQData(oldp+23,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[10]),64);
        tracep->fullQData(oldp+25,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[11]),64);
        tracep->fullQData(oldp+27,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[12]),64);
        tracep->fullQData(oldp+29,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[13]),64);
        tracep->fullQData(oldp+31,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[14]),64);
        tracep->fullQData(oldp+33,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[15]),64);
        tracep->fullQData(oldp+35,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[16]),64);
        tracep->fullQData(oldp+37,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[17]),64);
        tracep->fullQData(oldp+39,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[18]),64);
        tracep->fullQData(oldp+41,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[19]),64);
        tracep->fullQData(oldp+43,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[20]),64);
        tracep->fullQData(oldp+45,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[21]),64);
        tracep->fullQData(oldp+47,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[22]),64);
        tracep->fullQData(oldp+49,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[23]),64);
        tracep->fullQData(oldp+51,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[24]),64);
        tracep->fullQData(oldp+53,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[25]),64);
        tracep->fullQData(oldp+55,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[26]),64);
        tracep->fullQData(oldp+57,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[27]),64);
        tracep->fullQData(oldp+59,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[28]),64);
        tracep->fullQData(oldp+61,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[29]),64);
        tracep->fullQData(oldp+63,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[30]),64);
        tracep->fullBit(oldp+65,(vlTOPp->clk));
        tracep->fullBit(oldp+66,(vlTOPp->rst));
        tracep->fullIData(oldp+67,(vlTOPp->inst),32);
        tracep->fullQData(oldp+68,(vlTOPp->inst_addr),64);
        tracep->fullBit(oldp+70,(vlTOPp->inst_ena));
        tracep->fullCData(oldp+71,((0x1fU & (vlTOPp->inst 
                                             >> 0xfU))),5);
        tracep->fullCData(oldp+72,((0x1fU & (vlTOPp->inst 
                                             >> 0x14U))),5);
        tracep->fullCData(oldp+73,((0x1fU & (vlTOPp->inst 
                                             >> 7U))),5);
        tracep->fullQData(oldp+74,(((0xfffffffffffff000ULL 
                                     & ((- (QData)((IData)(
                                                           (1U 
                                                            & (vlTOPp->inst 
                                                               >> 0x1fU))))) 
                                        << 0xcU)) | (QData)((IData)(
                                                                    (0xfffU 
                                                                     & (vlTOPp->inst 
                                                                        >> 0x14U)))))),64);
        tracep->fullQData(oldp+76,(vlTOPp->rvcpu__DOT__rd_data),64);
        tracep->fullQData(oldp+78,(((0U == (0x1fU & 
                                            (vlTOPp->inst 
                                             >> 0xfU)))
                                     ? 0ULL : ((0x1eU 
                                                >= 
                                                (0x1fU 
                                                 & ((vlTOPp->inst 
                                                     >> 0xfU) 
                                                    - (IData)(1U))))
                                                ? vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
                                               [(0x1fU 
                                                 & ((vlTOPp->inst 
                                                     >> 0xfU) 
                                                    - (IData)(1U)))]
                                                : 0ULL))),64);
        tracep->fullQData(oldp+80,((4ULL + vlTOPp->inst_addr)),64);
        tracep->fullSData(oldp+82,((0xfffU & (vlTOPp->inst 
                                              >> 0x14U))),12);
        tracep->fullQData(oldp+83,(((0U == (0x1fU & 
                                            (vlTOPp->inst 
                                             >> 0x14U)))
                                     ? 0ULL : ((0x1eU 
                                                >= 
                                                (0x1fU 
                                                 & ((vlTOPp->inst 
                                                     >> 0x14U) 
                                                    - (IData)(1U))))
                                                ? vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
                                               [(0x1fU 
                                                 & ((vlTOPp->inst 
                                                     >> 0x14U) 
                                                    - (IData)(1U)))]
                                                : 0ULL))),64);
        tracep->fullBit(oldp+85,(1U));
        tracep->fullBit(oldp+86,(0U));
        tracep->fullQData(oldp+87,(0ULL),64);
    }
}
