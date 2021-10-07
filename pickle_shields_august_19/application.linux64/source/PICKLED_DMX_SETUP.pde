void pickledDMXcontrol() {
  //// MAIN BOOTH OFF ///
  // blendMode(MULTIPLY);
  fill(0, 360);
  float y = 765;
  rect(roof1X, y, 10, 80);
  rect(roof2X, y, 10, 80);
  rect(roof3X, y, 10, 80);
  rect(roof4X, y, 10, 80);
  y = 695;
  rect(roof1X, y, 10, 10); //// roof lights in front of booth //// 
  rect(roof2X, y, 10, 10);
  rect(roof3X, y, 10, 10); //// roof lights in front of booth //// 
  rect(roof4X, y, 10, 10); //// roof lights next to laptop //// 
  blendMode(NORMAL);
}
////////////////////////////// override ON / OFF for spare DMX pixels, strobe, brightness etc ///////
void DMXOverride() {
  fill(0);
  rect(5, 5, 20, 20);     ///////// rect for DMX control pixels OFF ////
  rect(ww, h-35, w, 80);
  fill(360);
  rect(w-5, 5, 10, 10);  ///////// rect for DMX control pixels ON ////
}

void pickleDMXBattonsGrid() {
  opc.led(6001, 2, 2);
  opc.led(6003, 2, 4);
  opc.led(6005, 2, 6);

  opc.led(6002, rx-50, 100);
  opc.led(6000, rx, ry);
  opc.led(6004, rx+50, 350);
}

float DMXspotsX;
float DMXspotsY; 
void pickleDMXspotsAdjust(float alph) {
  ///// PICKLE DMX DIM /////
  fill(0, 360-(360*alph));
  rect(DMXspotsX, DMXspotsY-200, 140, 180);
  blendMode(NORMAL);
  ///// PICKLE BAR LIGHTS /////
  fill(c1, 200); //// ON color C
  rect(DMXspotsX-60, DMXspotsY+57, 20, 30);
  //// PICKLE BOOTH LIGHTS ////
  fill(0);  ///// OFF
  rect(DMXspotsX, DMXspotsY+160, 140, 20);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// PICKLED DMX SETUP //////////////////////////////////////////////////////////////////

int roof1X, roof2X, roof3X, roof4X, roofY;
void pickleDMXSpotsGrid(int xpos, int ypos) {
  //// OVERALL BRIGHNESS CONTROL, FAR RIGHT, ALWAYS ON ////
  opc.led(2000, w-5, 5);   //// *** change this back!!
  ///// AMBER CONTROL, FAR LEFT, ALWAYS OFF  ////
  opc.led(4000, 10, 3);
  //// STROBE CONTROL, FAR LEFT, ALWAYS OFF ///
  opc.led(5000, 5, 5);

  int n = 2;    //// HORIZTONAL DISTANCE BETWEEN PIXELS /////
  float m = 25;   //// VERTICAL DISTANCE BETWEEN PIXELS /////
  int v = 0;
  int c = 0;


  ///////// global variables for X and Y postion of roof spot lines //////////
  roof1X = xpos-int(rw/2/n*1.5+v);
  roof2X = xpos-int(rw/2/n/2+c);
  roof3X = xpos+int(rw/2/n/2+c);
  roof4X = xpos+int(rw/2/n*1.5+v);
  roofY = ypos;
  ypos = int(m*15/1.8);
  /////// ROOF LEDS START AT 3000 /////
  opc.led(3000, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*1)));
  opc.led(3001, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*1)));
  opc.led(3002, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*1)));
  opc.led(3003, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*1)));

  opc.led(3004, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*2)));
  opc.led(3005, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*2)));

  opc.led(3006, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*3)));
  opc.led(3007, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*3)));
  opc.led(3008, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*3)));
  opc.led(3009, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*3)));

  ////// BAR /////
  opc.led(3010, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*4)));
  opc.led(3011, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*4)));
  opc.led(3012, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*4)));
  opc.led(3013, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*4)));
  ////// BAR /////
  opc.led(3014, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*5)));
  opc.led(3015, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*5)));
  ////// BAR /////
  opc.led(3016, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*6)));
  opc.led(3017, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*6)));
  opc.led(3018, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*6)));
  opc.led(3019, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*6)));

  opc.led(3020, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*7)));
  opc.led(3021, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*7)));
  opc.led(3022, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*7)));
  opc.led(3023, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*7)));

  opc.led(3024, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*8)));
  opc.led(3025, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*8)));

  opc.led(3026, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*9)));
  opc.led(3027, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*9)));
  opc.led(3028, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*9)));
  opc.led(3029, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*9)));

  opc.led(3030, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*10)));
  opc.led(3031, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*10)));
  opc.led(3032, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*10)));
  opc.led(3033, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*10)));

  opc.led(3034, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*11)));
  opc.led(3035, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*11)));

  opc.led(3036, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*12)));
  opc.led(3037, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*12)));
  opc.led(3038, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*12)));
  opc.led(3039, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*12)));

  opc.led(3040, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*13)));
  opc.led(3041, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*13)));
  opc.led(3042, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*13)));
  opc.led(3043, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*13)));

  opc.led(3044, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*14)));
  opc.led(3045, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*14)));

  opc.led(3046, xpos-int(rw/2/n*1.5+v), int((ry-ypos)+(m*15)));
  opc.led(3047, xpos-(rw/2/n/2+c), int((ry-ypos)+(m*15)));
  opc.led(3048, xpos+(rw/2/n/2+c), int((ry-ypos)+(m*15)));
  opc.led(3049, xpos+int(rw/2/n*1.5+v), int((ry-ypos)+(m*15)));
}
