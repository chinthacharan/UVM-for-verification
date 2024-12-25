`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
    int data = 56;

    initial begin
        `uvm_info("TB_TOP", $sformatf("Value opf data: %0d", data), UVM_NONE); //(ID, message, redundancy level)
    end
endmodule

/*redudancy level
typedef enum 
{
    UVM_NONE = 0,
    UVM_LOW = 100,
    UVM_MEDIUM = 200,
    UVM_HIGH = 300,
    UVM_FULL = 400,
    UVM_DEBUG = 500
} uvm_verbosity;*/