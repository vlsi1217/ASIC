/*uart_top.v 
This is used to imply a BLOCK_RAM to buffer the TX and RX*/

module uart_top(
	CLOCK_50,
		KEY,
		START,
		UART_RXD,
		UART_TXD
);

input	CLOCK_50;
input	KEY;
input	START;
input	UART_RXD;
input	UART_TXD;

wire clk;
pll u_pll (
    .CLKIN_IN(CLKIN_50), 
    .CLKDV_OUT(clk), 
    .CLKIN_IBUFG_OUT( ), 
    .CLK0_OUT( )
    );
	
wire rst;
assign	rst = KEY;

rxtx u_rxtx (
            .clk         (         clk             ),
			.rst         (         rst             ),
			.rx          (         RxD             ),
			.tx_vld      (         tx_vld          ),
			.tx_data     (         tx_data         ),
			
			.rx_vld      (         rx_vld          ),
			.rx_data     (         rx_data         ),
			.tx          (         TxD             ),
			.txrdy       (         txrdy           )
			);
			
/*here comes the Block_RAM*/

/*step 1: setup the flag for Block_RAM*/
always @ (posedge clk or posedge rst)
if (rst) 
	rx_addr <= 10'b0;
else if (rx_vld)
	rx_addr <= rx_addr + 1'b1;
else;

/*step 2: define the RAM*/
always @ (posedge clk)
if (rx_vld)
	mem[rx_addr] <= rx_data;
else;

/*setup the process to tx from Block_RAM to computer*/
always @ (posedge clk or posedge rst)
if (rst) begin
	start_dly0 <= 1'b0;
		start_dly1 <= 1'b0;
		start_ok <= 1'b0;
		end
else begin
	start_dly0 <= START;
		start_dly1 <= start_dly0;
		start_ok <= start_dly1;
	end
assign start_rising = (start_dly1 & ~start_ok) & txrrdy & (rx_addr != 10'b0);
	