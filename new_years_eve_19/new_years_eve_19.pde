OPC opcLocal;
OPC opcMirror1; 
OPC opcMirror2;
OPC opcNode4;
OPC opcNode3;
OPC opcNode6;
OPC opcNode7;
OPC opcWifi;

import java.util.*;
import controlP5.*;
import ch.bildspur.artnet.*;
ControlP5 cp5;
ControlFrame ControlFrame; // load control frame must come after shild ring etc

boolean SHITTYLAPTOP=false;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ShieldsOPCGrid shieldsGrid;
ControlFrame controlFrame, sliderFrame;

Rig rigg, roof, cans, mirrors, strips, donut, seeds, pars;
ArrayList <Rig> rigs = new ArrayList<Rig>();  

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import themidibus.*;  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep

String controlFrameValues, sliderFrameValues, mainFrameValues;

boolean onTop = false;

void settings() {
  size = new SizeSettings(LANDSCAPE);
  fullScreen();
  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 1920-width-50;
  if (SHITTYLAPTOP) size.surfacePositionX = 0;
  size.surfacePositionY = 150;
}
void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);

  controlFrame = new MainControlFrame(this, width, 290, size.surfacePositionX, size.surfacePositionY+height+5); // load control frame must come after shild ring etc
  opcGrid = new OPCGrid();

  //Rig(boolean _toggle, float _xpos, float _ypos, int _wide, int _high, String _name) {
  rigg = new Rig(true, size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");
  //cans = new Rig(false, size.cans.x, size.cans.y, size.cansWidth, size.cansHeight, "SEEDS");
  roof = new Rig(true, size.roof.x, size.roof.y, size.roofWidth, size.roofHeight, "ROOF");
  pars = new Rig(true, size.pars.x, size.pars.y, size.parsWidth, size.parsHeight, "PARS");

  int frameWidth = 220;
  sliderFrame = new SliderFrame(this, frameWidth, height+controlFrame.height+5, size.surfacePositionX-frameWidth-5, size.surfacePositionY); // load control frame must come after shild ring etc

  ///////////////// LOCAL opc /////////////////////
  opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS

  ///////////////// OPC over NETWORK /////////////////////
  opcMirror1 = new OPC(this, "192.168.10.2", 7890);     // left hand mirror
  opcMirror2 = new OPC(this, "192.168.10.5", 7890);     // right hand mirror
  opcNode4 = new OPC(this, "192.168.10.210", 7890);
  opcNode3 = new OPC(this, "192.168.10.3", 7890);
  //opcNode6 = new OPC(this, "192.168.10.6", 7890);
  opcNode7 = new OPC(this, "192.168.10.7", 7890);

  //opcGrid.mirrorsOPC(opcLocal, opcLocal, 1);               // grids 0-3 MIX IT UPPPPP 
  opcGrid.standAloneBoothOPC(opcLocal);
  //opcGrid.tawSeedsOPC(cans, opcLocal, opcLocal);
  opcGrid.individualCansOPC(roof, opcLocal, true);
  opcGrid.dmxParsOPC(opcLocal);
  opcGrid.dmxSmokeOPC(opcLocal);

  shieldsGrid = new ShieldsOPCGrid(rigg);
  shieldsGrid.spiralShieldsOPC(opcLocal);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  setupSpecifics();
  //syphonSetup(syphonToggle);
  //artNetSetup();

  controlFrameValues = sketchPath("cp5ControlFrameValues");
  sliderFrameValues  = sketchPath("cp5SliderFrameValues");
  mainFrameValues  = sketchPath("cp5MainFrameValues");
  try {
    this.cp5.loadProperties(mainFrameValues);
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
int colStepper = 1;
int time_since_last_anim=0;
void draw()
{
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                                ////// number of seconds before no music detected and auto kicks in
  globalFunctions();
  //syphonLoadSentImage(syphonToggle);

  //vizTime *=60;      // convert from minutes to seconds
  //colorTime *=60;    // convert from minutes to seconds
  if (frameCount > 10) playWithYourself(vizTime*60);
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
  if (keyT['s']) for (Anim anim : rigg.animations)  anim.funcFX = 1-(stutter*noize1*0.1);
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
  /*
  for (int i = 0; i < 12; i++) {
   float xpos = int(sin(radians((i)*360/12))*100*2)+rigg.size.x;
   float ypos = int(cos(radians((i)*360/12))*100*2)+rigg.size.y;
   fill(300);
   text(i, xpos, ypos);
   }
   */
  /* 
   for (int i = 0; i < 9; i++) {
   float xpos = int(sin(radians((i)*360/9))*120*2)+rigg.size.x;
   float ypos = int(cos(radians((i)*360/9))*120*2)+rigg.size.y;
   fill(300);
   text(i, xpos, ypos);
   }
   */
  /*
  fill(red);
   for (int o = 0; o < 3; o++) {
   for (int i = 0; i < shieldsGrid._shield.length; i++) {
   text(i+"/"+o, shieldsGrid._shield[i][o].x, shieldsGrid._shield[i][o].y);
   }
   
   }
   */
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
