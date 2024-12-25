`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
//register class with factory
    `uvm_component_utils(driver)

    //constructor
    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("DRV1", "Executed Driver1 Code", UVM_HIGH);
        `uvm_info("DRV2", "Executed Driver2 Code", UVM_HIGH);
    endtask
endclass

class env extends uvm_env;
    //register class to a factory
    `uvm_component_utils(env)

    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("ENV1", "Executed ENV1 Code", UVM_HIGH);
        `uvm_info("ENV2", "Executed ENV2 Code", UVM_HIGH);
    endtask
endclass


module tb;

    //instance of a class
    driver drv;
    env e;

    initial begin
        //constructor
        drv = new("DRV", null);
        e = new("ENV", null);
        e.set_report_verbosity_level(UVM_HIGH);//verbosity level on individual component
        drv.run();
        e.run();
    end
endmodule
