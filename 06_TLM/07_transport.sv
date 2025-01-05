//This is a two way communication
//Producer sends the datas and receives datar 
//consumer sends datar and receives datas

`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
    `uvm_component_utils(producer)

    int datas = 12;
    int datar = 0;
    uvm_blocking_transport_port #(int, int) port; //first parameter is data sent and second is data received

    function new(input string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    //constructor for port
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port", this);
    endfunction
    
    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        port.transport(datas, datar);
        `uvm_info("prod", $sformatf("Data sent : %0d, Data received : %0d", datas, datar), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    int datas = 13;
    int datar = 0;
    uvm_blocking_transport_imp #(int, int, consumer) imp;

    function new(input string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    //constructor for imp
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    virtual task transport(input int datar, output int datas);
        datas = this.datas;
        `uvm_info("comp", $sformatf("Data received: %0d, Data sent: %0d", datar, datas), UVM_NONE);
    endtask
endclass


class env extends uvm_env;
    `uvm_component_utils(env)

    producer p;
    consumer c;

    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    //constructor for p and c
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        p = producer::type_id::create("p", this);
        c = consumer::type_id::create("c", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.port.connect(c.imp);
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

    //print hierarchy
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule
        

