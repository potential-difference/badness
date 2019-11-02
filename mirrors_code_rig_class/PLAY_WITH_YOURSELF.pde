int counter, rigAlphaIndexA, rigAlphaIndexB = 1, rigFunctionIndexA, rigFunctionIndexB = 1, swap;
int steps = 0;
int rigVizList = 9;
int roofVizList = 11;

int roofAlphaIndexA, roofAlphaIndexB = 1, roofFunctionIndexA, roofFunctionIndexB = 1;
float alf, bt, bt1, func, func1;
float roofBt, roofBt1, roofFunc, roofFunc1;
color col1, col2;

int alphLength = 7, funcLength = 8;

void playWithYourself(float vizTm) {
  ///////////////// VIZ TIMER ////////////////////////////////////////
  if (millis()/1000 - time[0] >= vizTm) {
    rigViz = int(random(rigVizList));
    roofViz = int(random(roofVizList));
    alf = 0; ////// set new viz to 0 to fade up viz /////
    println("VIZ:", rigViz, "COUNTER:", counter, "@", (hour()+":"+minute()+":"+second()));
    time[0] = millis()/1000;
  }
  float divide = 4; ///////// NUMBER OF TIMES ALPHA CHANGES PER VIZ
  ///////////// ALPHA TIMER ///////////////////////////////////////////////////////////
  if (millis()/1000 - time[1] >= vizTm/divide) { ///// alpha timer changes 4 times every viz change /////
    rigAlphaIndexA = int(random(alphLength));  //// select from alpha array
    rigAlphaIndexB = int(random(alphLength)); //// select from alpha array
    roofAlphaIndexA = int(random(alphLength));  //// select from alpha array
    roofAlphaIndexB = int(random(alphLength)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", rigAlphaIndexA, "new af1:", rigAlphaIndexB);
    time[1] = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////
  if (millis()/1000 - time[2] >= vizTm/divide) {    ////// change function n times for every state change
    rigFunctionIndexA = int(random(funcLength));  //// select from function array
    rigFunctionIndexB = int(random(funcLength));  //// select from function array
    roofFunctionIndexA = int(random(funcLength));  //// select from function array
    roofFunctionIndexB = int(random(funcLength));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", rigFunctionIndexA, "new fc1:", rigFunctionIndexB);
    time[2] = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ ////////////
  if (alf < 1)  alf += 0.05;
  if (alf > 1) alf = 1;
  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  //if (keyT[97]) colStepper = 2;
  //else colStepper = 1;
  colTime = colorTimerSlider*60*30;
  rigColor.colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours
  roofColor.colorTimer(colTime/1.5, 2); //// seconds between colour change, number of steps to cycle through colours
  cansColor.colorTimer(colTime/2, 2); //// seconds between colour change, number of steps to cycle through colours

  //if (millis()/1000* == 0) rigBgr = (rigBgr + 1) % bgList;               // change colour layer automatically

  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) {
    rigColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    roofColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    cansColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  }
  if (beatCounter%64<2) rigColor.colorSwap(1000000*noize);  
  if (beatCounter%82>79) roofColor.colorSwap(1000000*noize);
  if (beatCounter%64>61) cansColor.colorSwap(1000000*noize);

  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) rigColor.colFlip = true;
  else rigColor.colFlip = false;
  for (int i = 11; i<19; i+=2) if ( beatCounter % 128 == i) roofColor.colFlip = true;
  else roofColor.colFlip = false;

  rigColor.colorFlip(rigColor.colFlip);
  roofColor.colorFlip(roofColor.colFlip);
  cansColor.colorFlip(cansColor.colFlip);

  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  if (beatCounter % 64 > 60)  colorLerping(rigColor, (1-beat)*2);
  if (beatCounter % 96 > 90)  colorLerping(roofColor, (1-beat)*1.5);
  if (beatCounter % 32 > 28)  colorLerping(cansColor, (1-beat)*1.5);

  colBeat = false;
  //rigColor.c = lerpColor(rigColor.col[rigColor.colorB], rigColor.col[rigColor.colorA], beatFast);
  //rigColor.flash = lerpColor(rigColor.col[rigColor.colorA], rigColor.col[rigColor.colorB], beatFast);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorLerping(SketchColor object, float function) {
  object.c = lerpColor(object.col[object.colorB], object.col[object.colorA], function);
  object.flash = lerpColor(object.col[object.colorA], object.col[object.colorB], function);
  colBeat = true;
}
