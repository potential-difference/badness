OPC opc;
OPC opcWifi;


import themidibus.*; //Import the midi library
MidiBus myBus; // The MidiBus
float cc[] = new float[128];   //// An array where to store the last value received for each knob
int time[] = new int[12]; // array of timers to use throughout the sketch
int w, h, ww, hh, mx, my, mh, mw, rx, ry, rw, rh, iw, ih, ix, iy, sh; // size variables
int surfacePositionX = 780, surfacePositionY = 600;

PShader maskShader;
PGraphics maskImage, maskedImage;
PVector[] DMXpar = new PVector[6];

PFont myFont;


void settings() {
  mw = 400;          // WIDTH of rigViz
  mh = 400;          // HEIGHT of rigViz
  mx = mw/2;          // X coordiante for center of rigViz 
  my = mh/2;        // Y coordiante for center of rigViz

  rw = 400;          // WIDTH of roofViz
  rh = mh;          // HEIGHT of roofViz
  rx = mw+(rw/2);    // X coordiante for center of roofViz
  ry = rh/2;           // Y coordiante for center of roofViz

  sh = 70;         // height of slider area at bottom of sketch window

  iw = 300;          // WIDTH of info area
  ih = mh+sh;          // HEIGHT of info area
  ix = mw+rw+(iw/2); // X coordiante for center of infoArea
  iy = ih/2;

  size(mw+rw+iw, sh+mh, P2D);
  w = width;
  h = height;
  ww = w >> 1;  // half of width
  hh = h >> 1;  // half of height
}

void setup()
{
  /// size moved to settings - see above
  surface.setAlwaysOnTop(true);
  surface.setLocation(surfacePositionX, surfacePositionY);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////

  opc = new OPC(this, "127.0.0.1", 7890);   // Connect to the local instance of fcserver
  ///////////////// OPC over WIFI - uncomment below /////////////////////
  //opcWifi = new OPC(this, "sputnik.local", 7890);   // Connect to the wifi instance of fcserver

  float medRingSize = mw/8;        ///// SIZE OF RING BIG SHIELDS ARE POSITION ON
  float smallRingSize = mw/5;    ///// SIZE OF RING SMALL SHIELDS ARE POSITION ON
  float ballRingSize = mw/4;         ///// SIZE OF RING BALLS ARE POSITIONED ON
  shieldRingSetup(mx, my, 6, 9, medRingSize, smallRingSize, ballRingSize);    ////// SETUP RING SIZE FOR SHIELD POSITION, number of postitions on ring //////
  SpiralShieldGrid();
  boothLights(w-35, 115);
  //NYEcans();
  PickledCans();
  pickleDMXBattonsGrid();

  //int pd = 5;
  //int leds = 23;

  //opc.ledStrip(0, 23, mx, my+(leds/2*pd+(pd/2)), pd, 0, false);
  //opc.ledStrip(leds, 23, mx+(leds/2*pd+(pd/2)), my, pd, PI/2, true);

  //opc.ledStrip(64, 23, mx-(leds/2*pd+(pd/2)), my, pd, PI/2, true);
  //opc.ledStrip(64+leds, 23, mx, my-(leds/2*pd+(pd/2)), pd, 0, false);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  myBus = new MidiBus(this, 0, 1);      /// PAD 1

  dimmer = 1; // must come before load control frame
  cf = new ControlFrame(this, w, 130, "Controls"); // load control frame must come after shild ring etc

  drawingSetup();
  loadImages();
  loadGraphics();
  colorSetup();
  colorArray();

  // loadSliders();
  blur = loadShader("blur.glsl");
  loadShaders(10);

  maskShader = loadShader("mask.glsl");
  maskShader.set("mask", rigWindow);
  maskImage = createGraphics(mw, mh, P2D);
  maskImage.noSmooth();
  maskImage.imageMode(CENTER);

  maskedImage = createGraphics(mw, mh, P2D);
  maskedImage.noSmooth();
  maskedImage.imageMode(CENTER);

  visualisation = 4;
  visualisation1 = 1;
  rigBgr = 1;    
  co = 1;    // set c start
  co1 = 2;   // set flash start
  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 9; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  //keyT[107] = true; // turn shimmer on from start
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
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                        ////// number of seconds before no music detected
  noize();
  oskPulse();
  arrayDraw();
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

  //for (int i = 0; i< 11; i++) vizSelection(vizPreview[i], i, cc[4]*rigDimmer);                     // loop to iniciate all viz at once

  vizSelection(vizPreview[visualisation], visualisation, cc[4]*rigDimmer);                           // develop one visulisation
  //if (secondVizSlider > 0) vizSelection(vizPreview[visualisation1], visualisation1, cc[8]*secondVizSlider);    // develop 2nd visulisation
  //visualisation2 = (visualisation1+1)%11;
  //if (roofDimmer > 0) vizSelection(vizPreview[visualisation2], visualisation2, roofDimmer);    // develop 2nd visulisation


  if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;                // change colour layer automatically
  colorLayer(rigColourLayer, rigBgr);                                // develop colour layer
  rigWindow.beginDraw();
  rigWindow.background(0);
  rigWindow.blendMode(NORMAL);
  if (secondVizSlider>0 && cc[8] > 0) {  
    rigWindow.blendMode(BLEND);                                                   // changing this blend mode produces really interesting results - would be great on a drop down box
    rigWindow.image(vizPreview[visualisation1], mx, my);                        // draw secondVIZ to RIG WINDOW blending with colour layer
  }
  rigWindow.image(vizPreview[visualisation], mx, my);                           // draw VIZ to RIG WINDOW blending with colour layer
  rigWindow.endDraw();





  image(rigWindow, mx, my);
  blendMode(MULTIPLY);
  image(rigColourLayer, mx, my, mw, mh);                        // draw rig colour layer to rig window
  blendMode(NORMAL);


  colorLayer(roofColourLayer, roofBgr);  
  roofWindow.beginDraw();
  roofWindow.background(0);
  roofWindow.blendMode(NORMAL);
  roofWindow.image(vizPreview[visualisation2], rx, ry);                           // draw VIZ to RIG WINDOW blending with colour layer
  roofWindow.endDraw();

  //toggle roof viz with tilda key '~' 
  if (keyT[96]) {
    image(roofWindow, rx, ry, rw, rh);                 // draw VIZ to ROOF WINDOW blending with colour layer
    blendMode(MULTIPLY);
    image(roofColourLayer, rx, ry, rw, rh);                      // draw roof colour layer to roog window
    blendMode(NORMAL);
  }

  // code to develop and then draw preview boxes 
  if (frameCount<12)visualisation = (visualisation+1)%11; // quick n dirty loop to render all previews at startup
  colorPreview(infoWindow);
  vizPreview(infoWindow);
  image(infoWindow, ix, iy);



  //****************************************************************************************//
  ///////////////////  *** TESTING THIS OUT - KEY A activates multiviz layers *** ///////////////
  //playWithMany();   ////////// MULTIVIZ SLIDERS TURN ON OTHER VIZ ACTIVE
  /////////////// change color of multiviz layer ///////////
  //c = col[(co+1)% (col.length-1)]; 
  //flash = col[(co1+1)% (col.length-1)]; 
  //colorLayer();    ///////// WAS BACKGROUNDS AT BOTTOM OF PLAYWITHYOUSELF
  //****************************************************************************************//

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




  ///////////////////////////////////////////////////////////////////////
  /////////////////////////////////// BOOTH LIGHTS //////////////////////////////////
  fill(0);
  rect(boothX+10, boothY, 30, 10);
  fill(flash1, 360*boothDimmer);
  rect(boothX+10, boothY, 30, 10);

  ///////////////////////// DIGGING LIGHTS /////////////////
  fill(0, 360-(360*digDimmer));
  rect(boothX+10, boothY+30, 30, 10);
  fill(c1, 360*digDimmer);
  rect(boothX+10, boothY+30, 30, 10);

  //////////////////////////////// DMX ROOF SHIZ /////////////////////////
  //////////////// ROOF RUSH BANG BUTTON ///////////////
  //if (cc][[][107] > 0) roofRush();
  ///////////////// ROOF STOBE BANG BUTTON ///////////////
  //if (cc[104] > 0 || keyP[43]) roofStrobe();

  /////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
  if (test) {
    fill((millis()/50)%360, 100, 100);
    rect(mx, my, w, h);
  }
  /////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
  if (work) {
    fill(360);
    rect(ww, hh, w, h);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  onScreenInfo();                ///// display info about current settings, viz, funcs, alphs etc
  colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(flash);
  rect(mw, hh, 1, h);           ///// vertical line to show end of rig viz area
  rect(mw+rw, hh, 1, h);        ///// vertical line to show end of roof viz area
  fill(flash, 80);    
  rect((mw+rw)/2, h-sh, mw+rw, 1);            ///// horizontal line to show bottom area

  // DMX CONTROL PIXELS
  fill(360);
  rect(w-2, 2, 4, 4);
  fill(0);
  rect(2, 2, 6, 6);
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
