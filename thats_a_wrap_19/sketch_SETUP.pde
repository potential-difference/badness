class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, infoWidth, vizWidth, vizHeight, cansWidth, cansHeight, donutWidth, donutHeight;
  PVector rig, roof, info, cans, donut;
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
      rigWidth = 900;                                    // WIDTH of rigViz
      rigHeight = 350;    
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    }

    ////////////////////////////////  CANS SETUP UNDER RIG ///////////////////////
    cansWidth = rigWidth;
    cansHeight = 400;
    cans = new PVector (rig.x, rigHeight+(cansHeight/2));

    ////////////////////////////////  ROOF SETUP RIGHT OF RIG ///////////////////////
    roofWidth = 500;
    roofHeight = rigHeight;
    roof = new PVector (rigWidth+(roofWidth/2), roofHeight/2);

    //////////////////////////////// DONUT SETUP ///////////////////////
    donutWidth = roofWidth;
    donutHeight = cansHeight;
    donut = new PVector (roof.x, cans.y);
 
    sizeX = rigWidth+roofWidth;
    sizeY = rigHeight+cansHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
class Toggle {
  boolean rect = false;
  Toggle() {
    rect = false;
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
  myFont = createFont("Lucida Sans Unicode", 18);
  textFont(myFont);
  textSize(18);
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
  float blury = int(map(blurSlider, 0, 1, 0, 100));
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}
