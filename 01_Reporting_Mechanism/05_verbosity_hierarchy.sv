`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    //register with a factory
    `uvm_component_utils(driver)

    //constructor
    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("DRV", "Executed Driver code", UVM_HIGH);
    endtask

endclass

class monitor extends uvm_monitor;
    //register class with factory
    `uvm_component_utils(monitor)

    //constructor
    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("MON", "Executed Monitor Code", UVM_HIGH);
    endtask
endclass

class env extends uvm_env;
    //register class with factory
    `uvm_component_utils(env)

    //instantiate both driver and monitor inside the env
    driver drv;
    monitor mon;

    //constructor
    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        drv = new("DRV", this);
        mon = new("MON", this);
        drv.run();
        mon.run();
    endtask
endclass


module tb;
    //instantiate the env class
    env e;

    initial begin
        //constructor 
        e = new("ENV", null);
        e.set_report_verbosity_level_hier(UVM_HIGH); //entire hierarchy will have this verbosity level
        e.run();
    end
endmodule