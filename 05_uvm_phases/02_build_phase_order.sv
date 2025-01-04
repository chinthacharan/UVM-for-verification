//top down approach
//first top block test is executed then env then mon and driver is executed
`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("driver", "driver build phase is executed", UVM_NONE);
    endfunction
endclass

class monitor extends uvm_driver;
    `uvm_component_utils(monitor)

    function new(string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("monitor", "Monitor build phase is executed", UVM_NONE);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    driver drv;
    monitor mon;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
        `uvm_info("env", "env build phase is executed", UVM_NONE);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    env e;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        `uvm_info("test", "test build phase is executed", UVM_NONE);
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule


    