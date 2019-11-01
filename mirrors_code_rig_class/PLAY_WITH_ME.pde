void playWithMe() {


  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['\\']) rigColor.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['\'']) rigColor.colFlip = (keyT['\'']);                  // COLOR FLIP TOGGLE 
  if (keyP[';']) rigColor.colFlip = !rigColor.colFlip;                   // COLOR FLIP MOMENTARY
  rigColor.colorFlip(rigColor.colFlip);
  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  if (keyT['l']) {
    colorLerping(rigColor, (1-beat)*2);
        colorLerping(roofColor, (1-beat)*1.5);
  }
  //if (keyT['o']) colorLerping(rig, beatFast); 
  //colBeat = !colBeat;
  // lerpcolor function goes in here
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) time[0] = millis()/1000;              // hold viz change timer
  if (colHold) time[3] = millis()/1000;              // hold color change timer
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (keyP[' ']) animations.add(new Anim(RIG, rigViz, alphaSlider, funcSlider, rigDimmer));   // or space bar!
  if (keyP['a']) animations.add(new AllOn(RIG, manualSlider, stutter, rigDimmer));
  if (keyP['s']) {
    animations.add(new AllOn(RIG, manualSlider, stutter, rigDimmer));
    rigColor.colorFlip(true);
  }
  if (keyP['z'] ) animations.add(new AllOn(ROOF, manualSlider, stutter, roofDimmer));
  if (keyP['`'] ) { 
    animations.add(new AllOn(ROOF, manualSlider, stutter, roofDimmer));
    roofColor.colorFlip(true);
  }

  if (cc[101] > 0) animations.add(new Anim(RIG, rigViz, cc[1], cc[2], cc[101])); // current animation
  if (cc[102] > 0) animations.add(new Anim(RIG, 9, cc[1], cc[2], cc[102])); // current animation
  if (cc[103] > 0) { 
    rigColor.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY
    roofColor.colorSwap(0.9999999999);
  }
  if (cc[104] > 0) {
    animations.add(new AllOn(RIG, manualSlider, 1-(stutter*stutterSlider), cc[104]));
    rigColor.colorFlip(true);
  }
  if (cc[107] > 0) animations.add(new AllOn(ROOF, manualSlider, 1-(stutter*stutterSlider), cc[107]));
  if (cc[108] > 0) { 
    animations.add(new AllOn(ROOF, manualSlider, 1-(stutter*stutterSlider), cc[108]));
    roofColor.colorFlip(true);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {

  /////background noise over whole window/////
  if (cc[105] > 0) {
    rigColourLayer.beginDraw();
    rigColourLayer.background(0, 0, 0, 0);
    rigColourLayer.endDraw();
    bgNoise(rigColourLayer, rigColor.flash, map(cc[105], 0, 1, 0.2, 1), cc[5]);   //PGraphics layer,color,alpha
    image(rigColourLayer, size.rigWidth/2, size.rigHeight/2);
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
