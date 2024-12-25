`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
    int data = 56;

    initial begin
        `uvm_info("TB_TOP", $sformatf("Value opf data: %0d", data), UVM_NONE);
    end
endmodule