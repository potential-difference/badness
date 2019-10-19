int counter, rigAlphIndex, rigAlph1Index = 1, fctIndex, fct1Index = 1, swap;
int steps = 0;
int rigVizList = 11;
int roofVizList = 6;

int roofAlphIndex, roofAlph1Index = 1, roofFctIndex, roofFct1Index = 1;
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
    rigAlphIndex = int(random(alphLength));  //// select from alpha array
    rigAlph1Index = int(random(alphLength)); //// select from alpha array
    //roofAlphIndex = int(random(roofAlph.length));  //// select from alpha array
    //roofAlph1Index = int(random(roofAlph.length)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", rigAlphIndex, "new af1:", rigAlph1Index);
    time[1] = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////
  if (millis()/1000 - time[2] >= vizTm/divide) {    ////// change function n times for every state change
    fctIndex = int(random(funcLength));  //// select from function array
    fct1Index = int(random(funcLength));  //// select from function array
    //roofFctIndex = int(random(roofFct.length));  //// select from function array
    //roofFct1Index = int(random(roofFct.length));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", fctIndex, "new fc1:", fct1Index);
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
  rig.colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours
  roof.colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours
  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) {
    rig.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    roof.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  }
  if (beatCounter%64<2) rig.colorSwap(1000000*noize);  
  if (beatCounter%64>61) roof.colorSwap(1000000*noize);
  //if (colorSwapSlider == 0);
  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) rig.colFlip = true;
  else rig.colFlip = false;
  rig.colorFlip(rig.colFlip);
  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  if (beatCounter % 18 > 13)  colorLerping(rig, beat*2);
  colBeat = false;
  //rig.c = lerpColor(rig.col[rig.colorB], rig.col[rig.colorA], beatFast);
  //rig.flash = lerpColor(rig.col[rig.colorA], rig.col[rig.colorB], beatFast);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorLerping(SketchColor object, float function) {
  object.c = lerpColor(object.col[object.colorB], object.col[object.colorA], function);
  object.flash = lerpColor(object.col[object.colorA], object.col[object.colorB], function);
  colBeat = true;
}
