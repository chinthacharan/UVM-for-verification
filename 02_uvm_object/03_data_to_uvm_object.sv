class obj extends uvm_object;

    function new(string path = "obj");
        super.new(path);
    endfunction

    rand bit [3:0] a;
    rand bit [7:0] b;

    `uvm_object_utils_begin(obj)
    `uvm_field_int(a, UVM_DEFAULT | UVM_BIN);//will be printed in binary format
    `uvm_filed_int(b, UVM_NOPRINT | UVM_DEC); //will not be printed
    `uvm_object_utils_end
endclass

module tb;
    obj o;

    initial begin
        o = new("obj");
        o.randomize();
        o.print(uvm_default_tree_printer);//printed in tree format, only works if we assign variable to factory
    end

endmodule

