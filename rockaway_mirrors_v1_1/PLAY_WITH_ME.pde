void playWithMe() {
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  float sat1, sat2;
  if (cc[101] > 0) {
    sat1 = map(cc[1], 0, 1, 40, 100);
    println(sat1);
  } else  sat1 = 100;
  if (cc[105] > 0) {
    sat2 = map(cc[5], 0, 1, 40, 100);
    println(sat2);
  } else  sat2 = 100;
  rig.col[rig.colorA] = color(hue(rig.col[rig.colorA]), sat1, brightness(rig.col[rig.colorB]));
  rig.col[rig.colorB] = color(hue(rig.col[rig.colorB]), sat2, brightness(rig.col[rig.colorB]));
  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['\\']) rig.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['\'']) rig.colFlip = (keyT['\'']);                  // COLOR FLIP TOGGLE 
  if (keyP[';']) rig.colFlip = !rig.colFlip;                   // COLOR FLIP MOMENTARY
  rig.colorFlip(rig.colFlip);
  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  if (keyT['o']) rig.c = lerpColor(rig.col[rig.colorB], rig.col[rig.colorA], beatFast);
  if (keyT['o']) rig.flash = lerpColor(rig.col[rig.colorA], rig.col[rig.colorB], beatFast);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyP['l']) colBeat = !colBeat;
  // lerpcolor function goes in here

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // shimmer function goes in here

  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) time[0] = millis()/1000;              // hold viz change timer
  if (colHold) time[3] = millis()/1000;              // hold color change timer
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

void colorControl(int colorSwitch) {
  switch(colorSwitch) {
  case 0:
    rig.c = red;
    rig.flash = bloo;
    break;
  case 1:
    rig.c = grin;
    rig.flash = red;
    break;
  case 2:
    rig.c = pink;
    rig.flash = grin;
    break;
  case 3:
    rig.c = orange;
    rig.flash = pink;
    break;
  case 4:
    rig.c = orange;
    rig.flash = teal;
    break;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
boolean button[] = new boolean [16];
void playWithMeMore() {

  if (button[0]) {
    cansControl(0, 1);  
    seedsControlC(0, 1);
  }
  if (button[1]) seedsControlA(0, 1);
  if (button[2]) rigControl(0, 1);
  if (button[3]) seedsControlB(0, 1);
  if (button[4]) controllerControl(0, 1);

  if (keyP['1']) cansControl(0, 1);  
  if (keyP['2']) seedsControlA(0, 1);
  if (keyP['3']) rigControl(0, 1);
  if (keyP['4']) seedsControlB(0, 1);
  if (keyP['5']) controllerControl(0, 1);

  if (keyP['7']) cansControl(roof.flash, stutter); 
  if (keyP['8']) seedsControlA(roof.flash, stutter);
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
