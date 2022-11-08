void rect(Coord c){rect(c.x,c.y,c.wide,c.high);}
void rect(IntCoord c){rect(c.x,c.y,c.wide,c.high);}
class Coord{
  float x,y,wide,high;
  Coord(float _x,float _y,float _wide,float _high){
    x=_x; y=_y; wide=_wide; high=_high;
  }
}
class IntCoord{
  int x,y,wide,high;
  IntCoord(int _x,int _y,int _wide,int _high){
    x = _x; y=_y;wide=_wide;high=_high;
  }
}

class SizeSettings {
  IntCoord shields,roofmid,roofcentre,roofsides,megaSeedA,megaSeedB,info,booth,bar,uvPars;
  //PVector rig, roof, cans, donut, pars, info;
  int sizeX, sizeY;

  SizeSettings() {
    int rigWidth = 600;   
    int rigHeight = 600;    
                               
    if (SHITTYLAPTOP) rigWidth = 547;
    if (SHITTYLAPTOP) rigHeight = 547;

    shields = new IntCoord(rigWidth/2,rigHeight/2,rigWidth,rigHeight);

    ////////////////////////////////  TOP LINE OF RIGS RIGHT OF MAIN ONE ///////////////////////
    rigWidth = shields.wide/3;
    // TODO - MAKE THIS EASIER TO ADJUST //
    roofcentre = new IntCoord(shields.wide+rigWidth/2,shields.y,rigWidth,rigHeight);
    roofmid = new IntCoord(roofcentre.x+roofcentre.wide/2+rigWidth/2,shields.y,rigWidth,rigHeight);
    roofsides = new IntCoord(roofmid.x+roofmid.wide/2+rigWidth/2,shields.y,rigWidth,rigHeight);

    rigWidth = 250;
    info = new IntCoord(roofsides.x+roofsides.wide/2+rigWidth/2,shields.y,rigWidth,rigHeight);

    ////////////////////////////////  BOTTOM LINE OF RIGS ///////////////////////

    rigHeight = 100;
    rigWidth = 200;
    int bottomRigY = shields.high+rigHeight/2;

    megaSeedA = new IntCoord(rigWidth/2,bottomRigY,rigWidth,rigHeight);
    megaSeedB = new IntCoord(megaSeedA.wide+rigWidth/2,bottomRigY,rigWidth,rigHeight);

    rigWidth = 400;
   
    uvPars = new IntCoord(megaSeedB.x+megaSeedB.wide/2+rigWidth/2,bottomRigY,rigWidth,rigHeight);
    bar = new IntCoord(uvPars.x+uvPars.wide/2+rigWidth/2,bottomRigY,rigWidth,rigHeight);

    rigWidth = info.wide;
    booth = new IntCoord(info.x,bottomRigY,rigWidth,rigHeight);
    
    ////////////////////////////////  OVERALL SIZE /////////////////////////////

    sizeX = shields.wide+roofsides.wide+roofmid.wide+roofcentre.wide+info.wide;
    sizeY = shields.high+megaSeedA.high;
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
