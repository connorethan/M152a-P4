# This file is a general .xdc for the Basys3 rev B board
# To use it in a project:
# - uncomment the lines corresponding to used pins
# - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Input buttons
set_property PACKAGE_PIN T18 [get_ports btn_up]
set_property IOSTANDARD LVCMOS33 [get_ports btn_up]
set_property PACKAGE_PIN U17 [get_ports btn_down]
set_property IOSTANDARD LVCMOS33 [get_ports btn_down]

#VGA Connector
#set_property PACKAGE_PIN G19 [get_ports {rgb[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[8]}]
#set_property PACKAGE_PIN H19 [get_ports {rgb[9]}]
#set_property IOSTANDARD LaVCMOS33 [get_ports {rgb[9]}]
#set_property PACKAGE_PIN J19 [get_ports {rgb[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[10]}]
#set_property PACKAGE_PIN N19 [get_ports {rgb[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[11]}]
#set_property PACKAGE_PIN N18 [get_ports {rgb[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
#set_property PACKAGE_PIN L18 [get_ports {rgb[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
#set_property PACKAGE_PIN K18 [get_ports {rgb[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
#set_property PACKAGE_PIN J18 [get_ports {rgb[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[3]}]
#set_property PACKAGE_PIN J17 [get_ports {rgb[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[4]}]
#set_property PACKAGE_PIN H17 [get_ports {rgb[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[5]}]
#set_property PACKAGE_PIN G17 [get_ports {rgb[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[6]}]
#set_property PACKAGE_PIN D17 [get_ports {rgb[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {rgb[7]}]
set_property PACKAGE_PIN N19 [get_ports red]
set_property IOSTANDARD LVCMOS33 [get_ports red]
set_property PACKAGE_PIN D17 [get_ports green]
set_property IOSTANDARD LVCMOS33 [get_ports green]
set_property PACKAGE_PIN J18 [get_ports blue]
set_property IOSTANDARD LVCMOS33 [get_ports blue]
set_property PACKAGE_PIN P19 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

set_property PACKAGE_PIN T17 	 [get_ports rst]						
set_property IOSTANDARD LVCMOS33 [get_ports rst]


##Pmod Header JA
# reg
set_property PACKAGE_PIN J1 [get_ports nes_clk]					
	set_property IOSTANDARD LVCMOS33 [get_ports nes_clk]
# blue
set_property PACKAGE_PIN L1 [get_ports latch]					
	set_property IOSTANDARD LVCMOS33 [get_ports latch]
# green
set_property PACKAGE_PIN J2 [get_ports data]					
	set_property IOSTANDARD LVCMOS33 [get_ports data]




#7 segment display
set_property PACKAGE_PIN W7 [get_ports {sseg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[6]}]
set_property PACKAGE_PIN W6 [get_ports {sseg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[5]}]
set_property PACKAGE_PIN U8 [get_ports {sseg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[4]}]
set_property PACKAGE_PIN V8 [get_ports {sseg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[3]}]
set_property PACKAGE_PIN U5 [get_ports {sseg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[2]}]
set_property PACKAGE_PIN V5 [get_ports {sseg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[1]}]
set_property PACKAGE_PIN U7 [get_ports {sseg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[0]}]

set_property PACKAGE_PIN V7 [get_ports sseg[7]]							
	set_property IOSTANDARD LVCMOS33 [get_ports sseg[7]]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
	
## LEDs
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {led[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {led[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {led[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {led[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {led[7]}]
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {led[8]}]
#set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports {led[9]}]
#set_property -dict { PACKAGE_PIN W3    IOSTANDARD LVCMOS33 } [get_ports {led[10]}]
#set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports {led[11]}]
#set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
#set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
#set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
#set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {led[15]}]
