`include "uvm_macros.svh"
import uvm_pkg::*;

class obj extends uvm_object;
//register class with factory
    `uvm_object_utils(obj)

    //constructor for the class derived from the uvm object
    function new(string path = "obj");
        super.new(path);
    endfunction

    rand bit [3:0] a;
endclass

module tb;
    obj o;
    initial begin
        o = new("obj");
        o.randomize();
        `uvm_info("TB_TOP", $sformatf("value of a : %0d", o.a), UVM_NONE);
    end
endmodule