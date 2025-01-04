`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("drv", "Driver reset started", UVM_NONE);
        #100;
        `uvm_info("drv", "Driver reset ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("drv", "driver main started", UVM_NONE);
        #100;
        `uvm_info("drv", "driver main ended", UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass

class monitor extends uvm_monitor
    `uvm_component_utils(monitor)

    function new(string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("mon", "Monitor reset started", UVM_NONE);
        #300;
        `uvm_info("mon", "Monitor reset ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("mon", "Monitor main started");
        #400;
        `uvm_info("mon", "Monitor main ended");
        phase.drop_objection(this);
    endtask
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    driver d;
    monitor m;

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = driver::type_id::create("d", this);
        m = monitor::type_id::create("m", this);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction

    endclass

    class tb;
        initial begin
            run_test("test");
        end
    endclass

    