OPC opc;
OPC opcLocal;
OPC opcMirror1;
OPC opcMirror2;
OPC opcSeeds;
OPC opcCans;
OPC opcControllerA;
OPC opcControllerB;

SizeSettings size = new SizeSettings();
OPCGrid grid;
Toggle toggle;

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import themidibus.*;  
MidiBus TR8bus;       // midibus for TR8
MidiBus faderBus;     // midibus for APC mini
MidiBus LPD8bus;      // midibus for LPD8
MidiBus myBus;

float cc[] = new float[128];   //// An array where to store the last value received for each knob
float prevcc[] = new float[128];
int time[] = new int[12]; // array of timers to use throughout the sketch
int surfacePositionX = 710, surfacePositionY = 400;

PShader maskShader;
PGraphics maskImage, maskedImage;
PVector[] DMXpar = new PVector[6];

PFont myFont;

void settings() {
  size(size.sizeX, size.sizeY, P2D);
}
boolean onTop = false;

void setup()
{
  /// size moved to settings - see above
  //surface.setAlwaysOnTop(true);
  size.surfacePositionX = 720;
  size.surfacePositionY = 200;
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  surface.setAlwaysOnTop(onTop);


  ///////////////// LOCAL opc  /////////////////////
  //opc = new OPC(this, "127.0.0.1", 7890);            // Connect to the local instance of fcserver - MIRRORS
  opcMirror1 = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRROR 1 - used coz of issues with the remote conneciton
  opcMirror2 = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRROR 1 - used coz of issues with the remote conneciton
  opcSeeds = new OPC(this, "127.0.0.1", 7890);         // Connect to the remote instance of fcserver - SEEDS BOX IN ROOF - also had issues with this one so had to remove it
  opcCans = new OPC(this, "127.0.0.1", 7890);          // Connect to the remote instance of fcserver - CANS BOX
  opcControllerA = new OPC(this, "127.0.0.1", 7890);   // Connect to the remote instance of fcserver - LEFT TWO CONTROLLERS
  opcControllerB = new OPC(this, "127.0.0.1", 7890);   // Connect to the remote instance of fcserver - RIGHT PAIR OF CONTROLLERS

  ///////////////// OPC over WIFI /////////////////////
  //opcMirror1 = new OPC(this, "10.168.1.58", 7890);       // Connect to the remote instance of fcserver - MIRROR 1
  //opcMirror2 = new OPC(this, "10.168.1.179", 7890);      // Connect to the remote instance of fcserver - MIRROR 2
  //opcCans = new OPC(this, "10.168.1.86", 7890);          // Connect to the remote instance of fcserver - CANS BOX
  //opcSeeds = new OPC(this, "127.0.0.1", 7890);           // Connect to the remote instance of fcserver - SEEDS BOX IN ROOF - also had issues with this one so had to remove it
  //opcControllerA = new OPC(this, "10.168.1.28", 7890);   // Connect to the remote instance of fcserver - LEFT TWO CONTROLLERS
  //opcControllerB = new OPC(this, "10.168.1.89", 7890);   // Connect to the remote instance of fcserver - RIGHT PAIR OF CONTROLLERS

  grid = new OPCGrid();
  grid.kallidaMirrors(opcMirror1, opcMirror2, 0);               // grids 0-3 MIX IT UPPPPP 
  grid.kallidaCans(opcCans);                                  // grids 0-3 MIX IT UPPPPP 
  grid.kallidaSeeds(opcSeeds);
  grid.kallidaControllers(opcControllerA, opcControllerB, 2);   // grids 0-3 MIX IT UPPPPP 

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  /* start oscP5, listening for incoming messages at port 5000 to 5003 */
  for (int i = 0; i < 4; i++) oscP5[i] = new OscP5(this, 5000+i);
  oscAddrSetup();

  dimmer = 1; // must come before load control frame

  toggle = new Toggle();

  drawingSetup();
  loadImages();
  loadGraphics();
  colorSetup();
  colorArray();

  controlFrame = new ControlFrame(this, width, 130, "Controls"); // load control frame must come after shild ring etc

  blur = loadShader("blur.glsl");
  loadShaders(10);

  rigViz = 4;
  roofViz = 1;
  rigBgr = 1;    
  co = 1;    // set c start
  co1 = 2;   // set flash start
  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 9; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  //hint(DISABLE_OPTIMIZED_STROKE);
  cc[1] = 0.75;
  cc[6] = 0.75;
  cc[8] = 0;

  frameRate(30);
}
float vizTime, colTime;
int roofViz, rigViz, colStepper = 1;

void draw()
{
    surface.setAlwaysOnTop(onTop);

  background(0);
  //dimmer = bgDimmer;
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                        ////// number of seconds before no music detected
  noize();
  oskPulse();
  arrayDraw();
  clash(func);                         ///// clash colour changes on function in brackets

  ////// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
  blury = int(map(blurSlider, 0, 1, 0, 30));
  if (blury!=prevblury) {
    prevblury=blury;
    loadShaders(blury);
  }

  //if (keyT[97]) colStepper = 2;
  //else colStepper = 1;
  colTime = colorTimerSlider*60*30;
  colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours


  //dimmer = cc[4]*rigDimmer;
  vizTime = 60*15*vizTimeSlider;
  playWithYourself(vizTime); 
  playWithMe();

  //oscControl();

  float rigDimmerPad = cc[4]; // come back to this with wigflex code?!
  float roofDimmerPad = cc[8]; // come back to this with wigflex code?!

  rigVizSelection(rigWindow, rigViz, rigDimmerPad*rigDimmer);                           // develop one visulisation
  //roofVizSelection(roofWindow, roofViz, roofDimmerPad*roofDimmer);    // develop 2nd visulisation

  if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;                // change colour layer automatically
  colorLayer(rigColourLayer, rigBgr);                                // develop colour layer
  image(rigColourLayer, size.rigWidth/2, size.rigHeight/2);         // draw rig colour layer to rig window
  blendMode(MULTIPLY);
  image(rigWindow, size.rigWidth/2, size.rigHeight/2);
  blendMode(NORMAL);

  //toggle roof viz with tilda key '~' 
  if (!keyT[96]) {
    colorLayer(roofColourLayer, roofBgr);  
    image(roofColourLayer, size.roof.x, size.roof.y);                      // draw roof colour layer to roog window
    blendMode(MULTIPLY);
    image(roofWindow, size.roof.x, size.roof.y);
    blendMode(NORMAL);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////

  image(infoWindow, size.info.x, size.info.y);

  //////////////////////////////////////////// SEEDS SHIT ///////////////////////////////////////////////////////////////////////////////
  if (keyP[48]) { // beatCounter % 100 >   92
    rigControl(0, 1);
    cansControl(0, 1);
    // add uv control////
    fill(flash, 360*(pulz*0.8+(stutter*0.2)));
    rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
    rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
    rect(grid.seed[2].x, grid.seed[2].y, 3, grid.seedLength);
  }
  /*
size.seed1X = size.rig.x;
   size.seed2X = size.rig.x;
   size.seed3X = size.rig.x;
   
   size.seed1Y = size.rig.y-(rigHeight/1.5);
   size.seed2Y = size.rig.y+(rigHeight/1.5);
   size.seed3Y = size.rig.y;
   
   
   if (button[0])  cansControl(0,0); 
   if (button[1]) seedsControlA(0, 0);
   if (button[2]) rigControl(0,0);
   if (button[3]) seedsControlB(0, 0);
   if (button[4]) controllerControl(0, 0);
   
   if (keyP[55]) cansControl(flash, stutter); 
   if (keyP[56]) seedsControlA(flash, stutter);
   //if (keyP[57])  colorSwap(0.9999999);
   */

  /////////////////////////////////////////////// UV /////////////////////////////////////////////////////////////////////////////////////
  fill(360, ((180*noize)+(180*pulz))*uvDimmer);
  ellipse(grid.uv.x, grid.uv.y, 3, 3);

  ///////////////////////////////////////////CANS //////////////////////////////////////
  fill(0, 360-(360*cansDimmer));
  rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
  rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);

  /////////////////////////////////////////// SEEDS ///////////////////////////////////////////////////////////
  fill(0, 360-(360*seedsDimmer));
  rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
  rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);

  fill(0, 360-(360*seed2Dimmer));
  rect(grid.seed[2].x, grid.seed[2].y, 3, grid.seed2Length);

  //////////////////////////////// CONTROLLERS //////////////////////////////////////////////////////////////

  controllerControl(flash1, (0.7+(0.3*noize1))*controllerDimmer);


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //playWithMeMore();

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
  if (test) {
    fill((millis()/50)%360, 100, 100);           
    rect(size.rig.x, size.rig.y, width, height);
  }
  /////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
  if (work) {
    pause = 10;
    fill(360*cc[9], 360*cc[10]);
    rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    rect(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  fill(flash);
  rect(size.rigWidth, height/2, 1, height);                     ///// vertical line to show end of rig viz area
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);      ///// vertical line to show end of roof viz area
  fill(flash, 80);    
  rect((size.rigWidth+size.roofWidth)/2, height-size.sliderHeight, size.rigWidth+size.roofWidth, 1);                              ///// horizontal line to show bottom area

  // code to develop and then draw preview boxes 
  image(infoWindow, size.info.x, size.info.y);
  onScreenInfo();                ///// display info about current settings, viz, funcs, alphs etc
  colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////
  //gid.mirrorTest(false);          // true to test physical mirror orientation
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
