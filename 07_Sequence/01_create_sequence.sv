`include "uvm_macros.sch"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;

    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [4:0] y;
    

    function new(input string path = "transaction");
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

    function new(input string path = "sequence1");
        super.new(path);
    endfunction

    virtual task pre_body();
        `uvm_info("SEQ1", "PRE_BODY executed", UVM_NONE);
    endtask

    virtual task body();
        `uvm_info("SEQ1", "Body executed", UVM_NONE);
    endtask

    virtual task post_body();
        `uvm_info("SEQ1", "Post Body executed", UVM_NONE);
    endtask

endclass

//we dont need to create a class for sequencer by extending the sequencer we can directly instantiate inside the agent

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    transaction t;

    function new(input string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = transaction::type_id::create("t"); //since transaction is uvm_object only one parameter
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(t);
            //apply seq to DUT
            seq_item_port.item_done();
        end
    endtask

endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    driver d;
    uvm_sequencer #(transaction) seqr;

    function new(input string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = driver::type_id::create("d", this);
        seqr = uvm_sequencer #(transaction)::type_id::create("seqr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    agent a;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("a", this);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    function new(input string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    sequence1 sq1;
    env e;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        sq1 = sequence1::type_id::create("sq1", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        sq1.start(e.a.seqr);
        phase.drop_objection(this);
    endtask

endclass

module ram_tb;
    initial begin
        run_test("test");
    end
endmodule

