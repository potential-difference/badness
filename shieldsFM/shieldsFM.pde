WLED wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls, wledSeedsA, wledSeedsB;
OPC opcLocal;

import java.util.*;
import static java.util.Map.entry;  
import java.util.Arrays;
import java.net.*;
import ch.bildspur.artnet.*;
import java.lang.reflect.*;

boolean SHITTYLAPTOP=true;//false;

final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;

//Gig Specific
ShieldsOPCGrid shieldsGrid;
BoothGrid boothGrid;
Rig shields, roofmid,roofsides,bar,booth, megaSeeds,cans,roof;

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
float boothDimmer=0.5, mixerDimmer=0.5, digDimmer=1.0, vizTime, colorChangeTime, colorSwapSlider, beatSlider = 0.3;
float smokePumpValue, smokeOnTime, smokeOffTime;
float uvDimmer=0.2;
float uvSpeed=0.5;
float uvProgram=0.5;
void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings();
  //fullScreen();
  size(size.sizeX, size.sizeY, P2D);
}

void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);
  
  ///////////////// LOCAL opc /////////////////////
  Map<String,OPC> OPCs = Map.ofEntries(
    entry("BigShield", new WLED(this, "192.168.10.10", 21324)),
    entry("SmallShieldA", new WLED(this, "192.168.10.11", 21324)),//bottom right
    entry("MedShieldA", new WLED(this, "192.168.10.12", 21324)),
    entry("SmallShieldB", new WLED(this, "192.168.10.13", 21324)),//bottom left
    entry("MedShieldB", new WLED(this, "192.168.10.14", 21324)),
    entry("SmallShieldC", new WLED(this, "192.168.10.15", 21324)),
    entry("MedShieldC", new WLED(this, "192.168.10.16", 21324)), //bottom right
    entry("Balls", new WLED(this, "192.168.10.17", 21324)),
    //entry("SeedsA", new WLED(this, "192.168.10.20", 21324)),
    //entry("SeedsB", new WLED(this, "192.168.10.21", 21324)),
    entry("Entec",new OPC(this,"127.0.0.1",7890)),

    entry("FrontLeft",new WLED(this,"192.168.10.50",21324)),
    //A:boothL B:mixer C:boothR D:dig E:leftfar
    
    entry("FrontRight",new WLED(this,"192.168.10.40",21324)),
    //A:leftmid B:rightmid C:righfar
//A: 19,B: 18, C: 17, D: 16, 4
    entry("Truss",new WLED(this,"192.168.10.60",21324)),
    //A:barleft B:barmid C:barright D:truss E:centre

    entry("FrontSeed",new WLED(this,"192.168.10.90",21324)),
    entry("CentreSeed",new WLED(this,"192.168.10.30",21324))
  );
  Map<String,LanternInfo> units = Map.ofEntries(
    entry("leftmid", new LanternInfo("leftmid","FrontRight",0,new int[] {1,1,25,1,1})),
    entry("leftfar", new LanternInfo("leftfar","FrontLeft",400,new int[] {1,25,1,1,25})),
    entry("rightmid",new LanternInfo("rightmid","FrontRight",100,new int[]{25,1,1,25,1,1})),
    entry("rightfar",new LanternInfo("rightfar","FrontRight",200,new int[]{1,1,25,1})),
    entry("truss", new LanternInfo("truss","Truss",300,new int[]{1})),
    entry("centre", new LanternInfo("centre","Truss",400,new int[]{1,25})),
    entry("barleft", new LanternInfo("barleft","Truss",0,new int[]{1})),
    entry("barmid", new LanternInfo("barmid","Truss",100,new int[]{1})),
    entry("barright", new LanternInfo("barright","Truss",200,new int[]{1}))
  );
  shields = new Rig(size.shields, RigType.Shields);
  shields.opcgrid = new ShieldsOPCGrid(shields);
  ((ShieldsOPCGrid)(shields.opcgrid)).spiralShieldsOPC(OPCs); 

  //opc: FrontLeft
  //boothL,mixer,boothR,dig, (leftfar)
  //100    200   300    400
  //rectangles are:
  //mixer,dig,booth
  //
  boothGrid = new BoothGrid(OPCs);

  megaSeeds = new Rig(size.megaSeeds,RigType.MegaSeeds);
  //opc:FrontSeed,CentreSeed
  //frontseed, centreseed
  //FrontSeed(0)  CentreSeed(0)
  //pvectors are:
  //frontseed,centreseed
  //positions are:
  //same
  megaSeeds.opcgrid = new MegaSeedsGrid(megaSeeds,OPCs);

  roofmid = new Rig(size.roofmid,RigType.RoofMid);
  //opc: FrontLeft,FrontRight
  //leftmid, leftfar
  //1+1+25+1+1  1+25+1+1+25
  //FrontRight(100) FrontLeft(500)
  //
  String roofmidunits[] = {"leftmid","truss","rightmid"};
  roofmid.opcgrid = new FMRoofGrid(roofmid,OPCs,units,roofmidunits);

  roofsides = new Rig(size.roofsides,RigType.RoofSides); // name change of rig
  //opc:FrontRight
  //rightmid rightfar
  //25+1+1+25+1+1         1+1+25+1  
  //FrontRight(100) FrontRight(200)
  String roofsidesunits[] = {"leftfar","centre", "rightfar"};
  roofsides.opcgrid = new FMRoofGrid(roofsides,OPCs,units,roofsidesunits);
  
  bar = new Rig(size.bar,RigType.Bar);
  //opc:Truss
  //barleft barmid barright
  //1     1     1
  String barunits[] = {"barleft","barmid","barright"};
  bar.opcgrid = new FMRoofGrid(bar,OPCs,units,barunits);


//

  audioSetup(100, 0.2); ///// AUDIO SETUP - sensitivity, beatTempo /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  alwaysDoFirst();
  vizTime = 0.5;
  colorChangeTime = 0.5;
  for (Rig rig :rigs){
   rig.dimmer = 1;
  rig.alphaRate = 0.5;
  rig.functionRate = 0.5;
  rig.wideSlider = 0.5;
  rig.highSlider = 0.5;
  rig.strokeSlider= 0.5;
  rig.blurriness = 0.2;
 
  }
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

  
  if (frameCount > 10) playWithYourself(vizTime*60*8);
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
  boothLights(boothGrid);
  ///////////////////UV BATONS/////////
  uvBatons(boothGrid);
  //////////////////////BLINDERS//////////
  //static boolean blindersOn = false;
  //to create a dimmer
  //make a new global variable blinderDimmer=0.2 or whatever
  //then copy and paste a fader in touchosc
  //under the booth panel
  //change the name to blinderDimmer
  //and the label to blinderDimmer
  if (beatCounter % 32 < 4){
    if (shields.animations.size() > 0){
      Anim anim = shields.animations.get(0);
      fill(100*anim.alphaA);
      rect(boothGrid.blinders);
    }
  }
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
