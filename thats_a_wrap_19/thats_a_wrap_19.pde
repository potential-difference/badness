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
DMXGrid dmx;
OPC opcWifi;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ControlFrame controlFrame;
Rig rigg, roof, cans, mirrors, strips, donut;
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

//import codeanticode.syphon.*;
//PGraphics syphonImageReceived, syphonImageSent;
//SyphonClient syphonClient;
//SyphonServer syphonServer;

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

  opcGrid = new OPCGrid();
  dmx = new DMXGrid();

  rigg = new Rig(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");
  roof = new Rig(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight, "ROOF");
  cans = new Rig(size.cans.x, size.cans.y, size.cansWidth, size.cansHeight, "CANS");
  donut = new Rig(size.donut.x, size.donut.y, size.donutWidth, size.donutHeight, "DONUT");

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
  opcGrid.donutOPC(donut, opcLocal);
  //opcGrid.pickleCansOPC(cans, opcLocal);               
  //opcGrid.kingsHeadStripOPC(cans, opcESP);
  //opcGrid.espTestOPC(rigg, opcLocal);
  //grid.kingsHeadBoothOPC(opcLocal);
  //opcGrid.individualCansOPC(roof, opcLocal);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  beatStepBus = new MidiBus(this, "Arturia BeatStep", "Arturia BeatStep"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  drawingSetup();
  loadImages();
  loadShaders();

  rigg.vizIndex = 2;
  roof.vizIndex = 1;
  rigg.functionIndexA = 0;
  rigg.functionIndexB = 1;
  rigg.alphaIndexA = 0;
  rigg.alphaIndexB = 1;
  rigg.bgIndex = 0;
  roof.bgIndex = 4;

  rigg.colorIndexA = 0;
  rigg.colorIndexB = 14;
  roof.colorIndexA = 3;
  roof.colorIndexB = 4;
  cans.colorIndexA = 7;
  cans.colorIndexB = 11;
  donut.colorIndexA = 0;
  donut.colorIndexB = 14;

  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75;
  cc[2] = 0.75;
  cc[5] = 0.3;
  cc[6] = 0.75;
  cc[4] = 1;
  cc[8] = 1;
  cc[MASTERFXON] = 0;

  controlFrame = new ControlFrame(this); // load control frame must come after shild ring etc
  /*
  HashMap<String, String>[] allServers = SyphonClient.listServers();
   print("Available Syphon servers: ");
   print(allServers);
   if (allServers.length == 0) print("NO Syphon servers avaliable");
   String matt_servname = "MATTS-MACBOOK-PRO.LOCAL (VDMX-NDI® Output 1)";
   //String matt_servname2 = "MATTS-MACBOOK-PRO.LOCAL (VDMX-NDI® Output 2)";
   String matt_appname = "NDISyphon";
   syphonClient = new SyphonClient(this, matt_appname, matt_servname);// create syphon client to receive frames
   //syphonClient2 = new SyphonClient(this, matt_appname, matt_servname2);// create syphon client to receive frames
   
   syphonServer = new SyphonServer(this, "mirrors syphon");   // Create syhpon server to send frames out.
   println();
   syphonImageSent = createGraphics(rigg.wide, rigg.high, P2D);
   syphonImageSent.imageMode(CENTER);
   */
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

  //syphonImageSent.beginDraw();
  //syphonImageSent.background(0);
  //syphonImageSent.endDraw();
  //if (syphonToggle) if (syphonClient.newFrame()) syphonImageReceived = syphonClient.getGraphics(syphonImageReceived); // load the pixels array with the updated image info (slow)

  vizTime = 60*15*vizTimeSlider;
  if (frameCount > 10) playWithYourself(vizTime);
  c = rigg.c;
  flash = rigg.flash;
  /// DIMMING CONTROL STILL NOT QUITE AS EXPECTED 
  rigg.dimmer = rigDimmer;     // cc[4]
  roof.dimmer = roofDimmer;    // cc[8]
  cans.dimmer = cansDimmer;    // cc[5]

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  cans.vizIndex=roof.vizIndex;
  // create a new anim object and add it to the beginning of the arrayList
  if (beatTrigger) {
    if (rigToggle)    rigg.animations.add(new SquareNuts(alphaSlider, funcSlider, rigg));   
    if (cansToggle)   cans.animations.add(new Anim0(cansAlpha, funcSlider, cans));              // create an anim object for the cans 
    if (donutToggle)  donut.animations.add(new Anim1(alphaSlider, funcSlider, donut));              // create an anim object for the cans 
    if (roofToggle) {
      if (roofBasic) roof.animations.add(new AllOn(alphaSlider, funcSlider, roof));            // create a new anim object for the roof
      else roof.animations.add(new Stars(alphaSlider, funcSlider, roof));
    }
  }

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
  /*
  if (syphonToggle) {
   syphonServer.sendImage(syphonImageSent);
   image(syphonImageSent, size.rig.x+112.5, 455, 225, 87.5);
   if (syphonImageReceived != null) image(syphonImageReceived, size.rig.x-112.5, 455, 225, 87.5);
   }
   */
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
