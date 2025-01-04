

`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;
    `uvm_component_utils(test)

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    /////////////////////////////////construction phases

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("test", "build Phase Executed", UVM_NONE);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("test", "Connect phase executed", UVM_NONE);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("test", "end of elaboration is executed", UVM_NONE);
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("test", "start of simulation is executed", UVM_NONE);
    endfunction


    //////////////////////////////run phases

    virtual task run_phase(uvm_phase phase); //task will not have super 
        `uvm_info("test", "Run phase is executed", UVM_NONE);
    endtask

    /////////////////////////////cleanup phases

    virtual function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("test", "extract phase is executed", UVM_NONE);
    endfunction

    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("test", "check phase is executed", UVM_NONE);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("test", "report phase is executed", UVM_NONE);
    endfunction

    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("test", "final phase is executed", UVM_NONE);
    endfunction

endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule

