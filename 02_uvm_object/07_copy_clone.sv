`include "uvm_macros.svh"
import uvm_pkg::*;

class first extends uvm_object;

    function new(string path = "first");
        super.ew(path);
    endfunction

    `uvm_object_utils_begin(first)
    `uvm_field_int(data, UVM_DEFAULT);
    `uvm_object_utils_end
endclass

module tb;
    first f;
    first s;

    //copy 
    initial begin
        f = new("first");
        s = new("second");
        f.randomize();
        s.copy(f);
        f.print();
        s.print();
    end

    //clone
    initial begin
        f = new("first");
        //while using clone no need to initialize the constructor
        f.randomize();
        //this following line will throw an error since f.clone is uvm_object type and s is first type
        //s = f.clone();
        $cast(s, f.clone());
        f.print();
        s.print();
    end
endmodule