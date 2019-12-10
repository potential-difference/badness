OPC opc;
OPC opcLocal;
OPC opcMirrors; 
OPC opcMirror1; 
OPC opcMirror2;
OPC opcSeeds;
OPC opcCans;
OPC opcStrip;
OPC opcControllerA;
OPC opcControllerB;
OPC opcWifi;

import controlP5.*;
ControlP5 cp5;
//SliderSetup ss;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ControlFrame controlFrame;
Rig rigg, roof, cans, mirrors, strips, donut;
ArrayList <Rig> rigs = new ArrayList<Rig>();  

ControlFrame ControlFrame; // load control frame must come after shild ring etc

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import themidibus.*;  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep

PFont myFont;
boolean onTop = false;
void settings() {
  size = new SizeSettings(LANDSCAPE);
  //fullScreen();
  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 1920-width-50;
  size.surfacePositionY = 150;
}
void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  controlFrame = new ControlFrame(this); // load control frame must come after shild ring etc
  cp5 = new ControlP5( controlFrame );
  //ss = new SliderSetup();

  opcGrid = new OPCGrid();

  rigg = new Rig(true, size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");
  roof = new Rig(false, size.roof.x, size.roof.y, size.roofWidth, size.roofHeight, "ROOF");
  cans = new Rig(false, size.cans.x, size.cans.y, size.cansWidth, size.cansHeight, "CANS");
  //donut = new Rig(false,size.donut.x, size.donut.y, size.donutWidth, size.donutHeight, "DONUT");


  ///////////////// LOCAL opc /////////////////////
  opcLocal   = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRRORS
  opcMirror1 = new OPC(this, "GL-AR300m-c4c", 7890);
  opcMirror2 = new OPC(this, "GL-AR300M-cb9", 7890);

  ///////////////// OPC over NETWORK /////////////////////
  //opcMirrors = new OPC(this, "192.168.0.70", 7890);        // Connect to the remote instance of fcserver - MIRROR 1
  //opcCans    = new OPC(this, "192.168.0.10", 7890);           // Connect to the remote instance of fcserver - CANS BOX
  //opcStrip   = new OPC(this, "192.168.0.20", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  opcGrid.mirrorsOPC(opcMirror1, opcMirror2, 0);               // grids 0-3 MIX IT UPPPPP 
  opcGrid.radiatorsOPC(cans, opcLocal);
  //opcGrid.donutOPC(donut, opcLocal);
  //opcGrid.pickleCansOPC(cans, opcLocal);               
  //opcGrid.kingsHeadStripOPC(cans, opcESP);
  //opcGrid.espTestOPC(rigg, opcLocal);
  //grid.kingsHeadBoothOPC(opcLocal);
  //opcGrid.individualCansOPC(roof, opcLocal);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  midiSetup();

  drawingSetup();
  loadImages();
  loadShaders();
  setupSpecifics();
  //syphonSetup(syphonToggle);

  frameRate(30);
}
float vizTime, colTime;
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

  vizTime = 60*15*vizTimeSlider;
  if (frameCount > 10) playWithYourself(vizTime);
  c = rigg.c;
  flash = rigg.flash;

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  cans.vizIndex=roof.vizIndex;

  // create a new anim object and add it to the beginning of the arrayList
  if (beatTrigger) { 
    for (Rig rig : rigs) { 
      if (rig.toggle) rig.addAnim(rig.availableAnims[rig.vizIndex]);
    }
  }
  //for (Rig rig : rigs) println(rig.name, rig.toggle);
  //println(rigg.dimmer);
  if (keyT['s']) for (Anim anims : rigg.animations)  anims.funcFX = 1-(stutter*noize1*0.1);

  for (Rig rigs : rigs) rigs.draw();  
  //////////////////////////////////////////// PLAY WITH ME MORE /////////////////////////////////////////////////////////////////////////////////
  playWithMeMore();
  //////////////////////////////////////////// BOOTH & DIG ///////////////////////////////////////////////////////////////////////////////////////
  boothLights();
  //////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////
  workLights(keyT['w']);
  testColors(keyT['t']);
  mouseInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  frameRateInfo(5, 20);                     // display frame rate X, Y /////
  dividerLines();
  //gid.mirrorTest(false);                  // true to test physical mirror orientation

  //syphonSendImage(syphonToggle);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
