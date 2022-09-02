WLED wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls, wledSeedsA, wledSeedsB;
OPC opcLocal;

import java.util.*;
import static java.util.Map.entry;  
import java.util.Arrays;
import java.net.*;
import ch.bildspur.artnet.*;
import java.lang.reflect.*;

boolean SHITTYLAPTOP=false;//false;

final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ShieldsOPCGrid shieldsGrid;
LanternsGrid lanternGrid;
DiamondsGrid diamondsGrid;
BoothGrid boothGrid;

Rig shields, roof, cans, strips, donut, seeds, pars;
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

boolean onTop = false;

boolean testToggle, smokeToggle;
float boothDimmer, digDimmer, vizTime, colorChangeTime, colorSwapSlider, beatSlider = 0.3;
float smokePumpValue, smokeOnTime, smokeOffTime;

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
  
  shields = new Rig(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, RigType.Shields);
  //opcGrid = new OPCGrid();
  
  ///////////////// LOCAL opc /////////////////////
  Map<String,OPC> shieldOPCs = Map.ofEntries(
    entry("BigShield", new WLED(this, "192.168.8.10", 21324)),
    entry("SmallShieldA", new WLED(this, "192.168.8.11", 21324)),
    entry("MedShieldA", new WLED(this, "192.168.8.12", 21324)),
    entry("SmallShieldB", new WLED(this, "192.168.8.13", 21324)),
    entry("MedShieldB", new WLED(this, "192.168.8.14", 21324)),
    entry("SmallShieldC", new WLED(this, "192.168.8.15", 21324)),
    entry("MedShieldC", new WLED(this, "192.168.8.16", 21324)),
    entry("Balls", new WLED(this, "192.168.8.17", 21324)),
    entry("SeedsA", new WLED(this, "192.168.10.20", 21324)),
    entry("SeedsB", new WLED(this, "192.168.10.21", 21324))
  );

  shields.opcgrid = new ShieldsOPCGrid(shields);
  ((ShieldsOPCGrid)(shields.opcgrid)).spiralShieldsOPC(shieldOPCs);        // SHIELDS plug into RIGHT SLOTS A-F = 1-6 *** BIG SHIELD = 7 *** H-G = LEFT SLOTS 0-2 ***
  boothGrid = new BoothGrid(Map.ofEntries(
    entry("Entec",new OPC(this,"127.0.0.1",7890))
  ));
  
  //opcLocal   = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS
  //opcGrid.dmxSmokeOPC(opcLocal) ;

  audioSetup(100, 0.2); ///// AUDIO SETUP - sensitivity, beatTempo /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  alwaysDoFirst();

  shields.dimmer = 1;
  shields.alphaRate = 0.5;
  shields.functionRate = 0.5;
  vizTime = 0.5;
  colorChangeTime = 0.5;
  shields.wideSlider = 0.5;
  shields.highSlider = 0.5;
  shields.strokeSlider= 0.5;
  shields.blurriness = 0.2;
  frameRate(30); // always needs to be last in setup
}

int colStepper = 1;
int time_since_last_anim=0;
void draw()
{
  int start_time = millis();
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats(beatSlider);   
  //pause(10);           ////// number of seconds before no music detected and auto kicks in
  globalFunctions();

  fill(cc[14]*360);
  rect(boothGrid.uvs[0][0].x,boothGrid.uvs[3][0].y,3,80);
  
  if (frameCount > 10) playWithYourself(vizTime*60);
  c = shields.c;
  flash = shields.flash;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  if (beatTrigger) { 
    for (Rig rig : rigs) {
            //if (testToggle) rig.animations.add(new Test(rig));
        //println(rig.type," vizIndex", rig.vizIndex);
        rig.addAnim(rig.vizIndex);  // create a new anim object and add it to the beginning of the arrayList
      }
  }

  if (keyT['s']) for (Anim anim : shields.animations)  anim.funcFX = 1-(stutter*noize1*0.1);
 
  //////////////////// Must be after playwithme, before rig.draw()////
  for (Rig rig : rigs) rig.draw();  
  //////////////////////////////////////////// PLAY WITH ME MORE /////////////////////////////////////////////////////////////////////////////////
  playWithMeMore();
  //////////////////////////////////////////// BOOTH & DIG ///////////////////////////////////////////////////////////////////////////////////////
  //boothLights();
  //////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////
  //workLights(keyT['w']);
  //testColors(keyT['t']);
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
