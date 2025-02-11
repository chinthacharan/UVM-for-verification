`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("drv", "Driver Reset started", UVM_NONE);
        #100;
        `uvm_info("drv", "Driver Reset Ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("drv", "Driver main started", UVM_NONE);
        #100;
        `uvm_info("drv", "Driver main ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task post_main_phase(uvm_phase phase);
        `uvm_info("drv", "Driver Post-main phase started", UVM_NONE);
    endtask
endclass

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string path = "monitor", uvm_component parent = null);
        super.new(path, string);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("mon", "Monitor reset started", UVM_NONE);
        #150;
        `uvm_info("mon", "Monitor reset ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("mon", "Monitor main started", UVM_NONE);
        #200;
        `uvm_info("mon", "Monitor main ended", UVM_NONE);
        phase.drop_objection(this);
    endtask

    virtual task post_main_phase(uvm_phase phase);
        `uvm_info("mon", "Monitor Post-main phase started", UVM_NONE);
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
        super.new(path, string);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_phase main_phase;
        super.end_of_elaboration_phase(phase);
         main_phase = phase.find_by_name("main", 0);
         main_phase.phase_done.set_drain_time(this, 100);
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule