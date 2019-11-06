/* KEY FUNCTIONS
 
 'c' steps through one of the colours
 'v' steps theough the other colour - current and upcoming colours are displayed in small boxes below the main animation
 'b' steps the animations backwards 
 'n' steps the animations forward
 'm' changes the backgrounds
 ',' changes the function
 '.' changes the alpha
 'l' toggle colour change on beat
 ';' toggle swaps color c/flash
 ''' swaps color c/flash - press and hold
 '\' color swap
 '[' viz hold - stops the timer counting down for next viz change
 ']' color hold - stops the timer counting down for next colour change
 'q' toggles mouse coordiantes and moveable dot
 't' toggle TEST - cycles though all colours to test LEDs
 'w' toggle WORK LIGHTS - all WHITE 
 
 */
void onScreenInfo() {
  textSize(18);
  fill(300+(60*stutter));
  textAlign(RIGHT);
  textLeading(18);
  text("RIG PANEL", size.rig.x+(size.rigWidth/2)-5, size.rig.y-(size.rigHeight/2)+20);
  if (size.roofWidth >0|| size.roofHeight>0)  text("ROOF PANEL", size.roof.x+(size.roofWidth/2)-5, size.rig.y-(size.rigHeight/2)+20);
  if (size.cansWidth >0|| size.cansHeight>0) text("CANS PANEL", size.rig.x+(size.rigWidth/2)-5, size.rig.y+(size.rigHeight/2)-5);
  text("# of anims: "+animations.size(), width - 5, height - 30);
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////// SHOW INFO ABOUT CURRENT ARRAY SELECTION ////////////////////////////////////////////////////////////////
  textAlign(LEFT);
  fill(360);
  float x = 10;
  float y = 20;
  fill(rigColor.flash, 300);
  textSize(18);
  y = height-size.sliderHeight+20;
  ///////////// rig info/ ///////////////////////////////////////////////////////////////////
  text("rigViz: " + rigViz, x, y);
  text("bkgrnd: " + rigBgr, x, y+20);
  text("func's: " + rigFunctionIndexA + " / " + rigFunctionIndexB, x+100, y);
  text("alph's: " + rigAlphaIndexA + " / " + rigAlphaIndexB, x+100, y+20);
  ///////////// roof info ////////////////////////////////////////////////////////
  if (size.roofWidth > 0 || size.roofHeight>0) {
    textAlign(RIGHT);
    x = size.roof.x+(size.roofWidth/2) - 130;
    text("roofViz: " + roofViz, x, y);
    text("bkgrnd: " + roofBgr, x, y+20);
    text("func's: " + roofFunctionIndexA + " / " + roofFunctionIndexB, x+120, y);
    text("alph's: " + roofAlphaIndexA + " / " + roofAlphaIndexB, x+120, y+20);
  }
  ///////////// cans info ////////////////////////////////////////////////////////
  if (size.cansHeight > 0 || size.cansWidth > 0) {
    textAlign(RIGHT);
    x = size.cans.x+(size.cansWidth/2) - 130;
    text("cansViz: " + roofViz, x, y);
    text("bkgrnd: " + roofBgr, x, y+20);
    text("func's: " + roofFunctionIndexA + " / " + roofFunctionIndexB, x+120, y);
    text("alph's: " + roofAlphaIndexA + " / " + roofAlphaIndexB, x+120, y+20);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
  y = 20;
  x=width-5;
  textAlign(RIGHT);
  fill(rigColor.c, 300);
  ///// NEXT VIZ IN....
  String sec = nf(int(vizTime - (millis()/1000 - vizTimer)) % 60, 2, 0);
  int min = int(vizTime - (millis()/1000 - vizTimer)) /60 % 60;
  text("next viz in: "+min+":"+sec, x, y);
  ///// NEXT COLOR CHANGE IN....
  sec = nf(int(colTime - (millis()/1000 - rigColor.colorTimer)) %60, 2, 0);
  min = int(colTime - (millis()/1000 - rigColor.colorTimer)) /60 %60;
  text("next color in: "+ min+":"+sec, x, y+20);
  text("c-" + rigColor.colorA + "  " + "flash-" + rigColor.colorB, x, y+40);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  pauseInfo();
  colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////
  sequencer();
  toggleKeysInfo();
  cordinatesInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  dividerLines();
}
void pauseInfo() {
  if (pause > 0) { 
    textAlign(RIGHT);
    textSize(20); 
    fill(300);
    text(pause*10+" sec NO AUDIO!!", width-5, height-2);
  }
}
void cordinatesInfo(boolean _info) {
  if (_info) {
    /////// DISPLAY MOUSE COORDINATES
    textAlign(LEFT);
    fill(360);  
    ellipse(mouseX, mouseY+10, 10, 10);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, mouseX, mouseY );
    /////  LABLELS to show what PVectors are what 
    textSize(12);
    textAlign(CENTER);
    for (int i = 0; i < grid.mirror.length; i++) text(i, grid.mirror[i].x, grid.mirror[i].y);   /// mirrors Position info
    for (int i = 0; i < grid.roof.length; i++) if (size.roof.x>0) text(i, grid.roof[i].x, grid.roof[i].y);
  }
}
void sequencer() {
  fill(rigColor.flash);
  int dist = 20;
  float y = 80;
  for (int i = 0; i<(size.infoHeight-size.sliderHeight)/dist-(y/dist); i++) if (int(beatCounter%(dist-(y/dist))) == i) rect(size.info.x-(size.infoWidth/2)+10, 10+i*dist+y, 10, 10);
  fill(rigColor.c, 100);
  for (int i = 0; i<(size.infoHeight-size.sliderHeight)/dist-(y/dist); i++) rect(size.info.x-(size.infoWidth/2)+10, 10+i*dist+y, 10, 10);
}
void dividerLines() {
  fill(rigColor.flash);
  rect(size.rigWidth, height/2, 1, height);                     ///// vertical line to show end of rig viz area
  rect(size.rig.x, size.rigHeight, size.rigWidth, 1);             //// horizontal line to divide landscape rig / roof areas
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);      ///// vertical line to show end of roof viz area
  fill(rigColor.flash, 80);    
  rect((size.rigWidth+size.roofWidth)/2, height-size.sliderHeight, size.rigWidth+size.roofWidth, 1);                              ///// horizontal line to show bottom area
}
void colorInfo() {
  ///// RECTANGLES TO SHOW BEAT DETECTION AND CURRENT COLOURS /////
  float y = height-7.5;
  float x = 17;
  // RIG ///
  fill(rigColor.c);          
  rect(x, y-10, 10, 10);               // rect to show CURRENT color C 
  fill(rigColor.col[(rigColor.colorA+1)%rigColor.col.length], 100);
  rect(x+15, y-10, 10, 10);              // rect to show NEXT color C 
  fill(rigColor.flash);
  rect(x, y, 10, 10);                  // rect to show CURRENT color FLASH 
  fill(rigColor.col[(rigColor.colorB+1)%rigColor.col.length], 100);  
  rect(x+15, y, 10, 10);                 // rect to show NEXT color FLASH1
  // roof
  if (size.roofWidth>0|| size.roofHeight>0) {
    x = size.roof.x+(size.roofWidth/2)-25;
    fill(roofColor.c);          
    rect(x, y-10, 10, 10);              // rect to show CURRENT color C 
    fill(roofColor.col[(roofColor.colorA+1)%roofColor.col.length], 100);
    rect(x+15, y-10, 10, 10);               // rect to show NEXT color C 
    fill(roofColor.flash);          
    rect(x, y, 10, 10);                 // rect to show CURRENT color FLASH 
    fill(roofColor.col[(roofColor.colorB+1)%roofColor.col.length], 100);
    rect(x+15, y, 10, 10);                  // rect to show NEXT color FLASH1
  }
  // cans
  if (size.cansWidth>0|| size.cansHeight>0) {
    x = size.cans.x+(size.cansWidth/2)-25;
    fill(roofColor.c);          
    rect(x, y-10, 10, 10);              // rect to show CURRENT color C 
    fill(cansColor.col[(cansColor.colorA+1)%cansColor.col.length], 100);
    rect(x+15, y-10, 10, 10);               // rect to show NEXT color C 
    fill(cansColor.flash);          
    rect(x, y, 10, 10);                 // rect to show CURRENT color FLASH 
    fill(cansColor.col[(cansColor.colorB+1)%cansColor.col.length], 100);
    rect(x+15, y, 10, 10);                  // rect to show NEXT color FLASH1
  }
}
void frameRateInfo(float x, float y) {
  textAlign(LEFT);
  textSize(18);
  fill(360);  
  text(int(frameRate) + " fps", x, y); // framerate display
  //frame.setTitle(int(frameRate) + " fps"); //framerate as title
}
void toggleKeysInfo() {
  textSize(18);
  textAlign(RIGHT);
  float y = 180;
  float x = width-5;
  fill(50);
  if (vizHold)  fill(300+(60*stutter));
  text("[ = VIZ HOLD", x, y);
  fill(50);
  if (colHold) fill(300+(60*stutter));
  text("] = COL HOLD", x, y+20);
  y +=20;
  fill(50);
  if (keyT['p']) fill(300+(60*stutter));
  text("P = shimmer", x, y+40);
  fill(50);
  if (!rigColor.colSwap) fill(300+(60*stutter));
  text("O = color swap", x, y+60);
  fill(50);
  if (rigColor.colFlip) fill(300+(60*stutter));
  text("I / U = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("Y = color beat", x, y+100);
  y+=20;
  fill(50);
}
