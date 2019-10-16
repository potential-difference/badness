OPC opc;
OPC opcLocal;
OPC opcMirrors; 
OPC opcMirror1; 
OPC opcMirror2;
OPC opcSeeds;
OPC opcCans;
OPC opcControllerA;
OPC opcControllerB;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;

SizeSettings size;
OPCGrid grid;
Toggle toggle = new Toggle();

SketchColor rig = new SketchColor();
SketchColor roof = new SketchColor();

ArrayList <Anim> animations;
Visualisation visual[] = new Visualisation[2];

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import themidibus.*;  
MidiBus TR8bus;       // midibus for TR8
MidiBus faderBus;     // midibus for APC mini
MidiBus LPD8bus;      // midibus for LPD8

int time[] = new int[12]; // array of timers to use throughout the sketch

PFont myFont;
boolean onTopToggle = false;

void settings() {
  size = new SizeSettings(LANDSCAPE);

  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 800;
  size.surfacePositionY = 300;
}

float dimmer = 1;
void setup()
{
  surface.setAlwaysOnTop(onTopToggle);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  grid = new OPCGrid();

  ///////////////// LOCAL opc /////////////////////
  opcMirrors = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRRORS
  opcCans = new OPC(this, "127.0.0.1", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  ///////////////// OPC over NETWORK /////////////////////
  //opcMirrors = new OPC(this, "192.168.0.70", 7890);       // Connect to the remote instance of fcserver - MIRROR 1
  //opcCans = new OPC(this, "10.168.1.86", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  grid.mirrorsOPC(opcMirrors, opcMirrors, 0);               // grids 0-3 MIX IT UPPPPP 
  grid.pickleCansOPC(opcCans);               

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  //loadAudio();     // load one shot sounds ///

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  /* start oscP5, listening for incoming messages at port 5000 to 5003 */
  for (int i = 0; i < 4; i++) oscP5[i] = new OscP5(this, 5000+i);
  oscAddrSetup();

  animations = new ArrayList<Anim>();
  animations.add(new Anim(size.rig.x, size.rig.y, 0));
  for (int i=0; i < visual.length; i++) visual[i] = new Visualisation();

  //dimmer = 1; // must come before load control frame
  drawingSetup();
  loadImages();
  loadGraphics();
  colorSetup();  
  rig.colorArray();
  roof.colorArray();

  controlFrame = new ControlFrame(this, width, 130, "Controls"); // load control frame must come after shild ring etc

  rigViz = 0;
  roofViz = 1;
  rigBgr = 1;    
  rig.c = purple;    // set c start
  rig.flash = orange;   // set flash start

  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75;
  cc[6] = 0.75;
  cc[8] = 1;
  cc[MASTERFXON] = 0;
  frameRate(30);
}
float vizTime, colTime;
int roofViz, rigViz, colStepper = 1;
int time_since_last_anim=0;
void draw()
{
  surface.setAlwaysOnTop(onTopToggle);

  background(0);
  //dimmer = bgDimmer;
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                                ////// number of seconds before no music detected
  globalFunctions();
  //rig.clash(func);                          ///// clash colour changes on function in brackets
  //roof.clash(func);                         ///// clash colour changes on function in brackets

  //dimmer = cc[4]*rigDimmer;
  //vizTime = 60*15*vizTimeSlider;
  //playWithYourself(vizTime); 
  //playWithMe();

  float rigDimmerPad = cc[4]; // come back to this with wigflex code?!
  float roofDimmerPad = cc[8]; // come back to this with wigflex code?!

  //rigVizSelection(rigWindow, rigDimmerPad*rigDimmer);               // develop rig visulisation
  //if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;               // change colour layer automatically

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // trigger new animnations 
  if (keyP[' ']) animations.add(new Anim(size.rig.x, size.rig.y, rigViz));                                                    // or space bar!
  if ( keyP['d']) animations.add(new Anim(size.rig.x, size.rig.y, 1));
  if (cc[101] > 0) {
    animations.add(new Anim(size.rig.x, size.rig.y, 1));
    animations.get(animations.size()-1).funcFX = cc[1];
  }
  if (beatDetect.isOnset()) animations.add(new Anim(size.rig.x, size.rig.y, rigViz));   // create a new anim object and add it to the beginning of the arrayList
  // limit the number of animations
  if (animations.size() >= 16) animations.remove(0);  
  // adjust animations
  if (keyT['a']) for (Anim anim : animations)  anim.alphFX = 1-(stutter*0.1);
  if (keyT['s']) for (Anim anim : animations)  anim.funcFX = 1-(stutter*noize1*0.1);
  //draw animations
  blendMode(LIGHTEST);
  for (int i = animations.size()-1; i >=0; i--) {                                  // loop  through the list
    Anim anim = animations.get(i);  
    anim.drawAnim();           // draw the animation
  }
  // draw colour layer
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  blendMode(MULTIPLY);
  colorLayer(rigColourLayer, rigBgr);                               // develop colour layer
  image(rigColourLayer, size.rigWidth/2, size.rigHeight/2);         // draw rig colour layer to rig window
  blendMode(NORMAL);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ///////////////////////////////////////////CANS //////////////////////////////////////
  fill(0);
  rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
  rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);

  if (beat <0.3) {
    fill(rig.flash, ((1-beat*0.6)+(0.3*noize1)+(0.05*1-beat*stutter))*360*cansDimmer); //       (280*noize)+(100*shimmer)+(120*1-beat));
    rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
    rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);
  }

  //////////////////////////////// PLAY WITH ME MORE //////////////////////////////////////////////////////////////////////////////
  playWithMeMore();

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
  /////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////

  fill(rig.flash);
  rect(size.rigWidth, height/2, 1, height);                     ///// vertical line to show end of rig viz area
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);      ///// vertical line to show end of roof viz area
  fill(rig.flash, 80);    
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
