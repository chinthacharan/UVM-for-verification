`include "uvm_macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
    `uvm_component_utils(comp)

    function new(string path = "comp", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("comp", "Reset started", UVM_NONE);
        #10;
        `uvm_info("comp", "Reset ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        //drain time
        phase.phase_done.set_drain_time(this,200);//this task wont be completed after 110 but will continue till 310
        phase.raise_objection(this);
        `uvm_info("mon", "main phase started", UVM_NONE);
        #100;
        `uvm_info("mon", "Main phase ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

        //this task will start after 310
    virtual task post_main_phase(uvm_phase phase);
        `uvm_info("mon", "Post main phase started", UVM_NONE);
    endtask

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass

module tb;
    initial begin
        run_test("comp");
    end
endmodule
