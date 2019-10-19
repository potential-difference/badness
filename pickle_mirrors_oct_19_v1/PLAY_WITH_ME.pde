void playWithMe() {
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //float sat1, sat2;
  //if (OscAddrMap.get("/throttle_box/throttle_button_1") == 127) {
  //  sat1 = map(OscAddrMap.get("/throttle_box/throttle"), 64, 127, 100, 20);
  //  println(sat1);
  //} else {
  //  sat1 = 100;
  //  sat2 = 100;
  //}
  //sat1 = map(cc[1], 0, 1, 20, 100);
  //sat2 = map(cc[2], 0, 1, 20, 100);
  //rig.col[rig.colorA] = color(hue(rig.col[rig.colorA]), sat1, brightness(rig.col[rig.colorB]));
  //rig.col[rig.colorB] = color(hue(rig.col[rig.colorB]), sat1, brightness(rig.col[rig.colorB]));
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['\\'] || cc[101] > 0 ) rig.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['\'']) rig.colFlip = (keyT['\'']);                  // COLOR FLIP TOGGLE 
  if (keyP[';']) rig.colFlip = !rig.colFlip;                   // COLOR FLIP MOMENTARY
  rig.colorFlip(rig.colFlip);
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

  if (keyP[' '])  animations.add(new Anim( rigViz, alphaSlider, funcSlider));   // or space bar!
  if (keyP['x'])  animations.add(new AllOn(alphaSlider, funcSlider));
  //if (keyP['d'])  animations.add(new Anim(1));

  if (cc[101] > 0) animations.add(new Anim(rigViz,cc[1],cc[2])); // current animation
  if (cc[102] > 0) animations.add(new Anim(int(random(rigVizList)),cc[1],cc[2])); // current animation
  if (cc[103] > 0) animations.add(new Anim(3,cc[1],cc[2])); // current animation
  if (cc[104] > 0) animations.add(new Anim(8,cc[1],cc[2])); // current animation

  //     animations.get(animations.size()-1).funcFX = cc[1];

  if (cc[107] > 0) animations.add(new AllOn(cc[107], funcSlider));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {
  if (keyP['1']) cansControl(0, 0);  
  if (keyP['2']) seedsControlA(0, 0);
  if (keyP['3']) rigControl(0, 0);
  if (keyP['4']) seedsControlB(0, 0);
  if (keyP['5']) controllerControl(0, 0);

  if (keyP['7']) cansControl(roof.flash, stutter); 
  if (keyP['8']) seedsControlA(roof.flash, stutter);


  //if (cc[102]>0) rigControl(0, 1); 
  //if (cc[103]>0) seedsControlA(0, 1);
  //if (cc[103]>0) seedsControlB(0, 1);

  //if (cc[104]>0) controllerControl(0, 1);

  //  if (cc[106]>0) rigControl(rig.flash, stutter*cc[106]); 
  //  if (cc[107]>0) seedsControlA(rig.c, stutter*cc[107]);
  //  if (cc[107]>0) seedsControlB(rig.c, stutter*cc[107]);

  //if (cc[108]>0) controllerControl(rig.flash, stutter*cc[108]);



  /////background noise over whole window/////
  if (cc[105] > 0) {
    rigColourLayer.beginDraw();
    rigColourLayer.background(0, 0, 0, 0);
    rigColourLayer.endDraw();
    bgNoise(rigColourLayer, rig.flash, map(cc[105], 0, 1, 0.2, 1), cc[5]);   //PGraphics layer,color,alpha
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
