OPC opcLocal, opcMirrorLeft, opcMirrorRight;
OPCGrid opcGrid;

import java.util.*;
import controlP5.*;
import ch.bildspur.artnet.*;
ControlP5 main_cp5;
ControlFrame ControlFrame; // load control frame must come after shild ring etc
ControlFrame controlFrame;
String controlFrameValues, mainFrameValues;
boolean SHITTYLAPTOP=false;

final int PORTRAIT = 0; 
final int LANDSCAPE = 1; 
final int RIG = 0; 
final int ROOF = 1;
SizeSettings size;

Rig rigg, roof, cans, mirrors, strips, donut, seeds, pars;
ArrayList <Rig> rigs = new ArrayList<Rig>();  

import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import themidibus.*; 
import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
MidiBus TR8bus, apcBus, LPD8bus, beatStepBus;          

boolean onTop = false;
boolean MCFinitialized, SFinitialized,SettingsLoaded;

void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings(LANDSCAPE);
  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 1920-width;
  if (SHITTYLAPTOP) size.surfacePositionX = 0;
  size.surfacePositionY = 150;
}
void setup()
{
  SettingsLoaded = false;
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  MCFinitialized = false;
  controlFrame = new MainControlFrame(this, width, 360, size.surfacePositionX, size.surfacePositionY+height+50); // load control frame must come after shild ring etc
  opcGrid = new OPCGrid();

  // order of these is important for layout of sliders
  print("MainControlFrame");
  while (!MCFinitialized) {
    try{
      Thread.sleep(100);
    }catch(Exception e){}
    print(".");
  }
  println("DONE");

  //////////////////////////////////////////////////////////////////
  ///////////////// LOCAL opc /////////////////////
  opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS

  ///////////////// OPC over NETWORK /////////////////////
  opcMirrorLeft = new OPC(this, "192.168.10.1", 7890);     // left hand mirror
  opcMirrorRight = new OPC(this, "192.168.10.5", 7890);     // right hand mirror

  opcGrid.mirrorsOPC(opcMirrorLeft, opcMirrorRight, 1);               // grids 0-3 MIX IT UPPPPP 
  opcGrid.standAloneBoothOPC(opcLocal);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  setupSpecifics();

  controlFrameValues = sketchPath("cp5ControlFrameValues");
  //mainFrameValues  = sketchPath("cp5MainFrameValues");
  println("loading cp5 properties");
  try {
    controlFrame.cp5.loadProperties(controlFrameValues);
    //println("loaded.");
  }
  catch(Exception e) {
    println(e);
    println("*** !!PROBABLY NO PROPERTIES FILE!! ***");
  }
  SettingsLoaded = true;
  frameRate(30); // always needs to be last in setup
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
        rig.addAnim(rig.vizIndex);           // create a new anim object and add it to the beginning of the arrayList
      }
    }
  }
  if (keyT['s']) for (Anim anim : rigg.animations)  anim.funcFX = 1-(stutter*noize1*0.1);
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
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  mouseInfo(keyT['q']);
  frameRateInfo(5, 20);                     // display frame rate X, Y /////
  dividerLines();
  //gid.mirrorTest(false);                  // true to test physical mirror orientation
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
