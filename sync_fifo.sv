//Synchronous fifo RTL

module sync_fifo #(parameter DEPTH=8, DWIDTH=16)
(
    input                   rstn,
                            clk,
                            wr_en,
                            rd_en,
    input      [DWIDTH-1:0] din,
    output reg [DWIDTH-1:0] dout,
    output                  empty,full
);

    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;

    reg [DWIDTH-1:0] fifo [DEPTH];

    // Write logic
    always @(posedge clk) begin
        if (!rstn) begin
            wptr <= 1'b0;
        end
        else if (wr_en && !full) begin
            fifo[wptr] <= din;
            wptr <= wptr + 1'b1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!rstn) begin
            rptr <= 1'b0;
        end
        else if (rd_en && !empty) begin
            dout <= fifo[rptr];
            rptr <= rptr + 1'b1;
        end
    end

    assign full  = (wptr + 1'b1) == rptr;
    assign empty = (wptr == rptr);

endmodule
