//if you want to print the data in single line use convert2string
//there is a difference between this and do_print as do_print requires uvm_printer as a parameter here it is optional
`include "uvm_macros.svh"
import uvm_pkg::*;

class obj extends uvm_object;
    `uvm_object_utils(obj)

    function new(string path = "obj");
        super.new(path);
    endfunction

    bit [3:0] a = 4;
    string b = "UVM";
    real c = 12.34;

    virtual function string convert2string(); //paramter uvm_printer is not mandatory

        string s = super.convert2string();

        s = {s, $sformatf("a: %0d", a)};
        s = {s, $sformatf("b: %0s", b)};
        s = {s, $sformatf("c: %0f", c)};

        return s;
    endfunction
endclass

module tb;
    obj o;

    initial begin
        o = obj::type_id::create("o");
        //$display("%0s", o.convert2string());
        `uvm_info("TB_TOP", $sformatf("%0s", o.convert2string()), UVM_NONE);
    end
endmodule