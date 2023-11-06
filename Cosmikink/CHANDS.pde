void lovalMap(OPC opc, int xpos, int ypos) {

  /// FADE CANDY 0 - CENTER OVALS
  int fc = 0;                       // fadecandy number (first one used is 0)
  fc *=512;

  ///////////////////////////////////////// OVALS - all pixels start at bottom and go anticlockwise?? ///////////////////////////////////////////

  float scale = 1.0;                ///////// CAN USE THIS TO CHANGE THE SIZE OF ALL THE OVALS - KEEPING RELATIVE PROPORTIONS THE SAME /////////////////

  ///////////////////// Big OVAL
  int strt = 0;         // starting pixel number for cicle
  int leds = 64;
  xpos = width/5;
  float wide = w/20.5*scale;
  float high = h/5.8*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
   ///////////////////// Inner Circle - 
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  wide = w/40*scale;
  high = h/11.5*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
    ///////////////////// Big OVAL
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  xpos = (width/5) *2;
  wide = w/20.5*scale;
  high = h/5.8*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
   ///////////////////// Inner Circle - 
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  wide = w/40*scale;
  high = h/11.5*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
   ///////////////////// Big OVAL
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  xpos = (width/5) *3;
  wide = w/20.5*scale;
  high = h/5.8*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
   ///////////////////// Inner Circle - 
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  wide = w/40*scale;
  high = h/11.5*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
   ///////////////////// Big OVAL
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  xpos = (width/5) *4;
  wide = w/20.5*scale;
  high = h/5.8*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
   ///////////////////// Inner Circle - 
  strt += leds;         // starting pixel number for cicle
  leds = 64;
  wide = w/40*scale;
  high = h/11.5*scale;
  for (int i=strt; i < strt+leds; i++) opc.led(i, int(sin(radians((i-strt)*360/leds))*wide)+xpos, (int(cos(radians((i-strt)*360/leds))*high)+ypos));
  
}
