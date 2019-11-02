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
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid grid;
ControlFrame controlFrame;
Toggle toggle = new Toggle();

SketchColor rigColor = new SketchColor();
SketchColor roofColor = new SketchColor();

ArrayList <Anim> animations;

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
boolean onTop = true, manualToggle = false;

void settings() {
  size = new SizeSettings(LANDSCAPE);

  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 800;
  size.surfacePositionY = 300;
}

float dimmer = 1;
void setup()
{
  surface.setAlwaysOnTop(onTop);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  grid = new OPCGrid();

  ///////////////// LOCAL opc /////////////////////
  opcMirrors = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRRORS
  opcCans = new OPC(this, "127.0.0.1", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  ///////////////// OPC over NETWORK /////////////////////
  //opcMirrors = new OPC(this, "192.168.0.70", 7890);       // Connect to the remote instance of fcserver - MIRROR 1
  //opcCans = new OPC(this, "192.168.0.10", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  grid.mirrorsOPC(opcMirrors, opcMirrors, 0);               // grids 0-3 MIX IT UPPPPP 
  grid.pickleCansOPC(opcCans);               
  grid.pickleBoothOPC(opcCans);               

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.


  drawingSetup();
  loadImages();
  loadGraphics();
  loadShaders();
  colorSetup();  

  rigColor.colorArray();
  roofColor.colorArray();
  rigViz = 0;
  roofViz = 1;
  rigBgr = 1;
  roofBgr = 1;
  rigColor.c = purple;        // set c start
  rigColor.flash = orange;    // set flash start
  roofColor.c = orange;       // set c start
  roofColor.flash = purple;   // set flash start
  dimmer = 1;

  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75;
  cc[6] = 0.75;
  cc[8] = 1;
  cc[MASTERFXON] = 0;

  controlFrame = new ControlFrame(this, width, 130, "Controls"); // load control frame must come after shild ring etc

  animations = new ArrayList<Anim>();
  animations.add(new Anim(0, alphaSlider, funcSlider, rigDimmer));


  frameRate(30);
}
float vizTime, colTime;
int roofViz, rigViz, colStepper = 1;
int time_since_last_anim=0;
void draw()
{
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                                ////// number of seconds before no music detected
  globalFunctions();

  vizTime = 60*15*vizTimeSlider;
  playWithYourself(vizTime); 

  //blur.set("blurSize", 0);

  //////////// WHY DOESN't THIS WORK???? ?/////////////////////////////
  ///// ECHO RIG DIMMER SLIDER AND MIDI SLIDER 4 to control rig dimmer but only whne slider is changed
  //if (cc[4]!=prevcc[4]) {
  //  prevcc[4]=cc[4];
  //  if (cc[4] != rigDimmer) cp5.getController("rigDimmer").setValue(cc[4]);
  //}  

  //if (cc[8]!=prevcc[8]) {
  //   prevcc[8]=cc[8];
  //   if (cc[8] != roofDimmer) cp5.getController("roofDimmer").setValue(cc[8]);
  // }  

  rigDimmer = cc[4]; // come back to this with wigxxxflex code?!
  roofDimmer = cc[8]; // come back to this with wigflex code?!

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  // trigger new animnations 
  if (!manualToggle) if (beatDetect.isOnset()) {
    animations.add(new RoofAnim(roofViz, cansAlpha, funcSlider, roofDimmer));     // create an anim object for the cans specficially doing something simple
    animations.add(new Anim(rigViz, alphaSlider, funcSlider, rigDimmer));   // create a new anim object and add it to the beginning of the arrayList
  }
  //////////////////////////////// NEED TO LOOK AT A BETTER WAY OF DOING THIS ...................///////////////////////////////
  //////////////////////////////////// MAYBE SORTED THIS WITH  deleteMeSliderr and deleteMeSlider 
  // limit the number of animations
  while (animations.size()>0 && animations.get(0).deleteme) {
    animations.remove(0);
  }
  if (animations.size() >= 24) animations.remove(0);  
  textAlign(RIGHT);
  text("# of anims: "+animations.size(), width - 5, height - 10);
  // adjust animations
  if (keyT['a']) for (Anim anim : animations)  anim.alphFX = 1-(stutter*0.1);
  if (keyT['s']) for (Anim anim : animations)  anim.funcFX = 1-(stutter*noize1*0.1);
  //draw animations
  blendMode(LIGHTEST);
  for (int i = animations.size()-1; i >=0; i--) {                                  // loop  through the list
    Anim anim = animations.get(i);  
    anim.drawAnim();           // draw the animation
  }
  ////////////////////// draw colour layer /////////////////////////////////////////////////////////////////////////////////////////////////////
  blendMode(MULTIPLY);
  colorLayer(rigColourLayer, rigBgr);
  colorLayer(roofColourLayer, roofBgr);

  if (cc[106] > 0 || keyT['r'] || glitchToggle) bgNoise(rigColourLayer, 0, 0, cc[6]); //PGraphics layer,color,alpha
  // develop colour layer
  image(rigColourLayer, size.rig.x, size.rig.y);            // draw rig colour layer to rig window
  image(roofColourLayer, size.roof.x, size.roof.y);         // draw roof colour layer to rig window
  blendMode(NORMAL);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////// PLAY WITH ME MORE //////////////////////////////////////////////////////////////////////////////
  playWithMeMore();

  ///////////////////////////////////// BOOTH & DIG //////////////////////////////////////////////////////////////
  fill(rigColor.c1, 360*boothDimmer);
  rect(grid.booth.x, grid.booth.y, 30, 10);
  fill(rigColor.flash1, 360*digDimmer);
  rect(grid.dig.x, grid.dig.y, 30, 10);

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
  onScreenInfo();                ///// display info about current settings, viz, funcs, alphs etc
  colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////
  //gid.mirrorTest(false);          // true to test physical mirror orientation
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
