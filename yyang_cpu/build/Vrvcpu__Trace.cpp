// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vrvcpu__Syms.h"


void Vrvcpu::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vrvcpu::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgQData(oldp+0,(vlTOPp->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r),64);
            tracep->chgQData(oldp+2,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0]),64);
            tracep->chgQData(oldp+4,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[1]),64);
            tracep->chgQData(oldp+6,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[2]),64);
            tracep->chgQData(oldp+8,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[3]),64);
            tracep->chgQData(oldp+10,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[4]),64);
            tracep->chgQData(oldp+12,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[5]),64);
            tracep->chgQData(oldp+14,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[6]),64);
            tracep->chgQData(oldp+16,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[7]),64);
            tracep->chgQData(oldp+18,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[8]),64);
            tracep->chgQData(oldp+20,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[9]),64);
            tracep->chgQData(oldp+22,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[10]),64);
            tracep->chgQData(oldp+24,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[11]),64);
            tracep->chgQData(oldp+26,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[12]),64);
            tracep->chgQData(oldp+28,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[13]),64);
            tracep->chgQData(oldp+30,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[14]),64);
            tracep->chgQData(oldp+32,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[15]),64);
            tracep->chgQData(oldp+34,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[16]),64);
            tracep->chgQData(oldp+36,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[17]),64);
            tracep->chgQData(oldp+38,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[18]),64);
            tracep->chgQData(oldp+40,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[19]),64);
            tracep->chgQData(oldp+42,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[20]),64);
            tracep->chgQData(oldp+44,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[21]),64);
            tracep->chgQData(oldp+46,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[22]),64);
            tracep->chgQData(oldp+48,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[23]),64);
            tracep->chgQData(oldp+50,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[24]),64);
            tracep->chgQData(oldp+52,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[25]),64);
            tracep->chgQData(oldp+54,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[26]),64);
            tracep->chgQData(oldp+56,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[27]),64);
            tracep->chgQData(oldp+58,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[28]),64);
            tracep->chgQData(oldp+60,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[29]),64);
            tracep->chgQData(oldp+62,(vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[30]),64);
        }
        tracep->chgBit(oldp+64,(vlTOPp->clk));
        tracep->chgBit(oldp+65,(vlTOPp->rst));
        tracep->chgIData(oldp+66,(vlTOPp->inst),32);
        tracep->chgQData(oldp+67,(vlTOPp->inst_addr),64);
        tracep->chgBit(oldp+69,(vlTOPp->inst_ena));
        tracep->chgCData(oldp+70,((0x1fU & (vlTOPp->inst 
                                            >> 0xfU))),5);
        tracep->chgCData(oldp+71,((0x1fU & (vlTOPp->inst 
                                            >> 0x14U))),5);
        tracep->chgCData(oldp+72,((0x1fU & (vlTOPp->inst 
                                            >> 7U))),5);
        tracep->chgQData(oldp+73,(((0xfffffffffffff000ULL 
                                    & ((- (QData)((IData)(
                                                          (1U 
                                                           & (vlTOPp->inst 
                                                              >> 0x1fU))))) 
                                       << 0xcU)) | (QData)((IData)(
                                                                   (0xfffU 
                                                                    & (vlTOPp->inst 
                                                                       >> 0x14U)))))),64);
        tracep->chgQData(oldp+75,(vlTOPp->rvcpu__DOT__rd_data),64);
        tracep->chgQData(oldp+77,(((0U == (0x1fU & 
                                           (vlTOPp->inst 
                                            >> 0xfU)))
                                    ? 0ULL : ((0x1eU 
                                               >= (0x1fU 
                                                   & ((vlTOPp->inst 
                                                       >> 0xfU) 
                                                      - (IData)(1U))))
                                               ? vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
                                              [(0x1fU 
                                                & ((vlTOPp->inst 
                                                    >> 0xfU) 
                                                   - (IData)(1U)))]
                                               : 0ULL))),64);
        tracep->chgQData(oldp+79,((4ULL + vlTOPp->inst_addr)),64);
        tracep->chgSData(oldp+81,((0xfffU & (vlTOPp->inst 
                                             >> 0x14U))),12);
        tracep->chgQData(oldp+82,(((0U == (0x1fU & 
                                           (vlTOPp->inst 
                                            >> 0x14U)))
                                    ? 0ULL : ((0x1eU 
                                               >= (0x1fU 
                                                   & ((vlTOPp->inst 
                                                       >> 0x14U) 
                                                      - (IData)(1U))))
                                               ? vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
                                              [(0x1fU 
                                                & ((vlTOPp->inst 
                                                    >> 0x14U) 
                                                   - (IData)(1U)))]
                                               : 0ULL))),64);
    }
}

void Vrvcpu::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vrvcpu__Syms* __restrict vlSymsp = static_cast<Vrvcpu__Syms*>(userp);
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
