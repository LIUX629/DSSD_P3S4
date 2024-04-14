/********1*********2*********3*********4*********5*********6*********7*********8
* File : dbus_master_model.v
*_______________________________________________________________________________
*
* Revision history
*
* Name          Date        Observations
* ------------------------------------------------------------------------------
* -            01/04/2023   First version.
* ------------------------------------------------------------------------------
*_______________________________________________________________________________
*
* Description
*  data bus master model. Performs write and read cicles to specific
*  registers
*_______________________________________________________________________________

* (c) Copyright Universitat de Barcelona, 2022
*
*********1*********2*********3*********4*********5*********6*********7*********/

`include "D:/Estudio/semestre 6/DSSD/Pracs/Prac3_S2/misc/timescale.v"
module dbus_master_model #(
  parameter DATA_WIDTH = 8,             // bus data size
  parameter ADDR_WIDTH = 3              // bus addres size
)(
  input  wire                  Clk,     // system clock input
  input  wire                  Rst_n,   // system asynch reset. active low
  output reg  [ADDR_WIDTH-1:0] Addr,    // address bits
  output reg  [DATA_WIDTH-1:0] Dout,    // databus input
  input  wire [DATA_WIDTH-1:0] Din,     // databus output
  output reg                   Wr       // write enable input
);

  initial begin
  Dout={DATA_WIDTH{1'b0}};
  Addr={ADDR_WIDTH{1'b0}};
  Wr=1'b0;
    //TO BE COMPLETED BY THE STUDENT
  end

  task write(input [ADDR_WIDTH-1:0] WrAddr, input [DATA_WIDTH-1:0] WrData);
  begin 

  Dout=WrData;
  Addr=WrAddr;
  //@(posedge Clk);
  Wr=1'b1;
 @(posedge Clk);
    Wr=1'b0;
    Dout={DATA_WIDTH{1'b0}};
    Addr={ADDR_WIDTH{1'b0}};  
  end 
  // TODO: Task automatically generates a write to a register.
  // Inputs register address data to write.
  //TO BE COMPLETED BY THE STUDENT
  endtask

task read(input [ADDR_WIDTH-1:0] RdAddr, output [DATA_WIDTH-1:0] RdData);
 begin
 @(posedge Clk);
     Wr=1'b0;
    Addr=RdAddr;
    //Dout=RdData;
    RdData = Din;

 end
  // TODO: Task automatically generates a read from a register.
  // Input reg address. Output read data.
    //TO BE COMPLETED BY THE STUDENT
endtask

endmodule
