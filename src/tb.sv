
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
	aph_intf apb_if(.*);
	uart_interrupt u_irq_if(.*);
	uart_interface uart_if(.*);
	modem_interface modem_if(.*);
	
	
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
	  .PREADY		(apb_itf.PREADY	),
	  .PSLVERR		(apb_itf.PSLVERR	),
		// UART interrupt request line
	  .IRQ			(u_irq_itf.IRQ		),
		// UART signals
		// serial input/output
	  .TXD			(uart_itf.TXD),
	  .RXD			(uart_itf.RXD),
		// modem signals
	  .nRTS			(modem_if.nRTS	),
	  .nDTR			(modem_if.nDTR	),
	  .nOUT1		(modem_if.nOUT1	),
	  .nOUT2		(modem_if.nOUT2	),
	  .nCTS			(modem_if.nCTS		),
	  .nDSR			(modem_if.nDSR		),
	  .nDCD			(modem_if.nDCD		),
	  .nRI			(modem_if.nRI		),
		// Baud rate generator output - needed for checking
	  .baud_o		(uart_itf.baud_o)
	  );

	initial begin 
		uvm_config_db #(virtual aph_intf)::set(null,"tb_top","apb_itf",apb_if);
		uvm_config_db #(virtual uart_interrupt)::set(null,"tb_top","u_irq_itf",u_irq_if);
		uvm_config_db #(virtual uart_intf)::set(null,"tb_top","apb_itf",uart_if);
	end

endmodule
