`include "../misc/timescale.v"
`include "../misc/i2c_master_defines.v"
module i2c_master_byte_ctrl (
  input             Clk,        // system clock
  input             Rst_n,      // asynchronous active low reset
  input             Start,
  input             Stop,
  input             Read,
  input             Write,
  input wire        Tx_ack, 
  output reg        Rx_ack,//
  output reg        I2C_done,
  output reg        I2C_al,
  input             SR_sout,
  output reg        SR_load,
  output reg        SR_shift,
  output reg [4-1:0]Bit_cmd,
  output reg        Bit_txd,
  input             Bit_rxd,//LECTURA DE ACKNNOLDWE, O LECTURA DE SHITFT REISTER //hay un estado bit_rxd=!rx_ack
  input             Bit_ack);
  
  reg ctrl , ctrl_rd;

  localparam IDLE    = 5'd0,
             START   = 5'd1,
             STOP    = 5'd2,
             RD_A    = 5'd3,
             RD_B    = 5'd4,
             RD_C    = 5'd5,
             RD_D    = 5'd6,
             RD_E    = 5'd7,
             RD_F    = 5'd8,
             RD_G    = 5'd9,
             RD_H    = 5'd10,
             WR_A    = 5'd11,
             WR_B    = 5'd12,
             WR_C    = 5'd13,
             WR_D    = 5'd14,
             WR_E    = 5'd15,
             WR_F    = 5'd16,
             WR_G    = 5'd17,
             WR_H    = 5'd18,
             ACK     = 5'd19;
  reg [4:0] state, next;

  always @(posedge Clk or negedge Rst_n)
    begin
      if(!Rst_n) state <= IDLE;
      else       state <= next;
    end



  always @(posedge Clk or negedge Rst_n)
    if(!Rst_n) begin 
        Rx_ack <=1'b0;
        I2C_done<=1'b0;
        I2C_al<=1'b0;
        SR_load<=1'b0;
        SR_shift<=1'b0;
        Bit_cmd<=`I2C_CMD_NOP;
        Bit_txd<=1'b0;
        ctrl<=1'b1;
        ctrl_rd<=1'b1;        
    end else begin
      Bit_cmd <= Bit_cmd;
      Bit_txd<=SR_sout;
      SR_load <= 1'b0;
      SR_shift <= 1'b0;
      I2C_done <= 1'b0;
      Rx_ack <= Rx_ack;
      I2C_al<=1'b0;
      case(state)
        IDLE: begin
        if(Start) begin
          Bit_cmd<=`I2C_CMD_START;
        end
        else if(Write) begin
          Bit_cmd<=`I2C_CMD_WRITE;
          SR_load<= 1'b1;
        end
        else if(Read) begin
          Bit_cmd<=`I2C_CMD_READ;
          SR_load<= 1'b1;
        end
        else if(Stop) begin
          Bit_cmd<=`I2C_CMD_STOP;
        end
        else
          Bit_cmd<=`I2C_CMD_NOP;
        end
    
        START: begin
          if (Bit_ack && Read) begin
            Bit_cmd<=`I2C_CMD_READ;
            
          end else if(Bit_ack && Write) begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_load  <= 1'b1;
          end else begin
            Bit_cmd <= Bit_cmd;
          end
        end
        STOP : begin 
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_NOP;
            I2C_done<=1;
          end
            Bit_cmd<=Bit_cmd;
        end
        RD_A :begin 
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;              
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0;
          end
        end
        RD_B :begin 
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;             
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end          
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0; 
          end
        end
        RD_C :begin 
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;
            //ctrl_rd<=1'b1;              
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end          
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0;
          end
        end
        RD_D :begin 
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;              
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end          
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0;
          end
        end
        RD_E :begin 
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;              
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end          
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0;
          end
        end
        RD_F :begin 
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;              
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end          
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0;
          end
        end
        RD_G :begin
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift<=1'b1;              
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            SR_shift<=1'b0; 
          end
          else begin
            Bit_cmd<=Bit_cmd;
            SR_shift<=1'b0;
          end
        end
        RD_H :begin
          if(Bit_ack) begin
            Bit_cmd<=`I2C_CMD_NOP;
            SR_shift<=1'b1;
          end
          else if(Write)begin
            Bit_cmd<=`I2C_CMD_WRITE; 
            SR_shift<=1'b0;
          end
          else begin
              Bit_cmd<=Bit_cmd;
              SR_shift<=1'b0;
          end
        end
        
        
        
        WR_A :begin
        if (ctrl) begin
          SR_load<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_load<=1'b0;
        end
        if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
        end
        else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
        end
        else begin
            Bit_cmd<=Bit_cmd;
        end
        end   

        WR_B :begin
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end
          else begin
            Bit_cmd<=Bit_cmd;
          end
        end
 
        WR_C :begin
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end          
          else begin
            Bit_cmd<=Bit_cmd;
          end
        end

        WR_D :begin
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end          
          else begin
            Bit_cmd<=Bit_cmd;
          end
        end
        WR_E :begin
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end 
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end          
          else begin
            Bit_cmd<=Bit_cmd;
          end
        end
        WR_F :begin
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end              
          else begin
            Bit_cmd<=Bit_cmd;
          end
        end
        WR_G :begin 
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end  
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_WRITE;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end          
          else begin
            Bit_cmd<=Bit_cmd;
          end

        end
        WR_H :begin
        if (ctrl) begin
          SR_shift<=1'b1;
          ctrl<=1'b0;
        end 
        else begin
          SR_shift<=1'b0;
        end
          if(Bit_ack)begin
            Bit_cmd<=`I2C_CMD_NOP;
            ctrl<=1'b1;
          end
          else if(Read)begin
            Bit_cmd<=`I2C_CMD_READ;
            SR_shift <= 1'b1;
          end          
          else begin
            Bit_cmd<=Bit_cmd;
          end
        end

        ACK  : begin
        if (Stop) begin
          if (Read) begin
            Rx_ack  <= 1'b1;
            Bit_cmd <= 4'b0010;
          end
          else if (Write) begin
            Bit_txd <= Tx_ack;
            Bit_cmd <= 4'b0010;
          end
          else                        
            Bit_cmd<= 4'b0010;
          end
        else begin                          
          if (Read) begin
            Rx_ack  <= 1'b1;
            Bit_cmd <= 4'b0000;
            I2C_done<= 1'b1;
          end
          else if (Write) begin
            Bit_txd <= Tx_ack;
            Bit_cmd <= 4'b0000;
            I2C_done<= 1'b1;
          end
          else begin                       
            Bit_cmd <= 4'b0000;
            I2C_done<= 1'b1;
          end
        end 
      end
      default:
        I2C_al<=1;
      endcase
    end

  always @(*)
  begin

      case(state)
      IDLE : begin
        if(Start) begin 
          next=START;
        end
        else if (Write) begin
          next=WR_A;  
        end
        else if(Read) begin
          next=RD_A;
        end
        else if(Stop) begin
          next=STOP;
        end
        else begin
          next=IDLE;
        end
      end
      START: begin 
        if(Read && Bit_ack) begin
          next=RD_A;
        end
        else if(Write && Bit_ack) begin 
          next=WR_A;
        end
        else begin
          next=START;
        end
      end
      WR_A : begin 
        if(Bit_ack) begin
          next= WR_B;
        end
        else begin
          next= WR_A;
        end
      end
      WR_B : begin 
        if(Bit_ack) begin
          next= WR_C;
        end
        else begin
          next= WR_B;
        end
      end
      WR_C : begin 
        if(Bit_ack) begin
          next = WR_D;
        end
        else begin
          next= WR_C;
        end
      end
      WR_D : begin 
        if(Bit_ack) begin
          next= WR_E;
        end
        else begin
          next= WR_D;
        end
      end
      WR_E : begin 
        if(Bit_ack) begin
          next= WR_F;
        end
        else begin
          next= WR_E;
        end
      end
      WR_F : begin 
        if(Bit_ack) begin
          next= WR_G;
        end
        else begin
          next= WR_F;
        end
      end
      WR_G : begin 
        if(Bit_ack) begin
          next= WR_H;
        end
        else begin
          next= WR_G;
        end
      end
      WR_H : begin 
        if(Bit_ack) begin
          next= ACK;
        end
        else begin
          next= WR_H;
        end
      end
      STOP : begin 
        if(Bit_ack)begin
          next=IDLE;
        end
        else begin
          next=STOP;
        end
      end
      
      ACK: begin 
        if(Stop) begin
          next=STOP;
        end
        else begin
          next=IDLE;
        end
      end

    RD_A : begin 
        if(Bit_ack) begin
          next= RD_B;
        end
        else begin
          next= RD_A;
        end
    end
      RD_B : begin 
        if(Bit_ack) begin
          next= RD_C;
        end
        else begin
          next= RD_B;
        end
      end
      RD_C : begin 
        if(Bit_ack) begin
          next= RD_D;
        end
        else begin
          next= RD_C;
        end
      end
      RD_D : begin 
        if(Bit_ack) begin
          next= RD_E;
        end
        else begin
          next= RD_D;
        end
      end
      RD_E : begin 
        if(Bit_ack) begin
          next= RD_F;
        end
        else begin
          next= RD_E;
        end
      end
      RD_F : begin 
        if(Bit_ack) begin
          next= RD_G;
        end
        else begin
          next= RD_F;
        end
      end
      RD_G : begin 
        if(Bit_ack) begin
          next= RD_H;
        end
        else begin
          next= RD_G;
        end
      end
      RD_H : begin 
        if(Bit_ack) begin
          next= ACK;
        end
        else begin
          next= RD_H;
        end
      end
      default:
        next=IDLE;
    endcase
    end
endmodule
