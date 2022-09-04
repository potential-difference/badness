int vizTimer, bgChangeTimer; // TODO does this need to be global / is it needed at all?
void playWithYourself(float vizTm) {

  for (Rig rig : rigs) {
    ///////////////// VIZ TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
    if (millis()/1000 - vizTimer >= vizTm) {
      rig.vizIndex = int(random(rig.availableAnims.length));
      println(rig.type," VIZ:", rig.vizIndex, "@", (hour()+":"+minute()+":"+second()));
      vizTimer = millis()/1000;
    }
    ////////////////////////////// PLAY TOGGLE TO CONTROL AUTO CYCLING OF FUNCS AND ALPHAS /////////////////////////////////////////
    if (rig.playWithYourSelf) {  
      ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
      //rig,duration,something_that_happens
      //  this is a timer function with a callback, repeatedly
      //
      if (millis()/1000 - rig.alphaTimer >= vizTm/(1+rig.alphaChangeRate*20)) {       //// SWAPRATE changes # of times every viz change /////
        rig.alphaIndexA = int(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        rig.alphaIndexB = int(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        println(rig.type+" alpha change @", (hour()+":"+minute()+":"+second()), "new envelopes:", rig.alphaIndexA, "&", rig.alphaIndexB);
        rig.alphaTimer = millis()/1000;
          }
      //////////// FUNCTION TIMER //////////////////////////////////////////////////////////////////////////////////////////////////
      if (millis()/1000 - rig.functionTimer >= vizTm/(1+rig.functionChangeRate*20)) {
        rig.functionIndexA = int(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        rig.functionIndexB = int(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        println(rig.type+" function change @", (hour()+":"+minute()+":"+second()), "new envelope:", rig.functionIndexA, "&", rig.functionIndexB);
        rig.functionTimer = millis()/1000;
       }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  for (Rig rig : rigs) {
    rig.colorTimer(colorChangeTime*60*20, 1); //// seconds between colour change, number of steps to cycle through colours
    if (millis()/1000 - bgChangeTimer >= colorChangeTime*60/rig.backgroundChangeRate) {
      rig.bgIndex = (int(random(rig.availableBkgrnds.length)));  // change colour layer 4 times every auto color change
      bgChangeTimer = millis()/1000;
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) for (Rig rig : rigs) rig.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  for (Rig rig : rigs){
    switch(rig.type){
    case Shields: if (beatCounter%64<4) rig.colorSwap(1000000*noize);  break;
    case RoofMid:
    case RoofSides:
    case MegaSeedFront:
    case MegaSeedCentre:
    default:
      if (beatCounter%82 > 78) rig.colorSwap(noize);
    }
  }
  //if (beatCounter%82>78) roof.colorSwap(1000000*noize);
  //if (beatCounter%64>61) cans.colorSwap(1000000*noize);

  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) shields.colFlip = true;
  else shields.colFlip = false;
  
  for (Rig rig : rigs) rig.colorFlip(shields.colFlip);

  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  colBeat = false;
  if (beatCounter % 18 > 15)  colorLerping(shields, (1-beat)*4);
  /*for (Rig rig : rigs) 
  {
    switch (rig){
      case cans:
        if (beatCounter % 18 < 4) colorLerping(rig,(1-beat)*4);break;
      case roof:
        if (beatCounter % 32 > 27) colorLerping(rig,(1-beat)*3);break;
    }
  }
  */
  //TODO if loop that only affects rigs that are present
  
  //if (beatCounter % 18 < 4)  colorLerping(cans, (1-beat)*4);
  //if (beatCounter % 32 > 27)  colorLerping(roof, (1-beat)*3);
  ////if (beatCounter % 32 > 28)  colorLerping(cans, (1-beat)*1.5);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorLerping(Rig _rig, float function) {
  _rig.c = lerpColor(_rig.col[_rig.colorIndexB], _rig.col[_rig.colorIndexA], function);
  _rig.flash = lerpColor(_rig.col[_rig.colorIndexA], _rig.col[_rig.colorIndexB], function);
  colBeat = true;
}
