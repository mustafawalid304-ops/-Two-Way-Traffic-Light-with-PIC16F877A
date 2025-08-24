
_south_yellow:

;SASA.c,26 :: 		void south_yellow(){R_S = 0;Y_S = 1;G_S = 0;R_W = 1;Y_W = 0;G_W = 0;}
	BCF        PORTD+0, 0
	BSF        PORTD+0, 1
	BCF        PORTD+0, 2
	BSF        PORTD+0, 3
	BCF        PORTD+0, 4
	BCF        PORTD+0, 5
L_end_south_yellow:
	RETURN
; end of _south_yellow

_south_green:

;SASA.c,27 :: 		void south_green(){R_S = 0;Y_S = 0;G_S = 1;R_W = 1;Y_W = 0;G_W = 0;}
	BCF        PORTD+0, 0
	BCF        PORTD+0, 1
	BSF        PORTD+0, 2
	BSF        PORTD+0, 3
	BCF        PORTD+0, 4
	BCF        PORTD+0, 5
L_end_south_green:
	RETURN
; end of _south_green

_west_yellow:

;SASA.c,28 :: 		void west_yellow(){R_S = 1;Y_S = 0;G_S = 0;R_W = 0;Y_W = 1;G_W = 0;}
	BSF        PORTD+0, 0
	BCF        PORTD+0, 1
	BCF        PORTD+0, 2
	BCF        PORTD+0, 3
	BSF        PORTD+0, 4
	BCF        PORTD+0, 5
L_end_west_yellow:
	RETURN
; end of _west_yellow

_west_green:

;SASA.c,29 :: 		void west_green(){R_S = 1;Y_S = 0;G_S = 0;R_W = 0;Y_W = 0;G_W = 1;}
	BSF        PORTD+0, 0
	BCF        PORTD+0, 1
	BCF        PORTD+0, 2
	BCF        PORTD+0, 3
	BCF        PORTD+0, 4
	BSF        PORTD+0, 5
L_end_west_green:
	RETURN
; end of _west_green

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;SASA.c,30 :: 		void interrupt(){
;SASA.c,31 :: 		if(INTF_bit){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;SASA.c,32 :: 		INTF_bit = 0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;SASA.c,33 :: 		INTE_bit = 0;
	BCF        INTE_bit+0, BitPos(INTE_bit+0)
;SASA.c,34 :: 		while(1){
L_interrupt1:
;SASA.c,35 :: 		if(South_flag){ // (south green && south yellow) is work   // only can interrupt west func
	MOVF       _South_flag+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
;SASA.c,36 :: 		indicator = 1;
	MOVLW      1
	MOVWF      _indicator+0
;SASA.c,37 :: 		portB = 0b00111100;     //RB0&1 --> input don't care func. port //  RB2:5 --> output(high)
	MOVLW      60
	MOVWF      PORTB+0
;SASA.c,38 :: 		i = 16;              // (when intrrupt count from 15 not after breaK
	MOVLW      16
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
;SASA.c,39 :: 		West_flag = 0;
	CLRF       _West_flag+0
;SASA.c,40 :: 		south_green();
	CALL       _south_green+0
;SASA.c,41 :: 		while(Switch){
L_interrupt4:
	BTFSS      PORTB+0, 1
	GOTO       L_interrupt5
;SASA.c,42 :: 		if(INTF_bit == 1){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt6
;SASA.c,43 :: 		INTF_bit = 0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;SASA.c,44 :: 		break_big_loop = 1;
	MOVLW      1
	MOVWF      _break_big_loop+0
;SASA.c,45 :: 		break;
	GOTO       L_interrupt5
;SASA.c,46 :: 		}
L_interrupt6:
;SASA.c,47 :: 		}
	GOTO       L_interrupt4
L_interrupt5:
;SASA.c,48 :: 		if(break_big_loop){break_big_loop = 0;break;}
	MOVF       _break_big_loop+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
	CLRF       _break_big_loop+0
	GOTO       L_interrupt2
L_interrupt7:
;SASA.c,49 :: 		for(i = 3;i >= 0;i--){
	MOVLW      3
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_interrupt8:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt44
	MOVLW      0
	SUBWF      _i+0, 0
L__interrupt44:
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt9
;SASA.c,50 :: 		portB = 0b00000000;
	CLRF       PORTB+0
;SASA.c,51 :: 		portC = segment[i];
	MOVF       _i+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;SASA.c,52 :: 		south_yellow();
	CALL       _south_yellow+0
;SASA.c,53 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_interrupt11:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt11
	DECFSZ     R12+0, 1
	GOTO       L_interrupt11
	DECFSZ     R11+0, 1
	GOTO       L_interrupt11
	NOP
	NOP
;SASA.c,49 :: 		for(i = 3;i >= 0;i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;SASA.c,54 :: 		}
	GOTO       L_interrupt8
L_interrupt9:
;SASA.c,55 :: 		South_flag = !(South_flag);
	MOVF       _South_flag+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _South_flag+0
;SASA.c,56 :: 		}
	GOTO       L_interrupt12
L_interrupt3:
;SASA.c,58 :: 		indicator = 0;
	CLRF       _indicator+0
;SASA.c,59 :: 		portB = 0b00111100;
	MOVLW      60
	MOVWF      PORTB+0
;SASA.c,60 :: 		i = 24;      // (when intrrupt count from 23 not after break)
	MOVLW      24
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
;SASA.c,61 :: 		West_flag = 1;
	MOVLW      1
	MOVWF      _West_flag+0
;SASA.c,62 :: 		west_green();
	CALL       _west_green+0
;SASA.c,63 :: 		while(Switch){
L_interrupt13:
	BTFSS      PORTB+0, 1
	GOTO       L_interrupt14
;SASA.c,64 :: 		if(INTF_bit == 1){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt15
;SASA.c,65 :: 		INTF_bit = 0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;SASA.c,66 :: 		break_big_loop = 1;
	MOVLW      1
	MOVWF      _break_big_loop+0
;SASA.c,67 :: 		break;
	GOTO       L_interrupt14
;SASA.c,68 :: 		}
L_interrupt15:
;SASA.c,69 :: 		}
	GOTO       L_interrupt13
L_interrupt14:
;SASA.c,70 :: 		if(break_big_loop){break_big_loop = 0;break;}
	MOVF       _break_big_loop+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt16
	CLRF       _break_big_loop+0
	GOTO       L_interrupt2
L_interrupt16:
;SASA.c,71 :: 		for(i = 3;i >= 0;i--){
	MOVLW      3
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_interrupt17:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt45
	MOVLW      0
	SUBWF      _i+0, 0
L__interrupt45:
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt18
;SASA.c,72 :: 		portB = 0b00000000;
	CLRF       PORTB+0
;SASA.c,73 :: 		portC = i;
	MOVF       _i+0, 0
	MOVWF      PORTC+0
;SASA.c,74 :: 		west_yellow();
	CALL       _west_yellow+0
;SASA.c,75 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_interrupt20:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt20
	DECFSZ     R12+0, 1
	GOTO       L_interrupt20
	DECFSZ     R11+0, 1
	GOTO       L_interrupt20
	NOP
	NOP
;SASA.c,71 :: 		for(i = 3;i >= 0;i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;SASA.c,76 :: 		}
	GOTO       L_interrupt17
L_interrupt18:
;SASA.c,77 :: 		South_flag = !(South_flag);
	MOVF       _South_flag+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _South_flag+0
;SASA.c,78 :: 		}
L_interrupt12:
;SASA.c,79 :: 		}
	GOTO       L_interrupt1
L_interrupt2:
;SASA.c,80 :: 		INTE_bit = 1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;SASA.c,81 :: 		}
L_interrupt0:
;SASA.c,82 :: 		}
L_end_interrupt:
L__interrupt43:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_west:

;SASA.c,83 :: 		void west() {
;SASA.c,84 :: 		South_flag = 0;
	CLRF       _South_flag+0
;SASA.c,85 :: 		for(i = 23;i >= 0;i--){
	MOVLW      23
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_west21:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__west47
	MOVLW      0
	SUBWF      _i+0, 0
L__west47:
	BTFSS      STATUS+0, 0
	GOTO       L_west22
;SASA.c,86 :: 		if(!(West_flag) && indicator){  // when break west function(which on) and the interrupt is south on   after it and verses
	MOVF       _West_flag+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_west26
	MOVF       _indicator+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_west26
L__west37:
;SASA.c,87 :: 		break;
	GOTO       L_west22
;SASA.c,88 :: 		}
L_west26:
;SASA.c,89 :: 		portB = 0b00000000;
	CLRF       PORTB+0
;SASA.c,90 :: 		portC = segment[i];
	MOVF       _i+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;SASA.c,91 :: 		if(i > 3)west_green();
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _i+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__west48
	MOVF       _i+0, 0
	SUBLW      3
L__west48:
	BTFSC      STATUS+0, 0
	GOTO       L_west27
	CALL       _west_green+0
	GOTO       L_west28
L_west27:
;SASA.c,92 :: 		else west_yellow();
	CALL       _west_yellow+0
L_west28:
;SASA.c,93 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_west29:
	DECFSZ     R13+0, 1
	GOTO       L_west29
	DECFSZ     R12+0, 1
	GOTO       L_west29
	DECFSZ     R11+0, 1
	GOTO       L_west29
	NOP
	NOP
;SASA.c,85 :: 		for(i = 23;i >= 0;i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;SASA.c,94 :: 		}
	GOTO       L_west21
L_west22:
;SASA.c,95 :: 		}
L_end_west:
	RETURN
; end of _west

_south:

;SASA.c,96 :: 		void south() {
;SASA.c,97 :: 		South_flag = 1;
	MOVLW      1
	MOVWF      _South_flag+0
;SASA.c,98 :: 		for(i = 15;i >= 0;i--){
	MOVLW      15
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
L_south30:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__south50
	MOVLW      0
	SUBWF      _i+0, 0
L__south50:
	BTFSS      STATUS+0, 0
	GOTO       L_south31
;SASA.c,99 :: 		if(West_flag){      // when break south function(which on) and the interrupt is west on   after it and verses
	MOVF       _West_flag+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_south33
;SASA.c,100 :: 		West_flag = 0;
	CLRF       _West_flag+0
;SASA.c,101 :: 		break;
	GOTO       L_south31
;SASA.c,102 :: 		}
L_south33:
;SASA.c,103 :: 		portB = 0b00000000;
	CLRF       PORTB+0
;SASA.c,104 :: 		portC = segment[i];
	MOVF       _i+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;SASA.c,105 :: 		if(i > 3)south_green();
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _i+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__south51
	MOVF       _i+0, 0
	SUBLW      3
L__south51:
	BTFSC      STATUS+0, 0
	GOTO       L_south34
	CALL       _south_green+0
	GOTO       L_south35
L_south34:
;SASA.c,106 :: 		else south_yellow();
	CALL       _south_yellow+0
L_south35:
;SASA.c,107 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_south36:
	DECFSZ     R13+0, 1
	GOTO       L_south36
	DECFSZ     R12+0, 1
	GOTO       L_south36
	DECFSZ     R11+0, 1
	GOTO       L_south36
	NOP
	NOP
;SASA.c,98 :: 		for(i = 15;i >= 0;i--){
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;SASA.c,108 :: 		}
	GOTO       L_south30
L_south31:
;SASA.c,109 :: 		}
L_end_south:
	RETURN
; end of _south

_main:

;SASA.c,111 :: 		void main() {
;SASA.c,112 :: 		trisC = 0b00000000;
	CLRF       TRISC+0
;SASA.c,113 :: 		trisD = 0b00000000;
	CLRF       TRISD+0
;SASA.c,114 :: 		trisB = 0b00000011;
	MOVLW      3
	MOVWF      TRISB+0
;SASA.c,115 :: 		INTE_bit = 1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;SASA.c,116 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;SASA.c,117 :: 		INTEDG_bit = 0;
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;SASA.c,118 :: 		s:
___main_s:
;SASA.c,119 :: 		west();
	CALL       _west+0
;SASA.c,120 :: 		south();
	CALL       _south+0
;SASA.c,121 :: 		goto s;
	GOTO       ___main_s
;SASA.c,122 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
