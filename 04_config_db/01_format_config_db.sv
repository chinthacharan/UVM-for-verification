`include "uvm_macros.svh"
import uvm_pkg::*;

class env extends uvm_env;
    `uvm_component_utils(env)

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    // function to recieve the data from other class
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(uvm_config_db#(int):: get(null, "uvm_test_top", "data", data))
            `uvm_info("ENV", $sformatf("value of data: %0d", data), UVM_NONE)
        else begin
            `uvm_error("ENV", "unable to access the value");
        end
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
        e = env::type_id::create("e", null);
        //to update and send the value of data we use set and it requires corresponding get in instantiated class
        uvm_config_db#(int)::set(null, "uvm_test_top", "data" , 12); //context + instance name+ key+value
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule