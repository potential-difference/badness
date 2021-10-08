class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, infoWidth, vizWidth, vizHeight, cansWidth, cansHeight, parsWidth, parsHeight;
  PVector rig, roof, info, cans, donut, pars;
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
    case SHIELDS:
      rigWidth = 400;                                    // WIDTH of rigViz
      if (SHITTYLAPTOP) rigWidth = 350;
      rigHeight = 400;    
      if (SHITTYLAPTOP) rigHeight = 350;
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    }

    ////////////////////////////////  ROOF SETUP RIGHT OF RIG ///////////////////////
    roofWidth = rigHeight;
    roofHeight = rigHeight;
    roof = new PVector (rigWidth+(roofWidth/2), roofHeight/2);

    ////////////////////////////////  CANS SETUP RIGHT OF ROOF ///////////////////////
    cansWidth = 200;
    cansHeight = rigHeight;
    //if (SHITTYLAPTOP) cansHeight = 250;
    cans = new PVector (rigWidth+roofWidth+(cansWidth/2), cansHeight/2);

    //////////////////////////////// PARS SETUP FAR RIGHT ////////////////////////////
    parsWidth = 200;
    parsHeight = rigHeight;
    pars = new PVector(rigWidth+roofWidth+cansWidth+(parsWidth/2), parsHeight/2);      

    sizeX = rigWidth+roofWidth+cansWidth+parsWidth;
    sizeY = rigHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
void midiSetup() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  String[] inputs = MidiBus.availableInputs();
  //String[] outputs = MidiBus.availableOutputs(); 
  for (String in : inputs){
    if (in.contains("TR-8S")) { 
      TR8bus = new MidiBus(this, in,in);
      println("Found TR8: ",in);
    }
    if (in.contains("LPD8")) {
      LPD8bus = new MidiBus(this,in,in);
      println("Found LPD8: ", in);
    }
    if (in.contains("BeatStep")) { 
      beatStepBus = new MidiBus(this,in,in);
      println("Found Arturia BeatStep: ", in);
    }
  }
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
