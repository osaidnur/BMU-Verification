class bmu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(bmu_scoreboard)
 
  // Monitor connects to this: env.monitor.exp -> sb.exp
  uvm_analysis_imp#(bmu_sequence_item, bmu_scoreboard) exp;
 
  // If DUT latency changes, override via config_db or set here.
  int unsigned latency = 1;
 
  // Pipeline of input transactions (one per cycle)
  bmu_sequence_item cmd_pipe[$];
 
  // ---- CONSTRUCTOR ----
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  // ---- BUILD PHASE ----
  function void build_phase(uvm_phase phase);
    int unsigned tmp_latency; // DECLARATIONS FIRST
    super.build_phase(phase);
    exp = new("exp", this);
 
    // Optional: allow overriding latency from test/env
    if (uvm_config_db#(int unsigned)::get(this, "", "latency", tmp_latency))
      latency = tmp_latency;
  endfunction
 
  // ---- analysis imp ----
  function void write(bmu_sequence_item req);
    // DECLARATIONS FIRST
    bmu_sequence_item in_tr;
    bmu_sequence_item prod;
    logic [31:0]     exp_res;
    bit              exp_err;
 
    // Flush on reset
    if (!req.rst_l) begin
      cmd_pipe.delete();
      `uvm_info("SCOREBOARD", "Reset observed -> clearing pipeline", UVM_LOW)
      return;
    end
 
    // Push current-cycle *inputs* into the pipe (gate with valid if you use bubbles)
    in_tr = new();
    in_tr.a_in          = req.a_in;
    in_tr.b_in          = req.b_in;
    in_tr.ap            = req.ap;
    in_tr.valid_in      = req.valid_in;
    in_tr.csr_ren_in    = req.csr_ren_in;
    in_tr.csr_rddata_in = req.csr_rddata_in;
    in_tr.scan_mode     = req.scan_mode;
    in_tr.rst_l         = req.rst_l;
    cmd_pipe.push_back(in_tr);
 
    // When we have enough history, pop the producer of today's result
    if (cmd_pipe.size() > latency) begin // here cmd_pipe stores the history of the inputs and outputs
      prod = cmd_pipe.pop_front(); // here we pop the front of the pipe
      // here we compute the expected result
      compute_expected(prod, exp_res, exp_err);
      doo_print_current_pair(prod, req.result_ff, req.error); // here we print the current pair
 
      // here we check if the expected result is correct
      if ( (req.result_ff !== exp_res) || (req.error !== exp_err) ) begin
        `uvm_error("SCOREBOARD",
          $sformatf("Mismatch: A=%0d B=%0d  exp=%0d/%0b  got=%0d/%0b",
                    prod.a_in, prod.b_in, exp_res, exp_err,
                    req.result_ff, req.error))
      end
    end
  endfunction
 
  // --- Minimal reference model (extend to cover all ops you enable) ---
  function void compute_expected(const ref bmu_sequence_item tr,
                                 output logic [31:0] expected,
                                 output bit exp_err);
    // DECLARATIONS FIRST (none needed beyond formals)
    exp_err = 0;
 
    if (tr.ap.add) begin
      expected = tr.a_in + tr.b_in;
      // Signed add overflow example (optional)
      if ((tr.a_in[31] == tr.b_in[31]) && (expected[31] != tr.a_in[31]))
        exp_err = 1;
    end
    else if (tr.ap.sub) begin
      expected = tr.a_in - tr.b_in;
      if ((tr.a_in[31] != tr.b_in[31]) && (expected[31] != tr.a_in[31]))
        exp_err = 1;
    end
    else if (tr.ap.land) expected = tr.a_in & tr.b_in;
    else if (tr.ap.lxor) expected = tr.a_in ^ tr.b_in;
    // TODO: add sll/sra/rol/bext/sh3add/min/packu/gorc/... as you wire them up
    else begin
      expected = '0;
      exp_err  = 1'b0;
    end
  endfunction
 
  // --- Pretty printer: producing inputs + current-cycle result ---
  function void doo_print_current_pair(bmu_sequence_item prod,
                                       logic [31:0] result_now,
                                       logic err_now);
    // DECLARATIONS FIRST
    string active_signals[$];
    string signal_info;
 
    if (prod.ap.csr_write) active_signals.push_back("csr_write=1");
    if (prod.ap.csr_imm)   active_signals.push_back("csr_imm=1");
    if (prod.ap.zbb)       active_signals.push_back("zbb=1");
    if (prod.ap.zbp)       active_signals.push_back("zbp=1");
    if (prod.ap.zba)       active_signals.push_back("zba=1");
    if (prod.ap.zbs)       active_signals.push_back("zbs=1");
    if (prod.ap.land)      active_signals.push_back("land=1");
    if (prod.ap.lxor)      active_signals.push_back("lxor=1");
    if (prod.ap.sll)       active_signals.push_back("sll=1");
    if (prod.ap.sra)       active_signals.push_back("sra=1");
    if (prod.ap.rol)       active_signals.push_back("rol=1");
    if (prod.ap.bext)      active_signals.push_back("bext=1");
    if (prod.ap.sh3add)    active_signals.push_back("sh3add=1");
    if (prod.ap.add)       active_signals.push_back("add=1");
    if (prod.ap.slt)       active_signals.push_back("slt=1");
    if (prod.ap.sub)       active_signals.push_back("sub=1");
    if (prod.ap.clz)       active_signals.push_back("clz=1");
    if (prod.ap.cpop)      active_signals.push_back("cpop=1");
    if (prod.ap.siext_h)   active_signals.push_back("siext_h=1");
    if (prod.ap.min)       active_signals.push_back("min=1");
    if (prod.ap.packu)     active_signals.push_back("packu=1");
    if (prod.ap.gorc)      active_signals.push_back("gorc=1");
 
    if (active_signals.size() == 0) signal_info = "No active signals";
    else begin
      signal_info = $sformatf("Active signal(s) (%0d): ", active_signals.size());
      foreach (active_signals[i]) signal_info = {signal_info, (i?", ":""), active_signals[i]};
    end
 
    `uvm_info("Scoreboard",
      $sformatf("A=%0d, B=%0d, %s, Result=%0d, Error=%0b",
                prod.a_in, prod.b_in, signal_info, result_now, err_now),
      UVM_LOW)
  endfunction
 
endclass