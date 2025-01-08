/*
SEQ_ARB_FIFO (default) first in first out ..priority wont work or priority do not effect 
SEQ_ARB_WEIGHTED : weight is use for priority
SEQ_ARB_RANDOM strictly random -- priority do not effect
SEQ_ARB_STRICT_FIFO supports priority
SEQ_ARB_STRICT_RANDOM supports priority
SEQ_ARB_USER
*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence;
    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [4:0] y;

    function new(string path = "transaction");
        super.new(path);
    endfunction

    `uvm_object_utils_begin(transaction)
     `uvm_field_int(a, UVM_DEFAULT)
     `uvm_field_int(b, UVM_DEFAULT)
     `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end
endclass

class sequence1 extends uvm_sequence#(transaction);
    `uvm_object_utils(sequence1)

    transaction trans;
    function new(string path = "transaction");
        super.new(path);
    endfunction

    virtual task body();
        trans = transaction::type_id::create("trans");
        `uvm_info("SEQ1", "SEQ 1 started", UVM_NONE);
        start_item(trans);
        trans.randomize();
        finish_item(trans);
        `uvm_info("SEQ1", "SEQ1 Ended", UVM_NONE);
    endtask
endclass

class sequence2 extends uvm_sequence#(transaction);
    `uvm_object_utils(sequence2)

    transaction trans;

    function new(string path = "sequence2");
        super.new(sequence2);
    endfunction

    virtual task body();
        trans = transaction::type_id::create("trans");
        `uvm_info("SEQ2", "SEQ 2 started", UVM_NONE);
        start_item(trans);
        trans.randomize();
        finish_item(trans);
        `uvm_info("SEQ2", "SEQ 2 ended", UVM_NONE);
    endtask
endclass

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    transaction trans;
    virtual adder_if aif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = transaction::type_id::create("trans");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
        seq_item_port.get_next_item(trans);
        seq_item_port.item_done();
        end
    endtask
endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    uvm_sequencer #(transaction) seqr;
    driver d;
    //no monitor for now

    function new(string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
        d = driver::type_id::create("d", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    agent a;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("a", this);
    endfunction
endclass

class test extends uvm_test;

    env e;
    sequence1 s1;
    sequence2 s2;

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        s1 = sequence1::type_id::create("s1", this);
        s2 = sequence2::type_id::create("s2", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        e.a.seqr.set_arbitration(UVM_SEQ_ARB_STRICT_RANDOM);
        fork
            repeat(5) s1.start(e.a.seqr, null, 100); //sequencer, parent sequence, priority
            repeat(5) s2.start(e.a.seqr, null, 100);
        join
        phase.drop_objection(this);
    endtask
endclass

module ram_tb;
    initial begin
        run_test("test");
    end
endmodule
        





