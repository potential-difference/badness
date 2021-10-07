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
ControlP5 main_cp5;

boolean SHITTYLAPTOP=true;//false;

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
boolean MCFinitialized,SFinitialized;
void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings(LANDSCAPE);
  //fullScreen();
  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 1920-width-50;
  if (SHITTYLAPTOP) size.surfacePositionX = 0;
  size.surfacePositionY = 150;
}
void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);
  //surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  MCFinitialized = false;
  controlFrame = new MainControlFrame(this, width, 330, size.surfacePositionX, size.surfacePositionY+height+5); // load control frame must come after shild ring etc
  opcGrid = new OPCGrid();

  // order of these is important for layout of sliders
  print("MainControlFrame");
  while(!MCFinitialized){delay(100);print(".");}
  println(".");
  
  int frameWidth = 220;
  SFinitialized = false;
  sliderFrame = new SliderFrame(this, frameWidth, height+controlFrame.height+5, size.surfacePositionX-frameWidth-5, size.surfacePositionY); // load control frame must come after shild ring etc
  
  print("SliderFrame");
  //wait for MCF,SF to be initialized
  while (!SFinitialized){delay(100);print(".");}
  println(".");
  ///////////////// LOCAL opc /////////////////////
  opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS

  ///////////////// OPC over NETWORK /////////////////////
  //opcMirror1 = new OPC(this, "192.168.10.2", 7890);     // left hand mirror
  //opcMirror2 = new OPC(this, "192.168.10.5", 7890);     // right hand mirror
  opcNode4 = new OPC(this, "192.168.10.211", 7890);       // NODE IN THE SHIELDS BOX
  opcNode3 = new OPC(this, "192.168.10.3", 7890);         // NODE IN CANS BOX
  opcNode7 = new OPC(this, "192.168.10.7", 7890);         // NODE IN LANTERNS BOX 

  int numberOfPars;
  opcGrid.dmxParsOPC(pars, opcLocal, numberOfPars = 6);   // ENTTEC BOX PLUGGED INTO LAPTOP VIZ USB - run json locally - pars DMX address 1,5,9,13,17,21
  opcGrid.dmxSmokeOPC(opcLocal);                          // ENTTEC BOX PLUGGED INTO LAPTOP VIZ USB - run json locally - smoke machine DMX address 100

  shieldsGrid = new ShieldsOPCGrid(rigg);        
  shieldsGrid.spiralShieldsOPC(opcNode4);                 // SHIELDS plug into RIGHT SLOTS A-F = 1-6 *** BIG SHIELD = 7 *** H-G = LEFT SLOTS 0-2 ***
  opcGrid.shieldsBoothOPC(opcNode4);                      // BOOTH and DIG lights plug into SHIELDS BOX LEFT slots: booth 3 & 5, dig 4 & 5 or use splitter joiners

  int fadecandy;
  opcGrid.pickleCansOPC(roof, opcNode7, fadecandy = 9);   
  opcGrid.pickleLanternsIndividual(cans, opcNode3, fadecandy = 10);    // each lantern plugged into its own slot on the box, 0 - 7
  //opcGrid.pickleLanternsDaisyChain(cans, opcNode3, fadecandy = 10);  // one chain starting at slot 0 on the box - see function if you need to add another chain

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
    this.main_cp5.loadProperties(mainFrameValues);
    controlFrame.cp5.loadProperties(controlFrameValues);
    sliderFrame.cp5.loadProperties(sliderFrameValues);
  }
  catch(Exception e) {
    println(e);
    println("*** !!PROBABLY NO PROPERTIES FILE!! ***");
  }
  for (int i = 0; i < 16; i++) {
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
  //pause(10);                                ////// number of seconds before no music detected and auto kicks in
  globalFunctions();
  //syphonLoadSentImage(syphonToggle);

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
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
