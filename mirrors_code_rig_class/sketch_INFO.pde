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
 'a' toggle colorSteps - changes colour in pairs or not
 
 */
void frameRateInfo(float x, float y) {
  textAlign(LEFT);
  textSize(18);
  fill(360);  
  text(int(frameRate) + " fps", x, y); // framerate display
  //frame.setTitle(int(frameRate) + " fps"); //framerate as title
}

void onScreenInfo() {
  textSize(18);
  toggleInfo(width/2+90, 20);
  fill(300+(60*stutter));
  textAlign(RIGHT);
  textLeading(18);
  text("RIG PANEL", size.rigWidth-5, size.rig.y-(size.rigHeight/2)+20);
  if (size.roofWidth >0)  text("ROOF PANEL", size.roofWidth-5, size.rigHeight-5);

  textAlign(LEFT);
  fill(360);
  float x = 10;
  float y = 20;

  /////// SHOW INFO ABOUT CURRENT ARRAY SELECTION ////
  fill(rigColor.flash, 300);
  textSize(18);
  y = height-size.sliderHeight+20;
  ///////////// rig info
  text("rigViz: " + rigViz, x, y);
  text("bkgrnd: " + rigBgr, x, y+20);
  text("func's: " + rigFunctionIndexA + " / " + rigFunctionIndexB, x+100, y);
  text("alph's: " + rigAlphaIndexA + " / " + rigAlphaIndexB, x+100, y+20);
  if (size.roofWidth > 0) {
    ///////////// roof info
    textAlign(RIGHT);
    x = size.roofWidth - 130;
    text("roofViz: " + roofViz, x, y);
    text("bkgrnd: " + roofBgr, x, y+20);
    text("func's: " + roofFunctionIndexA + " / " + roofFunctionIndexB, x+120, y);
    text("alph's: " + roofAlphaIndexA + " / " + roofAlphaIndexB, x+120, y+20);
  }

  /////////// info about PLAYWITHYOURSELF functions
  y = 20;
  x=width-5;
  textAlign(RIGHT);
  fill(rigColor.c, 300);
  ///// NEXT VIZ IN....
  String sec = nf(int(vizTime - (millis()/1000 - time[0])) % 60, 2, 0);
  int min = int(vizTime - (millis()/1000 - time[0])) /60 % 60;
  text("next viz in: "+min+":"+sec, x, y);
  ///// NEXT COLOR CHANGE IN....
  sec = nf(int(colTime - (millis()/1000 - time[3])) %60, 2, 0);
  min = int(colTime - (millis()/1000 - time[3])) /60 %60;
  text("next color in: "+ min+":"+sec, x, y+20);
  text("c-" + rigColor.colorA + "  " + "flash-" + rigColor.colorB, x, y+40);
  text("counter: " + counter, x, y+60);

  // moving rectangle displays alpha and functions
  //textSize(12);
  //textAlign(CENTER);
  //fill(rigColor.flash);
  //text("FUNCTION", (size.rigWidth-50)/2, height-10);
  ////rect((size.rigWidth-50)*animations.get(animations.alph[rigAlphaIndexA]), height-15, 10, 10); // moving rectangle to show current function
  //fill(rigColor.c, 360);
  //text("ALPHA", (size.rigWidth-50)/2, height);
  //rect((size.rigWidth-50)*bt, height-5, 10, 10); // moving rectangle to show current alpha

  // sequencer
  fill(rigColor.flash);
  int dist = 20;
  y = 80;
  for (int i = 0; i<(size.infoHeight-size.sliderHeight)/dist-(y/dist); i++) if (int(beatCounter%(dist-(y/dist))) == i) rect(size.info.x-(size.infoWidth/2)+10, 10+i*dist+y, 10, 10);
  fill(rigColor.c, 100);
  for (int i = 0; i<(size.infoHeight-size.sliderHeight)/dist-(y/dist); i++) rect(size.info.x-(size.infoWidth/2)+10, 10+i*dist+y, 10, 10);

  // text to show no audio
  if (pause >0) { 
    textAlign(RIGHT);
    textSize(20); 
    fill(300);
    text("NO AUDIO!! "+pause, width-5, height-2);
  }

  if (info) {
    /////// DISPLAY MOUSE COORDINATES
    textAlign(LEFT);
    fill(360);  
    ellipse(mouseX, mouseY+10, 10, 10);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, mouseX, mouseY );

    /////  LABLELS to show what PVectors are what 
    textSize(12);
    textAlign(CENTER);
    for (int i = 0; i < 12; i++) text(i, grid.mirror[i].x, grid.mirror[i].y);   /// Ball Position info
  }
  dividers();
  // code to develop and then draw preview boxes 
  image(infoWindow, size.info.x, size.info.y);
}
void dividers() {
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
  //fill(360, beat*360); 
  //rect(size.rigWidth-32.5, y, 10, 10);                // rect to show B alpha
  //fill(360, bt*360); 
  //rect(size.rigWidth-32.5, y-10, 10, 10);             // rect to show CURRENT alpha
  // ROOF ///

  if (size.roofWidth>0) {
    x = size.roofWidth - 25;
    fill(roofColor.c);          
    rect(x, y-10, 10, 10);              // rect to show CURRENT color C 
    fill(roofColor.col[(roofColor.colorA+1)%roofColor.col.length], 100);
    rect(x+15, y-10, 10, 10);               // rect to show NEXT color C 
    fill(roofColor.flash);          
    rect(x, y, 10, 10);                 // rect to show CURRENT color FLASH 
    fill(roofColor.col[(roofColor.colorB+1)%roofColor.col.length], 100);
    rect(x+15, y, 10, 10);                  // rect to show NEXT color FLASH1
  }

  //fill(360, roof.beat*360); 
  //rect(size.rigWidth+32.5, y, 10, 10);      // rect to show B alpha
  //fill(360, roof.bt*360); 
  //rect(size.rigWidth+32.5, y-10, 10, 10);   // rect to show CURRENT alpha
}

void toggleInfo(float xpos, float ypos) {
  textSize(18);
  textAlign(CENTER);
  float x = 20;
  float y = 0;

  textAlign(RIGHT);
  y = 180;
  x = width-5;
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
