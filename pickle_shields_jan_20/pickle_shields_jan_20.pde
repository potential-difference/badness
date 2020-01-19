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

  controlFrame = new MainControlFrame(this, width, 310, size.surfacePositionX, size.surfacePositionY+height+5); // load control frame must come after shild ring etc
  opcGrid = new OPCGrid();

  //Rig(float _xpos, float _ypos, int _wide, int _high, String _name) {
  // order of these is important for layout of sliders
  rigg = new Rig(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");
  roof = new Rig(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight, "ROOF");
  cans = new Rig(size.cans.x, size.cans.y, size.cansWidth, size.cansHeight, "LIVE");
  pars = new Rig(size.pars.x, size.pars.y, size.parsWidth, size.parsHeight, "PARS");

  int frameWidth = 220;
  sliderFrame = new SliderFrame(this, frameWidth, height+controlFrame.height+5, size.surfacePositionX-frameWidth-5, size.surfacePositionY); // load control frame must come after shild ring etc

  ///////////////// LOCAL opc /////////////////////
  opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS

  ///////////////// OPC over NETWORK /////////////////////
  //opcMirror1 = new OPC(this, "192.168.10.2", 7890);     // left hand mirror
  //opcMirror2 = new OPC(this, "192.168.10.5", 7890);     // right hand mirror
  opcNode4 = new OPC(this, "192.168.10.211", 7890);       // NODE IN THE SHIELDS BOX
  opcNode3 = new OPC(this, "192.168.10.3", 7890);         // NODE IN CANS BOX
  opcNode7 = new OPC(this, "192.168.10.7", 7890);         // NODE IN LANTERNS BOX 

  opcGrid.dmxParsOPC(pars, opcLocal);                     // ENTTEC BOX PLUGGED INTO LAPTOP VIZ USB - run json locally
  opcGrid.dmxSmokeOPC(opcLocal);                             

  shieldsGrid = new ShieldsOPCGrid(rigg);
  shieldsGrid.spiralShieldsOPC(opcNode4);
  opcGrid.shieldsBoothOPC(opcNode4);                      // BOOTH and DIG LIGHTS PLUG INTO THE SHIELDS BOX slots: booth 3 & 5, dig 4 & 5 or use splitter joiner

  int fadecandy5 = 5*512;
  int fadecandy9 = 9*512;
  int fadecandy10 = 10*512;

  opcGrid.pickleCansOPC(roof, opcLocal, fadecandy9);    //opcNode7
  opcGrid.pickleLanterns(cans, opcLocal, fadecandy10);  //opcNode3

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
  //pause(10);                                ////// number of seconds before no music detected and auto kicks in
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
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
