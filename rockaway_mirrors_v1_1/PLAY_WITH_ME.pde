void playWithMe() {
  float base = 0.4;
  float top = stutter*0.1;
  blendMode(NORMAL);

  color col1a = c;
  color col2a = flash;

  if (keyT[42]) {
    col1a = 0;
    col2a = 0;
    base = 1;
    top = 1;
  }
}

void colorControl(int colorSwitch) {
  switch(colorSwitch) {
  case 0:
    c = red;
    flash = bloo;
    break;
  case 1:
    c = grin;
    flash = red;
    break;
  case 2:
    c = pink;
    flash = grin;
    break;
  case 3:
    c = orange;
    flash = pink;
    break;
  case 4:
    c = orange;
    flash = teal;
    break;
  }
}

//PGraphics vis[] = new PGraphics[11];

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

  if (keyP[49]) cansControl(0, 1);  
  if (keyP[50]) seedsControlA(0, 1);
  if (keyP[51]) rigControl(0, 1);
  if (keyP[52]) seedsControlB(0, 1);
  if (keyP[53]) controllerControl(0, 1);

  if (keyP[55]) cansControl(flash, stutter); 
  if (keyP[56]) seedsControlA(flash, stutter);
  if (keyP[57]) colorSwap(0.9999999);
}

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
