`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence;

    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [4:0] y;

    function new(string path = "transaction");
        super.new(path);
    endfunction

    `uvm_component_utils_begin(transaction)
     `uvm_field_int(a, UVM_DEFAULT)
     `uvm_field_int(b, UVM_DEFAULT)
     `uvm_field_int(y, UVM_DEFAULT)
    `uvm_component_utils_end
endclass

class sequence1 extends uvm_sequence#(transaction);
    `uvm_component_utils(sequence1)

    transaction trans;

    function new(string path = "sequence1");
        super.new(path);
    endfunction

    virtual task body();
        trans = transaction::type_id::create("trans");
        `uvm_info("SEQ1", "Sequence 1 started", UVM_NONE);
        start_item(trans);
        trans.randomize();
        finish_item(trans);
        `uvm_info("SEQ1", "Sequence 1 ended", UVM_NONE);
    endtask
endclass

class sequence2 extends uvm_sequence#(transaction);
    `uvm_object_utils(sequence2)

    transaction trans;

    function new(string path = "sequence2");
        super.new(path);
    endfunction

    virtual task body();
        trans = transaction::type_id::create("trans");
        `uvm_info("SEQ2", "Sequence 2 started", UVM_NONE);
        start_item(trans);
        trans.randomize();
        finish_item(trans);
        `uvm_info("SEQ2", "Sequence 2 ended", UVM_NONE);
    endtask
endclass

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    transaction t;
    virtual adder_if aif;

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = transaction::type_id::create("t");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(t);
            seq_item_port.item_done();
        end
    endtask
endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    driver d;
    uvm_sequencer #(transaction) seq;

    function new(string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = driver::type_id::create("d", this);
        seq = uvm_sequencer#(transaction)::type_id::create("seq", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d.seq_item_port.connect(seq.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    agent a;

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("a", this);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    sequence1 s1;
    sequence2 s2;
    env e;

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s1 = sequence1::type_id::create("s1");
        s2 = sequence2::type_id::create("s2");
        e = env::type_id::create("e", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        fork
            s2.start(e.a.seq);
            s1.start(e.a.seq);
        join
        phase.drop_objection(this);
    endtask
endclass

module ram_tb;
    initial begin
        run_test("test");
    end
endmodule

