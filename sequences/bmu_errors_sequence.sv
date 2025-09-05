class bmu_errors_sequence extends uvm_sequence #(bmu_sequence_item);
`uvm_object_utils(bmu_errors_sequence)

function new(string name = "bmu_errors_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    string instruction_names[];
    req = bmu_sequence_item::type_id::create("req");
    
    // Random set of the control signals
    `uvm_info(get_type_name(), "[Randomized Tests] Random set of active signals", UVM_LOW);
    repeat(20) begin
        start_item(req);
        void'(req.randomize() with {
            rst_l == 1;
            scan_mode == 0;
            valid_in == 1;
        });
        finish_item(req);
    end

    // ==================== CSR Read Conflict Error Tests ===================
    `uvm_info(get_type_name(), "[Test 1] CSR Conflicts: CSR Read + Individual Instructions", UVM_LOW);
    
    // CSR Read + each individual instruction
    instruction_names = {"csr_write", "land", "lxor", "sll", "sra", "rol", "bext", 
                         "sh3add", "add", "slt", "sub", "clz", "cpop", "siext_h", 
                         "min", "packu", "gorc"};
    
    foreach(instruction_names[i]) begin
        start_item(req);
        void'(req.randomize() with {
            rst_l == 1;
            scan_mode == 0;
            valid_in == 1;
        });
        req.ap = 0;
        req.csr_ren_in = 1; // CSR read active
        
        // Activate individual instruction
        case(instruction_names[i])
            "csr_write": req.ap.csr_write = 1;
            "land": req.ap.land = 1;
            "lxor": req.ap.lxor = 1; 
            "sll": req.ap.sll = 1;
            "sra": req.ap.sra = 1;
            "rol": req.ap.rol = 1;
            "bext": req.ap.bext = 1;
            "sh3add": req.ap.sh3add = 1;
            "add": req.ap.add = 1;
            "slt": req.ap.slt = 1;
            "sub": req.ap.sub = 1;
            "clz": req.ap.clz = 1;
            "cpop": req.ap.cpop = 1;
            "siext_h": req.ap.siext_h = 1;
            "min": req.ap.min = 1;
            "packu": req.ap.packu = 1;
            "gorc": req.ap.gorc = 1;
        endcase
        finish_item(req);
    end

    // sh3add Error Case
    `uvm_info(get_type_name(), "[Test 2] sh3add without zba", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.sh3add = 1; // sh3add without zba should error
    req.csr_ren_in = 0;
    finish_item(req);


    // ==================== Invalid Two-Signal Combinations ===================
    // Test 3: land + lxor (two logical operations)
    `uvm_info(get_type_name(), "[Test 3: Invalid Pairs 1] land + lxor", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.land = 1;
    req.ap.lxor = 1;
    req.csr_ren_in = 0;
    finish_item(req);
    
    // Test 4: sll + sra (two shift operations)
    `uvm_info(get_type_name(), "[Test 4: Invalid Pairs 2] sll + sra", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.sll = 1;
    req.ap.sra = 1;
    req.csr_ren_in = 0;
    finish_item(req);
    
    // Test 5: add + sub (two arithmetic operations)
    `uvm_info(get_type_name(), "[Test 5: Invalid Pairs 3] add + sub", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.add = 1;
    req.ap.sub = 1;
    req.csr_ren_in = 0;
    finish_item(req);
    
    // Test 6: clz + cpop (two count operations)
    `uvm_info(get_type_name(), "[Test 6: Invalid Pairs 4] clz + cpop", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.clz = 1;
    req.ap.cpop = 1;
    req.csr_ren_in = 0;
    finish_item(req);
    
    // Test 7: min + packu (min without sub)
    `uvm_info(get_type_name(), "[Test 7: Invalid Pairs 5] min + packu", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.min = 1;
    req.ap.packu = 1;
    req.csr_ren_in = 0;
    finish_item(req);

    // ==================== Invalid Three-Signal Combinations ===================
    // Test 8: slt + unsign + add (should be sub not add)
    `uvm_info(get_type_name(), "[Test 8: Invalid triplet 1] slt + unsign + add", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;
    req.ap.add = 1; // should be sub not add
    req.csr_ren_in = 0;
    finish_item(req);

    // Test 9: slt + add + sub (missing unsign)
    `uvm_info(get_type_name(), "[Test 9: Invalid triplet 2] slt + add + sub", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.add = 1;
    req.ap.sub = 1; // missing unsign
    req.csr_ren_in = 0;
    finish_item(req);

    // Test 10: lxor + zbb + add (zbb without land)
    `uvm_info(get_type_name(), "[Test 10: Invalid triplet 3] lxor + zbb + add", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.lxor = 1;
    req.ap.zbb = 1; // zbb without land
    req.ap.add = 1;
    req.csr_ren_in = 0;
    finish_item(req);

    // Test 11: csr_write + csr_imm + land (CSR + other operation)
    `uvm_info(get_type_name(), "[Test 11: Invalid triplet 4] csr_write + csr_imm + land", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.csr_write = 1;
    req.ap.csr_imm = 1;
    req.ap.land = 1;
    req.csr_ren_in = 0;
    finish_item(req);


    // ==================== More Than 3 Active Signals ===================
    // 4 signals active
    `uvm_info(get_type_name(), "[Test 12] 4 Signals Active", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.land = 1;
    req.ap.lxor = 1;
    req.ap.add = 1;
    req.ap.sub = 1;
    req.csr_ren_in = 0;
    finish_item(req);
    
    // 5 signals active
    `uvm_info(get_type_name(), "[Test 13] 5 Signals Active", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;
    req.ap.sub = 1;
    req.ap.cpop = 1;
    req.ap.sll = 1;
    req.csr_ren_in = 0;
    finish_item(req);


    // ==================== Extension Flag Misuse ===================
    // Extension flags without their required instructions
    `uvm_info(get_type_name(), "[Test 14] Testing extension flag zbb without land/lxor", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.zbb = 1; // zbb without land/lxor
    req.csr_ren_in = 0;
    finish_item(req);
    
    `uvm_info(get_type_name(), "[Test 15] Testing extension flag zba without sh3add", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.zba = 1; // zba without sh3add
    req.csr_ren_in = 0;
    finish_item(req);
    
    `uvm_info(get_type_name(), "[Test 16] Testing unsign signal alone", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.unsign = 1; // unsign without slt
    req.csr_ren_in = 0;
    finish_item(req);

    // Valid slt+unsign+sub with additional invalid signal
    `uvm_info(get_type_name(), "[Test 17] Valid slt+unsign+sub with extra invalid signal", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
    });
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;
    req.ap.sub = 1;
    req.ap.land = 1; // Additional invalid signal makes it >3 signals
    req.csr_ren_in = 0;
    finish_item(req);

    // Add idle cycles to ensure all transactions are completed
    repeat(2) begin
        start_item(req);
        req.rst_l = 1;
        req.scan_mode = 0;
        req.valid_in = 0;  // No valid transaction - idle cycle
        req.csr_ren_in = 0;
        req.ap = 0;
        finish_item(req);
    end

    // ==================== Reset Conditions ===================
    `uvm_info(get_type_name(), "[Test 18] Testing during reset", UVM_LOW);
    
    // Transactions during reset condition (should result in data=0, error=0)
    repeat(5) begin
        start_item(req);
        void'(req.randomize() with {
            rst_l == 0; // Reset active
            scan_mode == 0;
            valid_in == 1;
        });
        req.ap = 0;
        req.csr_ren_in = 0;
        // Randomly set one signal to test reset behavior
        case($urandom_range(4))
            0: req.ap.land = 1;
            1: req.ap.lxor = 1;
            2: req.ap.add = 1;
            3: req.ap.cpop = 1;
            4: req.ap.siext_h = 1;
        endcase
        finish_item(req);
    end
    
    // Add idle cycles to ensure all transactions are completed
    repeat(2) begin
        start_item(req);
        req.rst_l = 1;
        req.scan_mode = 0;
        req.valid_in = 0;  // No valid transaction - idle cycle
        req.csr_ren_in = 0;
        req.ap = 0;
        finish_item(req);
    end

endtask: body
endclass: bmu_errors_sequence