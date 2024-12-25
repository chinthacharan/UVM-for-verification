`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver)

    //constructor
    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    //method
    task run();
        `uvm_info("DRV1", "Executed Driver1 code", UVM_HIGH);//since default verbosity is UVM_MEDIUM this message wont be printed
        `uvm_info("DRV2", "Executed Driver2 code", UVM_HIGH);
    endtask
endclass

module tb;
    //create the instance of a class
    driver drv;

    initial begin
        //call constructor before accessing or setting the parameters of a class
        drv = new("DRV", null);
        drv.set_report_id_verbosity("DRV1", UVM_HIGH); //now DRV1 driver is executed
        drv.run(); //now run the driver again
    end
endmodule
