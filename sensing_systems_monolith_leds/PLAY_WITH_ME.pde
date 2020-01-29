/*
float[] lastTime = new float[cc.length];

void playWithMe() {

  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) da.colorSwap(0.9999999999);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) da.colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) da.colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  //if (keyT['y']) {
  //  colorLerping(da, (1-beat)*2);
  //  colorLerping(ro, (1-beat)*1.5);
  //}

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  float  debouncetime=100;
///////////////////////////// *** MANUAL ANIM WORK THAT DOESNT WORK **** ////////////////////////////
  /*
  try {
   if (millis()-lastTime[44]>debouncetime) {
   if (padVelocity[44]>0) da.animations.add(new Checkers (da));
   if (da.animations.size() > 0 ) { 
   Anim theanim = da.animations.get(da.animations.size()-1);
   //Envelope manualA = CrushPulse(0.0, 0, 1, da.manualAlpha*500, 0.0, 0.0);
   Envelope manualA = CrushPulse(0.05, 0.0, 1.0, avgmillis*(da.manualAlpha+0.5), 0.0, 0.0);
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
   
  /*
  if (millis()-lastTime[44]>debouncetime) {
   if (padVelocity[44]>0) da.animations.add(new StarMesh (da));
   lastTime[44]=millis();
   }
   
   if (millis()-lastTime[45]>debouncetime) {
   if (padVelocity[45]>0) da.animations.add(new SpiralFlower(da));
   lastTime[45]=millis();
   }
   
   if (millis()-lastTime[46]>debouncetime) {
   if (padVelocity[46]>0) da.animations.add(new Stars(da));
   lastTime[46]=millis();
   }
   */
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// ADD ANIM ////////////////////////////////////////////////////////////////////
 /*
  if (millis()-lastTime[0]>debouncetime*2.5) {
    if (keyP[' ']) {
      for (Rig rig : rigs) {
        if (rig.toggle) {
          beatTdaer = true;
          //if (testToggle) rig.animations.add(new Test(rig));
          rig.addAnim(rig.vizIndex);
        }
      }
      lastTime[0]=millis();
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// ALL ON ///////////////////////////////////////////////

  if (millis()-lastTime[47]>debouncetime) {
    if (padVelocity[47]>0) {
      da.animations.add( new AllOn(da)); //da.anim.alphaEnvelopeA = new CrushPulse(0.031, 0.040, 0.913, avgmillis*da.alphaRate*3+0.5, 0.0, 0.0);
      //anim = da.animations.get(da.animations.size()-1);
      lastTime[47]=millis();
    }
  }
  if (millis()-lastTime[39]>debouncetime) {
    if (padVelocity[39]>0) ro.animations.add( new AllOn(ro));
    lastTime[39]=millis();
  }
  if (millis()-lastTime[42]>debouncetime) {
    if (padVelocity[42]>0) for (Anim anim : te.animations) anim.deleteme = true;
    lastTime[42]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// KILL ALL ANIMS - BLACKOUT ///////////////////////////////////////////////
  if (millis()-lastTime[48]>debouncetime) {
    if (padVelocity[48]>0) for (Anim anim : da.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[48]=millis();
  }
  if (millis()-lastTime[40]>debouncetime) {
    if (padVelocity[40]>0) for (Anim anim : ro.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[40]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// STUTTER ///////////////////////////////////////////////x
  /*
  if (millis()-lastTime[49]>debouncetime) {
   if (padVelocity[49]>0) for (Anim anim : da.animations) {
   anim.alphaEnvelopeA = anim.alphaEnvelopeA.mul((1-cc[46])+(stutter*cc[46])); // anim.alphaEnvelopeA.mul(0.6+(stutter*0.4));     //anim.alphaEnvelopeA.mul((1-cc[46])+(stutter*cc[46]));
   anim.alphaEnvelopeB = anim.alphaEnvelopeB.mul((1-cc[46])+(stutter*cc[46])); //anim.alphaEnvelopeA.mul(0.6+(stutter*0.4)); //anim.alphaEnvelopeB.mul((1-cc[46])+(stutter*cc[46]));
   }
   lastTime[49]=millis();
   }
   
   if (millis()-lastTime[41]>debouncetime) {
   if (padVelocity[41]>0) for (Anim anim : da.animations) {
   anim.functionEnvelopeA = anim.functionEnvelopeA.mul(0.6+(stutter*0.4));  //     anim.functionEnvelopeA.mul((1-cc[54])+(stutter*cc[54]));
   anim.functionEnvelopeB = anim.functionEnvelopeB.mul(0.6+(stutter*0.4));    //anim.functionEnvelopeB.mul((1-cc[54])+(stutter*cc[54]));
   }
   lastTime[41]=millis();
   }
   */
  //  if (padVelocity[36] > 0) {
  //    da.colorIndexA = (da.colorIndexA+1)%da.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    pa.colorIndexA = (pa.colorIndexA+1)%pa.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  //  if (padVelocity[37] > 0) {
  //    da.colorIndexB = (da.colorIndexB+1)%da.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    pa.colorIndexB = (pa.colorIndexB+1)%pa.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  /*
  if (padVelocity[36] > 0) da.colorFlip(true);
  if (padVelocity[37] > 0) da.colorSwap(0.9999999999);

  if (padVelocity[38] > 0) ro.colorSwap(0.9999999999);
  if (padVelocity[39] > 0) te.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {

  /////////////////////////////////////////////////////// 

  /////background noise over whole window/////
  if (padVelocity[51] > 0) {
    da.colorLayer.beginDraw();
    da.colorLayer.background(0, 0, 0, 0);
    da.colorLayer.endDraw();
    bgNoise(da.colorLayer, da.flash, map(padVelocity[51], 0, 1, 0, da.dimmer/1.5), cc[48]);   //PGraphics layer,color,alpha
    image(da.colorLayer, da.size.x, da.size.y, da.wide, da.high);
  }
  if (padVelocity[43] > 0) {
    ro.colorLayer.beginDraw();
    ro.colorLayer.background(0, 0, 0, 0);
    ro.colorLayer.endDraw();
    bgNoise(ro.colorLayer, ro.flash, map(padVelocity[43], 0, 1, 0, ro.dimmer), cc[56]);   //PGraphics layer,color,alpha
    image(ro.colorLayer, ro.size.x, ro.size.y, ro.wide, ro.high);
  }

  if (padVelocity[50] > 0) {
    te.colorLayer.beginDraw();
    te.colorLayer.background(0, 0, 0, 0);
    te.colorLayer.endDraw();
    //void bgNoise(PGraphics layer, color _col, float bright, float fizzyness) {

    bgNoise(te.colorLayer, te.flash, map(padVelocity[50], 0, 1, 0, te.dimmer), cc[47]);   //PGraphics layer,color,alpha
    image(te.colorLayer, te.size.x, te.size.y, te.wide, te.high);
  }
}
*/
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void paControl(color col, float alpha) {
  fill(col, 360*alpha);
  rect(opcGrid.pa[0].x, opcGrid.pa[0].y, opcGrid.paLength, 3);
  rect(opcGrid.pa[1].x, opcGrid.pa[1].y, opcGrid.paLength, 3);
}
void rigControl(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke( col, 360*alpha);
  for (int i  = 0; i < opcGrid.mirror.length; i++) rect(opcGrid.mirror[i].x, opcGrid.mirror[i].y, opcGrid._mirrorWidth, opcGrid._mirrorWidth);
  noStroke();
}
void seedsControlA(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seeds[0].x, opcGrid.seeds[0].y, opcGrid.seedsLength, 3);
  noStroke();
}
void seedsControlB(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seeds[1].x, opcGrid.seeds[1].y, opcGrid.seedsLength, 3);
  noStroke();
}
void seedsControlC(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seeds[2].x, opcGrid.seeds[2].y, 3, opcGrid.seeds2Length);
  noStroke();
}
void controllerControl(color col, float alpha) {
  fill(col, 360*alpha);
  rect(opcGrid.controller[0].x, opcGrid.controller[0].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[1].x, opcGrid.controller[1].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[2].x, opcGrid.controller[2].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[3].x, opcGrid.controller[3].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
}

/*
 //if (cc[104] > 0) {
 //  animations.add(new MirrorsOn(manualSlider, 1-(stutter*stutterSlider), cc[104]*rigDimmer));
 //  da.colorFlip(true);
 //}
 //if (cc[107] > 0) animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[107]*roDimmer));
 //if (cc[108] > 0) { 
 //  ro.colorFlip(true);
 //  animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[108]*roDimmer));
 //}
 */
/*
 for (int i = 0; i < 4; i++) if (padPressed[101+i]) {
 da.dimmer = pad[101+i];
 da.animations.add(new Anim(i, manualSlider, funcRate, da)); // use pad buttons to play differnt viz
 }
 for (int i = 0; i < 3; i++) if (padPressed[105+i]) {
 ro.dimmer = pad[105+i];
 ro.animations.add(new Anim(i, manualSlider, funcRate, ro)); // use pad buttons to play differnt viz
 }
 if (padPressed[108]) {
 ro.dimmer = pad[108];
 ro.animations.add(new Anim(10, manualSlider, funcRate, ro)); // use pad buttons to play differnt viz
 }
 
 for (int i =0; i < 8; i++)if (padPressed[i]) {
 da.dimmer = padVelocity[i];
 da.animations.add(new Anim(i, alphaRate, funcRate, da)); // use pad buttons to play differnt viz
 }
 */
/*
//for (int i = 0; i<8; i++) if (keyP[49+i]) da.animations.add(new Anim(i, manualSlider, funcSlider, da));       // use number buttons to play differnt viz
 //if (keyP[48]) animations.add(new AllOn(manualSlider, 1, rigDimmer));   
 
 // '0' tdaers all on for the rig
 
 */
