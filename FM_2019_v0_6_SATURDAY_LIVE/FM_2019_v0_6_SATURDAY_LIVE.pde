OPC opc;
OPC opcLocal;
OPC opcWifi;
OPC opcWifi1;
OPC opcWifi2;
OPC opcWifi3;

SizeSettings size = new SizeSettings();
BoothOPCGrid booth;
ShieldsOPCGrid grid;
CansOPCGrid cans;
SeedsOPCGrid seeds;
DMXGrid dmx;
//EggsGrid eggs;

import themidibus.*; //Import the midi library
MidiBus lpd8Bus; 
MidiBus touchBus; 

float cc[] = new float[128];   //// An array where to store the last value received for each knob
float prevcc[] = new float[128];
int time[] = new int[12]; // array of timers to use throughout the sketch

PVector[] DMXpar = new PVector[6];

PFont myFont;

void settings() {
  size(size.sizeX, size.sizeY, P2D);
}

void setup()
{
  /// size moved to settings - see above
  surface.setAlwaysOnTop(true);
  size.surfacePositionX = 720;
  size.surfacePositionY = 200;
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);

  audioSetup(800); ///// AUDIO SETUP - sensitivity /////

  ///////////////// LOCAL opc  /////////////////////
  opcLocal = new OPC(this, "127.0.0.1", 7890);      // Connect to the local instance of fcserver
  ///////////////// OPC over NETWORK /////////////////////
  opc = new OPC(this, "192.168.0.5", 7890);         // Connect to the ethernet instance of fcserver
  opcWifi1 = new OPC(this, "192.168.0.10", 7890);   // Connect to the wifi instance of fcserver
  opcWifi2 = new OPC(this, "192.168.0.20", 7890);   // Connect to the wifi instance of fcserver

  grid = new ShieldsOPCGrid();
  grid.shieldPositon();
  grid.FMShieldsGrid();
  grid.FMEggs(opc);
  booth = new BoothOPCGrid(width-35, 115);
  cans = new CansOPCGrid();
  cans.FMCansSideToSide(opcWifi1, opcWifi2);
  //cans.FMCansTEST(opcWifi1, opcWifi2);
  seeds = new SeedsOPCGrid();
  seeds.FMSeeds(opcWifi1, opcWifi2);
  dmx = new DMXGrid();
  dmx.FMPars(opcLocal, width-90, 110);
  dmx.FMSmoke(opcLocal, width - 120, 115);


  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  lpd8Bus = new MidiBus(this, "LPD8", "LPD8");   
  touchBus = new MidiBus(this, "TouchOSC Bridge", "TouchOSC Bridge");     

  dimmer = 1; // must come before load control frame
  controlFrame = new ControlFrame(this, width, 130, "Controls"); // load control frame must come after shild ring etc

  drawingSetup();
  loadImages();
  loadGraphics();
  colorSetup();
  colorArray();
  loadShaders(10);

  rigViz = 4;
  roofViz = 1;
  rigBgr = 1;    
  co = 1;    // set c start
  co1 = 2;   // set flash start
  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 9; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  //keyT[107] = true; // turn shimmer on from start
  cc[1] = 0.75;
  cc[6] = 0.75;
  cc[8] = 0.7;
  roofDimmer = 0.7;

  cc[11] = 1;
  cc[15] = 0.8;

  frameRate(30);
}
float vizTime, colTime;
int roofViz, rigViz, colStepper = 1;


void draw()
{
  ////// MIX UPTHE WAY THE SHIELDS ARE DRAWN //////
  //grid.medRingSize = size.rigWidth/6;
  //grid.smallRingSize = size.rigWidth/6;
  //grid.ballRingSize = size.rigWidth/11;
  //grid.bigShieldRad = size.rigWidth/3;
  //grid.shieldPositon();
  if(beatCounter% 128 < 42) grid.FMShieldsGrid();
  else grid.FMShieldsGrid2();

  /// ECHO RIG DIMMER SLIDER AND MIDI SLIDER 4 to control rig dimmer but only whne slider is changed
  if (cc[4]!=prevcc[4]) {
    prevcc[4]=cc[4];
    if (cc[4] != rigDimmer) controlFrame.cp5.getController("rigDimmer").setValue(cc[4]);
  }  
  if (cc[8]!=prevcc[8]) {
    prevcc[8]=cc[8];
    if (cc[8] != roofDimmer) controlFrame.cp5.getController("roofDimmer").setValue(cc[8]);
  }  

  ///////// MIX UP THE WAY THE CANS ARE DRAWN ///////
  //cans.FMCansSideToSide(opcWifi1, opcWifi2);
  //cans.FMCansMiddle(opcWifi1, opcWifi2);


  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                        ////// number of seconds before no music detected
  noize();
  oskPulse();
  arrayDraw();
  roofArrayDraw();
  clash(func);                         ///// clash colour changes on function in brackets

  ////// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
  blury = int(map(blurSlider, 0, 1, 0, 20));
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

  float rigDimmerPad = cc[4]; // come back to this with wigflex code?!
  float roofDimmerPad = cc[8]; // come back to this with wigflex code?!

  rigVizSelection(rigWindow, rigViz, rigDimmerPad*rigDimmer);                           // develop one visulisation
  roofVizSelection(roofWindow, roofViz, roofDimmerPad*roofDimmer);    // develop 2nd visulisation

  if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;                // change colour layer automatically
  colorLayer(rigColourLayer, rigBgr);                                // develop colour layer
  image(rigColourLayer, size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);         // draw rig colour layer to rig window
  blendMode(MULTIPLY);
  image(rigWindow, size.rig.x, size.rig.y);
  blendMode(NORMAL);


  //toggle roof viz with tilda key '~' 
  if (!keyT[96]) {
    colorLayer(roofColourLayer, roofBgr);  
    image(roofColourLayer, size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);                      // draw roof colour layer to roog window
    blendMode(MULTIPLY);
    image(roofWindow, size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    blendMode(NORMAL);
  }

  image(infoWindow, size.info.x, size.info.y);
  //////////////////////////////////////// CANS DIMMER //////////////////////////////////////////////////
  fill(0, 360-(360*cansSlider));
  rect(cans.cansLeft.x, cans.cansLeft.y, 3, cans.canLength);
  rect(cans.cansRight.x, cans.cansRight.y, 3, cans.canLength);

  //////////////////////////////////////// SMALL SEEDS DIMMER //////////////////////////////////////////////////
  fill(0, 360-(360*smallSeedsSlider));
  ellipse(seeds.seed[1][0].x, seeds.seed[1][0].y, 15, 15);
  ellipse(seeds.seed[1][2].x, seeds.seed[1][2].y, 15, 15);
  ellipse(seeds.seed[2][0].x, seeds.seed[2][0].y, 15, 15);
  ellipse(seeds.seed[2][2].x, seeds.seed[2][2].y, 15, 15);
  ellipse(seeds.seed[3][0].x, seeds.seed[3][0].y, 15, 15);
  ellipse(seeds.seed[3][2].x, seeds.seed[3][2].y, 15, 15);
  ellipse(seeds.seed[0][1].x, seeds.seed[0][1].y, 15, 15);

  fill(0, 360-(360*bigSeedsSlider));
  ellipse(seeds.seed[0][0].x, seeds.seed[0][0].y, 15, 15);
  ellipse(seeds.seed[0][2].x, seeds.seed[0][2].y, 15, 15);
  ellipse(seeds.seed[1][1].x, seeds.seed[1][1].y, 15, 15);
  ellipse(seeds.seed[2][1].x, seeds.seed[2][1].y, 15, 15);
  ellipse(seeds.seed[4][0].x, seeds.seed[4][0].y, 15, 15);
  ellipse(seeds.seed[4][2].x, seeds.seed[4][2].y, 15, 15);

  /////////////////////////////////// SEEDS LEVEL ////////////////////////////////////
  fill(c, ((360*frontSeedLevel)+(frontSeedLevel*(stutter*0.4*noize1*0.2)))*roofDimmer);
  ellipse(seeds.seed[0][0].x, seeds.seed[0][0].y, 12, 12);
  ellipse(seeds.seed[0][2].x, seeds.seed[0][2].y, 12, 12);

  fill(c, ((360*rearSeedLevel)+(rearSeedLevel*(stutter*0.4*noize1*0.2)))*roofDimmer);
  ellipse(seeds.seed[4][0].x, seeds.seed[4][0].y, 12, 12);
  ellipse(seeds.seed[4][2].x, seeds.seed[4][2].y, 12, 12);

  fill(c, ((360*rearSeedLevel/2)+(rearSeedLevel/2*(stutter*0.4*noize1*0.2)))*roofDimmer);
  ellipse(seeds.seed[2][1].x, seeds.seed[2][1].y, 12, 12);

  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////

  drumButtons();

  ///////////////////////////////////////////////////////////////////////
  /////////////////////////////////// BOOTH LIGHTS //////////////////////////////////
  fill(flash1, 360*boothDimmer);
  rect(booth.bth.x+10, booth.bth.y, 30, 10);

  /////////////////////////////////// DIGGING LIGHTS /////////////////
  fill(c1, 360*digDimmer);
  rect(booth.dig.x+10, booth.dig.y, 30, 10);

  /////////////////////////////////// EGGS LIGHTS /////////////////
  fill(0, 360-(360*rigDimmer));
  rect(grid.eggs[1].x, grid.eggs[1].y, 10, grid.eggLength);

  fill(c1, (360*eggDimmer+(eggDimmer+stutter*0.4*noize1*0.2))*rigDimmer);
  rect(grid.eggs[1].x, grid.eggs[1].y, 10, grid.eggLength);
  fill(c1, (360*eggDimmer+(eggDimmer*stutter*0.4*noize12*0.2))*rigDimmer);
  rect(grid.eggs[1].x, grid.eggs[1].y, 10, 10);

  /////////////////////////////////// DMX PARS  /////////////////////////
  fill(flash, 360*frontParsDimmer+(frontParsDimmer*stutter*0.4*noize1*0.2));
  rect(dmx.pars[0].x, dmx.pars[0].y, 30, 10);
  fill(flash, 360*frontParsDimmer+(frontParsDimmer*stutter*0.4*noize1*0.2));
  rect(dmx.pars[1].x, dmx.pars[1].y, 30, 10);
  fill(flash, 360*rearParsDimmer+(frontParsDimmer*stutter*0.4*noize1*0.2));
  rect(dmx.pars[2].x, dmx.pars[2].y, 30, 10);

  ////////////////////////////////////// DMX SMOKE //////////////////////////////////
  float smokeInterval = 600*smokeOffTime;
  float smokeOn = smokeOnTime*10;
  if (millis()/1000 % smokeInterval > smokeInterval - smokeOn) {
    fill(360*smokePump);
    rect(dmx.smoke[0].x, dmx.smoke[0].y, 10, 10);
  }
  float smokeInfo = millis()/1000 % smokeInterval - (smokeInterval);
  fill(300);
  text("smoke on in: "+smokeInfo, 1000,400);

  if (keyP[32]) {
    fill(360*smokePump);
    rect(dmx.smoke[0].x, dmx.smoke[0].y, 10, 10);
  }

  /////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
  if (test) {
    fill((millis()/50)%360, 100, 100);           
    rect(size.rig.x, size.rig.y, width, height);
  }
  /////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
  if (work) {
    pause = 10;
    fill(360*cc[9],360*cc[10]);
    rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    rect(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    // booth lights
    rect(booth.bth.x+10, booth.bth.y, 30, 10);
    rect(booth.bth.x+10, booth.bth.y+20, 30, 10);
    //pars
    rect(dmx.pars[0].x, dmx.pars[0].y, 30, 10);
    rect(dmx.pars[1].x, dmx.pars[1].y, 30, 10);
    rect(dmx.pars[2].x, dmx.pars[2]. y, 30, 10);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  onScreenInfo();                ///// display info about current settings, viz, funcs, alphs etc
  colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, 20);         ///// display frame rate X, Y /////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(flash);
  rect(size.rigWidth, height/2, 1, height);           ///// vertical line to show end of rig viz area
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);        ///// vertical line to show end of roof viz area
  fill(flash, 80);    
  rect((size.rigWidth+size.roofWidth)/2, height-size.sliderHeight, size.rigWidth+size.roofWidth, 1);            ///// horizontal line to show bottom area

  //// DMX CONTROL PIXELS
  //fill(360);
  //rect(width-2, 2, 4, 4);
  //fill(0);
  //rect(2, 2, 6, 6);
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
  ////////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////// CANS SHIT ///////////////////////////////////////////////////////////////////////////////
 canWidth = 220;
 noStroke();
 blendMode(NORMAL);
 if (rigDimmer > 0 ) {
 if (visualisation>0) {
 if (beat < 0.3) {
 fill(flash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
 rect(canX, canY+1, canWidth, 6);
 }
 } else { 
 fill(flash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
 rect(canX, canY+1, canWidth, 6);
 }
 
 //if (visualisation>0) {
 //  if (beatCounter % 6 == 1) {
 //    fill(clash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
 //    rect(canX, canY+1, canWidth, 6);
 //  }
 //}
 }
 blendMode(MULTIPLY);
 fill(0, 360-(360*bgDimmer));
 rect(canX, canY, canWidth, 3);
 blendMode(NORMAL);
 
 if (cc[106] > 0) {   
 //if (keyP[57]) {
 //for (int i=0; i<4; i++) alpha1[i] = (alpha1[i]*cc[7]/2)+(stutter*cc[7]);
 //fill(flash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
 fill(clash1, (360)*cc[6]);
 rect(canX, canY+1, canWidth, 6);
 println("BG ON SHIMMERY * knob 7");
 }
 
 if (cc[107] > 0) {   
 //if (keyP[57]) {
 //for (int i=0; i<4; i++) alpha1[i] = (alpha1[i]*cc[7]/2)+(stutter*cc[7]);
 //fill(flash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
 fill(clash, (240+(120*stutter))*cc[7]);
 rect(canX, canY+1, canWidth, 6);
 println("BG ON SHIMMERY * knob 7");
 }
 
 /// background on a bit when key A pressed
 if (keyT[97]) {
 fill(c, (240+(120*noize*beat))*cc[7]);
 rect(canX, canY+1, canWidth, 6);
 }
 
 */
