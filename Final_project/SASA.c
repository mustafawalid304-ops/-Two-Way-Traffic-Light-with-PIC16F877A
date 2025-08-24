/*
  Project Name: Traffic Light
  Designed By: Mustafa Walid
  B.N: 36
------------------------------------------------------------------------------------------------------------------------------------------
  Description: 2 traffic lights FIRST FOR West street and THE OTHER for South street,
               West (15s Red, 3s Yellow, 20s Green), South ST. (23s Red, 3s Yellow, 12s Green), 
                2 switches
               FIRST for Automatic/Manual mode and SECOND switch between the two streets in the manual mode.
*/
#define R_S portD.B0
#define Y_S portD.B1
#define G_S portD.B2
#define R_W portD.B3
#define Y_W portD.B4
#define G_W portD.B5
#define Switch portB.B1// When pressing on Push_Button Switch==0 -->skip the small loop(while)  so that don't change the value of() && don't break big loop (while)

int i;
char break_big_loop;
char indicator=0;  //when  interrupt occur use it to break Auto loop using it in condition
char South_flag = 0;
char West_flag = 0;
char segment[] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09
                  ,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19
                  ,0x20,0x21,0x22,0x23 };
void south_yellow(){R_S = 0;Y_S = 1;G_S = 0;R_W = 1;Y_W = 0;G_W = 0;}
void south_green(){R_S = 0;Y_S = 0;G_S = 1;R_W = 1;Y_W = 0;G_W = 0;}
void west_yellow(){R_S = 1;Y_S = 0;G_S = 0;R_W = 0;Y_W = 1;G_W = 0;}
void west_green(){R_S = 1;Y_S = 0;G_S = 0;R_W = 0;Y_W = 0;G_W = 1;}
void interrupt(){
    if(INTF_bit){
        INTF_bit = 0;
        INTE_bit = 0;
        while(1){
            if(South_flag){ // (south green && south yellow) is work   // only can interrupt west func
                indicator = 1;
                portB = 0b00111100;     //RB0&1 --> input don't care func. port //  RB2:5 --> output(high)
                i = 16;              // (when intrrupt count from 15 not after breaK
                West_flag = 0;
                south_green();
                while(Switch){
                    if(INTF_bit == 1){
                        INTF_bit = 0;
                        break_big_loop = 1;
                        break;
                    }
                }
                if(break_big_loop){break_big_loop = 0;break;}
                for(i = 3;i >= 0;i--){
                    portB = 0b00000000;
                    portC = segment[i];
                    south_yellow();
                    delay_ms(1000);
                }
                South_flag = !(South_flag);
            }
            else{     // (west green && west yellow) is work            // only can interrupt south func
                indicator = 0;
                portB = 0b00111100;
                i = 24;      // (when intrrupt count from 23 not after break)
                West_flag = 1;
                west_green();
                while(Switch){
                    if(INTF_bit == 1){
                        INTF_bit = 0;
                        break_big_loop = 1;
                        break;
                    }
                }
                if(break_big_loop){break_big_loop = 0;break;}
                for(i = 3;i >= 0;i--){
                    portB = 0b00000000;
                    portC = i;
                    west_yellow();
                    delay_ms(1000);
                }
                South_flag = !(South_flag);
            }
        }
        INTE_bit = 1;
    }
}
void west() {
    South_flag = 0;
    for(i = 23;i >= 0;i--){
        if(!(West_flag) && indicator){  // when break west function(which on) and the interrupt is south on   after it and verses
            break;
        }
        portB = 0b00000000;
        portC = segment[i];
        if(i > 3)west_green();
        else west_yellow();
        delay_ms(1000);
    }
}
void south() {
    South_flag = 1;
    for(i = 15;i >= 0;i--){
        if(West_flag){      // when break south function(which on) and the interrupt is west on   after it and verses
            West_flag = 0;
            break;
        }
        portB = 0b00000000;
        portC = segment[i];
        if(i > 3)south_green();
        else south_yellow();
        delay_ms(1000);
    }
}

void main() {
    trisC = 0b00000000;
    trisD = 0b00000000;
    trisB = 0b00000011;
    INTE_bit = 1;
    GIE_bit = 1;
    INTEDG_bit = 0;
    s:
        west();
        south();
    goto s;
}