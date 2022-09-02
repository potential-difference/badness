class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, vizWidth, vizHeight, cansWidth;
  int cansHeight, parsWidth, parsHeight, infoWidth, infoHeight;
  PVector rig, roof, cans, donut, pars, info;
  int surfacePositionX, surfacePositionY, sizeX, sizeY, orientation;

  SizeSettings() {
      rigWidth = 600;                                    // WIDTH of rigViz
      if (SHITTYLAPTOP) rigWidth = 350;
      rigHeight = 600;    
      if (SHITTYLAPTOP) rigHeight = 350;
      rig = new PVector(rigWidth/2, rigHeight/2);   // cordinates for center of rig
     
    ////////////////////////////////  ROOF SETUP RIGHT OF RIG ///////////////////////
    roofWidth = 0;
    roofHeight = rigHeight;
    roof = new PVector (rigWidth+(roofWidth/2), roofHeight/2);

    ////////////////////////////////  CANS SETUP RIGHT OF ROOF ///////////////////////
    cansWidth = 0;
    cansHeight = rigHeight;
    //if (SHITTYLAPTOP) cansHeight = 250;
    cans = new PVector (rigWidth+roofWidth+(cansWidth/2), cansHeight/2);

    //////////////////////////////// PARS SETUP FAR RIGHT ////////////////////////////
    parsWidth = 0;
    parsHeight = rigHeight;
    pars = new PVector(rigWidth+roofWidth+cansWidth+(parsWidth/2), parsHeight/2);      

    //////////////////////////////// INFO AREA TO RIGHT OF ALL RIGS //////////////////////
    infoWidth = rigWidth/2;
    infoHeight = rigHeight;
    info = new PVector(rigWidth+roofWidth+cansWidth+parsWidth+(infoWidth/2), infoHeight/2);      
    ///////////////////////////////////// OVERALL SIZE OF SKETCH WINDOW /////////////////////
    sizeX = rigWidth+roofWidth+cansWidth+parsWidth+infoWidth;
    sizeY = rigHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
void midiSetup() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  String[] inputs = MidiBus.availableInputs();
  //String[] outputs = MidiBus.availableOutputs(); 
  for (String in : inputs){//(int idx=0;idx < inputs.length;idx++){//in : inputs){
    //String in = inputs[idx];
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
    if (in.contains("MPD218")) { 
      MPD8bus = new MidiBus(this,in,in);
      println("Found AKAI MPD218: ", in);
    }
  }
  setupMidiActions();
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
float avgvolume, weightedsum, weightedcnt, beatTempo;
void audioSetup(int sensitivity, float beatTempo) {
  // beatTempo affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
    
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);
  weightedsum=0;
  weightedcnt=0;
  avgvolume = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

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
