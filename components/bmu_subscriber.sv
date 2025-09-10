class bmu_subscriber extends uvm_subscriber #(bmu_sequence_item); 
`uvm_component_utils(bmu_subscriber) 

bmu_sequence_item sub; 

covergroup bmuCoverage;
    // Input operand coverage with special value bins
    A: coverpoint sub.a_in {
        bins zero = {32'h00000000};
        bins ones = {32'hFFFFFFFF};
        bins pos = {[32'h00000001: 32'h7FFFFFFF]};
        bins max_pos = {32'h7FFFFFFF};
        bins neg = {[32'h80000000: 32'hFFFFFFFF]};
        bins max_neg = {32'h80000000};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }
    
    B: coverpoint sub.b_in {
        bins zero = {32'h00000000};
        bins ones = {32'hFFFFFFFF};
        bins pos = {[32'h00000001: 32'h7FFFFFFF]};
        bins max_pos = {32'h7FFFFFFF};
        bins neg = {[32'h80000000: 32'hFFFFFFFF]};
        bins max_neg = {32'h80000000};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }

    AP_CSR_RDATA: coverpoint sub.csr_rddata_in {
        bins zero = {32'h00000000};
        bins ones = {32'hFFFFFFFF};
        bins pos = {[32'h00000001: 32'h7FFFFFFF]};
        bins neg = {[32'h80000000: 32'hFFFFFFFF]};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }
    
    // reset signal coverage
    RST: coverpoint sub.rst_l ;
    
    // valid_in signal
    VALID_IN: coverpoint sub.valid_in;
    
    // CSR read enable signal
    CSR_REN_IN: coverpoint sub.csr_ren_in;
    
    // Arithmetic operations
    AP_ADD: coverpoint sub.ap.add;
    
    // Logical operations
    AP_LAND: coverpoint sub.ap.land;
    AP_LXOR: coverpoint sub.ap.lxor;
    
    // Shifting and masking operations
    AP_SLL: coverpoint sub.ap.sll;
    AP_SRA: coverpoint sub.ap.sra;
    AP_ROL: coverpoint sub.ap.rol;
    AP_BEXT: coverpoint sub.ap.bext;
    AP_SH3ADD: coverpoint sub.ap.sh3add;
    
    // Bit manipulation operations
    AP_SLT: coverpoint sub.ap.slt;
    AP_CLZ: coverpoint sub.ap.clz;
    AP_CPOP: coverpoint sub.ap.cpop;
    AP_SIEXT_H: coverpoint sub.ap.siext_h;
    AP_MIN: coverpoint sub.ap.min;
    AP_PACKU: coverpoint sub.ap.packu;
    AP_GORC: coverpoint sub.ap.gorc;
    
    // Extension controls
    AP_ZBB: coverpoint sub.ap.zbb;
    AP_ZBA: coverpoint sub.ap.zba;

    AP_UNSIGN: coverpoint sub.ap.unsign;
    AP_SUB: coverpoint sub.ap.sub;
    
    // CSR operations
    AP_CSR_WRITE: coverpoint sub.ap.csr_write;
    AP_CSR_IMM: coverpoint sub.ap.csr_imm;
    
    // Result coverage
    Result: coverpoint sub.result_ff {
        bins zero = {32'h00000000};
        bins ones = {32'hFFFFFFFF};
        bins pos = {[32'h00000001: 32'h7FFFFFFF]};
        bins max_pos = {32'h7FFFFFFF};
        bins neg = {[32'h80000000: 32'hFFFFFFFF]};
        bins max_neg = {32'h80000000};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }
    
    // Error coverage
    Error: coverpoint sub.error;
    
    // ===================================================================
    // INSTRUCTION-SPECIFIC CROSS COVERAGE WITH INTERESTING VALUES
    // Tracks each instruction with corner case values in operands A & B
    // ===================================================================
    
    // Logical Instructions with Interesting Values
    LAND_WITH_CORNERS: cross AP_LAND, A, B {
        ignore_bins ignore_land_inactive = binsof(AP_LAND) intersect {0};
        ignore_bins ignore_max_pos_neg = binsof(AP_LAND) intersect {1} && (binsof(A.max_pos) || binsof(A.max_neg) ||
                                         binsof(B.max_pos) || binsof(B.max_neg));
        
        bins land_zero_ops = binsof(AP_LAND) intersect {1} && (binsof(A.zero) || binsof(B.zero));
        bins land_ones_ops = binsof(AP_LAND) intersect {1} && (binsof(A.ones) || binsof(B.ones));
        bins land_patterns = binsof(AP_LAND) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                             binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }
    
    LXOR_WITH_CORNERS: cross AP_LXOR, A, B {
        ignore_bins ignore_lxor_inactive = binsof(AP_LXOR) intersect {0};
        ignore_bins ignore_max_pos_neg = binsof(AP_LXOR) intersect {1} && (binsof(A.max_pos) || binsof(A.max_neg) ||
                                         binsof(B.max_pos) || binsof(B.max_neg));
        
        bins lxor_zero_ops = binsof(AP_LXOR) intersect {1} && (binsof(A.zero) || binsof(B.zero));
        bins lxor_ones_ops = binsof(AP_LXOR) intersect {1} && (binsof(A.ones) || binsof(B.ones));
        bins lxor_patterns = binsof(AP_LXOR) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                             binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }
    
    // Shift Instructions with Interesting Values  
    SLL_WITH_CORNERS: cross AP_SLL, A, B {
        ignore_bins ignore_sll_inactive = binsof(AP_SLL) intersect {0};
        ignore_bins ignore_b_alt_patterns = binsof(AP_SLL) intersect {1} && (binsof(B.alt_pattern1) || binsof(B.alt_pattern2));

        ignore_bins ignore_pos_neg_b = binsof(AP_SLL) intersect {1} && (binsof(B.pos) || binsof(B.neg) || 
                                   binsof(B.max_pos) || binsof(B.max_neg));
        
        bins sll_zero_shift = binsof(AP_SLL) intersect {1} && binsof(B.zero);
        bins sll_max_shift = binsof(AP_SLL) intersect {1} && (binsof(B.max_pos) || binsof(B.ones));
        bins a_is_zero = binsof(AP_SLL) intersect {1} && (binsof(A.zero) || binsof(B.zero));
        bins a_is_ones = binsof(AP_SLL) intersect {1} && (binsof(A.ones) || binsof(B.ones));
        bins sll_patterns = binsof(AP_SLL) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
    }
    
    SRA_WITH_CORNERS: cross AP_SRA, A, B {
        ignore_bins ignore_sra_inactive = binsof(AP_SRA) intersect {0};
        ignore_bins ignore_b_alt_patterns = binsof(AP_SRA) intersect {1} && (binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
        ignore_bins ignore_pos_neg_b =  binsof(AP_SRA) intersect {1} && (binsof(B.pos) || binsof(B.neg) || binsof(B.max_neg) || binsof(B.max_pos));
        
        bins sra_zero_shift = binsof(AP_SRA) intersect {1} && binsof(B.zero);
        bins sra_max_shift = binsof(AP_SRA) intersect {1} && (binsof(B.max_pos) || binsof(B.ones));
        bins sra_patterns = binsof(AP_SRA) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
        bins shift_pos = binsof(AP_SRA) intersect {1} && (binsof(A.pos));
        bins shift_neg = binsof(AP_SRA) intersect {1} && (binsof(A.neg));
    }
    
    ROL_WITH_CORNERS: cross AP_ROL, A, B {
        ignore_bins ignore_rol_inactive = binsof(AP_ROL) intersect {0};
        ignore_bins ignore_b_alt_patterns = binsof(AP_ROL) intersect {1} && (binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
        ignore_bins ignore_pos_neg_b = binsof(AP_ROL) intersect {1} && (binsof(B.pos) || binsof(B.neg) || binsof(B.max_neg) || binsof(B.max_pos));
        
        bins rol_zero_shift = binsof(AP_ROL) intersect {1} && binsof(B.zero);
        bins rol_max_shift = binsof(AP_ROL) intersect {1} && (binsof(B.ones));
        bins rol_patterns = binsof(AP_ROL) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
    }
    
    // Bit Manipulation Instructions with Interesting Values
    BEXT_WITH_CORNERS: cross AP_BEXT, A, B {
        ignore_bins ignore_bext_inactive = binsof(AP_BEXT) intersect {0};
        ignore_bins ignore_b_alt_patterns = binsof(AP_BEXT) intersect {1} && (binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
        ignore_bins ignore_pos_neg_b = binsof(AP_BEXT) intersect {1} && (binsof(B.neg) || binsof(B.max_neg));
        ignore_bins ignore_a_pos_neg = binsof(AP_BEXT) intersect {1} && (binsof(A.pos) || binsof(A.neg) || 
                                   binsof(A.max_pos) || binsof(A.max_neg));

        bins bext_zero_ops = binsof(AP_BEXT) intersect {1} && (binsof(A.zero));
        bins b_is_zero = binsof(AP_BEXT) intersect {1} && (binsof(B.zero));
        bins bext_ones_ops = binsof(AP_BEXT) intersect {1} && (binsof(A.ones));
        bins bext_patterns = binsof(AP_BEXT) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
    }

    SH3ADD_WITH_CORNERS: cross AP_SH3ADD, A, B {
        ignore_bins ignore_sh3add_inactive = binsof(AP_SH3ADD) intersect {0};
        ignore_bins ignore_max_pos_neg = binsof(AP_SH3ADD) intersect {1} && (binsof(A.max_pos) || binsof(A.max_neg) );
        
        bins sh3add_zero_ops = binsof(AP_SH3ADD) intersect {1} && 
                              (binsof(A.zero) || binsof(B.zero));
        bins sh3add_max_pos = binsof(AP_SH3ADD) intersect {1} && 
                             (binsof(A.max_pos) || binsof(B.max_pos));
        bins sh3add_A_patterns = binsof(AP_SH3ADD) intersect {1} && 
                              (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
        bins sh3add_B_patterns = binsof(AP_SH3ADD) intersect {1} && 
                              (binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }

    // Arithmetic Instructions with Interesting Values
    ADD_WITH_CORNERS: cross AP_ADD, A, B {
        // Ignore all cases where ADD is not active (ADD = 0)
        ignore_bins ignore_add_inactive = binsof(AP_ADD) intersect {0};
        
        bins add_zero_ops = binsof(AP_ADD) intersect {1} && (binsof(A.zero) || binsof(B.zero));
        bins add_ones_ops = binsof(AP_ADD) intersect {1} && (binsof(A.ones) || binsof(B.ones));
        bins add_pos_negs = binsof(AP_ADD) intersect {1} && (binsof(A.pos) || binsof(A.neg) ||
                            binsof(B.pos) || binsof(B.neg));
        bins add_max_pos = binsof(AP_ADD) intersect {1} && (binsof(A.max_pos) || binsof(B.max_pos));
        bins add_max_neg = binsof(AP_ADD) intersect {1} && (binsof(A.max_neg) || binsof(B.max_neg));
        bins add_patterns = binsof(AP_ADD) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                            binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }

    // Bit Manipulation Instructions with Interesting Values
    SLT_WITH_CORNERS: cross AP_SLT,AP_SUB,AP_UNSIGN, A, B {
        ignore_bins ignore_slt_inactive = binsof(AP_SLT) intersect {0};
        ignore_bins ignore_sub_inactive = binsof(AP_SUB) intersect {0};
        ignore_bins ignore_alternate_patterns = binsof(AP_SLT) intersect {1} && 
                           (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                            binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
        ignore_bins ignore_unsigned = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {1} &&
                           binsof(AP_SUB) intersect {1} && (binsof(A.max_neg) || binsof(A.max_pos) || binsof(B.max_neg) || binsof(B.max_pos));
        
        bins slt_zero_cmp = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {1} &&
                           binsof(AP_SUB) intersect {1} && (binsof(A.zero) || binsof(B.zero));
        bins slt_ones_cmp = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {1} &&
                           binsof(AP_SUB) intersect {1} && (binsof(A.ones) || binsof(B.ones));

        bins slt_min_cmp = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {0} &&
                           binsof(AP_SUB) intersect {1} && (binsof(A.max_neg) || binsof(B.max_neg));
        bins slt_max_cmp = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {0} &&
                           binsof(AP_SUB) intersect {1} && (binsof(A.max_pos) || binsof(B.max_pos));

        bins slt_equal_values_unsigned = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {1} &&
                            binsof(AP_SUB) intersect {1} && (binsof(A.zero) && binsof(B.zero));
        bins slt_equal_values_signed = binsof(AP_SLT) intersect {1} && binsof(AP_UNSIGN) intersect {0} &&
                            binsof(AP_SUB) intersect {1} && (binsof(A.zero) && binsof(B.zero));
    }
    
    CLZ_WITH_CORNERS: cross AP_CLZ, A {
        ignore_bins ignore_clz_inactive = binsof(AP_CLZ) intersect {0};
        
        // bins clz_zero = binsof(AP_CLZ) intersect {1} && binsof(A.zero);
        // bins clz_ones = binsof(AP_CLZ) intersect {1} && binsof(A.ones);
        // bins clz_max_pos = binsof(AP_CLZ) intersect {1} && binsof(A.max_pos);
        // bins clz_patterns = binsof(AP_CLZ) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
    }
    
    CPOP_WITH_CORNERS: cross AP_CPOP, A {
        ignore_bins ignore_cpop_inactive = binsof(AP_CPOP) intersect {0};
        
        // bins cpop_zero = binsof(AP_CPOP) intersect {1} && binsof(A.zero);
        // bins cpop_ones = binsof(AP_CPOP) intersect {1} && binsof(A.ones);
        // bins cpop_patterns = binsof(AP_CPOP) intersect {1} && (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
    }
    
    SIEXT_H_WITH_CORNERS: cross AP_SIEXT_H, A {
        ignore_bins ignore_siext_h_inactive = binsof(AP_SIEXT_H) intersect {0};
        ignore_bins alternate_patterns = binsof(AP_SIEXT_H) intersect {1} && 
                           (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
        
        // bins siext_h_zero = binsof(AP_SIEXT_H) intersect {1} && binsof(A.zero);
        // bins siext_h_ones = binsof(AP_SIEXT_H) intersect {1} && binsof(A.ones);
        // bins siext_h_max_pos = binsof(AP_SIEXT_H) intersect {1} && binsof(A.max_pos);
        bins siext_h_patterns = binsof(AP_SIEXT_H) intersect {1} && 
                               (binsof(A) intersect {32'h0000AAAA} || binsof(A) intersect {32'h00005555});
    }
    
    
    MIN_WITH_CORNERS: cross AP_MIN, A, B {
        ignore_bins ignore_min_inactive = binsof(AP_MIN) intersect {0};
        
        bins min_zero_ops = binsof(AP_MIN) intersect {1} && 
                           (binsof(A.zero) || binsof(B.zero));
        bins min_max_cmp = binsof(AP_MIN) intersect {1} && 
                          (binsof(A.max_pos) || binsof(A.max_neg) ||
                           binsof(B.max_pos) || binsof(B.max_neg));
        bins min_equal_values = binsof(AP_MIN) intersect {1} && 
                               (binsof(A.zero) && binsof(B.zero));
        bins alternate_patterns = binsof(AP_MIN) intersect {1} && 
                               (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                                binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }
    
    PACKU_WITH_CORNERS: cross AP_PACKU, A, B {
        ignore_bins ignore_packu_inactive = binsof(AP_PACKU) intersect {0};
        ignore_bins ignore_max_pos_neg = binsof(AP_PACKU) intersect {1} && (binsof(A.max_pos) || binsof(A.max_neg) ||
                                         binsof(B.max_pos) || binsof(B.max_neg));
        
        bins packu_zero_ops = binsof(AP_PACKU) intersect {1} && 
                             (binsof(A) intersect {[32'h00000000 : 32'h0000FFFF]} || binsof(B) intersect {[32'h00000000 : 32'h0000FFFF]});
        bins packu_ones_ops = binsof(AP_PACKU) intersect {1} && 
                             (binsof(A) intersect {[32'hFFFF0000 : 32'hFFFFFFFF]} || binsof(B) intersect {[32'hFFFF0000 : 32'hFFFFFFFF]});
        bins packu_patterns = binsof(AP_PACKU) intersect {1} && 
                             (binsof(A) intersect {[32'hAAAA0000 : 32'hAAAAFFFF]} || binsof(B) intersect {[32'h55550000 : 32'h5555FFFF]});
        bins packu_full_patterns = binsof(AP_PACKU) intersect {1} && 
                                (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                                 binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }
    
    GORC_WITH_CORNERS: cross AP_GORC, A, B {
        ignore_bins ignore_gorc_inactive = binsof(AP_GORC) intersect {0};
        ignore_bins ignore_b = binsof(B.zero) || binsof(B.ones) || binsof(B.alt_pattern1) || binsof(B.alt_pattern2) ||
                               binsof(B.max_pos) || binsof(B.max_neg);
        ignore_bins ignore_a_pos_neg = binsof(AP_GORC) intersect {1} && (binsof(A.max_pos) || binsof(A.max_neg));
        
        // Corner case: All bytes zero (affects GORC byte-level operations)
        bins gorc_zero_a = binsof(AP_GORC) intersect {1} && binsof(B) intersect {[32'h00000111:32'hFFF00111]} && binsof(A.zero);
        
        // Corner case: All bytes all ones (maximum GORC transformation)
        bins gorc_ones_a = binsof(AP_GORC) intersect {1} && binsof(B) intersect {[32'h00000111:32'hFFF00111]} && binsof(A.ones);
        
        // Pattern testing: Alternating patterns for byte-level GORC
        bins gorc_alt_pattern = binsof(AP_GORC) intersect {1} && binsof(B) intersect {[32'h00000111:32'hFFF00111]} &&
                                  (binsof(A.alt_pattern1) || binsof(A.alt_pattern2));
    }
    
    // ===================================================================
    // CSR OPERATIONS COVERAGE - Simple unified cross for read and write
    // ===================================================================
    CSR_READ: cross CSR_REN_IN,AP_CSR_RDATA {
        // Ignore invalid combinations
        // ignore_bins ignore_invalid_trans = binsof(VALID_IN) intersect {0};
        // ignore_bins ignore_A_B_max = (binsof(A.max_pos) || binsof(A.max_neg) || binsof(B.max_pos) || binsof(B.max_neg));
        
        // CSR Read operations with corner case data
        bins csr_read_zero_data = binsof(CSR_REN_IN) intersect {1} && binsof(AP_CSR_RDATA.zero);
        bins csr_read_ones_data = binsof(CSR_REN_IN) intersect {1} && binsof(AP_CSR_RDATA.ones);
        bins csr_read_patterns = binsof(CSR_REN_IN) intersect {1} && (binsof(AP_CSR_RDATA.alt_pattern1) || binsof(AP_CSR_RDATA.alt_pattern2));
        
    }


    CSR_WRITE_WITH_CORNERS: cross AP_CSR_WRITE, AP_CSR_IMM, A, B {
        ignore_bins ignore_csr_write_inactive = binsof(AP_CSR_WRITE) intersect {0};
        ignore_bins ignore_A_B_max = (binsof(A.max_pos) || binsof(A.max_neg) || binsof(B.max_pos) || binsof(B.max_neg));
        
        // CSR Write operations with immediate mode
        bins csr_write_imm_zero = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                 (binsof(A.zero) || binsof(B.zero));
        bins csr_write_imm_ones = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                 (binsof(A.ones) || binsof(B.ones));
        bins csr_write_imm_patterns = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                     (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                                     binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
        
        // CSR Write operations with register mode
        bins csr_write_reg_zero = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                 (binsof(A.zero) || binsof(B.zero));
        bins csr_write_reg_ones = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                 (binsof(A.ones) || binsof(B.ones));
        bins csr_write_reg_patterns = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                     (binsof(A.alt_pattern1) || binsof(A.alt_pattern2) ||
                                     binsof(B.alt_pattern1) || binsof(B.alt_pattern2));
    }


    // ===================================================================
    // SIMPLE ERROR COVERAGE 
    // Basic error conditions without complex combinations
    // ===================================================================
    SIMPLE_ERROR_CROSS: cross Error, VALID_IN, AP_CSR_WRITE {
        
        // Basic error cases
        bins error_with_valid = binsof(Error) intersect {1} && binsof(VALID_IN) intersect {1};
        bins error_with_invalid = binsof(Error) intersect {1} && binsof(VALID_IN) intersect {0};
        bins csr_write_error = binsof(Error) intersect {1} && binsof(AP_CSR_WRITE) intersect {1};
        
        // No error cases
        bins no_error_valid = binsof(Error) intersect {0} && binsof(VALID_IN) intersect {1};
        bins no_error_invalid = binsof(Error) intersect {0} && binsof(VALID_IN) intersect {0};
    }
    
endgroup

function new(string name,uvm_component parent); 
    super.new(name,parent); 
    bmuCoverage = new(); 
    sub = new(); 
endfunction

function void write (bmu_sequence_item t);
    sub.rst_l = t.rst_l;
    sub.a_in = t.a_in; 
    sub.b_in = t.b_in; 
    sub.valid_in = t.valid_in;
    sub.scan_mode = t.scan_mode;
    sub.csr_ren_in = t.csr_ren_in;
    sub.csr_rddata_in = t.csr_rddata_in;
    sub.ap = t.ap; 
    sub.result_ff = t.result_ff; 
    sub.error = t.error; 
    bmuCoverage.sample();
endfunction

function void report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    `uvm_info(get_type_name,  
    $sformatf("=== BMU COVERAGE REPORT ==="), UVM_LOW);
    `uvm_info(get_type_name,  
    $sformatf("Overall Coverage: %.2f%%", bmuCoverage.get_coverage()), UVM_LOW);
    
    // Input operand coverage
    `uvm_info(get_type_name,  
    $sformatf("Input Operand Coverage - A: %.2f%%, B: %.2f%%", 
              bmuCoverage.A.get_coverage(), bmuCoverage.B.get_coverage()), UVM_MEDIUM);
    
    
    // Instruction-specific coverage with corner cases
    `uvm_info(get_type_name,  
    $sformatf("=== INSTRUCTION-SPECIFIC CORNER CASE COVERAGE ==="), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("ADD with corners: %.2f%%", bmuCoverage.ADD_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("LAND with corners: %.2f%%", bmuCoverage.LAND_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("LXOR with corners: %.2f%%", bmuCoverage.LXOR_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("SLL with corners: %.2f%%", bmuCoverage.SLL_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("SRA with corners: %.2f%%", bmuCoverage.SRA_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("ROL with corners: %.2f%%", bmuCoverage.ROL_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("BEXT with corners: %.2f%%", bmuCoverage.BEXT_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("CLZ with corners: %.2f%%", bmuCoverage.CLZ_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("CPOP with corners: %.2f%%", bmuCoverage.CPOP_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("SH3ADD with corners: %.2f%%", bmuCoverage.SH3ADD_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("SLT with corners: %.2f%%", bmuCoverage.SLT_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("MIN with corners: %.2f%%", bmuCoverage.MIN_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("PACKU with corners: %.2f%%", bmuCoverage.PACKU_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("GORC with corners: %.2f%%", bmuCoverage.GORC_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("SIEXT_H with corners: %.2f%%", bmuCoverage.SIEXT_H_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    
    // CSR Operations coverage
    `uvm_info(get_type_name,  
    $sformatf("=== CSR OPERATIONS COVERAGE ==="), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("CSR READ: %.2f%%", bmuCoverage.CSR_READ.get_coverage()), UVM_MEDIUM);
    
    `uvm_info(get_type_name,  
    $sformatf("CSR Write: %.2f%%", bmuCoverage.CSR_WRITE_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    // Error coverage
    `uvm_info(get_type_name,  
    $sformatf("=== ERROR COVERAGE REPORT ==="), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Overall Error Coverage: %.2f%%", bmuCoverage.Error.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Simple Error Cross Coverage: %.2f%%", bmuCoverage.SIMPLE_ERROR_CROSS.get_coverage()), UVM_MEDIUM);
    
    `uvm_info(get_type_name,  
    $sformatf("=== END BMU COVERAGE REPORT ==="), UVM_LOW);
endfunction
endclass