//changing the default verbosity level from medium to high

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
    initial begin
        $display("default verbosity level : %0d", uvm_top.get_report_verbosity_level);
        #10;
        uvm_top.set_report_verbosity_level(UVM_HIGH);
        $display("updated system verbosity level : %0d", uvm_top.get_report_verbosity_level);
        `uvm_info("TB_TOP", "string", UVM_MEDIUM); //this verbosity level should be less than or equal system verbosity level otherwise the message is not printed 
    end
endmodule