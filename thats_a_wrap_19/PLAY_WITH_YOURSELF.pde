int rigVizList = 11, roofVizList =11, alphLength = 5, funcLength = 8;
float alf;
int vizTimer, alphaTimer, functionTimer;
void playWithYourself(float vizTm) {
  ///////////////// VIZ TIMER /////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - vizTimer >= vizTm) {
    rigg.vizIndex = int(random(rigVizList));
    roof.vizIndex = int(random(roofVizList));
    alf = 0; ////// set new viz to 0 to fade up viz /////
    println("VIZ:", rigg.vizIndex, "@", (hour()+":"+minute()+":"+second()));
    vizTimer = millis()/1000;
  }
  float divide = 4; ///////// NUMBER OF TIMES ALPHA CHANGES PER VIZ
  ///////////////////////////////////////////////////////////////////////
  /* envelope selection
  if (millis()/1000 - alphaTimer >= vizTm/divide) {
    rigg.envelope_factory=envelopesByName.get("fastup");
    //rigg.envelope_factory=envelopesByName.get("slowdown");
    //rigg.envelope_factory=envelopesByName.get(envelopesByName.keySet().toArray()[random(envelopesByName.size()]);
    //rigg.envelope_factory=envelopesByName[random(envelopesByName.length];
    //rigg.envelope_factory=envelopesByName[FASTUP];
  
  
  */
  //////////////////////////////////////////////////////////////////////
  ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - alphaTimer >= vizTm/divide) { ///// alpha timer changes 4 times every viz change /////
    rigg.alphaIndexA = int(random(alphLength));  //// select from alpha array
    rigg.alphaIndexB = int(random(alphLength)); //// select from alpha array
    roof.alphaIndexA = int(random(alphLength));  //// select from alpha array
    roof.alphaIndexB = int(random(alphLength)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", rigg.alphaIndexA, "new af1:", rigg.alphaIndexB);
    alphaTimer = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - functionTimer >= vizTm/divide) {    ////// change function n times for every state change
    rigg.functionIndexA = int(random(funcLength));  //// select from function array
    rigg.functionIndexB = int(random(funcLength));  //// select from function array
    roof.functionIndexA = int(random(funcLength));  //// select from function array
    roof.functionIndexB = int(random(funcLength));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", rigg.functionIndexA, "new fc1:", rigg.functionIndexB);
    functionTimer = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ //////////////////////////////////////////////////////////////////////////
  if (alf < 1)  alf += 0.05;
  if (alf > 1) alf = 1;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  colTime = colorTimerSlider*60*30;
  rigColor.colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours
  roofColor.colorTimer(colTime/1.5, 2); //// seconds between colour change, number of steps to cycle through colours
  cansColor.colorTimer(colTime/2, 2); //// seconds between colour change, number of steps to cycle through colours

  if (millis()/1000 % 60 == 0) {
    rigg.bgIndex = (rigg.bgIndex + 1) % rigBgList;               // change colour layer automatically
    roof.bgIndex = (roof.bgIndex + 1) % roofBgList;               // change colour layer automatically
  }
  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) {
    rigColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    roofColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    cansColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  }
  if (beatCounter%64<2) rigColor.colorSwap(1000000*noize);  
  if (beatCounter%82>80) roofColor.colorSwap(1000000*noize);
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
  //rigColor.c = lerpColor(rigColor.col[rigColor.colorIndexB], rigColor.col[rigColor.colorIndexA], beatFast);
  //rigColor.flash = lerpColor(rigColor.col[rigColor.colorIndexA], rigColor.col[rigColor.colorIndexB], beatFast);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorLerping(SketchColor _rig, float function) {
  _rig.c = lerpColor(_rig.col[_rig.colorIndexB], _rig.col[_rig.colorIndexA], function);
  _rig.flash = lerpColor(_rig.col[_rig.colorIndexA], _rig.col[_rig.colorIndexB], function);
  colBeat = true;
}
