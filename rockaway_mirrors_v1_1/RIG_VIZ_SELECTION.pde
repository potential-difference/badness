int steps = 0;
int rigVizList = 11;
int roofVizList = 6;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// VIZ SELECTION and PREVIEW ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
void rigVizSelection(PGraphics subwindow, float dimmer) {
  // variables to use in the construction of each vis[n]
  float stroke, wide, high;
  col1 = color(white);
  col2 = color(white);
  size.viz.x = size.rig.x;
  size.viz.y = size.rig.y;
  size.vizWidth = size.rigWidth;
  size.vizHeight = size.rigHeight;
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////// VIZ SELECTION //////////////////////////////////////////////////////////////////////////

  switch (rigViz) {
  case 0: /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 300-(200*noize);
    wide = size.vizWidth+(50);
    high = wide;
    //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
    for (int i = 0; i <4; i++) squareNut(i, col1, stroke, wide-(wide*function[i]*(i+1)), high-(high*function[i]*(i+1)), alpha[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) {
      subwindow.image( blured[i], grid.mirror[5].x, grid.mirror[5].y);
      subwindow.image( blured[i], grid.mirror[6].x, grid.mirror[6].y);
    }
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 1:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //checkers(0, rig.c, rig.flash, bt*alf*dimmer); 
    subwindow.beginDraw();
    subwindow.background(0);
    int sequence = 9;
    if (beatCounter % sequence == 0) {
      subwindow.fill( rig.c, 360*bt*alf*dimmer);
      subwindow.rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[9].x, grid.mirror[9].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 1) {
      subwindow.fill( rig.flash, 360*bt1*alf*dimmer);
      subwindow.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth); 
      subwindow.rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 2) {
      subwindow.fill( rig.flash, 360*bt*alf*dimmer);
      subwindow.rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[9].x, grid.mirror[9].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
      ////////////////////////////////////////////////////////////////////////////////////////////
      subwindow.fill( rig.c, 360*bt1*alf*dimmer);
      subwindow.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth); 
      subwindow.rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
    }

    ///////////////////////////////////////////////////////////////////////////////////////
    //sequence = 6;
    if (beatCounter % sequence == 3) {
      subwindow.fill( rig.c, 360*bt1*alf*dimmer);
      subwindow.rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[9].x, grid.mirror[9].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 4) {
      subwindow.fill( rig.c, 360*bt*alf*dimmer);
      subwindow.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 5) {
      subwindow.fill( rig.c, 360*bt1*alf*dimmer);
      subwindow.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.fill( rig.flash, 360*bt*alf*dimmer);
      subwindow.rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[9].x, grid.mirror[9].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 6) {
      subwindow.fill( rig.flash, 360*bt1*alf*dimmer);
      subwindow.rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[9].x, grid.mirror[9].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 7) {
      subwindow.fill( rig.c, 360*bt*alf*dimmer);
      subwindow.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    if (beatCounter % sequence == 8) {
      subwindow.fill( rig.flash, 360*bt1*alf*dimmer);
      subwindow.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth);
      subwindow.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
    }
    sequence = 4;
    if (beatCounter % sequence == 0) {
      subwindow.fill(rig.flash, 360*bt1*alf*dimmer);
      subwindow.rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
      subwindow.rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
    }
    if (beatCounter % sequence == 1) {
      subwindow.fill(rig.c, 360*bt*alf*dimmer);
      subwindow.rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
      subwindow.rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
    }
    if (beatCounter % sequence == 2) {
      subwindow.fill(rig.c, 360*bt1*alf*dimmer);
      subwindow.rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
      subwindow.rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
    }
    if (beatCounter % sequence == 3) {
      subwindow.fill(rig.flash, 360*bt*alf*dimmer);
      subwindow.rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
      subwindow.rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
    }


    break;    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 2:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 20+(400*tweakSlider); 
    float reSize = (size.vizWidth*3)-(size.vizWidth/10);
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i+=2) {
      wide = 50+(reSize-(reSize*function[i])); 
      high = wide;
      donut(i, col1, stroke, wide, high, alpha[i]*alf*dimmer);

      reSize = (size.vizWidth/4)-(size.vizWidth/10);
      wide = 10+(reSize-(reSize*function1[i])); 
      high = wide;
      donut(i+4, col1, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    for (int i = 1; i < 4; i+=2) {
      wide = 50+(reSize-(reSize*function[i])); 
      high = wide;
      donut(i, col2, stroke, wide, high, alpha[i]*alf*dimmer);

      reSize = (size.vizWidth/4)-(size.vizWidth/10);
      wide = 10+(reSize-(reSize*function1[i])); 
      high = wide;
      donut(i+4, col2, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      for (int o = 0; o < 4; o++) {
        subwindow.image( blured[i], grid.mirror[o].x, grid.mirror[o].y);
      }
      for (int o = 8; o < 12; o++) {
        subwindow.image( blured[i], grid.mirror[o].x, grid.mirror[o].y);
      }
    }
    for (int i = 0; i < 4; i++) {
      for (int o = 4; o < 8; o++) {
        subwindow.image( blured[i+4], grid.mirror[o].x, grid.mirror[o].y);
      }
    }
    break;  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 3:   /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = size.vizWidth/8; 
    for (int i = 0; i <4; i++) {
      wide = (size.vizWidth*1.4);
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col2, stroke, wide-(wide*function[i]*(i+1)), high-(high*function[i]*(i+1)), alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0); 
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], grid.mirror[5].x, grid.mirror[5].y);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], grid.mirror[6].x, grid.mirror[6].y);
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 4:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i++) {
      stroke = 10+(30*function[i]);
      star(i, 10+(beats[i]*size.vizWidth), 110-(pulzs[i]*size.vizHeight), -60*beats[i], col1, stroke, alpha[i]/1.5*alf*dimmer);
      star(i+4, 10+(pulzs[i]*size.vizWidth), 110+(beats[i]*size.vizHeight), 60*pulzs[i], col1, stroke, alpha1[i]/1.5*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i=0; i<4; i++) {   
      subwindow.image(blured[i], grid.mirrorX[1][1].x, grid.mirrorX[1][1].y);
      subwindow.image(blured[i+4], grid.mirrorX[3][1].x, grid.mirrorX[3][1].y);
      subwindow.image(blured[i+4], grid.mirrorX[1][2].x, grid.mirrorX[1][2].y);
      subwindow.image(blured[i], grid.mirrorX[3][2].x, grid.mirrorX[3][2].y);
    }
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 5:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 50+(100*noize*func);
    //toggle.rect = true;
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    star(0, 10+(pulz*size.vizWidth*1.5), 10+(beat*size.vizHeight*1.5), -30*pulz*noize, col1, stroke, bt*alf*dimmer);
    star(1, 10+(pulz*size.vizWidth*1.5), 10+(beat*size.vizHeight*1.5), -30*pulz*noize2, col1, stroke, bt*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image(blured[0], grid.mirror[4].x, grid.mirror[4].y);
    subwindow.image(blured[1], grid.mirror[7].x, grid.mirror[7].y);
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 6:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i = 0; i < 4; i++) {
      stroke = 40+(80*oskP);
      wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function[i]));
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col1, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    for (int i = 0; i < 4; i++) {
      stroke = 40+(80*noize2);
      wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function1[i]));
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      squareNut(i+4, col1, stroke, wide, high, alpha1[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.mirror[0].x, grid.mirror[0].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.mirror[3].x, grid.mirror[3].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.mirror[8].x, grid.mirror[8].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.mirror[11].x, grid.mirror[11].y, size.vizWidth*2, size.vizHeight*2);

      subwindow.image( blured[i+4], grid.mirror[5].x, grid.mirror[5].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i+4], grid.mirror[6].x, grid.mirror[6].y, size.vizWidth*2, size.vizHeight*2);
    }
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 7:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i++) {
      stroke = 25+(100*function[i]);
      star(i, 10+(function[i]*size.vizWidth*2), 110-(function1[i]*size.vizHeight), 45*beats[i]*noize1, col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image(blured[i], size.rig.x-(size.vizWidth/2), size.rig.y-(size.vizHeight/2), size.vizWidth*2.5, size.vizHeight*2);
      subwindow.image(blured[i], size.rig.x+(size.vizWidth/2), size.rig.y+(size.vizHeight/2), size.vizWidth*2.5, size.vizHeight*2);
    }
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 8: /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 56+(43*noize*func);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    star(0, 10+(pulz*size.vizWidth), 10+(beats[0]*size.vizHeight), 120*pulzs[0], col1, stroke, alpha[0]*alf*dimmer);
    star(2, 10+(pulz*size.vizWidth), 10+(beats[2]*size.vizHeight), -120*pulzs[2], col1, stroke, alpha[2]*alf*dimmer);

    star(1, 10+(beats[1]*size.vizWidth), 10+(pulzs[1]*size.vizHeight), 120*beats[1], col1, stroke, alpha1[1]*alf*dimmer);
    star(3, 10+(beats[3]*size.vizWidth), 10+(pulzs[3]*size.vizHeight), -120*beats[3], col1, stroke, alpha1[3]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i+=2) {
      subwindow.image(blured[i], grid.mirror[1].x, grid.mirror[1].y);
      subwindow.image(blured[i], grid.mirror[5].x, grid.mirror[5].y);
      subwindow.image(blured[i], grid.mirror[9].x, grid.mirror[9].y);

      subwindow.image(blured[i], grid.mirror[2].x, grid.mirror[2].y);
      subwindow.image(blured[i], grid.mirror[6].x, grid.mirror[6].y);
      subwindow.image(blured[i], grid.mirror[10].x, grid.mirror[10].y);
    }
    for (int i = 1; i <4; i+=2) {
      subwindow.image(blured[i], grid.mirror[0].x, grid.mirror[0].y);
      subwindow.image(blured[i], grid.mirror[4].x, grid.mirror[4].y);
      subwindow.image(blured[i], grid.mirror[8].x, grid.mirror[8].y);

      subwindow.image(blured[i], grid.mirror[3].x, grid.mirror[3].y);
      subwindow.image(blured[i], grid.mirror[7].x, grid.mirror[7].y);
      subwindow.image(blured[i], grid.mirror[11].x, grid.mirror[11].y);
    }
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 9: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
    wide = 500+(noize*150);
    for (int i = 0; i < 4; i+=2) rush(i, col1, wide, size.vizHeight, function[i], alpha[0]*alf*dimmer);
    for (int i = 1; i < 4; i+=2) rush(i, col1, wide, size.vizHeight, 1-function[i], alpha[0]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) subwindow.image(vis[i], size.viz.x, size.viz.y);
    break;   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 10: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
    //wide = 800-(noize1*100*func);
    for (int i = 0; i < 4; i++) {
      wide = 800-(noize1*100*function[i]);
      rush(i, col1, wide, grid.mirrorAndGap, function[i], alpha[0]*alf*dimmer);
      rush(i+4, col1, wide, grid.mirrorAndGap, 1-function[i], alpha[0]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image(vis[i+4], size.viz.x+(size.vizWidth/2+grid.dist), grid.mirror[0].y);
      subwindow.image(vis[i], size.viz.x-(size.vizWidth/2+grid.dist), grid.mirror[0].y);

      subwindow.image(vis[i+4], size.viz.x-(size.vizWidth/2+grid.dist), size.viz.y);
      subwindow.image(vis[i], size.viz.x+(size.vizWidth/2+grid.dist), size.viz.y);

      subwindow.image(vis[i+4], size.viz.x+(size.vizWidth/2+grid.dist), grid.mirror[8].y);
      subwindow.image(vis[i], size.viz.x-(size.vizWidth/2+grid.dist), grid.mirror[8].y);
    }
    break;
  }
  subwindow.blendMode(NORMAL);
  subwindow.noStroke();
  ////////////////////////////////////////////////////////////////  CONTROLLERS ON A BIT /////////////////////////////////////
  subwindow.fill(col1, (0.6+(0.4*noize1))*controllerDimmer*360);
  if (rigViz == 1) subwindow.fill(rig.flash, (0.6+(0.8*noize2))*controllerDimmer*360);
  subwindow.rect(grid.controller[0].x, grid.controller[0].y, grid.controllerWidth, grid.controllerWidth);
  subwindow.rect(grid.controller[3].x, grid.controller[3].y, grid.controllerWidth, grid.controllerWidth);
  subwindow.fill(col1, (0.6+(0.4*noize12))*controllerDimmer*360);
  if (rigViz == 1) subwindow.fill(rig.c, (0.6+(0.4*noize12))*controllerDimmer*360);
  subwindow.rect(grid.controller[1].x, grid.controller[1].y, grid.controllerWidth, grid.controllerWidth);
  subwindow.rect(grid.controller[2].x, grid.controller[2].y, grid.controllerWidth, grid.controllerWidth);

  ////////////////////////////////////////////////////////////////  SEEDS ON A BIT /////////////////////////////////////
  subwindow.fill(col1, (0.6+(0.8*noize2))*seed2Dimmer*360);
  if (rigViz == 1) subwindow.fill(rig.flash, (0.6+(0.8*noize2))*seed2Dimmer*360);
  subwindow.rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
  subwindow.rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
  subwindow.endDraw();
  ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
