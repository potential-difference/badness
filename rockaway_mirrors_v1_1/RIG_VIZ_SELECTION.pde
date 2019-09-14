int steps = 0;
int rigVizList = 10;

int roofVizList = 6;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// VIZ SELECTION and PREVIEW ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
void rigVizSelection(PGraphics subwindow, int viz, float dimmer) {
  // variables to use in the construction of each vis[n]
  float stroke, wide, high, speed;
  col1 = color(white);
  col2 = color(white);

  size.viz.x = size.rig.x;
  size.viz.y = size.rig.y;
  size.vizWidth = size.rigWidth;
  size.vizHeight = size.rigHeight;
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////// VIZ SELECTION //////////////////////////////////////////////////////////////////////////
  blendMode(NORMAL);
  toggle.rect = true;
  switch (viz) {
  case 0: /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 180-(200*noize);
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
    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 1:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      stroke = 50+(30*oskP);
      wide = size.vizWidth;
      high = size.vizHeight; //10+(wide-(wide*function[i])); //100+(20*i); //
      // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
      star(i, 10+(pulz*wide), 10+(beat*high), -30*pulz, col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth*2, size.vizWidth*2);
      subwindow.image( blured[i], grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth*2, size.vizWidth*2);
      subwindow.image( blured[i], grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth*2, size.vizWidth*2);
      subwindow.image( blured[i], grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth*2, size.vizWidth*2);
    }
    subwindow.endDraw();
    break;    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 2:     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      stroke = 30+(10*function1[i]);
      wide = 10+(size.vizWidth-(grid.mirrorWidth*function[i]-20));
      high = wide * 3;
      donut(i, col1, stroke, wide, high, alpha[i]*alf*dimmer);
    }

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.mirror[4].x, grid.mirror[4].y);
      subwindow.image( blured[i], grid.mirror[5].x, grid.mirror[5].y);
      subwindow.image( blured[i], grid.mirror[6].x, grid.mirror[6].y);
      subwindow.image( blured[i], grid.mirror[7].x, grid.mirror[7].y);
    }
    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 3:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

    subwindow.endDraw();
    break;  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 4:   /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = size.vizWidth/12; 
    for (int i = 0; i <4; i++) {
      wide = (size.vizWidth*1.2*function[i]);
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col2, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0); 
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], grid.mirror[5].x, grid.mirror[5].y);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], grid.mirror[6].x, grid.mirror[6].y);

    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 5:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i++) {
      stroke = 15+(10*function[i]);
      star(i, 10+(beats[i]*size.vizWidth), 110-(pulzs[i]*size.vizHeight), -60*beats[i], col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i=0; i<4; i++) {   
      subwindow.image(blured[i], grid.mirrorX[1][1].x, grid.mirrorX[1][1].y);
      subwindow.image(blured[i], grid.mirrorX[3][1].x, grid.mirrorX[3][1].y);
      subwindow.image(blured[i], grid.mirrorX[1][2].x, grid.mirrorX[1][2].y);
      subwindow.image(blured[i], grid.mirrorX[3][2].x, grid.mirrorX[3][2].y);
    }

    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 6:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 50+(100*noize*func);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    star(0, 10+(pulz*size.vizWidth*1.5), 10+(beat*size.vizHeight*1.5), -30*pulz*noize, col1, stroke, bt*alf*dimmer);
    star(1, 10+(pulz*size.vizWidth*1.5), 10+(beat*size.vizHeight*1.5), -30*pulz*noize2, col1, stroke, bt*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image(blured[0], grid.mirror[5].x, grid.mirror[5].y);
    subwindow.image(blured[1], grid.mirror[6].x, grid.mirror[6].y);

    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 7:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i = 0; i < 4; i++) {
      stroke = 20+(50*oskP);
      wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function[i]));
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col1, stroke, wide, high, alpha[i]*alf*dimmer);
    }

    for (int i = 0; i < 4; i++) {
      stroke = 20+(50*oskP);
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
    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 8:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i++) {
      stroke = 25+(50*function[i]);
      star(i, 10+(beats[i]*size.vizWidth*2), 110-(pulzs[i]*size.vizHeight), 60*beats[i], col1, stroke, alpha[i]/2*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image(blured[i], size.rig.x-(size.vizWidth/2), size.rig.y-(size.vizHeight/2), size.vizWidth*2.5, size.vizHeight*2);
      subwindow.image(blured[i], size.rig.x+(size.vizWidth/2), size.rig.y+(size.vizHeight/2), size.vizWidth*2.5, size.vizHeight*2);
    }
    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 9: /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 25+(25*noize*func);
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
    subwindow.endDraw();
    break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 10: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
    wide = 500+(noize*150);
    for (int i = 0; i < 4; i+=2) rush(i, col1, wide, size.vizHeight, function[i], alpha[i]);
    for (int i = 1; i < 4; i+=2) rush(i, col1, wide, size.vizHeight, 1-function[i], alpha[i]);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) subwindow.image(vis[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 11: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
    wide = 800-(noize1*100*func);
    for (int i = 0; i < 4; i++) {
      wide = 800-(noize1*100*function[i]);
      rush(i, col1, wide, grid.mirrorWidth, function[i], alpha[i]);
      rush(i+4, col1, wide, grid.mirrorWidth, 1-function[i], alpha[i]);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image(vis[i], size.viz.x-(size.vizWidth/2)+(grid.mirrorAndGap/2), grid.mirror[0].y);
      subwindow.image(vis[i+4], size.viz.x+(size.vizWidth/2)+(grid.mirrorAndGap/2), grid.mirror[0].y);

      subwindow.image(vis[i], size.viz.x+(size.vizWidth/2)+(grid.mirrorAndGap/2), size.viz.y);
      subwindow.image(vis[i+4], size.viz.x-(size.vizWidth/2)+(grid.mirrorAndGap/2), size.viz.y);

      subwindow.image(vis[i], size.viz.x-(size.vizWidth/2)+(grid.mirrorAndGap/2), grid.mirror[8].y);
      subwindow.image(vis[i+4], size.viz.x+(size.vizWidth/2)+(grid.mirrorAndGap/2), grid.mirror[8].y);
    }
    subwindow.endDraw();
    break;
  }


  ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
