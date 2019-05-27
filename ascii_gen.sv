module ascii_gen(
	input logic [7:0] keycode,
	input logic shift,
	output logic [7:0] ascii
	);
assign ascii = (keycode == 8'h04)?8'h41: 				//a
					(keycode == 8'h05)?8'h42: 				//b
					(keycode == 8'h06)?8'h43: 				//c
					(keycode == 8'h07)?8'h44:				//d
					(keycode == 8'h08)?8'h45: 				//e
					(keycode == 8'h09)?8'h46: 				//f
					(keycode == 8'h0a)?8'h47: 				//g
					(keycode == 8'h0b)?8'h48: 				//h
					(keycode == 8'h0c)?8'h49: 				//i
					(keycode == 8'h0d)?8'h4a: 				//j
					(keycode == 8'h0e)?8'h4b: 				//k
					(keycode == 8'h0f)?8'h4c: 				//l
					(keycode == 8'h10)?8'h4d: 				//m
					(keycode == 8'h11)?8'h4e: 				//n
					(keycode == 8'h12)?8'h4f: 				//o
					(keycode == 8'h13)?8'h50: 				//p
					(keycode == 8'h14)?8'h51: 				//q
					(keycode == 8'h15)?8'h52: 				//r
					(keycode == 8'h16)?8'h53: 				//s
					(keycode == 8'h17)?8'h54: 				//t
					(keycode == 8'h18)?8'h55: 				//u
					(keycode == 8'h19)?8'h56: 				//v
					(keycode == 8'h1a)?8'h57: 				//w
					(keycode == 8'h1b)?8'h58: 				//x
					(keycode == 8'h1c)?8'h59: 				//y
					(keycode == 8'h1d)?8'h5a: 				//z
					(keycode == 8'h1e && !shift)?8'h31: //1
					(keycode == 8'h1e && shift)?8'h21: 	//!
					(keycode == 8'h1f && !shift)?8'h32: //2
					(keycode == 8'h1f && shift)?8'h40: 	//@
					(keycode == 8'h20 && !shift)?8'h33: //3
					(keycode == 8'h20 && shift)?8'h23: 	//#
					(keycode == 8'h21 && !shift)?8'h34: //4
					(keycode == 8'h21 && shift)?8'h24: 	//$
					(keycode == 8'h22 && !shift)?8'h35: //5
					(keycode == 8'h22 && shift)?8'h25: 	//%
					(keycode == 8'h23 && !shift)?8'h36: //6
					(keycode == 8'h23 && shift)?8'h5e: 	//^
					(keycode == 8'h24 && !shift)?8'h37: //7
					(keycode == 8'h24 && shift)?8'h26:  //&
					(keycode == 8'h25 && !shift)?8'h38: //8
					(keycode == 8'h25 && shift)?8'h2a:	//*
					(keycode == 8'h26 && !shift)?8'h39: //9
					(keycode == 8'h26 && shift)?8'h28:	//(
					(keycode == 8'h27 && !shift)?8'h30: //0
					(keycode == 8'h27 && shift)?8'h29:	//)
					(keycode == 8'h28)?8'h0d: 				//enter
					(keycode == 8'h29)?8'h1b: 				//esc
					(keycode == 8'h2a)?8'h08: 				//backspace
					(keycode == 8'h2b)?8'h09: 				//tab
					(keycode == 8'h2c)?8'h20: 				//spacebar
					(keycode == 8'h2d && !shift)?8'h2d: // -
					(keycode == 8'h2d && shift)?8'h5f: 	// _
					(keycode == 8'h2e && !shift)?8'h3d: // =
					(keycode == 8'h2e && shift)?8'h2b: 	// +
					(keycode == 8'h2f && !shift)?8'h5b: // [ 
					(keycode == 8'h2f && shift)?8'h7b: 	// {
					(keycode == 8'h30 && !shift)?8'h5d: // ] 
					(keycode == 8'h30 && shift)?8'h7d: 	// }
					(keycode == 8'h31 && !shift)?8'h5c: // \ 
					(keycode == 8'h31 && shift)?8'h7c: 	// |
					(keycode == 8'h33 && !shift)?8'h3b: // ; 
					(keycode == 8'h33 && shift)?8'h3a: 	// :
					(keycode == 8'h34 && !shift)?8'h27: // ' 
					(keycode == 8'h34 &&  shift)?8'h22: // "
					(keycode == 8'h35 && !shift)?8'h60: // `
					(keycode == 8'h35 && shift)?8'h7e: 	// ~
					(keycode == 8'h36 && !shift)?8'h2c: //, 
					(keycode == 8'h36 && shift)?8'h3c: 	// <
					(keycode == 8'h37 && !shift)?8'h2e: //. 
					(keycode == 8'h37 && shift)?8'h3e: 	// >
					(keycode == 8'h38 && !shift)?8'h2f: // / 
					(keycode == 8'h38 && shift)?8'h3f: 	// ?
					8'h00; //else	
	
endmodule
