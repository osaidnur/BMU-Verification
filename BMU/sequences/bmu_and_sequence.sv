class bmu_and_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_and_sequence)

function new(string name = "bmu_and_sequence");
  super.new(name);
endfunction: new




// virtual task body();  // Behavior of the sequence

//     repeat (1) begin  // Continue generating trs

//       transaction tr = transaction::type_id::create(
//           "tr"
//       );  // New tr

      
//       // IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
//       repeat (1) begin
//         tr.randomize(); // this is used to avoid getting an unknown value.
//         tr.rst_l = 1'b1;
//         tr.scan_mode = 1'b0;
//         tr.ap.clz = 1'b0;
//         tr.ap.ctz = 1'b0;
//         tr.ap.cpop = 1'b0;
//         tr.ap.siext_b = 1'b0;
//         tr.ap.siext_h = 1'b0;
//         tr.ap.min = 1'b0;
//         tr.ap.max = 1'b0;
//         tr.ap.pack = 1'b0;
//         tr.ap.packu = 1'b0;
//         tr.ap.packh = 1'b0;
//         tr.ap.rol = 1'b0;
//         tr.ap.ror = 1'b0;
//         tr.ap.grev = 1'b0;
//         tr.ap.gorc = 1'b0;
//         tr.ap.zbb = 1'b0;
//         tr.ap.bset = 1'b0;
//         tr.ap.bclr = 1'b0;
//         tr.ap.binv = 1'b0;
//         tr.ap.bext = 1'b0;
//         tr.ap.sh1add = 1'b0;
//         tr.ap.sh2add = 1'b0;
//         tr.ap.sh3add = 1'b0;
//         tr.ap.zba = 1'b0;
//         tr.ap.land = 1'b1;
//         tr.ap.lor = 1'b0;
//         tr.ap.lxor = 1'b0;
//         tr.ap.sll = 1'b0;
//         tr.ap.srl = 1'b0;
//         tr.ap.sra = 1'b0;
//         tr.ap.beq = 1'b0;
//         tr.ap.bne = 1'b0;
//         tr.ap.blt = 1'b0;
//         tr.ap.bge = 1'b0;
//         tr.ap.add = 1'b0;
//         tr.ap.sub = 1'b0;
//         tr.ap.slt = 1'b0;
//         tr.ap.unsign = 1'b0;
//         tr.ap.jal = 1'b0;
//         tr.ap.predict_t = 1'b0;
//         tr.ap.predict_nt = 1'b0;
//         tr.ap.csr_write = 1'b0;
//         tr.ap.csr_imm = 1'b0;
//         tr.csr_ren_in = 1'b1; 
//         tr.csr_rddata_in = 32'h00AF; 
//         tr.valid_in = 1'b1; 
//         // tr.a_in = 'hFFFF_0101; 
//         // tr.b_in = 'h1234_AA00; 
//         tr.a_in = 'hF0F0_F0F0; 
//         tr.b_in = 'h0F0F_0F0F; 
//         start_item(tr);
//         `uvm_info(get_type_name(), (" IIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIIIIII "),UVM_NONE)
//         `uvm_info(get_type_name(), (" IIIIIIIIIIIIIIIIIII bit_manipluation_and_seq to DUT IIIIIIIIIIIIIIIIIII "),UVM_NONE)
//         `uvm_info(get_type_name(), (" IIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIIIIII "),UVM_NONE)
//         finish_item(tr);

//         start_item(tr);
//           tr.randomize();
//           tr.ap = 'h0;
//           tr.valid_in = 1'b1;
//           tr.csr_ren_in= 1'b0;
//           tr.rst_l = 1'b1;
//         finish_item(tr);

//         start_item(tr);
//         finish_item(tr);
//         start_item(tr);
//         finish_item(tr);
//         start_item(tr);
//         finish_item(tr);
//         start_item(tr);
//         finish_item(tr);
//         start_item(tr);
//         finish_item(tr);

//         repeat(120)
//         begin
//         start_item(tr);
//             tr.randomize();
//             tr.valid_in = 1'b1;
//             tr.csr_ren_in = 1'b0;
//             tr.ap  = 'h0 ; 
//             tr.ap.land = 1'b1;
//             tr.rst_l = 1'b1;
//         finish_item(tr);
//         end

//         repeat(120)
//         begin
//         start_item(tr);
//             tr.randomize();
//             tr.valid_in = 1'b1;
//             tr.csr_ren_in = 1'b0;
//             tr.ap  = 'h0 ; 
//             tr.ap.land = 1'b1;
//             tr.rst_l = 1'b1;
//             tr.ap.zbb = 1'b1;
//         finish_item(tr);
//         end


//       end
//     end

//   endtask



task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    // #10; // Small delay after reset sequence
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal AND operation", UVM_LOW);
    // Normal AND operations
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.land = 1;
      finish_item(req);
    end
    
    // Add idle cycles to ensure all transactions from previous test are completed
    repeat(1) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end
    
    
    // Small delay to ensure all results are captured before moving to next test
    // #10;

    `uvm_info(get_type_name(), "[Randomized Tests 2] Inverted AND operation", UVM_LOW);
    // Inverted AND operations (A & ~B)
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      
      req.ap = 0;
      req.ap.land = 1;
      req.ap.zbb = 1;
      
      finish_item(req);
    end

    // Add idle cycles to ensure all transactions from previous test are completed
    repeat(1) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end
    
    // ==================== Directed Testing ===================

    // Directed Test 1: AND operation with all bits set to 1
    `uvm_info(get_type_name(), "[Directed Test 1]: AND with all bits set to 1", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;
    req.b_in = 32'hFFFFFFFF;
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // #5;
    
    // Directed Test 2: AND operation with all bits set to 0
    `uvm_info(get_type_name(), "[Directed Test 2]: AND with all bits set to 0", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;
    req.b_in = 32'h00000000;
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // #5;
    // Directed Test 3: AND operation when one operand is zeros and the other is ones
    `uvm_info(get_type_name(), "[Directed Test 3]: AND with one operand as 0s and the other as 1s", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;  // All bits set to 1
    req.b_in = 32'h00000000;  // All bits set to
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 4: AND with maximum positive and minimum values
    `uvm_info(get_type_name(), "[Directed Test 4]: AND with max positive and min negative values (0x7FFFFFFF & 0x80000000)", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h7FFFFFFF;
    req.b_in = 32'h80000000;
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    
    // Directed Test 5: AND with alternating bits pattern 1
    `uvm_info(get_type_name(), "[Directed Test 5]: AND with alternating bits (0x55555555 & 0xAAAAAAAA)", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h55555555;  // Alternating 01010101...
    req.b_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 6: AND with alternating bits pattern 2
    `uvm_info(get_type_name(), "[Directed Test 6]: AND with alternating bits (0x55555555 & 0x55555555)", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h55555555;  // Alternating 01010101...
    req.b_in = 32'h55555555;  // Alternating 01010101...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 7: AND with alternating bits pattern 3
    `uvm_info(get_type_name(), "[Directed Test 7]: AND with alternating bits (0xAAAAAAAA & 0xAAAAAAAA)", UVM_LOW);
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.b_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);


    // Add idle cycles to ensure all transactions from previous test are completed
    repeat(1) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end
    

    
  
endtask: body

endclass: bmu_and_sequence