`include "uvm_macros.svh"
import uvm_pkg::*;


class driver extends uvm_driver;
    //class allocated to factory
    `uvm_component_utils(driver)

    //constructor
    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("DRV", "Informational message", UVM_NONE);
        `uvm_warning("DRV", "potential Error");
        `uvm_error("DRV", "Real Error");
        #10;
        `uvm_fatal("DRV", "simulation cannot continue");
    endtask
endclass

module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        d.run();
    end
endmodule