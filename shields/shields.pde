WLED wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls, wledSeedsA, wledSeedsB;
OPC opcLocal;

import java.util.*;
import controlP5.*;
import ch.bildspur.artnet.*;
import java.lang.reflect.*;
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

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5 = new OscP5(this,12000);

import themidibus.*;  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep
MidiBus MPD8bus;

String controlFrameValues, mainFrameValues;

boolean onTop = false;
boolean MCFinitialized, SFinitialized;

void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings();
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

  audioSetup(100, 0.2); ///// AUDIO SETUP - sensitivity, beatTempo /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  setupSpecifics();

  frameRate(30); // always needs to be last in setup
}
int colStepper = 1;
int time_since_last_anim=0;
void draw()
{
  rigg.dimmer = 1;
  rigg.alphaRate = 0.5;
  rigg.funcRate = 0.5;
  vizTime = 0.5;
  colorTime = 0.5;
  rigg.wideSlider = 0.5;
  rigg.highSlider = 0.5;
  rigg.strokeSlider= 0.5;
  rigg.blurValue = 0.2;

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

  if (keyT['s']) for (Anim anim : rigg.animations)  anim.funcFX = 1-(stutter*noize1*0.1);
 
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
