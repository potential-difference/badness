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

  size.viz.x = size.rigWidth/2;
  size.viz.y = size.rigHeight/2;
  size.vizWidth = size.rigWidth;
  size.vizHeight = size.rigHeight;
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////// VIZ SELECTION //////////////////////////////////////////////////////////////////////////
  blendMode(NORMAL);
  if (viz == 0) {
    stroke = 90-(85*pulzSlow);
    wide = size.vizWidth+(50);
    high = wide;
    //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
    for (int i = 0; i <4; i++) donut(i, col1, stroke, wide-(wide*function[i]*(i+1)), high-(high*function[i]*(i+1)), alpha[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
  }
  if (viz == 1) {
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
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 2) {
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      stroke = 30+(10*func1);
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
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 3) {
    stroke = 20+(400*tweakSlider);//14+(20*oskP);
    float reSize = (size.vizWidth*3)-(size.vizWidth/10);
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i+=2) {
      wide = 50+(reSize-(reSize*function[i])); //100+(20*i); //
      high = wide;
      donutRotate(i, col1, stroke, wide, high, 45, alpha[i]*alf*dimmer);

      reSize = (mw/4)-(mw/10);
      wide = 10+(reSize-(reSize*function1[i])); //100+(20*i); //
      high = wide;
      donut(i+4, col1, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    for (int i = 1; i < 4; i+=2) {
      wide = 50+(reSize-(reSize*function[i])); //100+(20*i); //
      high = wide;
      donut(i, col2, stroke, wide, high, alpha[i]*alf*dimmer);

      reSize = (mw/4)-(mw/10);
      wide = 10+(reSize-(reSize*function1[i])); //100+(20*i); //
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
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 4) {
    stroke = mw/12; //16+(10*func1);
    for (int i = 0; i <4; i++) {
      wide = (size.vizWidth*1.2*function[i]);
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col2, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0); 
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], mx, my);
    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 5) {
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i++) {
      stroke = 15+(10*function[i]);
    star(i, 10+(beats[i]*size.vizWidth), 110-(pulzs[i]*size.vizHeight), -60*beats[i], col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i=0; i<4; i++) {   
      subwindow.image(blured[i], size.viz.x,size.viz.y);
    }

    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 6) {
    stroke = 90+(50*noize*pulz);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    star(0, 10+(pulz*size.vizWidth), 10+(beat*size.vizHeight), -30*pulz, col1, stroke, bt/4*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(NORMAL);
    subwindow.image(blured[0], size.viz.x,size.viz.y);
    subwindow.endDraw();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 7) {
    for (int i = 0; i < 4; i++) {
      stroke = 20+(50*oskP);
      wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function[i]));
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col1, stroke, wide,high, alpha[i]*alf*dimmer);
    }

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.mirror[0].x, grid.mirror[0].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.mirror[3].x, grid.mirror[3].y, size.vizWidth*2, size.vizHeight*2);

      subwindow.image( blured[i], grid.mirror[8].x, grid.mirror[8].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.mirror[11].x, grid.mirror[11].y, size.vizWidth*2, size.vizHeight*2);
    }
    subwindow.endDraw();
  }


  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 8) {
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
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (viz == 9) {
    stroke = 25+(25*noize*func);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i+=2)  star(i, 10+(pulz*size.vizWidth), 10+(beat*size.vizHeight), -30*pulz, col1, stroke, alpha[i]*alf*dimmer);
    for (int i=1; i<4; i+=2)  star(i, 10+(pulz*size.vizWidth), 10+(beat*size.vizHeight), -30*pulz, col1, stroke, alpha[i]/4*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);

    for (int i = 0; i <4; i+=2) {
      subwindow.image(blured[i], grid.mirror[1].x, grid.mirror[1].y);
      subwindow.image(blured[i], grid.mirror[3].x, grid.mirror[3].y);
      subwindow.image(blured[i], grid.mirror[5].x, grid.mirror[5].y);

      subwindow.image(blured[i], grid.mirror[7].x, grid.mirror[7].y);
      subwindow.image(blured[i], grid.mirror[9].x, grid.mirror[9].y);
      subwindow.image(blured[i], grid.mirror[11].x, grid.mirror[11].y);
    }
    for (int i = 1; i <4; i+=2) {
      subwindow.image(blured[i], grid.mirror[0].x, grid.mirror[0].y);
      subwindow.image(blured[i], grid.mirror[4].x, grid.mirror[4].y);
      subwindow.image(blured[i], grid.mirror[8].x, grid.mirror[8].y);

      subwindow.image(blured[i], grid.mirror[2].x, grid.mirror[2].y);
      subwindow.image(blured[i], grid.mirror[6].x, grid.mirror[6].y);
      subwindow.image(blured[i], grid.mirror[10].x, grid.mirror[10].y);
    }
    //subwindow.image(blured[0], mx, my);

    subwindow.endDraw();
  }

  ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////// END OF PLAYWITHYOURSELF /////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////
}
