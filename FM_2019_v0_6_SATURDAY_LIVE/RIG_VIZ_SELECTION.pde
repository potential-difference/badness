
int steps = 0; // remove

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

  switch(viz) {
  case 0: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    pulse(4, col1,col2, 1*alf*dimmer); ///((0.6)+bt*alf)*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.image(blured[4], size.viz.x, size.viz.y);
    subwindow.noTint();
    subwindow.endDraw();

    stroke = 90-(85*pulzSlow);
    wide = grid.bigShieldRad/2; //wide-(wide*function[i]*(i+1))
    high = wide; 
    //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
    for (int i = 0; i <4; i++) donut(i, col1, stroke, wide-(wide*function[i]), high-(high*function[i]), alpha[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 1: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i = 0; i < 4; i++) {
      stroke = 20;
      wide = 10+(size.rigWidth-(size.rigWidth*function[i]));
      high = wide;
      // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
      star(i, 10+(pulz*wide), 10+(beat*high), -30*pulz, col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.shield[0][1].x, grid.shield[0][1].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.shield[4][1].x, grid.shield[4][1].y, size.vizWidth*2, size.vizHeight*2);
      subwindow.image( blured[i], grid.shield[8][1].x, grid.shield[8][1].y, size.vizWidth*2, size.vizHeight*2);
    }
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 2: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      stroke = 10+(size.rigWidth/10*0.2); //16+(10*func1);
      wide = 10+(size.rigWidth-(size.rigWidth*function[i]-20));
      high = wide;
      donut(i, col1, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.shield[2][0].x, grid.shield[2][0].y);
      subwindow.image( blured[i], grid.shield[6][0].x, grid.shield[6][0].y);
      subwindow.image( blured[i], grid.shield[10][0].x, grid.shield[10][0].y);
    }
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 3: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 20;//14+(20*oskP);
    wide = size.rigWidth+50; //wide-(wide*function[i]*(i+1))

    // donut(int n, color col, float stroke, float wide, float high, float alph) {
    for (int i = 0; i < 4; i++) {
      wide = size.rigWidth+40; //wide-(wide*function[i]*(i+1))
      high = wide;
      donut(i, col1, stroke, wide-(wide*function[i]*(i+1)), high-(high*function[i]*(i+1)), alpha[i]*alf*dimmer);

      //   reSize = (size.rigWidth/4)-(size.rigWidth/10);
      //wide = 10+(reSize-(reSize*function1[i])); 
      wide = size.rigWidth+10; //wide-(wide*function[i]*(i+1))
      high = wide; //size.rigWidth+10;
      //wide = high/4; //wide-(wide*function[i]*(i+1))

      stroke = 30;

      donut(i+4, col1, stroke, wide-(wide*function1[i]*(i+1)), high-(high*function1[i]*(i+1)), alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], grid.shield[0][0].x, grid.shield[0][0].y);
      subwindow.image( blured[i], grid.shield[4][0].x, grid.shield[4][0].y);
      subwindow.image( blured[i], grid.shield[8][0].x, grid.shield[8][0].y);

      subwindow.image( blured[i+4], grid.shield[0][1].x, grid.shield[0][1].y);
      subwindow.image( blured[i+4], grid.shield[4][1].x, grid.shield[4][1].y);
      subwindow.image( blured[i+4], grid.shield[8][1].x, grid.shield[8][1].y);

      subwindow.image( blured[i+4], size.viz.x, size.viz.y);
    }
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 4: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = size.rigWidth/12; //16+(10*func1);
    for (int i = 0; i <4; i++) {
      wide = 15+((size.rigWidth+20)*function[i]);
      high = wide;
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col2, stroke, wide, high, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0); 
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 5: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i+=2) {
      stroke = 10+(80*function[i]);
      wide = 10+(beats[i]*(size.rigWidth+40));
      high = 110-(pulzs[i]*(size.rigHeight+40));
      star(i, wide, high, -60*beats[i]+60, col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image(blured[0], size.viz.x, size.viz.y);
    //subwindow.image(blured[1], size.rig.x, size.rig.y);
    subwindow.image(blured[2], size.viz.x, size.viz.y);
    //subwindow.image(blured[3], size.rig.x, size.rig.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 6: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 50+(50*noize*pulz);
    for (int i=0; i<4; i++) {
      // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
      star(i, 10+(pulzs[i]*size.rigWidth), 10+(beats[i]*size.rigHeight), -120*function[i], col1, stroke, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(NORMAL);
    for (int i=0; i<4; i++) subwindow.image(blured[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 7: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (beatCounter%16<8)  steps = (1+int(beat*4))%4;
    else steps = 3-int(beatCounter%4);
    float bt0 = (0.4*pulz)+(0.3*noize1)+(0.2*stutter); /// special fill for balls
    speed = beat;
    // spin(int n, float rad, float func, float rotate, float alph) {
    spin(0, grid.medShieldRad, pulz, speed, bt1*alf*dimmer);
    spin(1, grid.smallShieldRad, pulz, speed, bt*alf*dimmer);
    spin(2, grid.bigShieldRad, beat, -speed, bt*alf*dimmer);
    spin(3, 10, pulz, 1.5, bt*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image( blured[0], grid.medShield[2].x, grid.medShield[2].y);
    subwindow.image( blured[0], grid.medShield[6].x, grid.medShield[6].y);
    subwindow.image( blured[0], grid.medShield[10].x, grid.medShield[10].y);

    subwindow.image( blured[1], grid.smallShield[2].x, grid.smallShield[2].y);
    subwindow.image( blured[1], grid.smallShield[6].x, grid.smallShield[6].y);
    subwindow.image( blured[1], grid.smallShield[10].x, grid.smallShield[10].y);

    subwindow.fill(360*bt0*alf*dimmer);
    subwindow.ellipse(grid.ball[0].x, grid.ball[0].y, 10, 10);
    subwindow.ellipse(grid.ball[4].x, grid.ball[4].y, 10, 10);
    subwindow.ellipse(grid.ball[8].x, grid.ball[8].y, 10, 10);

    subwindow.fill(360*bt0*pulz*alf*dimmer);
    subwindow.ellipse( grid.shield[2][0].x, grid.shield[2][0].y, 40, 40);
    subwindow.ellipse( grid.shield[6][0].x, grid.shield[6][0].y, 40, 40);
    subwindow.ellipse( grid.shield[10][0].x, grid.shield[10][0].y, 40, 40);

    subwindow.ellipse( grid.shield[2][1].x, grid.shield[2][1].y, 40, 40);
    subwindow.ellipse( grid.shield[6][1].x, grid.shield[6][1].y, 40, 40);
    subwindow.ellipse( grid.shield[10][1].x, grid.shield[10][1].y, 40, 40);

    subwindow.image( blured[2], size.viz.x, size.viz.y);
    subwindow.image( blured[3], size.viz.x, size.viz.y);

    bt0 = (0.4*pulzSlow)+(0.3*noize1); /// special fill for balls
    subwindow.fill(360*bt0*alf*dimmer);

    if (steps <2 ) //subwindow.ellipse( size.rig.x, size.rig.y, grid.bigShieldRad-20, grid.bigShieldRad-20);     // fill big shield HP LEDS
      if (steps >=2) {
        subwindow.ellipse(grid.ball[0].x, grid.ball[0].y, 30, 30);
        subwindow.ellipse(grid.ball[4].x, grid.ball[4].y, 30, 30);
        subwindow.ellipse(grid.ball[8].x, grid.ball[8].y, 30, 30);
      }
    subwindow.endDraw();
    break; 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 8: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 20+(100*oskP);
    wide = 10+((size.rigWidth-60)-((size.rigWidth-60)*func));
    high = wide;
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    donut(0, col1, stroke, wide, high, bt*alf*dimmer);
    wide = 2+(size.rigWidth/5-(size.rigWidth/5*func));
    high = wide;
    donut(1, col2, stroke, wide, high, bt1*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image( blured[0], grid.shield[2][1].x, grid.shield[2][1].y);
    subwindow.image( blured[0], grid.shield[6][1].x, grid.shield[6][1].y);
    subwindow.image( blured[0], grid.shield[10][1].x, grid.shield[10][1].y);

    subwindow.image( blured[0], grid.shield[0][2].x, grid.shield[0][2].y);
    subwindow.image( blured[0], grid.shield[4][2].x, grid.shield[4][2].y);
    subwindow.image( blured[0], grid.shield[8][2].x, grid.shield[8][2].y);

    subwindow.image( blured[1], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 9: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    stroke = 90-(85*pulzSlow);
    wide = size.rigWidth+50; //wide-(wide*function[i]*(i+1))
    high = wide; 
    //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
    for (int i = 0; i <4; i++) donut(i, col1, stroke, wide-(wide*function[i]*(i+1)), high-(high*function[i]*(i+1)), alpha[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  case 10: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // lockIt(int n, float func, float func1, float alph) {
    for (int i = 0; i <2; i++) lockIt(i, function[i], function1[i], alpha[i]*alf*dimmer, alpha1[i]*alf*dimmer);
    for (int i = 2; i <4; i++) lockIt(i, function[i], -function1[i], alpha1[i]*alf*dimmer, alpha1[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image(vis[i], size.viz.x, size.viz.y);
    subwindow.endDraw();
    break;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  subwindow.beginDraw();
  subwindow.blendMode(NORMAL);
  subwindow.endDraw();
  ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////// END OF PLAYWITHYOURSELF /////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////
}
