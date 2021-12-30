import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import controlP5.*; 
import ch.bildspur.artnet.*; 
import javax.sound.midi.ShortMessage; 
import oscP5.*; 
import netP5.*; 
import themidibus.*; 
import java.util.Arrays; 
import java.net.*; 
import java.util.Arrays; 
import java.util.*; 
import java.net.*; 
import java.util.Arrays; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import javax.sound.sampled.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pickle_mirrors_dec_19 extends PApplet {

OPC opcLocal;
OPC opcMirror1; 
OPC opcMirror2;
OPC opcNode4;
OPC opcNode3;
OPC opcNode6;
OPC opcNode7;
OPC opcWifi;




ControlP5 main_cp5;
ControlFrame ControlFrame; // load control frame must come after shild ring etc

boolean SHITTYLAPTOP=false;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ControlFrame controlFrame, sliderFrame;

Rig rigg, roof, cans, mirrors, strips, donut, seeds, pars;
ArrayList <Rig> rigs = new ArrayList<Rig>();  

       // shorthand names for each control on the TR8


OscP5 oscP5[] = new OscP5[4];

  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep

String controlFrameValues, sliderFrameValues, mainFrameValues;


boolean onTop = false;
boolean MCFinitialized, SFinitialized;
public void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings(LANDSCAPE);
  //fullScreen();
  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 1920-width-50;
  if (SHITTYLAPTOP) size.surfacePositionX = 0;
  size.surfacePositionY = 150;
}
public void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);

  //surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  MCFinitialized = false;
  controlFrame = new MainControlFrame(this, width*2, 530, size.surfacePositionX, size.surfacePositionY+height+5); // load control frame must come after shild ring etc
  opcGrid = new OPCGrid();

  // order of these is important for layout of sliders
  print("MainControlFrame");
  while (!MCFinitialized) {
    delay(100);
    print(".");
  }
  println(".");

  int frameWidth = 220;
  SFinitialized = false;
  sliderFrame = new SliderFrame(this, frameWidth, height+controlFrame.height+5, size.surfacePositionX-frameWidth-5, size.surfacePositionY); // load control frame must come after shild ring etc

  print("SliderFrame");
  //wait for MCF,SF to be initialized
  while (!SFinitialized) {
    delay(100);
    print(".");
  }
  println(".");
  ///////////////// LOCAL opc /////////////////////
  opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS

  ///////////////// OPC over NETWORK /////////////////////
  opcMirror1 = new OPC(this, "192.168.10.2", 7890);     // left hand mirror
  opcMirror2 = new OPC(this, "192.168.10.5", 7890);     // right hand mirror
  opcNode4 = new OPC(this, "192.168.10.210", 7890);
  opcNode3 = new OPC(this, "192.168.10.3", 7890);
  //opcNode6 = new OPC(this, "192.168.10.6", 7890);
  opcNode7 = new OPC(this, "192.168.10.7", 7890);

  opcGrid.mirrorsOPC(opcLocal, opcLocal, 1);               // grids 0-3 MIX IT UPPPPP 
  opcGrid.standAloneBoothOPC(opcLocal);
  opcGrid.tawSeedsOPC(cans, opcLocal, opcLocal);
  opcGrid.individualCansOPC(roof, opcLocal, true);
  opcGrid.dmxParsOPC(opcLocal);
  opcGrid.dmxSmokeOPC(opcLocal);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  setupSpecifics();
  //syphonSetup(syphonToggle);
  //DMXSetup();

  controlFrameValues = sketchPath("cp5ControlFrameValues");
  sliderFrameValues  = sketchPath("cp5SliderFrameValues");
  mainFrameValues  = sketchPath("cp5MainFrameValues");
  try {
    controlFrame.cp5.loadProperties(controlFrameValues);
    sliderFrame.cp5.loadProperties(sliderFrameValues);
  }
  catch(Exception e) {
    println(e);
    println("*** !!PROBABLY NO PROPERTIES FILE!! ***");
  }
  for (int i = 0; i < 17; i++) {
    String controllerName = "slider "+i;
    float value = sliderFrame.cp5.getController(controllerName).getValue();
    setCCfromController(controllerName, value);
  }
  frameRate(30); // always needs to be last in setup
}


float vizTime, colTime;
int colStepper = 1;
int time_since_last_anim=0;
public void draw()
{
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                                ////// number of seconds before no music detected and auto kicks in
  globalFunctions();
  //syphonLoadSentImage(syphonToggle);

  vizTime = 60*15*vizTimeSlider;
  if (frameCount > 10) playWithYourself(vizTime);
  c = rigg.c;
  flash = rigg.flash;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  if (beatTrigger) { 
    for (Rig rig : rigs) {
      if (rig.toggle) {
        //if (testToggle) rig.animations.add(new Test(rig));
        //println(rig.name+" vizIndex", rig.vizIndex);
        rig.addAnim(rig.vizIndex);           // create a new anim object and add it to the beginning of the arrayList
      }
    }
  }
  if (keyT['s']) for (Anim anim : rigg.animations)  anim.funcFX = 1-(stutter*noize1*0.1f);
  //////////////////////////////////////////// Artnet  /////////////
  //DMXcontrollingUs();
  //////////////////// Must be after playwithme, before rig.draw()////
  for (Rig rig : rigs) rig.draw();  
  //////////////////////////////////////////// PLAY WITH ME MORE /////////////////////////////////////////////////////////////////////////////////
  playWithMeMore();
  //////////////////////////////////////////// BOOTH & DIG ///////////////////////////////////////////////////////////////////////////////////////
  boothLights();
  //////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////
  workLights(keyT['w']);
  testColors(keyT['t']);
  //////////////////////////////////////////// !!!SMOKE!!! ///////////////////////////////////////////////////////////////////////////////////////
  dmxSmoke();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  mouseInfo(keyT['q']);
  frameRateInfo(5, 20);                     // display frame rate X, Y /////
  dividerLines();
  //gid.mirrorTest(false);                  // true to test physical mirror orientation
  //syphonSendImage(syphonToggle);
}
public void dmxSmoke() {
  ////////////////////////////////////// DMX SMOKE //////////////////////////////////


  fill(0, 150);
  strokeWeight(1);
  stroke(rigg.flash, 60);
  rect(opcGrid.smokePump.x+80, opcGrid.smokePump.y, 220, 30);
  noStroke();
  fill(0);
  rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 40, 15);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(rigg.c, 360);
  textAlign(LEFT);
  textSize(16);
  text("PUMP", opcGrid.smokePump.x+25, opcGrid.smokePump.y+6);

  float smokeInterval = smokeOffTime*60;
  float smokeOn = smokeOnTime;
  if (millis()/1000 % smokeInterval > smokeInterval - smokeOn) {
    fill(360*smokePumpValue);
    rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 10, 10);
  }
  float smokeInfo = millis()/1000 % smokeInterval - (smokeInterval);
  fill(300);
  text("smoke on in: "+smokeInfo+" seconds", opcGrid.smokePump.x+200, opcGrid.smokePump.y+5);

  if (keyP['0']) {
    fill(360*smokePumpValue);
    rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 10, 10);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void setupSpecifics() {
  /*
   animNames = new String[] {"benjmains boxes", "checkers", "rings", "rush", "rushed", 
   "square nuts", "diaganol nuts", "stars", "swipe", "swiped", "teeth", "donut"}; 
   backgroundNames = new String[] {"one col c", "vert mirror grad", "side by side", "horiz mirror grad", 
   "one color flash", "moving horiz grad", "checked", "radiators", "stripes", "one two three"}; 
   */

  rigg.availableAnims = new int[] {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};      // setup which anims are used on which rig here
  roof.availableAnims = rigg.availableAnims;      // setup which anims are used on which rig here - defualt is 0,1,2,3...
  cans.availableAnims = new int[] {11, 4, 2, 7, 4, 5, 6, 7, 8, 9, 10, 12};      // setup which anims are used on which rig here
  pars.availableAnims = new int[] {0, 12};      // setup which anims are used on which rig here

  rigg.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5};  
  roof.availableFunctionEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  

  rigg.availableBkgrnds = new int[] {0, 1, 2, 3, 4, 5, 6, 9};
  cans.availableBkgrnds = new int[] {0, 1, 2, 3, 4, 5}; //rigg.availableBkgrnds;
  roof.availableBkgrnds = new int[] {0, 1, 3, 4, 5, 8};
  pars.availableBkgrnds = new int[] {0, 4};

  ///////////////////////////////// UPDATE THE DROPDOWN LISTS WITH AVLIABLE OPTIONS ///////////////////////////////////////////////////////
  for (Rig rig : rigs) {    
    rig.ddVizList.clear();
    rig.ddBgList.clear();
    rig.ddAlphaList.clear();
    rig.ddAlphaListB.clear();
    rig.ddFuncList.clear();
    rig.ddFuncListB.clear();
    for (int i=0; i<rig.availableBkgrnds.length; i++) { 
      int index = rig.availableBkgrnds[i];
      rig.ddBgList.addItem(rig.backgroundNames[index], index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableAnims.length; i++) {
      int index = rig.availableAnims[i];
      rig.ddVizList.addItem(rig.animNames[index], index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableAlphaEnvelopes.length; i++) {
      int index = rig.availableAlphaEnvelopes[i];
      rig.ddAlphaList.addItem("alph "+index, index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableAlphaEnvelopes.length; i++) {
      int index = rig.availableAlphaEnvelopes[i];
      rig.ddAlphaListB.addItem("alph "+index, index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableFunctionEnvelopes.length; i++) {
      int index = rig.availableFunctionEnvelopes[i];
      rig.ddFuncList.addItem("func "+index, index); //add all available anims to VizLists -
    }
    println(rig.name+" fun length", rig.availableFunctionEnvelopes.length);
    for (int i=0; i<rig.availableFunctionEnvelopes.length; i++) {
      int index = rig.availableFunctionEnvelopes[i];
      rig.ddFuncListB.addItem("func "+index, index); //add all available anims to VizLists -
    }
    //need to use the actal numbers from the above aray
  }

  //rigg.dimmers.put(3, new Ref(cc, 34));

  rigg.vizIndex = 2;
  roof.vizIndex = 1;
  rigg.functionIndexA = 0;
  rigg.functionIndexB = 1;
  rigg.alphaIndexA = 0;
  rigg.alphaIndexB = 1;
  rigg.bgIndex = 0;
  roof.bgIndex = 4;

  rigg.colorIndexA = 2;
  rigg.colorIndexB = 1;
  roof.colorIndexA = 1;
  roof.colorIndexB = 0;
  cans.colorIndexA = 7;
  cans.colorIndexB = 11;
  //donut.colorIndexA = 
  //donut.colorIndexB = ;

  cans.infoX += 100;


  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75f;
  cc[2] = 0.75f;
  cc[5] = 0.3f;
  cc[6] = 0.75f;
  cc[4] = 1;
  cc[8] = 1;
  cc[MASTERFXON] = 0;


  for (int i= 36; i < 52; i++)cc[i] = 0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// COLOR SETUP CHOSE COLOUR VALUES ///////////////////////////////////////////////
int red, pink, yell, grin, bloo, purple, teal, orange, aqua, white, black;
int red1, pink1, yell1, grin1, bloo1, purple1, teal1, aqua1, orange1;
int red2, pink2, yell2, grin2, bloo2, purple2, teal2, aqua2, orange2;
int c, flash;
int act = 0xff07E0D3;
int act1 = 0xff00FC84;
int bac = 0xff370064;
int bac1 = 0xff4D9315;
int slider = 0xffE07F07;
int slider1 = 0xffE0D607;
public void colorSetup() {

  colorMode(HSB, 360, 100, 100);
  white = color(0, 0, 100);
  black = color(0, 0, 0);

  float alt = 0;
  float sat = 100;
  aqua = color(150+alt, sat, 100);
  pink = color(323+alt, sat, 90);
  bloo = color(239+alt, sat, 100);
  yell = color(50+alt, sat, 100);
  grin = color(115+alt, sat, 60);
  orange = color(30+alt, sat, 90);
  purple = color(290+alt, sat, 70);
  teal = color(170+alt, sat, 60);
  red = color(7+alt, sat, 100);
  // colors that aren't affected by color swap
  float sat1 = 100;
  aqua1 = color(190+alt, 80, 100);
  pink1 = color(323-alt, sat1, 90);
  bloo1 = color(239-alt, sat1, 100);
  yell1 = color(50-alt, sat1, 100);
  grin1 = color(160-alt, sat1, 60);
  orange1 = color(34.02f-alt, sat1, 90);
  purple1 = color(290-alt, sat1, 70);
  teal1 = color(170-alt, sat1, 60);
  red1 = color(15-alt, sat1, 100);
  /// alternative colour similar to original for 2 colour blends
  float sat2 = 100;
  alt = +6;
  aqua2 = color(190-alt, 80, 100);
  pink2 = color(323-alt, sat2, 90);
  bloo2 = color(239-alt, sat2, 100);
  yell2 = color(50-alt, sat2, 100);
  grin2 = color(160-alt, sat2, 100);
  orange2 = color(34.02f-alt, sat2, 90);
  purple2 = color(290-alt, sat2, 70);
  teal2 = color(170-alt, sat2, 85);
  red2 = color(15-alt, sat2, 100);
}

abstract class ManualAnim extends Anim {
  ManualAnim(Rig _rig) {
    super(_rig);
    alphaRate = _rig.manualAlpha;
  }
  public void draw() {
  }
  public void drawAnim() {
    super.drawAnim();
    window.beginDraw();
    window.background(0);
    draw();
    window.endDraw();
    image(window, rig.size.x, rig.size.y, window.width, window.height);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
class AllOn extends Anim {
  AllOn(Rig _rig) {
    super( _rig);
    alphaRate=manualSlider;
  }
  public void draw() {
    window.beginDraw();
    window.background(360*alphaA);
    window.endDraw();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class AllOff extends Anim {
  AllOff(Rig _rig) {
    super( _rig);
    alphaRate=manualSlider;
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    window.endDraw();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BenjaminsBoxes extends Anim {
  BenjaminsBoxes (Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = 600;
    high = 1000;

    //stroke *=strokeSlider;
    //wide *=wideSlider;
    //high *=highSlider;

    rotate = 45+(15*noize); //+(functionB*30);
    float xpos = 10+(noize*window.width/4);
    float ypos = viz.y;
    benjaminsBox(xpos, ypos, col1, wide, high, functionA, rotate, alphaA);
    benjaminsBox(xpos, ypos, col1, wide, high, functionA, -rotate, alphaA);

    xpos = vizWidth-10-(noize*window.width/4);
    benjaminsBox(xpos, ypos, col1, wide, high, 1-functionA, rotate, alphaA);
    benjaminsBox(xpos, ypos, col1, wide, high, 1-functionA, -rotate, alphaA);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Anim1 extends Anim { ///////// COME BACK TO THIS WITH NEW ENVELOPES
  Anim1(Rig _rig) {
    super(_rig);
    //functionEnvelopeA = ADSR(1, 1, 2000, 0, 0.3);
    //functionEnvelopeB = ADSR(2000, 1, 1, 0.2, 0);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 10+(30*functionA);
    if (_beatCounter % 8 < 3) rotate = -60*functionA;   /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    else rotate = 60*functionB;                         /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    wide = 10+(functionB*vizWidth);
    high = 110-(functionA*vizHeight);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    star(positionX[2][0].x, positionX[2][0].y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, rotate, alphaA);
    //
    println("functionA / B", functionA, functionB);
    println("wide/high 1", wide, high);

    wide = 10+(functionA*vizWidth);
    high = 110+(functionB*vizHeight);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    println("wide/high 2", wide, high);

    if (_beatCounter % 8 < 3) rotate = 60*functionA;    /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    else rotate = -60*functionB;                        /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    star(positionX[4][0].x, positionX[4][0].y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[2][2].x, positionX[2][2].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Checkers extends Anim {
  Checkers(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 20+(10*strokeSlider);
    rotate = 0;
    if (_beatCounter % 9 <4) { 
      for (int i = 0; i < opcGrid.columns; i+=2) {
        wide = (vizWidth*2)-(vizWidth/10);
        wide = 50+(wide-(wide*functionA)); 
        high = wide;

        //stroke *=strokeSlider;
        wide *=wideSlider;
        high *=highSlider;

        donut(position[i].x, position[i].y, col1, stroke, wide, high, rotate, alphaA);
        donut(position[i+1 % opcGrid.columns+6].x, position[i+1 % opcGrid.columns+6].y, col1, stroke, wide, high, rotate, alphaA);

        wide = (vizWidth/4)-(vizWidth/10);
        wide = (wide-(wide*functionA)); 
        high = wide;

        //stroke *=strokeSlider;
        wide *=wideSlider;
        high *=highSlider;

        donut(position[i+1 % opcGrid.columns].x, position[i+1 % opcGrid.columns].y, col1, stroke, wide, high, rotate, alphaA);
        donut(position[i+6].x, position[i+6].y, col1, stroke, wide, high, rotate, alphaA);
      }
    } else { // opposite way around
      for (int i = 0; i < opcGrid.columns; i+=2) {
        wide  = (vizWidth*2)-(vizWidth/10);
        wide = 50+(wide-(wide*functionA)); 
        high = wide;

        //stroke *=strokeSlider;
        wide *=wideSlider;
        high *=highSlider;

        donut(position[i+1 % opcGrid.columns].x, position[i+1 % opcGrid.columns].y, col1, stroke, wide, high, rotate, alphaB);
        donut(position[i+6].x, position[i+6].y, col1, stroke, wide, high, rotate, alphaB);
        wide = (vizWidth/4)-(vizWidth/10);
        wide = (wide-(wide*functionB)); 
        high = wide;

        //stroke *=strokeSlider;
        wide *=wideSlider;
        high *=highSlider;

        donut(position[i].x, position[i].y, col1, stroke, wide, high, rotate, alphaA);
        donut(position[i+1 % opcGrid.columns+6].x, position[i+1 % opcGrid.columns+6].y, col1, stroke, wide, high, rotate, alphaA);
      }
    }
    window.endDraw();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rings extends Anim {
  /*
  what benjamin would do
   Object wide,stroke,high; in anim main class
   make Processing/Java complain when you try to set wide/high
   so you get an error if you do it wrong
   in draw:
   wide.set(vizWidth*1.2) etc.
   wide.set(wide.get() - (wide.get()*functionA);
   if wide is a Ref, this allows us to later
   anim.wide.mul(wideslider);
   and the internals of the anim subclass don't need to have to remember to * by wideslider every time
   this is sort of what Ref() is for.
   */

  Rings(Rig _rig) {
    super(_rig);
    //animDimmer = animDimmer.mul(0.5);//this one is somehow blinding
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 15+(90*functionA)+(10*strokeSlider);
    wide = vizWidth*1.2f;
    wide = wide-(wide*functionA);
    high = wide*2;
    rotate = 90*noize*functionB;

    wide *=wideSlider;
    high *=highSlider;

    donut(position[2].x, position[2].y, col1, stroke, wide, high, rotate, alphaA);
    donut(position[9].x, position[9].y, col1, stroke, wide, high, rotate, alphaA);
    stroke = 15+(90*functionB*oskP)+(10*strokeSlider);
    wide = vizWidth*1.2f;
    wide = wide-(wide*functionB);
    high = wide*2;
    rotate = -90*noize*functionA;

    wide *=wideSlider;
    high *=highSlider;

    donut(position[3].x, position[3].y, col1, stroke, wide, high, rotate, alphaA);
    donut(position[8].x, position[8].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rush extends Anim {
  Rush (Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = 500+(noize*150);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    if (_beatCounter % 8 < 3) {
      rush(position[0].x, position[3].y, col1, wide, vizHeight/2, functionA, alphaA);
      rush(position[11].x, position[8].y, col1, wide, vizHeight/2, -functionA, alphaA);
    } else {    
      rush(position[0]. x, position[3].y, col1, wide, vizHeight/2, -functionA, alphaA);
      rush(position[11].x, position[8].y, col1, wide, vizHeight/2, functionA, alphaA);
    }
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rushed extends Anim {
  Rushed(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = 150+(noize*600*functionA);
    high = vizHeight/2;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    if (beatCounter % 6 < 4) {
      rush(viz.x, position[3].y, col1, wide, high, functionA, alphaA);
      rush(viz.x, position[3].y, col1, wide, high, -functionB, alphaB);
      rush(viz.x, position[3].y, col1, wide, high, -functionA, alphaA);
      rush(viz.x, position[3].y, col1, wide, high, functionB, alphaB);
      //
      rush(viz.x, position[8].y, col1, wide, high, -functionA, alphaB);
      rush(viz.x, position[8].y, col1, wide, high, functionB, alphaA);
      rush(viz.x, position[8].y, col1, wide, high, functionA, alphaB);
      rush(viz.x, position[8].y, col1, wide, high, -functionB, alphaA);
    } else {
      rush(viz.x, position[3].y, col1, wide, high, functionB, alphaB);
      rush(viz.x, position[3].y, col1, wide, high, -functionA, alphaA);
      rush(viz.x, position[3].y, col1, wide, high, -functionB, alphaB);
      rush(viz.x, position[3].y, col1, wide, high, functionA, alphaA);
      //
      rush(viz.x, position[8].y, col1, wide, high, -functionB, alphaA);
      rush(viz.x, position[8].y, col1, wide, high, functionA, alphaB);
      rush(viz.x, position[8].y, col1, wide, high, functionB, alphaA);
      rush(viz.x, position[8].y, col1, wide, high, -functionA, alphaB);
    }
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SquareNuts extends Anim { 
  SquareNuts(Rig _rig) { 
    super(_rig);
  }                                // maybe add beatcounter flip postion for this
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 300-(200*functionB);
    wide = vizWidth+(50);
    high = wide;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    if (rig == rigg) {
      squareNut(position[1].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(position[4].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
    } else {
      squareNut(window.width/4, window.height/4, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(window.width/4*3, window.height/4*3, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
    }
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class DiagoNuts extends Anim { 
  DiagoNuts(Rig _rig) { 
    super(_rig);
  }                                // maybe add beatcounter flip postion for this
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 100-(400*functionA);
    wide = vizWidth+(50);
    high = wide;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    if (rig == rigg) {
      squareNut(position[1].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
      squareNut(position[4].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
    } else {
      squareNut(window.width/4, window.height/4, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
      squareNut(window.width/4*3, window.height/4*3, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
    }
    window.endDraw();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Stars extends Anim {
  Stars(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = 50+(functionA*vizWidth*1.5f);
    high = 50+(functionB*vizHeight*1.5f);
    stroke = 15+(30*functionA);
    rotate = 30+(30*functionB);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    star(positionX[1][1].x, viz.y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[5][1].x, viz.y, col1, stroke, wide, high, -rotate, alphaA);

    star(viz.x, viz.y, col1, stroke, wide, high, 0, alphaB);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Swipe extends Anim {
  Swipe(Rig _rig) {
    super(_rig);
    //opcGrid.mirrorsOPC(opcMirror1, opcMirror2, 0);               // grids 0-3 MIX IT UPPPPP
  }
  public void draw() {

    window.beginDraw();
    window.background(0);
    wide = 500+(noize*300);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    if   (beatCounter % 3 < 1) rush(position[0].x, viz.y, col1, wide, vizHeight, functionA, alphaA);
    else rush(position[0].x, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Swiped extends Anim {
  Swiped(Rig _rig) {
    super(_rig);
  }
  public void draw() {

    window.beginDraw();
    window.background(0);
    wide = 150+(noize1*500*functionB);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    rush(viz.x, viz.y, col1, wide, vizHeight, functionA, alphaA);
    rush(-vizWidth/2, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Teeth extends Anim {
  Teeth(Rig _rig) {
    super( _rig);
    //functionBEnvelope = new(oskP Envelope); /////////////////////////////////
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    //stroke = 50+(100*functionB);
    stroke = 50+(100*oskP);
    wide = vizWidth+(50);
    wide = wide-(wide*functionA);
    high = wide;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    //squareNut(positionX[0][2].x, positionX[0][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[1][0].x, positionX[1][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[2][2].x, positionX[2][2].y, col1, stroke, wide, high, -45, alphaA);
    //squareNut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[5][0].x, positionX[5][0].y, col1, stroke, wide, high, -45, alphaA);
    //squareNut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, -45, alphaA);

    wide = wide-(wide*functionB);
    high = wide;
    squareNut(positionX[0][2].x, positionX[0][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, -45, alphaA);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Donut extends Anim {
  Donut(Rig _rig) {            // come back to this with new envelopes
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = 10+(vizWidth*(1-functionB));
    high = wide;
    stroke = 2+(vizWidth/2*functionA);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;
    //void donut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Fill extends Anim {
  Fill(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    window.noStroke();

    if (_beatCounter % 9 < 4) window.fill(360*alphaA);
    else window.fill(360*alphaB);
    window.rect(window.width/4, viz.y, window.width/2, window.height);
    //
    if (_beatCounter % 9 < 4) window.fill(360*alphaB);
    else window.fill(360*alphaA);
    window.rect(window.width/4*3, viz.y, window.width/2, window.height);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Avoid extends Anim {
  Avoid(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = -window.width*functionA;
    wide = window.width;
    high = wide;
    squareNut(viz.x, viz.y, col1, stroke, wide, high, 0, 1);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Test extends Anim {
  int atk, sus, dec, atk1, sus1, dec1, str, dur, str_per, end_per;
  float atk_curv, dec_curv, atk_curv1, dec_curv1;
  Test(Rig _rig) {
    super(_rig);
  }
  public void draw() {  
    window.beginDraw();
    window.background(0);
    wide = 100;
    high = vizHeight/2; //*functionB;

    window.fill(360*alphaA);
    window.rect(viz.x, viz.y, 100, 100);
    window.endDraw();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Anim {
  float alphaRate, funcRate, dimmer, alphMod=1, funcMod=1, funcFX=1, alphFX=1, alphaA, alphaB, functionA, functionB;
  int blury, prevblury, vizIndex, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, _beatCounter;
  int col1, col2;
  PVector viz;
  PVector[] position = new PVector[18];
  PVector[][] positionX = new PVector[7][3];  
  PGraphics window, pass1, pass2;
  float alph[] = new float[7];
  float func[] = new float[8];
  boolean deleteme=false;
  String animName;
  Envelope alphaEnvelopeA, alphaEnvelopeB, functionEnvelopeA, functionEnvelopeB;
  Ref animDimmer;
  Rig rig;

  Anim(Rig _rig) {
    animDimmer=new Ref(new float[]{1.0f}, 0);
    rig = _rig;
    alphaRate = rig.alphaRate;
    funcRate = rig.funcRate;
    _beatCounter = (int)beatCounter;
    col1 = white;
    col2 = white;

    //opcGrid.mirrorsOPC(opcMirror1, opcMirror2, 1);               // grids 0-3 MIX IT UPPPPP 


    animName = "default";

    blury = PApplet.parseInt(map(rig.blurValue, 0, 1, 0, 100));     //// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
    if (blury!=prevblury) prevblury=blury;

    window = rig.buffer;
    viz = new PVector(window.width/2, window.height/2);
    vizWidth = PApplet.parseFloat(this.window.width);
    vizHeight = PApplet.parseFloat(this.window.height);

    pass1 = rig.pass1;
    pass2 = rig.pass2;
    position = rig.position; 
    positionX = rig.positionX;

    alphaEnvelopeA = envelopeFactory(rig.availableAlphaEnvelopes[rig.alphaIndexA], rig);
    alphaEnvelopeB = envelopeFactory(rig.availableAlphaEnvelopes[rig.alphaIndexB], rig);
    functionEnvelopeA = functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexA], rig);
    functionEnvelopeB = functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexB], rig);
  }

  public void draw() {
    //Override Me in subclass
    fill(300+(60*stutter));
    textSize(30);
    textAlign(CENTER);
    text("OOPS!!\nCHECK YOUR ANIM LIST", rig.size.x, rig.size.y-15);
  }
  float stroke, wide, high, rotate;
  //Object highobj;
  Float vizWidth, vizHeight;
  public void drawAnim() {
    int now = millis();
    alphaA = alphaEnvelopeA.value(now);
    alphaB = alphaEnvelopeB.value(now);
    alphaA *=rig.dimmer;
    alphaB *=rig.dimmer;          // not sure how to link this yet

    functionA = functionEnvelopeA.value(now); 
    functionB = functionEnvelopeB.value(now);

    if (alphaEnvelopeA.end_time<now && alphaEnvelopeB.end_time<now) deleteme = true;  // only delete when all finished

    this.draw();

    /*
    if (syphonToggle) {
     if (this.rig == rigg) {
     ///// only send the rig animations???!!!???!!! /////
     syphonImageSent.beginDraw();
     syphonImageSent.blendMode(LIGHTEST);
     syphonImageSent.image(pass2, syphonImageSent.width/2, syphonImageSent.height/2, syphonImageSent.width, syphonImageSent.height);
     syphonImageSent.endDraw();
     }
     }
     */
    blurPGraphics();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////

  float sineFast, sineSlow, sine, d, e, stutter;
  float timer[] = new float[6];

  public void alphaFunction() {
    float tm = 0.05f+(noize/50);
    timer[2] += beatSlider;            
    for (int i = 0; i<timer.length; i++) timer[i] += tm;
    timer[3] += (0.3f*5);
    sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
    sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
    sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
    if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
    else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave

    //// array of functions
    func[0] = pulz;       //  
    func[1] = beat;        
    func[2] = pulzSlow; 
    func[3] = (beatSlow*0.99f)+(0.01f*stutter);
    func[4] = (0.99f*pulz)+(stutter*pulz*0.01f);       
    func[5] = (0.99f*beatSlow)+(stutter*pulz*0.01f);
    func[6] = pulzSlow;
    func[7] = beatSlow;

    //// array of alphas
    alph[0] = beat;
    alph[1] = pulz;
    alph[2] = beat+(0.05f*stutter);
    alph[3] =(0.98f*beat)+(stutter*pulz*0.02f);
    alph[4] = (0.98f*pulz)+(beat*0.02f*stutter);
    alph[5] = beatFast;
    alph[6] = pulzSlow;

    for (int i = 0; i < alph.length; i++) alph[i] *=alphMod;
    for (int i = 0; i < func.length; i++) func[i] *=funcMod;
  }
  //////////////////////////////////// BEATS //////////////////////////////////////////////
  float beat, beatSlow, pulz, pulzSlow, pulzFast, beatFast;
  long beatTimer;
  public void trigger() {
    beat = 1;
    beatFast = 1;
    beatSlow = 1;

    //beatCounter = (beatCounter + 1) % 120;
    //weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
    //weightedcnt=1+(1-beatAlpha)*weightedcnt;
    //avgtime=weightedsum/weightedcnt;
    //beatTimer=0;
  }
  public void decay() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
    beatTimer++;
    beatAlpha=0.2f;//this affects how quickly code adapts to tempo changes 0.2 averages
    // the last 10 onsets  0.02 would average the last 100
    if (avgtime>0) beat*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
    else beat*=0.95f;
    if (beat < 0.8f) beat *= 0.98f;
    pulz = 1-beat;                     /// p is opposite of b
    beatFast *=0.7f;                 
    pulzFast = 1-pulzFast;            /// bF is oppiste of pF
    beatSlow -= 0.05f;
    pulzSlow = 1-beatSlow;
    float end = 0.01f;
    if (beat < end) beat = end;
    if (pulzFast > 1) pulzFast = 1;
    if (beatFast < end) beatFast = end;
    if (beatSlow < 0.4f+(noize1*0.2f)) beatSlow = 0.4f+(noize1*0.2f);
    if (pulzSlow > 1) pulzSlow = 1;
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  public void squareNut(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.rect(0, 0, wide, high);
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void donut(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
    try {
      window.strokeWeight(-stroke);
      window.stroke(360*alph);
      window.noFill();
      window.pushMatrix();
      window.translate(xpos, ypos);
      window.rotate(radians(rotate));
      window.ellipse(0, 0, wide, high);
      window.popMatrix();
    }
    catch(Exception e) {
      println(e, "BENJAMIN REALLY NEEDDS TO FIX THIS");
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void star(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.ellipse(0, 0, wide, high);
    window.rotate(radians(120));
    window.ellipse(0, 0, wide, high);
    window.rotate(radians(120));
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void rush(float xpos, float ypos, int col, float wide, float high, float func, float alph) {
    float moveA;
    float strt = xpos;
    moveA = (strt+((window.width)*func));
    window.imageMode(CENTER);
    window.tint(360, 360*alph);
    window.image(bar1, moveA, ypos, wide, high);
    window.noTint();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public float diagonallen(PVector w, float r) {
    r=abs(r)%PI;
    if (r>PI*0.5f) r = PI-r;
    if (r<atan(w.y/w.x)) return w.x/cos(r);
    return w.y/cos(PI*0.5f-r);
  }


  public void benjaminsBox(float xpos, float ypos, int col, float wide, float high, float func, float rotate, float alph) {
    rotate = radians(rotate);

    PVector box = new PVector(window.width, window.height);
    float distance = (-diagonallen(box, rotate)*0.5f)-(diagonallen(box, rotate)*0.5f);
    float moveA = (-(distance/2)+(distance*func))*1.3f;

    window.imageMode(CENTER);
    window.tint(360*alph);
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(rotate);
    window.image(bar1, moveA, 0, wide, high);
    window.noTint();
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void drop(float xpos, float ypos, int col, float wide, float high, float func, float alph) {
    float moveA;
    float strt = window.height-ypos;
    moveA = (strt-((window.height)*func))*1.3f;
    window.imageMode(CENTER);
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(90));
    window.tint(360*alph);
    window.image(bar1, moveA, 0, high, wide);
    window.noTint();
    window.popMatrix();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void blurPGraphics() {
    blur.set("blurSize", blury);
    blur.set("horizontalPass", 0);
    pass1.beginDraw();            
    pass1.shader(blur); 
    pass1.imageMode(CENTER);
    pass1.image(window, pass1.width/2, pass1.height/2, pass1.width, pass1.height);
    pass1.endDraw();
    blur.set("horizontalPass", 1);
    pass2.beginDraw();            
    pass2.shader(blur);  
    pass2.imageMode(CENTER);
    pass2.image(pass1, pass2.width/2, pass2.height/2, pass2.width, pass2.height);
    pass2.endDraw();
    image(pass2, rig.size.x, rig.size.y, window.width, window.height);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public PApplet getparent () {
    try {
      return (PApplet) getClass().getDeclaredField("this$0").get(this);
    }
    catch (ReflectiveOperationException cause) {
      throw new RuntimeException(cause);
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public float getval() {
    try {
      return animDimmer.f[animDimmer.i];
    } 
    catch (Exception e) {
      return 1;
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}



//////////////////////////////////////////////////////////////////
//////////////Composition interface /////////////////////////////
interface Composable {
  public float get();
}
interface Operator {
  public float operate(int time,Object...o);
}

class Mul implements Operator {
  public float operate(int time,Object...o){
    float prod=1.0f;
    for(int i=0;i<o.length;i++){
      prod *= floatValue(o[i],time);
    }
    return prod;
  }
}
class Add implements Operator{
  public float operate(int time,Object...o){
    float sum=0.0f;
    for (int i=0;i<o.length;i++){
      sum += floatValue(o[i],time);
    }
    return sum;
  }
}
class Inv implements Operator{
  public float operate(int time,Object...o){
    return 1.0f/floatValue(o[0],time);
  }
}
class Sin01 implements Operator{
  public float operate(int time, Object...o){
    return 0.5f*(1+sin(floatValue(o[0],time)));
  }
}
///////////////////////helper functions//////////////////////////////
public float floatValue(Object o){
  if (o instanceof Number) return ((Number)o).floatValue();
  if (o instanceof Composable) return ((Composable)o).get();
  throw new RuntimeException("floatValue expected Number,Composable, got "+o.getClass().getCanonicalName());
}
public float floatValue(Object o,Number time){
  if (o instanceof Envelope) return ((Envelope)o).value(time.intValue());
  return floatValue(o);
}

/////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////Reference Class///////////////////////////////////////

class Ref implements Composable{
  float[] f;
  int i;
  Ref(){
    f=new float[]{1.0f};
    i=0;
  }
  Ref(float[] ff,int ii){
    f=ff;
    i=ii;
  }
  Ref(float[] ff){
    f=ff;
    i=0;
  }
  public float get(){
    if (f == null) return 1.0f;
    if (i<0 || i>f.length) return 1.0f;//should raise exception,really
    return f[i];
  }
  public Ref add(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeRef(new Add(),out);
  }
  public Ref mul(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeRef(new Mul(),out);
  }
  public Ref inv(){
    return new CompositeRef(new Inv(),this);
  }
}

class CompositeRef extends Ref{
  Operator op;
  Object[] children;
  CompositeRef(Operator op,Object...o){
    this.op=op;
    this.children=o;
  }
  public float get(){
    return op.operate(millis(),children);
  }
}


///////////////////////////////////////////////////////////////////
////////////////Envelope class/////////////////////////////////////

abstract class Envelope implements Composable{
  int end_time;
  public abstract float value(int time);
  public float get(){
    return value(millis());
  }
  public Envelope add(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeEnvelope(new Add(),out);
  }
  public Envelope mul(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeEnvelope(new Mul(),out);
  }
  public Envelope inv(){
    return new CompositeEnvelope(new Inv(),this);
  }
  public Envelope sin01(){
    return new CompositeEnvelope(new Sin01(),this);
  }
}
class CompositeEnvelope extends Envelope{
  Operator op;
  Object[] children;
  CompositeEnvelope(Operator op,Object...o){
    this.op=op;
    children=o;
    //Envelopes need to keep track of endtimes so Anim knows when they're over
    //we just take the last one
    //infinite envelopes like Sine will have a 0 end_time;
    end_time=-1;
    for(int i=0;i<o.length;i++){
      if (o[i] instanceof Envelope) {
        if (((Envelope)o[i]).end_time > end_time) end_time=((Envelope)o[i]).end_time;
      }
    }
  }
  public float value(int time){
    return op.operate(time,children);
  }
}

//////////////////////////////////////////////////////////
///////////////////interesting stuff below////////////////

// goes from 0 to AMPLITUDE and BACK to 0 over number of MILLIS for cycle
class Sine extends Envelope {
  Object amplitude,period;
  Sine(Object amplitude,Object period){
    this.amplitude=amplitude;
    this.period=period;
  }
  public float value(int time){
    float amp = floatValue(amplitude,time);
    float prd = floatValue(period,time);
    return amp*0.5f*(1+sin(TWO_PI * time / prd));//sinwave from 0 to amplitude
  }
}
class Perlin extends Envelope{
  Object xScale,yScale,zScale;
  Perlin(Object xScale, Object yScale, Object zScale){
    this.xScale=xScale;
    this.yScale=yScale;
    this.zScale=zScale;
  }
  public float value(int time){
    return noise(floatValue(xScale,time), floatValue(yScale,time), floatValue(zScale,time));
  }
}
class Linear extends Envelope{
  Object Scale;
  Linear(Object Scale){
    this.Scale=Scale;
    
  }
  public float value(int time){
    return floatValue(Scale,time)*(float)time;
  }
}



class Ramp extends Envelope {
  int start_time;
  Object[] values;
  Ramp(Number start_time, Number end_time, Object...values) {
    this.start_time=start_time.intValue();
    this.end_time=end_time.intValue();
    this.values=values;
    //assert(values.length>0);
  }
  public float fact(int a) {
    if (a<=1) return 1.0f;
    return a * fact(a-1);
  }
  public float binom(int a, int b) {
    //n!/(k!(n-k)!
    return fact(a)/(fact(b)*(fact(a-b)));
  }

  public float value(int time) {
    /*nim code
     if (time<e.start_time): return e.points[0]
     if (time>e.end_time): return e.points[^1]
     let normt = float(time-e.start_time)/float(e.end_time-e.start_time)
     let n = e.points.len - 1
     for i,p in e.points.pairs:
     result += float(binom(n,i))*(1-normt)^(n-i)*normt^i*p
     */
    if (time<start_time) return floatValue(values[0]);
    if (time>end_time) return floatValue(values[values.length-1]);
    float normt = PApplet.parseFloat(time-start_time)/PApplet.parseFloat(end_time-start_time);
    int n = values.length-1;
    float result=0.0f;
    for (int i=0; i<values.length; i++) {
      result += binom(n, i)*pow(1-normt, n-i)*pow(normt, i)*floatValue(values[i]);
    }
    return result;
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public Envelope SimplePulse(Number attack_time, Number sustain_time, Number decay_time, float attack_curv, float decay_curv) {
  int t=millis();
  // the arguments after DURATION describe a curve - first one is STARTVALUE last one is ENDVALUE - anything inbetween creates the curve ALWAYS EQUALLY SPACED
  //Envelope upramp = new Ramp( STARTTIME , DURATION , STARTVALUE , ** vlaues here create curve ** , FINALVALUE );
  // in this case - during the attack_time and the sustain time the downramp = 1
  // attack curve: 0.5 = STRAIGHT, 0 = SWOOP-UP, 1 = ARC-UP
  Envelope upramp = new Ramp(t, t+attack_time.intValue(), 0.0f, attack_curv, 1.0f);
  Envelope dwnrmp = new Ramp(t+attack_time.intValue()+sustain_time.intValue(), t+attack_time.intValue()+sustain_time.intValue()+decay_time.intValue(), 1.0f, decay_curv, 0.1f);
  return upramp.mul(dwnrmp);
}
// THIS IS A FUNCTION NOT AN ENVELOPE - it RETURNS an ENVELOPE that starts sowly going from 0 TO 1 TO 0 and getting FASTER but still with the same AMPLITUDE
public Envelope SlowFast(int start_time, int duration, int start_period, int end_period) {
  // this ramp is a stright line - starting at START_PERIOD and finishing at END_PERIOD over the DURATION variable
  Envelope period = new Ramp(start_time, start_time+duration, start_period, end_period);
  // passing envelope to SINE as PERIOD
  return new Sine(1.0f, period); //Using an envelope as the parameter
}
// starts OSSCILIATING with the AMPLITUDE slowly RAMPING to 0.4, ADDITIONALLY ramping to 0.6 with the top 0.2 SQUIGGLING
public Envelope Squiggle(Number attack_t, Number sustain_t, Number decay_t, Number total_time, float squiggle_spd, float squiggliness ) {
  Envelope base = CrushPulse(attack_t.floatValue(), sustain_t.floatValue(), decay_t.floatValue(), total_time, 0.02f, 0.02f);
  int sin_start=millis()+attack_t.intValue();
  int sin_duration=sustain_t.intValue()+decay_t.intValue();
  int start_period=sin_duration;
  int end_period = sin_duration/5;
  // squiggle is always 0.4, squigglieness starts after ATTACKTIME and gets squigglier till end of SUSTAINTIME remains SQUIGGLING FOREVER
  //Envelope squiggle = SlowFast(sin_start, sin_duration, start_period, end_period).mul(new Ramp(sin_start, sin_start+sin_duration, 0.0, sqiggle_curv, squiggliness));
  Envelope squiggle = new Sine(1, squiggle_spd*500).mul(new Ramp(sin_start, sin_start+sin_duration, 0.0f, 0.02f, squiggliness)).add(1-squiggliness);
  return base.mul(squiggle);
}
public Envelope SineBySine(float amplitude, int period, float amplitude1, int period1) {
  Envelope firstSine = new Sine(amplitude, period);
  return firstSine.mul(new Sine(amplitude1, period1));
}


public Envelope PullDown(int attack_time, int sustain_time, int decay_time, float attack_curv, float decay_curv, float effect_value) {
  int t=millis();
  //Envelope upramp = new Ramp( STARTTIME , DURATION , STARTVALUE , ** vlaues here create curve ** , FINALVALUE );
  // attack curve: 0.5 = STRAIGHT, 0 = SWOOP-UP, 1 = ARC-UP
  Envelope downramp = new Ramp(t, t+attack_time, 1.0f, attack_curv, effect_value);
  Envelope upramp = new Ramp(t+attack_time+sustain_time, t+attack_time+sustain_time+decay_time, effect_value, attack_curv, 1.0f);
  return downramp.mul(upramp);
}

public Envelope BlackOut(int attack_time, float attack_curv) {
  int t=millis();
  return new Ramp(t, t+attack_time, 1.0f, attack_curv, 0);
}
public Envelope NoizeEnv() {
  Envelope perl = new Perlin(new Linear(0.1f*0.0001f), 0.01f, new Linear(0.0001f));
  return perl.add(-0.4f).mul(10).sin01();
}

//Envelope Beats(Number total_time,float decay_curv){


// return  
//}
// WRITE FUNCTION THAT CRUSHES RATE OF ALL ENVELOPES

public Envelope CrushPulse(float attack_proportion, float sustain_proportion, float decay_proportion, Number total_time, float attack_curv, float decay_curv) {
  if (attack_proportion<0) attack_proportion=0;
  if (sustain_proportion<0) sustain_proportion=0;
  if (decay_proportion<0) decay_proportion=0;
  float total_prop = attack_proportion+sustain_proportion+decay_proportion;
  float attack_time = attack_proportion/total_prop*total_time.floatValue();
  float sustain_time = sustain_proportion/total_prop*total_time.floatValue();
  float decay_time = decay_proportion/total_prop*total_time.floatValue();
  return SimplePulse(attack_time, sustain_time, decay_time, attack_curv, decay_curv);
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public Envelope envelopeFactory(int envelope_index, Rig rig) {
  switch (envelope_index) {
  case 0: 
    // BEATZ
    return CrushPulse(0.031f, 0.040f, 0.913f, avgmillis*rig.alphaRate*15+0.5f, 0.0f, 0.0f);
  case 1:
    // PULZ
    return CrushPulse(0.92f, 0.055f, 0.071f, avgmillis*rig.alphaRate*10+0.5f, 0.0f, 0);
  case 2:
    // BEAT CONROLLED BY PAD
    return CrushPulse(cc[41], cc[42], cc[43], avgmillis*rig.alphaRate*15+0.5f, 0.0f, 0.0f);
  case 3:
    // PULZ CONTROLLED BY PAD
    return CrushPulse(cc[49], cc[50], cc[51], avgmillis*rig.alphaRate*10+0.5f, 0.0f, 0.0f);
  case 4:
    // SQUIGGLE (BEATS) CONTROLLED BY PAD 
    return Squiggle(cc[41], cc[42], cc[43], avgmillis*rig.alphaRate*15+0.5f, 0.01f+cc[44], cc[45]);
  case 5:
    // SQUIGGLE (PULZ) CONTROLLED BY PAD 
    return Squiggle(cc[49], cc[50], cc[51], avgmillis*rig.alphaRate*10+0.5f, 0.01f+cc[52], cc[53]);
  case 6:
    // STUTTER
    return CrushPulse(0.031f, 0.040f, 0.913f, avgmillis*rig.alphaRate*15+0.5f, 0.0f, 0.0f).mul(stutter);
  default: 
    return CrushPulse(0.031f, 0.040f, 0.913f, avgmillis*rig.alphaRate*15+0.5f, 0.02f, 0.02f);
  }
}

public Envelope functionEnvelopeFactory(int envelope_index, Rig rig) {
  switch (envelope_index) {
  case 0: 
    //return SimplePulse(cc[41]*4000, cc[42]*4000, cc[43]*4000, cc[44], cc[45]);
    return CrushPulse(0.031f, 0.040f, 0.913f, avgmillis*rig.funcRate*15+0.5f, 0.02f, 0.02f);
  case 1:
    //return CrushPulse(cc[49], cc[50], cc[51], avgmillis*rig.beatSlider*15+0.5, cc[52], cc[53]);
    return CrushPulse(0.92f, 0.055f, 0.071f, avgmillis*rig.funcRate*15+0.5f, 0.118f, 0);
  case 2:
    return CrushPulse(cc[41], cc[42], cc[43], avgmillis*rig.funcRate*15+0.5f, 0.02f, 0.02f);
  case 3:
    return CrushPulse(cc[44], cc[45], cc[46], avgmillis*rig.funcRate*15+0.5f, 0.02f, 0.02f);
  case 4:
    //Envelope Squiggle(Number attack_t, Number sustain_t, Number decay_t, float attack_curv, float decay_curv, float sqiggle_curv, float squiggliness, int squiggle_spd) {
    return Squiggle(cc[49], cc[50], cc[51], avgmillis*rig.funcRate*15+0.5f, 0.01f+cc[52], cc[53]);
  default: 
    return CrushPulse(0.031f, 0.040f, 0.913f, avgmillis*rig.funcRate*15+0.5f, 0.02f, 0.02f);
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean vizHold, colHold, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
public void keyPressed() {  

  if (key == CODED) {
    //println("keycode", keyCode);
    if (keyCode == 157) {
      println("*** DELETE ALL ANIMS ***");
      for (Rig rig : rigs) {
        for (Anim anim : rig.animations) anim.deleteme = true; // immediately delete all anims
      }
    }
  }

  //// debound or thorttle this ////

  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (key == 'n') rigg.vizIndex = (rigg.vizIndex+1)%rigg.availableAnims.length;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') rigg.vizIndex -=1;                            //// STEP BACK TO PREVIOUS RIG VIZ
  if (rigg.vizIndex <0) rigg.vizIndex = rigg.availableAnims.length-1;
  if (key == 'm') rigg.bgIndex = (rigg.bgIndex+1)%rigg.availableBkgrnds.length;                 //// CYCLE THROUGH RIG BACKGROUNDS
  if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
    rigg.functionIndexA = (rigg.functionIndexA+1)%rigg.availableFunctionEnvelopes.length; //animations.func.length; 
    rigg.functionIndexB = (rigg.functionIndexB+1)%rigg.availableFunctionEnvelopes.length; //fct.length;
  }  
  if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
    rigg.alphaIndexA = (rigg.alphaIndexA+1)% rigg.availableAlphaEnvelopes.length; //alph.length; 
    rigg.alphaIndexB = (rigg.alphaIndexB+1)% rigg.availableAlphaEnvelopes.length; //alph.length;
  }   
  if (key == 'c') rigg.colorIndexA = (rigg.colorIndexA+1)%rigg.col.length; //// CYCLE FORWARD THROUGH RIG COLORS
  if (key == 'v') rigg.colorIndexB = (rigg.colorIndexB+1)%rigg.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////// ROOF KEY FUNCTIONS ///////////////////////////////////////////////////////////////////////////////
  if (key == 'h') roof.vizIndex = (roof.vizIndex+1)%roof.availableAnims.length;               //// STEP FORWARD TO NEXT RIG VIZ
  if (key == 'g') roof.vizIndex -= 1;                          //// STEP BACK TO PREVIOUS RIG VIZ
  if (roof.vizIndex <0) roof.vizIndex = roof.availableAnims.length-1;
  if (key == 'j') roof.bgIndex = (roof.bgIndex+1)%roof.availableBkgrnds.length;               //// CYCLE THROUGH ROOF BACKGROUNDS
  if (key == 'k') {                                      //// CYCLE THROUGH ROOF FUNCS
    roof.functionIndexA = (roof.functionIndexA+1)%roof.availableFunctionEnvelopes.length; 
    roof.functionIndexB = (roof.functionIndexB+1)%roof.availableFunctionEnvelopes.length;
  }  
  if (key == 'l') {                                      //// CYCLE THROUGH ROOF ALPHAS
    roof.alphaIndexA = (roof.alphaIndexA+1)%roof.availableAlphaEnvelopes.length; 
    roof.alphaIndexB = (roof.alphaIndexB+1)%roof.availableAlphaEnvelopes.length;
  }
  if (key == 'd') {
    roof.colorIndexA = (roof.colorIndexA+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  }
  if (key == 'f') {
    roof.colorIndexB = (roof.colorIndexB+1)%cans.col.length;      //// CYCLE BACKWARD THROUGH ROOF COLORS
  }




  //roof.alphaIndexA = rigg.alphaIndexA;
  //roof.alphaIndexB = rigg.alphaIndexB;

  //roof.functionIndexA = roof.functionIndexA;
  //roof.functionIndexA = roof.functionIndexA;

  //roof.c = rigg.c;
  //roof.flash = rigg.flash;


  if (key == '[') vizHold = !vizHold; 
  if (key == ']') colHold = !colHold; 


  if (key=='1') {
    controlFrame.cp5.saveProperties(controlFrameValues);//"cp5values.json");
    sliderFrame.cp5.saveProperties(sliderFrameValues);//"cp5SliderValues.json");
    //this.cp5.saveProperties(mainFrameValues);
    println("** SAVED CONTROLER VALUES **");
    //println("saved to", controlFrameValues, sliderFrameValues);
  } else if (key=='2') {
    try {
      controlFrame.cp5.loadProperties(controlFrameValues);
      sliderFrame.cp5.loadProperties(sliderFrameValues);
      //this.cp5.loadProperties(mainFrameValues);
      println("** LOADED CONTROLER VALUES **");
      //println("loaded from", controlFrameValues, sliderFrameValues);
    }
    catch(Exception e) {
      println(e, "ERROR LOADING CONTROLLER VALUES");
    }
  }



  //  switch(key) {
  //    case('1'):
  //    /* make the ScrollableList behave like a ListBox */
  //    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.LIST);
  //    break;
  //    case('2'):
  //    /* make the ScrollableList behave like a DropdownList */
  //    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.DROPDOWN);
  //    break;
  //    case('3'):
  //    /*change content of the ScrollableList */
  //    List l = Arrays.asList("a-1", "b-1", "c-1", "d-1", "e-1", "f-1", "g-1", "h-1", "i-1", "j-1", "k-1");
  //    cp5.get(ScrollableList.class, "dropdown").setItems(l);
  //    break;
  //    case('4'):
  //    /* remove an item from the ScrollableList */
  //    cp5.get(ScrollableList.class, "dropdown").removeItem("k-1");
  //    break;
  //    case('5'):
  //    /* clear the ScrollableList */
  //    cp5.get(ScrollableList.class, "dropdown").clear();
  //    break;
  //  }

  /////////////////////////////////// momentaory key pressed array /////////////////////////////////////////////////
  for (int i = 32; i <=63; i++)  if (key == PApplet.parseChar(i)) keyP[i]=true;
  for (int i = 91; i <=127; i++) if (key == PApplet.parseChar(i)) keyP[i]=true;
  ///////////////////////////////// toggle key pressed array ///////////////////////////////////////////////////////
  for (int i = 32; i <=63; i++) {
    if (key == PApplet.parseChar(i)) keyT[i] = !keyT[i];
    if (key == PApplet.parseChar(i)) println(key, i, keyT[i]);
  }
  for (int i = 91; i <=127; i++) {
    if (key == PApplet.parseChar(i)) keyT[i] = !keyT[i];
    if (key == PApplet.parseChar(i)) println(key, i, keyT[i]);
  }
}

public void keyReleased()
{
  /// loop to change key[] to false when released to give hold control
  for (int i = 32; i <=63; i++) {
    char n = PApplet.parseChar(i);
    if (key == n) keyP[i]=false;
  }
  for (int i = 91; i <=127; i++) {
    char n = PApplet.parseChar(i);
    if (key == n) keyP[i]=false;
  }
} 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// MIDI FUNCTIONS /////////////////////////////////////////////////////////////////////
float pad[] = new float[128];                //// An array where to store the last value received for each midi Note controller
float padVelocity[] = new float[128];
boolean padPressed[] = new boolean[128];
int midiMap;
public void noteOn( int channel, int pitch, int _velocity) {
  float velocity = map(_velocity, 0, 127, 0, 1);
  pad[pitch] = velocity;
  padPressed[pitch] = true;

  padPressed[pitch] = true;
  padVelocity[pitch] = velocity;

  println();
  println("padVelocity: "+pitch, "Velocity: "+velocity, "Channel: "+channel);
}
public void noteOff(Note note) {
  padPressed[note.pitch] = false;
  padVelocity[note.pitch] = 0;
}
float cc[] = new float[128];                   //// An array where to store the last value received for each CC controller
public void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println("cc[" + number + "]", "Velocity: "+cc[number], "Channel: "+channel);

  String name = "slider "+(number-40);
  try {
    //sliderFrame.cp5.getController(name).setValue(cc[number]);
    sliderFrame.cp5.getController(name).setValue(cc[number]);
  } 
  catch (Exception e) {
    println(e);
    println("*** !!CHECK YOUR MIDI MAPPING!! ***");
    println();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
HashMap<String, int[]> oscAddrToMidiMap = new HashMap<String, int[]>();
public void oscAddrSetup() {

  int startVal = 64;
  OscAddrMap.put("/throttle_box/throttle_button_1", startVal);
  OscAddrMap.put("/throttle_box/throttle_button_2", startVal);
  OscAddrMap.put("/throttle_box/trackball_x", startVal);
  OscAddrMap.put("/throttle_box/trackball_y", startVal);
  OscAddrMap.put("/throttle_box/throttle", startVal);
  OscAddrMap.put("/throttle_box/knob_1", startVal);
  OscAddrMap.put("/throttle_box/knob_2", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/instrument/0/volume", startVal);
  OscAddrMap.put("/instrument/1/volume", startVal);
  OscAddrMap.put("/instrument/2/volume", startVal);
  OscAddrMap.put("/instrument/3/volume", startVal);
  OscAddrMap.put("/instrument/4/volume", startVal);
  OscAddrMap.put("/instrument/5/volume", startVal);
  OscAddrMap.put("/instrument/6/volume", startVal);
  OscAddrMap.put("/instrument/7/volume", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/tune", startVal);
  OscAddrMap.put("/knob_box/1/tune", startVal);
  OscAddrMap.put("/knob_box/2/tune", startVal);
  OscAddrMap.put("/knob_box/3/tune", startVal);
  OscAddrMap.put("/knob_box/4/tune", startVal);
  OscAddrMap.put("/knob_box/5/tune", startVal);
  OscAddrMap.put("/knob_box/6/tune", startVal);
  OscAddrMap.put("/knob_box/7/tune", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/decay", startVal);
  OscAddrMap.put("/knob_box/1/decay", startVal);
  OscAddrMap.put("/knob_box/2/decay", startVal);
  OscAddrMap.put("/knob_box/3/decay", startVal);
  OscAddrMap.put("/knob_box/4/decay", startVal);
  OscAddrMap.put("/knob_box/5/decay", startVal);
  OscAddrMap.put("/knob_box/6/decay", startVal);
  OscAddrMap.put("/knob_box/7/decay", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/ctrl", startVal);
  OscAddrMap.put("/knob_box/1/ctrl", startVal);
  OscAddrMap.put("/knob_box/2/ctrl", startVal);
  OscAddrMap.put("/knob_box/3/ctrl", startVal);
  OscAddrMap.put("/knob_box/4/ctrl", startVal);
  OscAddrMap.put("/knob_box/5/ctrl", startVal);
  OscAddrMap.put("/knob_box/6/ctrl", startVal);
  OscAddrMap.put("/knob_box/7/ctrl", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/joystick_1", 0);
  OscAddrMap.put("/knob_box/joystick_2", 0);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////
}
int oneshotmap, colorselected;
boolean buttonT[] = new boolean [16];
boolean oneshotmessage;
HashMap<String, Integer> OscAddrMap = new HashMap<String, Integer>();
public void oscEvent(OscMessage theOscMessage) {
  //split address into parts
  String addr[]=theOscMessage.addrPattern().split("/");
  String messageType=addr[addr.length-1];
  addr[addr.length-1]="";
  String address=String.join("/", addr);
  int argument = (int)theOscMessage.arguments()[0];

  if ( !(messageType.equals("throttle") || messageType.equals("throttle_button_2"))) {
    print("address = '"+address+"'");
    print(" mesgtype = '"+messageType+"'");
    println(" mesgArgument = "+argument);
  }
  OscAddrMap.put(theOscMessage.addrPattern(), argument);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int TR8CHANNEL = 9;
int BD = 0;
int SD = 1;
int LT = 2;
int MT = 3;
int HT = 4;
int RS = 5;
int HC = 6;
int CH = 7;

int BDTUNE = 20;
int BDDECAY = 23;
int BDLEVEL = 24;
int BDCTRL = 96;
int SDTUNE = 25;
int SDDECAY = 28;
int SDLEVEL = 29;
int SDCTRL = 102;
int LTTUNE = 46;
int LTDECAY = 47;
int LTLEVEL = 48;
int LTCTRL = 102;
int MTTUNE = 49;
int MTDECAY = 50;
int MTLEVEL = 51;
int MTCTRL = 103;
int HTTUNE = 52;
int HTDECAY = 53;
int HTLEVEL = 54;
int HTCTRL = 105;
int RSTUNE = 55;
int RSDECAY = 56;
int RSLEVEL = 57;
int RSCTRL = 105;
int HCTUNE = 58;
int HCDECAY = 59;
int HCLEVEL = 60;
int HCCTRL = 106;
int CHTUNE = 61;
int CHDECAY = 62;
int CHLEVEL = 63;
int CHCTRL = 107;

int DELAYLEVEL = 16;
int DELAYTIME = 17;
int DELAYFEEDBACK = 18;
int MASTERFXON = 15;
int MASTERFXLEVEL = 19;
int REVERBLEVEL = 91;
int NOTE_ON=ShortMessage.NOTE_ON;
int NOTE_OFF=ShortMessage.NOTE_OFF;
int PRGM_CHG=ShortMessage.PROGRAM_CHANGE;
int CTRL_CHG=ShortMessage.CONTROL_CHANGE;
int STOP=ShortMessage.STOP;
int START=ShortMessage.START;
int TIMING=ShortMessage.TIMING_CLOCK;
/*
 * Simple Open Pixel Control client for Processing,
 * designed to sample each LED's color from some point on the canvas.
 *
 * Micah Elizabeth Scott, 2013
 * This file is released into the public domain.
 */




public class OPC implements Runnable
{
  Thread thread;
  Socket socket;
  OutputStream output, pending;
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;
  OPC(){}
  OPC(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    thread = new Thread(this);
    thread.start();
    this.enableShowLocations = true;
    parent.registerMethod("draw", this);

  }

  // Set the location of a single LED
  public void led(int index, int x, int y)  
  {
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }
  
  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip.
  public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0f) * spacing * c + 0.5f),
        (int)(y + (i - (count-1)/2.0f) * spacing * s + 0.5f));
    }
  }

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
  public void ledRing(int index, int count, float x, float y, float radius, float angle)
  {
    for (int i = 0; i < count; i++) {
      float a = angle + i * 2 * PI / count;
      led(index + i, (int)(x - radius * cos(a) + 0.5f),
        (int)(y - radius * sin(a) + 0.5f));
    }
  }

  // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  public void ledGrid(int index, int stripLength, int numStrips, float x, float y,
               float ledSpacing, float stripSpacing, float angle, boolean zigzag)
  {
    float s = sin(angle + HALF_PI);
    float c = cos(angle + HALF_PI);
    for (int i = 0; i < numStrips; i++) {
      ledStrip(index + stripLength * i, stripLength,
        x + (i - (numStrips-1)/2.0f) * stripSpacing * c,
        y + (i - (numStrips-1)/2.0f) * stripSpacing * s, ledSpacing,
        angle, zigzag && (i % 2) == 1);
    }
  }

  // Set the location of 64 LEDs   arranged in a uniform 8x8 grid.
  // (x,y) is the center of the grid.
  public void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag)
  {
    ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag);
  }

  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  public void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }
  
  // Enable or disable dithering. Dithering avoids the "stair-stepping" artifact and increases color
  // resolution by quickly jittering between adjacent 8-bit brightness levels about 400 times a second.
  // Dithering is on by default.
  public void setDithering(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x01;
    else
      firmwareConfig |= 0x01;
    sendFirmwareConfigPacket();
  }

  // Enable or disable frame interpolation. Interpolation automatically blends between consecutive frames
  // in hardware, and it does so with 16-bit per channel resolution. Combined with dithering, this helps make
  // fades very smooth. Interpolation is on by default.
  public void setInterpolation(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x02;
    else
      firmwareConfig |= 0x02;
    sendFirmwareConfigPacket();
  }

  // Put the Fadecandy onboard LED under automatic control. It blinks any time the firmware processes a packet.
  // This is the default configuration for the LED.
  public void statusLedAuto()
  {
    firmwareConfig &= 0x0C;
    sendFirmwareConfigPacket();
  }    

  // Manually turn the Fadecandy onboard LED on or off. This disables automatic LED control.
  public void setStatusLed(boolean on)
  {
    firmwareConfig |= 0x04;   // Manual LED control
    if (on)
      firmwareConfig |= 0x08;
    else
      firmwareConfig &= ~0x08;
    sendFirmwareConfigPacket();
  } 

  // Set the color correction parameters
  public void setColorCorrection(float gamma, float red, float green, float blue)
  {
    colorCorrection = "{ \"gamma\": " + gamma + ", \"whitepoint\": [" + red + "," + green + "," + blue + "]}";
    sendColorCorrectionPacket();
  }
  
  // Set custom color correction parameters from a string
  public void setColorCorrection(String s)
  {
    colorCorrection = s;
    sendColorCorrectionPacket();
  }

  // Send a packet with the current firmware configuration settings
  public void sendFirmwareConfigPacket()
  {
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }
 
    byte[] packet = new byte[9];
    packet[0] = 0;          // Channel (reserved)
    packet[1] = (byte)0xFF; // Command (System Exclusive)
    packet[2] = 0;          // Length high byte
    packet[3] = 5;          // Length low byte
    packet[4] = 0x00;       // System ID high byte
    packet[5] = 0x01;       // System ID low byte
    packet[6] = 0x00;       // Command ID high byte
    packet[7] = 0x02;       // Command ID low byte
    packet[8] = firmwareConfig;

    try {
      pending.write(packet);
    } catch (Exception e) {
      dispose();
    }
  }

  // Send a packet with the current color correction settings
  public void sendColorCorrectionPacket()
  {
    if (colorCorrection == null) {
      // No color correction defined
      return;
    }
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }

    byte[] content = colorCorrection.getBytes();
    int packetLen = content.length + 4;
    byte[] header = new byte[8];
    header[0] = 0;          // Channel (reserved)
    header[1] = (byte)0xFF; // Command (System Exclusive)
    header[2] = (byte)(packetLen >> 8);
    header[3] = (byte)(packetLen & 0xFF);
    header[4] = 0x00;       // System ID high byte
    header[5] = 0x01;       // System ID low byte
    header[6] = 0x00;       // Command ID high byte
    header[7] = 0x01;       // Command ID low byte

    try {
      pending.write(header);
      pending.write(content);
    } catch (Exception e) {
      dispose();
    }
  }

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  public void draw()
  {
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }
    if (output == null) {
      return;
    }

    int numPixels = pixelLocations.length;
    int ledAddress = 4;

    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];

      packetData[ledAddress] = (byte)(pixel >> 16);
      packetData[ledAddress + 1] = (byte)(pixel >> 8);
      packetData[ledAddress + 2] = (byte)pixel;
      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
  }
  
  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  public void setPixelCount(int numPixels)
  {
    int numBytes = 3 * numPixels;
    int packetLen = 4 + numBytes;
    if (packetData == null || packetData.length != packetLen) {
      // Set up our packet buffer
      packetData = new byte[packetLen];
      packetData[0] = 0;  // Channel
      packetData[1] = 0;  // Command (Set pixel colors)
      packetData[2] = (byte)(numBytes >> 8);
      packetData[3] = (byte)(numBytes & 0xFF);
    }
  }
  
  // Directly manipulate a pixel in the output buffer. This isn't needed
  // for pixels that are mapped to the screen.
  public void setPixel(int number, int c)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = (byte) (c >> 16);
    packetData[offset + 1] = (byte) (c >> 8);
    packetData[offset + 2] = (byte) c;
  }
  
  // Read a pixel from the output buffer. If the pixel was mapped to the display,
  // this returns the value we captured on the previous frame.
  public int getPixel(int number)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      return 0;
    }
    return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
  }

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  public void writePixels()
  {
    if (packetData == null || packetData.length == 0) {
      // No pixel buffer
      return;
    }
    if (output == null) {
      return;
    }

    try {
      output.write(packetData);
    } catch (Exception e) {
      dispose();
    }
  }

  public void dispose()
  {
    // Destroy the socket. Called internally when we've disconnected.
    // (Thread continues to run)
    if (output != null) {
      println("Disconnected from OPC server", host);
    }
    socket = null;
    output = pending = null;
  }

  public void run()
  {
    // Thread tests server connection periodically, attempts reconnection.
    // Important for OPC arrays; faster startup, client continues
    // to run smoothly when mobile servers go in and out of range.
    for(;;) {

      if(output == null) { // No OPC connection?
        try {              // Make one!
          socket = new Socket(host, port);
          socket.setTcpNoDelay(true);
          pending = socket.getOutputStream(); // Avoid race condition...
          println("Connected to OPC server", host);
          sendColorCorrectionPacket();        // These write to 'pending'
          sendFirmwareConfigPacket();         // rather than 'output' before
          output = pending;                   // rest of code given access.
          // pending not set null, more config packets are OK!
        } catch (ConnectException e) {
          dispose();
        } catch (IOException e) {
          dispose();
        }
      }

      // Pause thread to avoid massive CPU load
      try {
        thread.sleep(500);
      }
      catch(InterruptedException e) {
      }
    }
  }
}
class OPCGrid {
  PVector[] mirror = new PVector[12];
  PVector[][] mirrorX = new PVector[7][4];
  PVector[] _mirror = new PVector[12];
  PVector[] seeds = new PVector[4];
  PVector[] cansString = new PVector[3];
  PVector[] cans = new PVector[18];
  PVector[] strip = new PVector[6];
  PVector[] controller = new PVector[4];
  PVector booth, dig, smokeFan, smokePump, uv;
  float yTop;                            // height Valuve for top line of mirrors
  float yBottom;  
  float yMid = size.rig.y;   

  Rig rig;

  int pd, ld, dist, controllerGridStep, rows, columns;
  float mirrorAndGap, seedsLength, _seedsLength, seeds2Length, _seeds2Length, cansLength, _cansLength, _mirrorWidth, mirrorWidth, controllerWidth;

  OPCGrid () {
    pd = 6;             // distance between pixels
    ld = 16;            // number of leds per strip
    dist = 16*3;          // distance between mirrors;
    _mirrorWidth = ld*pd;
    mirrorAndGap = (pd*ld)+dist;

    switch (size.orientation) {
    case PORTRAIT:
      yTop = size.rig.y - mirrorAndGap;                              // height Valuve for top line of mirrors
      yBottom = size.rig.y + mirrorAndGap;  
      yMid = size.rig.y;   
      rows = 3;
      columns = 4;
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-(mirrorAndGap*rows/2));
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-(mirrorAndGap/2));                   /// PVECTORS for MIDDLE GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+(mirrorAndGap/2));  /// PVECTORS for BOTTOM GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][3] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+(mirrorAndGap*rows/2));    /// PVECTORS for TOP GAPS 0-6
      // panel 1
      _mirror[0] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[1] = new PVector (size.rig.x-(mirrorAndGap/2), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[2] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[3] = new PVector (size.rig.x-(mirrorAndGap/2), yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[4] = new PVector (size.rig.x-(mirrorAndGap/2), yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[5] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yBottom);                       /// PVECTORS for CENTER of MIRRORS 0-2
      // panel 2
      _mirror[6] =  new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[7] =  new PVector (size.rig.x+(mirrorAndGap/2), yBottom);                    /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[8] =  new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yMid);                   /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[9] =  new PVector (size.rig.x+(mirrorAndGap/2), yMid);                       /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[10] = new PVector (size.rig.x+(mirrorAndGap/2), yTop);                     /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[11] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yTop);                   /// PVECTORS for CENTER of MIRRORS 0-2
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////// PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE /////////////////////////////////////////////////////
      mirror[0] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yTop);                  
      mirror[1] = new PVector (size.rig.x-(mirrorAndGap/2), yTop);                  
      mirror[2] = new PVector (size.rig.x+(mirrorAndGap/2), yTop);                  
      mirror[3] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yTop);                 
      mirror[4] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yMid);                   
      mirror[5] = new PVector (size.rig.x-(mirrorAndGap/2), yMid);                
      mirror[6] = new PVector (size.rig.x+(mirrorAndGap/2), yMid);                  
      mirror[7] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yMid);                    
      mirror[8] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yBottom);                  
      mirror[9] = new PVector (size.rig.x-(mirrorAndGap/2), yBottom);                 
      mirror[10]= new PVector (size.rig.x+(mirrorAndGap/2), yBottom);                  
      mirror[11]= new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yBottom); 
      break;
    case LANDSCAPE: 
      yTop = size.rig.y - (mirrorAndGap/2);                              // height Valuve for top line of mirrors
      yBottom = size.rig.y + (mirrorAndGap/2);  
      rows = 2;
      columns = 6;
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-mirrorAndGap);    /// PVECTORS for TOP GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y);                   /// PVECTORS for MIDDLE GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+mirrorAndGap);    /// PVECTORS for BOTTOM GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][3] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y);    /// PVECTORS for TOP GAPS 0-6
      // panel 1
      _mirror[0] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[1] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[2] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[3] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[4] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[5] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      // panel 2
      _mirror[6] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[7] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[8] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[9] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[10] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[11] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////// PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE /////////////////////////////////////////////////////
      mirror[0] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yTop);                  
      mirror[1] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yTop);                  
      mirror[2] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yTop);                  
      mirror[3] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yTop);                
      mirror[4] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yTop);                   
      mirror[5] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yTop);                
      mirror[6] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yBottom);                   
      mirror[7] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yBottom);                   
      mirror[8] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yBottom);                  
      mirror[9] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yBottom);                 
      mirror[10]= new PVector (size.rig.x+(mirrorAndGap*1.5f), yBottom);                  
      mirror[11]= new PVector (size.rig.x+(mirrorAndGap*2.5f), yBottom);
      break;
    }
    mirrorWidth = _mirrorWidth+16;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// MIRRORS //////////////////////////////////////////////
  public void mirrorsOPC(OPC opc, OPC opc1, int gridStep) {
    int fc = 3*512;
    switch (size.orientation) {  
    case PORTRAIT:
      switch(gridStep) {
      case 0:
        for (int i = 0; i < 6; i++) {       /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc.ledStrip(fc+(64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
          opc.ledStrip(fc+(64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
          opc.ledStrip(fc+(64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip(fc+(64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
        }
        for (int i = 6; i < 12; i++) {       /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
        }
        break;
      case 1:
        for (int i = 0; i < 6; i++) opc.ledStrip(fc+(64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8f, 0, true);                 
        for (int i = 6; i < 12; i++) opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8f, 0, false);
        break;
      case 2:
        for (int i = 0; i < 6; i++) opc.ledStrip(fc+(64*(5-i))+(ld*0), ld*4, size.rig.x-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6f)), size.rig.y, size.rigHeight/64, PI/2, true);                 
        for (int i = 6; i < 12; i++) opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld*4, size.rig.x-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6f)), size.rig.y, size.rigHeight/64, PI/2, false);
        break;
      default:
        for (int i = 0; i < 6; i++) {       /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc.ledStrip(fc+(64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
          opc.ledStrip(fc+(64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
          opc.ledStrip(fc+(64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip(fc+(64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
        }
        for (int i = 6; i < 12; i++) {       /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
        }
        break;
      }
      break;
    case LANDSCAPE:
      switch(gridStep) {
      case 0:    /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 0; i < 6; i++) {
          opc.ledStrip(fc+(64*(5-i))+(ld*0), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);                 // TOP horizontal strip 
          opc.ledStrip(fc+(64*(5-i))+(ld*1), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip(fc+(64*(5-i))+(ld*2), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
          opc.ledStrip(fc+(64*(5-i))+(ld*3), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
        }
        /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 6; i < 12; i++) {
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip 
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*1), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip       
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*2), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*3), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
        }
        break;
      case 1:    /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
        _mirror[6] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[7] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[8] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[9] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[10] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[11] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
        // panel 2
        _mirror[0] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[1] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[2] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[3] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[4] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
        _mirror[5] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
        for (int i = 0; i < 6; i++) {
          opc.ledStrip(fc+(64*(5-i))+(ld*0), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);                 // TOP horizontal strip 
          opc.ledStrip(fc+(64*(5-i))+(ld*1), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip(fc+(64*(5-i))+(ld*2), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
          opc.ledStrip(fc+(64*(5-i))+(ld*3), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
        }
        /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 6; i < 12; i++) {
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip 
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*1), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip       
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*2), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(fc+512+(64*(i-6))+(ld*3), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
        }
        break;
      case 2:
        for (int i = 0; i < 6; i++) opc.ledStrip(fc+(64*(5-i))+(ld*0), ld*4, _mirror[2].x, 50+((size.rigHeight-55)/6*i), pd/1.2f, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld*4, _mirror[8].x, 50+((size.rigHeight-55)/6*(i-6)), pd/1.2f, 0, true);                 // TOP horizontal strip
        break;
      case 3:
        for (int i = 0; i < 6; i++) opc.ledStrip(fc+(64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.6f, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.6f, 0, true);
        break;
      case 4:
        for (int i = 0; i < 6; i++) opc.ledStrip(fc+(64*(5-i))+(ld*0), ld*4, size.rig.x, 48+((size.rigHeight-55)/12*i), pd*1.8f, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(fc+512+(64*(i-6))+(ld*0), ld*4, size.rig.x, 52+((size.rigHeight-55)/12*(i)), pd*1.8f, 0, true);                 // TOP horizontal strip
        break;
      }
      break;
    }
    rigg.position=opcGrid.mirror;
    rigg.positionX=opcGrid.mirrorX;
  }
  ////////////////////////////////////// MIRROR TEST ///////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void mirrorTest(boolean toggle, int mirrorStep) {
    /////////////////////////// TESTING MIRROR ORENTATION //////////////////
    if (toggle) {
      fill(0);
      rect(mirror[mirrorStep].x+(mirrorWidth/2), mirror[mirrorStep].y+(mirrorWidth/4), 3, mirrorWidth/2);
      rect(mirror[mirrorStep].x-(mirrorWidth/2), mirror[mirrorStep].y-(mirrorWidth/4), 3, mirrorWidth/2);
      fill(200);
      rect(mirror[mirrorStep].x+(mirrorWidth/4), mirror[mirrorStep].y+(mirrorWidth/2), mirrorWidth/2, 3);
      rect(mirror[mirrorStep].x-(mirrorWidth/4), mirror[mirrorStep].y-(mirrorWidth/2), mirrorWidth/2, 3);
      println("TESTING: "+mirrorStep);
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////// RADIATORS ////////////////////////////////////////////////////////////////////////////////
  PVector [] rad = new PVector[12];
  public void radiatorsOPC(Rig _rig, OPC opc, OPC opc1) {
    rig = _rig;

    int xpos = PApplet.parseInt(rig.size.x-(rig.wide/4));
    int _xpos = xpos;
    int ypos = PApplet.parseInt(rig.size.y);

    ///////////////////// LEFT RADIATOR - FC 5
    // 6 SQAURES
    int fc = 7 * 512;                       // fadecandy number (first one used is 0)
    int strips = 6;
    int gap = PApplet.parseInt(rig.wide/20);         // X distance between strips
    int pixelDist = PApplet.parseInt(rig.high/70);                      // Y distance between pixels
    for (int i = 0; i < strips; i++) {
      _xpos = PApplet.parseInt(xpos+((i-(strips/2))*gap+(gap/2)));
      opc.ledStrip(fc+(i*64), 64, _xpos, ypos, pixelDist, (PI/2), false);
      rad[i] = new PVector (_xpos, ypos);      // PVectors for center of each strip in 2D array - LEFT chandelear is ZERO
    } 

    _xpos = PApplet.parseInt(xpos+((0-(strips/2))*gap+(gap/2)));

    int vertPixels = 40;

    //FRAME Section 1 - ch.6
    int channel = 6;                   // channel leds are soldered to on the FadeCandy
    int strt = 64*channel+fc;         // starting pixel number for channel
    int leds = 20;
    pixelDist = PApplet.parseInt(pixelDist*1.8f); //(pixelDist*64+gap)/leds;
    int frameXpos = _xpos - gap;
    int frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //left 1/2 middle to top
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);
    frameYpos = PApplet.parseInt(ypos-(vertPixels/2*pixelDist)-(pixelDist/2));
    int _pixelDist = PApplet.parseInt((gap*(strips+1.5f)/leds)); 
    //top whole left to right
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(180), true); //RICH - WILL 180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //top right side 1/2 right to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); //RICH - WILL -90 MAKE THE PIXEL ORDER GO FROM TOP TO BOTTOM?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //FRAME Section 2 - ch.7
    channel = 7;                   // channel leds are soldered to on the FadeCandy
    strt = 64*channel+fc;         // starting pixel number for channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //right vertical 1/2 middle to bottom
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); 
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);  //// come back to this
    frameYpos = PApplet.parseInt(ypos+(vertPixels/2*pixelDist)+(pixelDist/2));
    //bottom whole right to left
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(-180), false); //RICH - WILL -180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos - gap;
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //bottom left to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////// RIGHT RADIATOR - FC 6
    fc =  fc + 512; 
    opc = opc1;
    pixelDist = PApplet.parseInt(rig.high/70);                          // Y distance between pixels
    xpos = PApplet.parseInt(rig.size.x+(rig.wide/4));

    for (int i = 0; i < strips; i++) {
      _xpos = PApplet.parseInt(xpos+((i-(strips/2))*gap+(gap/2)));
      opc.ledStrip(fc+(i*64), 64, _xpos, ypos, pixelDist, (PI/2), false);
      rad[i+strips] = new PVector (_xpos, ypos);      // PVectors for center of each strip in 2D array - LEFT chandelear is ZERO
    }

    _xpos = PApplet.parseInt(xpos+((0-(strips/2))*gap+(gap/2)));

    //FRAME Section 1 - ch.6
    channel = 6;                   // channel leds are soldered to on the FadeCandy
    strt = 64*channel+fc;         // starting pixel number for channel
    leds = 20;
    pixelDist = PApplet.parseInt(pixelDist*1.8f);
    frameXpos = _xpos - gap;
    frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //left 1/2 middle to top
    opc1.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);
    frameYpos = PApplet.parseInt(ypos-(vertPixels/2*pixelDist)-(pixelDist/2));
    //top whole left to right
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(180), true); //RICH - WILL 180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //top right side 1/2 right to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); //RICH - WILL -90 MAKE THE PIXEL ORDER GO FROM TOP TO BOTTOM?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //FRAME Section 2 - ch.7
    channel = 7;                   // channel leds are soldered to on the FadeCandy
    strt = 64*channel+fc;         // starting pixel number for channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //right vertical 1/2 middle to bottom
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); 
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);  //// come back to this
    frameYpos = PApplet.parseInt(ypos+(vertPixels/2*pixelDist)+(pixelDist/2));
    //bottom whole right to left
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(-180), false); //RICH - WILL -180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos - gap;
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //bottom left to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////  set ROOF position to RAD positions
    for (int i = 0; i < rig.position.length; i++) {
      rig.position[i].x=opcGrid.rad[i].x-(rig.size.x-(rig.wide/2));
      rig.position[i].y=opcGrid.rad[i].y-(rig.size.y-(rig.high/2));
    }
    //int l = rig.position.length;
    //for (int i = 1; i < rig.position.length; i+=2) {
    //  rig.position[(i+1)%l].x=opcGrid.rad[(i+1)%l].x-(rig.size.x-(rig.wide/2));
    //  rig.position[(i+1)%l].y=opcGrid.rad[(i+1)%l].y-(rig.size.y-(rig.high/2));
    //}
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////// DONUT OPC GRID //////////////////////////////////////////////////////////////////////////////////////////
  float bigCircleRadius, ringSize, smallCircleRadius;
  PVector[] smallCircle = new PVector[12];
  public void donutOPC(Rig _rig, OPC opc) {
    rig = _rig;
    int xpos = PApplet.parseInt(rig.size.x);
    int ypos = PApplet.parseInt(rig.size.y);
    //// I use the following code to make it very easy to add or change strips without having to do all the maths
    int fc = 8 * 512;                       // fadecandy number (first one used is 0)
    int numberOfCirlces = 12;

    ///////////////////////////////////////// CIRCLES - all pixels start at bottom and go anticlockwise ///////////////////////////////////////////
    // big center cirlce
    int channel = 6;                   // channel leds are soldered to on the FadeCandy
    bigCircleRadius = rig.high/6;         // size of the BIG CENTER circle
    int strt = 64*channel+fc;         // starting pixel number for cicle
    int leds = 64;                 // number of pixels in the first circle
    for (int i=strt; i < strt+leds; i++) opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*bigCircleRadius)+xpos, (PApplet.parseInt(cos(radians((i-strt)*360/leds))*bigCircleRadius)+ypos));

    // function to create PVectors for all the small cirlce centers
    ringSize = rig.high/2.5f;
    for (int i = 0; i < smallCircle.length; i++) {    
      float xposition = PApplet.parseInt(sin(radians((i-0.5f)*360/numberOfCirlces))*ringSize)+xpos;
      float yposition = PApplet.parseInt(cos(radians((i-0.5f)*360/numberOfCirlces))*ringSize)+ypos;
      /////// PVECTOR produces center of circle
      smallCircle[i] = new PVector (xposition, yposition);
    }

    //////////////////// SMALL CIRCLES //////////////
    fc = fc + 512;
    leds = 32;
    smallCircleRadius = 32;
    channel = 0;               // starting channel on fadecandy for cirlces 
    // loop to loop below loop for all 6 channels on ring
    for (int o = 0; o < numberOfCirlces/2; o++) { 
      strt = o*64+(channel*64) + fc;
      // loop to create 2 small circle of pixels, first one starts at index 0 / 2nd one starts at index 32
      for (int i=strt; i < strt+leds; i++) {     
        opc.led(i, PApplet.parseInt((sin(radians((i-strt)*360/leds))*smallCircleRadius)+smallCircle[o*2].x), (PApplet.parseInt((cos(radians((i-strt)*360/leds))*smallCircleRadius)+smallCircle[o*2].y)));
        opc.led(i+leds, PApplet.parseInt((sin(radians((i-strt)*360/leds))*smallCircleRadius)+smallCircle[o*2+1].x), (PApplet.parseInt((cos(radians((i-strt)*360/leds))*smallCircleRadius)+smallCircle[o*2+1].y)));
      }
    }

    bigCircleRadius += 2;        // increase size of the BIG CENTER circle so when you use this value in the code it is covered
    //**** ellipse(mm, hh, bigCircleRadius, bigCircleRadius);
    smallCircleRadius +=2;  // increase size of the SMALL CIRCLES so when you use this value in the code it is covered eg *** 
    //**** ellipse(smallCircle[4].x, smallCircle[4].y, smallCircleRadius, smallCircleRadius);

    ////  set CANS position to circle positions
    for (int i = 0; i < rig.position.length; i++) {
      rig.position[i].x=opcGrid.smallCircle[i].x-(rig.size.x-(rig.wide/2));
      rig.position[i].y=opcGrid.smallCircle[i].y-(rig.size.y-(rig.high/2));
      //
      //rig.position[i+6].x=opcGrid.cat[i+12].x-(rig.size.x-(rig.wide/2));
      //rig.position[i+6].y=opcGrid.cat[i+12].y-(rig.size.y-(rig.high/2));
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// SEEDS ///////////////////////////////////////////////
  public void tawSeedsOPC(Rig _rig, OPC opc, OPC opc1) {
    rig = _rig;

    ////////////////////////////////// ROOF POSISTIONS FOR GRID ////////////////////////////////////////////////////
    _seedsLength = rig.wide/2;
    _seeds2Length = rig.wide/2;
    //seeds[0] = new PVector (rig.size.x, rig.size.y-(rig.high/2)+(rig.high/5)); 
    //seeds[1] = new PVector (rig.size.x, rig.size.y-(rig.high/2)+(rig.high/5*2)); 
    //seeds[2] = new PVector (rig.size.x, rig.size.y-(rig.high/2)+(rig.high/5*3));
    //seeds[3] = new PVector (rig.size.x, rig.size.y-(rig.high/2)+(rig.high/5*4));

    seeds[0] = new PVector (rig.size.x-(rig.wide/4), rig.size.y-(rig.high/4)); 
    seeds[1] = new PVector (rig.size.x+(rig.wide/4), rig.size.y-(rig.high/4));
    seeds[2] = new PVector (rig.size.x-(rig.wide/4), rig.size.y+(rig.high/4));
    seeds[3] = new PVector (rig.size.x+(rig.wide/4), rig.size.y+(rig.high/4));

    println("seeeds PVector");
    print(seeds);

    int xpos = PApplet.parseInt(rig.size.x-(rig.wide/4));
    int _xpos = xpos;
    int ypos = PApplet.parseInt(rig.size.y);


    int fc = 5 * 512;                 // fadecandy number (first one used is 0)
    int channel = 0;                  // pair of holes on fadecandy board
    int strt = 64*channel+fc;         // starting pixel index
    int leds = 64;                    // leds in strip
    int seedLeds = 110;               // leds per seed
    int pd = PApplet.parseInt(_seedsLength/seedLeds); //int(size.roofWidth/seedLeds*1.49);

    ///////////////////////////////////// SEED 1 ///////////////////////////////////////////////
    opc.ledStrip(strt, leds, PApplet.parseInt(seeds[0].x-(seedLeds/2*pd-(leds/2*pd))), PApplet.parseInt(seeds[0].y), pd, 0, false);     
    strt = strt+leds;               //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seeds[0].x+(seedLeds/2*pd-(leds/2*pd)), seeds[0].y, pd, 0, true);

    ///////////////////////////////////// SEED 2 //////////////////////////////////////////////
    channel = 2;
    strt = 64*channel+fc;             // starting pixel number for cicle
    leds = 64;      
    opc.ledStrip(strt, leds, seeds[1].x-(seedLeds/2*pd-(leds/2*pd)), seeds[1].y, pd, 0, false);             
    strt = strt+leds;                 //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seeds[1].x+(seedLeds/2*pd-(leds/2*pd)), seeds[1].y, pd, 0, true);

    ///////////////////////////////////// SEED 3 //////////////////////////////////////////////
    fc = fc + 512;  // next fade candy - only 2 seeds per box
    opc = opc1;     // different box with differnt IP controlling 2nd pair of seeds
    channel = 0;
    strt = 64*channel+fc;         
    leds = 64;    

    opc.ledStrip(strt, leds, seeds[2].x-(seedLeds/2*pd-(leds/2*pd)), seeds[2].y, pd, 0, false);     
    strt = strt+leds;               //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seeds[2].x+(seedLeds/2*pd-(leds/2*pd)), seeds[2].y, pd, 0, true);

    ///////////////////////////////////// SEED 4 //////////////////////////////////////////////
    channel = 2;
    strt = 64*channel+fc;             // starting pixel number for cicle
    leds = 64;      
    opc1.ledStrip(strt, leds, seeds[3].x-(seedLeds/2*pd-(leds/2*pd)), seeds[3].y, pd, 0, false);             
    strt = strt+leds;                 //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seeds[3].x+(seedLeds/2*pd-(leds/2*pd)), seeds[3].y, pd, 0, true);

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    seedsLength = _seedsLength + (pd/2);
    seeds2Length = _seeds2Length + (pd/2);
  }














  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// CANS //////////////////////////////////////////////////
  public void individualCansOPC(Rig _rig, OPC opc, boolean offset) {
    rig = _rig;
    float xw = 6;
    float y = rig.size.y;
    if (offset) y = rig.size.y - rig.high/(xw+1)/(xw/2);

    for (int i=0; i<cans.length/xw; i++) cans[i] =     new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*1);
    for (int i=0; i<cans.length/xw; i++) cans[i+3] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*2);
    for (int i=0; i<cans.length/xw; i++) cans[i+6] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*3);
    for (int i=0; i<cans.length/xw; i++) cans[i+9] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*4);
    for (int i=0; i<cans.length/xw; i++) cans[i+12] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*5);
    for (int i=0; i<cans.length/xw; i++) cans[i+15] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*6);

    if (offset) {
      cans[1].y = y-(rig.high/2)+rig.high/(xw+1)*(1.5f);
      cans[4].y = y-(rig.high/2)+rig.high/(xw+1)*(2.5f);
      cans[7].y = y-(rig.high/2)+rig.high/(xw+1)*(3.5f);
      cans[10].y = y-(rig.high/2)+rig.high/(xw+1)*(4.5f);
      cans[13].y = y-(rig.high/2)+rig.high/(xw+1)*(5.5f);
      cans[16].y = y-(rig.high/2)+rig.high/(xw+1)*(6.5f);
    }


    int fc = 9 * 512;
    int channel = 64;
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*0+i), PApplet.parseInt(cans[i].x), PApplet.parseInt(cans[i].y));                   
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*1+i), PApplet.parseInt(cans[i+6].x), PApplet.parseInt(cans[i+6].y));                  
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*2+i), PApplet.parseInt(cans[i+12].x), PApplet.parseInt(cans[i+12].y));                  

    ////  set roof position to individual cans positions
    for (int i = 0; i < rig.position.length/2; i++) {
      rig.position[i].x=opcGrid.cans[i].x-(rig.size.x-(rig.wide/2));
      rig.position[i].y=opcGrid.cans[i].y-(rig.size.y-(rig.high/2));
      //
      rig.position[i+6].x=opcGrid.cans[i+12].x-(rig.size.x-(rig.wide/2));
      rig.position[i+6].y=opcGrid.cans[i+12].y-(rig.size.y-(rig.high/2));
    }
    rig.position[4].x=cans[7].x-(rig.size.x-(rig.wide/2));
    rig.position[4].y=cans[7].y-(rig.size.y-(rig.high/2));

    rig.position[7].x=cans[10].x-(rig.size.x-(rig.wide/2));
    rig.position[7].y=cans[10].y-(rig.size.y-(rig.high/2));
  }
  public void kallidaCansOPC(OPC opc) {
    int fc = 5 * 512;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, PApplet.parseInt(cansString[0].x), PApplet.parseInt(cansString[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1)+(64*channel), leds, PApplet.parseInt(cansString[1].x), PApplet.parseInt(cansString[1].y), pd, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX ///////
    cansLength = _cansLength - (pd/2);
  } /////////////////////////////////////////////////////////////////////////////////////////////////////
  public void pickleCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    _cansLength = size.cansWidth;
    cansString[0] = new PVector(rig.size.x, rig.size.y-(rig.high/4));
    cansString[1] = new PVector(rig.size.x, rig.size.y);
    cansString[2] = new PVector(rig.size.x, rig.size.y+(rig.high/4));

    int fc = 2 * 512;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);
    opc.ledStrip(fc+(channel*5), leds, PApplet.parseInt(cansString[0].x), PApplet.parseInt(cansString[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*6), leds, PApplet.parseInt(cansString[1].x), PApplet.parseInt(cansString[1].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*7), leds, PApplet.parseInt(cansString[2].x), PApplet.parseInt(cansString[2].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 

    cansLength = _cansLength - (pd/2);
  } /////////////////////////////////////////////////////////////////////////////////////////////////////
  public void kingsHeadCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    _cansLength = size.cansWidth;
    cansString[0] = new PVector(rig.size.x, rig.size.y-(rig.high/4));
    cansString[1] = new PVector(rig.size.x, rig.size.y);
    cansString[2] = new PVector(rig.size.x, rig.size.y+(rig.high/4));

    int fc = 0 * 512;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, PApplet.parseInt(cansString[0].x), PApplet.parseInt(cansString[0].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1), leds, PApplet.parseInt(cansString[1].x), PApplet.parseInt(cansString[1].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*2), leds, PApplet.parseInt(cansString[2].x), PApplet.parseInt(cansString[2].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    cansLength = _cansLength - (pd/2);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// UV /////////////////////////////////////////////////////
  public void kallidaUV(OPC opc) {
    int fc = 2 * 512;
    int channel = 64;                 
    opc.led(fc+(channel*7), PApplet.parseInt(uv.x), PApplet.parseInt(uv.y));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////// STRIP ///////////////////////////////////////////////////////////////
  public void kingsHeadStripOPC(Rig _rig, OPC opc) {
    rig = _rig;
    int fc = 3 * 512;
    int channel = 64;
    int leds = 64;
    int pd = rig.wide/2/leds;
    for (int i = 0; i < 3; i++) strip[i] = new PVector (rig.size.x-(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));
    for (int i = 0; i < 3; i++) strip[i+3] = new PVector (rig.size.x+(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));

    for (int i=0; i<6; i++)  opc.ledStrip(fc+(channel), leds, PApplet.parseInt(strip[i].x), PApplet.parseInt(strip[i].y), pd, 0, true);
  }

  public void espTestOPC(Rig _rig, OPC opc) {
    rig = _rig;
    int fc = 0 * 512;
    int channel = 64;
    int leds = 120;
    int pd = rig.wide/2/leds;
    for (int i = 0; i < 3; i++) strip[i] = new PVector (rig.size.x-(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));
    for (int i = 0; i < 3; i++) strip[i+3] = new PVector (rig.size.x+(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));

    for (int i=0; i<1; i++) opc.ledStrip(fc+(channel*i), leds, PApplet.parseInt(strip[i].x), PApplet.parseInt(strip[i].y), 2, 0, true);
  }

  ////////////////////////////////////// BOOTH LIGHTS ///////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void standAloneBoothOPC(OPC opc) {
    booth = new PVector (104, 15);
    dig = new PVector (booth.x+110, booth.y);

    int fc = 10 * 512;
    int channel = 64;       

    opc.led(fc+(channel*1), PApplet.parseInt(booth.x-5), PApplet.parseInt(booth.y));

    opc.led(fc+(channel*2), PApplet.parseInt(dig.x-5), PApplet.parseInt(dig.y));
    opc.led(fc+(channel*3), PApplet.parseInt(dig.x+5), PApplet.parseInt(dig.y));
  }

  public void kingsHeadBoothOPC(OPC opc) {
    int fc = 4 * 512;
    int channel = 64;       

    opc.led(fc+(channel*3), PApplet.parseInt(dig.x-5), PApplet.parseInt(dig.y));
    opc.led(fc+(channel*2), PApplet.parseInt(dig.x+5), PApplet.parseInt(dig.y));

    opc.led(fc+(channel*1), PApplet.parseInt(booth.x-5), PApplet.parseInt(booth.y));
  }
  ////////////////////////////////// DMX  /////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void dmxParsOPC(OPC opc) {
    for (int i = 0; i < 12; i+=2) opc.led(6048+i, PApplet.parseInt(pars.size.x), PApplet.parseInt(pars.size.y-(pars.high/2)+100+(i*40)));
  } 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void dmxSmokeOPC(OPC opc) {
    smokePump = new PVector (304, 15);
    smokeFan = new PVector (smokePump.x+140, 15);

    opc.led(7000, PApplet.parseInt(smokePump.x), PApplet.parseInt(smokePump.y));
    opc.led(7001, PApplet.parseInt(smokeFan.x), PApplet.parseInt(smokeFan.y));
  } 

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//possible helper class
//class GridCoords{
//int arg1
//int arg2
//float arg3
//int xpos
//int ypos
//int pd.
// etc....
//GridCoords(_arg1,_arg2...){
//init all of them
//}
//}
//then use it like a c struct sorry if that doesn't make it make mor sense
//gridargs=new GridCoords(foo,bar,baz);
//opc.ledStrip(gridargs);
//gridargs.arg1=foo2;
//opc.ledStrip(gridargs);
float[] lastTime = new float[cc.length];

public void playWithMe() {




  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) rigg.colorSwap(0.9999999999f);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) rigg.colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) rigg.colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  if (keyT['y']) {
    colorLerping(rigg, (1-beat)*2);
    colorLerping(roof, (1-beat)*1.5f);
  }
  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) vizTimer = millis()/1000;              // hold viz change timer
  if (colHold) {
    rigg.colorTimer = millis()/1000;              // hold color change timer
    roof.colorTimer = millis()/1000;              // hold color change timer
    cans.colorTimer = millis()/1000;              // hold color change timer
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyP[' ']) { 
    for (Rig rig : rigs) {
      if (rig.toggle) {
        beatTrigger = true;
        //if (testToggle) rig.animations.add(new Test(rig));
        rig.addAnim(rig.vizIndex);
      }
    }
  } 
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  float  debouncetime=100;

  Envelope manualA = CrushPulse(0.0f, 0, 1, manualSlider*500, 0.0f, 0.0f);
  /*
  try {
   if (millis()-lastTime[44]>debouncetime) {
   if (padVelocity[44]>0) rigg.animations.add(new Checkers (rigg));
   //if (rigg.animations.size() > 0 ) { 
   Anim theanim = rigg.animations.get(rigg.animations.size()-1);
   theanim.alphaEnvelopeA = manualA;
   theanim.alphaEnvelopeB = manualA;
   lastTime[44]=millis();
   //}
   }
   } 
   catch (Exception e) {
   println(e, "playwithyourself error");
   }
   */

  if (millis()-lastTime[44]>debouncetime) {
    if (padVelocity[44]>0) rigg.animations.add(new Checkers (rigg));
    lastTime[44]=millis();
  }

  if (millis()-lastTime[45]>debouncetime) {
    if (padVelocity[45]>0) rigg.animations.add(new DiagoNuts(rigg));
    lastTime[45]=millis();
  }

  if (millis()-lastTime[46]>debouncetime) {
    if (padVelocity[46]>0) rigg.animations.add(new Stars(rigg));
    lastTime[46]=millis();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// ALL ON ///////////////////////////////////////////////

  if (millis()-lastTime[47]>debouncetime) {
    if (padVelocity[47]>0) {
      rigg.animations.add( new AllOn(rigg)); //rigg.anim.alphaEnvelopeA = new CrushPulse(0.031, 0.040, 0.913, avgmillis*rigg.alphaRate*3+0.5, 0.0, 0.0);
      //anim = rigg.animations.get(rigg.animations.size()-1);
      lastTime[47]=millis();
    }
  }
  if (millis()-lastTime[39]>debouncetime) {
    if (padVelocity[39]>0) roof.animations.add( new AllOn(roof));
    lastTime[39]=millis();
  }
  if (millis()-lastTime[42]>debouncetime) {
    if (padVelocity[42]>0) for (Anim anim : pars.animations) anim.deleteme = true;
    lastTime[42]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// KILL ALL ANIMS - BLACKOUT ///////////////////////////////////////////////
  if (millis()-lastTime[48]>debouncetime) {
    if (padVelocity[48]>0) for (Anim anim : rigg.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[48]=millis();
  }
  if (millis()-lastTime[40]>debouncetime) {
    if (padVelocity[40]>0) for (Anim anim : roof.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[40]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// STUTTER ///////////////////////////////////////////////x
  /*
  if (millis()-lastTime[49]>debouncetime) {
   if (padVelocity[49]>0) for (Anim anim : rigg.animations) {
   anim.alphaEnvelopeA = anim.alphaEnvelopeA.mul((1-cc[46])+(stutter*cc[46])); // anim.alphaEnvelopeA.mul(0.6+(stutter*0.4));     //anim.alphaEnvelopeA.mul((1-cc[46])+(stutter*cc[46]));
   anim.alphaEnvelopeB = anim.alphaEnvelopeB.mul((1-cc[46])+(stutter*cc[46])); //anim.alphaEnvelopeA.mul(0.6+(stutter*0.4)); //anim.alphaEnvelopeB.mul((1-cc[46])+(stutter*cc[46]));
   }
   lastTime[49]=millis();
   }
   
   if (millis()-lastTime[41]>debouncetime) {
   if (padVelocity[41]>0) for (Anim anim : rigg.animations) {
   anim.functionEnvelopeA = anim.functionEnvelopeA.mul(0.6+(stutter*0.4));  //     anim.functionEnvelopeA.mul((1-cc[54])+(stutter*cc[54]));
   anim.functionEnvelopeB = anim.functionEnvelopeB.mul(0.6+(stutter*0.4));    //anim.functionEnvelopeB.mul((1-cc[54])+(stutter*cc[54]));
   }
   lastTime[41]=millis();
   }
   */
  //  if (padVelocity[36] > 0) {
  //    rigg.colorIndexA = (rigg.colorIndexA+1)%rigg.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    cans.colorIndexA = (cans.colorIndexA+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  //  if (padVelocity[37] > 0) {
  //    rigg.colorIndexB = (rigg.colorIndexB+1)%rigg.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    cans.colorIndexB = (cans.colorIndexB+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  if (padVelocity[36] > 0) rigg.colorFlip(true);
  if (padVelocity[37] > 0) rigg.colorSwap(0.9999999999f);

  if (padVelocity[38] > 0) roof.colorSwap(0.9999999999f);
  if (padVelocity[39] > 0) pars.colorSwap(0.9999999999f);                // COLOR SWAP MOMENTARY



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
public void playWithMeMore() {

  /////////////////////////////////////////////////////// 

  /////background noise over whole window/////
  if (padVelocity[51] > 0) {
    rigg.colorLayer.beginDraw();
    rigg.colorLayer.background(0, 0, 0, 0);
    rigg.colorLayer.endDraw();
    bgNoise(rigg.colorLayer, rigg.flash, map(padVelocity[51], 0, 1, 0, rigg.dimmer/1.5f), cc[48]);   //PGraphics layer,color,alpha
    image(rigg.colorLayer, rigg.size.x, rigg.size.y, rigg.wide, rigg.high);
  }
  if (padVelocity[43] > 0) {
    roof.colorLayer.beginDraw();
    roof.colorLayer.background(0, 0, 0, 0);
    roof.colorLayer.endDraw();
    bgNoise(roof.colorLayer, roof.flash, map(padVelocity[43], 0, 1, 0, roof.dimmer), cc[56]);   //PGraphics layer,color,alpha
    image(roof.colorLayer, roof.size.x, roof.size.y, roof.wide, roof.high);
  }

  if (padVelocity[50] > 0) {
    pars.colorLayer.beginDraw();
    pars.colorLayer.background(0, 0, 0, 0);
    pars.colorLayer.endDraw();
    //void bgNoise(PGraphics layer, color _col, float bright, float fizzyness) {

    bgNoise(pars.colorLayer, pars.flash, map(padVelocity[50], 0, 1, 0, pars.dimmer), cc[47]);   //PGraphics layer,color,alpha
    image(pars.colorLayer, pars.size.x, pars.size.y, pars.wide, pars.high);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void cansControl(int col, float alpha) {
  fill(col, 360*alpha);
  rect(opcGrid.cans[0].x, opcGrid.cans[0].y, opcGrid.cansLength, 3);
  rect(opcGrid.cans[1].x, opcGrid.cans[1].y, opcGrid.cansLength, 3);
}
public void rigControl(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke( col, 360*alpha);
  for (int i  = 0; i < opcGrid.mirror.length; i++) rect(opcGrid.mirror[i].x, opcGrid.mirror[i].y, opcGrid._mirrorWidth, opcGrid._mirrorWidth);
  noStroke();
}
public void seedsControlA(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seeds[0].x, opcGrid.seeds[0].y, opcGrid.seedsLength, 3);
  noStroke();
}
public void seedsControlB(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seeds[1].x, opcGrid.seeds[1].y, opcGrid.seedsLength, 3);
  noStroke();
}
public void seedsControlC(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seeds[2].x, opcGrid.seeds[2].y, 3, opcGrid.seeds2Length);
  noStroke();
}
public void controllerControl(int col, float alpha) {
  fill(col, 360*alpha);
  rect(opcGrid.controller[0].x, opcGrid.controller[0].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[1].x, opcGrid.controller[1].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[2].x, opcGrid.controller[2].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[3].x, opcGrid.controller[3].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
}

/*
 //if (cc[104] > 0) {
 //  animations.add(new MirrorsOn(manualSlider, 1-(stutter*stutterSlider), cc[104]*rigDimmer));
 //  rigg.colorFlip(true);
 //}
 //if (cc[107] > 0) animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[107]*roofDimmer));
 //if (cc[108] > 0) { 
 //  roof.colorFlip(true);
 //  animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[108]*roofDimmer));
 //}
 */
/*
 for (int i = 0; i < 4; i++) if (padPressed[101+i]) {
 rigg.dimmer = pad[101+i];
 rigg.animations.add(new Anim(i, manualSlider, funcRate, rigg)); // use pad buttons to play differnt viz
 }
 for (int i = 0; i < 3; i++) if (padPressed[105+i]) {
 roof.dimmer = pad[105+i];
 roof.animations.add(new Anim(i, manualSlider, funcRate, roof)); // use pad buttons to play differnt viz
 }
 if (padPressed[108]) {
 roof.dimmer = pad[108];
 roof.animations.add(new Anim(10, manualSlider, funcRate, roof)); // use pad buttons to play differnt viz
 }
 
 for (int i =0; i < 8; i++)if (padPressed[i]) {
 rigg.dimmer = padVelocity[i];
 rigg.animations.add(new Anim(i, alphaRate, funcRate, rigg)); // use pad buttons to play differnt viz
 }
 */
/*
//for (int i = 0; i<8; i++) if (keyP[49+i]) rigg.animations.add(new Anim(i, manualSlider, funcSlider, rigg));       // use number buttons to play differnt viz
 //if (keyP[48]) animations.add(new AllOn(manualSlider, 1, rigDimmer));   
 
 // '0' triggers all on for the rig
 
 */
int rigVizList = 11, roofVizList =11, alphLength = 5, funcLength = 8;
float alf;
int vizTimer, alphaTimer, functionTimer;
public void playWithYourself(float vizTm) {
  ///////////////// VIZ TIMER /////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - vizTimer >= vizTm) {
    for (Rig rig : rigs) { 
      if (rig.play) {  
        rig.vizIndex = PApplet.parseInt(random(rig.availableAnims.length));
        alf = 0; ////// set new viz to 0 to fade up viz /////
        println(rig.name+" VIZ:", rig.vizIndex, "@", (hour()+":"+minute()+":"+second()));
      }
    }
    vizTimer = millis()/1000;
  }
  float divide = 4; ///////// NUMBER OF TIMES ALPHA CHANGES PER VIZ
  ///////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - alphaTimer >= vizTm/divide) { ///// alpha timer changes 4 times every viz change /////
    for (Rig rig : rigs) { 
      if (rig.play) {  
        rig.alphaIndexA = PApplet.parseInt(random(rig.availableAlphaEnvelopes.length));  //// select from alpha array
        rig.alphaIndexB = PApplet.parseInt(random(rig.availableAlphaEnvelopes.length)); //// select from alpha array
        alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
        println(rig.name+" alpha change @", (hour()+":"+minute()+":"+second()), "new envelopes:", rig.alphaIndexA, "&", rig.alphaIndexB);
      }
    }
    alphaTimer = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - functionTimer >= vizTm/divide) {    ////// change function n times for every state change
    for (Rig rig : rigs) {
      if (rig.play) {  
        rig.functionIndexA = PApplet.parseInt(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        rig.functionIndexB = PApplet.parseInt(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
        println(rig.name+" function change @", (hour()+":"+minute()+":"+second()), "new envelope:", rig.functionIndexA, "&", rig.functionIndexB);
      }
    }
    functionTimer = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ //////////////////////////////////////////////////////////////////////////
  if (alf < 1)  alf += 0.05f;
  if (alf > 1) alf = 1;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  colTime = colorTimerSlider*60*30;
  for(Rig rig : rigs) rig.colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours
  //roof.colorTimer(colTime/1.5, 1); //// seconds between colour change, number of steps to cycle through colours
  //cans.colorTimer(colTime/2, 1); //// seconds between colour change, number of steps to cycle through colours
  //pars.colorTimer(colTime/2, 1); //// seconds between colour change, number of steps to cycle through colours

  if (millis()/1000 % colTime/4 == 0) for (Rig rig : rigs) rig.bgIndex = (rig.bgIndex+1) % rig.availableBkgrnds.length;               // change colour layer automatically

  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) {
    rigg.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    roof.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    cans.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  }
  if (beatCounter%64<2) rigg.colorSwap(1000000*noize);  
  if (beatCounter%82>80) roof.colorSwap(1000000*noize);
  if (beatCounter%64>61) cans.colorSwap(1000000*noize);

  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) rigg.colFlip = true;
  else rigg.colFlip = false;
  for (int i = 11; i<19; i+=2) if ( beatCounter % 128 == i) roof.colFlip = true;
  else roof.colFlip = false;

  rigg.colorFlip(rigg.colFlip);
  roof.colorFlip(roof.colFlip);
  cans.colorFlip(cans.colFlip);

  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  if (beatCounter % 64 > 60)  colorLerping(rigg, (1-beat)*2);
  if (beatCounter % 96 > 90)  colorLerping(roof, (1-beat)*1.5f);
  if (beatCounter % 32 > 28)  colorLerping(cans, (1-beat)*1.5f);

  colBeat = false;
  //rigg.c = lerpColor(rigg.col[rigg.colorIndexB], rigg.col[rigg.colorIndexA], beatFast);
  //rigg.flash = lerpColor(rigg.col[rigg.colorIndexA], rigg.col[rigg.colorIndexB], beatFast);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

public void colorLerping(Rig _rig, float function) {
  _rig.c = lerpColor(_rig.col[_rig.colorIndexB], _rig.col[_rig.colorIndexA], function);
  _rig.flash = lerpColor(_rig.col[_rig.colorIndexA], _rig.col[_rig.colorIndexB], function);
  colBeat = true;
}
public class Rig {
  float dimmer, alphaRate, funcRate, blurValue, bgNoise, manualAlpha, beatSlider; 
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  int c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD, scol1, scol2, scol3;
  int col[] = new int[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  boolean firsttime_sketchcolor=true, toggle, noiseToggle, play;
  ArrayList <Anim> animations;
  HashMap<Integer, Ref> dimmers;
  int[] availableAnims;
  int[] availableBkgrnds;
  int[] availableAlphaEnvelopes;
  int[] availableFunctionEnvelopes;
  int[] availableColors;
  String[] animNames, backgroundNames, alphaNames, functionNames;
  int arrayListIndex;
  float infoX, infoY;
  ControlP5 cp5;
  PApplet parent;
  ScrollableList ddVizList, ddBgList, ddAlphaList, ddFuncList, ddAlphaListB, ddFuncListB;
  RadioButton cRadioButton, flashRadioButton;

  Rig(boolean _toggle, float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);
    toggle = _toggle;

    this.cp5 = controlFrame.cp5;

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;

    animNames = new String[] {"benjmains boxes", "checkers", "rings", "rush", "rushed", 
      "square nuts", "diaganol nuts", "stars", "swipe", "swiped", "teeth", "donut", "all on", "all off"}; 
    backgroundNames = new String[] {"one col c", "vert mirror grad", "side by side", "horiz mirror grad", 
      "one color flash", "moving horiz grad", "checked", "radiators", "stripes", "one two three"}; 

    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);          // where this is the rig object
    availableBkgrnds = new int[] {0, 1, 2, 3};    // default - changed when initalised;
    availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5};  
    availableFunctionEnvelopes = new int[] {0, 1, 2, 5, 6};  

    //dimmers = new HashMap<Integer, Ref>();

    int xw = 2;
    for (int i = 0; i < position.length/xw; i++) position[i] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*1);
    for (int i = 0; i < position.length/xw; i++) position[i+(position.length/xw)] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*2);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i=0; i<positionX.length; i++)  positionX[i][0] = new PVector(wide/(positionX.length)*(i+0.5f), high/6*1);
    for (int i=0; i<positionX.length; i++)  positionX[i][1] = new PVector(wide/(positionX.length)*(i+0.5f), high/4*2);
    for (int i=0; i<positionX.length; i++)  positionX[i][2] = new PVector(wide/(positionX.length)*(i+0.5f), high/6*5);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    colorLayer = createGraphics(wide, high, P2D);
    colorLayer.beginDraw();
    colorLayer.noStroke();
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
    /////////////////////////////////////// COLOR ARRAY ARRANGEMENT ////////////////////////////////////////
    if (firsttime_sketchcolor) {
      colorSetup();                        // setup colors red bloo etc once
      firsttime_sketchcolor = false;
    }
    availableColors = new int[] { 0, 1, 2, 3, 4, 5, 6};
    col[0] = teal; 
    col[1] = orange; 
    col[2] = pink; 
    col[3] = purple;
    col[4] = bloo;
    col[5] = red;
    col[6] = grin;
    col[7] = pink;
    col[8] = orange;
    col[9] = bloo;
    col[10] = purple;
    col[11] = pink;
    col[12] = orange;
    col[13] = orange1;
    col[14] = teal;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    ////////////////////////////// LOAD CONTROLLERS //////////////////////////////////////////////////////////////////////////////
    int clm = 300;           // distance between coloms
    float x = clm;
    float y = 90;
    int swide = 80;           // x size of sliders
    int shigh = 14;           // y size of slider
    int row = shigh+4;       // distance between rows
    ///////////////////////////////// SLIDERS  ///////////////////////////////////////////////////////////////////////////////////
    loadSlider( "dimmer", x+(clm*arrayListIndex), y+(0*row), swide, shigh, 0, 1, dimmer, act1, bac1, slider1);
    loadSlider( "alphaRate", x+(clm*arrayListIndex), y+(1*row), swide, shigh, 0, 1, 0.5f, act, bac, slider);
    loadSlider( "funcRate", x+(clm*arrayListIndex), y+(2*row), swide, shigh, 0, 1, 0.5f, act1, bac1, slider1);
    loadSlider( "blurValue", x+(clm*arrayListIndex), y+(3*row), swide, shigh, 0, 1, 0.5f, act, bac, slider);
    loadSlider( "bgNoise", x+(clm*arrayListIndex), y+(4*row), swide, shigh, 0, 1, 0.5f, act1, bac1, slider1);
    loadSlider( "manualAlpha", x+(clm*arrayListIndex), y+(5*row), swide, shigh, 0, 1, 0.8f, act, bac, slider);
    loadSlider( "beatSlider", x+(clm*arrayListIndex), y+(6*row), swide, shigh, 0, 1, 0.2f, act1, bac1, slider1);
    ///////////////////////////////// TOGGLES  ///////////////////////////////////////////////////////////////////////////////////
    loadToggle(noiseToggle, "noiseToggle", x+(clm*arrayListIndex), y+row*7.5f, swide, 10);
    loadToggle(toggle, "toggle", x+(clm*arrayListIndex), y+row*9, swide-30, 20);
    loadToggle(play, "play", x+(clm*arrayListIndex)+swide-25, y+row*9, 25, 20);
    ///////////////////////////////// RADIO BUTTONS  //////////////////////////////////////////////////////////////////////////////
    cRadioButton = cp5.addRadioButton(name+" cRadioButton")
      //.plugTo(this, "cRadioButton")
      //.setLabel(this.name+" cRadioButton")
      .setPosition(x+(clm*arrayListIndex)-130, y)
      .setSize(15, shigh);
    for (int i=0; i<availableColors.length; i++) {
      cRadioButton.addItem(name+" colc "+i, i);
      cRadioButton.getItem(name+" colc "+i)
        .setColorBackground(color(col[availableColors[i]], 100))
        .setColorForeground(color(col[availableColors[i]], 200))
        .setColorActive(color(col[availableColors[i]], 360));
      cRadioButton.hideLabels();
    }

    flashRadioButton = cp5.addRadioButton(name+" flashRadioButton")
      //.plugTo(this, "flashRadioButton")
      //.setLabel(this.name+" flashRadioButton")
      .setPosition(x+(clm*arrayListIndex)-110, y)
      .setSize(15, shigh);
    for (int i=0; i<availableColors.length; i++) {
      flashRadioButton.addItem(name+" colFlash "+i, i);
      flashRadioButton.getItem(name+" colFlash "+i)
        .setColorBackground(color(col[availableColors[i]], 100))
        .setColorForeground(color(col[availableColors[i]], 200))
        .setColorActive(color(col[availableColors[i]], 360));
      flashRadioButton.hideLabels() ;
    }
    ///////////////////////////////// DROPDOWN LISTS //////////////////////////////////////////////////////////////////////////////
    ddVizList = cp5.addScrollableList(name+" vizLizt").setPosition(x+(clm*arrayListIndex)-90, y);
    ddBgList = cp5.addScrollableList(name+" bkList").setPosition(x+(clm*arrayListIndex)-90, y+25);
    ddAlphaList = cp5.addScrollableList(name+" alpahLizt").setPosition(x+(clm*arrayListIndex)-90, y+60);
    ddFuncList = cp5.addScrollableList(name+" funcLizt").setPosition(x+(clm*arrayListIndex)-90, y+85);

    ddAlphaListB = cp5.addScrollableList(name+" alpahLiztB").setPosition(x+(clm*arrayListIndex)-45, y+60);
    ddFuncListB = cp5.addScrollableList(name+" funcLiztB").setPosition(x+(clm*arrayListIndex)-45, y+85);

    // the order of this has to be oppostie to the order they are displayed on screen
    customize(ddFuncListB, color(bac1, 200), bac, act, 40, "funcB");     // customize the list
    customize(ddAlphaListB, color(bac1, 200), bac, act, 40, "alphB");   // customize the list
    customize(ddFuncList, color(bac1, 200), bac, act, 40, "funcA");     // customize the list
    customize(ddAlphaList, color(bac1, 200), bac, act, 40, "alphA");   // customize the list

    customize(ddBgList, color(bac, 200), bac1, act, 85, name+" bkgrnd");       // customize the list
    customize(ddVizList, color(bac, 200), bac1, act, 85, name+" viz");       // customize the list

    /////////  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void loadToggle(boolean toggle, String label, float x, float y, int wide, int high) {
    cp5.addToggle(this.name+" "+label)
      .plugTo(this, label)
      .setLabel(label)
      .setPosition(x, y)
      .setSize(wide, high)      
      .setValue(toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(act) 
      ;
  }

  public void loadSlider(String label, float x, float y, int wide, int high, float min, float max, float startVal, int act1, int bac1, int slider1) {
    cp5.addSlider(name+" "+label)
      //.setLabel(label)
      .plugTo(this, label)
      .setPosition(x, y)
      .setSize(wide, high)
      .setRange(min, max)
      .setValue(startVal)    // start value of slider
      .setColorActive(color(act1, 200)) 
      .setColorBackground(color(bac1, 200)) 
      .setColorForeground(color(slider1, 200)) 
      ;
  }

  public void customize(ScrollableList ddl, int bac, int bac1, int act, int wide, String label) {
    ddl.setBackgroundColor(0); // color behind list - can hardly see it
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.setWidth(wide);
    ddl.setCaptionLabel(label);
    for (int i=0; i<availableAnims.length; i++) ddl.addItem(label+i, i);
    ddl.setColorBackground(color(bac, 300));       // background color
    ddl.setColorActive(200);           // clicked color
    ddl.setColorCaptionLabel(0xffFFFAFA) ;
    ddl.setColorForeground(bac1) ;      // highlight color
    ddl.setColorLabel(0xffFFFAFA) ;       // text color for label
    ddl.close();
    ddl.bringToFront();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void drawColorLayer() {
    int index = availableBkgrnds[bgIndex];
    switch(index) {
    case 0:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      colorLayer.endDraw();
      break;
    case 1:
      colorLayer.beginDraw();
      colorLayer.background(0);
      mirrorGradient(c, flash, 0.5f);
      colorLayer.endDraw();
      break;
    case 2:
      colorLayer.beginDraw();
      colorLayer.background(0);
      sideBySide(c, flash);
      colorLayer.endDraw();
      break;
    case 3:
      colorLayer.beginDraw();
      colorLayer.background(0);
      horizontalMirrorGradient(c, flash, 1);
      colorLayer.endDraw();
      break;
    case 4:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(flash);
      colorLayer.endDraw();
      break;
    case 5:
      colorLayer.beginDraw();
      colorLayer.background(0);
      horizontalMirrorGradient(c, flash, noize1);
      colorLayer.endDraw();
      break;
    case 6:
      colorLayer.beginDraw();
      colorLayer.background(0);
      check(c, flash);
      colorLayer.endDraw();
      break;
    case 7:
      colorLayer.beginDraw();
      colorLayer.background(0);
      radiator(c, flash);
      colorLayer.endDraw();
      break;
    case 8:
      colorLayer.beginDraw();
      colorLayer.background(0);
      stripes(c, flash);
      colorLayer.endDraw();
      break;
    case 9:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneTwoThree(c, flash);
      colorLayer.endDraw();
      break;
    default:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      colorLayer.endDraw();
      break;
    }
    blendMode(MULTIPLY);
    /*
    if (syphonToggle) { 
     if (syphonImageReceived != null) image(syphonImageReceived, size.x, size.y, wide, high);
     } else 
     */
    image(colorLayer, size.x, size.y);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// VERTICAL MIRROR GRADIENT BACKGROUND ////////////////////////////////////////////////
  public void mirrorGradient(int col1, int col2, float func) {
    //// LEFT SIDE OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    //colorLayer.noStroke();
    colorLayer.fill(col1);
    colorLayer.vertex(0, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height);
    colorLayer.endShape(CLOSE);
    //// RIGHT SIDE OF colorLayerIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.endShape(CLOSE);
  }
  /////////////////////////////////// RADIAL GRADIENT BACKGROUND //////////////////////////////////////////////////////////
  public void radialGradient(int col1, int col2, float function) {
    colorLayer.background(col1);
    float radius = colorLayer.height*function;
    int numPoints = 12;
    float angle=360/numPoints;
    float rotate = 90+(function*angle);
    for (  int i = 0; i < numPoints; i++) {
      colorLayer.beginShape(POLYGON); 
      colorLayer.fill(col1);
      colorLayer.vertex(cos(radians((i)*angle+rotate))*radius+colorLayer.width/2, sin(radians((i)*angle+rotate))*radius+colorLayer.height/2);
      colorLayer.fill(col2);
      colorLayer.vertex(colorLayer.width/2, colorLayer.height/2);
      colorLayer.fill(col1);
      colorLayer.vertex(cos(radians((i+1)*angle+rotate))*radius+colorLayer.width/2, sin(radians((i+1)*angle+rotate))*radius+colorLayer.height/2);
      colorLayer.endShape(CLOSE);
    }
  }
  /// MIRROR GRADIENT BACKGROUND top one direction - bottom opposite direction ///
  public void mirrorGradientHalfHalf(int col1, int col2, float func) {
    //////// TOP //// LEFT SIDE OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col1);
    colorLayer.vertex(0, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height/2);
    colorLayer.endShape(CLOSE);
    //// RIGHT SIDE OF colorLayerIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height/2);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.endShape(CLOSE);
    colorLayer.endDraw();
    //////////////////////////////////
    func = 1-func;
    colorLayer.beginDraw();
    ///// BOTTOM
    //// LEFT SIDE OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height/2);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height/2);
    colorLayer.endShape(CLOSE);
    //// RIGHT SIDE OF colorLayerIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height/2);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.endShape(CLOSE);
  }
  /////////////////////////////////////////////////// HORIZONAL GRADIENT ///////////////////////////////////////////////////////
  public void horizontalMirrorGradient(int col1, int col2, float func) {
    //// TOP HALF OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(0, 0);
    colorLayer.vertex(colorLayer.width, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height*func);
    colorLayer.vertex(0, colorLayer.height*func);
    colorLayer.endShape(CLOSE);
    //// BOTTOM HALF OF GRADIENT 
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height*func);
    colorLayer.vertex(colorLayer.width, colorLayer.height*func);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width, colorLayer.height);
    colorLayer.vertex(0, colorLayer.height);
    colorLayer.endShape(CLOSE);
  }
  ///////////////////////////////////////// ONE COLOUR BACKGOUND //////////////////////////////////////////////////////////////////////////
  public void oneColour(int col1) {
    colorLayer.background(col1);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void radiator(int col1, int col2) {
    colorLayer.fill(col2);
    for (int i = 0; i < opcGrid.rad.length; i++) colorLayer.rect(this.position[i].x, this.position[i].y, 15, this.high/2.2f);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void check(int col1, int col2) {
    colorLayer.fill(col2);
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width, colorLayer.height);        
    colorLayer.fill(col1);  
    for (int i = 0; i < position.length/2; i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    for (int i = position.length/2+1; i < position.length; i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    //if (opcGrid.rows == 3) for (int i = opcGrid.columns*opcGrid.rows; i < opcGrid.mirror.length/opcGrid.rows+(opcGrid.columns*2); i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void sideBySide( int col1, int col2) {
    colorLayer.fill(col2);
    colorLayer.rect(colorLayer.width/4, colorLayer.height/2, colorLayer.width/2, colorLayer.height);     
    colorLayer.fill(col1);                                
    colorLayer.rect(colorLayer.width/4*3, colorLayer.height/2, colorLayer.width/2, colorLayer.height);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void oneTwoThree( int col1, int col2) {
    colorLayer.background(col1);
    colorLayer.fill(col2);                                
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width/3*2, colorLayer.height);
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void stripes( int col1, int col2) {
    colorLayer.background(col1);
    colorLayer.fill(col2);                                
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width/3, colorLayer.height);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void rigInfo() {

    float textHeight = 18;
    textSize(textHeight);
    float nameWidth = textWidth(name);
    float x = size.x+(wide/2)-(nameWidth/2)-12;
    float y = size.y-(high/2)+21;

    //if (this == cans) x = size.x+25;

    fill(360);
    textAlign(CENTER);
    textLeading(18);
    text(name, x, y);

    fill(0, 100);
    stroke(rigg.flash, 60);
    strokeWeight(1);
    rect(x, y-(textHeight/2)+3, nameWidth+17, 30);
    noStroke();
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    x = x-(nameWidth+17);
    y = size.y-(high/2)+20;

    ///// RECTANGLES TO SHOW CURRENT COLOURS /////
    fill(0);                              
    rect(x, y-10, 10, 10);                 // rect to show CURRENT color C 
    rect(x+15, y-10, 10, 10);              // rect to show NEXT color C 
    rect(x, y, 10, 10);                    // rect to show CURRENT color FLASH 
    rect(x+15, y, 10, 10);                 // rect to show NEXT color FLASH1

    fill(0, 100);
    stroke(rigg.flash, 60);
    strokeWeight(1);
    rect(x+7.5f, y-5, 30, 30);

    stroke(0);
    fill(this.c);          
    rect(x, y-10, 10, 10);                                     // rect to show CURRENT color C 
    fill(this.col[(this.colorIndexA+1)%this.col.length], 100);
    rect(x+15, y-10, 10, 10);                                  // rect to show NEXT color C 
    fill(this.flash);
    rect(x, y, 10, 10);                                        // rect to show CURRENT color FLASH 
    fill(this.col[(this.colorIndexB+1)%this.col.length], 100);  
    rect(x+15, y, 10, 10);                                     // rect to show NEXT color FLASH1
    noStroke();
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////// COLOR TIMER /////////////////////////////////////////////////////////////////////////
  float go = 0;
  boolean change;
  int colorTimer;
  public void colorTimer(float colTime, int steps) {
    if (change == false) {
      colA = c;
      colC = flash;
    }
    if (millis()/1000 - colorTimer >= colTime) {
      change = true;
      println("COLOR CHANGE @", (hour()+":"+minute()+":"+second()));
      colorTimer = millis()/1000;
    } else change = false;
    if (change == true) {
      go = 1;
      colorIndexA =  (colorIndexA + steps) % (col.length-1);
      colB =  col[colorIndexA];
      colorIndexB = (colorIndexB + steps) % (col.length-1);
      colD = col[colorIndexB];
    }
    c = col[colorIndexA];
    c1 = col[colorIndexA];
    flash = col[colorIndexB];
    flash1 = col[colorIndexB];

    if (go > 0.1f) change = true;
    else change = false;
    if (change == true) {
      c = lerpColorHSB(colB, colA, go);
      flash = lerpColorHSB(colD, colC, go);
    }
    go *= 0.97f;
    if (go < 0.01f) go = 0.001f;
  }
  ////////////////////////////////////////////////////// HSB LERP COLOR FUNCTION //////////////////////////////
  // linear interpolate two colors in HSB space 
  public int lerpColorHSB(int c1, int c2, float amt) {
    amt = min(max(0.0f, amt), 1.0f);
    float h1 = hue(c1), s1 = saturation(c1), b1 = brightness(c1);
    float h2 = hue(c2), s2 = saturation(c2), b2 = brightness(c2);
    // figure out shortest direction around hue
    float z = g.colorModeZ;
    float dh12 = (h1>=h2) ? h1-h2 : z-h2+h1;
    float dh21 = (h2>=h1) ? h2-h1 : z-h1+h2;
    float h = (dh21 < dh12) ? h1 + dh21 * amt : h1 - dh12 * amt;
    if (h < 0.0f) h += z;
    else if (h > z) h -= z;
    colorMode(HSB);
    return color(h, lerp(s1, s2, amt), lerp(b1, b2, amt));
  }
  ////////////////////////////// COLOR SWAP //////////////////////////////////
  boolean colSwap;
  public void colorSwap(float spd) {
    int t = PApplet.parseInt(millis()/70*spd % 2);
    int colA = c;
    int colB = flash;
    if ( t == 0) {
      colSwap = true;
      c = colB;
      flash = colA;
    } else colSwap = false;
  } 
  ////////////////////////////// COLOR FLIP //////////////////////////////////
  boolean colFlip;
  public void colorFlip(boolean toggle) {
    int colA = c;
    int colB = flash;
    if (toggle) {
      c = colB;
      flash = colA;
    }
  }
  ///////////////////////////////////////// CLASH COLOR SETUP /////////////////////////////////
  public void clash(float func) { 
    clash = lerpColorHSB(c, flash, func*0.2f);           ///// MOVING, HALF RNAGE BETWEEN C and FLASH
    clash1 = lerpColorHSB(c, flash, 1-(func*0.2f));      ///// MOVING, HALF RANGE BETWEEN FLASH and C
    clashed = lerpColor(c, flash, 0.2f);                 ///// STATIC - HALFWAY BETWEEN C and FLASH
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void addAnim(int animIndex) {
    Anim anim = new Anim(this);

    //    println(name+" aval anims");
    //println(availableAnims);
    int index = this.availableAnims[animIndex];

    //println(name+" index", index);
    //println();

    switch (index) {
    case 0:  
      anim = new BenjaminsBoxes(this);
      break;
    case 1:  
      anim = new Checkers(this);
      break;
    case 2:  
      anim = new Rings(this);
      break;
    case 3:  
      anim = new Rush(this);
      break;
    case 4:  
      anim = new Rushed(this);
      break;
    case 5:  
      anim = new SquareNuts(this);
      break;
    case 6:  
      anim = new DiagoNuts(this);
      break;
    case 7:  
      anim = new Stars(this);
      break;
    case 8:  
      anim = new Swipe(this);
      break;
    case 9:  
      anim = new Swiped(this);
      break;
    case 10:  
      anim = new Teeth(this);
      break;
    case 11:  
      anim = new Donut(this);
      break;
    case 12:
      anim = new AllOn(this);
      break;
    case 13:
      anim = new AllOff(this);
      break;
    }
    //    Ref t=new Ref(new float[]{1.0}, 0);
    //    if (t != null) anim.animDimmer = anim.animDimmer.mul(t);

    // ramp out all previous anims
    if (testToggle) {
      for (Anim an : animations) {
        float now = millis();
        if (alphaIndexA == 1) {
          an.alphaEnvelopeA = new Ramp(now, now+avgmillis*alphaRate*3.0f, an.alphaA, an.alphaA, 0.9f).mul(new Ramp(now+avgmillis*alphaRate*3.0f, now+avgmillis*alphaRate*4.0f, 1.0f, 0.1f, 0.1f));
        } else {
          an.alphaEnvelopeA = an.alphaEnvelopeA.mul(new Ramp(now, now+avgmillis*alphaRate*3.0f, 0.8f, 0.2f, 0.1f));
          an.alphaEnvelopeA.end_time = min(PApplet.parseInt(now+avgmillis*alphaRate*5.0f), an.alphaEnvelopeA.end_time);
        }
        if (alphaIndexB == 1) {
          an.alphaEnvelopeB = new Ramp(now, now+avgmillis*alphaRate*3.0f, an.alphaB, an.alphaB, 0.9f).mul(new Ramp(now+avgmillis*alphaRate*3.0f, now+avgmillis*alphaRate*4.0f, 1.0f, 0.1f, 0.1f));
        } else {       
          an.alphaEnvelopeB = an.alphaEnvelopeB.mul(new Ramp(now, now+avgmillis*alphaRate*3.0f, 0.9f, 0.2f, 0.1f));
          an.alphaEnvelopeB.end_time = min(PApplet.parseInt(now+avgmillis*alphaRate*5.0f), an.alphaEnvelopeB.end_time);
        }
      }
    }

    this.animations.add(anim);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void drawAnimations() {
    blendMode(LIGHTEST);
    for (int i = this.animations.size()-1; i >=0; i--) {                                  // loop  through the list
      Anim anim = this.animations.get(i);  
      anim.drawAnim();           // draw the animation
    }
  }
  
  public void removeAnimations() {
    Iterator<Anim> animiter = this.animations.iterator();
    while (animiter.hasNext()) {
      if (animiter.next().deleteme) animiter.remove();
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void draw() {
    clash(beat);
    drawAnimations();

    //dimmer = cc[40];
    blendMode(MULTIPLY);
    // this donesnt work anymore....
    if (cc[107] > 0 || keyT['r'] || glitchToggle) bgNoise(colorLayer, 0, 0, cc[55]); //PGraphics layer,color,alpha
    drawColorLayer();

    blendMode(NORMAL);
    cans.infoX +=100;
    rigInfo();
    removeAnimations();
    cordinatesInfo(this, keyT['q']);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
PApplet getparent () {
 try {
 return (PApplet) getClass().getDeclaredField("this$0").get(this);
 }
 catch (ReflectiveOperationException cause) {
 throw new RuntimeException(cause);
 }
 }
 */
public int xred(int c) {
  return c >> 16 & 0xFF;
}
public int xgrn(int c) {
  return c>>8 & 0xFF;
}
public int xblu(int c) {
  return c & 0xFF;
}
public int xcolor(byte a, byte b, byte c) {
  return (0xff<<24) | ((a&0xff)<<16) | ((b&0xff) << 8) | (c&0xff);
}

ArtNetClient artnet;
byte[] dmxData = new byte[512];
int triggertimes[] = new int[512];
public void DMXSetup(){
  artnet = new ArtNetClient();
  artnet.start();
}
public void DMXcontrollingUs() {
  int debouncetime=100;
  int subnet=0;
  int universe=0;
  dmxData = artnet.readDmxData(subnet,universe);  
  //attach bits of the code to DMX channels
  //attach to vizIndex
  if (dmxData[4]>0 ) {
    rigg.vizIndex=PApplet.parseInt(map(dmxData[3], 1, 255, 0, rigg.availableAnims.length-1)+0.5f);//plus 0.5 rounds rather than truncates
  }
  //DMX attach color
  if (dmxData[0]>0 || dmxData[1]>0 || dmxData[2]>0) {
    rigg.c = xcolor(dmxData[0], dmxData[1], dmxData[2]);
    rigg.flash = xcolor(dmxData[0],dmxData[1],dmxData[2]);
  }
  //DMX attach trigger
  if (dmxData[7]>0 ) {
    //debounce
    if (triggertimes[7]<millis()+debouncetime) {
      rigg.addAnim(rigg.availableAnims[rigg.vizIndex]);
      triggertimes[7]=millis();
    }
  }
  //DMX attach float
  if (dmxData[8]>0 && false) {
    roof.dimmer = map(dmxData[8], 1, 255, 0, 1);
  }
}


////import codeanticode.syphon.*;
//PGraphics syphonImageReceived, syphonImageSent;
////SyphonClient syphonClient;
////SyphonServer syphonServer;

boolean syphonToggle = false;
/*
void syphonSetup(boolean toggle) {
 if (toggle) {
 HashMap<String, String>[] allServers = SyphonClient.listServers();
 print("Available Syphon servers: ");
 print(allServers);
 if (allServers.length == 0) print("NO Syphon servers available");
 String matt_servname = "MATTS-MACBOOK-PRO.LOCAL (VDMX-NDI® Output 1)";
 //String matt_servname2 = "MATTS-MACBOOK-PRO.LOCAL (VDMX-NDI® Output 2)";
 String matt_appname = "NDISyphon";
 syphonClient = new SyphonClient(this, matt_appname, matt_servname);// create syphon client to receive frames
 //syphonClient2 = new SyphonClient(this, matt_appname, matt_servname2);// create syphon client to receive frames
 
 syphonServer = new SyphonServer(this, "mirrors syphon");   // Create syhpon server to send frames out.
 println();
 syphonImageSent = createGraphics(rigg.wide, rigg.high, P2D);
 syphonImageSent.imageMode(CENTER);
 }
 syphonToggle = false;
 }
 
 
 void syphonLoadSentImage(boolean toggle) {
 if (toggle) {
 syphonImageSent.beginDraw();
 syphonImageSent.background(0);
 syphonImageSent.endDraw();
 if (syphonClient.newFrame()) syphonImageReceived = syphonClient.getGraphics(syphonImageReceived); // load the pixels array with the updated image info (slow)
 }
 }
 
 
 
 void syphonSendImage(boolean toggle) {
 if (toggle) {
 syphonServer.sendImage(syphonImageSent);
 image(syphonImageSent, size.rig.x+112.5, 455, 225, 87.5);
 if (syphonImageReceived != null) image(syphonImageReceived, size.rig.x-112.5, 455, 225, 87.5);
 }
 }
 */



public class WLED extends OPC
{
  Socket socket;
  OutputStream output, pending;
  DatagramSocket udpsock;
  InetAddress wledaddress;
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte[][] wledData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;

  WLED(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    this.enableShowLocations = true;
    parent.registerMethod("draw", this);
    try{
      udpsock = new DatagramSocket();
    }catch(Exception e){println("Failed to Open WLED Socket",e);}
    try{
      wledaddress = InetAddress.getByName(host);
    }catch(Exception e){println("DNS lookup failed for ",host,e);}
    
    
    
    
  }

  // Set the location of a single LED
  public void led(int index, int x, int y)  
  {
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }
  
  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip.
  public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0f) * spacing * c + 0.5f),
        (int)(y + (i - (count-1)/2.0f) * spacing * s + 0.5f));
    }
  }

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
  public void ledRing(int index, int count, float x, float y, float radius, float angle)
  {
    for (int i = 0; i < count; i++) {
      float a = angle + i * 2 * PI / count;
      led(index + i, (int)(x - radius * cos(a) + 0.5f),
        (int)(y - radius * sin(a) + 0.5f));
    }
  }

  // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  public void ledGrid(int index, int stripLength, int numStrips, float x, float y,
               float ledSpacing, float stripSpacing, float angle, boolean zigzag)
  {
    float s = sin(angle + HALF_PI);
    float c = cos(angle + HALF_PI);
    for (int i = 0; i < numStrips; i++) {
      ledStrip(index + stripLength * i, stripLength,
        x + (i - (numStrips-1)/2.0f) * stripSpacing * c,
        y + (i - (numStrips-1)/2.0f) * stripSpacing * s, ledSpacing,
        angle, zigzag && (i % 2) == 1);
    }
  }

  // Set the location of 64 LEDs arranged in a uniform 8x8 grid.
  // (x,y) is the center of the grid.
  public void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag)
  {
    ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag);
  }

  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  public void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }
  
  

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  public void draw()
  {
    int start_time = millis();
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }


    int numPixels = pixelLocations.length;
    int ledAddress = 4;
    
    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];
      
      int wledPacket_idx = (ledAddress - 4)/(489*3);
      int wledAddress = (ledAddress-4) % (489*3) + 4;
      //ledAddress 489*3 is the last one
      //ledAddress 4+490*3 becomes 4
      //println("ledAddress: ",ledAddress,", wledPacket_idx: ",wledPacket_idx,", wledAddress",wledAddress);
      byte R = (byte)(pixel >> 16);
      byte G = (byte)(pixel >> 8);
      byte B = (byte)(pixel);
      wledData[wledPacket_idx][wledAddress] = R;//(byte)(pixel >> 16);//R
      wledData[wledPacket_idx][wledAddress + 1] = G;//(byte)(pixel >> 8);//G
      wledData[wledPacket_idx][wledAddress + 2] = B;//(byte)pixel;//B

      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
    //println("wled draw: ",millis()-start_time);
  }
  
  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  public void setPixelCount(int numPixels)
  {

    //warls format
    // byte 0: which realtime protocol to use
    // 4: DNRGB 489 leds per packet
    // byte 1: how many seconds to wait after the last
    // received packet before returning to normal mode
    // 2: pause for two seconds before doing something cool again
    // 255: infinite timeout
    // byte 2-3: start index H-L
    int numWledPackets = numPixels / 490 + 1;
    //println("Packets= ",numWledPackets,", Pixels= ",numPixels);
    
    if (wledData == null || wledData.length != numWledPackets) {
      wledData = new byte[numWledPackets][];
      for(int i=0;i<numWledPackets;i++){
        int packet_pixels = min(numPixels,489);
        numPixels -= packet_pixels;
        println("creating packet of size ",4+packet_pixels*3);
        wledData[i] = new byte[4+packet_pixels*3];
        int offset = 490 * i;
        byte highByte = (byte)(offset >> 8);
        byte lowByte = (byte)offset;
        wledData[i][0] = 4;//DNRGB
        wledData[i][1] = 2;//two second timeout
        wledData[i][2] = highByte;
        wledData[i][3] = lowByte;
      }
    }

  }
  
  

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  public void writePixels()
  {
    if (wledData == null || wledData.length == 0){
    }else{
      for(int i=0;i<wledData.length;i++){
        DatagramPacket packet = new DatagramPacket(wledData[i],wledData[i].length,this.wledaddress,port);//21324 or 65506
        try{
          udpsock.send(packet);
        }catch(Exception e){
          println("failed to send packet ",e);
        }
      }
    }

  }


}
boolean glitchToggle, roofBasic = false, testToggle;
float vizTimeSlider, colorSwapSlider, colorTimerSlider, boothDimmer, digDimmer, backDropSlider;
float tweakSlider, blurSlider, bgNoiseBrightnessSlider, bgNoiseDensitySlider, manualSlider, stutterSlider;
float shimmerSlider, funcSlider, beatSlider;
float smokePumpValue, smokeOnTime, smokeOffTime;
float wideSlider, strokeSlider, highSlider;

class MainControlFrame extends ControlFrame {
  MainControlFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super (_parent, _controlW, _controlH, _xpos, _ypos);
  }
  public void setup() {
    super.setup();
    this.x = 10;
    this.y = 90;
    this.sliderY=y;
    rigg = new Rig(false,size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");
    roof = new Rig(false,size.roof.x, size.roof.y, size.roofWidth, size.roofHeight, "ROOF");
    cans = new Rig(true,size.cans.x, size.cans.y, size.cansWidth, size.cansHeight, "EGGS");
    pars = new Rig(true,size.pars.x, size.pars.y, size.parsWidth, size.parsHeight, "PARS");
 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// GLOBAL SLIDERS ///////////////////////////////////////////////////////////
    loadSlider("boothDimmer", x, y, wide, high, 0, 1, 0.32f, act1, bac1, slider1);
    loadSlider("digDimmer", x, y+row, wide, high, 0, 1, 0.2f, act, bac, slider);
    loadSlider("vizTimeSlider", x, y+row*2, wide, high, 0, 1, 0.5f, act1, bac1, slider1);
    loadSlider("colorTimerSlider", x, y+row*3, wide, high, 0, 1, 0.45f, act, bac, slider);
    loadSlider("colorSwapSlider", x, y+row*4, wide, high, 0, 1, 0.9f, act1, bac1, slider1);
    loadSlider("manualSlider", x, y+row*5, wide, high, 0, 1, 0.9f, act, bac, slider);

    loadSlider("strokeSlider", x, y+row*7, wide/2, high, 1, 5, 0, act1, bac1, slider1);
    loadSlider("wideSlider", x, y+row*8, wide/2, high, 1, 5, 0, act, bac, slider);
    loadSlider("highSlider", x, y+row*9, wide/2, high, 1, 5, 0, act1, bac1, slider1);

    loadSlider("smokeOnTime", x+140, y+row*7, wide/2, high, 1, 10, 3, act, bac, slider);
    loadSlider("smokeOffTime", x+140, y+row*8, wide/2, high, 0, 20, 10, act1, bac1, slider1);
    loadSlider("smokePumpValue", x+140, y+row*9, wide/2, high, 0, 1, 0.1f, act, bac, slider);

    /////////////////////////////// GLOBAL TOGGLE BUTTONS//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    this.x = this.width-65;
    this.wide = 20;
    this.high = 20;
    loadToggle("onTop", onTop, 1200, 45, wide, high, bac1, bac, slider);
    //loadToggle("glitchToggle", glitchToggle, x, y+35, wide, high, bac1, bac, slider);
    //loadToggle("roofBasic", roofBasic, x, y+70, wide, high, bac1, bac, slider);
    //loadToggle("syphonToggle", syphonToggle, x, y+105, wide, high, bac1, bac, slider);

    loadToggle("testToggle", testToggle, x, 10, 55, 55, bac1, bac, slider);
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    MCFinitialized = true;
  }
  public void draw() {
    background(0);
    //////////////////////////////// SHOW INFO ABOUT CURRENT RIG ARRAY SELECTION //////////////////////////////////////////////////////////////// 
    float x = 10;
    float y = 25;
    textAlign(LEFT);
    textSize(18);
    fill(360);
    int totalAnims=0;      
    for (Rig rig : rigs) totalAnims += rig.animations.size();
    text("# of anims: "+totalAnims, x, y+45);
    ///////////// rig info/ ///////////////////////////////////////////////////////////////////
    fill(rigg.flash, 300);
    text("rigViz: " + rigg.availableAnims[rigg.vizIndex], x, y);
    text("bkgrnd: " + rigg.availableBkgrnds[rigg.bgIndex], x, y+20);
    text("func's: " + rigg.availableFunctionEnvelopes[rigg.functionIndexA] + " / " + rigg.availableFunctionEnvelopes[rigg.functionIndexB], x+100, y);
    text("alph's: " + rigg.availableAlphaEnvelopes[rigg.alphaIndexA] + " / " + rigg.availableAlphaEnvelopes[rigg.alphaIndexB], x+100, y+20);
    /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
    ///// NEXT VIZ IN....
    x=250;
    fill(rigg.c, 300);
    fill(rigg.c, 100);
    String sec = nf(PApplet.parseInt(vizTime - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = PApplet.parseInt(vizTime - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(PApplet.parseInt(colTime - (millis()/1000 - rigg.colorTimer)) %60, 2, 0);
    min = PApplet.parseInt(colTime - (millis()/1000 - rigg.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+20);
    text("c-" + rigg.colorIndexA + "  " + "flash-" + rigg.colorIndexB, x, y+40);
    /////////////////////////////////////////////////// roof info ////////////////////////////////////////////////////////
    if (size.roofWidth > 0 && size.roofHeight > 0) {
      fill(rigg.c, 300);
      if (!roof.toggle) fill(rigg.c, 100);
      textSize(18);
      textAlign(RIGHT);
      x = size.roof.x+(size.roofWidth/2) - 130;
      text("roofViz: " + roof.availableAnims[roof.vizIndex], x, y);
      text("bkgrnd: " + roof.availableBkgrnds[roof.bgIndex], x, y+20);
      text("func's: " + roof.availableFunctionEnvelopes[roof.functionIndexA] + " / " + roof.availableFunctionEnvelopes[roof.functionIndexB], x+120, y);
      text("alph's: " + roof.availableAlphaEnvelopes[roof.alphaIndexA] + " / " + roof.availableAlphaEnvelopes[roof.alphaIndexB], x+120, y+20);
    }
    /////////////////////////////////////////////////// cans info ////////////////////////////////////////////////////////
    if (size.cansHeight > 0 && size.cansWidth > 0) {
      fill(rigg.c, 300);
      if (!cans.toggle) fill(rigg.c, 100);
      textSize(18);
      textAlign(RIGHT);
      x = size.cans.x+(size.cansWidth/2) - 130;
      text("cansViz: " + cans.availableAnims[cans.vizIndex], x, y);
      text("bkgrnd: " + cans.availableBkgrnds[cans.bgIndex], x, y+20);
      text("func's: " + cans.availableFunctionEnvelopes[cans.functionIndexA] + " / " + cans.availableFunctionEnvelopes[cans.functionIndexB], x+120, y);
      text("alph's: " + cans.availableAlphaEnvelopes[cans.alphaIndexA] + " / " + cans.availableAlphaEnvelopes[cans.alphaIndexB], x+120, y+20);
    }
    /*
     /////////////////////////////////////////////////// cans info ////////////////////////////////////////////////////////
     if (size.donutHeight > 0 && size.donutHeight > 0) {
     fill(rigg.c, 300);
     if (!donut.toggle) fill(rigg.c, 100);
     textSize(18);
     textAlign(LEFT);
     x = size.cans.x+(size.cansWidth/2) +25;
     text("donutViz: " + donut.vizIndex, x, y);
     text("bkgrnd: " + donut.bgIndex, x, y+20);
     text("func's: " + donut.functionIndexA + " / " + donut.functionIndexB, x+120, y);
     text("alph's: " + donut.alphaIndexA + " / " + donut.alphaIndexB, x+120, y+20);
     }
     */

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    sequencer(675, sliderY-20);
    pauseInfo(width-5, sliderY-15);
    dividerLines();
    fill(rigg.c);                              // divider for sliders
    // test for radio buttons
    rect(width/2, sliderY-7.5f, width, 1);
    fill(ctest);
    rect(1000, sliderY+30, 50, 50);
    fill(flashtest);
    rect(1080, sliderY+30, 50, 50);
  }
}

class SliderFrame extends ControlFrame {
  SliderFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super (_parent, _controlW, _controlH, _xpos, _ypos);
  }
  public void setup() {
    super.setup();
    surface.setAlwaysOnTop(onTop);
    //fullScreen();

    this.x = 10;
    this.y = 10;
    //this.wide = 150;
    //this.high = 20;

    int sliderWide = 150;
    int sliderHigh = 20;

    int gap = 25;

    for (int i =0; i<17; i+=2) {
      gap = 25;
      String name = "slider "+i;
      String name1 = "slider "+(i+1);
      loadSlider( name, x, y+(i*gap), sliderWide, sliderHigh, 0, 1, 0.32f, act1, bac1, slider1);
      loadSlider( name1, x, y+gap+(i*gap), sliderWide, sliderHigh, 0, 1, 0.32f, act, bac, slider);
    }
    SFinitialized = true;
  }
  public void draw() {
    surface.setAlwaysOnTop(onTop);
    background(0);
    dividerLines();

    //Envelopes visulization
    float y=500;
    float y1=200;
    x = 10;
    float dist = 15;
    int i=0;

    try {
      for (Anim anim : rigg.animations) {
        if (i<rigg.animations.size()-1) {
          fill(rigg.c1, 120);
        } else {
          fill(rigg.flash1, 300);
        }
        rect(20+(anim.alphaA*(this.width/2-32)), y+(dist*i), 10, 10);                // ALPHA A viz
        rect(this.width/2+12+(anim.alphaB*(this.width/2-32)), y+(dist*i), 10, 10);   // ALPHA B viz
        rect(20+(anim.functionA*(this.width/2-32)), y+(dist*i)+y1, 10, 10);                // FUNCTION A viz
        rect(this.width/2+12+(anim.functionB*(this.width/2-32)), y+(dist*i)+y1, 10, 10);   // FUNCTION B viz
        i+=1;
      }
    }
    catch (Exception e) {
      println(e);
      println("erorr on alpah / function  envelope visulization");
    }
    fill(rigg.flash1, 200);
    textAlign(LEFT);
    textSize(18);
    text("alph A : "+rigg.alphaIndexA, 12, y-12);
    text("alph B : "+rigg.alphaIndexB, this.width/2+12, y-12);
    rectMode(CORNER);
    rect(12, y - 5, 1, 150);
    rect(this.width/2-5, y - 5, 1, 150);
    rect(this.width/2+5, y - 5, 1, 150);
    rect(this.width-12, y - 5, 1, 150);
    rectMode(CENTER);


    fill(rigg.c1, 200);
    text("func A : "+rigg.functionIndexA, 12, y-12+y1);
    text("func B : "+rigg.functionIndexB, this.width/2+12, y-12+y1);
    rectMode(CORNER);
    rect(12, y - 5 + y1, 1, 150);
    rect(this.width/2-5, y - 5+y1, 1, 150);
    rect(this.width/2+5, y - 5+y1, 1, 150);
    rect(this.width-12, y - 5+y1, 1, 150);
    rectMode(CENTER);
  }
}

class ControlFrame extends PApplet {
  int controlW, controlH, wide, high, xpos, ypos;
  float clm, row, sliderY, x, y;
  PApplet parent;
  ControlP5 cp5;
  public ControlFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super();   
    parent = _parent;
    controlW=_controlW;
    controlH=_controlH;
    xpos = _xpos;
    ypos = _ypos;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  public void settings() {
    size(controlW, controlH);
    fullScreen();
  }
  public void setup() {
    this.surface.setSize(controlW, controlH);
    this.surface.setAlwaysOnTop(onTop);
    this.surface.setLocation(xpos, ypos);
    colorMode(HSB, 360, 100, 100);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();
    cp5 = new ControlP5(this);
    cp5.getProperties().setFormat(ControlP5.SERIALIZED);
    wide = 80;           // x size of sliders
    high = 14;           // y size of slider
    row = high +4;       // distance between rows
    clm = 210;
  }
  public void draw() {
    /// override in subclass
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void loadSlider(String label, float x, float y, int wide, int high, float min, float max, float startVal, int act1, int bac1, int slider1) {
    cp5.addSlider(label)
      .plugTo(parent, label)
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(min, max)
      .setValue(startVal)    // start value of slider
      .setColorActive(color(act1, 200)) 
      .setColorBackground(color(bac1, 200)) 
      .setColorForeground(color(slider1, 200)) 
      ;
  }
  public void loadToggle(String label, Boolean toggle, float x, float y, int wide, int high, int bac1, int bac, int slider) {
    cp5.addToggle(label)
      .plugTo(parent, label)
      .setPosition(x, y)
      .setSize(wide, high)
      .setValue(toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(act) 
      ;
  }
  //////////////////////////////////////// CALL BACK FOR SLIDER CONTROL FROM OTHER VARIABLES
  // an event from slider sliderA will change the value of textfield textA here
  public void rigDimmer(float theValue) {
    int value = PApplet.parseInt(map(theValue, 0, 1, 0, 127));
    LPD8bus.sendControllerChange(0, 4, value) ;
  }
  public void dividerLines() {
    fill(rigg.c, 100);                         // box around the outside
    rect(width/2, height-1, width, 1);  
    rect(width/2, 1, width, 1);                              
    rect(0, height/2, 1, height);
    rect(width-1, height/2, 1, height);
  }
  public void sequencer(float x, float y) {
    int dist = 20;
    fill(rigg.flash, 100);
    for (int i = 0; i<(16); i++) rect(10+i*dist+x, y, 10, 10);
    fill(rigg.c);
    for (int i = 0; i<(16); i++) if (PApplet.parseInt(beatCounter%(16)) == i) rect(10+i*dist+x, y, 10, 10);
  }
  public void pauseInfo(float x, float y) {
    if (pause > 0) { 
      textAlign(RIGHT);
      textSize(20); 
      fill(300+(60*stutter));
      text(pause*10+" sec NO AUDIO!!", x, y); //
    }
  }
  int ctest, flashtest;
  public void controlEvent(ControlEvent theEvent) {
    int intValue = PApplet.parseInt(theEvent.getValue());
    float value = theEvent.getValue();
    //float[] arrayValue = theEvent.getArrayValue();
    int someDelay = 120; // silence at startup
    for (Rig rig : rigs) {                        
      if (theEvent.isFrom(rig.ddVizList)) {
        if (frameCount > someDelay)    println(rig.name+" viz selected "+intValue);
        rig.vizIndex = intValue;
        //println(arrayValue);
      }
      if (theEvent.isFrom(rig.ddBgList)) {
        if (frameCount > someDelay)    println(rig.name+" background selected "+intValue);
        rig.bgIndex = intValue;
      }
      if (theEvent.isFrom(rig.ddAlphaList)) {
        if (frameCount > someDelay)    println(rig.name+" alpahA selected "+intValue);
        rig.alphaIndexA = intValue;
      }
      if (theEvent.isFrom(rig.ddFuncList)) {
        if (frameCount > someDelay)   println(rig.name+" funcA selected "+intValue);
        rig.functionIndexA = intValue;
      }
      if (theEvent.isFrom(rig.ddAlphaListB)) {
        if (frameCount > someDelay)  println(rig.name+" alpahB selected "+intValue);
        rig.alphaIndexB = intValue;
      }
      if (theEvent.isFrom(rig.ddFuncListB)) {
        if (frameCount > someDelay)   println(rig.name+" funcB selected "+intValue);
        rig.functionIndexB = intValue;
      }
      try {
        if (intValue >= 0) {
          if (theEvent.isFrom(rig.flashRadioButton)) {
            if (frameCount > someDelay)     println(rig.name+" C plugged to index: "+intValue);
            rig.colorIndexB = intValue;
          }
          if (theEvent.isFrom(rig.cRadioButton)) {
            if (frameCount > someDelay)     println(rig.name+" FLASH plugged to index: "+intValue);
            rig.colorIndexA = intValue;
          }
        }
      }
      catch (Exception e) {
        println(e);
        println("*** !!COLOR PLUGGING WRONG!! ***");
      }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (theEvent.isController()) {
      if (frameCount > someDelay)   println("- controller "+theEvent.getController().getName()+" "+theEvent.getValue());

      try {
        if (theEvent.getController().getName().startsWith("slider")) {
          String name = theEvent.getController().getName();
          setCCfromController(name, value);
        }
      }
      catch (Exception e) {
        println(e);
        println("*** !!SOMETHING WRONG WITH YOUR SLIDER MAPPING YO!! ***");
      }
    }
    //if (theEvent.isGroup()) println("- group "+theEvent.getName()+" "+theEvent.getValue());
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
}

public void setCCfromController(String name, float value) {
  int ones = PApplet.parseInt(name.substring(7, 8));
  int tens = 0;
  if (name.length() > 8) {
    tens = PApplet.parseInt(name.substring(7, 8));
    ones = PApplet.parseInt(name.substring(8, 9));
  }
  int  index = tens * 10 + ones + 40;
  cc[index] = value;

  int someDelay = 120; // silence at startup
  if (frameCount > someDelay) println("set cc["+index+"]", value);
}







/* // old sliders 
 
 x+=clm;
 //////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////// FOURTH coloum of sliders ///////////////////////////////////////
 
 cp5.addSlider("bgNoiseSlider")
 .plugTo(parent, "bgNoiseSlider")
 .setPosition(x, y+row*2)
 .setSize(wide, high)
 //.setFont(font)
 .setRange(0, 1)
 .setValue(0.3) // start value of slider
 .setColorActive(act1) 
 .setColorBackground(bac1) 
 .setColorForeground(slider1) 
 ;
 cp5.addSlider("bgNoiseBrightnessSlider")
 .plugTo(parent, "bgNoiseBrightnessSlider")
 .setPosition(x, y+row*3)
 .setSize(wide, high)
 //.setFont(font)
 .setRange(0, 1)
 .setValue(0.5) // start value of slider
 .setColorActive(act) 
 .setColorBackground(bac) 
 .setColorForeground(slider) 
 ;    
 cp5.addSlider("bgNoiseDensitySlider")
 .plugTo(parent, "bgNoiseDensitySlider")
 .setPosition(x, y+row*4)
 .setSize(wide, high)
 //.setFont(font)
 .setRange(0, 1)
 .setValue(0.1) // start value of slider
 .setColorActive(act1) 
 .setColorBackground(bac1) 
 .setColorForeground(slider1) 
 ;
 
 */
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

/////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
float sineFast, sineSlow, sine, stutter, shimmer;
float timer[] = new float[6];
public void globalFunctions() {
  float tm = 0.05f+(noize/50);
  for (int i = 0; i<timer.length; i++) timer[i] += tm;
  timer[3] += (0.3f*5);
  timer[5] *=1.2f;
  sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
  if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  shimmer = (shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
  noize();
  oskPulse();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// BEAT DETECT THROUGHOUT SKETCH //////////////////////////////////////////////////////////////////////////
int beatCounter, pauseTriggerTime=360;
long beatTimer;
boolean beatTrigger;
float beat, avgmillis;
public void resetbeats() {
  weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
  weightedcnt=1+(1-beatAlpha)*weightedcnt;
  avgtime=weightedsum/weightedcnt;
  avgmillis = avgtime*1000/frameRate;
  beatTimer=0;
}
///////////////////////////////////////// BEATS /////////////////////////////////////////////////////////////////////
public void beats() {            
  beatTimer++;
  beatAlpha=0.2f; //this affects how quickly code adapts to tempo changes 0.2 averages the last 10 onsets  0.02 would average the last 100
  beatTrigger = false;
  if (beatDetect.isOnset()) beatTrigger = true;
  // trigger beats without audio input
  if (pause > 1) {
        if ((millis() % pauseTriggerTime) == 0){
          beatTrigger = true;
          pauseTriggerTime = PApplet.parseInt(random(360, 750));
        }
  }
    
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (beatTrigger) {
    beat = 1;
    beatCounter = (beatCounter + 1) % 120;
    resetbeats();
  }
  if (avgtime>0) beat*=pow(beatSlider, (1/avgtime));       //  changes rate alpha fades out!!
  else beat*=0.95f;
  float end = 0.001f;
  if (beat < end) beat = end;
}
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
int pause, pauseTimer;
public void pause(int secondsToWait) {
  if (beatDetect.isOnset()) {
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
public void boothLights() {
  fill(0);
  rect(opcGrid.booth.x, opcGrid.booth.y, 40, 15);
  rect(opcGrid.dig.x, opcGrid.dig.y, 40, 15);
  fill(0, 150);
  strokeWeight(1);
  stroke(rigg.flash, 60);
  rect(opcGrid.booth.x+70, opcGrid.booth.y, 200, 30);
  noStroke();
  fill(rigg.flash1, 360*boothDimmer);
  rect(opcGrid.booth.x, opcGrid.booth.y, 40, 15);
  fill(rigg.flash1, 360*digDimmer);
  rect(opcGrid.dig.x, opcGrid.dig.y, 40, 15);

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(rigg.c, 360);
  textAlign(LEFT);
  textSize(16);
  text("BOOTH", opcGrid.booth.x+25, opcGrid.booth.y+6);
  text("DIG", opcGrid.dig.x+25, opcGrid.dig.y+6);
}
/////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
public void testColors(boolean _test) {
  if (_test) {

    fill((millis()/50)%360, 100, 100, 360*rigg.dimmer); 
        for(Rig rig : rigs)     rect(rig.size.x, rig.size.y, rig.wide,rig.high);

   
    rect(opcGrid.booth.x, opcGrid.booth.y, 30, 10);
    rect(opcGrid.dig.x, opcGrid.dig.y, 30, 10);
  }
}
/////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
public void workLights(boolean _work) {
  if (_work) {
    pause = 10;
    fill(360*cc[9], 360*cc[10]);
    rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    rect(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    rect(size.cans.x, size.cans.y, size.cansWidth, size.cansHeight);
    rect(opcGrid.booth.x, opcGrid.booth.y, 30, 10);
    rect(opcGrid.dig.x, opcGrid.dig.y, 30, 10);
  }
}
/////////////////////////////////////////////// OSKP///////////////////////////////////////////
float osk1, oskP, timer1;
public void oskPulse() {
  osk1 += 0.01f;               
  timer1 = log(map (sin(osk1), -1, 1, 0.1f, 10000));
  timer1 += timer1;
  oskP = map(sin(timer1), -1, 1, 0, 1);
}

////////////////////////////////////////////// NOIZE ////////////////////////////////////////////
float noize, noize1, noize2, noize12;
public void noize() {
  float dx = millis() * 0.0001f;
  float z = millis() * 0.0001f;
  noize = sin(10 * (noise(dx * 0.01f, 0.01f, z) - 0.4f));
  noize2 = cos(10 * (noise(dx * 0.01f, 0.01f, z/1.5f) - 0.4f));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}

public void bgNoise(PGraphics layer, int _col, float bright, float fizzyness) {
  int col=color(hue(_col), saturation(_col), 100*bright);
  layer.loadPixels();
  for (int x=0; x<layer.width; x++) {
    for (int y=0; y<layer.height; y++) {
      int pixel=layer.pixels[x+y*layer.width];
      //col=int(random(255*alpha))<<24 | col&0xffffff;
      int out;
      if (random(1.0f)<fizzyness) {
        out=col;
      } else {
        out=pixel;
      }
      layer.pixels[x+y*layer.width]=out;
    }
  }
  layer.updatePixels();
}
/* KEY FUNCTIONS
 
 'c' steps through one of the colours
 'v' steps theough the other colour - current and upcoming colours are displayed in small boxes below the main animation
 'b' steps the animations backwards 
 'n' steps the animations forward
 'm' changes the backgrounds
 ',' changes the function
 '.' changes the alpha
 'l' toggle colour change on beat
 ';' toggle swaps color c/flash
 ''' swaps color c/flash - press and hold
 '\' color swap
 '[' viz hold - stops the timer counting down for next viz change
 ']' color hold - stops the timer counting down for next colour change
 'q' toggles mouse coordiantes and moveable dot
 't' toggle TEST - cycles though all colours to test LEDs
 'w' toggle WORK LIGHTS - all WHITE 
 
 */
public void onScreenInfo() {
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////
  mouseInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  dividerLines();
}
public void pauseInfo() {
  //pause = 0;
  if (pause > 0) { 
    float x = 400;
    float y = 30;
    textAlign(RIGHT);
    textSize(20); 
    fill(300);
    text(" sec NO AUDIO!!", x, y); //pause*10+
  }
}
public void mouseInfo(boolean _info) {
  if (_info) {
    /////// DISPLAY MOUSE COORDINATES
    textAlign(LEFT);
    fill(360);  
    ellipse(mouseX, mouseY+10, 10, 10);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, mouseX, mouseY );
    /////  LABLELS to show what PVectors are what 
    textSize(12);
    textAlign(CENTER);
  }
}
public void cordinatesInfo(Rig rig, boolean _info) {
  if (_info) {
    textSize(12);
    textAlign(CENTER);
    fill(360);  
    for (int i = 0; i < rig.position.length; i++) text(i, rig.size.x-(rig.wide/2)+rig.position[i].x, rig.size.y-(rig.high/2)+rig.position[i].y);   /// mirrors Position info
    fill(200);  
    for (int i = 0; i < rig.positionX.length; i++) {
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][0].x, rig.size.y-(rig.high/2)+rig.positionX[i][0].y);   /// mirrors Position info
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][1].x, rig.size.y-(rig.high/2)+rig.positionX[i][1].y);   /// mirrors Position info
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][2].x, rig.size.y-(rig.high/2)+rig.positionX[i][2].y);   /// mirrors Position info
    }
  }
}
public void dividerLines() {
  fill(rigg.flash);
  rect(size.rigWidth, height/2, 1, height);                     ///// vertical line to show end of rig viz area
  rect(size.rig.x, size.rigHeight, size.rigWidth, 1);             //// horizontal line to divide landscape rig / roof areas
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);      ///// vertical line to show end of roof viz area
  rect(size.roof.x, size.roofHeight, size.roofWidth, 1);             //// horizontal line to divide landscape rig / roof areas
  // box around the outside
  fill(rigg.flash, 100);   
  rect(width/2, height-1, width, 1);  
  rect(width/2, 1, width, 1);                              
  rect(0, height/2, 1, height);
  rect(width-1, height/2, 1, height);
}

public void frameRateInfo(float x, float y) {
  fill(0, 150);
  strokeWeight(1);
  stroke(rigg.flash, 60);
  rect(x+28, y-5, 75, 30);
  noStroke();
  textAlign(LEFT);
  textSize(18);
  fill(360);  
  text(PApplet.parseInt(frameRate) + " fps", x, y); // framerate display
  //frame.setTitle(int(frameRate) + " fps"); //framerate as title
}
public void toggleKeysInfo() {
  textSize(18);
  textAlign(RIGHT);
  float y = 180;
  float x = width-5;
  fill(50);
  if (vizHold)  fill(300+(60*stutter));
  text("[ = VIZ HOLD", x, y);
  fill(50);
  if (colHold) fill(300+(60*stutter));
  text("] = COL HOLD", x, y+20);
  y +=20;
  fill(50);
  if (keyT['p']) fill(300+(60*stutter));
  text("P = shimmer", x, y+40);
  fill(50);
  if (!rigg.colSwap) fill(300+(60*stutter));
  text("O = color swap", x, y+60);
  fill(50);
  if (rigg.colFlip) fill(300+(60*stutter));
  text("I / U = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("Y = color beat", x, y+100);
  y+=20;
  fill(50);
}
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
      rigWidth = 900;                                    // WIDTH of rigViz
      if (SHITTYLAPTOP) rigWidth = 600;
      rigHeight = 350;    
      if (SHITTYLAPTOP) rigHeight = 250;
      rig = new PVector(rigWidth/2, (rigHeight/2));   // cordinates for center of rig
      break;
    }

    ////////////////////////////////  CANS SETUP UNDER RIG ///////////////////////
    cansWidth = rigWidth;
    cansHeight = 250;
    if (SHITTYLAPTOP) cansHeight = 250;
    cans = new PVector (rig.x, rigHeight+(cansHeight/2));

    ////////////////////////////////  ROOF SETUP RIGHT OF RIG ///////////////////////
    roofWidth = 300;
    roofHeight = rigHeight+cansHeight;
    roof = new PVector (rigWidth+(roofWidth/2), roofHeight/2);

    /////////////////////////////////////////////////////////////////////////////////////
    parsWidth = 120;
    parsHeight = rigHeight+cansHeight;
    pars = new PVector(rigWidth+roofWidth+(parsWidth/2),parsHeight/2);                        //( (rig.x + (rigHeight/2)) + (cans.x+(cansHeight/2)) + (parsHeight/2), parsWidth/2);


    sizeX = rigWidth+roofWidth+parsWidth;
    sizeY = rigHeight+cansHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
public void midiSetup() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  beatStepBus = new MidiBus(this, "Arturia BeatStep", "Arturia BeatStep"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
}

//////////////////////////////////////// LOAD IMAGES ///////////////////////////
PImage bar1, flames; 
public void loadImages() {
  flames = loadImage("1.jpg");
  bar1 = loadImage("bar1.png");
}
//////////////////////////// AUDIO SETUP ////////////////////////////////////







Minim minim;
AudioInput in;
BeatDetect beatDetect;
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
public void audioSetup(int sensitivity) {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);

  beatAlpha=0.2f;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  weightedsum=0;
  weightedcnt=0;
  avgtime=0;
  avgvolume = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
AudioPlayer player[];
public void loadAudio() {
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
public void drawingSetup() {

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
public void loadShaders() {
  float blury = PApplet.parseInt(map(blurSlider, 0, 1, 0, 100));
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "pickle_mirrors_dec_19" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
