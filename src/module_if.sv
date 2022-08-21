interface apb_intf(input PCLK,input PRESETn);

  logic[31:0] PADDR;
  logic[31:0] PRDATA;
  logic[31:0] PWDATA;
  logic[15:0] PSEL; // Only connect the ones that are needed
  logic PENABLE;
  logic PWRITE;
  logic PREADY;
  logic PSLVERR;
/**
  property psel_valid;
    @(posedge PCLK)
    !$isunknown(PSEL);
  endproperty: psel_valid

  CHK_PSEL: assert property(psel_valid);

  COVER_PSEL: cover property(psel_valid);***/

endinterface: apb_intf

interface uart_interrupt(input PCLK,input PRESETn);
	logic 	IRQ;
endinterface:uart_interrupt

interface uart_interface(input 	PCLK,input PRESETn);
	logic			TXD     ;
	logic			RXD     ;
			
	logic			nCTS    ;
	logic			nRTS	;
	logic			nDTR	;
	logic	[7:0]	nOUT1	;//当前波特率的输出的16倍，第8位
	logic	[7:0]	nOUT2	;//高八位
	logic			nCTS	;	
	logic		  	nDSR	;	
	logic		  	nDCD	;	
	logic		  	nRI		;
	
	logic			baud_o	;//Baud rate generator output - needed for checking
endinterface: uart_interface