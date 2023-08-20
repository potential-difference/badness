float[] lastTime = new float[cc.length];

/*midiMap[46] = (float cc)->{
  if (cc == 1.0){
    rigs.get(0).animations.add new StarMesh(rigs.get(0));
  }
};
*/
void setupMidiActions(){
  newMomentary(100,()->{
    rigs.get(0).colorSwap(0.9999);
  });
  //MIDI PAD AKAI
  //      A                   B
  //48  49  50  51    64  65  66  67
  //44  45  46  47    60  61  62  63
  //40  41  42  43    56  57  58  59
  //36  37  38  39    52  53  54  55

  

  MidiAction shieldsOff = (float velocity) ->{
    for (Anim anim : shields.animations) anim.deleteme = true;
  //and also prevent pwys from adding more to shields
    shields.onBeat = false;
  };
  noteOnActions[64] = shieldsOff;
  noteOffActions[64] = ()->{
    shields.onBeat = true;
  };

  noteOnActions[65] = (float velocity) ->{
    Anim anim = shields.animAtIndex(shields.vizIndex);
    shields.animations.add(anim);
    noteOffActions[65] = ()->{
      anim.deleteme = true;
    };
  };

  //allON shields momentary..
  noteOnActions[66] = (float velocity) ->{
    //get an allonforever anim that has no 
    // dependence on alpha
    Anim anim = new AllOnForever(shields);    
    //add it to the rig
    shields.animations.add(anim);
    noteOffActions[66] = ()->{
      anim.deleteme = true;
    };
  };
  ///////////////////////////// TPIPS ////////////////////////////////////////////////
  // turn off the tips
  noteOnActions[60] = (float velocity) -> {
    //delete all the anims
    for (Anim anim : tipiRight.animations) anim.deleteme = true;
    for (Anim anim : tipiLeft.animations) anim.deleteme = true; 
    //disable adding anims on beats
    tipiRight.onBeat = false;
    tipiLeft.onBeat = false;
  };
  noteOffActions[60] = () -> {
    tipiLeft.onBeat = true;
    tipiRight.onBeat = true;
  };

  //both Tipis bang
  noteOnActions[61] = (float velocity) ->{
    Anim anim = tipiLeft.animAtIndex(tipiLeft.vizIndex);
    tipiLeft.animations.add(anim);
    Anim anim1 = tipiRight.animAtIndex(tipiRight.vizIndex);
    tipiRight.animations.add(anim1); 
    noteOffActions[61] = ()->{
      anim.deleteme = true;
      anim1.deleteme = true;
    };
  };

  //all ON both tipis momentary..
  noteOnActions[62] = (float velocity) ->{
    Anim anim = new AllOnForever(tipiLeft);
    Anim anim1 = new AllOnForever(tipiRight);
    tipiLeft.animations.add(anim);
    tipiRight.animations.add(anim1);

    noteOffActions[62] = ()->{
      anim.deleteme = true;
      anim1.deleteme = true;
    };
  };

  ////////////////////////// MEGA SEEDS ////////////////////////////////////
  
  // turn them off
  noteOnActions[56] = (float velocity) -> {
    for (Anim anim : megaSeedA.animations) anim.deleteme = true;
    for (Anim anim : megaSeedB.animations) anim.deleteme = true;
    for (Anim anim : megaSeedC.animations) anim.deleteme = true;

    megaSeedA.onBeat = false;
    megaSeedB.onBeat = false;
    megaSeedC.onBeat = false;
  };
  noteOffActions[56] = () -> {
    megaSeedA.onBeat = true;
    megaSeedB.onBeat = true;
    megaSeedC.onBeat = true;
  };

  //all megaseeds bang
  noteOnActions[57] = (float velocity) ->{
    Anim animA = megaSeedA.animAtIndex(megaSeedA.vizIndex);
    Anim animB = megaSeedB.animAtIndex(megaSeedB.vizIndex);
    Anim animC = megaSeedC.animAtIndex(megaSeedC.vizIndex);
    megaSeedA.animations.add(animA);
    megaSeedB.animations.add(animB);
    megaSeedC.animations.add(animC);
    noteOffActions[57] = ()->{
      animA.deleteme = true;
      animB.deleteme = true;
      animC.deleteme = true;
    };
  };
  // all megaseds all on
  noteOnActions[58] = (float velocity) ->{
    Anim animA = new AllOnForever(megaSeedA);
    Anim animB = new AllOnForever(megaSeedB);
    Anim animC = new AllOnForever(megaSeedC);

   megaSeedA.animations.add(animA);
   megaSeedB.animations.add(animB);
   megaSeedC.animations.add(animC);
    noteOffActions[58] = ()->{
      animA.deleteme = true;
      animB.deleteme = true;
      animC.deleteme = true;
    };
  };

/////////////// FILLAMENTS ///////////////////////////////////
  // filaments.manualAlpha = cc[9]; 
  // TODO figure this out so that controller knobs affect the 
  // bightness off the all on amin 
  // we have manuaAlpah but im not sure execactly what its doing here
  noteOnActions[67] = (float velocity)->{
    Anim anim = new AllOn(filaments);
    filaments.animations.add(anim);
    noteOffActions[67] = ()->{
      anim.deleteme = true;
    };
  }; 
  noteOnActions[63] = (float velocity)->{
     Anim anim = new AllOnForever(filaments);
    filaments.animations.add(anim);
    noteOffActions[63] = ()->{
      anim.deleteme = true;
    };
  };
  
  //////////////////////////////////////// UV PARS 
  noteOnActions[52] = (float velocity) -> {
    //delete all the anims
    for (Anim anim : uvPars.animations) anim.deleteme = true;
    //disable adding anims on beats
    uvPars.onBeat = false;
  };
  
  //when the button lifts, re-enable beat adding 
  noteOffActions[52] = () -> {
    uvPars.onBeat = true;
  };

  noteOnActions[53] = (float velocity) ->{
    Anim anim = uvPars.animAtIndex(uvPars.vizIndex);
    uvPars.animations.add(anim);
    noteOffActions[53] = ()->{
      anim.deleteme = true;
    };
  };

  noteOnActions[54] = (float velocity) ->{
    //get an allonforever anim that has no 
    // dependence on alpha
    Anim anim = new AllOnForever(uvPars);    
    //add it to the rig
    uvPars.animations.add(anim);
    noteOffActions[54] = ()->{
      anim.deleteme = true;
    };
  };
  

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

  ////////////////////////////////////// Momentary pad button actions //////////////////////////////
  for (int idx=0;idx<128;idx++){//action: everyFrameActions){
    FrameAction action = everyFrameActions[idx];
    if (action != null){
      action.doit();
    }
  }

  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) rigs.get(0).colorSwap(0.9999999999);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) rigs.get(0).colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) rigs.get(0).colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  //if (keyT['y']) {
  //  colorLerping(shields, (1-beat)*2);
  //  colorLerping(roof, (1-beat)*1.5);
  //}

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
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// ADD ANIM ////////////////////////////////////////////////////////////////////
  /*if (millis()-lastTime[0]>debouncetime*2.5) {
    if (keyP[' ']) {
      for (Rig rig : rigs) {
        if (true){
          rig.addAnim(rig.vizIndex);
        }
      }
      lastTime[0]=millis();
    }
  }
  */
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /*
  int ccc = 101;
  if (millis()-lastTime[ccc]>debouncetime) {
    if (padVelocity[ccc]>0) shields.animations.add(new StarMesh (shields));
    lastTime[ccc]=millis();
  }
  */
  //if (millis()-lastTime[45]>debouncetime) {
  //  if (padVelocity[45]>0) shields.animations.add(new SpiralFlower(shields));
  //  lastTime[45]=millis();
  //}
  /*
  ccc= 102;
    if (millis()-lastTime[ccc]>debouncetime) {
    if (padVelocity[ccc]>0) shields.animations.add(new Stars(shields));
    lastTime[ccc]=millis();
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
  ///////////////////////////////////////////////// KILL ALL ANIMS - BLACKOUT ///////////////////////////////////////////////

  ///// DEBOUNCE?! /////
  /*
  if (millis()-lastTime[47]>debouncetime) {
    if (padVelocity[47]>0) for (Anim anim : shields.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[47]=millis();
  }
  */
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////  COLOUR //////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //if (millis()-lastTime[36]>debouncetime) {
  // if (padVelocity[36]>0) shields.animations.add(new StarMesh (roof));
  // lastTime[36]=millis();
  // }

  // if (millis()-lastTime[37]>debouncetime) {
  // if (padVelocity[37]>0) shields.animations.add(new SingleDonut(roof));
  // lastTime[37]=millis();
  // }

  // if (millis()-lastTime[38]>debouncetime) {
  // if (padVelocity[38]>0) shields.animations.add(new BenjaminsBoxes(roof));
  // lastTime[38]=millis();
  // }
  /*
  if (millis()-lastTime[39]>debouncetime) {
   if (padVelocity[39]>0) roof.animations.add( new AllOn(roof));
   lastTime[39]=millis();
   }
   */
  /*
  if (millis()-lastTime[40]>debouncetime) {
   if (padVelocity[40]>0) for (Anim anim : roof.animations) anim.deleteme = true;  // immediately delete all anims
   lastTime[40]=millis();
   }
   */
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
