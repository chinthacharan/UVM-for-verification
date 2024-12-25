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
        `uvm_fatal("DRV", "simulation cannot continue for DRV");
        #10;
        `uvm_fatal("DRV1", "simulation cannot continue for DRV1");
    endtask
endclass

module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        //severity override from UVM_FATAL to UVM_ERROR
        d.set_report_severity_override(UVM_FATAL, UVM_ERROR);
        d.set_report_severity_id_override(UVM_FATAL, "DRV1", UVM_ERROR);
        d.run();
    end
endmodule