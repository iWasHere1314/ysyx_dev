// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrvcpu.h for the primary calling header

#include "Vrvcpu.h"
#include "Vrvcpu__Syms.h"

//==========

Vrvcpu::Vrvcpu(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModule{_vcname__}
 {
    Vrvcpu__Syms* __restrict vlSymsp = __VlSymsp = new Vrvcpu__Syms(_vcontextp__, this, name());
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values

    // Reset structure values
    _ctor_var_reset(this);
}

void Vrvcpu::__Vconfigure(Vrvcpu__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    vlSymsp->_vm_contextp__->timeunit(-9);
    vlSymsp->_vm_contextp__->timeprecision(-12);
}

Vrvcpu::~Vrvcpu() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = nullptr);
}

void Vrvcpu::_initial__TOP__1(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_initial__TOP__1\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->inst_ena = 1U;
}

void Vrvcpu::_settle__TOP__3(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_settle__TOP__3\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->inst_addr = vlTOPp->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r;
    vlTOPp->rvcpu__DOT__rd_data = (((0U == (0x1fU & 
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
                                                : 0ULL)) 
                                   + ((0xfffffffffffff000ULL 
                                       & ((- (QData)((IData)(
                                                             (1U 
                                                              & (vlTOPp->inst 
                                                                 >> 0x1fU))))) 
                                          << 0xcU)) 
                                      | (QData)((IData)(
                                                        (0xfffU 
                                                         & (vlTOPp->inst 
                                                            >> 0x14U))))));
}

void Vrvcpu::_eval_initial(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_eval_initial\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
}

void Vrvcpu::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::final\n"); );
    // Variables
    Vrvcpu__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vrvcpu::_eval_settle(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_eval_settle\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__3(vlSymsp);
}

void Vrvcpu::_ctor_var_reset(Vrvcpu* self) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_ctor_var_reset\n"); );
    // Body
    if (false && self) {}  // Prevent unused
    self->clk = VL_RAND_RESET_I(1);
    self->rst = VL_RAND_RESET_I(1);
    self->inst = VL_RAND_RESET_I(32);
    self->inst_addr = VL_RAND_RESET_Q(64);
    self->inst_ena = VL_RAND_RESET_I(1);
    self->rvcpu__DOT__rd_data = VL_RAND_RESET_Q(64);
    self->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r = VL_RAND_RESET_Q(64);
    for (int __Vi0=0; __Vi0<31; ++__Vi0) {
        self->rvcpu__DOT__my_regfile__DOT__regfile_r[__Vi0] = VL_RAND_RESET_Q(64);
    }
    for (int __Vi0=0; __Vi0<2; ++__Vi0) {
        self->__Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }
}
