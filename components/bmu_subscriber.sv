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
    
    // reset signal coverage
    RST: coverpoint sub.rst_l ;
    
    // valid_in signal
    VALID_IN: coverpoint sub.valid_in;
    
    // CSR read enable signal
    CSR_REN_IN: coverpoint sub.csr_ren_in;
    
    // CSR read data coverage
    CSR_RDDATA_IN: coverpoint sub.csr_rddata_in {
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
    AP_ZBP: coverpoint sub.ap.zbp;
    AP_ZBA: coverpoint sub.ap.zba;
    AP_ZBS: coverpoint sub.ap.zbs;

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
    // CSR WRITE OPERATION COVERAGE
    // Covers CSR write operations with different modes and data patterns
    // ===================================================================
    CSR_WRITE_WITH_CORNERS: cross AP_CSR_WRITE, AP_CSR_IMM, A, B, Error {
        ignore_bins ignore_csr_write_inactive = binsof(AP_CSR_WRITE) intersect {0};
        ignore_bins ignore_max_pos_neg = binsof(AP_CSR_WRITE) intersect {1} && (binsof(A.max_pos) || binsof(A.max_neg) ||
                                         binsof(B.max_pos) || binsof(B.max_neg));
        
        // CSR Write Immediate Mode (csr_imm=1) with different data patterns
        bins csr_write_imm_zero_a = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                   binsof(A.zero) ;
        bins csr_write_imm_ones_a = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                   binsof(A.ones)  ;
        bins csr_write_imm_alt_pattern = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                           (binsof(A.alt_pattern1) || binsof(A.alt_pattern2)) ;

        
        
        // CSR Write Register Mode (csr_imm=0) with different data patterns in B register
        bins csr_write_reg_zero_b = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                   binsof(B.zero)  ;
        bins csr_write_reg_ones_b = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                   binsof(B.ones)  ;

        bins csr_write_reg_alt_pattern1 = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                           (binsof(B.alt_pattern1) || binsof(B.alt_pattern2)) ;
        
        // Cross coverage between A and B for register mode (both inputs matter)
        bins csr_write_reg_zero_cross = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                       binsof(A.zero) && binsof(B.zero) ;
        bins csr_write_reg_alt_cross = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                      binsof(A.alt_pattern1) && binsof(B.alt_pattern2) ;

        
       
        // Ignore patterns that are less relevant for CSR operations
        ignore_bins ignore_pos_neg_patterns = binsof(AP_CSR_WRITE) intersect {1} && 
                                             (binsof(A.pos) || binsof(A.neg) || binsof(B.pos) || binsof(B.neg));
    }

    // ===================================================================
    // CSR READ CONFLICTS - These are the main error conditions from error sequence
    // CSR read active (csr_ren_in=1) with any other operation causes errors
    // ===================================================================
    CSR_READ_CONFLICTS: cross Error, CSR_REN_IN, AP_ADD, AP_SUB, AP_LAND, AP_LXOR, 
                              AP_SLL, AP_SRA, AP_ROL, AP_BEXT, AP_SH3ADD, AP_SLT, 
                              AP_CLZ, AP_CPOP, AP_SIEXT_H, AP_MIN, AP_PACKU, AP_GORC, 
                              AP_CSR_WRITE {
        
        // Ignore valid cases (no CSR read conflict)
        ignore_bins valid_no_csr_read = binsof(CSR_REN_IN) intersect {0};
        ignore_bins valid_csr_read_only = binsof(Error) intersect {0} && binsof(CSR_REN_IN) intersect {1};
        
        // CSR read conflicts with individual operations
        bins csr_read_conflict_add = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_ADD) intersect {1};
        bins csr_read_conflict_sub = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_SUB) intersect {1};
        bins csr_read_conflict_land = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_LAND) intersect {1};
        bins csr_read_conflict_lxor = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_LXOR) intersect {1};
        bins csr_read_conflict_sll = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_SLL) intersect {1};
        bins csr_read_conflict_sra = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_SRA) intersect {1};
        bins csr_read_conflict_rol = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_ROL) intersect {1};
        bins csr_read_conflict_bext = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_BEXT) intersect {1};
        bins csr_read_conflict_sh3add = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_SH3ADD) intersect {1};
        bins csr_read_conflict_slt = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_SLT) intersect {1};
        bins csr_read_conflict_clz = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_CLZ) intersect {1};
        bins csr_read_conflict_cpop = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_CPOP) intersect {1};
        bins csr_read_conflict_siext_h = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_SIEXT_H) intersect {1};
        bins csr_read_conflict_min = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_MIN) intersect {1};
        bins csr_read_conflict_packu = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_PACKU) intersect {1};
        bins csr_read_conflict_gorc = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_GORC) intersect {1};
        bins csr_read_conflict_csr_write = binsof(Error) intersect {1} && binsof(CSR_REN_IN) intersect {1} && binsof(AP_CSR_WRITE) intersect {1};
        
    }

    // ===================================================================
    // CSR READ OPERATION COVERAGE  
    // Covers valid CSR read operations where all AP signals are cleared
    // and csr_ren_in is set, result should be csr_rddata_in
    // ===================================================================
    CSR_READ_WITH_CORNERS: cross CSR_REN_IN, CSR_RDDATA_IN, Result, Error, VALID_IN,
                                 AP_ADD, AP_SUB, AP_LAND, AP_LXOR, AP_SLL, AP_SRA, 
                                 AP_ROL, AP_BEXT, AP_SH3ADD, AP_SLT, AP_CLZ, AP_CPOP, 
                                 AP_SIEXT_H, AP_MIN, AP_PACKU, AP_GORC, AP_CSR_WRITE {
        
        ignore_bins ignore_csr_read_inactive = binsof(CSR_REN_IN) intersect {0};
        ignore_bins ignore_invalid_transactions = binsof(VALID_IN) intersect {0};
        ignore_bins ignore_any_ap_active = binsof(CSR_REN_IN) intersect {1} && 
                                          (binsof(AP_ADD) intersect {1} || binsof(AP_SUB) intersect {1} ||
                                           binsof(AP_LAND) intersect {1} || binsof(AP_LXOR) intersect {1} ||
                                           binsof(AP_SLL) intersect {1} || binsof(AP_SRA) intersect {1} ||
                                           binsof(AP_ROL) intersect {1} || binsof(AP_BEXT) intersect {1} ||
                                           binsof(AP_SH3ADD) intersect {1} || binsof(AP_SLT) intersect {1} ||
                                           binsof(AP_CLZ) intersect {1} || binsof(AP_CPOP) intersect {1} ||
                                           binsof(AP_SIEXT_H) intersect {1} || binsof(AP_MIN) intersect {1} ||
                                           binsof(AP_PACKU) intersect {1} || binsof(AP_GORC) intersect {1} ||
                                           binsof(AP_CSR_WRITE) intersect {1});
        
        // Valid CSR read operations - all AP signals cleared, csr_ren_in=1
        // Result should match csr_rddata_in
        bins csr_read_zero_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                 binsof(CSR_RDDATA_IN.zero) && binsof(Result.zero) && binsof(Error) intersect {0};
        bins csr_read_ones_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                 binsof(CSR_RDDATA_IN.ones) && binsof(Result.ones) && binsof(Error) intersect {0};
        bins csr_read_max_pos_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                    binsof(CSR_RDDATA_IN.max_pos) && binsof(Result.max_pos) && binsof(Error) intersect {0};
        bins csr_read_max_neg_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                    binsof(CSR_RDDATA_IN.max_neg) && binsof(Result.max_neg) && binsof(Error) intersect {0};
        bins csr_read_alt_pattern1_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                         binsof(CSR_RDDATA_IN.alt_pattern1) && binsof(Result.alt_pattern1) && binsof(Error) intersect {0};
        bins csr_read_alt_pattern2_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                         binsof(CSR_RDDATA_IN.alt_pattern2) && binsof(Result.alt_pattern2) && binsof(Error) intersect {0};
        
        // General valid CSR read (any data pattern mapping correctly)
        bins csr_read_valid_operation = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                       binsof(Error) intersect {0};
        
        // CSR read with different data patterns in CSR_RDDATA_IN
        bins csr_read_pos_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                binsof(CSR_RDDATA_IN.pos) && binsof(Error) intersect {0};
        bins csr_read_neg_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                binsof(CSR_RDDATA_IN.neg) && binsof(Error) intersect {0};
        bins csr_read_other_data = binsof(CSR_REN_IN) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                  binsof(CSR_RDDATA_IN.other_values) && binsof(Error) intersect {0};
    }

    // ===================================================================
    // ERROR CONDITIONS WITH SPECIFIC INSTRUCTIONS
    // Comprehensive error coverage based on error sequence scenarios
    // ===================================================================
    ERROR_PER_INSTRUCTION: cross Error, AP_ADD, AP_SUB, AP_LAND, AP_LXOR, AP_SLL, AP_SRA, 
                                 AP_ROL, AP_BEXT, AP_SH3ADD, AP_SLT, AP_CLZ, AP_CPOP, 
                                 AP_SIEXT_H, AP_MIN, AP_PACKU, AP_GORC, AP_CSR_WRITE, 
                                 AP_ZBB, AP_ZBA, AP_ZBP, AP_ZBS, AP_UNSIGN, VALID_IN, AP_CSR_IMM {
        
        // Multiple Instruction Conflicts - Invalid combinations  
        bins multi_logical_ops = binsof(Error) intersect {1} && binsof(AP_LAND) intersect {1} && binsof(AP_LXOR) intersect {1};
        bins multi_shift_ops = binsof(Error) intersect {1} && binsof(AP_SLL) intersect {1} && binsof(AP_SRA) intersect {1};
        bins multi_arith_ops = binsof(Error) intersect {1} && binsof(AP_ADD) intersect {1} && binsof(AP_SUB) intersect {1};
        bins multi_count_ops = binsof(Error) intersect {1} && binsof(AP_CLZ) intersect {1} && binsof(AP_CPOP) intersect {1};
        bins multi_misc_ops = binsof(Error) intersect {1} && binsof(AP_MIN) intersect {1} && binsof(AP_PACKU) intersect {1};
        
        // Extension Flag Misuse
        bins sh3add_without_zba = binsof(Error) intersect {1} && binsof(AP_SH3ADD) intersect {1} && binsof(AP_ZBA) intersect {0};
        bins zbb_without_logical = binsof(Error) intersect {1} && binsof(AP_ZBB) intersect {1} && 
                                  binsof(AP_LAND) intersect {0} && binsof(AP_LXOR) intersect {0};
        bins zba_without_sh3add = binsof(Error) intersect {1} && binsof(AP_ZBA) intersect {1} && binsof(AP_SH3ADD) intersect {0};
        bins unsign_without_slt = binsof(Error) intersect {1} && binsof(AP_UNSIGN) intersect {1} && binsof(AP_SLT) intersect {0};
        
        // Invalid SLT combinations
        bins slt_with_add_not_sub = binsof(Error) intersect {1} && binsof(AP_SLT) intersect {1} && 
                                   binsof(AP_ADD) intersect {1} && binsof(AP_SUB) intersect {0};
        bins slt_add_sub_conflict = binsof(Error) intersect {1} && binsof(AP_SLT) intersect {1} && 
                                   binsof(AP_ADD) intersect {1} && binsof(AP_SUB) intersect {1};
        
        // GORC specific errors (invalid b_in values)
        bins gorc_invalid_operand = binsof(Error) intersect {1} && binsof(AP_GORC) intersect {1};
        
        // General unsupported operation errors (no valid operation active)
        bins unsupported_operation = binsof(Error) intersect {1} && binsof(VALID_IN) intersect {1} &&
                                    binsof(AP_ADD) intersect {0} && binsof(AP_SUB) intersect {0} &&
                                    binsof(AP_LAND) intersect {0} && binsof(AP_LXOR) intersect {0} &&
                                    binsof(AP_SLL) intersect {0} && binsof(AP_SRA) intersect {0} &&
                                    binsof(AP_ROL) intersect {0} && binsof(AP_BEXT) intersect {0} &&
                                    binsof(AP_SH3ADD) intersect {0} && binsof(AP_SLT) intersect {0} &&
                                    binsof(AP_CLZ) intersect {0} && binsof(AP_CPOP) intersect {0} &&
                                    binsof(AP_SIEXT_H) intersect {0} && binsof(AP_MIN) intersect {0} &&
                                    binsof(AP_PACKU) intersect {0} && binsof(AP_GORC) intersect {0} &&
                                    binsof(AP_CSR_WRITE) intersect {0};
        
        // 4+ signal combinations (too many active)
        bins too_many_signals_4 = binsof(Error) intersect {1} && binsof(AP_LAND) intersect {1} && 
                                 binsof(AP_LXOR) intersect {1} && binsof(AP_ADD) intersect {1} && binsof(AP_SUB) intersect {1};
        bins too_many_signals_5 = binsof(Error) intersect {1} && binsof(AP_SLT) intersect {1} && 
                                 binsof(AP_UNSIGN) intersect {1} && binsof(AP_SUB) intersect {1} && 
                                 binsof(AP_CPOP) intersect {1} && binsof(AP_SLL) intersect {1};
        
        // Error conditions for CSR write (since CSR write is not implemented, should error)
        bins csr_write_imm_error = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {1} && 
                                  binsof(Error) intersect {1} ;
        bins csr_write_reg_error = binsof(AP_CSR_WRITE) intersect {1} && binsof(AP_CSR_IMM) intersect {0} && 
                                  binsof(Error) intersect {1} ;
        
        // Invalid transactions (valid_in=0)
        bins csr_write_invalid = binsof(AP_CSR_WRITE) intersect {1} && binsof(VALID_IN) intersect {0};


        // Ignore bins for valid operations (no error expected)
        ignore_bins valid_operations = binsof(Error) intersect {0};
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
    $sformatf("CSR Write with corners: %.2f%%", bmuCoverage.CSR_WRITE_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("CSR Read with corners: %.2f%%", bmuCoverage.CSR_READ_WITH_CORNERS.get_coverage()), UVM_MEDIUM);
    
    // Error coverage
    `uvm_info(get_type_name,  
    $sformatf("=== ERROR COVERAGE REPORT ==="), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Overall Error Coverage: %.2f%%", bmuCoverage.Error.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("CSR Read Conflicts: %.2f%%", bmuCoverage.CSR_READ_CONFLICTS.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("General Error per Instruction: %.2f%%", bmuCoverage.ERROR_PER_INSTRUCTION.get_coverage()), UVM_MEDIUM);
    
    `uvm_info(get_type_name,  
    $sformatf("=== END BMU COVERAGE REPORT ==="), UVM_LOW);
endfunction
endclass