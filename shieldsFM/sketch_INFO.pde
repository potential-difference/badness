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
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////
  text("avgmillis: " + avgmillis,8,30);
  mouseInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  dividerLines();

  //////////////////////////////// SHOW INFO ABOUT CURRENT RIG ARRAY SELECTION //////////////////////////////////////////////////////////////// 
    float x = size.info.x-size.info.wide/2+10;
    float y = size.info.y-size.info.high/2+20;
    textAlign(LEFT);
    textSize(18);
    ///////////// rig info/ ///////////////////////////////////////////////////////////////////
    fill(300);
    text("rigViz: " + shields.availableAnims[shields.vizIndex], x, y);
    text("bkgrnd: " + shields.availableBkgrnds[shields.bgIndex], x, y+20);
    text("func's: " + shields.availableFunctionEnvelopes[shields.functionIndexA] + " / " + shields.availableFunctionEnvelopes[shields.functionIndexB], x+110, y);
    text("alph's: " + shields.availableAlphaEnvelopes[shields.alphaIndexA] + " / " + shields.availableAlphaEnvelopes[shields.alphaIndexB], x+110, y+20);
    /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
  
    fill(300);
    String sec = nf(int(vizTime*60 - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = int(vizTime*60 - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y+40);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(int(colorChangeTime*60 - (millis()/1000 - shields.colorTimer)) %60, 2, 0);
    min = int(colorChangeTime*60 - (millis()/1000 - shields.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+60);
    int totalAnims=0;      
    for (Rig rig : rigs) totalAnims += rig.animations.size();
    text("# of anims: "+totalAnims, x,y+80);

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
//Envelopes visulization
    y+=200;             // STARTING HEIGHT for sections
    float y1=160;            // LENGTH of sections
    float dist = 15;
    int i=0;
    x+=20;
 try {
      for (Anim anim : shields.animations) {
        if (i<shields.animations.size()-1) {
          fill(c1, 120);
        } else {
          fill(flash1, 300);
        }
        float xAxis = (size.info.wide/4);
        rect(x+20+(anim.alphaA*xAxis-32), y+(dist*i), 10, 10);                      // ALPHA A viz
        rect(x+xAxis+12+(anim.alphaB*xAxis-32), y+(dist*i), 10, 10);         // ALPHA B viz
        rect(x+20+(anim.functionA*xAxis-32), y+(dist*i)+y1, 10, 10);                // FUNCTION A viz
        rect(x+xAxis+12+(anim.functionB*xAxis-32), y+(dist*i)+y1, 10, 10);   // FUNCTION B viz
        i+=1;
      }
    }
    catch (Exception e) {
      println(e);
      println("erorr on alpah / function  envelope visulization");
    }
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
void coordinatesInfo(Rig rig, boolean _info) {
  if (_info) {
    textSize(12);
    textAlign(CENTER);
    fill(360);  

    float centerX = rig.size.x - (rig.wide / 2);
    float centerY = rig.size.y - (rig.high / 2);
    for (int i = 0; i < rig.position.length; i++) {
      PVector position = rig.position[i];
      text(i, centerX + position.x, centerY + position.y); // Position info
    }     
  }
}
void dividerLines() {
  noFill();
  stroke(shields.flash,200);
  strokeWeight(1);
  
  // TO DO is this possible?? 
  //for (Rig rig : rigs) rect(size.rig);
  
  
  rect(size.shields);
  rect(size.tipiCentre);
  rect(size.tipiLeft);
  rect(size.tipiRight);
  rect(size.info);
  rect(size.megaSeedA);
  rect(size.megaSeedB);
  rect(size.uvPars);
  rect(size.bar);
  rect(size.booth);
  
}

void frameRateInfo(float x, float y) {
  fill(0, 150);
  strokeWeight(1);
  stroke(shields.flash, 60);
  rect(x+28, y-5, 75, 30);
  noStroke();
  textAlign(LEFT);
  textSize(18);
  fill(360);  
  text(int(frameRate) + " fps", x, y); // framerate display
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
  if (!shields.colSwap) fill(300+(60*stutter));
  text("O = color swap", x, y+60);
  fill(50);
  if (shields.colFlip) fill(300+(60*stutter));
  text("I / U = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("Y = color beat", x, y+100);
  y+=20;
  fill(50);
}
