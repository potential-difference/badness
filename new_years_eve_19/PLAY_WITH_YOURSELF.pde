int vizTimer, bgChangeTimer;
void playWithYourself(float vizTm) {

  for (Rig rig : rigs) {
    ///////////////// VIZ TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
    if (millis()/1000 - vizTimer >= vizTm) {
      rig.vizIndex = int(random(rig.availableAnims.length));
      println(rig.name+" VIZ:", rig.vizIndex, "@", (hour()+":"+minute()+":"+second()));
      vizTimer = millis()/1000;
    }
    ////////////////////////////// PLAY TOGGLE TO CONTROL AUTO CYCLING OF FUNCS AND ALPHAS /////////////////////////////////////////
    if (rig.play) {  
      ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
      if (millis()/1000 - rig.alphaTimer >= vizTm/rig.alphaSwapRate) {       //// SWAPRATE changes # of times every viz change /////
        rig.alphaIndexA = int(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        rig.alphaIndexB = int(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        println(rig.name+" alpha change @", (hour()+":"+minute()+":"+second()), "new envelopes:", rig.alphaIndexA, "&", rig.alphaIndexB);
        rig.alphaTimer = millis()/1000;
      }
      //////////// FUNCTION TIMER //////////////////////////////////////////////////////////////////////////////////////////////////
      if (millis()/1000 - rig.functionTimer >= vizTm/rig.funcSwapRate) {
        rig.functionIndexA = int(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        rig.functionIndexB = int(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        println(rig.name+" function change @", (hour()+":"+minute()+":"+second()), "new envelope:", rig.functionIndexA, "&", rig.functionIndexB);
        rig.functionTimer = millis()/1000;
      }
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  for (Rig rig : rigs) {
    rig.colorTimer(colorTime*60, 1); //// seconds between colour change, number of steps to cycle through colours
    if (millis()/1000 - bgChangeTimer >= colorTime*60/rig.bgSwapRate) {
      rig.bgIndex = (int(random(rig.availableBkgrnds.length)));  // change colour layer 4 times every auto color change
      bgChangeTimer = millis()/1000;
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) for (Rig rig : rigs) rig.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  if (beatCounter%64<4) rigg.colorSwap(1000000*noize);  
  if (beatCounter%82>78) roof.colorSwap(1000000*noize);
  //if (beatCounter%64>61) cans.colorSwap(1000000*noize);

  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) rigg.colFlip = true;
  else rigg.colFlip = false;
  for (int i = 11; i<19; i+=2) if ( beatCounter % 128 == i) roof.colFlip = true;
  else roof.colFlip = false;
  for (Rig rig : rigs) rig.colorFlip(rigg.colFlip);

  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  colBeat = false;
  if (beatCounter % 18 > 13)  colorLerping(rigg, (1-beat)*2);
  if (beatCounter % 32 > 23)  colorLerping(roof, (1-beat)*1.5);
  ////if (beatCounter % 32 > 28)  colorLerping(cans, (1-beat)*1.5);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorLerping(Rig _rig, float function) {
  _rig.c = lerpColor(_rig.col[_rig.colorIndexB], _rig.col[_rig.colorIndexA], function);
  _rig.flash = lerpColor(_rig.col[_rig.colorIndexA], _rig.col[_rig.colorIndexB], function);
  colBeat = true;
}
