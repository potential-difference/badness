class SizeSettings {
  int rigWidth, rigHeight, roWidth, roHeight, infoWidth, vizWidth, vizHeight, paWidth, paHeight, teWidth, teHeight;
  PVector rig, ro, info, pa, donut, te;
  int surfacePositionX, surfacePositionY, sizeX, sizeY, orientation;

  SizeSettings(int _orientation) {
    orientation = _orientation;
    switch (orientation) {
    case PORTRAIT:
      rigWidth = 600;                                    // WIDTH of rigViz
      rigHeight = 350;                                   // HEIGHT of rigViz
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    case LANDSCAPE:
      rigWidth = 500;                                    // WIDTH of rigViz
      if (SHITTYLAPTOP) rigWidth = 600;
      rigHeight = 500;    
      if (SHITTYLAPTOP) rigHeight = 250;
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    }

    ////////////////////////////////  ROOF SETUP RIGHT OF RIG ///////////////////////
    roWidth = 350;
    roHeight = rigHeight;
    ro = new PVector (rigWidth+(roWidth/2), roHeight/2);

    ////////////////////////////////  CANS SETUP RIGHT OF ROOF ///////////////////////
    paWidth = 300;
    paHeight = rigHeight;
    //if (SHITTYLAPTOP) paHeight = 250;
    pa = new PVector (rigWidth+roWidth+(paWidth/2), paHeight/2);

    //////////////////////////////// PARS SETUP FAR RIGHT ////////////////////////////
    teWidth = 120;
    teHeight = rigHeight;
    te = new PVector(rigWidth+roWidth+paWidth+(teWidth/2), teHeight/2);      

    sizeX = rigWidth+roWidth+paWidth+teWidth;
    sizeY = rigHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
void midiSetup() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  beatStepBus = new MidiBus(this, "Arturia BeatStep", "Arturia BeatStep"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
}

//////////////////////////////////////// LOAD IMAGES ///////////////////////////
PImage bar1, flames; 
void loadImages() {
  flames = loadImage("1.jpg");
  bar1 = loadImage("bar1.png");
}
//////////////////////////// AUDIO SETUP ////////////////////////////////////
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import javax.sound.sampled.*;
Minim minim;
AudioInput in;
BeatDetect beatDetect;
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
void audioSetup(int sensitivity) {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);

  beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  weightedsum=0;
  weightedcnt=0;
  avgtime=0;
  avgvolume = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
AudioPlayer player[];
void loadAudio() {
  //////////////////////////////// load one shot sounds ///////////////////////////////
  player = new AudioPlayer[81];
  for (int i = 1; i <= 80; i++) {
    int hundreds = i/100;
    int tens = (i%100)/10;
    int ones = i%10;
    String number =str(hundreds)+str(tens)+str(ones);
    player[i] = minim.loadFile("oneshot_"+number+".wav");
  }
  println("audio loaded");
}
////////////////////////////////// SETUP SKETCH DRAWING NORMALS ////////////////////////
void drawingSetup() {

  colorMode(HSB, 360, 100, 100);
  blendMode(ADD);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  noStroke();
  strokeWeight(20);
  //hint(DISABLE_OPTIMIZED_STROKE);
}

PShader blur;
void loadShaders() {
  float blury = int(10);
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}
