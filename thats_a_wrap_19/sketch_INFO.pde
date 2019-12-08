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

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////
  //toggleKeysInfo();
  cordinatesInfo(roof, keyT['q']);
  cordinatesInfo(rigg, keyT['q']);
  cordinatesInfo(cans, keyT['q']);
  cordinatesInfo(donut, keyT['q']);

  mouseInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  dividerLines();
}
void pauseInfo() {
  //pause = 0;
  if (pause > 0) { 
    float x = 400;
    float y = 30;
    textAlign(RIGHT);
    textSize(20); 
    fill(300);
    text(" sec NO AUDIO!!", x, y); //pause*10+
  }
}
void mouseInfo(boolean _info) {
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
  }
}
void cordinatesInfo(Rig rig, boolean _info) {
  if (_info) {
    textSize(12);
    textAlign(CENTER);
    fill(360);  
    for (int i = 0; i < rig.position.length; i++) text(i, rig.size.x-(rig.wide/2)+rig.position[i].x, rig.size.y-(rig.high/2)+rig.position[i].y);   /// mirrors Position info
    fill(200);  
    for (int i = 0; i < rig.positionX.length; i++) {
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][0].x, rig.size.y-(rig.high/2)+rig.positionX[i][0].y);   /// mirrors Position info
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][1].x, rig.size.y-(rig.high/2)+rig.positionX[i][1].y);   /// mirrors Position info
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][2].x, rig.size.y-(rig.high/2)+rig.positionX[i][2].y);   /// mirrors Position info
    }
  }
}

void dividerLines() {
  fill(rigg.flash);
  rect(size.rigWidth, height/2, 1, height);                     ///// vertical line to show end of rig viz area
  rect(size.rig.x, size.rigHeight, size.rigWidth, 1);             //// horizontal line to divide landscape rig / roof areas
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);      ///// vertical line to show end of roof viz area
  rect(size.roof.x, size.roofHeight, size.roofWidth, 1);             //// horizontal line to divide landscape rig / roof areas
  // box around the outside
  fill(rigg.flash, 100);   
  rect(width/2, height-1, width, 1);  
  rect(width/2, 1, width, 1);                              
  rect(0, height/2, 1, height);
  rect(width-1, height/2, 1, height);
}

void frameRateInfo(float x, float y) {
  fill(0, 150);
  strokeWeight(1);
  stroke(rigg.flash, 60);
  rect(x+28, y-5, 75, 30);
  noStroke();

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
  if (!rigg.colSwap) fill(300+(60*stutter));
  text("O = color swap", x, y+60);
  fill(50);
  if (rigg.colFlip) fill(300+(60*stutter));
  text("I / U = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("Y = color beat", x, y+100);
  y+=20;
  fill(50);
}
