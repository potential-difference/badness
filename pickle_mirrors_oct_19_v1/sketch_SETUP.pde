
class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, sliderHeight, infoWidth, infoHeight, vizWidth, vizHeight;
  PVector rig, roof, info, viz, rigWindow;
  int surfacePositionX, surfacePositionY, sizeX, sizeY, orientation;

  SizeSettings(int _orientation) {
    orientation = _orientation;
    switch (orientation) {
    case PORTRAIT:
      rigWidth = 600;                                    // WIDTH of rigViz
      rigHeight = 550;                                   // HEIGHT of rigViz
      rig = new PVector(rigWidth/2, (rigHeight/2)-30);   // cordinates for center of rig
      rigWindow = new PVector(rigWidth/2, rigHeight/2);
      break;
    case LANDSCAPE:
      rigWidth = 900;                                    // WIDTH of rigViz
      rigHeight = 300;    
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      rigWindow = new PVector(rigWidth/2, rigHeight/2);
      break;
    }

    vizWidth = rigWidth;
    vizHeight = rigHeight;
    viz = new PVector (rig.x, rig.y);

    roofWidth = 0;
    roofHeight = rigHeight;
    roof = new PVector (rigWidth+roofWidth/2, roofHeight/2);

    sliderHeight = 70;         // height of slider area at bottom of sketch window

    infoWidth = 300;
    infoHeight = rigHeight+sliderHeight;
    info = new PVector (rigWidth+roofWidth+(infoWidth/2), infoHeight/2);

    sizeX = rigWidth+roofWidth+infoWidth;
    sizeY = sliderHeight+rigHeight;
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

/////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
PGraphics vis[] = new PGraphics[16];
PGraphics roofVis[] = new PGraphics[16];
PGraphics bg[] = new PGraphics[bgList];
PGraphics rigWindow, roofWindow, pg, infoWindow, rigColourLayer, roofColourLayer;
void loadGraphics() {
  //////////////////////////////// RIG VIS GRAPHICS ///////////////////
  for ( int i = 0; i< vis.length; i++ ) {
    vis[i] = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    vis[i].beginDraw();
    vis[i].colorMode(HSB, 360, 100, 100);
    vis[i].blendMode(NORMAL);
    vis[i].ellipseMode(CENTER);
    vis[i].rectMode(CENTER);
    vis[i].imageMode(CENTER);
    vis[i].noStroke();
    vis[i].noFill();
    vis[i].endDraw();
  }
  //////////////////////////////// rig subwindow  ///////////////////
  rigWindow = createGraphics(int(size.rigWidth), int(size.rigHeight), P2D);
  rigWindow.beginDraw();
  rigWindow.colorMode(HSB, 360, 100, 100);
  rigWindow.imageMode(CENTER);
  rigWindow.rectMode(CENTER);
  rigWindow.endDraw();
  //////////////////////////////// rig colour layer  ///////////////////
  rigColourLayer = createGraphics(int(size.rigWidth), int(size.rigHeight), P2D);
  rigColourLayer.beginDraw();
  rigColourLayer.colorMode(HSB, 360, 100, 100);
  rigColourLayer.imageMode(CENTER);
  rigColourLayer.rectMode(CENTER);
  rigColourLayer.endDraw();
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////// ROOF GRAPHICS SETUP ///////////////////////////////////////////
  if (size.roofWidth > 0) {
    ////////////////////////////// ROOF VIS GRAPHICS ///////////////////
    for ( int i = 0; i< vis.length; i++ ) {
      roofVis[i] = createGraphics(int(size.roofWidth*1.2), int(size.roofHeight*1.2), P2D);
      roofVis[i].beginDraw();
      roofVis[i].colorMode(HSB, 360, 100, 100);
      roofVis[i].blendMode(NORMAL);
      roofVis[i].ellipseMode(CENTER);
      roofVis[i].rectMode(CENTER);
      roofVis[i].imageMode(CENTER);
      roofVis[i].noStroke();
      roofVis[i].noFill();
      roofVis[i].endDraw();
    }
    //////////////////////////////// roof subwindow  ///////////////////
    roofWindow = createGraphics(int(size.roofWidth), int(size.roofHeight), P2D);
    roofWindow.beginDraw();
    roofWindow.colorMode(HSB, 360, 100, 100);
    roofWindow.imageMode(CENTER);
    roofWindow.rectMode(CENTER);
    roofWindow.endDraw();
    //////////////////////////////// roof colour layer  ///////////////////
    roofColourLayer = createGraphics(int(size.roofWidth), int(size.roofHeight), P2D);
    roofColourLayer.beginDraw();
    roofColourLayer.colorMode(HSB, 360, 100, 100);
    roofColourLayer.imageMode(CENTER);
    roofColourLayer.rectMode(CENTER);
    roofColourLayer.endDraw();
  }
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
///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
PGraphics pass1[] = new PGraphics[16];
PGraphics blured[] = new PGraphics[16];
PShader blur;
PGraphics src;
int blury, prevblury;
void loadShaders(int blury) {
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);  
  src = createGraphics(size.rigWidth, size.rigHeight, P3D); 
  for (int i = 0; i < pass1.length; i++) {
    pass1[i] = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    pass1[i].noSmooth();
    pass1[i].imageMode(CENTER);
    pass1[i].beginDraw();
    pass1[i].noStroke();
    pass1[i].endDraw();
  }
  for (int i = 0; i < blured.length; i++) {
    blured[i] = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    blured[i].noSmooth();
    blured[i].beginDraw();
    blured[i].imageMode(CENTER);
    blured[i].noStroke();
    blured[i].endDraw();
  }
}
