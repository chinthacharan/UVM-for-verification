//2) port to Imp 

`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
    `uvm_component_utils(producer)

    uvm_blocking_put_port #(int) send;

    function new(input string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    //constructor for port
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send", this);
    endfunction

    //task to send the data
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        send.put(data);
        phase.drop_objection(this);
    endtask

endclass

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    uvm_blocking_put_imp #(int, consumer) imp; //since implementation of put method is in consumer we are using it in brackets

    function new(input string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    virtual task put(int datar);
        `uvm_info("con", $sformatf("Data received: %0d", datar), UVM_NONE);
    endtask

endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    producer p;
    consumer c;

    function new(input string path = "env", uvm_component c);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        p = producer::type_id::create("p", this);
        c = consumer::type_id::create("c", this);
    endfunction

    virtual function connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.send.connect(c.imp);
    endfunction
    
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(input string path = "test", uvm_component c);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction
endclass

module test;
    initial begin
        run_test("test");
    end
endmodule

