module router_fifo(clock , resetn , soft_reset , write_enb , read_enb  , lfd_state , data_in , full , empty , data_out);


input clock ,resetn , soft_reset ;
input write_enb , read_enb , lfd_state ;
input [7:0] data_in ;


output reg [7:0] data_out ;
output full , empty ;

reg [4:0] rd_pointer , wr_pointer ;
reg [6:0] count ;
reg [8:0] mem [15:0] ;

integer  i ;
reg lfd_state_t ;

always @(posedge clock) begin 

    if(!resetn) lfd_state_t <= 0 ;
    else lfd_state_t <= lfd_state ;
end

// -----------Read operation----------

always @(posedge clock) begin
    if(!resetn) data_out <= 8'b0 ;
    else if (soft_reset) data_out <= 8'bz ;
    else if ((read_enb) && (!empty)) begin
            data_out <= mem[rd_pointer[3:0][7:0]];  
    end
    else if (count == 0) data_out <= 8'bz ;
end

// ----------------- Write Operation-----------

always @(posedge clock) begin
    if( !resetn || soft_reset) begin
        for( i =0 ; i < 16 ; i = i+1) begin
                mem[i] <= 0 ;
        end
    end
    else if (write_enb && (~full)) begin
        if(lfd_state_t) begin
            mem[wr_pointer[3:0]][8] <= 1'b1 ;
            mem[wr_pointer[3:0][7:0]] <= data_in ;
        end
        else  begin
            mem[wr_pointer[3:0]][8] <= 1'b0 ;
            mem[wr_pointer[3:0]][7:0] <= data_in ;
        end

    end
end

//-----------------pointer generation Block-----------

always @(posedge clock ) begin

    if(!resetn) begin
        wr_pointer <= 0;
    end
    else if (write_enb && (~full)) begin
        wr_pointer <= wr_pointer + 1'b1 ;
    end
end


always @(posedge clock) begin

    if(!resetn) rd_pointer <= 0 ;
    else if (read_enb && (~empty))rd_pointer  <= rd_pointer + 1'b1 ;

end

always @(posedge clock) begin
    if(read_enb && !empty ) begin
        if((mem[rd_pointer[3:0]][8])==1'b1) begin
            count <= mem[rd_pointer[3:0]][7:2]+ 1'b1 ; 
        end
        else if (count != 0) begin
            count <= count - 1'b1 ;
        end
    end
end

// ------------ full & empty condition ----------------




 assign full = (wr_pointer ==({~rd_pointer[4], rd_pointer[3:0] }));

 assign empty = (rd_pointer == wr_pointer) ;


endmodule