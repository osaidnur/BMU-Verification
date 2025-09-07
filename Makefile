#######################################################################################
# Parameters
#######################################################################################

# Directories
COMP_DIR = components
SEQ_DIR = sequences
TEST_DIR = tests
RTL_DIR = rtl

#IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
TEST_NAME = bmu_regression_test
VERBOSITY = UVM_LOW
#IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

# Only the essential files for BMU
# DESIGN_FILE = $(COMP_DIR)/BMU.sv
RTL_DESIGN_FILES = $(RTL_DIR)/rtl_def.sv $(RTL_DIR)/rtl_defines.sv $(RTL_DIR)/rtl_lib.sv $(RTL_DIR)/rtl_pdef.sv $(RTL_DIR)/Bit_Manibulation_Unit.sv
INTERFACE_FILE = $(COMP_DIR)/bmu_interface.sv 
PACKAGE_FILE = $(COMP_DIR)/bmu_pkg.sv
TB_FILE = $(COMP_DIR)/bmu_tb.sv

# File list with RTL design files instead of single BMU.sv
ALL_FILES = $(RTL_DESIGN_FILES) $(INTERFACE_FILE) $(PACKAGE_FILE) $(TB_FILE)

# Xrun flags
XRUN_FLAGS = -uvm -sv -access +rwc -coverage all -covwork coverage_db

# Coverage flags
COV_FLAGS = -coverage all -covwork coverage_db

# Include directories for relative paths in package
INCDIR = +incdir+$(COMP_DIR)+$(SEQ_DIR)+$(TEST_DIR)+$(RTL_DIR)

#######################################################################################
# Endpoints
#######################################################################################

# Clean and run simulation
all: clean run_sim

# Run simulation
run_sim:
	@echo "Running UVM BMU Simulation with test: $(TEST_NAME)"
	xrun $(XRUN_FLAGS) $(INCDIR) $(ALL_FILES) +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=$(VERBOSITY)

# Run the test specified in run_test() method in the testbench
test:
	xrun $(XRUN_FLAGS) $(INCDIR) $(ALL_FILES) +UVM_VERBOSITY=$(VERBOSITY)

# Generate coverage report
cov_report:
	@echo "Generating Coverage Report..."
	imc -exec -noconsole -batch -init coverage_report.tcl

# Open Verisium GUI
wave:
	xrun $(XRUN_FLAGS) $(INCDIR) $(ALL_FILES) +UVM_TESTNAME=$(TEST_NAME) -debug_opt verisium_interactive

imc:
	@echo "Opening IMC Coverage Analyzer..."
	imc -load coverage_db/scope/test/ -gui
	

# Compile only
compile:
	@echo "Compiling UVM ALU Environment ..."
	xrun $(XRUN_FLAGS) $(INCDIR) -compile $(ALL_FILES)

# Check compilation without running
check:
	@echo "Checking compilation ..."
	xrun $(XRUN_FLAGS) $(INCDIR) -elaborate $(ALL_FILES)

# Open SimVision GUI
simvision:
	@echo "Running with GUI..."
	xrun $(XRUN_FLAGS) $(INCDIR) -gui $(ALL_FILES) +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=$(VERBOSITY)

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf xrun.* waves.shm xcelium.d .simvision INCA_libs *.log *.history *.fsdb *.key verisium_debug_logs .verisium_debug_auto_save ida.db .probeFlags.flg coverage_db cov_work verisium_debug_logs_backup .reset_sync_save .reinvoke.sim

.PHONY: run_sim wave test cov_sim cov_report imc compile check simvision clean all