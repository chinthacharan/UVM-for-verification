`include "macros.svh"
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

class second extends uvm_object;

    first f;

    function new(string path = "second");
        super.new(path);
        f = new("first");
    endfunction

    `uvm_object_utils_begin(second)
    `uvm_filed_object(f, UVM_DEFAULT);
    `uvm_object_utils_end
endclass

module tb;
    second s1, s2;

    initial begin
        s1 = new("s1");
        //while using clone no need to initialize the constructor
       //s2 = new("s2");

       s1.f.randomize();
       $cast(s2, s1.cone()); //deep copy: updating s2 will not update s1
       s1.print();
       s2.print();

       s2.f.data = 12;
       s1.print();
       s2.print();
    end

endmodule
