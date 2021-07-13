// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrvcpu.h for the primary calling header

#include "Vrvcpu.h"
#include "Vrvcpu__Syms.h"

//==========

VerilatedContext* Vrvcpu::contextp() {
    return __VlSymsp->_vm_contextp__;
}

void Vrvcpu::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vrvcpu::eval\n"); );
    Vrvcpu__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("rvcpu.v", 7, "",
                "Verilated model didn't converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vrvcpu::_eval_initial_loop(Vrvcpu__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("rvcpu.v", 7, "",
                "Verilated model didn't DC converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vrvcpu::_sequent__TOP__2(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_sequent__TOP__2\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v0;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v1;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v2;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v3;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v4;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v5;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v6;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v7;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v8;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v9;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v10;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v11;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v12;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v13;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v14;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v15;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v16;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v17;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v18;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v19;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v20;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v21;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v22;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v23;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v24;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v25;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v26;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v27;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v28;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v29;
    QData/*63:0*/ __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v30;
    // Body
    if (vlTOPp->rst) {
        vlTOPp->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v0 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v1 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v2 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v3 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v4 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v5 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v6 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v7 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v8 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v9 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v10 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v11 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v12 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v13 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v14 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v15 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v16 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v17 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v18 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v19 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v20 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v21 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v22 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v23 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v24 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v25 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v26 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v27 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v28 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v29 = 0ULL;
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v30 = 0ULL;
    } else {
        vlTOPp->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r 
            = (4ULL + vlTOPp->inst_addr);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v0 
            = ((1U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v1 
            = ((2U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [1U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v2 
            = ((3U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [2U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v3 
            = ((4U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [3U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v4 
            = ((5U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [4U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v5 
            = ((6U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [5U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v6 
            = ((7U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [6U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v7 
            = ((8U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [7U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v8 
            = ((9U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [8U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v9 
            = ((0xaU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [9U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v10 
            = ((0xbU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0xaU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v11 
            = ((0xcU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0xbU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v12 
            = ((0xdU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0xcU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v13 
            = ((0xeU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0xdU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v14 
            = ((0xfU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0xeU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v15 
            = ((0x10U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0xfU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v16 
            = ((0x11U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x10U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v17 
            = ((0x12U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x11U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v18 
            = ((0x13U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x12U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v19 
            = ((0x14U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x13U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v20 
            = ((0x15U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x14U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v21 
            = ((0x16U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x15U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v22 
            = ((0x17U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x16U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v23 
            = ((0x18U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x17U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v24 
            = ((0x19U == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x18U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v25 
            = ((0x1aU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x19U]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v26 
            = ((0x1bU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x1aU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v27 
            = ((0x1cU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x1bU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v28 
            = ((0x1dU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x1cU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v29 
            = ((0x1eU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x1dU]);
        __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v30 
            = ((0x1fU == (0x1fU & (vlTOPp->inst >> 7U)))
                ? vlTOPp->rvcpu__DOT__rd_data : vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r
               [0x1eU]);
    }
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v0;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[1U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v1;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[2U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v2;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[3U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v3;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[4U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v4;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[5U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v5;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[6U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v6;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[7U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v7;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[8U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v8;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[9U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v9;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0xaU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v10;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0xbU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v11;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0xcU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v12;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0xdU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v13;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0xeU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v14;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0xfU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v15;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x10U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v16;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x11U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v17;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x12U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v18;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x13U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v19;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x14U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v20;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x15U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v21;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x16U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v22;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x17U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v23;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x18U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v24;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x19U] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v25;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x1aU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v26;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x1bU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v27;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x1cU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v28;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x1dU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v29;
    vlTOPp->rvcpu__DOT__my_regfile__DOT__regfile_r[0x1eU] 
        = __Vdlyvval__rvcpu__DOT__my_regfile__DOT__regfile_r__v30;
    vlTOPp->inst_addr = vlTOPp->rvcpu__DOT__my_if_top__DOT__my_if_pc__DOT__cur_inst_addr_r;
}

VL_INLINE_OPT void Vrvcpu::_combo__TOP__4(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_combo__TOP__4\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
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

void Vrvcpu::_eval(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_eval\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->clk) & (~ (IData)(vlTOPp->__Vclklast__TOP__clk)))) {
        vlTOPp->_sequent__TOP__2(vlSymsp);
        vlTOPp->__Vm_traceActivity[1U] = 1U;
    }
    vlTOPp->_combo__TOP__4(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
}

VL_INLINE_OPT QData Vrvcpu::_change_request(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_change_request\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vrvcpu::_change_request_1(Vrvcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_change_request_1\n"); );
    Vrvcpu* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vrvcpu::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrvcpu::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
}
#endif  // VL_DEBUG
