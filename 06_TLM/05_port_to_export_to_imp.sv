//opposite to previous case
//Producer port to export of consumer
//consumer has subconsumer with imp

`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
    `uvm_component_utils(producer)

    int data = 12;
    `uvm_blocking_put_port #(int) port;

    function new(input string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port", this);
    endfunction

    //send the data using main_phase which is a type of run_phase which uses a task
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        port.put(data);
        `uvm_info("comp", $sformatf("Data sent: %0d", data), UVM_NONE);
        phase.drop_objection(this);
    endtask

endclass

class subconsumer extends uvm_component;
    `uvm_component_utils(subconsumer)

    uvm_blocking_put_imp #(int, subconsumer) imp; //since put task is implemented inside the subconsumer

    function new(input string path = "subconsumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    virtual task put(int datar);
        `uvm_info("subc", $sformatf("Data received: %0d", datar), UVM_NONE);
    endtask
endclass

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    subconsumer s;
    uvm_blocking_put_export #(int) export;

    function new(input string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        export = new("export", this);
        s = subconsumer::type_id::create("s", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        s.imp.connect(export);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    consumer c;
    producer p;

    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        c = consumer::typ_id::create("c", this);
        p = producer::type_id::create("p", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        c.export.connect(p.port);
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
        e = env::typ_id::create("e", this);
    endfunction

    //print hierarchy
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule