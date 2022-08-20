
`include "module_if.sv"
`include "uvm_macros.svh"



module tb();

import uvm_pkg::*;

	logic PCLK;
	logic PRESETn

	// Simple clock/reset
	initial begin
	  PCLK = 0;
	  PRESETn = 0;
	  repeat(10) begin
		#1ns PCLK = ~PCLK;
	  end
	  PRESETn = 1;
	  forever begin
		#1ns PCLK = ~PCLK;
	  end
	end
	//interface inistail
	//1.划分原则，不同功能的划为一片
	aph_intf apb_itf(.*);
	uart_interrupt u_irq_itf(.*);
	uart_intf uart_itf(.*);
	
	
	uart_1655 uart_1655_inst(
	  // APB Signals
	  .PCLK			(PCLK	),
	  .PRESETn		(PRESETn	),
	  .PADDR		(apb_itf.PADDR	),
	  .PWDATA		(apb_itf.PWDATA	),
	  .PRDATA		(apb_itf.PRDATA	),
	  .PWRITE		(apb_itf.PWRITE	),
	  .PENABLE		(apb_itf.PENABLE	),                                       
	  .PSEL			(apb_itf.PSEL	),
	  . PREADY		(apb_itf.PREADY	),
	  . PSLVERR		(apb_itf.PSLVERR	),
		// UART interrupt request line
	  . IRQ			(u_irq_itf.IRQ		),
		// UART signals
		// serial input/output
	  .TXD			(uart_itf.TXD),
	  .RXD			(uart_itf.RXD),
		// modem signals
	  . nRTS		(uart_itf.nRTS	),
	  . nDTR		(uart_itf.nDTR	),
	  . nOUT1		(uart_itf.nOUT1	),
	  . nOUT2		(uart_itf.nOUT2	),
	  .nCTS			(uart_itf.nCTS		),
	  .nDSR			(uart_itf.nDSR		),
	  .nDCD			(uart_itf.nDCD		),
	  .nRI			(uart_itf.nRI		),
		// Baud rate generator output - needed for checking
	  .baud_o		(uart_itf.baud_o)
	  );

	initial begin 
		uvm_config_db #(virtual aph_intf)::set(null,"tb_top","apb_itf",apb_itf);
		uvm_config_db #(virtual uart_interrupt)::set(null,"tb_top","u_irq_itf",u_irq_itf);
		uvm_config_db #(virtual uart_intf)::set(null,"tb_top","apb_itf",uart_itf);
	end

endmodule
