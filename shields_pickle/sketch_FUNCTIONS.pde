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
//void dmxSmoke(BoothGrid opcGrid) {
// how does this even work
/*
class ManualDmxSmoke extends ManualAnim {
  ManualDmxSmoke(Rig rig_){super(rig_);}
  void draw(){
    float smokePumpValue = 0.5;//rig.smokePumpValue;
    //need to be able to add extra sliders to a rig
    //without fucking inheritance
    BoothGrid opcgrid = (BoothGrid)rig.opcgrid;
    //TODO HACK 
    //nullpointerexception waiting to happen mate.
    fill(360*smokePumpValue);
    rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 10, 10);
  }
}
*/
//momentary_keypresses['0'] = (bool value)->{rigs.get("boothgrid")}
// add this Anim in the Booth constructor
// booth = new Rig
/*
class DmxSmoke extends Anim {
  DmxSmoke(Rig _rig){
    //assert that this rig is a boothgrid
    super(_rig);
    animName = "DmxSmoke";
  }
  void draw() {
    float smokePumpValue = 0.5;//rig.smokePumpValue;
    float smokeOnTime = 0.5;//rig.smokeOnTime;
    float smokeOffTime = 0.5;//rig.smokeOffTime;
    BoothGrid opcgrid = (BoothGrid)rig.opcgrid;
    //TODO HACK nullpointerexception waiting to happen
    ////////////////////////////////////// DMX SMOKE //////////////////////////////////
    fill(0, 150);
    strokeWeight(1);
    stroke(flash, 60);
    rect(opcGrid.smokePump.x+80, opcGrid.smokePump.y, 220, 30);
    noStroke();
    fill(0);
    rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 40, 15);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // this is an anim
    float smokeInterval = smokeOffTime*60;
    float smokeOn = smokeOnTime;
    if (millis()/1000 % smokeInterval > smokeInterval - smokeOn) {
      fill(360*smokePumpValue);
      if (smokeToggle)  rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 10, 10);
    }
    float smokeInfo = millis()/1000 % smokeInterval - (smokeInterval);
    fill(c, 360);
    textAlign(LEFT);
    textSize(16);
    int min = abs(int(smokeInfo) /60 % 60);
    String sec = nf(abs(int(smokeInfo) % 60), 2, 0);
    text("SMOKE ON IN: "+min+":"+sec, opcGrid.smokePump.x+25, opcGrid.smokePump.y+6);
  }
}
*/
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
  // TODO figure out a way to reinstate this
  // if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  // else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  // //shimmer = (shimmerSlider/2+(stutter*0.4*noize1*0.2));
  noize();
  oskPulse();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// BEAT DETECT THROUGHOUT SKETCH //////////////////////////////////////////////////////////////////////////
int beatCounter, pauseTriggerTime=360;
long beatTimer;
boolean beatTrigger;
float beat, avgmillis, bmp;
void resetbeats() {
  beat = 1;
  beatCounter = (beatCounter + 1) % 120;

  weightedsum=beatTimer+(1-beatTempo)*weightedsum;
  weightedcnt=1+(1-beatTempo)*weightedcnt;
  float avgtime=weightedsum/weightedcnt;
  avgmillis = avgtime*1000/frameRate;
  bmp = 60000/avgmillis;
  beatTimer=0;
}
///////////////////////////////////////// BEATS /////////////////////////////////////////////////////////////////////
void beats(float _beatSlider) {  
  beatTimer++;
  beatTrigger = false;
  if (beatDetect.isBeat()) beatTrigger = true;
  // trigger beats without audio input
  if (pause > 1) {
    if ((millis() % pauseTriggerTime) == 0) {
      beatTrigger = true;
      pauseTriggerTime = int(random(360, 750));
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (beatTrigger) resetbeats();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (avgmillis>0) beat*= pow(_beatSlider, (20/avgmillis));       //  changes rate alpha fades out based on average millis between beats
  else beat*=0.95;
  float end = 0.001;
  if (beat < end) beat = end;
}
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
int pause, pauseTimer;
void pause(int secondsToWait) {
  if (beatDetect.isBeat()) {
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
void boothLights(BoothGrid opcGrid) {
  fill(0);              // FILL IN BLACK TO CANCEL ANY ANIMATIONS ETC
  rect(opcGrid.booth);
  rect(opcGrid.dig);
  rect(opcGrid.mixer);
  fill(0, 150);         // DRAW OUTLINE BOX 
  rect(opcGrid.dig.x+30, opcGrid.dig.y, 110, 70);
  noStroke();
  //////////////////// RECTANGLES TO CONTROL BIRGHTNESS AND COLOUR //////////////
  fill(flash1, 360*boothDimmer);
  rect(opcGrid.booth);
  fill(c, 360*digDimmer);
  rect(opcGrid.dig);
  fill(c, 360*mixerDimmer);
  rect(opcGrid.mixer);
  //////////////////// ON SCREEN INFO /////////////////////////////////////////////
  fill(c, 360);
  textAlign(LEFT);
  textSize(16);
  text("BOOTH", opcGrid.booth.x+25, opcGrid.booth.y+6);
  text("DIG", opcGrid.dig.x+25, opcGrid.dig.y+6);
  text("MIXER",opcGrid.mixer.x+25, opcGrid.mixer.y+6);
  noFill();
  strokeWeight(1);
  stroke(flash,60);
  rect(opcGrid.booth);
  rect(opcGrid.dig);
  rect(opcGrid.mixer);
  noStroke();
}

void blinders(BoothGrid opcGrid){
  //static boolean blindersOn = false;
  //to create a dimmer
  //make a new global variable blinderDimmer=0.2 or whatever
  //then copy and paste a fader in touchosc
  //under the booth panel
  //change the name to blinderDimmer
  //and the label to blinderDimmer
  fill(0);              // FILL IN BLACK TO CANCEL ANY ANIMATIONS ETC
  rect(opcGrid.blinders); 
  fill(0, 150);         // DRAW OUTLINE BOX 
  strokeWeight(1);
  stroke(flash,60);
  rect(opcGrid.blinders.x, opcGrid.blinders.y, 110, 70); 
  noStroke();
  // if (beatCounter % 32 < 4){
    if (shields.animations.size() > 0){
      Anim anim = shields.animations.get(0);
      fill(100*anim.alphaA);
      rect(opcGrid.blinders);
    }
  // }
  fill(c, 360);
  textAlign(CENTER);
  textSize(16);
  text("BLINDERS", opcGrid.blinders.x, opcGrid.blinders.y+30);
  noFill();
  strokeWeight(1);
  stroke(flash,60);
  rect(opcGrid.blinders);
  noStroke();
}
/////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
void testColors(boolean test) {
  if (test) {

    fill((millis()/25)%360, 100, 100, 360*shields.dimmer);  // TODO need to have touch osc setup
    fill((millis()/25)%360, 100, 100, 50);                  // fixed for now

    for (Rig rig : rigs)     rect(rig.size.x, rig.size.y, rig.wide, rig.high);

   //rect(opcGrid.booth.x, opcGrid.booth.y, 30, 10);
   //rect(opcGrid.dig.x, opcGrid.dig.y, 30, 10);
  }
}
/////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
void workLights(boolean _work,BoothGrid opcGrid) {
  if (_work) {
    pause = 10;
    fill(360, 360 * shields.dimmer);
    for (Rig rig : rigs) rect(rig.size);
    // rect(size.shields);
    // rect(size.tipiLeft);
    // rect(size.tipiRight);
    // //rect(size.cans);
    // rect(opcGrid.booth);
    // rect(opcGrid.dig);
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

void printmd(String text) {
  outputmd.println(text); // Write the provided text to the file
}