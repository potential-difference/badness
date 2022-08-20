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

public class shields extends PApplet {

WLED wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls, wledSeedsA, wledSeedsB;
OPC opcLocal;




ControlP5 main_cp5;

boolean SHITTYLAPTOP=false;//false;

final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ShieldsOPCGrid shieldsGrid;
ControlFrame controlFrame;

Rig rigg, roof, cans, strips, donut, seeds, pars;
ArrayList <Rig> rigs = new ArrayList<Rig>();  
PFont font;

       // shorthand names for each control on the TR8


OscP5 oscP5[] = new OscP5[4];

  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep
MidiBus MPD8bus;

String controlFrameValues, mainFrameValues;

boolean onTop = false;
boolean MCFinitialized, SFinitialized;
public void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings();
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

  rigg = new Rig(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");
  opcGrid = new OPCGrid();

  ///////////////// LOCAL opc /////////////////////
  wledBigShield = new WLED(this, "192.168.8.10", 21324);
  wledShieldA = new WLED(this, "192.168.8.11", 21324);
  wledShieldB = new WLED(this, "192.168.8.12", 21324);
  wledShieldC = new WLED(this, "192.168.8.13", 21324);
  wledShieldD = new WLED(this, "192.168.8.14", 21324);
  wledShieldE = new WLED(this, "192.168.8.15", 21324);
  wledShieldF = new WLED(this, "192.168.8.16", 21324);
  wledBalls   = new WLED(this, "192.168.8.17", 21324);

  wledSeedsA   = new WLED(this, "192.168.10.20", 21324);
  wledSeedsB   = new WLED(this, "192.168.10.21", 21324);

  shieldsGrid = new ShieldsOPCGrid(rigg);  

  OPC[] shieldOPCs = {wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls};
  shieldsGrid.spiralShieldsOPC(shieldOPCs);        // SHIELDS plug into RIGHT SLOTS A-F = 1-6 *** BIG SHIELD = 7 *** H-G = LEFT SLOTS 0-2 ***

  opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS
  opcGrid.dmxSmokeOPC(opcLocal) ;

  audioSetup(100, 0.2f); ///// AUDIO SETUP - sensitivity, beatTempo /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  setupSpecifics();

  frameRate(30); // always needs to be last in setup
}
int colStepper = 1;
int time_since_last_anim=0;
public void draw()
{
  rigg.dimmer = 1;
  rigg.alphaRate = 0.5f;
  rigg.funcRate = 0.5f;
  vizTime = 0.5f;
  colorTime = 0.5f;

  int start_time = millis();
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  //pause(10);           ////// number of seconds before no music detected and auto kicks in
  globalFunctions();

  if (frameCount > 10) playWithYourself(vizTime*60);
  c = rigg.c;
  flash = rigg.flash;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  if (beatTrigger) { 
    for (Rig rig : rigs) {
            //if (testToggle) rig.animations.add(new Test(rig));
        //println(rig.name+" vizIndex", rig.vizIndex);
        rig.addAnim(rig.vizIndex);  // create a new anim object and add it to the beginning of the arrayList
      }
  }

  if (keyT['s']) for (Anim anim : rigg.animations)  anim.funcFX = 1-(stutter*noize1*0.1f);
 
  //////////////////// Must be after playwithme, before rig.draw()////
  for (Rig rig : rigs) rig.draw();  
  //////////////////////////////////////////// PLAY WITH ME MORE /////////////////////////////////////////////////////////////////////////////////
  playWithMeMore();
  //////////////////////////////////////////// BOOTH & DIG ///////////////////////////////////////////////////////////////////////////////////////
  //boothLights();
  //////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////
  workLights(keyT['w']);
  testColors(keyT['t']);
  //////////////////////////////////////////// !!!SMOKE!!! ///////////////////////////////////////////////////////////////////////////////////////
  //dmxSmoke();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  mouseInfo(keyT['q']);
  onScreenInfo();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void setupSpecifics() {

  rigg.availableAnims = new int[] {1, 2, 3, 6, 7, 8};      // setup which anims are used on which rig here
  rigg.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
  rigg.availableFunctionEnvelopes = new int[] {0, 1, 2};  
  rigg.availableBkgrnds = new int[] {0, 1, 10, 11, 12, 13, 14};
  
  //rigg.availableColors = new int[] { 0, 1, 2, 3, 4, 13, 10, 11, 12, 2, 3};
  //roof.availableColors = rigg.availableColors; // = new int[] { 0, 1, 2, 3, 4, 13, 10, 11, 12, 2, 3};

  ///////////////////////////////// UPDATE THE DROPDOWN LISTS WITH AVLIABLE OPTIONS ///////////////////////////////////////////////////////
  
  for (Rig rig : rigs) {    
    // rig.ddVizList.clear();
    // rig.ddBgList.clear();
    // rig.ddAlphaListA.clear();
    // rig.ddAlphaListA.clear();
    // rig.ddFuncListB.clear();
    // rig.ddFuncListB.clear();
    for (int i=0; i<rig.availableBkgrnds.length; i++) { 
      int index = rig.availableBkgrnds[i];
      //rig.ddBgList.addItem(rig.backgroundNames[index], index); //add all available anims to VizLists -
      // rig.ddBgList.addItem("backround  "+index, index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableAnims.length; i++) {
      int index = rig.availableAnims[i];
      //rig.ddVizList.addItem(rig.animNames[index], index); //add all available anims to VizLists -
      // rig.ddVizList.addItem("viz  "+index, index); //add all available anims to VizLists -
    }
    
     
    for (int i=0; i<rig.availableAlphaEnvelopes.length; i++) {
      int index = rig.availableAlphaEnvelopes[i];
      // rig.ddAlphaListA.addItem("alph  "+index, index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableAlphaEnvelopes.length; i++) {
      int index = rig.availableAlphaEnvelopes[i];
      // rig.ddAlphaListB.addItem("alph  "+index, index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableFunctionEnvelopes.length; i++) {
      int index = rig.availableFunctionEnvelopes[i];
      // rig.ddFuncListA.addItem("func  "+index, index); //add all available anims to VizLists -
    }
    for (int i=0; i<rig.availableFunctionEnvelopes.length; i++) {
      int index = rig.availableFunctionEnvelopes[i];
      // rig.ddFuncListB.addItem("func  "+index, index); //add all available anims to VizLists -
    } 
    //need to use the actal numbers from the above aray
  }

  //rigg.dimmers.put(3, new Ref(cc, 34));

  rigg.vizIndex = 2;
  rigg.functionIndexA = 0;
  rigg.functionIndexB = 1;
  rigg.alphaIndexA = 0;
  rigg.alphaIndexB = 1;
  rigg.bgIndex = 0;

  rigg.colorIndexA = 2;
  rigg.colorIndexB = 1;
 
  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75f;
  cc[2] = 0.75f;
  cc[5] = 0.3f;
  cc[6] = 0.75f;
  cc[4] = 1;
  cc[8] = 1;

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
    alphaRate = rig.manualAlpha;
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
    alphaRate=rig.manualAlpha;
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
    alphaRate=rig.manualAlpha;
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    window.endDraw();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class StarMesh extends Anim {
  StarMesh ( Rig _rig) {
    super (_rig);
    animName = "starMesh";
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = (rig.high+rig.wide)/2/20*strokeSlider;
    //println("function A", functionA);
    wide = (10+(functionA*rig.wide*1.5f));
    high = (10+((1-functionA)*rig.high*1.5f));
    rotate = -30*functionB;
    star(position[3].x, position[3].y, col1, stroke, wide, high, rotate, alphaA);
    star(position[4].x, position[4].y, col1, stroke, wide, high, rotate, alphaA);
    star(position[5].x, position[5].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Celtic extends Anim {
  Celtic (Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 10+((rig.high+rig.wide)/2/20*strokeSlider); //16+(10*func1);
    wide = (10+(rig.wide-(rig.wide*functionA-20)))*wideSlider;
    high = wide;
    rotate = 0;
    donut(positionX[8][0].x, positionX[8][0].y, col1, stroke, wide, high, rotate, alphaA);
    donut(positionX[5][0].x, positionX[5][0].y, col1, stroke, wide, high, rotate, alphaA);
    donut(positionX[2][0].x, positionX[2][0].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}

class SpiralFlower extends Anim {
  SpiralFlower(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    stroke = (rig.high+rig.wide)/2/20*strokeSlider;
    wide = (rig.wide)-(rig.wide/10);
    wide = 5+(wide-(wide*functionA)); //100+(20*i); //
    high = wide;
    rotate = 0;

    donut(positionX[1][1].x, positionX[1][1].y, col1, stroke, wide, high, rotate, alphaA);
    donut(positionX[4][1].x, positionX[4][1].y, col1, stroke, wide, high, rotate, alphaA);
    donut(positionX[7][1].x, positionX[7][1].y, col1, stroke, wide, high, rotate, alphaA);

    donut(positionX[0][2].x, positionX[0][2].y, col1, stroke, wide, high, rotate, alphaB);
    donut(positionX[3][2].x, positionX[3][2].y, col1, stroke, wide, high, rotate, alphaB);
    donut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, rotate, alphaB);

    wide = (rig.wide/3.5f)-(rig.wide/10);
    wide = 10+(wide-(wide*(1-functionA))); 
    high = wide;
    donut(viz.x, viz.y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}

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
    stroke = 15+((rig.high+rig.wide)/2/20*functionA)+(10*strokeSlider);
    wide = vizWidth*1.2f;
    wide = wide-(wide*functionA);
    high = wide*2;
    rotate = 120*noize*functionB;

    wide *=wideSlider;
    high *=highSlider;

    donut(position[0].x, position[0].y, col1, stroke, wide, high, -rotate, alphaA);
    donut(position[1].x, position[1].y, col1, stroke, wide, high, -rotate-60, alphaA);
    donut(position[2].x, position[2].y, col1, stroke, wide, high, -rotate+60, alphaA);
    stroke = 15+((rig.high+rig.wide)/2/20*functionB*oskP)+(10*strokeSlider);
    wide = vizWidth*1.2f;
    wide = wide-(wide*functionB);
    high = wide*2;
    rotate = -120*noize*functionA;

    wide *=wideSlider;
    high *=highSlider;

    donut(position[6].x, position[6].y, col1, stroke, wide, high, rotate, alphaB);
    donut(position[7].x, position[7].y, col1, stroke, wide, high, rotate-60, alphaB);
    donut(position[8].x, position[8].y, col1, stroke, wide, high, rotate+60, alphaB);
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
    wide = 2+(functionA*vizWidth*1.5f);
    high = 2+(functionB*vizHeight*1.5f);
    stroke = 15+(30*functionA);
    rotate = 30+(30*functionB);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    star(positionX[1][2].x, positionX[1][2].y, col1, stroke, wide, high, -rotate, alphaA);
    star(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, -rotate, alphaA);
    star(positionX[7][2].x, positionX[7][2].y, col1, stroke, wide, high, -rotate, alphaA);

    stroke = 12+(10*functionA);
    wide = 5+(shieldsGrid.bigShieldRad*1.2f*(1-functionB));
    high = wide;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaB);
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
class TwistedStar extends Anim {
  TwistedStar(Rig _rig) {
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    stroke = 10+((rig.high+rig.wide)/2/20*functionB);
    wide = shieldsGrid.bigShieldRad/2+(functionA*rig.wide*1.2f);
    high = shieldsGrid.bigShieldRad/2+((1-functionA)*rig.high*1.2f);

    float wideB = shieldsGrid.bigShieldRad/2+(functionB*rig.high*1.2f);
    float highB = shieldsGrid.bigShieldRad/2+((1-functionB)*rig.wide*1.2f);
    rotate = 60*functionA;
    //void star(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    starNine(viz.x, viz.y, col1, stroke, wide, high, wideB, highB, 40+rotate, alphaA, alphaB); 
    //10+(beats[i]*mw), 110-(pulzs[i]*mh), -60*beats[i], col1, stroke, alpha[i]/4*alf*dimmer);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SingleDonut extends Anim {
  SingleDonut(Rig _rig) {            
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = 10+(rig.wide*1.2f*(1-functionB));
    high = 10+(rig.high*1.2f*(1-functionB));
    ;
    stroke = (rig.high+rig.wide)/2/15*strokeSlider;
    wide *=wideSlider;
    high *=highSlider;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BouncingDonut extends Anim {
  int beatcounted;
  int numberofanims;
  BouncingDonut(Rig _rig) {            
    super(_rig);
    numberofanims = rig.animations.size();
    beatcounted = (_beatCounter % (numberofanims+1));
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = rig.wide*1.2f-(rig.wide*1.2f*functionA*((beatcounted+1)));
    high = rig.high*1.2f-(rig.high*1.2f*functionA*((beatcounted+1)));
    ;
    stroke = (rig.high+rig.wide)/2/15*strokeSlider;
    wide *=wideSlider;
    high *=highSlider;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BouncingPolo extends Anim {
  int beatcounted;
  int numberofanims;
  BouncingPolo(Rig _rig) {            
    super(_rig);
    numberofanims = rig.animations.size();
    beatcounted = (_beatCounter % (numberofanims+1));
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = (rig.wide*1.2f*functionA*((beatcounted+1)));
    high = (rig.high*1.2f*functionA*((beatcounted+1)));
    ;
    stroke = wide*functionA;
    wide *=wideSlider;
    high *=highSlider;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA); 
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Polo extends Anim {
  Polo(Rig _rig) {            
    super(_rig);
  }
  public void draw() {
    window.beginDraw();
    window.background(0);
    wide = rig.wide*1.2f*(1-functionA);
    high = rig.high*1.2f*(1-functionA);
    ;
    stroke = wide*functionA;
    wide *=wideSlider;
    high *=highSlider;
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
  float overalltime;
  float strokeSlider, wideSlider, highSlider;

  Anim(Rig _rig) {
    animDimmer=new Ref(new float[]{1.0f}, 0);
    rig = _rig;
    alphaRate = rig.alphaRate;
    funcRate = rig.funcRate;
    _beatCounter = (int)beatCounter;
    col1 = white;
    col2 = white;
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

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    overalltime = avgmillis;

    alphaEnvelopeA = envelopeFactory(rig.availableAlphaEnvelopes[rig.alphaIndexA], rig, overalltime);
    alphaEnvelopeB = envelopeFactory(rig.availableAlphaEnvelopes[rig.alphaIndexB], rig, overalltime);
    //if(functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexA], rig) != NaN)
    functionEnvelopeA = functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexA], rig);
    functionEnvelopeB = functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexB], rig);

    strokeSlider = rig.strokeSlider;
    wideSlider = rig.wideSlider;
    highSlider = rig.highSlider;
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
    alphaB *=rig.dimmer;

    Float funcX = functionEnvelopeA.value(now);
    if (!Float.isNaN(funcX)) functionA = funcX; 
    //functionEnvelopeA.value(now); 

    Float funcZ = functionEnvelopeB.value(now);
    if (!Float.isNaN(funcZ)) functionB = funcZ;
    //functionB = functionEnvelopeB.value(now);

    //println("functionA "+functionA,"alphaA "+alphaA, "rigdimmer " +rigg.dimmer);

    if (alphaEnvelopeA.end_time<now && alphaEnvelopeB.end_time<now) deleteme = true;  // only delete when all finished


    this.draw();

    
    blurPGraphics();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    try {
      this.window.strokeWeight(-stroke);
      this.window.stroke(360*alph);
      this.window.noFill();
      this.window.pushMatrix();                      //  ERROR too many calls to push matrix
      this.window.translate(xpos, ypos);
      this.window.rotate(radians(rotate));
      this.window.ellipse(0, 0, wide, high);         //  ERROR neagtive array size exception
      this.window.rotate(radians(120));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(120));
      this.window.ellipse(0, 0, wide, high);
      this.window.popMatrix();
    }  
    catch(Exception e) {
      println(wide, high);
      //NegativeArraySizeException();
      String message = e.getMessage();
      Throwable cause = e.getCause();
      println("message:", e, "cause", cause);
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void starNine(float xpos, float ypos, int col, float stroke, float wide, float high, float wideB, float highB, float rotate, float alph, float alphB) {
    try {
      int rot = 36;
      this.window.strokeWeight(-stroke);
      this.window.stroke(360*alph);
      this.window.noFill();
      this.window.pushMatrix();                      //  ERROR too many calls to push matrix
      this.window.translate(xpos, ypos);
      this.window.rotate(radians(rotate));
      this.window.ellipse(0, 0, wide, high);         //  ERROR neagtive array size exception
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.popMatrix();
    }  
    catch(Exception e) {
      println(wide, high);
      //NegativeArraySizeException();
      String message = e.getMessage();
      Throwable cause = e.getCause();
      println("message:", e, "cause", cause);
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  public void starNineA(float xpos, float ypos, int col, float stroke, float wide, float high, float wideB, float highB, float rotate, float alph, float alphB) {
    try {
      this.window.strokeWeight(-stroke);
      this.window.stroke(360*alph);
      this.window.noFill();
      this.window.pushMatrix();                      //  ERROR too many calls to push matrix
      this.window.translate(xpos, ypos);
      this.window.rotate(radians(rotate));
      this.window.ellipse(0, 0, wide, high);         //  ERROR neagtive array size exception
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.popMatrix();
    }  
    catch(Exception e) {
      println(wide, high);
      //NegativeArraySizeException();
      String message = e.getMessage();
      Throwable cause = e.getCause();
      println("message:", e, "cause", cause);
    }
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
  Envelope dwnrmp = new Ramp(t+attack_time.intValue()+sustain_time.intValue(), t+attack_time.intValue()+sustain_time.intValue()+decay_time.intValue(), 1.0f, decay_curv, 0.01f);
  return upramp.mul(dwnrmp);
}

public Envelope SimpleRamp(Number ramp_time, float start_val, float final_val, Number ramp_curv) {
  //Envelope = new Ramp( STARTTIME , DURATION , STARTVALUE , ** vlaues here create curve ** , FINALVALUE );
  float start_time = millis();
  float end_time = start_time+ramp_time.intValue();
  return new Ramp(start_time, end_time, start_val, ramp_curv, final_val);
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
public Envelope envelopeFactory(int envelope_index, Rig rig, float overalltime) {
  float alphaRate = rig.alphaRate*10;
  //float overalltime = avgmillis;

  switch (envelope_index) {
  case 0: 
    // BEATZ
    return CrushPulse(0.05f, 0.0f, 1.0f, overalltime*(alphaRate+0.5f), 0.0f, 0.0f);
    //CrushPulse(0.031, 0.040, 0.913, avgmillis*rig.alphaRate*15+0.5, 0.0, 0.0);
  case 1:
    // PULZ
    return CrushPulse(1.0f, 0.0f, 0.1f, overalltime*(alphaRate*0.8f+0.5f), 1.0f, 1.0f);
    //CrushPulse(0.92, 0.055, 0.071, avgmillis*rig.alphaRate*10+0.5, 0.0, 0.0);
  case 2:
    // BEAT CONROLLED BY PAD
    return CrushPulse(cc[41], cc[42], cc[43], overalltime*(alphaRate+0.5f), 0.0f, 0.0f);
  case 3:
    // PULZ CONTROLLED BY PAD
    return CrushPulse(cc[49], cc[50], cc[51], overalltime*(alphaRate+0.5f), 0.0f, 0.0f);
  case 4:
    // SQUIGGLE (BEATS) CONTROLLED BY PAD 
    return Squiggle(cc[41], cc[42], cc[43], overalltime*(alphaRate+0.5f), 0.01f+cc[44], cc[45]);
  case 5:
    // SQUIGGLE (PULZ) CONTROLLED BY PAD 
    return Squiggle(cc[49], cc[50], cc[51], overalltime*(alphaRate+0.5f), 0.01f+cc[52], cc[53]);
  case 6:
    // STUTTER
    return CrushPulse(0.031f, 0.040f, 0.913f, overalltime*(alphaRate+0.5f), 0.0f, 0.0f).mul(stutter);
  default: 
    return CrushPulse(0.031f, 0.040f, 0.913f, overalltime*(alphaRate+0.5f), 0.02f, 0.02f);
  }
}

public Envelope functionEnvelopeFactory(int envelope_index, Rig rig) {
  float overalltime = avgmillis;

  Envelope sine = new Sine(1, overalltime*rig.funcRate);
  int now = millis();
  float sined = sine.value(now); 

  float funcRate = rig.funcRate*10;
  switch (envelope_index) {
  case 0: 
    //return SimplePulse(cc[41]*4000, cc[42]*4000, cc[43]*4000, cc[44], cc[45]);
    return CrushPulse(0.2f, 0.0f, 1.0f, overalltime*(funcRate+0.5f), 0.0f, sined);
  case 1:
    //return CrushPulse(cc[49], cc[50], cc[51], avgmillis*rig.beatSlider*15+0.5, cc[52], cc[53]);
    return SimpleRamp(overalltime*funcRate, 0, 1, sined);
    //SimplePulse(Number attack_time, Number sustain_time, Number decay_time, float attack_curv, float decay_curv)
  case 2:
    return  SimpleRamp(overalltime*funcRate/0.3f, 1, 0, sined);
    //CrushPulse(cc[41], cc[42], cc[43], avgmillis*rig.funcRate*15+0.5, 0.00, 0.00);
    //case 3:
    //  return CrushPulse(cc[44], cc[45], cc[46], avgmillis*rig.funcRate*15+0.5, 0.02, 0.02);
    //case 4:
    //  //Envelope Squiggle(Number attack_t, Number sustain_t, Number decay_t, float attack_curv, float decay_curv, float sqiggle_curv, float squiggliness, int squiggle_spd) {
    //  return Squiggle(cc[49], cc[50], cc[51], avgmillis*rig.funcRate*15+0.5, 0.01+cc[52], cc[53]);
  default: 
    return CrushPulse(0.0f, 0.0f, 1.0f, overalltime*(funcRate+0.5f), 0.0f, 0.0f);
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean vizHold, colHold, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
public void keyPressed() {  

  if (keyCode == BACKSPACE) {
    println("*** DELETE ALL ANIMS ***");
    for (Rig rig : rigs) {
      for (Anim anim : rig.animations) anim.deleteme = true; // immediately delete all anims
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

/*
  for (Rig rig : rigs) {
    rig.ddListCallback(rig.ddVizList, rig.vizIndex);
    rig.ddListCallback(rig.ddFuncListA, rig.functionIndexA);
    rig.ddListCallback(rig.ddFuncListB, rig.functionIndexB);
    rig.ddListCallback(rig.ddAlphaListA, rig.alphaIndexA);
    rig.ddListCallback(rig.ddAlphaListB, rig.alphaIndexB);
    rig.ddListCallback(rig.ddBgList, rig.bgIndex);
  }
*/
  if (key == '[') vizHold = !vizHold; 
  if (key == ']') colHold = !colHold; 

  if (key=='1') {
    controlFrame.cp5.saveProperties(controlFrameValues);//"cp5values.json");
    //this.cp5.saveProperties(mainFrameValues);
    println("** SAVED CONTROLER VALUES **");
  } else if (key=='2') {
    try {
      controlFrame.cp5.loadProperties(controlFrameValues);
      //this.cp5.loadProperties(mainFrameValues);
      println("** LOADED CONTROLER VALUES **");
      //println("loaded from", controlFrameValues, sliderFrameValues);
    }
    catch(Exception e) {
      println(e, "ERROR LOADING CONTROLLER VALUES");
    }
  }

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
    controlFrame.cp5.getController(name).setValue(cc[number]);
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
        Thread.sleep(500);
      }
      catch(InterruptedException e) {
      }
    }
  }
}
class ShieldsOPCGrid extends OPCGrid {
  //  PVectors for positions of shields
  PVector[][] _shield; // = new PVector[numberOfShields][numberOfRings];    
  PVector[][] shield; // = new PVector[numberOfPositions][numberOfRings];  
  PVector[] shields = new PVector[12];
  //PVector[] eggs = new PVector[2]; 
  //int eggLength;
  float[] ringSize;
  OPC[] opclist;
  Rig rig;

  float bigShieldRad, medShieldRad, smallShieldRad, _bigShieldRad, _medShieldRad, _smallShieldRad;

  ShieldsOPCGrid(Rig _rig) {
    rig = _rig;

    _bigShieldRad = rig.wide/64*7;       
    bigShieldRad = _bigShieldRad * 2 + 6;

    _smallShieldRad = rig.wide/2/48*5.12f; 
    smallShieldRad = _smallShieldRad * 2 + 6; 

    _medShieldRad = rig.wide/2/32*5.12f;
    medShieldRad = _medShieldRad * 2 + 6;
  }

  public void shieldSetup(int _numberOfPositions) {
    float xpos, ypos;
    int numberOfRings = 3;
    _shield = new PVector[_numberOfPositions][numberOfRings];    
    for (int o = 0; o < ringSize.length; o ++) {
      for (int i = 0; i < _numberOfPositions; i++) {    
        xpos = PApplet.parseInt(sin(radians((i)*360/_numberOfPositions))*ringSize[o]*2)+rig.size.x;
        ypos = PApplet.parseInt(cos(radians((i)*360/_numberOfPositions))*ringSize[o]*2)+rig.size.y;
        _shield[i][o] = new PVector (xpos, ypos);
      }
    }
  }
  /*
  void 
   
   OPC(OPC opc, Rig rig) {
   //rig = _rig;
   eggs[0] = new PVector(rig.size.x-75, rig.size.y);
   eggs[1] = new PVector(rig.size.x+75, rig.size.y);
   println("eggs x/y ", eggs[0], eggs[1]);
   eggLength = 100;
   int fc = 10 * 512;
   int channel = 64;
   opc.led(fc+(channel*6), int(eggs[0].x), int(eggs[0].y-(eggLength/2)));          
   opc.led(fc+(channel*6)+1, int(eggs[0].x), int(eggs[0].y));
   opc.led(fc+(channel*6)+2, int(eggs[0].x), int(eggs[0].y+(eggLength/2)));
   
   opc.led(fc+(channel*7), int(eggs[1].x), int(eggs[1].y-(eggLength/2)));          
   opc.led(fc+(channel*7)+1, int(eggs[1].x), int(eggs[1].y));
   opc.led(fc+(channel*7)+2, int(eggs[1].x), int(eggs[1].y+(eggLength/2)));
   
   eggLength += 20;
   }
   */
  public void spiralShieldsOPC(OPC[] _opc) {
    opclist = _opc;
    ringSize = new float[] { rig.wide/8.3f, rig.wide/5.5f, rig.wide/4.5f };
    shieldSetup(9);

    medShieldWLED(opclist[2], 0, 0);   ///// SLOT b1 on BOX ///// 

    smallShieldWLED(opclist[1], 8, 1); ///// SLOT b0 on BOX /////
    ballGrid(opclist[7], 0, 7, 2);

    medShieldWLED(opclist[4], 6, 0);   ///// SLOT b5 on BOX /////
    smallShieldWLED(opclist[3], 5, 1); ///// SLOT b4 on BOX /////
    ballGrid(opclist[7], 1, 4, 2);

    medShieldWLED(opclist[6], 3, 0);   ///// SLOT b3 on BOX /////
    smallShieldWLED(opclist[5], 2, 1); ///// SLOT b2 on BOX /////
    ballGrid(opclist[7], 2, 1, 2);

    bigShieldWLED(opclist[0], PApplet.parseInt(size.rig.x), PApplet.parseInt(size.rig.y));     ///// SLOT b7 on BOX /////
    /////////////////////////// increase size of radius so its covered when drawing over it in the sketch

    shields[0] = new PVector (_shield[0][0].x, _shield[0][0].y);        // MEDIUM SHIELD
    shields[3] = new PVector (_shield[8][1].x, _shield[8][1].y);        // SMALL SHEILD
    shields[6] = new PVector (_shield[7][2].x, _shield[7][2].y);        // BALL

    shields[1] = new PVector (_shield[6][0].x, _shield[6][0].y);        // MEDIUM SHIELD
    shields[4] = new PVector (_shield[5][1].x, _shield[5][1].y);        // SMALL SHEILD
    shields[7] = new PVector (_shield[4][2].x, _shield[4][2].y);        // BALL

    shields[2] = new PVector (_shield[3][0].x, _shield[3][0].y);        // MEDIUM SHIELD
    shields[5] = new PVector (_shield[2][1].x, _shield[2][1].y);        // SMALL SHEILD
    shields[8] = new PVector (_shield[1][2].x, _shield[1][2].y);        // BALL

    shields[9] =  new PVector (_shield[7][2].x, _shield[7][2].y);       // BALL
    shields[10] = new PVector (_shield[4][2].x, _shield[4][2].y);       // BALL
    shields[11] = new PVector (_shield[1][2].x, _shield[1][2].y);       // BALL

    rigg.positionX = _shield; 
    rigg.position = shields;
  }

  public void triangleShieldsOPC(OPC[] _opc) {
    opclist = _opc;
    ringSize = new float[] { rig.wide/9, rig.wide/5, rig.wide/4.5f };
    shieldSetup(12);
    //// SHIELDS - #1 slot on box; #2 position on ring; #3 number of LEDS in 5v ring 
    smallShieldWLED(opclist[1], 2, 0); ///// SLOT b0 on BOX /////   
    medShieldWLED(opclist[2], 2, 1);   ///// SLOT b1 on BOX ///// 
    smallShieldWLED(opclist[3], 6, 0); ///// SLOT b2 on BOX /////
    medShieldWLED(opclist[4], 6, 1);   ///// SLOT b3 on BOX /////
    smallShieldWLED(opclist[5], 10, 0); ///// SLOT b4 on BOX /////
    medShieldWLED(opclist[6], 10, 1);   ///// SLOT b5 on BOX /////
    bigShieldWLED(opclist[0], PApplet.parseInt(size.rig.x), PApplet.parseInt(size.rig.y));     ///// SLOT b7 on BOX /////
    ballGrid(opclist[7], 0, 0, 1);
    ballGrid(opclist[7], 1, 4, 1);
    ballGrid(opclist[7], 2, 8, 1);
  }

  public void ballGrid(OPC opc, int numb, int positionA, int positionB) {
    opc.led(1024+(64*numb), PApplet.parseInt(_shield[positionA][positionB].x), PApplet.parseInt(_shield[positionA][positionB].y));
  }


  public void bigShieldWLED(OPC opc, int xpos, int ypos) {
    ////// HIGH POWER LED RING ////
    int space = rig.wide/2/18;
    opc.led(0, xpos, ypos+space);
    opc.led(1, xpos+space, ypos);
    opc.led(2, xpos, ypos-space);
    opc.led(3, xpos-space, ypos);
    ///// 5V LED STRIP ////
    int leds = 126;
    int strt = 4;
    _bigShieldRad = rig.wide/leds*16;       
    bigShieldRad = _bigShieldRad * 2 + 4; 
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*_bigShieldRad)+xpos, (PApplet.parseInt(cos(radians((i-strt)*360/leds))*_bigShieldRad)+ypos));
    }
  }
  public void medShieldWLED(OPC opc, int positionA, int positionB) {
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int positionX = PApplet.parseInt(_shield[positionA][positionB].x);
    int positionY = PApplet.parseInt(_shield[positionA][positionB].y);
    ////// 5V LED RING for MEDIUM SHIELDS
    int strt = 4;
    int leds = 33;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*_medShieldRad)+PApplet.parseInt(positionX), (PApplet.parseInt(cos(radians((i-strt)*360/leds))*_medShieldRad)+PApplet.parseInt(positionY)));
    }

    ///// PLACE 4 HP LEDS in CENTER OF EACH RING /////
    for (int j = 1; j < 6; j +=2) {
      int space = rig.wide/2/20;
      opc.led(0, positionX, positionY+space);
      opc.led(1, positionX+space, positionY);
      opc.led(2, positionX, positionY-space);
      opc.led(3, positionX-space, positionY);
    }
  }

  public void smallShieldWLED(OPC opc, int positionA, int positionB) {
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int positionX = PApplet.parseInt(_shield[positionA][positionB].x);
    int positionY = PApplet.parseInt(_shield[positionA][positionB].y);
    ////// 1 HP LED IN MIDDLE OF EACH SMALL SHIELD //////
    opc.led(0, PApplet.parseInt(positionX), PApplet.parseInt(positionY));
    /////// RING OF 5V LEDS TO MAKE SAMLL SHIELD ///////
    int leds = 48;
    int strt = 1;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*_smallShieldRad)+PApplet.parseInt(positionX), (PApplet.parseInt(cos(radians((i-strt)*360/leds))*_smallShieldRad)+PApplet.parseInt(positionY)));
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class OPCGrid {
  PVector[] mirror = new PVector[12];
  PVector[][] mirrorX = new PVector[7][4];
  PVector[] _mirror = new PVector[12];
  PVector[] seeds = new PVector[4];
  PVector[] cansString = new PVector[3];
  PVector[] cans = new PVector[18];
  PVector[] eggs = new PVector[2];
  PVector[] strip = new PVector[6];
  PVector[] controller = new PVector[4];
  PVector booth, dig, smokeFan, smokePump, uv;
  float yTop;                            // height Valuve for top line of mirrors
  float yBottom;  
  float yMid = size.rig.y;   
  int eggLength;

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
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  public void kallidaCansOPC(OPC opc) {
    int fc = 5 * 512;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, PApplet.parseInt(cansString[0].x), PApplet.parseInt(cansString[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1)+(64*channel), leds, PApplet.parseInt(cansString[1].x), PApplet.parseInt(cansString[1].y), pd, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX ///////
    cansLength = _cansLength - (pd/2);
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////
public void pickleCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    _cansLength = rig.high/1.2f;

    //int fc = 2 * 512;
    int fc = 2560;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);

    cansString[1] = new PVector(rig.size.x-(rig.wide/3), rig.size.y-(pd/4));
    cansString[0] = new PVector(rig.size.x, rig.size.y+(pd/4));
    cansString[2] = new PVector(rig.size.x+(rig.wide/3), rig.size.y-(pd/4));

    opc.ledStrip(fc+(channel*0), leds, PApplet.parseInt(cansString[0].x), PApplet.parseInt(cansString[0].y), pd, PI/2, false);                   /////  PLUG INTO slot 1 on CANS BOX (first tail) /////// 
    opc.ledStrip(fc+(channel*1), leds, PApplet.parseInt(cansString[1].x), PApplet.parseInt(cansString[1].y), pd, PI/2, false);                   /////  PLUG INTO slot 2 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*2), leds, PApplet.parseInt(cansString[2].x), PApplet.parseInt(cansString[2].y), pd, PI/2, false);                   /////  PLUG INTO slot 3 on CANS BOX /////// 

    cansLength = _cansLength - (pd/2);
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  public void castleCansOPC(Rig _rig, OPC opc, OPC opc1, boolean offset) {
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
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*0+i), PApplet.parseInt(cans[i].x), PApplet.parseInt(cans[i].y)+80);     
    fc = 10 * 512;
    for (int i = 0; i < cans.length/3; i++) opc1.led(fc+(channel*1+i), PApplet.parseInt(cans[i+6].x), PApplet.parseInt(cans[i+6].y)+80);                  
    for (int i = 0; i < cans.length/3; i++) opc1.led(fc+(channel*2+i), PApplet.parseInt(cans[i+12].x), PApplet.parseInt(cans[i+12].y)+80);                  

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
  /////////////////////////////////////////////////////////////////////////////////////////////////////
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
    opc.ledStrip(fc+(channel*1), leds, PApplet.parseInt(cansString[1].x), PApplet.parseInt(cansString[1].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*2), leds, PApplet.parseInt(cansString[2].x), PApplet.parseInt(cansString[2].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 2 on CANS BOX /////// 
    cansLength = _cansLength - (pd/2);
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void castleFireplaceCansOPC(Rig rig, OPC opc) {
    int fc = 10 * 512;
    int channel = 64;
    for (int i = 0; i < 6; i++) opc.led(fc+(channel*2+i), PApplet.parseInt(pars.size.x), PApplet.parseInt(pars.size.y-(pars.high/2)+100+(i*80)));
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////

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
  /////////////////////////////////////////////////////////////////////////////////////////////////////
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
  /////////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////// BOOTH LIGHTS ///////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void standAloneBoothOPC(OPC opc) {
    booth = new PVector (104, 15);
    dig = new PVector (booth.x+110, booth.y);

    int fc = 10 * 512;
    int channel = 64;       

    opc.led(fc+(channel*3), PApplet.parseInt(booth.x-5), PApplet.parseInt(booth.y));
    opc.led(fc+(channel*4), PApplet.parseInt(booth.x+5), PApplet.parseInt(booth.y));

    opc.led(fc+(channel*1), PApplet.parseInt(dig.x-5), PApplet.parseInt(dig.y));
    opc.led(fc+(channel*2), PApplet.parseInt(dig.x+5), PApplet.parseInt(dig.y));
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  public void shieldsBoothOPC(OPC opc) {
    booth = new PVector (104, 15);
    dig = new PVector (booth.x+110, booth.y);

    int fc = 5120;  
    int channel = 64;       

    // booth //
    opc.led(fc+(channel*0), PApplet.parseInt(booth.x-5), PApplet.parseInt(booth.y));
    opc.led(fc+(channel*1), PApplet.parseInt(booth.x+5), PApplet.parseInt(booth.y));

    // dig //
    opc.led(fc+(channel*2), PApplet.parseInt(dig.x+5), PApplet.parseInt(dig.y));
    opc.led(fc+(channel*3), PApplet.parseInt(dig.x-5), PApplet.parseInt(dig.y));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  public void kingsHeadBoothOPC(OPC opc) {
    int fc = 4 * 512;
    int channel = 64;       

    opc.led(fc+(channel*3), PApplet.parseInt(dig.x-5), PApplet.parseInt(dig.y));
    opc.led(fc+(channel*2), PApplet.parseInt(dig.x+5), PApplet.parseInt(dig.y));

    opc.led(fc+(channel*1), PApplet.parseInt(booth.x-5), PApplet.parseInt(booth.y));
  }

  public void eggsOPC(OPC opc, Rig rig) {
    //rig = _rig;
    eggs[0] = new PVector(rig.size.x-75, rig.size.y);
    eggs[1] = new PVector(rig.size.x+75, rig.size.y);
    println("eggs x/y ", eggs[0], eggs[1]);
    eggLength = 100;
    int fc = 10 * 512;
    int channel = 64;
    opc.led(fc+(channel*5), PApplet.parseInt(eggs[0].x), PApplet.parseInt(eggs[0].y-(eggLength/2)));          
    opc.led(fc+(channel*5)+1, PApplet.parseInt(eggs[0].x), PApplet.parseInt(eggs[0].y));
    opc.led(fc+(channel*5)+2, PApplet.parseInt(eggs[0].x), PApplet.parseInt(eggs[0].y+(eggLength/2)));
    int leds = 28;
    opc.ledStrip(fc+(channel*5)+3, leds, PApplet.parseInt(eggs[0].x+10), PApplet.parseInt(eggs[0].y), rig.high/1.5f/leds, PI/2, false);
    opc.ledStrip(fc+(channel*5)+3+leds, leds, PApplet.parseInt(eggs[0].x-10), PApplet.parseInt(eggs[0].y), rig.high/1.5f/leds, PI/2, true);


    opc.led(fc+(channel*6), PApplet.parseInt(eggs[1].x), PApplet.parseInt(eggs[1].y-(eggLength/2)));          
    opc.led(fc+(channel*6)+1, PApplet.parseInt(eggs[1].x), PApplet.parseInt(eggs[1].y));
    opc.led(fc+(channel*6)+2, PApplet.parseInt(eggs[1].x), PApplet.parseInt(eggs[1].y+(eggLength/2)));

    eggLength += 20;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void pickleLanternsIndividual(Rig _rig, OPC opc, int fc) {
    rig = _rig;
    int Xoffset = PApplet.parseInt(rig.size.x - (rig.wide/2));

    fc *= 512;
    int channel = 64;
    opc.led(fc+(channel*0), PApplet.parseInt(rig.positionX[3][0].x + Xoffset), PApplet.parseInt(rig.positionX[3][0].y)); 

    opc.led(fc+(channel*1), PApplet.parseInt(rig.position[0].x + Xoffset), PApplet.parseInt(rig.position[0].y));       
    opc.led(fc+(channel*2), PApplet.parseInt(rig.position[5].x + Xoffset), PApplet.parseInt(rig.position[5].y));  

    opc.led(fc+(channel*3), PApplet.parseInt(rig.positionX[2][1].x + Xoffset), PApplet.parseInt(rig.positionX[2][1].y)); 
    opc.led(fc+(channel*4), PApplet.parseInt(rig.positionX[4][1].x + Xoffset), PApplet.parseInt(rig.positionX[4][1].y)); 

    opc.led(fc+(channel*5), PApplet.parseInt(rig.position[6].x + Xoffset), PApplet.parseInt(rig.position[6].y)); 
    opc.led(fc+(channel*6), PApplet.parseInt(rig.position[11].x + Xoffset), PApplet.parseInt(rig.position[11].y));  

    opc.led(fc+(channel*7), PApplet.parseInt(rig.positionX[3][2].x + Xoffset), PApplet.parseInt(rig.positionX[3][2].y));
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void pickleLanternsDaisyChain(Rig _rig, OPC opc, int fc) {
    rig = _rig;
    int Xoffset = PApplet.parseInt(rig.size.x - (rig.wide/2));

    fc *=512;
    int channel = 64;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// if you need to make another chain just change the 0 to 1 (or whichever slot the start of the chain is plugged into)
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    opc.led(fc+(channel*0+0), PApplet.parseInt(rig.positionX[3][0].x + Xoffset), PApplet.parseInt(rig.positionX[3][0].y)); 

    opc.led(fc+(channel*0+1), PApplet.parseInt(rig.position[0].x + Xoffset), PApplet.parseInt(rig.position[0].y));       
    opc.led(fc+(channel*0+2), PApplet.parseInt(rig.position[5].x + Xoffset), PApplet.parseInt(rig.position[5].y));      

    opc.led(fc+(channel*0+3), PApplet.parseInt(rig.positionX[2][1].x + Xoffset), PApplet.parseInt(rig.positionX[2][1].y)); 
    opc.led(fc+(channel*0+4), PApplet.parseInt(rig.positionX[4][1].x + Xoffset), PApplet.parseInt(rig.positionX[4][1].y)); 

    opc.led(fc+(channel*0+5), PApplet.parseInt(rig.position[6].x + Xoffset), PApplet.parseInt(rig.position[6].y)); 
    opc.led(fc+(channel*0+6), PApplet.parseInt(rig.position[11].x + Xoffset), PApplet.parseInt(rig.position[11].y));  

    opc.led(fc+(channel*0+7), PApplet.parseInt(rig.positionX[3][2].x + Xoffset), PApplet.parseInt(rig.positionX[3][2].y));
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void wigflexLanterns(Rig _rig, OPC opc) {
    rig = _rig;
    int Xoffset = PApplet.parseInt(rig.size.x - (rig.wide/2));

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// if you need to make another chain just change the 0 to 1 (or whichever slot the start of the chain is plugged into)
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    opc.led(0, PApplet.parseInt(rig.position[0].x + Xoffset), PApplet.parseInt(rig.position[0].y));       
    
    
    opc.led(3, PApplet.parseInt(rig.position[5].x + Xoffset), PApplet.parseInt(rig.position[5].y));      

    opc.led(1, PApplet.parseInt(rig.positionX[2][1].x + Xoffset), PApplet.parseInt(rig.positionX[2][1].y)); 
    opc.led(4, PApplet.parseInt(rig.positionX[4][1].x + Xoffset), PApplet.parseInt(rig.positionX[4][1].y)); 

    opc.led(2, PApplet.parseInt(rig.position[6].x + Xoffset), PApplet.parseInt(rig.position[6].y)); 
    opc.led(5, PApplet.parseInt(rig.position[11].x + Xoffset), PApplet.parseInt(rig.position[11].y));  

    opc.led(6, PApplet.parseInt(rig.positionX[3][0].x + Xoffset), PApplet.parseInt(rig.positionX[3][0].y)); 

    opc.led(8, PApplet.parseInt(rig.positionX[3][2].x + Xoffset), PApplet.parseInt(rig.positionX[3][2].y));
    opc.led(7, PApplet.parseInt(rig.positionX[3][1].x + Xoffset), PApplet.parseInt(rig.positionX[3][1].y)+(rig.high-(PApplet.parseInt(rig.high/1.2f)))/2);
  }
  ////////////////////////////////// DMX  /////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void dmxParsOPC(Rig _rig, OPC opc, int numberOfPars) {
    rig = _rig;
    int gap = rig.high/(numberOfPars+2);
    for (int i = 0; i < numberOfPars*2; i+=2) opc.led(6048+i, PApplet.parseInt(rig.size.x), PApplet.parseInt(rig.size.y-(gap*numberOfPars/2)+(gap/2)+(i/2*gap)));
  } 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void dmxSmokeOPC(OPC opc) {
    smokePump = new PVector (height-10, width-20);
    smokeFan = new PVector (smokePump.x+10, smokePump.y);

    opc.led(7000, PApplet.parseInt(smokePump.x), PApplet.parseInt(smokePump.y));
    opc.led(7001, PApplet.parseInt(smokeFan.x), PApplet.parseInt(smokeFan.y));
  } 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  //if (keyT['y']) {
  //  colorLerping(rigg, (1-beat)*2);
  //  colorLerping(roof, (1-beat)*1.5);
  //}

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  float  debouncetime=100;
  ///////////////////////////// *** MANUAL ANIM WORK THAT DOESNT WORK **** ////////////////////////////
  /*
  try {
   if (millis()-lastTime[44]>debouncetime) {
   if (padVelocity[44]>0) rigg.animations.add(new Checkers (rigg));
   if (rigg.animations.size() > 0 ) { 
   Anim theanim = rigg.animations.get(rigg.animations.size()-1);
   //Envelope manualA = CrushPulse(0.0, 0, 1, rigg.manualAlpha*500, 0.0, 0.0);
   Envelope manualA = CrushPulse(0.05, 0.0, 1.0, avgmillis*(rigg.manualAlpha+0.5), 0.0, 0.0);
   theanim.alphaEnvelopeA = manualA;
   theanim.alphaEnvelopeB = manualA;
   lastTime[44]=millis();
   }
   }
   } 
   catch (Exception e) {
   println(e, "playwithyourself error");
   }
   */

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// ADD ANIM ////////////////////////////////////////////////////////////////////
  if (millis()-lastTime[0]>debouncetime*2.5f) {
    if (keyP[' ']) {
      for (Rig rig : rigs) {
        if (rig.toggle) {
          rig.addAnim(rig.vizIndex);
        }
      }
      lastTime[0]=millis();
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  int ccc = 101;
  if (millis()-lastTime[ccc]>debouncetime) {
    if (padVelocity[ccc]>0) rigg.animations.add(new StarMesh (rigg));
    lastTime[ccc]=millis();
  }

  //if (millis()-lastTime[45]>debouncetime) {
  //  if (padVelocity[45]>0) rigg.animations.add(new SpiralFlower(rigg));
  //  lastTime[45]=millis();
  //}
  ccc= 102;
    if (millis()-lastTime[ccc]>debouncetime) {
    if (padVelocity[ccc]>0) rigg.animations.add(new Stars(rigg));
    lastTime[ccc]=millis();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// ALL ON ///////////////////////////////////////////////

  if (millis()-lastTime[46]>debouncetime) {
    if (padVelocity[46]>0) {
      rigg.animations.add( new AllOn(rigg)); //rigg.anim.alphaEnvelopeA = new CrushPulse(0.031, 0.040, 0.913, avgmillis*rigg.alphaRate*3+0.5, 0.0, 0.0);
      //anim = rigg.animations.get(rigg.animations.size()-1);
      lastTime[46]=millis();
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// KILL ALL ANIMS - BLACKOUT ///////////////////////////////////////////////

  ///// DEBOUNCE?! /////

  if (millis()-lastTime[47]>debouncetime) {
    if (padVelocity[47]>0) for (Anim anim : rigg.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[47]=millis();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// STUTTER ///////////////////////////////////////////////x

  /// doesnt work as expected ///

  if (millis()-lastTime[48]>debouncetime) {
    if (padVelocity[48]>0) for (Anim anim : rigg.animations) {
      anim.alphaEnvelopeA = anim.alphaEnvelopeA.mul((1-cc[45])+(stutter*cc[45])); // anim.alphaEnvelopeA.mul(0.6+(stutter*0.4));     //anim.alphaEnvelopeA.mul((1-cc[46])+(stutter*cc[46]));
      anim.alphaEnvelopeB = anim.alphaEnvelopeB.mul((1-cc[45])+(stutter*cc[45])); //anim.alphaEnvelopeA.mul(0.6+(stutter*0.4)); //anim.alphaEnvelopeB.mul((1-cc[46])+(stutter*cc[46]));
    }
    lastTime[48]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////  COLOUR //////////////////////////////////////////////////////////////////////////////

  if (padVelocity[49] > 0) rigg.colorFlip(true);
  if (padVelocity[50] > 0) rigg.colorSwap(0.9999999999f);



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //if (millis()-lastTime[36]>debouncetime) {
  // if (padVelocity[36]>0) rigg.animations.add(new StarMesh (roof));
  // lastTime[36]=millis();
  // }

  // if (millis()-lastTime[37]>debouncetime) {
  // if (padVelocity[37]>0) rigg.animations.add(new SingleDonut(roof));
  // lastTime[37]=millis();
  // }

  // if (millis()-lastTime[38]>debouncetime) {
  // if (padVelocity[38]>0) rigg.animations.add(new BenjaminsBoxes(roof));
  // lastTime[38]=millis();
  // }
  /*
  if (millis()-lastTime[39]>debouncetime) {
   if (padVelocity[39]>0) roof.animations.add( new AllOn(roof));
   lastTime[39]=millis();
   }
   */
  /*
  if (millis()-lastTime[40]>debouncetime) {
   if (padVelocity[40]>0) for (Anim anim : roof.animations) anim.deleteme = true;  // immediately delete all anims
   lastTime[40]=millis();
   }
   */
  /*
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
  //if (padVelocity[51] > 0) roof.colorSwap(0.9999999999);
  //if (padVelocity[43] > 0) pars.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY



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
  /*
  if (padVelocity[50] > 0) {
   pars.colorLayer.beginDraw();
   pars.colorLayer.background(0, 0, 0, 0);
   pars.colorLayer.endDraw();
   //void bgNoise(PGraphics layer, color _col, float bright, float fizzyness) {
   
   bgNoise(pars.colorLayer, pars.flash, map(padVelocity[50], 0, 1, 0, pars.dimmer), cc[47]);   //PGraphics layer,color,alpha
   image(pars.colorLayer, pars.size.x, pars.size.y, pars.wide, pars.high);
   }
   */
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
int vizTimer, bgChangeTimer;
public void playWithYourself(float vizTm) {

  for (Rig rig : rigs) {
    ///////////////// VIZ TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
    if (millis()/1000 - vizTimer >= vizTm) {
      rig.vizIndex = PApplet.parseInt(random(rig.availableAnims.length));
      println(rig.name+" VIZ:", rig.vizIndex, "@", (hour()+":"+minute()+":"+second()));
      vizTimer = millis()/1000;
      //rig.ddListCallback(rig.ddVizList, rig.vizIndex);
    }
    ////////////////////////////// PLAY TOGGLE TO CONTROL AUTO CYCLING OF FUNCS AND ALPHAS /////////////////////////////////////////
    if (rig.playWithYourSelf) {  
      ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
      if (millis()/1000 - rig.alphaTimer >= vizTm/rig.alphaSwapRate) {       //// SWAPRATE changes # of times every viz change /////
        rig.alphaIndexA = PApplet.parseInt(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        rig.alphaIndexB = PApplet.parseInt(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        println(rig.name+" alpha change @", (hour()+":"+minute()+":"+second()), "new envelopes:", rig.alphaIndexA, "&", rig.alphaIndexB);
        rig.alphaTimer = millis()/1000;
       // rig.ddListCallback(rig.ddAlphaListA, rig.alphaIndexA);
       // rig.ddListCallback(rig.ddAlphaListB, rig.alphaIndexB);
      }
      //////////// FUNCTION TIMER //////////////////////////////////////////////////////////////////////////////////////////////////
      if (millis()/1000 - rig.functionTimer >= vizTm/rig.funcSwapRate) {
        rig.functionIndexA = PApplet.parseInt(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        rig.functionIndexB = PApplet.parseInt(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        println(rig.name+" function change @", (hour()+":"+minute()+":"+second()), "new envelope:", rig.functionIndexA, "&", rig.functionIndexB);
        rig.functionTimer = millis()/1000;
       //rig.ddListCallback(rig.ddFuncListA, rig.functionIndexA);
       // rig.ddListCallback(rig.ddFuncListB, rig.functionIndexB);
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  for (Rig rig : rigs) {
    rig.colorTimer(colorTime*60, 1); //// seconds between colour change, number of steps to cycle through colours
    if (millis()/1000 - bgChangeTimer >= colorTime*60/rig.bgSwapRate) {
      rig.bgIndex = (PApplet.parseInt(random(rig.availableBkgrnds.length)));  // change colour layer 4 times every auto color change
      bgChangeTimer = millis()/1000;
      //rig.ddListCallback(rig.ddBgList, rig.bgIndex);
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) for (Rig rig : rigs) rig.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  if (beatCounter%64<4) rigg.colorSwap(1000000*noize);  
  //if (beatCounter%82>78) roof.colorSwap(1000000*noize);
  //if (beatCounter%64>61) cans.colorSwap(1000000*noize);

  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) rigg.colFlip = true;
  else rigg.colFlip = false;
  
  for (Rig rig : rigs) rig.colorFlip(rigg.colFlip);

  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  colBeat = false;
  if (beatCounter % 18 > 15)  colorLerping(rigg, (1-beat)*4);
  //if (beatCounter % 18 < 4)  colorLerping(cans, (1-beat)*4);

  //if (beatCounter % 32 > 27)  colorLerping(roof, (1-beat)*3);
  ////if (beatCounter % 32 > 28)  colorLerping(cans, (1-beat)*1.5);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

public void colorLerping(Rig _rig, float function) {
  _rig.c = lerpColor(_rig.col[_rig.colorIndexB], _rig.col[_rig.colorIndexA], function);
  _rig.flash = lerpColor(_rig.col[_rig.colorIndexA], _rig.col[_rig.colorIndexB], function);
  colBeat = true;
}
public class Rig {
  float dimmer, alphaRate, funcRate, blurValue, bgNoise, manualAlpha, funcSwapRate, alphaSwapRate, bgSwapRate;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex, alphaTimer, functionTimer;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  int c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD, scol1, scol2, scol3;
  int col[] = new int[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  boolean firsttime_sketchcolor=true, toggle, noiseToggle, playWithYourSelf = true;
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
  float wideSlider, strokeSlider, highSlider;
  ControlP5 cp5;
  PApplet parent;
  ScrollableList ddVizList, ddBgList, ddAlphaListA, ddFuncListA, ddAlphaListB, ddFuncListB;
  RadioButton cRadioButton, flashRadioButton;

  Rig(float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;

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
    availableColors = new int[] { 0, 1, 2, 3, 13, 10, 11, 12, 2, 3};
    col[0] = teal; 
    col[1] = orange; 
    col[2] = pink; 
    col[3] = purple;
    col[4] = bloo;
    col[5] = pink1;
    col[6] = orange;
    col[7] = pink;
    col[8] = orange;
    col[9] = bloo;
    col[10] = purple1;
    col[11] = pink1;
    col[12] = orange;
    col[13] = orange1;
    col[14] = teal;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
  
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public void drawColorLayer(int backgroundIndex) {
    int index = this.availableBkgrnds[backgroundIndex];
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
      oneColour(flash);
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
      mirrorGradient(c, flash, 0.5f);
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
    case 10:
      colorLayer.beginDraw();
      colorLayer.background(0);
      radialGradient(flash, c, sine);
      colorLayer.endDraw();
      break;
    case 11:
      colorLayer.beginDraw();
      colorLayer.background(0);
      radialGradient(c, flash, beat);
      bigShield(c, flash);
      balls(clash);
      colorLayer.endDraw();
      break;
    case 12:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      bigShield(flash, flash);
      colorLayer.endDraw();
      break;
    case 13:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(flash);
      bigShield(c, clash);
      colorLayer.endDraw();
      break;
    case 14:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      bigShield(clash, clashed);
      mediumShield(flash, flash);
      smallShield(c);
      balls(clash1);
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
    image(colorLayer, size.x, size.y);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    float radius = colorLayer.height*function; //*function;
    int numberofpoints = 12;
    float angle=360/numberofpoints;
    //float rotate = 90+(function*angle);
    float rotate = -30+(function*angle);
    for (  int i = 0; i < numberofpoints; i++) {
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
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void bigShield( int col1, int col2) {
    colorLayer.noStroke();
    colorLayer.fill(col1);      
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, shieldsGrid.bigShieldRad, shieldsGrid.bigShieldRad);
    colorLayer.fill(col2);      
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, shieldsGrid.bigShieldRad/2, shieldsGrid.bigShieldRad/2);
  }
  public void balls(int col1) {
    colorLayer.fill(col1);     
    colorLayer.noStroke();
    colorLayer.ellipse(shieldsGrid.shields[7].x, shieldsGrid.shields[7].y, 15, 15);
    colorLayer.ellipse(shieldsGrid.shields[8].x, shieldsGrid.shields[8].y, 15, 15);
    colorLayer.ellipse(shieldsGrid.shields[9].x, shieldsGrid.shields[9].y, 15, 15);
  }
  public void mediumShield(int col1, int col2) {
    colorLayer.fill(col1);      
    colorLayer.noStroke();
    colorLayer.ellipse(shieldsGrid.shields[0].x, shieldsGrid.shields[0].y, shieldsGrid.medShieldRad, shieldsGrid.medShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[1].x, shieldsGrid.shields[1].y, shieldsGrid.medShieldRad, shieldsGrid.medShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[2].x, shieldsGrid.shields[2].y, shieldsGrid.medShieldRad, shieldsGrid.medShieldRad);

    colorLayer.fill(col2);      
    colorLayer.ellipse(shieldsGrid.shields[0].x, shieldsGrid.shields[0].y, shieldsGrid.medShieldRad/2, shieldsGrid.medShieldRad/2);
    colorLayer.ellipse(shieldsGrid.shields[1].x, shieldsGrid.shields[1].y, shieldsGrid.medShieldRad/2, shieldsGrid.medShieldRad/2);
    colorLayer.ellipse(shieldsGrid.shields[2].x, shieldsGrid.shields[2].y, shieldsGrid.medShieldRad/2, shieldsGrid.medShieldRad/2);
  }
  public void smallShield(int col1) {
    colorLayer.fill(col1);      
    colorLayer.ellipse(shieldsGrid.shields[3].x, shieldsGrid.shields[3].y, shieldsGrid.smallShieldRad, shieldsGrid.smallShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[4].x, shieldsGrid.shields[4].y, shieldsGrid.smallShieldRad, shieldsGrid.smallShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[5].x, shieldsGrid.shields[5].y, shieldsGrid.smallShieldRad, shieldsGrid.smallShieldRad);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void rigInfo() {
    float textHeight = 18;
    textSize(textHeight);
    float nameWidth = textWidth(name);
    float x = size.x+(wide/2)-(nameWidth/2)-12;
    float y = size.y-(high/2)+21;

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
      colorIndexA =  (colorIndexA + steps) % (availableColors.length-1);
      colB =  col[colorIndexA];
      colorIndexB = (colorIndexB + steps) % (availableColors.length-1);
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

    //Object[] classList = new Object[] { new BenjaminsBoxes(this), new StarMesh(this), new Rings(this), new Celtic(this)};

    Anim anim = new Anim(this);
    int index = this.availableAnims[animIndex];
    switch (index) {
    case 0:  
      anim = new BenjaminsBoxes(this);
      break;
    case 1:  
      anim = new StarMesh(this);
      break;
    case 2:  
      anim = new Rings(this);
      break;
    case 3:  
      anim = new Celtic(this);
      break;
    case 4:  
      anim = new SpiralFlower(this);
      break;
    case 5:  
      anim = new TwistedStar(this);
      break;
    case 6:  
      anim = new Stars(this);
      break;
    case 7:  
      anim = new SingleDonut(this);
      break;
    case 8:  
      anim = new BouncingDonut(this);
      break;
    case 9:  
      anim = new BouncingPolo(this);
      break;
    case 10:  
      anim = new Polo(this);
      break;
    case 11:  
      anim = new Checkers(this);
      break;
    case 12:  
      anim = new Rush(this);
      break;
    case 13:  
      anim = new Rushed(this);
      break;
    case 14:  
      anim = new SquareNuts(this);
      break;
    case 15:  
      anim = new DiagoNuts(this);
      break;
    case 16:  
      anim = new Swipe(this);
      break;
    case 17:  
      anim = new Swiped(this);
      break;
    case 18:  
      anim = new Teeth(this);
      break;
    case 19:
      anim = new AllOn(this);
      break;
    case 20:
      anim = new AllOff(this);
      break;
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

    /// alter all but the most recent animations
    if (testToggle) {
      for (int i = 0; i < this.animations.size()-1; i++) {   // loop  through the list excluding the last one added
        int animIndex = i;
        Anim an = this.animations.get(animIndex);  
        int now = millis();

        an.overalltime*=0.9f;

  }
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
    if (cc[107] > 0 || keyT['r']) bgNoise(colorLayer, 0, 0, cc[55]); //PGraphics layer,color,alpha
    drawColorLayer(bgIndex);

    blendMode(NORMAL);
    rigInfo();
    removeAnimations();
    cordinatesInfo(this, keyT['e']);
    
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
public void artNetSetup(){
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
//can these go inside MainControlFrame?
boolean testToggle, smokeToggle;
float boothDimmer, digDimmer, vizTime, colorTime, colorSwapSlider, beatSlider = 0.3f;
float smokePumpValue, smokeOnTime, smokeOffTime;

class MainControlFrame extends ControlFrame {
  //private boolean initialized = false;
  MainControlFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super (_parent, _controlW, _controlH, _xpos, _ypos);
  }
  public void setup() {
    super.setup();
    /////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    this.x = this.width-65;
    this.wide = 20;
    this.high = 20;
   // rigg = new Rig(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// GLOBAL SLIDERS ///////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    if (!rigg.toggle) fill(rigg.c, 100);
    text("rigViz: " + rigg.availableAnims[rigg.vizIndex], x, y);
    text("bkgrnd: " + rigg.availableBkgrnds[rigg.bgIndex], x, y+20);
    text("func's: " + rigg.availableFunctionEnvelopes[rigg.functionIndexA] + " / " + rigg.availableFunctionEnvelopes[rigg.functionIndexB], x+110, y);
    text("alph's: " + rigg.availableAlphaEnvelopes[rigg.alphaIndexA] + " / " + rigg.availableAlphaEnvelopes[rigg.alphaIndexB], x+110, y+20);
    /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
    ///// NEXT VIZ IN....
    x=250;
    fill(rigg.c, 300);

    String sec = nf(PApplet.parseInt(vizTime*60 - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = PApplet.parseInt(vizTime*60 - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(PApplet.parseInt(colorTime*60 - (millis()/1000 - rigg.colorTimer)) %60, 2, 0);
    min = PApplet.parseInt(colorTime*60 - (millis()/1000 - rigg.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+20);
    //text("c-" + rigg.colorIndexA + "  " + "flash-" + rigg.colorIndexB, x, y+40);

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    int sliderY =90;
    sequencer(rigg.wide, sliderY-20);
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

class ControlFrame extends PApplet {
  int controlW, controlH, wide, high, xpos, ypos;
  float clm, row, x, y;
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
    //fullScreen();
  }
  public void setup() {
    frameRate(10);
    this.surface.setSize(controlW, controlH);
    this.surface.setAlwaysOnTop(onTop);
    //this.surface.setLocation(xpos, ypos);
    //pixelDensity(2);
    colorMode(HSB, 360, 100, 100);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();
    cp5 = new ControlP5(this);
    cp5.getProperties().setFormat(ControlP5.SERIALIZED);
  }
  public void draw() {  
    /// override in subclass
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void loadSlider(String label, float _x, float _y, int _wide, int _high, float min, float max, float startVal, int act1, int bac1, int slider1) {
    this.cp5.addSlider(label)
      .plugTo(parent, label)
      .setPosition(_x, _y)
      .setSize(_wide, _high)
      //.setFont(font)
      .setRange(min, max)
      .setValue(startVal)    // start value of slider
      .setColorActive(color(act1, 200)) 
      .setColorBackground(color(bac1, 200)) 
      .setColorForeground(color(slider1, 200)) 
      ;
  }
  public void loadToggle(String label, Boolean toggle, float x, float y, int wide, int high, int bac1, int bac, int slider) {
    this.cp5.addToggle(label)
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
  public void rigDimmer(float theValue) {
    int value = PApplet.parseInt(map(theValue, 0, 1, 0, 127));
    LPD8bus.sendControllerChange(0, 4, value) ;
  }
  public void dividerLines() {
    fill(rigg.c, 200);                         // box around the outside
    rect(width/2, height-1, width, 1);  
    rect(width/2, 0, width, 1);                              
    rect(0, height/2, 1, height);
    rect(width-1, height/2, 1, height);
  }
  public void sequencer(float x, float y) {
    int dist = 20;
    fill(rigg.flash, 100);
    for (int i = 0; i<(16); i++) rect(10+i*dist+x, y, 10, 10);
    fill(rigg.c);
    for (int i = 0; i<(16); i++) if (PApplet.parseInt(beatCounter%(16)) == i) rect(10+i*dist+x, y, 10, 10);
    textAlign(LEFT);
    textSize(14);
    text("BC: "+beatCounter, x+(16*dist), y+5);
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
      }
      if (theEvent.isFrom(rig.ddBgList)) {
        if (frameCount > someDelay)    println(rig.name+" background selected "+intValue);
        rig.bgIndex = intValue;
      }
      if (theEvent.isFrom(rig.ddAlphaListA)) {
        if (frameCount > someDelay)    println(rig.name+" alpahA selected "+intValue);
        rig.alphaIndexA = intValue;
      }
      if (theEvent.isFrom(rig.ddFuncListA)) {
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
        //   if( theEvent.getController().getName().startsWith("bang")){
        //     for (int i=0;i<col.length;i++) {
        //if (theEvent.getController().getName().equals("bang"+i)) {
        //  col[i] = color(random(255));
        //}
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
public void setCCfromBang(String name, float value) {
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

  float smokeInterval = smokeOffTime*60;
  float smokeOn = smokeOnTime;
  if (millis()/1000 % smokeInterval > smokeInterval - smokeOn) {
    fill(360*smokePumpValue);
    if (smokeToggle)  rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 10, 10);
  }
  float smokeInfo = millis()/1000 % smokeInterval - (smokeInterval);
  fill(rigg.c, 360);
  textAlign(LEFT);
  textSize(16);

  int min = abs(PApplet.parseInt(smokeInfo) /60 % 60);
  String sec = nf(abs(PApplet.parseInt(smokeInfo) % 60), 2, 0);
  text("SMOKE ON IN: "+min+":"+sec, opcGrid.smokePump.x+25, opcGrid.smokePump.y+6);

  if (keyP['0']) {
    fill(360*smokePumpValue);
    rect(opcGrid.smokePump.x, opcGrid.smokePump.y, 10, 10);
  }
}
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
  //shimmer = (shimmerSlider/2+(stutter*0.4*noize1*0.2));
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
  beat = 1;
  beatCounter = (beatCounter + 1) % 120;

  weightedsum=beatTimer+(1-beatTempo)*weightedsum;
  weightedcnt=1+(1-beatTempo)*weightedcnt;
  avgtime=weightedsum/weightedcnt;
  avgmillis = avgtime*1000/frameRate;
  beatTimer=0;
}
///////////////////////////////////////// BEATS /////////////////////////////////////////////////////////////////////
public void beats() {            
  beatTimer++;
  beatTempo=0.2f; //TODO - global vairable set twice, this affects how quickly code adapts to tempo changes 0.2 averages the last 10 onsets  0.02 would average the last 100
  beatTrigger = false;
  if (beatDetect.isOnset()) beatTrigger = true;
  // trigger beats without audio input
  if (pause > 1) {
    if ((millis() % pauseTriggerTime) == 0) {
      beatTrigger = true;
      pauseTriggerTime = PApplet.parseInt(random(360, 750));
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (beatTrigger) resetbeats();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (avgmillis>0) beat*= pow(beatSlider, (20/avgmillis));       //  changes rate alpha fades out based on average millis between beats
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
  fill(rigg.c, 360*digDimmer);
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
    for (Rig rig : rigs)     rect(rig.size.x, rig.size.y, rig.wide, rig.high);

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

  //////////////////////////////// SHOW INFO ABOUT CURRENT RIG ARRAY SELECTION //////////////////////////////////////////////////////////////// 
    float x = 420;
    float y = 25;
    textAlign(LEFT);
    textSize(18);
    ///////////// rig info/ ///////////////////////////////////////////////////////////////////
    fill(rigg.flash, 300);
    if (!rigg.toggle) fill(rigg.c, 100);
    text("rigViz: " + rigg.availableAnims[rigg.vizIndex], x, y);
    text("bkgrnd: " + rigg.availableBkgrnds[rigg.bgIndex], x, y+20);
    text("func's: " + rigg.availableFunctionEnvelopes[rigg.functionIndexA] + " / " + rigg.availableFunctionEnvelopes[rigg.functionIndexB], x+110, y);
    text("alph's: " + rigg.availableAlphaEnvelopes[rigg.alphaIndexA] + " / " + rigg.availableAlphaEnvelopes[rigg.alphaIndexB], x+110, y+20);
    /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
  
    fill(rigg.c, 300);
    String sec = nf(PApplet.parseInt(vizTime*60 - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = PApplet.parseInt(vizTime*60 - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y+40);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(PApplet.parseInt(colorTime*60 - (millis()/1000 - rigg.colorTimer)) %60, 2, 0);
    min = PApplet.parseInt(colorTime*60 - (millis()/1000 - rigg.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+60);
    //text("c-" + rigg.colorIndexA + "  " + "flash-" + rigg.colorIndexB, x, y+40);
    int totalAnims=0;      
    for (Rig rig : rigs) totalAnims += rig.animations.size();
    text("# of anims: "+totalAnims, x,y+80);

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
//Envelopes visulization
     y=200;             // STARTING HEIGHT for sections
    float y1=160;            // LENGTH of sections
    float dist = 15;
    int i=0;
 try {
      for (Anim anim : rigg.animations) {
        if (i<rigg.animations.size()-1) {
          fill(rigg.c1, 120);
        } else {
          fill(rigg.flash1, 300);
        }
        float xAxis = (this.width/8);
        rect(x+20+(anim.alphaA*xAxis-32), y+(dist*i), 10, 10);                      // ALPHA A viz
        rect(x+xAxis+12+(anim.alphaB*xAxis-32), y+(dist*i), 10, 10);         // ALPHA B viz
        rect(x+20+(anim.functionA*xAxis-32), y+(dist*i)+y1, 10, 10);                // FUNCTION A viz
        rect(x+xAxis+12+(anim.functionB*xAxis-32), y+(dist*i)+y1, 10, 10);   // FUNCTION B viz
        i+=1;
      }
    }
    catch (Exception e) {
      println(e);
      println("erorr on alpah / function  envelope visulization");
    }
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
  fill(rigg.flash, 200);
  rect(size.rigWidth, height/2, 1, height);                                         //// vertical line to show end of rig viz area
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);                          //// vertical line to show end of roof viz area
  rect(size.rigWidth+size.roofWidth+size.cansWidth, height/2, 1, height);           //// vertical line to show end of cans viz area
  rect(size.roof.x, size.roofHeight, size.roofWidth, 1);                            //// horizontal line to divide landscape rig / roof areas
  rect(size.rig.x, size.rigHeight, size.rigWidth, 1);                               //// horizontal line to divide landscape rig / roof areas

  // box around the outside
  fill(rigg.flash, 200);   
  rect(width/2, height-1, width, 1);  
  rect(width/2, 0, width, 1);                              
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

  SizeSettings() {
      rigWidth = 400;                                    // WIDTH of rigViz
      if (SHITTYLAPTOP) rigWidth = 350;
      rigHeight = 400;    
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

    //////////////////////////////// TEMP CONTROLLER AREA BELOW SHIELDS //////////////////////

    int sliderWidth = rigWidth;

    sizeX = rigWidth+roofWidth+cansWidth+parsWidth+sliderWidth;
    sizeY = rigHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
public void midiSetup() {
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
    if (in.contains("MPD218")) { 
      MPD8bus = new MidiBus(this,in,in);
      println("Found AKAI MPD218: ", in);
    }

  }
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
float avgtime, avgvolume, weightedsum, weightedcnt, beatTempo;
public void audioSetup(int sensitivity, float beatTempo) {
  // beatTempo affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
    
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);
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
  float blury = PApplet.parseInt(10);
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "shields" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
