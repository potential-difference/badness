// vizTimer keeps track of the time between 'ticks' 
void playWithYourself() {
  
  for (Rig rig : rigs) {
    ///////////////// VIZ TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
    if (millis()/1000 - rig.vizTimer >= vizChangeTime*60) { // TODO update this to rig.vizTimer for independant control 
      rig.vizIndex = int(random(rig.availableAnims.length));
      //println(rig.type," VIZ:", rig.vizIndex, "@", (hour()+":"+minute()+":"+second()));
      rig.vizTimer = millis()/1000;
    }

    ////////////////////////////// PLAY TOGGLE TO CONTROL AUTO CYCLING OF FUNCS AND ALPHAS /////////////////////////////////////////
    if (rig.playWithYourSelf) {  
      ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
      //rig,duration,something_that_happens
      //  this is a timer function with a callback, repeatedly
      if (millis()/1000 - rig.alphaTimer >= vizChangeTime/(1+rig.alphaChangeRate*20)) {       //// SWAPRATE changes # of times every viz change /////
        rig.alphaIndexA = int(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        rig.alphaIndexB = int(random(rig.availableAlphaEnvelopes.length));   //// select from alpha array
        // println(rig.type+" alpha change @", (hour()+":"+minute()+":"+second()), "new envelopes:", rig.alphaIndexA, "&", rig.alphaIndexB);
        rig.alphaTimer = millis()/1000;
      }
      //////////// FUNCTION TIMER //////////////////////////////////////////////////////////////////////////////////////////////////
      if (millis()/1000 - rig.functionTimer >= vizChangeTime/(1+rig.functionChangeRate*20)) {
        rig.functionIndexA = int(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        rig.functionIndexB = int(random(rig.availableFunctionEnvelopes.length));  //// select from function array
        // println(rig.type+" function change @", (hour()+":"+minute()+":"+second()), "new envelope:", rig.functionIndexA, "&", rig.functionIndexB);
        rig.functionTimer = millis()/1000;
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  for (Rig rig : rigs) {
    rig.colorTimer(1); //// seconds between colour change, number of steps to cycle through colours
    if (millis()/1000 - rig.bgTimer >= (colorChangeTime * 60) / rig.backgroundChangeRate) { 
      rig.bgIndex = (int(random(rig.availableBkgrnds.length)));  
      rig.bgTimer = millis()/1000; 
      // println(rig.type+" background change @", (hour()+":"+minute()+":"+second()), "new background:", rig.bgIndex);
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
 /*
  if (colorSwapSlider > 0) for (Rig rig : rigs) rig.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  for (Rig rig : rigs){
    switch(rig.type){
    case Shields:     if (beatCounter%64<4) rig.colorSwap(1000000*noize);  break;
    case TipiRight:   if (beatCounter%32>27) rig.colorSwap(1000000*noize); break;
    case TipiLeft:    if (beatCounter%34>29) rig.colorSwap(1000000*noize); break;
    case TipiCentre:  if (beatCounter%36>31) rig.colorSwap(1000000*noize); break;
    case MegaSeedA:   if (beatCounter%64>61) rig.colorSwap(1000000*noize); break;
    case MegaSeedB:   if (beatCounter%64>61) rig.colorSwap(1000000*noize); break;
    case Bar:
    default:
      if (beatCounter%82 > 78) rig.colorSwap(noize);
    }
  }
  */
  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  // TODO reinstate this when working proprely
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) shields.colFlip = true;
  for (Rig rig : rigs) if ( beatCounter % 128 > 120) rig.colFlip = true;
  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  //colBeat = false;
  // if (beatCounter % 18 > 15)  colorLerping(shields, (1-beat)*4);
  for (Rig rig : rigs){
    switch(rig.type){
    case Shields:     if (beatCounter % 18 > 15)  colorLerping(rig,(1-beat)*4);break;
    case TipiRight:   if (beatCounter % 32 > 27)  colorLerping(rig,(1-beat)*3);break;
    case TipiLeft:    if (beatCounter % 32 > 27)  colorLerping(rig,(1-beat)*3);break;
    case TipiCentre:  if (beatCounter % 18 < 4)   colorLerping(rig,(1-beat)*4);break;
    case MegaSeedA:   //if (beatCounter%64>61) rig.colorSwap(1000000*noize); break;
    case MegaSeedB:   //if (beatCounter%64>61) rig.colorSwap(1000000*noize); break;
    case Bar:
    default:
      if (beatCounter % 18 > 15)  colorLerping(rig, (1-beat)*4); break;
    }
  }
  // QUICK AND DIRTY ADJUSTMETNS ON FRIDAY NIGHT //

  outsideRoof.c = shields.c;
  outsideRoof.flash = shields.flash;

  outsideGround.c = shields.flash;
  outsideGround.flash = shields.c;

  frontCans.c = shields.flash;
  frontCans.flash = shields.c;

  boothCans.c = shields.flash;
  boothCans.flash = shields.c;

  // TODO make this proper beatLOGIS
  if (beatCounter % 32 < 8 && beatCounter % 2 == 0) filaments.onBeat = true;
  else filaments.onBeat = false;

  for (Rig rig : rigs) 
  {
    switch (rig.type){
      case Shields:  
      if (beatCounter % 18 < 4) colorLerping(rig,(1-beat)*4);
      break;
      case TipiLeft:
        if (beatCounter % 16 > 27) colorLerping(rig,(1-beat)*3);
        break;
      case TipiRight:
        if (beatCounter % 16 > 27) colorLerping(rig,(1-beat)*3);
        break;
      case MegaSeedA:
        if (beatCounter % 32 < 6) colorLerping(rig,(1-beat)*3);
        break;
      case MegaSeedB:
        if (beatCounter % 32 < 6) colorLerping(rig,(1-beat)*3);
        break;
      case MegaSeedC:
        if (beatCounter % 16 < 2) colorLerping(rig,(1-beat)*3);
        break;
      default:
       if (beatCounter % 64 > 60) colorLerping(rig,(1-beat)*4);
    }
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorLerping(Rig _rig, float function) {
  _rig.c = lerpColor(_rig.col[_rig.colorIndexB], _rig.col[_rig.colorIndexA], function);
  _rig.flash = lerpColor(_rig.col[_rig.colorIndexA], _rig.col[_rig.colorIndexB], function);
  //colBeat = true;
}
