int counter, visualisation, visualisation1,visualisation2, af, af1 = 1, fc, fc1 = 1, swap;
float x, y, alf, bt, bt1, dimmer, func, func1;
color col1, col2;

float alpha[] = new float[4];
float alpha1[] = new float[4];

float function[] = new float[4];
float function1[] = new float[4];

PVector[] panelM = new PVector[9];
PVector[] panelT = new PVector[9];
PVector[] panelB = new PVector[9]; 

void playWithYourself(float vizTm) {

  ///////////////// VIZ TIMER ////////////////////////////////////////
  if (millis()/1000 - time[0] >= vizTm) {
    counter = (counter + 1) % 3;
    if (counter == 0) {
      visualisation = int(random(1,11));
      visualisation1 = int(random(1,11));

      alf = 0; ////// set new viz to 0 to fade up viz /////
    }
    if (counter > 0 ) {
      visualisation = int(random(1,11));
      visualisation1 = int(random(1,11));
      alf = 0; ////// set new viz to 0 to fade up viz /////
    }
    println("VIZ:", visualisation, "COUNTER:", counter, "@", (hour()+":"+minute()+":"+second()));
    time[0] = millis()/1000;
  }
  float divide = 4; ///////// NUMBER OF TIMES ALPHA CHANGES PER VIZ
  ///////////// ALPHA TIMER ///////////////////////////////////////////////////////////
  if (millis()/1000 - time[1] >= vizTm/divide) { ///// alpha timer changes 4 times every viz change /////
    af = int(random(alph.length));  //// select from alpha array
    af1 = int(random(alph.length)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", af, "new af1:", af1);
    time[1] = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////
  if (millis()/1000 - time[2] >= vizTm/divide) {    ////// change function n times for every state change
    fc = int(random(fct.length));  //// select from function array
    fc1 = int(random(fct.length));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", fc, "new fc1:", fc1);
    time[2] = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ ////////////
  if (alf < 1)  alf += 0.05;
  if (alf > 1) alf = 1;
  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////// SET FUNCTIONS AND ALPHAS TO USE THROUGHT SKETCH ////////////////
  for (int i =0; i< beats.length; i++) {
    /// key K to toggle shimmer
    if (keyT[107]) { 
      alpha[i] = alph[af][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
      alpha1[i] = alph[af1][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));

      if (beatCounter%4 == i) bt = alph[af][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
      if (beatCounter%4 == i) bt1 = alph[af1][i]+(shimmerSlider/2+(stutter*0.4*noize1*0.2));
      ////////// maybe add this if K button isn't good
      //bt = bt+(0.3+(noize1*0.3));
      //bt1 = bt1+(0.3+(noize1*0.3));
    } else {
      alpha[i] = alph[af][i]/1;    //*(0.6+0.4*noize12)/1.5;  //// set alpha to selected alpha with bit of variation
      alpha1[i] = alph[af1][i]/1;   //*(0.6+0.4*noize1)/1.5;  //// set alpha1 to selected alpha with bit of variation
      if (beatCounter%4 == i) bt = alph[af][i];
      if (beatCounter%4 == i) bt1 = alph[af1][i];
    }
    //////////////// bright flash every 6 beats - counters all code above /////////
    if (beatCounter%6 == 0) {
      alpha[i]  = alph[af][i];
      alpha1[i]  = alph[af1][i];
    }
  }
  for (int i =0; i< beats.length; i++) {
    function[i] = fct[fc][i];  /// set func to selected function
    function1[i] = fct[fc1][i]; /// get func1 to selected function
    if (beatCounter%4 == i) func = fct[fc][i];
    if (beatCounter%4 == i) func1 = fct[fc1][i];
  }

  /////////////////////////////////////// COLORSWAP TIMER ///////////////////////////////////
  if (colorSwapSlider > 0)  colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  if (beatCounter%64<8) colorSwap(1000000*noize);   
  if (colorSwapSlider == 0) colorSwap(0);

  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR ///////////////////////////
  if (hold)  time[0] = millis()/1000;  //// hold viz change timer
  if (hold1) time[3] = millis()/1000;  //// hold color change timer

  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS //////////////////////////////////////
  colorFlip(colFlip);                      // COLOR FLIP on ';' key (toggle)
  if (keyP[92])  colorSwap(0.9999999999); /// COLOR SWAP on '\'  key
  if (keyP[39])  colorFlip(keyP[39]);      // COLOR SWAP ON '"' key (press and hold)

  ///////////////////////////////////////  COLOR FLIP ON BEAT ///////////////////////////////////
  for (int i=0; i<13; i+=2) if (beatCounter%32 == i) colorFlip(true);

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////
  if (keyT[108]) {
    c = lerpColor(col[co1], col[co], beatFast);
    flash = lerpColor(col[co], col[co1], beatFast);
  }
  if (beatCounter % 18 > 13) {
    c = lerpColor(col[co1], col[co], beatFast);
    flash = lerpColor(col[co], col[co1], beatFast);
  }

  /////////////////////////// TOGGLE MODIFIERS ///////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////
  /////////////// *** key X toggles different beat pattern 
  //if (keyT[120]) {
  //  steps = 4;
  //  if (beatCounter%steps==0) bt = beats[0];
  //  if (beatCounter%steps==1) bt = pulz;
  //  if (beatCounter%steps==2) bt = beats[2];
  //  if (beatCounter%steps==3) bt = beats[2];

  //  if (beatCounter%steps==0) bt1 = pulz;
  //  if (beatCounter%steps==1) bt1 = beat;
  //  if (beatCounter%steps==2) bt1 = pulzSlow;
  //  if (beatCounter%steps==3) bt1 = beat;
  //}
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
