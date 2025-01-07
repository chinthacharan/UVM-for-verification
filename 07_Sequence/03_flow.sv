`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [4:0] y;
    
    function new(input string path = "transaction"); //only one parameter since it is a uvm_object
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

    function new(input string path = "sequence1");
        super.new(path);
    endfunction

    virtual task body();
        `uvm_info("seq1", "Transaction object is created", UVM_NONE);
        trans = transaction::type_id::create("trans");
        `uvm_info("seq1", "Waiting for grant from driver", UVM_NONE);
        wait_for_grant();
        `uvm_info("seq1", "Received grant performing randomization", UVM_NONE);
        assert(trans.randomize());
        `uvm_info("seq1", "randomization done -> send req to driver", UVM_NONE);
        send_request(trans);
        `uvm_info("seq1", "Waiting for Item Done from driver", UVM_NONE);
        wait_for_item_done();
        `uvm_info("seq1", "SEQ1 Ended", UVM_NONE);
    endtask
endclass

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    transaction t;
    virtual adder_if aif; //interface

    function new(input string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = transaction::type_id::create("t");
         if(!uvm_config_db#(virtual adder_if)::get(this, "", "aif", aif))  //uvm_top.env.agent.driver.aif
            `uvm_info("DRV", "unable to access Interface", UVM_NONE);

        virtual task run_phase(uvm_phase phase);
            forever begin
                `uvm_info("Drv", "Sending Grant to sequence", UVM_NONE);
                seq_item_port.get_next_item(t);
                `uvm_info("Drv", "Apply stimulus to DUT", UVM_NONE);
                `uvm_info("DRV", "send item done to sequence", UVM_NONE);
                seq_item_port.item_done();
            end
        endtask
    endfunction
endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    driver d;
    uvm_sequencer #(transaction) seq;

    function new(input string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = driver::type_id::create("d", this);
        seq = uvm_sequencer #(transaction)::type_id::create("seq", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.build_phase(phase);
        d.seq_item_port.connect(seq.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    agent a;

    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

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

    sequence1 s1;
    env e;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s1 = sequence1::type_id::create("s1");
        e = env::type_id::create("e", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        s1.start(e.a.seq);
        phase.drop_objection(this);
    endtask
endclass

module ram_tb;
    adder_if aif(); //interface

    initial begin
        uvm_config_db#(virtual adder_if)::set(null,"*", "aif", aif);
        run_test("test");
    end

    //graph
    initial begin
        $dumpfile("dump.vsd");
        $dumpvars;
    end
endmodule





            


