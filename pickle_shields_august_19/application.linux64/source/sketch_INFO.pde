/* KEY FUNCTIONS
 
 'c' toggles on/off the info
 'b' steps the animations backwards 
 'n' steps the animations forward
 'm' changes the backgrounds
 ',' changes the function
 '.' changes the alpha
 '/' changes the colours
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
  toggleInfo(width/2+90, 20);
  fill(300+(60*stutter));
  textAlign(RIGHT);
  text("RIG PANEL", mw-5, my-(mh/2)+20);
  text("ROOF PANEL", mw+rw-5, ry-(rh/2)+20);

  textAlign(LEFT);
  textSize(18);
  fill(360);
  float x = 10;
  float y = 20;

  /////// SHOW INFO ABOUT CURRENT ARRAY SELECTION ////
  fill(flash, 300);
  textSize(18);
  y = h-sh+20;
  ///////////// rig info
  text("viz: " + visualisation, x, y);
  text("bkgrnd: " + rigBgr, x, y+20);
  text("func's: " + fc + " / " + fc1, x+100, y);
  text("alph's: " + af + " / " + af1, x+100, y+20);
  //////////// roof info
  x = x+rx-(rw/2);
  text("viz1: " + visualisation1, x, y);
  text("bkgrnd1: " + roofBgr, x, y+20);

  //if (keyT[115]) {
  /////////// info about PLAYWITHYOURSELF functions
  y = 20;
  x=width-5;
  textAlign(RIGHT);
  fill(c, 300);
  ///// NEXT VIZ IN....
  String sec = nf(int(vizTime - (millis()/1000 - time[0])) % 60, 2, 0);
  int min = int(vizTime - (millis()/1000 - time[0])) /60 % 60;
  text("next viz in: "+min+":"+sec, x, y);
  ///// NEXT COLOR CHANGE IN....
  sec = nf(int(colTime - (millis()/1000 - time[3])) %60, 2, 0);
  min = int(colTime - (millis()/1000 - time[3])) /60 %60;
  text("next color in: "+ min+":"+sec, x, y+20);
  text("c-" + co + "  " + "flash-" + co1, x, y+40);
  text("counter: " + counter, x, y+60);
  //}

  ////////////// booth lights info
  textSize(12);
  textAlign(CENTER);
  text("BOOTH", boothX+10, boothY-10);
  fill(flash);
  text("DIG", boothX+10, boothY+20);

  /////  LABLELS to show what PVectors are what 
  textSize(12);
  textAlign(CENTER);
  //for (int i = 1; i <ball.length; i+=3) text("BALL", ballP[i].x+12, int(ballP[i].y) +15);   /// Ball Position info
  for (int i = 0; i <shld.length; i++) text(i, shldP[i][0].x, shldP[i][0].y+4);                 /// SHIELD POSTION INFO

  // moving rectangle displays alpha and functions
  textSize(12);
  textAlign(CENTER);
  text("FUNCTION", (mw-50)/2, h-10);
  rect((mw-50)*func, height-15, 10, 10); // moving rectangle to show current function
  fill(c, 360);
  text("ALPHA", (mw-50)/2, h);
  rect((mw-50)*bt, height-5, 10, 10); // moving rectangle to show current alpha

  // sequencer
  fill(flash);
  int dist = 20;
  y = 80;
  for (int i = 0; i<(ih-sh)/dist-(y/dist); i++) if (int(beatCounter%(dist-(y/dist))) == i) rect(ix-(iw/2)+10, 10+i*dist+y, 10, 10);
  fill(c, 100);
  for (int i = 0; i<(ih-sh)/dist-(y/dist); i++) rect(ix-(iw/2)+10, 10+i*dist+y, 10, 10);

  // beats[] visulization
  y=10;
  dist = 15;
  for (int i = 0; i<beats.length; i++) {
    if (beatCounter % 4 == i) fill(flash1,360);
    else fill(c1, 100);
    rect((ix-(iw/2)+10)+(beats[i]*100), y+(dist*i), 10, 10);
    
    // rects to show pulzs[]
    //    if (beatCounter % 4 == i) fill(clash1);
    //    else fill(clashed, 100);
    //    rect((ix-(iw/2)+10)+(pulzs[i]*100), y+(dist*i), 10, 10);

    fill(c1, 65);
    rect((ix-(iw/2)+10)+(50), y+(dist*i), 110, 10);
  }

  // text to show no audio
  if (pause >0) { 
    textAlign(RIGHT);
    textSize(20); 
    fill(300);
    text("NO AUDIO!!", w-5, h-2);
  }

  if (info) {
    /////// DISPLAY MOUSE COORDINATES
    textAlign(LEFT);
    fill(c);  
    ellipse(mouseX, mouseY+10, 5, 5);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, mouseX, mouseY );
  }
}

void colorInfo() {
  ///// RECTANGLES TO SHOW BEAT DETECTION AND CURRENT COLOURS /////
  y = height-5;

  //fill(flash);
  //textAlign(RIGHT);
  //text("STEPS "+ colStepper, mw-2, y-20);

  fill(col[co1]);          
  rect(mw-20, y, 10, 10);        // rect to show CURRENT color FLASH 
  fill(col[(co1+1)%col.length]);
  rect(mw-7.5, y, 10, 10);       // rect to show NEXT color FLASH1
  fill(col[co]);
  rect(mw-20, y-10, 10, 10);     // rect to show CURRENT color C 
  fill(col[(co+1)%col.length]);
  rect(mw-7.5, y-10, 10, 10);    // rect to show NEXT color C 
  fill(360, beat*360); 
  rect(mw-32.5, y, 10, 10);      // rect to show B alpha
  fill(360, bt*360); 
  rect(mw-32.5, y-10, 10, 10);   // rect to show CURRENT alpha
}

void toggleInfo(float xpos, float ypos) {
  textSize(18);
  textAlign(CENTER);
  float x = 20;
  float y = 0;

  //if (one)    text("1", xpos+(x*1), ypos+(y*1));
  //if (two)    text("2", xpos+(x*2), ypos+(y*2));
  //if (three)  text("3", xpos+(x*3), ypos+(y*3));
  //if (four)   text("4", xpos+(x*4), ypos+(y*4));
  //if (five)   text("5", xpos+(x*5), ypos+(y*5));
  //if (six)    text("6", xpos+(x*6), ypos+(y*6));
  //if (seven)  text("7", xpos+(x*7), ypos+(y*7));
  //if (eight)  text("8", xpos+(x*8), ypos+(y*8));
  //if (nine)   text("9", xpos+(x*9), ypos+(y*9));
  //if (zero)   text("0", xpos+(x*10), ypos+(y*10));

  //if (shift)   text("SHIFT!!", xpos+(x*6), ypos+(y*1));
  textAlign(RIGHT);
  y = 180;
  x = w-5;
  fill(50);
  if (hold)  fill(300+(60*stutter));
  text("[ = VIZ HOLD", x, y);
  fill(50);
  if (hold1) fill(300+(60*stutter));
  text("] = COL HOLD", x, y+20);
  y +=20;
  fill(50);
  if (keyT[107]) fill(300+(60*stutter));
  text("K = shimmer", x, y+40);
  fill(50);
  if (!colSwap) fill(300+(60*stutter));
  text("| = color swap", x, y+60);
  fill(50);
  if (colorFlipped) fill(300+(60*stutter));
  text("; / ' = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("L = color beat", x, y+100);
  y+=20;
  fill(50);
  if (keyT[120]) fill(300+(60*stutter));
  text("X = B/P/B2/B2", x, y+120);
  fill(50);
  if (keyT[122]) fill(300+(60*stutter));
  text("Z = viz flip", x, y+140);
}
