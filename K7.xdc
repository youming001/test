create_clock -name clk100MHZ -period 10.0 [get_ports clk]
set_property PACKAGE_PIN AC18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]

set_property PACKAGE_PIN W14 [get_ports BTN[0]]
set_property IOSTANDARD LVCMOS18 [get_ports BTN[0]]
set_property PACKAGE_PIN V14 [get_ports BTN[1]]
set_property IOSTANDARD LVCMOS18 [get_ports BTN[1]]
set_property PACKAGE_PIN V19 [get_ports BTN[2]]
set_property IOSTANDARD LVCMOS18 [get_ports BTN[2]]
set_property PACKAGE_PIN V18 [get_ports BTN[3]]
set_property IOSTANDARD LVCMOS18 [get_ports BTN[3]]
set_property PACKAGE_PIN W16 [get_ports BTNX4]
set_property IOSTANDARD LVCMOS18 [get_ports BTNX4]

set_property PACKAGE_PIN W23 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN AB26 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN Y25 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN AA23 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN Y23 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN Y22 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN AE21 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN AF24 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]

set_property PACKAGE_PIN AA10 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[0]}]
set_property PACKAGE_PIN AB10 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[1]}]
set_property PACKAGE_PIN AA13 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[2]}]
set_property PACKAGE_PIN AA12 [get_ports {SW[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[3]}]
set_property PACKAGE_PIN Y13 [get_ports {SW[4]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[4]}]
set_property PACKAGE_PIN Y12 [get_ports {SW[5]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[5]}]
set_property PACKAGE_PIN AD11 [get_ports {SW[6]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[6]}]
set_property PACKAGE_PIN AD10 [get_ports {SW[7]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[7]}]
set_property PACKAGE_PIN AE10 [get_ports {SW[8]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[8]}]
set_property PACKAGE_PIN AE12 [get_ports {SW[9]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[9]}]
set_property PACKAGE_PIN AF12 [get_ports {SW[10]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[10]}]
set_property PACKAGE_PIN AE8 [get_ports {SW[11]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[11]}]
set_property PACKAGE_PIN AF8 [get_ports {SW[12]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[12]}]
set_property PACKAGE_PIN AE13 [get_ports {SW[13]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[13]}]
set_property PACKAGE_PIN AF13 [get_ports {SW[14]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[14]}]
set_property PACKAGE_PIN AF10 [get_ports {SW[15]}]
set_property IOSTANDARD LVCMOS15 [get_ports {SW[15]}]

set_property PACKAGE_PIN AB22 [get_ports {SEGMENT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[0]}]
set_property PACKAGE_PIN AD24 [get_ports {SEGMENT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[1]}]
set_property PACKAGE_PIN AD23 [get_ports {SEGMENT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[2]}]
set_property PACKAGE_PIN Y21 [get_ports {SEGMENT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[3]}]
set_property PACKAGE_PIN W20 [get_ports {SEGMENT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[4]}]
set_property PACKAGE_PIN AC24 [get_ports {SEGMENT[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[5]}]
set_property PACKAGE_PIN AC23 [get_ports {SEGMENT[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[6]}]
set_property PACKAGE_PIN AA22 [get_ports {SEGMENT[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT[7]}]

set_property PACKAGE_PIN AD21 [get_ports {AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property PACKAGE_PIN AC21 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property PACKAGE_PIN AB21 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property PACKAGE_PIN AC22 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]

# NET "b[0]"                                 LOC = T20       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "b[1]"                                 LOC = R20       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "b[2]"                                 LOC = T22       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "b[3]"                                 LOC = T23       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "g[0]"                                 LOC = R22       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "g[1]"                                 LOC = R23       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "g[2]"                                 LOC = T24       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "g[3]"                                 LOC = T25       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "r[0]"                                 LOC = N21       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "r[1]"                                 LOC = N22       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "r[2]"                                 LOC = R21       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "r[3]"                                 LOC = P21       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "hs"                                   LOC = M22       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "vs"                                   LOC = M21       | IOSTANDARD = LVCMOS33 | SLEW = FAST ;
# NET "rstn"                                 LOC = W13       | IOSTANDARD = LVCMOS18 ;

set_property PACKAGE_PIN T20 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property SLEW FAST [get_ports {b[0]}]
set_property PACKAGE_PIN R20 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property SLEW FAST [get_ports {b[1]}]
set_property PACKAGE_PIN T22 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property SLEW FAST [get_ports {b[2]}]
set_property PACKAGE_PIN T23 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]
set_property SLEW FAST [get_ports {b[3]}]
set_property PACKAGE_PIN R22 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property SLEW FAST [get_ports {g[0]}]
set_property PACKAGE_PIN R23 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property SLEW FAST [get_ports {g[1]}]
set_property PACKAGE_PIN T24 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property SLEW FAST [get_ports {g[2]}]
set_property PACKAGE_PIN T25 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]
set_property SLEW FAST [get_ports {g[3]}]
set_property PACKAGE_PIN N21 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property SLEW FAST [get_ports {r[0]}]
set_property PACKAGE_PIN N22 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property SLEW FAST [get_ports {r[1]}]
set_property PACKAGE_PIN R21 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property SLEW FAST [get_ports {r[2]}]
set_property PACKAGE_PIN P21 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]
set_property SLEW FAST [get_ports {r[3]}]
set_property PACKAGE_PIN M22 [get_ports hs]
set_property IOSTANDARD LVCMOS33 [get_ports hs]
set_property SLEW FAST [get_ports hs]
set_property PACKAGE_PIN M21 [get_ports vs]
set_property IOSTANDARD LVCMOS33 [get_ports vs]
set_property SLEW FAST [get_ports vs]
set_property PACKAGE_PIN W13 [get_ports rstn]
set_property IOSTANDARD LVCMOS18 [get_ports rstn]