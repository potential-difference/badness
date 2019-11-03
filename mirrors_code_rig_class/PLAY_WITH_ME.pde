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
  if (keyP[' ']) animations.add(new Anim(rigViz, alphaSlider, funcSlider, rigDimmer));         // or space bar!
  if (keyP[' ']) animations.add(new RoofAnim(roofViz, alphaSlider, funcSlider, roofDimmer));   // or space bar!
  if (keyP[' ']) animations.add(new CansAnim(roofViz, alphaSlider, funcSlider, roofDimmer));   // or space bar!

  if (keyP['a']) animations.add(new RoofOn(manualSlider, stutter, rigDimmer));
  if (keyP['s']) {
    animations.add(new RoofOn(manualSlider, stutter, rigDimmer));
    rigColor.colorFlip(true);
  }
  if (keyP['z'] ) animations.add(new AllOn(manualSlider, stutter, rigDimmer));
  if (keyP['`'] ) { 
    animations.add(new AllOn(manualSlider, stutter, roofDimmer));
    roofColor.colorFlip(true);
  }
  float alphaRate = cc[1];
  float funcRate = cc[2];

  if (cc[101] > 0) animations.add(new Anim(rigViz, alphaRate, funcRate, cc[101])); // current animation
  if (cc[102] > 0) animations.add(new Anim(9, alphaRate, funcRate, cc[102])); // current animation
  if (cc[103] > 0) { 
    rigColor.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY
    roofColor.colorSwap(0.9999999999);
  }
  if (cc[104] > 0) {
    animations.add(new AllOn(manualSlider, 1-(stutter*stutterSlider), cc[104]));
    rigColor.colorFlip(true);
  }
  if (cc[107] > 0) animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[107]));
  if (cc[108] > 0) { 
    animations.add(new CansOn(manualSlider, 1-(stutter*stutterSlider), cc[108]));
    cansColor.colorFlip(true);
  }

  for (int i = 0; i < 8; i++) if (padPressed[101+i]) animations.add(new Anim(i, alphaRate, funcRate, pad[101+i])); // use pad buttons to play differnt viz
  for (int i = 0; i<8; i++) if (keyP[49+i]) animations.add(new Anim(i, manualSlider, funcSlider, rigDimmer));       // use number buttons to play differnt viz
  if (keyP[48]) animations.add(new AllOn(manualSlider, 1, rigDimmer));                                             // '0' triggers all on for the rig
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {
  /////background noise over whole window/////
  if (cc[105] > 0) {
    rigBuffer.colorLayer.beginDraw();
    rigBuffer.colorLayer.background(0, 0, 0, 0);
    rigBuffer.colorLayer.endDraw();
    bgNoise(rigBuffer.colorLayer, rigColor.flash, map(cc[105], 0, 1, 0.2, 1), cc[5]);   //PGraphics layer,color,alpha
    image(rigBuffer.colorLayer, size.rigWidth/2, size.rigHeight/2);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void cansControl(color col, float alpha) {
  fill(col, 360*alpha);
  rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
  rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);
}
void rigControl(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke( col, 360*alpha);
  for (int i  = 0; i < grid.mirror.length; i++) rect(grid.mirror[i].x, grid.mirror[i].y, grid._mirrorWidth, grid._mirrorWidth);
  noStroke();
}
void seedsControlA(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
  noStroke();
}
void seedsControlB(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
  noStroke();
}
void seedsControlC(color col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(grid.seed[2].x, grid.seed[2].y, 3, grid.seed2Length);
  noStroke();
}
void controllerControl(color col, float alpha) {
  fill(col, 360*alpha);
  rect(grid.controller[0].x, grid.controller[0].y, grid.controllerWidth, grid.controllerWidth);
  rect(grid.controller[1].x, grid.controller[1].y, grid.controllerWidth, grid.controllerWidth);
  rect(grid.controller[2].x, grid.controller[2].y, grid.controllerWidth, grid.controllerWidth);
  rect(grid.controller[3].x, grid.controller[3].y, grid.controllerWidth, grid.controllerWidth);
}
