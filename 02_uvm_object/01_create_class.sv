class first;
    rand bit [3:0] data;
endclass

module tb;
    first f;

    initial begin
        f = new();
        f.randomize();
        $display("value of data: %0d", f.data);
    end
endmodule