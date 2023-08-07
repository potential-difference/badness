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

  noteOnActions[99] = (float velocity)->{
    //Anim x = new Stars(rigs.get(0));
    //x.animDimmer.set(velocity);
    rigs.get(0).animations.add(new Stars(rigs.get(0)));
  };

  noteOnActions[46] = (float velocity)->{
    for (Rig rig: rigs){
      rig.animations.add(new AllOn(rig));
    } 
  };

  noteOnActions[49] = (float velocity)->{
    rigs.get(0).colorFlip(true);
  };
///////////////////////////////////////////////// STUTTER ///////////////////////////////////////////////x

  
  noteOnActions[48] =(float velocity)->{
     for (Anim anim : rigs.get(0).animations) {
      anim.alphaEnvelopeA = anim.alphaEnvelopeA.mul((1-cc[45])+(stutter*cc[45])); // anim.alphaEnvelopeA.mul(0.6+(stutter*0.4));     //anim.alphaEnvelopeA.mul((1-cc[46])+(stutter*cc[46]));
      anim.alphaEnvelopeB = anim.alphaEnvelopeB.mul((1-cc[45])+(stutter*cc[45])); //anim.alphaEnvelopeA.mul(0.6+(stutter*0.4)); //anim.alphaEnvelopeB.mul((1-cc[46])+(stutter*cc[46]));
    }
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
  if (padVelocity[51] > 0) {
    shields.colorLayer.beginDraw();
    shields.colorLayer.background(0, 0, 0, 0);
    shields.colorLayer.endDraw();
    bgNoise(shields.colorLayer, shields.flash, map(padVelocity[51], 0, 1, 0, shields.dimmer/1.5), cc[48]);   //PGraphics layer,color,alpha
    image(shields.colorLayer, shields.size.x, shields.size.y, shields.wide, shields.high);
  }
  if (padVelocity[43] > 0 && roof != null) {
    roof.colorLayer.beginDraw();
    roof.colorLayer.background(0, 0, 0, 0);
    roof.colorLayer.endDraw();
    bgNoise(roof.colorLayer, roof.flash, map(padVelocity[43], 0, 1, 0, roof.dimmer), cc[56]);   //PGraphics layer,color,alpha
    image(roof.colorLayer, roof.size.x, roof.size.y, roof.wide, roof.high);
  }
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
