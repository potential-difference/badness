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
  mouseInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  dividerLines();
  //////////////////////////////// SHOW INFO ABOUT CURRENT RIG ARRAY SELECTION //////////////////////////////////////////////////////////////// 
  float x = size.info.x-size.info.wide/2+10;
  float y = size.info.y-size.info.high/2+20;
  textAlign(LEFT);
  textSize(18);
  fill(300);
  //////////////////////// INFO ABOUT SKETCH AND BEATS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  text(int(frameRate) + " fps", x, y); // framerate display
  text("BMP " + nf(bmp,0,1), x + 60, y);
  text("millis: " + int(avgmillis), x + 145, y);
  ///////////// rig info/ ///////////////////////////////////////////////////////////////////
  fill(300);
  text("rigViz: " + shields.availableAnims[shields.vizIndex], x, y+20);
  text("bkgrnd: " + shields.availableBkgrnds[shields.bgIndex], x, y+40);
  text("func's: " + shields.availableFunctionEnvelopes[shields.functionIndexA] + " / " + shields.availableFunctionEnvelopes[shields.functionIndexB], x+110, y+20);
  text("alph's: " + shields.availableAlphaEnvelopes[shields.alphaIndexA] + " / " + shields.availableAlphaEnvelopes[shields.alphaIndexB], x+110, y+40);
  /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
  
    fill(300);
    String sec = nf(int(vizTime*60 - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = int(vizTime*60 - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y+80);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(int(colorChangeTime*60 - (millis()/1000 - shields.colorTimer)) %60, 2, 0);
    min = int(colorChangeTime*60 - (millis()/1000 - shields.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+80);
    int totalAnims=0;      
    for (Rig rig : rigs) totalAnims += rig.animations.size();
    text("# of anims: "+totalAnims, x,y+100);

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
  if (pause > 0) { 
    textAlign(RIGHT,BOTTOM);
    textSize(18); 
    fill(360);
    text("NO AUDIO!! PAUSE RUNNING", width-20,height); 
  }
}
void mouseCircle(boolean _info){
  if (_info){
    // draw circle over mouse to check LEDS
    fill(200);  
    ellipse(mouseX, mouseY, 10, 10);
  } 
}
void mouseInfo(boolean _info) {
  if (_info) {
    // display mouse coordiantes in the bottom right.
    fill (360);
    textAlign(RIGHT,BOTTOM);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, width,height);
  }
}
void coordinatesInfo(Rig rig, boolean _info) {
  if (_info) {
    textSize(12);
    textAlign(LEFT);
    fill(rig.c);  
    float centerX = rig.size.x - (rig.wide / 2);
    float centerY = rig.size.y - (rig.high / 2);
    for (int i = 0; i < rig.position.length; i++) {
      PVector position = rig.position[i];
      text(i, centerX + position.x, centerY + position.y); // Position info
    }
    fill(rig.flash);
    int length = rig.pixelPosition.size();
    for(int i = 0; i < length; i++){
      PVector pv = rig.pixelPosition.get(i);
      text(" "+i, centerX + pv.x, centerY + pv.y);
    }
  } 
}
void dividerLines() {
  noFill();
  stroke(rigs.get(0).c1, 200);
  strokeWeight(1);
  for (Rig rig : rigs) rect(rig.size);
}