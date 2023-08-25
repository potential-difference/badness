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
  //colorSwapBangButton(59,shields,tipiLeft,tipiRight,megaSeedA,megaSeedB,megaSeedC,uvPars,filaments); // COLOR SWAP BANG BUTTON: noteNumber, rig objects to add animation to
  colorFlipBangButton(55,shields,tipiLeft,tipiRight,megaSeedA,megaSeedB,megaSeedC,uvPars,filaments); // COLOR FLIP BANG BUTTON: noteNumber, rig objects to add animation to

  // MOMENTARY ACTION that sets colorSwap for the given rig objects
  midiManager.newMomentary(59, (float velocity) ->{
    for (Rig rig : rigs) {
      rig.colorSwap(velocity);
      // println rig.type, "colorSwap", rig.colorSwapRate;
      println(rig.type, "colorSwap", rig.colorSwapRate);
    }
  });
  
  
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
  // Set the noteOn action for the given note number
  midiManager.noteOnActions[noteNumber] = (float velocity) -> {
    // Loop through each provided Rig object
    for (Rig rig : rigs) {
      // Loop through animations in the current rig and set the 'deleteme' flag
      for (Anim anim : rig.animations) {
        anim.deleteme = true;
      }
      // Update the 'onBeat' state for the current rig
      rig.onBeat = false;
    }
  };  
  // Set the noteOff action for the given note number
  midiManager.noteOffActions[noteNumber] = () -> {
    // Loop through each provided Rig object
    for (Rig rig : rigs) {
      // Update the 'onBeat' state for the current rig
      rig.onBeat = true;
    }
  };
}

// MOMENTARY PAD BUTTON adds the CURRENT ANIMATION to the given rig objects
void animOnBangButton(int noteNumber, Rig... rigs) {
  // set the noteOn action for the given note number
  midiManager.noteOnActions[noteNumber] = (float velocity) ->{
    // Loop through each provided Rig object
    for (Rig rig : rigs) {
      // get the animation at the current vizIndex and add it to the animations list
      Anim anim = rig.animAtIndex(rig.vizIndex);
      rig.animations.add(anim);
    }
    // set the noteOff action for the given note number
    midiManager.noteOffActions[noteNumber] = () ->{
      // Loop through each provided Rig object
      for (Rig rig : rigs) {
        // get the animation at the current vizIndex and set the 'deleteme' flag
        Anim anim = rig.animAtIndex(rig.vizIndex);
        anim.deleteme = true;
      }
    };
  };
}

// MOMENTARY PAD BUTTON adds ALL ON FOREVER to the given rig objects
void allOnForeverBangButton(int noteNumber, Rig... rigs) {
  AnimationHolder[] animationHolders = new AnimationHolder[rigs.length];
  
  midiManager.noteOnActions[noteNumber] = velocity -> {
    for (int i = 0; i < rigs.length; i++) {
      Rig rig = rigs[i];
      Anim animation = new AllOnForever(rig, velocity);
      animation.manuallyAdded = true; // Flag the animation as not flagged
      animationHolders[i] = new AnimationHolder(rig, animation);
      rig.animations.add(animationHolders[i].animation);
    }
  };

  midiManager.noteOffActions[noteNumber] = () -> {
    for (AnimationHolder animationHolder : animationHolders) {
      if (animationHolder != null) {
        if (animationHolder.animation.manuallyAdded) {
          System.out.println("Flagged animation for deletion: " + animationHolder.animation);
          animationHolder.animation.deleteme = true;
        }
        
      }
    }
  };
}



// A class to hold both the rig and the associated animation
class AnimationHolder {
  Rig rig;
  Anim animation;

  AnimationHolder(Rig rig, Anim animation) {
    this.rig = rig;
    this.animation = animation;
  }
}




// MOMENTARY PAD BUTTON sets colourSwap for the given rig objects
void colorSwapBangButton(int noteNumber, Rig... rigs) {
  midiManager.noteOnActions[noteNumber] = (float velocity) ->{
    for (Rig rig : rigs) {
      rig.colorSwap(velocity);
      // println rig.type, "colorSwap", rig.colorSwapRate;
      println(rig.type, "colorSwap", rig.colorSwapRate);
    }
    midiManager.noteOffActions[noteNumber] = () ->{
      for (Rig rig : rigs) {
        // set colorSwap to the default rate
        rig.colorSwap(rig.colorSwapRate);
      }
    };
  };
}

// MOMENTARY PAD BUTTON sets colorFlip for the given rig objects
void colorFlipBangButton(int noteNumber, Rig... rigs) {
  // set the noteOn action for the given note number
  midiManager.noteOnActions[noteNumber] = (float velocity) ->{
    for (Rig rig : rigs) rig.colorFlip(true);
    };
    midiManager.noteOffActions[noteNumber] = () ->{
      for (Rig rig : rigs) rig.colorFlip(false);
    };
  
}
 



