int counter, rigAlphaIndexA, rigAlphaIndexB = 1, fctIndexA, fctIndexB = 1, swap;
int roofAlphIndex, roofAlph1Index = 1, roofFctIndex, roofFct1Index = 1;
float alf, bt, bt1, dimmer, func, func1;
float roofBt, roofBt1, roofFunc, roofFunc1;
color col1, col2;
float alpha[] = new float[4];
float alpha1[] = new float[4];
float roofAlpha[] = new float[4];
float roofAlpha1[] = new float[4];
float function[] = new float[4];
float function1[] = new float[4];
float roofFunction[] = new float[4];
float roofFunction1[] = new float[4];

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
    rigAlphaIndexA = int(random(alph.length));  //// select from alpha array
    rigAlphaIndexB = int(random(alph.length)); //// select from alpha array
    roofAlphIndex = int(random(roofAlph.length));  //// select from alpha array
    roofAlph1Index = int(random(roofAlph.length)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", rigAlphaIndexA, "new af1:", rigAlphaIndexB);
    time[1] = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////
  if (millis()/1000 - time[2] >= vizTm/divide) {    ////// change function n times for every state change
    fctIndexA = int(random(fct.length));  //// select from function array
    fctIndexB = int(random(fct.length));  //// select from function array
    roofFctIndex = int(random(roofFct.length));  //// select from function array
    roofFct1Index = int(random(roofFct.length));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", fctIndexA, "new fc1:", fctIndexB);
    time[2] = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ ////////////
  if (alf < 1)  alf += 0.05;
  if (alf > 1) alf = 1;
  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////// SET FUNCTIONS AND ALPHAS TO USE THROUGHT SKETCH ////////////////
  for (int i =0; i< beats.length; i++) {
    /////////////////////////////////////// SHIMMER control for rig ////////////////////////////
    if (beatCounter % 36 > 24) { 
      alpha[i] = alph[rigAlphaIndexA][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
      alpha1[i] = alph[rigAlphaIndexB][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));

      if (beatCounter%4 == i) {
        bt = alph[rigAlphaIndexA][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
        bt1 = alph[rigAlphaIndexB][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
   }   
    } else {
      alpha[i] = alph[rigAlphaIndexA][i]/1;    //*(0.6+0.4*noize12)/1.5;  //// set alpha to selected alpha with bit of variation
      alpha1[i] = alph[rigAlphaIndexB][i]/1;   //*(0.6+0.4*noize1)/1.5;  //// set alpha1 to selected alpha with bit of variation
      if (beatCounter%4 == i) {
        bt = alph[rigAlphaIndexA][i];
        bt1 = alph[rigAlphaIndexA][i];
      }
      //////////////// bright flash every 6 beats - counters all code above /////////
      if (beatCounter%6 == 0) {
        alpha[i]  = alph[rigAlphaIndexA][i];
        alpha1[i]  = alph[rigAlphaIndexB][i];
      }
    }
    if (size.roofWidth > 0) {
      ////////////////// shimmer control for roof ////////////////////////////
      if (beatCounter % 96 < 64) { 
        roofAlpha[i] = roofAlph[roofAlphIndex][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
        roofAlpha1[i] = roofAlph[roofAlph1Index][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
        if (beatCounter%4 == i) {
          roofBt = roofAlph[roofAlphIndex][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
          roofBt1 = roofAlph[roofAlph1Index][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
        }
      } else {
        roofAlpha[i] = roofAlph[roofAlphIndex][i]/1;
        roofAlpha1[i] = roofAlph[roofAlph1Index][i]/1;
        if (beatCounter%4 == i) {
          roofBt = roofAlph[roofAlphIndex][i];
          roofBt1 = roofAlph[roofAlph1Index][i];
        }
        //////////////// bright flash every 12 beats - counters all code above /////////
        if (beatCounter%12 == 12) {
          roofAlpha[i]  = roofAlph[roofAlphIndex][i];
          roofAlpha1[i]  = roofAlph[roofAlph1Index][i];
        }
      }
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////// FUNCTIONS //////////////////////////////////////////////////////////////////////////
  for (int i =0; i< beats.length; i++) {
    function[i] = fct[fctIndexA][i];                                /// set func to selected function
    function1[i] = fct[fctIndexB][i];                              /// set func1 to selected function
    //roof
    roofFunction[i] = roofFct[roofFctIndex][i];                    /// set func to selected function
    roofFunction1[i] = roofFct[roofFct1Index][i];                  /// set func1 to selected function
    if (beatCounter%4 == i) {
      func = fct[fctIndexA][i];
      func1 = fct[fctIndexB][i];
      // roof
      roofFunc = roofFct[roofFctIndex][i];
      roofFunc1 = roofFct[roofFct1Index][i];
    }
  }
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
  //if (beatCounter % 18 > 13)  colorLerping(rig, beatFast);
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
