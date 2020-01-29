/*class Tup {
 float[] f;
 int i;
 Tup(float[] f, int i) {
 this.f=f;
 this.i=i;
 }
 float get() {
 if (f != null) {
 if (i<f.length && i>=0) {
 return f[i];
 }
 }
 return 1.0;
 }
 }*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
float sineFast, sineSlow, sine, stutter, shimmer;
float timer[] = new float[6];
void globalFunctions() {
  float tm = 0.05+(noize/50);
  for (int i = 0; i<timer.length; i++) timer[i] += tm;
  timer[3] += (0.3*5);
  timer[5] *=1.2;
  sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
  //if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  //else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  //shimmer = (shimmerSlider/2+(stutter*0.4*noize1*0.2));
  noize();
  oskPulse();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// BEAT DETECT THROUGHOUT SKETCH //////////////////////////////////////////////////////////////////////////
int beatCounter, pauseTdaerTime=360;
long beatTimer;
boolean beatTdaer;
float beat, avgmillis;
void resetbeats() {
  beat = 1;
  beatCounter = (beatCounter + 1) % 120;

  weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
  weightedcnt=1+(1-beatAlpha)*weightedcnt;
  avgtime=weightedsum/weightedcnt;
  avgmillis = avgtime*1000/frameRate;
  beatTimer=0;
}
///////////////////////////////////////// BEATS /////////////////////////////////////////////////////////////////////
void beats() {            
  beatTimer++;
  beatAlpha=0.2; //this affects how quickly code adapts to tempo changes 0.2 averages the last 10 onsets  0.02 would average the last 100
  beatTdaer = false;
  if (beatDetect.isOnset()) beatTdaer = true;
  // tdaer beats without audio input
  if (pause > 1) {
    if ((millis() % pauseTdaerTime) == 0) {
      beatTdaer = true;
      pauseTdaerTime = int(random(360, 750));
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (beatTdaer) resetbeats();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (avgmillis>0) beat*= pow(beatSlider, (20/avgmillis));       //  changes rate alpha fades out based on average millis between beats
  else beat*=0.95;
  float end = 0.001;
  if (beat < end) beat = end;
}
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
int pause, pauseTimer;
void pause(int secondsToWait) {
  if (beatDetect.isOnset()) {
    pause = 0;
    pauseTimer = millis()/1000;
  } else {
    if (millis()/1000 - pauseTimer >= secondsToWait) {
      pause +=1;
      pauseTimer = millis()/1000;
      avgmillis = 460;              /// need to make the same as the other thign we did for this varied bmp sthz
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// BOOTH AND DIG LIGHTS /////////////////////////////////////////////////////////////////////
void boothLights() {
  fill(0);
  rect(opcGrid.booth.x, opcGrid.booth.y, 40, 15);
  rect(opcGrid.dig.x, opcGrid.dig.y, 40, 15);
  fill(0, 150);
  strokeWeight(1);
  stroke(da.flash, 60);
  rect(opcGrid.booth.x+70, opcGrid.booth.y, 200, 30);
  noStroke();
  fill(da.flash1, 360*boothDimmer);
  rect(opcGrid.booth.x, opcGrid.booth.y, 40, 15);
  fill(da.c, 360*digDimmer);
  rect(opcGrid.dig.x, opcGrid.dig.y, 40, 15);

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(da.c, 360);
  textAlign(LEFT);
  textSize(16);
  text("BOOTH", opcGrid.booth.x+25, opcGrid.booth.y+6);
  text("DIG", opcGrid.dig.x+25, opcGrid.dig.y+6);
}
/////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
void testColors(boolean _test) {
  if (_test) {

    fill((millis()/50)%360, 100, 100, 360*da.dimmer); 
    for (Rig rig : rigs)     rect(rig.size.x, rig.size.y, rig.wide, rig.high);

    rect(opcGrid.booth.x, opcGrid.booth.y, 30, 10);
    rect(opcGrid.dig.x, opcGrid.dig.y, 30, 10);
  }
}

/////////////////////////////////////////////// OSKP///////////////////////////////////////////
float osk1, oskP, timer1;
void oskPulse() {
  osk1 += 0.01;               
  timer1 = log(map (sin(osk1), -1, 1, 0.1, 10000));
  timer1 += timer1;
  oskP = map(sin(timer1), -1, 1, 0, 1);
}

////////////////////////////////////////////// NOIZE ////////////////////////////////////////////
float noize, noize1, noize2, noize12;
void noize() {
  float dx = millis() * 0.0001;
  float z = millis() * 0.0001;
  noize = sin(10 * (noise(dx * 0.01, 0.01, z) - 0.4));
  noize2 = cos(10 * (noise(dx * 0.01, 0.01, z/1.5) - 0.4));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}

void bgNoise(PGraphics layer, color _col, float bright, float fizzyness) {
  color col=color(hue(_col), saturation(_col), 100*bright);
  layer.loadPixels();
  for (int x=0; x<layer.width; x++) {
    for (int y=0; y<layer.height; y++) {
      color pixel=layer.pixels[x+y*layer.width];
      //col=int(random(255*alpha))<<24 | col&0xffffff;
      color out;
      if (random(1.0)<fizzyness) {
        out=col;
      } else {
        out=pixel;
      }
      layer.pixels[x+y*layer.width]=out;
    }
  }
  layer.updatePixels();
}
