PrintWriter outputmd; // Global variable to hold the PrintWriter object
MidiManager midiManager; // Declare MidiManager instance

import java.util.*;
import static java.util.Map.entry;  
import java.util.Arrays;
import java.net.*;
import ch.bildspur.artnet.*;
import java.lang.reflect.*;

SizeSettings size;

OPC opcLocal;
OPCGrid opcGrid;//oof
//Gig Specific
ShieldsOPCGrid shieldsGrid;
BoothGrid boothGrid;
Rig shields,tipiLeft,tipiRight,frontCans ,
outsideGround,outsideRoof,
megaSeedA,megaSeedB,megaSeedC,
filaments,megaWhite,
uvPars,
boothCans;

ArrayList <Rig> rigs = new ArrayList<Rig>();  
PFont font;

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5 = new OscP5(this,8000);

import themidibus.*;  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep
MidiBus MPD8bus;

boolean onTop = false;
boolean testToggle, smokeToggle;
float boothDimmer, mixerDimmer, digDimmer, vizChangeTime, colorChangeTime, colorSwapSlider, beatSlider = 0.3;
//float smokePumpValue, smokeOnTime, smokeOffTime;
int colStepper = 1;
int time_since_last_anim=0;

void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings();
  size(size.sizeX, size.sizeY, P2D);
}
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);

  outputmd = createWriter("rig coords.md");
  printmd("## coordinate and position information for each rig"); 

  ArrayList<Device> devices;
  try{
    devices = parseDevices(loadJSONArray("opcs.json"));
  }catch(Exception e){
    println("ERROR: FAILED TO PARSE opcs.json");
    e.printStackTrace();
    noLoop();
    return;
  }

  Map<String,OPC> OPCs;// = legacyOPCs(devices);
  Map<String,PixelMapping> channels;// = legacyChannels(devices);
  try{
   OPCs = legacyOPCs(devices);
   channels = legacyChannels(devices);
  }catch(Exception e){
    println("ERROR: ");
    e.printStackTrace();
    noLoop();
    return;
  }
  
  shields = new Rig(size.shields, RigType.Shields);
  shields.opcgrid = new ShieldsOPCGrid(shields);
  ((ShieldsOPCGrid)(shields.opcgrid)).bigTriangleShieldsOPC(OPCs); 
  //shields is special.
  //but everything else can be initialized like this:
  
  boothGrid = new BoothGrid(OPCs);

  // new rigs need to be iniciated inside RIG.pde too
  megaSeedA = new Rig(size.megaSeedA,RigType.MegaSeedA);
  megaSeedA.opcgrid = new MegaSeedAGrid(megaSeedA,OPCs);
  megaSeedB = new Rig(size.megaSeedB,RigType.MegaSeedB);
  megaSeedB.opcgrid = new MegaSeedBGrid(megaSeedB,OPCs);
  megaSeedC = new Rig(size.megaSeedC,RigType.MegaSeedC);
  megaSeedC.opcgrid = new MegaSeedCGrid(megaSeedC,OPCs);

  filaments = new Rig(size.filaments,RigType.Filaments);
  filaments.opcgrid = new FilamentsGrid(filaments,OPCs);
  megaWhite = new Rig(size.megaWhite,RigType.MegaWhite);
  megaWhite.opcgrid = new MegaWhiteGrid(megaWhite,OPCs);


  uvPars = new Rig(size.uvPars,RigType.UvPars);
  uvPars.opcgrid = new UvParsGrid(uvPars,OPCs);

  outsideGround = new Rig(size.outsideGround,RigType.OutsideGround);
  outsideGround.opcgrid = new OutsideGroundGrid(outsideGround,OPCs);

  outsideRoof = new Rig(size.outsideRoof,RigType.OutsideRoof);
  outsideRoof.opcgrid = new OutsideRoofGrid(outsideRoof,OPCs);
  
  boothCans = new Rig(size.boothCans,RigType.BoothCans);
  boothCans.opcgrid = new BoothCansGrid(boothCans,OPCs);

  tipiLeft = new Rig(size.tipiLeft,RigType.TipiLeft);
  String tipiLeftChannels[] = new String[9];
  char idk[] = {'A','B','C','D','E','F','G','H','I'};
  for(int i = 0;i<9;i++){
    tipiLeftChannels[i] = "LunchBox1/lantern" + idk[i];
  }// = {"Lu","pix1","pix2","pix3","pix4","pix5","pix6","pix7","pix8"};
  tipiLeft.opcgrid = new CircularRoofGrid(tipiLeft,OPCs,channels,tipiLeftChannels);

  tipiRight = new Rig(size.tipiRight,RigType.TipiRight);
  String tipiRightChannels[] = new String[9];// = {"pix9","pix10","pix11","pix12","pix13","pix14","pix15","pix16","pix17"};
  for(int i = 0; i<9;i++){
    tipiRightChannels[i] = "LunchBox2/lantern" + idk[i];
  }
  tipiRight.opcgrid = new CircularRoofGrid(tipiRight,OPCs,channels,tipiRightChannels);

  frontCans = new Rig(size.frontCans,RigType.FrontCans);
  String frontCanChannels[] = {"LunchBox2/frontCansRight","LunchBox1/frontCansLeft"};
  frontCans.opcgrid = new CircularRoofGrid(frontCans,OPCs,channels,frontCanChannels);

  audioSetup(100, 0.2); ///// AUDIO SETUP - sensitivity, beatTempo /////
  midiManager = new MidiManager();        // Initialize MidiManager
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  alwaysDoFirst();
 
  for (Rig rig : rigs) setupLocalCoords(rig); // rig.pixelPosition used to store pixel coords in rig grid space
  for (Rig rig : rigs) markDownInfo(rig);     // print all rig info to md file.
  for(Rig rig : rigs) println(rig.type+" "+rig.pixelPosition); // print all rig into to termial
  outputmd.flush(); // Flush the output to ensure all data is written to the file
  outputmd.close(); // Close the PrintWriter object
  
  frameRate(30); // always needs to be last in setup
}
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
void draw()
{
 midiManager.processFrame();   // Process frame actions

  int start_time = millis();
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beats(beatSlider);   
  //pause(10);           ////// number of seconds before no music detected and auto kicks in
  globalFunctions();
  
  
  if (frameCount > 10) playWithYourself();
  // TODO made a global variable class to include these and alpha and funcs
  c = rigs.get(0).c;
  flash = rigs.get(0).flash;
  c1 = rigs.get(0).c1;
  flash1 = rigs.get(0).flash1;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////// PLAY WITH ME ////////////////////////////////////////////////////////////
  playWithMe();
  if (beatTrigger) { 
    
    for (Rig rig : rigs) {
        //if (testToggle) rig.animations.add(new Test(rig));
      if (rig.onBeat){
        rig.addAnim(rig.vizIndex);  // create a new anim object and add it to the beginning of the arrayList
      }
      }
  }

  if (keyT['s']) for (Anim anim : shields.animations)  anim.funcFX = 1-(stutter*noize1*0.1);
 
 
  //////////////////// Must be after playwithme, before rig.draw() //////////////////////////////////////////////////////
  for (Rig rig : rigs) rig.draw();  
  ///////////////////////////////////////////// PLAY WITH ME MORE ///////////////////////////////////////////////////////
  //playWithMeMore();
  ///////////////////////////////////////////// BOOTH & DIG /////////////////////////////////////////////////////////////
  boothLights(boothGrid);
  ///////////////////////////////////////////// BLINDERS FM22 ///////////////////////////////////////////////////////////
  // blinders(boothGrid);
  ///////////////////////////////////////////// DISPLAY //////////////////////////////////////////////////////////////////
  testColors(keyT['t']);
  ///////////////////////////////////////////// !!!SMOKE!!! //////////////////////////////////////////////////////////////
  //dmxSmoke(Grids.get("boothgrid")); //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  ///////////////////////////////////////////// OUTSIDE ROOF AND GROUND ///////////////////////////////////////////////////////////////////////////
  // add a solid coulsour sodute 
  fill(c, 360*cc[3]);
  rect(800,650, 120,80);

  fill(flash, 360*cc[12]);
  rect(1000,650, 120,80);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  mouseCircle(keyT['q']);
  onScreenInfo();
  pauseInfo();


}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// THE END ///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
