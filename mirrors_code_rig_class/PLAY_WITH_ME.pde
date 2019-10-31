void playWithMe() {


  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['\\'] || cc[103] > 0 ) rigColor.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['\'']) rigColor.colFlip = (keyT['\'']);                  // COLOR FLIP TOGGLE 
  if (keyP[';']) rigColor.colFlip = !rigColor.colFlip;                   // COLOR FLIP MOMENTARY
  rigColor.colorFlip(rigColor.colFlip);
  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  //if (keyP['l']) colorLerping(rig, beatFast);
  //if (keyT['o']) colorLerping(rig, beatFast); 
  //colBeat = !colBeat;
  // lerpcolor function goes in here
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) time[0] = millis()/1000;              // hold viz change timer
  if (colHold) time[3] = millis()/1000;              // hold color change timer
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (keyP[' ']) animations.add(new Anim(rigViz, alphaSlider, funcSlider, rigDimmer));   // or space bar!
  if (keyP['x']) animations.add(new AllOn(alphaSlider, funcSlider, rigDimmer));
  //if (keyP['z']) animations.add(new CansOn(alphaSlider, funcSlider));

  if (cc[101] > 0) animations.add(new Anim(rigViz, cc[1], cc[2], cc[101])); // current animation
  if (cc[102] > 0) animations.add(new Anim(int(random(rigVizList)), cc[1], cc[2], cc[102])); // current animation
  //if (cc[103] > 0) animations.add(new Anim(8, cc[1], cc[2])); // current animation
  //if (cc[104] > 0) animations.add(new Anim(8, cc[1], cc[2])); // current animation

  //     animations.get(animations.size()-1).funcFX = cc[1];

  if (cc[107] > 0) animations.add(new AllOn(cc[107], funcSlider, cc[107]));
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
  if (cc[108] > 0) {
    //animations.add(new CansOn(cc[108], funcSlider));
    fill(rigColor.flash, 360*cc[108]);
    rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
    rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);
  }
  if (cc[104] > 0) {
    //animations.add(new CansOn(cc[108], funcSlider));
    fill(rigColor.c, 360*cc[104]);
    rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
    rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);
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
