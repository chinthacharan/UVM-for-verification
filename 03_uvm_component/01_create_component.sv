`include "uvm_macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
    `uvm_component_utils(comp)

    function new(string path = "comp", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    //by specifying the parent as null we are creating this class as a child to root (uvm_top)

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("COMP", "Build phase of comp executed", UVM_NONE);
    endfunction
endclass

module tb;
    comp c;

    initial begin
        c = comp::type_id::create("c", null);
        c.build_phase(null);
    end

    //instead of instantiating the class and creating a constructor we can simply it using run_test
    /*
    initial begin
        run_test("comp");
    end
    */
endmodule