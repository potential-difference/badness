void playWithMe() {
  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) rigColor.colorSwap(0.9999999999);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) rigColor.colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) rigColor.colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  if (keyT['y']) {
    colorLerping(rigColor, (1-beat)*2);
    colorLerping(roofColor, (1-beat)*1.5);
  }
  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) vizTimer = millis()/1000;              // hold viz change timer
  if (colHold) {
    rigColor.colorTimer = millis()/1000;              // hold color change timer
    roofColor.colorTimer = millis()/1000;              // hold color change timer
    cansColor.colorTimer = millis()/1000;              // hold color change timer
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyP[' ']) animations.add(new Anim(rigg.vizIndex, alphaSlider, funcSlider, rigg));         // or space bar!
  if (keyP[' ']) animations.add(new Anim(roof.vizIndex, alphaSlider, funcSlider, roof));   // or space bar!
  if (keyP[' ']) animations.add(new Anim(10, alphaSlider, funcSlider, cans));   // or space bar!

  if (keyP['a']) animations.add(new AllOn(manualSlider, stutter, rigg));
  if (keyP['s']) {
    animations.add(new AllOn(manualSlider, stutter, rigg));
    rigColor.colorFlip(true);
  }
  if (keyP['z'] ) animations.add(new AllOn(manualSlider, stutter, roof));
  if (keyP['`'] ) { 
    animations.add(new AllOn(manualSlider, stutter, roof));
    roofColor.colorFlip(true);
  }
  float alphaRate = cc[1];
  float funcRate = cc[2];

  //if (cc[101] > 0) animations.add(new MirrorsAnim(rigViz, alphaRate, funcRate, cc[101]*rigDimmer/2)); // current animation
  //if (cc[102] > 0) animations.add(new RoofAnim(rigViz, alphaRate, funcRate, cc[102]*roofDimmer/2)); // current animation
  if (cc[103] > 0) { 
    rigColor.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY
    roofColor.colorSwap(0.9999999999);
  }
  //if (cc[104] > 0) {
  //  animations.add(new MirrorsOn(manualSlider, 1-(stutter*stutterSlider), cc[104]*rigDimmer));
  //  rigColor.colorFlip(true);
  //}
  //if (cc[107] > 0) animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[107]*roofDimmer));
  //if (cc[108] > 0) { 
  //  roofColor.colorFlip(true);
  //  animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[108]*roofDimmer));
  //}

  for (int i = 0; i < 4; i++) if (padPressed[101+i]){
   rigg.dimmer = pad[101+i];
    animations.add(new Anim(i, manualSlider, funcRate, rigg)); // use pad buttons to play differnt viz
  }
  for (int i = 0; i < 3; i++) if (padPressed[105+i]) {
    roof.dimmer = pad[105+i];
    animations.add(new Anim(i, manualSlider, funcRate, roof)); // use pad buttons to play differnt viz
  }
  if (padPressed[108]) {
    roof.dimmer = pad[108];
    animations.add(new Anim(10, manualSlider, funcRate, roof)); // use pad buttons to play differnt viz
  }

  for (int i =0; i < 8; i++)if (padPressed[i]) {
    rigg.dimmer = padVelocity[i];
    animations.add(new Anim(i, alphaRate, funcRate, rigg)); // use pad buttons to play differnt viz
  }


  for (int i = 0; i<8; i++) if (keyP[49+i]) animations.add(new Anim(i, manualSlider, funcSlider, rigg));       // use number buttons to play differnt viz
  //if (keyP[48]) animations.add(new AllOn(manualSlider, 1, rigDimmer));   

  // '0' triggers all on for the rig
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {
  /////background noise over whole window/////
  if (cc[105] > 0) {
    rigg.colorLayer.beginDraw();
    rigg.colorLayer.background(0, 0, 0, 0);
    rigg.colorLayer.endDraw();
    bgNoise(rigg.colorLayer, rigg.flash, map(cc[105], 0, 1, 0.2, 1), cc[5]*rigg.dimmer);   //PGraphics layer,color,alpha
    image(rigg.colorLayer, rigg.size.x, rigg.size.y, rigg.wide, rigg.high);
  }
  if (cc[106] > 0) {
    roof.colorLayer.beginDraw();
    roof.colorLayer.background(0, 0, 0, 0);
    roof.colorLayer.endDraw();
    bgNoise(roof.colorLayer, roof.flash, map(cc[106], 0, 1, 0.2, 1), cc[6]*roof.dimmer);   //PGraphics layer,color,alpha
    image(roof.colorLayer, roof.size.x, roof.size.y, roof.wide, roof.high);
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
  rect(opcGrid.seed[0].x, opcGrid.seed[0].y, opcGrid.seedLength, 3);
  noStroke();
}
void seedsControlB(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seed[1].x, opcGrid.seed[1].y, opcGrid.seedLength, 3);
  noStroke();
}
void seedsControlC(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(opcGrid.seed[2].x, opcGrid.seed[2].y, 3, opcGrid.seed2Length);
  noStroke();
}
void controllerControl(color col, float alpha) {
  fill(col, 360*alpha);
  rect(opcGrid.controller[0].x, opcGrid.controller[0].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[1].x, opcGrid.controller[1].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[2].x, opcGrid.controller[2].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
  rect(opcGrid.controller[3].x, opcGrid.controller[3].y, opcGrid.controllerWidth, opcGrid.controllerWidth);
}
