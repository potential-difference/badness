float[] lastTime = new float[cc.length];
void setupMidiActions(){
  
  /////////////////////////////////////////////////////////////////////////
  ///////////////////////////// SHIELDS ///////////////////////////////////
  offBangButton(64, shields);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
  animOnBangButton(65, shields);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
  allOnForeverBangButton(66, shields);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
  /////////////////////////////////////////////////////////////////////////
  ///////////////////////////// LANTERNS //////////////////////////////////
  offBangButton(60,tipiLeft,tipiRight);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
  animOnBangButton(61,tipiLeft,tipiRight);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
  allOnForeverBangButton(62,tipiLeft,tipiRight);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
  //////////////////////////////////////////////////////////////////////////
  ////////////////////////// MEGA SEEDS ////////////////////////////////////
  offBangButton(56,megaSeedA,megaSeedB,megaSeedC);          // OFF BANG BUTTON: noteNumber, rig objects to turn off
  animOnBangButton(57,megaSeedA,megaSeedB,megaSeedC);       // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
  allOnForeverBangButton(58,megaSeedA,megaSeedB,megaSeedC); // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////// UV PARS /////////////////////////////////////
  offBangButton(52,uvPars);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
  animOnBangButton(53,uvPars);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
  allOnForeverBangButton(54,uvPars);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
  /////////////////////////////////////////////////////////////////////////
  ////////////////////////// FILLAMENTS ///////////////////////////////////
  animOnBangButton(67,filaments);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
  allOnForeverBangButton(63,filaments);       // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  
  
  colorSwapBangButton(59,shields); // COLOR SWAP BANG BUTTON: noteNumber, rig objects to add animation to
  colorFlipBangButton(55,shields,tipiLeft); // COLOR FLIP BANG BUTTON: noteNumber, rig objects to add animation to

  /*
  // CONSTANT BUTTON sets colorSwap for the given rig objects
  // TODO this is WIP and doesn't work yet - maybe a java barrier
  float customFunctionRate = 0.5f; // Adjust the function rate as needed
  Consumer<Float> colorSwapConsumer = velocity -> shields.colorSwap(velocity);
  midiManager.constantButton(59, colorSwapConsumer, customFunctionRate, shields);
  */
}

void playWithMe() {

/////////////////////// KEY PRESS ////////////////////////////
if (keyP[' ']){ 
    for (Rig rig : rigs) {
            //if (testToggle) rig.animations.add(new Test(rig));
        //println(rig.type," vizIndex", rig.vizIndex);
        rig.addAnim(rig.vizIndex);  // create a new anim object and add it to the beginning of the arrayList
      }
} 

/*
  ////////////////////////////////////// Momentary pad button actions //////////////////////////////
  for (int idx=0;idx<128;idx++){//action: everyFrameActions){
    FrameAction action = everyFrameActions[idx];
    if (action != null){
      action.doit();
    }
  }
*/
  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) rigs.get(0).colorSwap(0.9999999999);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) rigs.get(0).colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) rigs.get(0).colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  float  debouncetime=100;
  ///////////////////////////// *** MANUAL ANIM WORK THAT DOESNT WORK **** ////////////////////////////
  /*
  try {
   if (millis()-lastTime[44]>debouncetime) {
   if (padVelocity[44]>0) shields.animations.add(new Checkers (shields));
   if (shields.animations.size() > 0 ) { 
   Anim theanim = shields.animations.get(shields.animations.size()-1);
   //Envelope manualA = CrushPulse(0.0, 0, 1, shields.manualAlpha*500, 0.0, 0.0);
   Envelope manualA = CrushPulse(0.05, 0.0, 1.0, avgmillis*(shields.manualAlpha+0.5), 0.0, 0.0);
   theanim.alphaEnvelopeA = manualA;
   theanim.alphaEnvelopeB = manualA;
   lastTime[44]=millis();
   }
   }
   } 
   catch (Exception e) {
   println(e, "playwithyourself error");
   }
   */
  
 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// ALL ON ///////////////////////////////////////////////

  /*if (millis()-lastTime[46]>debouncetime) {
    if (padVelocity[46]>0) {
      shields.animations.add( new AllOn(shields)); //shields.anim.alphaEnvelopeA = new CrushPulse(0.031, 0.040, 0.913, avgmillis*shields.alphaRate*3+0.5, 0.0, 0.0);
      //anim = shields.animations.get(shields.animations.size()-1);
      lastTime[46]=millis();
    }
  }
  */

  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////  COLOUR //////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  
  /*
   if (millis()-lastTime[41]>debouncetime) {
   if (padVelocity[41]>0) for (Anim anim : shields.animations) {
   anim.functionEnvelopeA = anim.functionEnvelopeA.mul(0.6+(stutter*0.4));  //     anim.functionEnvelopeA.mul((1-cc[54])+(stutter*cc[54]));
   anim.functionEnvelopeB = anim.functionEnvelopeB.mul(0.6+(stutter*0.4));    //anim.functionEnvelopeB.mul((1-cc[54])+(stutter*cc[54]));
   }
   lastTime[41]=millis();
   }
   */
  //  if (padVelocity[36] > 0) {
  //    shields.colorIndexA = (shields.colorIndexA+1)%shields.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    cans.colorIndexA = (cans.colorIndexA+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  //  if (padVelocity[37] > 0) {
  //    shields.colorIndexB = (shields.colorIndexB+1)%shields.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    cans.colorIndexB = (cans.colorIndexB+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  //if (padVelocity[51] > 0) roof.colorSwap(0.9999999999);
  //if (padVelocity[43] > 0) pars.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {

  /////////////////////////////////////////////////////// 

  /////background noise over whole window/////
  /*
  if (padVelocity[50] > 0) {
   pars.colorLayer.beginDraw();
   pars.colorLayer.background(0, 0, 0, 0);
   pars.colorLayer.endDraw();
   //void bgNoise(PGraphics layer, color _col, float bright, float fizzyness) {
   
   bgNoise(pars.colorLayer, pars.flash, map(padVelocity[50], 0, 1, 0, pars.dimmer), cc[47]);   //PGraphics layer,color,alpha
   image(pars.colorLayer, pars.size.x, pars.size.y, pars.wide, pars.high);
   }
   */
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// MOMENTARY PAD BUTTON turns OFF all the animations in the given rig objects
void offBangButton(int noteNumber, Rig... rigs) {
  midiManager.noteOnActions[noteNumber] = (float velocity) -> {
    for (Rig rig : rigs) {
      for (Anim anim : rig.animations) {
        anim.deleteme = true;             // delete all the animations in the given rig objects
      } 
      rig.onBeat = false;
    }
  };  
  midiManager.noteOffActions[noteNumber] = () -> {
    for (Rig rig : rigs)rig.onBeat = true;
  };
}

// MOMENTARY PAD BUTTON adds the CURRENT ANIMATION to the given rig objects
// TODO change the alpha of the added anim so it reamins on screeen while the button is held down
// and can be controlled by a knob or a slider
void animOnBangButton(int noteNumber, Rig... rigs) {
  AnimationHolder[] animationHolders = new AnimationHolder[rigs.length];
  // TODO im not sure this loop is exaclty right but it does work
  midiManager.noteOnActions[noteNumber] = velocity ->{
    for (int i = 0; i < rigs.length; i++) {
      Rig rig = rigs[i];            // get the animation at the current vizIndex and add it to the animations list
      Anim anim = rig.animAtIndex(rig.vizIndex);
      anim.manuallyAdded = true;    // flag anim as manually added so it doesn't get deleted by PLAY WITH YOURSELF
      animationHolders[i] = new AnimationHolder(rig, anim); // create a new AnimationHolder object and add it to the array
      rig.animations.add(animationHolders[i].anim); 
    }
  };
  midiManager.noteOffActions[noteNumber] = () -> {
    for (AnimationHolder animationHolder : animationHolders) {
      if (animationHolder != null) {
        if (animationHolder.anim.manuallyAdded) {
          animationHolder.anim.deleteme = true;
        }
      }
    }
  };
}

// MOMENTARY PAD BUTTON adds ALL ON FOREVER to the given rig objects
void allOnForeverBangButton(int noteNumber, Rig... rigs) {
  AnimationHolder[] animationHolders = new AnimationHolder[rigs.length];
  // TODO im not sure this loop is exaclty right but it does work
  midiManager.noteOnActions[noteNumber] = velocity -> {
    for (int i = 0; i < rigs.length; i++) {
      Rig rig = rigs[i];
      Anim anim = new AllOnForever(rig, velocity);
      anim.manuallyAdded = true;   // flag anim as manually added so it doesn't get deleted by PLAY WITH YOURSELF
      animationHolders[i] = new AnimationHolder(rig, anim); // create a new AnimationHolder object and add it to the array
      rig.animations.add(animationHolders[i].anim); 
    }
  };
  midiManager.noteOffActions[noteNumber] = () -> {
    for (AnimationHolder animationHolder : animationHolders) {
      if (animationHolder != null) {
        if (animationHolder.anim.manuallyAdded) {
          animationHolder.anim.deleteme = true;
        }
      }
    }
  };
}


// MOMENTARY PAD BUTTON sets colorSwap for the given rig objects
void colorFlipBangButton(int noteNumber, Rig... rigs) {
  midiManager.momentarySwitch(noteNumber, velocity -> {
    if (velocity > 0) for (Rig rig : rigs) rig.colorFlip(true);
  });
}



// MOMENTARY PAD BUTTON sets colorSwap for the given rig objects
void colorSwapBangButton(int noteNumber, Rig... rigs) {
  // start a momemtary process that runs while the button is held down
  // this is slightly different from the momentarySwitch because it doesn't
  // doesnt have any parameters
  midiManager.momentaryProcess(noteNumber, velocity -> {
    if (velocity > 0) { // Check if the button is pressed (velocity > 0)
      for (Rig rig : rigs) rig.colorSwap(velocity);
    }
    midiManager.noteOffActions[noteNumber] = () ->{
      for (Rig rig : rigs) rig.colorSwap(rig.colorSwapRate);
    };
  });
}
 



