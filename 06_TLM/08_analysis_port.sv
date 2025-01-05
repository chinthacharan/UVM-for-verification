//Put, Get are one to one communication
//Analysis is many to one
//analysis port doesn't consumer time so dont use task use function
//Only functions are used not the task as we dont wait to check whether communication happened or not
//Single producer multiple consumers

`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
    `uvm_component_utils(producer)

    uvm_analysis_port #(int) port;

    int data = 12;

    function new(input string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port", this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        port.write(data);
        `uvm_info("Prod", $sformatf("Data Broadcasted: %0d", data), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass

class consumer1 extends uvm_component;
    `uvm_component_utils(consumer1)

    uvm_analysis_imp #(int, consumer1) imp;

    function new(input string path = "consumer1", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    virtual function void write(int datar);
        `uvm_info("CON1", $sformatf("Data Recv: %0d", datar), UVM_NONE);
    endfunction
endclass

class consumer2 extends uvm_component;
    `uvm_component_utils(consumer2)

    uvm_analysis_imp #(int, consumer2) imp;

    function new(input string path = "consumer2", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    virtual function void write(int datar);
        `uvm_info("CON2", $sformatf("Data Recv: %0d", datar), UVM_NONE);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    producer p;
    consumer1 c1;
    consumer2 c2;

    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        p = producer::type_id::create("p", this);
        c1 = consumer1::type_id::create("c1", this);
        c2 = consumer2::type_id::create("c2", this);
    endfunction

    virtual function connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.port.connect(c1.imp);
        p.port.connect(c2.imp);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(input string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule