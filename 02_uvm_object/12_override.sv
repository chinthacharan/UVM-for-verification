//The advantage with using the create method instead of override is we will 
// be able to override one class with another class

`include "uvm_macros.svh"
import uvm_pkg::*;

class first extends uvm_object;

    rand bit [3:0] data;

    function new(string path = "first");
        super.new(path);
    endfunction

    `uvm_object_utils_begin(first)
    `uvm_field_int(data, UVM_DEFAULT);
    `uvm_object_utils_end

endclass

class first_mod extends first;
    rand bit ack;
    function new(string path = "first_mod");
        super.new(path);
    endfunction

    `uvm_object_utils_begin(first_mod)
    `uvm_field_int(ack, UVM_DEFAULT);
    `uvm_object_utils_end

endclass

class comp extends uvm_component;
    `uvm_component_utils(comp)

    first f;

    function new(string path = "comp", uvm_component parent = null);
        super.new(path);
        f = first::type_id::create("f");
        f.randomize();
        f.print();
    endfunction


module tb;
    comp c;

    initial begin
        c.set_type_override_by_type(first::get_type, first_mod::get_type);
        c = comp::type_id::create("comp", null);
    end
endmodule
