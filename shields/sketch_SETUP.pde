void rect(Coord c){rect(c.x,c.y,c.wide,c.high);}
void rect(Intcoord c){rect(c.x,c.y,c.wide,c.high);}
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
  //int rigWidth, rigHeight, roofWidth, roofHeight, vizWidth, vizHeight, cansWidth;
  //int cansHeight, parsWidth, parsHeight, infoWidth, infoHeight;
  IntCoord shields,diamonds,lanterns,megaSeeds,cans,info,booth;
  //PVector rig, roof, cans, donut, pars, info;
  int sizeX, sizeY;

  SizeSettings() {
    int rigWidth = 600;                                    // WIDTH of rigViz
    if (SHITTYLAPTOP) rigWidth = 350;
    int rigHeight = 600;    
    if (SHITTYLAPTOP) rigHeight = 350;
    shields = new IntCoord(rigWidth/2,rigHeight/2,rigWidth,rigHeight);

    ////////////////////////////////  ROOF SETUP RIGHT OF RIG ///////////////////////
    diamonds = new IntCoord(shields.wide+rigWidth/2,shields.y,rigWidth,rigHeight);
    
    lanterns = new IntCoord(shields.wide+diamonds.wide+rigWidth/2,rigWidth,rigHeight);

    rigHeight = 200;
    megaSeeds = new IntCoord(shields.x,shields.high+rigHeight/2,rigWidth,rigHeight);

    rigWidth = 2*rigWidth;
    int cansx = (lanterns.x + diamonds.x)/2;
    cans = new IntCoord(cansx,lanterns.y+rigHeight/2,rigWidth,rigHeight);
    
    rigWidth = shields.wide/2;
    rigHeight = shields.high;    
    info = new IntCoord(shields.wide+lanterns.wide+diamonds.wide+rigWidth/2,shields.y,rigWidth,rigHeight);

    rigHeight = cans.high;
    booth = new IntCoord(cans.x+cans.wide/2+rigWidth/2,cans.y,rigWidth,rigHeight);


    sizeX = shields.wide+lanterns.wide+diamonds.wide+info.wide;
    sizeY = shields.high+megaSeeds.high;
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
