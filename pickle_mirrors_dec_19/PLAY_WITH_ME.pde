float[] lastTime = new float[cc.length];

void playWithMe() {




  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) rigg.colorSwap(0.9999999999);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) rigg.colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) rigg.colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  if (keyT['y']) {
    colorLerping(rigg, (1-beat)*2);
    colorLerping(roof, (1-beat)*1.5);
  }
  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) vizTimer = millis()/1000;              // hold viz change timer
  if (colHold) {
    rigg.colorTimer = millis()/1000;              // hold color change timer
    roof.colorTimer = millis()/1000;              // hold color change timer
    cans.colorTimer = millis()/1000;              // hold color change timer
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyP[' ']) { 
    for (Rig rig : rigs) {
      if (rig.toggle) {
        beatTrigger = true;
        //if (testToggle) rig.animations.add(new Test(rig));
        rig.addAnim(rig.vizIndex);
      }
    }
  } 
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //rig.addAnim(rig.availableAnims[rig.vizIndex]);
  float  debouncetime=50;
  /*
  for (int i = 0; i < 7; i++) {
   if (millis()-lastTime[44+i]>debouncetime) {
   if (padVelocity[44+i]>0) rigg.addAnim(rigg.availableAnims[i]);
   lastTime[44+i]=millis();
   }
   }
   */
  if (millis()-lastTime[44]>debouncetime) {
    if (padVelocity[44]>0) rigg.addAnim(rigg.availableAnims[1]);
    lastTime[44]=millis();
  }

  if (millis()-lastTime[45]>debouncetime) {
    if (padVelocity[45]>0) rigg.addAnim(rigg.availableAnims[6]);
    lastTime[45]=millis();
  }

  if (millis()-lastTime[46]>debouncetime) {
    if (padVelocity[46]>0) rigg.addAnim(rigg.availableAnims[10]);
    lastTime[46]=millis();
  }

  if (millis()-lastTime[46]>debouncetime) {
    if (padVelocity[46]>0) rigg.addAnim(rigg.availableAnims[10]);
    lastTime[46]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// ALL ON ///////////////////////////////////////////////

  if (millis()-lastTime[47]>debouncetime) {
    if (padVelocity[47]>0) {
      rigg.animations.add( new AllOn(rigg)); //rigg.anim.alphaEnvelopeA = new CrushPulse(0.031, 0.040, 0.913, avgmillis*rigg.alphaRate*3+0.5, 0.0, 0.0);
      lastTime[47]=millis();
    }
  }
  if (millis()-lastTime[39]>debouncetime) {
    if (padVelocity[39]>0) roof.animations.add( new AllOn(roof));
    lastTime[39]=millis();
  }
  if (millis()-lastTime[42]>debouncetime) {
    if (padVelocity[42]>0) pars.animations.add( new AllOn(pars)); //rig.animations.add(new Test(rig))
    lastTime[42]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// KILL ALL ANIMS - BLACKOUT ///////////////////////////////////////////////
  if (millis()-lastTime[48]>debouncetime) {
    if (padVelocity[48]>0) for (Anim anim : rigg.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[48]=millis();
  }
  if (millis()-lastTime[40]>debouncetime) {
    if (padVelocity[40]>0) for (Anim anim : roof.animations) anim.deleteme = true;  // immediately delete all anims
    lastTime[40]=millis();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////// STUTTER ///////////////////////////////////////////////

  if (millis()-lastTime[49]>debouncetime) {
    if (padVelocity[49]>0) for (Anim anim : rigg.animations) {
      anim.alphaEnvelopeA = anim.alphaEnvelopeA.mul(08.+(stutter*cc[46]));
      anim.alphaEnvelopeB = anim.alphaEnvelopeB.mul(08.+(stutter*cc[46]));
    }
    lastTime[49]=millis();
  }

  //  if (padVelocity[36] > 0) {
  //    rigg.colorIndexA = (rigg.colorIndexA+1)%rigg.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    cans.colorIndexA = (cans.colorIndexA+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  //  if (padVelocity[37] > 0) {
  //    rigg.colorIndexB = (rigg.colorIndexB+1)%rigg.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //    cans.colorIndexB = (cans.colorIndexB+1)%cans.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  //  }
  if (padVelocity[36] > 0) rigg.colorFlip(true);
  if (padVelocity[37] > 0) cans.colorFlip(true);

  if (padVelocity[38] > 0) rigg.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY
  if (padVelocity[39] > 0) cans.colorSwap(0.9999999999);



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {

  // rig dimmer shold affect bgnosie


  /////background noise over whole window/////
  if (padVelocity[51] > 0) {
    rigg.colorLayer.beginDraw();
    rigg.colorLayer.background(0, 0, 0, 0);
    rigg.colorLayer.endDraw();
    bgNoise(rigg.colorLayer, rigg.flash, map(padVelocity[51], 0, 1, 0, 1), cc[48]*rigg.dimmer);   //PGraphics layer,color,alpha
    image(rigg.colorLayer, rigg.size.x, rigg.size.y, rigg.wide, rigg.high);
  }
  if (padVelocity[43] > 0) {
    roof.colorLayer.beginDraw();
    roof.colorLayer.background(0, 0, 0, 0);
    roof.colorLayer.endDraw();
    bgNoise(roof.colorLayer, roof.flash, map(padVelocity[43], 0, 1, 0, 1), cc[56]*roof.dimmer);   //PGraphics layer,color,alpha
    image(roof.colorLayer, roof.size.x, roof.size.y, roof.wide, roof.high);
  }

  if (padVelocity[50] > 0) {
    pars.colorLayer.beginDraw();
    pars.colorLayer.background(0, 0, 0, 0);
    pars.colorLayer.endDraw();
    bgNoise(pars.colorLayer, pars.flash, map(padVelocity[50], 0, 1, 0, 1), cc[55]*pars.dimmer);   //PGraphics layer,color,alpha
    image(pars.colorLayer, pars.size.x, pars.size.y, pars.wide, pars.high);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void cansControl(color col, float alpha) {
  fill(col, 360*alpha);
  rect(opcGrid.cans[0].x, opcGrid.cans[0].y, opcGrid.cansLength, 3);
  rect(opcGrid.cans[1].x, opcGrid.cans[1].y, opcGrid.cansLength, 3);
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
 //  rigg.colorFlip(true);
 //}
 //if (cc[107] > 0) animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[107]*roofDimmer));
 //if (cc[108] > 0) { 
 //  roof.colorFlip(true);
 //  animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[108]*roofDimmer));
 //}
 */
/*
 for (int i = 0; i < 4; i++) if (padPressed[101+i]) {
 rigg.dimmer = pad[101+i];
 rigg.animations.add(new Anim(i, manualSlider, funcRate, rigg)); // use pad buttons to play differnt viz
 }
 for (int i = 0; i < 3; i++) if (padPressed[105+i]) {
 roof.dimmer = pad[105+i];
 roof.animations.add(new Anim(i, manualSlider, funcRate, roof)); // use pad buttons to play differnt viz
 }
 if (padPressed[108]) {
 roof.dimmer = pad[108];
 roof.animations.add(new Anim(10, manualSlider, funcRate, roof)); // use pad buttons to play differnt viz
 }
 
 for (int i =0; i < 8; i++)if (padPressed[i]) {
 rigg.dimmer = padVelocity[i];
 rigg.animations.add(new Anim(i, alphaRate, funcRate, rigg)); // use pad buttons to play differnt viz
 }
 */
/*
//for (int i = 0; i<8; i++) if (keyP[49+i]) rigg.animations.add(new Anim(i, manualSlider, funcSlider, rigg));       // use number buttons to play differnt viz
 //if (keyP[48]) animations.add(new AllOn(manualSlider, 1, rigDimmer));   
 
 // '0' triggers all on for the rig
 
 */
