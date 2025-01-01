//do_print is used to print values in table format
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

    virtual function void do_print(uvm_printer printer); //used to print values in table format
        super.do_print(printer);

        printer.print_filed_int("a", a, $bits(a), UVM_HEX);
        printer.print_string("b", b);
        printer.print_real("c", c);
    endfunction

endclass

module tb;
    obj o;

    initial begin
        o = obj::type_id::create("o");
        o.print();
    end
endmodule