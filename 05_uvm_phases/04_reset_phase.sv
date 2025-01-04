//reset phase in run phase 

`include "uvm.macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
    `uvm_component_utils(comp)

    function new(string path = "comp", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("comp", "Reset started". UVM_NONE);
        #10;
        `uvm_info("comp", "Reset completed", UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass

module tb;
    initial begin
        run_test("comp");
    end
endmodule