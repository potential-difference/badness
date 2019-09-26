OPC opc;
OPC opcLocal;
OPC opcMirror1; 
OPC opcMirror2;
OPC opcSeeds;
OPC opcCans;
OPC opcControllerA;
OPC opcControllerB;

SizeSettings size = new SizeSettings();
OPCGrid grid = new OPCGrid();
Toggle toggle = new Toggle();

SketchColor rig = new SketchColor();
SketchColor roof = new SketchColor();

ArrayList <Anim> animations;
Visualisation visualisation = new Visualisation();

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
boolean onTop = false;

void settings() {
  size(size.sizeX, size.sizeY, P2D);
}

void setup()
{
  /// size moved to settings - see above
  //surface.setAlwaysOnTop(true);
  size.surfacePositionX = 720;
  size.surfacePositionY = 200;
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  surface.setAlwaysOnTop(onTop);

  ///////////////// LOCAL opc /////////////////////
  //opc = new OPC(this, "127.0.0.1", 7890);            // Connect to the local instance of fcserver - MIRRORS
  //opcMirror1 = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRROR 1 - used coz of issues with the remote conneciton
  //opcMirror2 = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRROR 1 - used coz of issues with the remote conneciton
  opcSeeds = new OPC(this, "127.0.0.1", 7890);         // Connect to the remote instance of fcserver - SEEDS BOX IN ROOF - also had issues with this one so had to remove it
  opcCans = new OPC(this, "127.0.0.1", 7890);          // Connect to the remote instance of fcserver - CANS BOX
  //opcControllerA = new OPC(this, "127.0.0.1", 7890);   // Connect to the remote instance of fcserver - LEFT TWO CONTROLLERS
  //opcControllerB = new OPC(this, "127.0.0.1", 7890);   // Connect to the remote instance of fcserver - RIGHT PAIR OF CONTROLLERS

  ///////////////// OPC over NETWORK /////////////////////
  opcMirror1 = new OPC(this, "192.168.0.70", 7890);       // Connect to the remote instance of fcserver - MIRROR 1
  //opcMirror2 = new OPC(this, "192.168.0.5", 7890);      // Connect to the remote instance of fcserver - MIRROR 2
  //opcCans = new OPC(this, "10.168.1.86", 7890);          // Connect to the remote instance of fcserver - CANS BOX
  opcSeeds = new OPC(this, "192.168.0.20", 7890);           // Connect to the remote instance of fcserver - SEEDS BOX IN ROOF - also had issues with this one so had to remove it
  opcControllerA = new OPC(this, "192.168.0.80", 7890);   // Connect to the remote instance of fcserver - LEFT TWO CONTROLLERS
  //opcControllerB = new OPC(this, "10.168.1.89", 7890);   // Connect to the remote instance of fcserver - RIGHT PAIR OF CONTROLLERS

  grid.kallidaMirrors(opcMirror1, opcMirror1, 0);               // grids 0-3 MIX IT UPPPPP 
  grid.kallidaCans(opcCans);                                  
  grid.kallidaUV(opcCans);
  grid.kallidaSeeds(opcSeeds);
  grid.kallidaControllers(opcControllerA, opcControllerA, 2);   // grids 0-3 MIX IT UPPPPP 

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  loadAudio();     // load one shot sounds ///

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  /* start oscP5, listening for incoming messages at port 5000 to 5003 */
  for (int i = 0; i < 4; i++) oscP5[i] = new OscP5(this, 5000+i);
  oscAddrSetup();

  animations = new ArrayList<Anim>();
  animations.add(new Anim());
  //for (int i = 0; i < animations.size(); i++)
  //Anim anim = animations.get(i);
  //anim.setupAnim();


  dimmer = 1; // must come before load control frame
  drawingSetup();
  loadImages();
  loadGraphics();
  colorSetup();  
  rig.colorArray();
  roof.colorArray();

  controlFrame = new ControlFrame(this, width, 130, "Controls"); // load control frame must come after shild ring etc

  blur = loadShader("blur.glsl");
  loadShaders(10);

  rigViz = 4;
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
void draw()
{
  background(0);
  //dimmer = bgDimmer;
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                                ////// number of seconds before no music detected
  noize();
  oskPulse();
  //arrayDraw();
  rig.clash(func);                          ///// clash colour changes on function in brackets
  roof.clash(func);                         ///// clash colour changes on function in brackets

  ////// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
  //blury = int(map(blurSlider, 0, 1, 0, 100));
  //if (blury!=prevblury) {
  //  prevblury=blury;
  //  loadShaders(blury);
  //}

  //dimmer = cc[4]*rigDimmer;
  vizTime = 60*15*vizTimeSlider;
  playWithYourself(vizTime); 
  playWithMe();

  float rigDimmerPad = cc[4]; // come back to this with wigflex code?!
  float roofDimmerPad = cc[8]; // come back to this with wigflex code?!

  //rigVizSelection(rigWindow, rigDimmerPad*rigDimmer);               // develop rig visulisation
  //if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;               // change colour layer automatically

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  boolean trigger = beatDetect.isOnset();                              // animations triggered by beats
  if (keyP[' ']) { 
    trigger = true;                                                    // or space bar!
    beatCounter = (beatCounter + 1 ) % 8;
  }
  if (trigger) animations.add(new Anim());                             // create a new anim object and add it to the arrayList

  blendMode(LIGHTEST);
  //for (Anim anim : animations){
  for (int i = animations.size()-1; i >= 0; i--) {                     // loop backwards through the list so one can be removed
    Anim anim = animations.get(i);                                     // tell the arrayList that it is an array of anim objects
    if (beatCounter % animations.size() == i) anim.trigger(trigger);   // trigger the function and alpha of the animation
    anim.drawAnim(anim.window, size.rigWidth/2+60, size.rigHeight/2+60);     // draw the animation (TODO figure out why the coordinates are wrong)
    if (animations.size() >= 8) animations.remove(i);                  // limit the array size to 8
  }
  println(animations.size());
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  blendMode(MULTIPLY);
  colorLayer(rigColourLayer, rigBgr);                               // develop colour layer
  image(rigColourLayer, size.rigWidth/2, size.rigHeight/2);         // draw rig colour layer to rig window
  blendMode(NORMAL);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /*
  //toggle roof viz and posostions of the cans and seeds with tilda key '~' 
   if (!keyT[96]) {
   // roof posistion for grid
   grid._seedLength = size.roofWidth;
   grid._seed2Length = size.roofHeight;
   grid.seed[0] = new PVector (size.roof.x, size.roof.y-(size.roofHeight/4)); 
   grid.seed[1] = new PVector (size.roof.x, size.roof.y+(size.roofHeight/4)); 
   grid.seed[2] = new PVector (size.roof.x, size.roof.y);
   
   grid._cansLength = size.roofWidth/2;
   grid.cans[0] = new PVector(size.roof.x-( grid._cansLength/2), size.roof.y-( grid.mirrorAndGap/2));
   grid.cans[1] = new PVector(size.roof.x+( grid._cansLength/2), size.roof.y+( grid.mirrorAndGap/2));
   grid.uv = new PVector(size.rig.x, size.rig.y);
   
   roofVizSelection(roofWindow, roofDimmerPad*roofDimmer);         // develop roof visulisation
   colorLayer(roofColourLayer, roofBgr);  
   image(roofColourLayer, size.roof.x, size.roof.y);               // draw roof colour layer to roof window
   blendMode(MULTIPLY);
   image(roofWindow, size.roof.x, size.roof.y);                    // draw roof viz to roof window    
   blendMode(NORMAL);
   } else {
   // rig positions for grid
   grid._seedLength = size.rigWidth;
   grid._seed2Length = size.rigHeight/1.6;
   grid.seed[0] = new PVector (size.rig.x, grid.mirrorX[0][0].y+(grid.dist/6)); 
   grid.seed[1] = new PVector (size.rig.x, grid.mirrorX[0][3].y-(grid.dist/6)); 
   grid.seed[2] = new PVector (size.rig.x, size.rig.y);
   
   grid._cansLength = size.rigWidth/2;
   grid.cans[0] = new PVector(size.rig.x-(grid._cansLength/2), size.rig.y-(grid.mirrorAndGap/2));
   grid.cans[1] = new PVector(size.rig.x+(grid._cansLength/2), size.rig.y+(grid.mirrorAndGap/2));
   grid.uv = new PVector(size.rig.x+10, size.rig.y);
   }
   grid.kallidaCans(opcCans);                                  
   grid.kallidaUV(opcCans);
   grid.kallidaSeeds(opcSeeds);
   */
  if (int(frameCount % (frameRate*90)) == 0) {                           // change the controller gird every X seconds
    grid.controllerGridStep = int(random(5));                 // randomly choose new grid
    if (rigBgr == 4 ) grid.controllerGridStep = int(random(1, 5));  // dont use grid 0 is bg4 = not symetrical
    grid.kallidaControllers(opcControllerA, opcControllerA, grid.controllerGridStep);   // grids 0-4 MIX IT UPPPPP
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  image(infoWindow, size.info.x, size.info.y);
  //////////////////////////////////////////// SEEDS SHIT ///////////////////////////////////////////////////////////////////////////////
  if (keyP['0']) { // beatCounter % 100 >   92
    rigControl(0, 1);
    cansControl(0, 1);
    // add uv control////
    fill(roof.flash, 360*(pulz*0.8+(stutter*0.2)));
    rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
    rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
    rect(grid.seed[2].x, grid.seed[2].y, 3, grid.seedLength);
  }
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
  //controllerControl(flash1, (0.7+(0.3*noize1))*controllerDimmer);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
