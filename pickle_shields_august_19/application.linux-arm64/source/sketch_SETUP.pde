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
////////////////////////////////// SETUP SKETCH DRAWING NORMALS ////////////////////////
void drawingSetup() {
  myFont = createFont("Lucida Sans Unicode", 18);
  textFont(myFont);
  textSize(18);
  colorMode(HSB, 360, 100, 100);
  blendMode(BLEND);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  noStroke();
  strokeWeight(20);
  //hint(DISABLE_OPTIMIZED_STROKE);
}
/////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
//import processing.core.PApplet*;
//import processing.core.PConstants*;
//import static processing.core.PConstants.*;

PGraphics vis[] = new PGraphics[9];
PGraphics bg[] = new PGraphics[7];
PGraphics colorPreview[] = new PGraphics[bg.length];
PGraphics vizPreview[] = new PGraphics[11];

PGraphics rigWindow, roofWindow, pg, infoWindow, rigColourLayer, roofColourLayer;

void loadGraphics() {
  //////////////////////////////// VIS GRAPHICS ///////////////////
  for ( int i = 0; i< vis.length; i++ ) {
    vis[i] = createGraphics(int(mw*1.2), int(mh*1.2), P2D);
    vis[i].beginDraw();
    vis[i].colorMode(HSB, 360, 100, 100);
    vis[i].blendMode(ADD);
    vis[i].ellipseMode(RADIUS);
    vis[i].rectMode(CENTER);
    vis[i].imageMode(CENTER);
    vis[i].noStroke();
    vis[i].noFill();
    vis[i].endDraw();
  }

  //////////////////////////////// rig subwindow  ///////////////////
  rigWindow = createGraphics(mw, mh, P2D);
  rigWindow.beginDraw();
  rigWindow.colorMode(HSB, 360, 100, 100);
  rigWindow.imageMode(CENTER);
  rigWindow.rectMode(CENTER);
  rigWindow.endDraw();
  //////////////////////////////// rig colour layer  ///////////////////
  rigColourLayer = createGraphics(mw, mh, P2D);
  rigColourLayer.beginDraw();
  rigColourLayer.colorMode(HSB, 360, 100, 100);
  rigColourLayer.imageMode(CENTER);
  rigColourLayer.rectMode(CENTER);
  rigColourLayer.endDraw();
  //////////////////////////////// roof subwindow  ///////////////////
  roofWindow = createGraphics(mw, mh, P2D);
  roofWindow.beginDraw();
  roofWindow.colorMode(HSB, 360, 100, 100);
  roofWindow.imageMode(CENTER);
  roofWindow.rectMode(CENTER);
  roofWindow.endDraw();
  //////////////////////////////// roof colour layer  ///////////////////
  roofColourLayer = createGraphics(mw, mh, P2D);
  roofColourLayer.beginDraw();
  roofColourLayer.colorMode(HSB, 360, 100, 100);
  roofColourLayer.imageMode(CENTER);
  roofColourLayer.rectMode(CENTER);
  roofColourLayer.endDraw();
  //////////////////////////////// info subwindow  ///////////////////
  infoWindow = createGraphics(iw, ih, P2D);
  infoWindow.beginDraw();
  infoWindow.colorMode(HSB, 360, 100, 100);
  infoWindow.ellipseMode(RADIUS);
  infoWindow.imageMode(CENTER);
  infoWindow.rectMode(CENTER);
  infoWindow.endDraw();

  for ( int n = 0; n<vizPreview.length; n++) {
    vizPreview[n] = createGraphics(mw, mh, P2D);
    vizPreview[n].beginDraw();
    vizPreview[n].colorMode(HSB, 360, 100, 100);
    vizPreview[n].ellipseMode(RADIUS);
    vizPreview[n].imageMode(CENTER);
    vizPreview[n].rectMode(CENTER);
    vizPreview[n].endDraw();
  }

  //////////////////////////////// color preview  ///////////////////
  for ( int n = 0; n<colorPreview.length; n++) {
    colorPreview[n] = createGraphics(40, 40, P2D);
    colorPreview[n].beginDraw();
    colorPreview[n].colorMode(HSB, 360, 100, 100);
    colorPreview[n].ellipseMode(RADIUS);
    colorPreview[n].imageMode(CENTER);
    colorPreview[n].rectMode(CENTER);
    colorPreview[n].endDraw();
  }
  ///////////////////////////// COLOR LAYER / BG GRAPHICS ////////////////////////////
  for ( int n = 0; n<bg.length; n++) {
    bg[n] = createGraphics(mw, mh, P2D);
    bg[n].beginDraw();
    bg[n].colorMode(HSB, 360, 100, 100);
    bg[n].ellipseMode(RADIUS);
    bg[n].rectMode(CENTER);
    bg[n].imageMode(CENTER);
    bg[n].noStroke();
    bg[n].noFill();
    bg[n].endDraw();
  }
  ///////////////////////////// SHIELD CONTROL GRAPHICS /////////////////////
  pg  = createGraphics(mw, mh, P2D);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100);
  pg.ellipseMode(RADIUS);
  pg.rectMode(CENTER);
  pg.imageMode(CENTER);
  pg.noStroke();
  pg.noFill();
  pg.endDraw();
}
///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
PGraphics pass1[] = new PGraphics[9];
PGraphics blured[] = new PGraphics[9];

PShader blur;
PGraphics src;
int blury, prevblury;

void loadShaders(int blury) {
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);  

  src = createGraphics(mw, mh, P3D); 
  for (int i = 0; i < pass1.length; i++) {
    pass1[i] = createGraphics(int(mw*1.2), int(mh*1.2), P2D);
    pass1[i].noSmooth();
    pass1[i].imageMode(CENTER);
    pass1[i].beginDraw();
    pass1[i].noStroke();
    pass1[i].endDraw();
  }
  for (int i = 0; i < blured.length; i++) {
    blured[i] = createGraphics(int(mw*1.2), int(mh*1.2), P2D);
    blured[i].noSmooth();
    blured[i].beginDraw();
    blured[i].imageMode(CENTER);
    blured[i].noStroke();
    blured[i].endDraw();
  }
}
