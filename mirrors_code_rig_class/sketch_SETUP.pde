
class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, sliderHeight, infoWidth, infoHeight, vizWidth, vizHeight, cansWidth, cansHeight;
  PVector rig, roof, info, cans;
  int surfacePositionX, surfacePositionY, sizeX, sizeY, orientation;

  SizeSettings(int _orientation) {
    orientation = _orientation;
    switch (orientation) {
    case PORTRAIT:
      rigWidth = 600;                                    // WIDTH of rigViz
      rigHeight = 550;                                   // HEIGHT of rigViz
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    case LANDSCAPE:
      rigWidth = 900;                                    // WIDTH of rigViz
      rigHeight = 350;    
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    }

    //////////////////////////////// LANDSCAPE ROOF SETUP UNDER RIG ///////////////////////
    cansWidth = rigWidth;
    cansHeight = 60;
    cans = new PVector (rig.x, rigHeight+(cansHeight/2));
    roofWidth = 250;
    roofHeight = rigHeight+cansHeight;
    roof = new PVector (rigWidth+(roofWidth/2), roofHeight/2);

    sliderHeight = 70;         // height of slider area at bottom of sketch window

    infoWidth = 200;
    infoHeight = rigHeight+sliderHeight;
    info = new PVector (rigWidth+roofWidth+(infoWidth/2), infoHeight/2);

    sizeX = rigWidth+infoWidth+roofWidth;
    sizeY = sliderHeight+rigHeight+cansHeight;
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
class Buffer {
  PGraphics colorLayer, buffer, pass1, pass2;
  Buffer(int wide, int high) {

    colorLayer = createGraphics(wide, high, P2D);
    colorLayer.beginDraw();
    colorLayer.colorMode(HSB, 360, 100, 100);
    colorLayer.imageMode(CENTER);
    colorLayer.rectMode(CENTER);
    colorLayer.endDraw();

    buffer = createGraphics(wide, high, P2D);
    buffer.beginDraw();
    buffer.colorMode(HSB, 360, 100, 100);
    buffer.blendMode(NORMAL);
    buffer.ellipseMode(CENTER);
    buffer.rectMode(CENTER);
    buffer.imageMode(CENTER);
    buffer.noStroke();
    buffer.noFill();
    buffer.endDraw();

    ///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
    pass1 = createGraphics(wide/2, high/2, P2D);
    pass1.noSmooth();
    pass1.imageMode(CENTER);
    pass1.beginDraw();
    pass1.noStroke();
    pass1.endDraw();

    pass2 = createGraphics(wide/2, high/2, P2D);
    pass2.noSmooth();
    pass2.beginDraw();
    pass2.imageMode(CENTER);
    pass2.noStroke();
    pass2.endDraw();
  }
}
/////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
PGraphics bg[] = new PGraphics[rigBgList];
PGraphics rigWindow, roofWindow, cansWindow, infoWindow, rigColourLayer, roofColourLayer, rigBluredA, rigBluredB, roofBluredA, roofBluredB;
void loadGraphics() {
    //////////////////////////////// info subwindow  ///////////////////
  infoWindow = createGraphics(size.infoWidth, size.infoHeight, P2D);
  infoWindow.beginDraw();
  infoWindow.colorMode(HSB, 360, 100, 100);
  infoWindow.ellipseMode(CENTER);
  infoWindow.imageMode(CENTER);
  infoWindow.rectMode(CENTER);
  infoWindow.endDraw();
  ///////////////////////////// COLOR LAYER / BG GRAPHICS ////////////////////////////
  for ( int n = 0; n<bg.length; n++) {
    bg[n] = createGraphics(int(size.rigWidth), int(size.rigHeight), P2D);
    bg[n].beginDraw();
    bg[n].colorMode(HSB, 360, 100, 100);
    bg[n].ellipseMode(CENTER);
    bg[n].rectMode(CENTER);
    bg[n].imageMode(CENTER);
    bg[n].noStroke();
    bg[n].noFill();
    bg[n].endDraw();
  }
}
PShader blur;
void loadShaders() {
  float blury = int(map(blurSlider, 0, 1, 0, 100));
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}
