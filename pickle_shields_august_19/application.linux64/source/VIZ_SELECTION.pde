PGraphics vizDisplay(PGraphics subwindow, int index) {
  subwindow.beginDraw();
  subwindow.background(0);
  subwindow.image(vizPreview[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);   
  subwindow.noTint();
  subwindow.endDraw();

  return subwindow;
}
int steps = 0;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// VIZ SELECTION and PREVIEW ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
void vizSelection(PGraphics subwindow, int viz, float dimmer) {

  println("viz "+viz);

  // variables to use in the construction of each vis[n]
  float stroke, wide, high, size, speed;
  col1 = color(white);
  col2 = color(white);
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////// VIZ SELECTION //////////////////////////////////////////////////////////////////////////
  blendMode(NORMAL);
  if (viz == 0) {
    blury *= 2;
    /////////////////////////////// make brighter //////////////////////////////
    pulse(4, c, flash, 1); ///((0.6)+bt*alf)*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.tint(360, (360*(0.6)+bt*alf)*dimmer);
    subwindow.image(blured[4], mx, my);
    subwindow.noTint();
    subwindow.endDraw();
  }
  /////////////////////////////////////////////// FLOWER OF LIFE ////////////////////////////////////////////////////////////
  if (viz == 1) {
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      stroke = 20;//14+(20*oskP);
      wide = 50;
      size = 10+(wide-(wide*function[i])); //100+(20*i); //
      // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
      star(i, 10+(pulz*mw), 10+(beat*mh), -30*pulz, col1, stroke, alpha[i]*alf*dimmer);

      //flowerOfLife(i, col1, stroke, size, size, alpha[i]*alf*dimmer, alpha1[i]*alf*dimmer);
      //donut(i+4, col1, stroke, size, size, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], shldP[2][1].x, shldP[2][1].y, mw*2, mh*2);
      subwindow.image( blured[i], shldP[5][1].x, shldP[5][1].y, mw*2, mh*2);
      subwindow.image( blured[i], shldP[8][1].x, shldP[8][1].y, mw*2, mh*2);

      //subwindow.image( blured[i+4], mx, my);
    }

    //subwindow.beginDraw();
    //  subwindow.background(0);
    //  subwindow.blendMode(LIGHTEST);
    //  subwindow.image( blured[0], ballP[0].x, ballP[0].y, mw, mh);
    //  subwindow.image( blured[0], ballP[3].x, ballP[3].y, mw, mh);
    //  subwindow.image( blured[0], ballP[6].x, ballP[6].y, mw, mh);
    //  subwindow.endDraw();

    subwindow.endDraw();
  }
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if (viz == 2) {
   // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
   for (int i = 0; i < 4; i++) {
   stroke = 10+(mw/10*0.2); //16+(10*func1);
   size = 10+(mw-(mw*function[i]-20));
   donut(i, col1, stroke, size, size, alpha[i]*alf*dimmer);
   }
   
   subwindow.beginDraw();
   subwindow.background(0);
   subwindow.blendMode(LIGHTEST);
   for (int i = 0; i < 4; i++) {
   subwindow.image( blured[i], shldP[2][0].x, shldP[2][0].y);
   subwindow.image( blured[i], shldP[5][0].x, shldP[5][0].y);
   subwindow.image( blured[i], shldP[8][0].x, shldP[8][0].y);
   }
   subwindow.endDraw();
   }
   
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 3) {
    stroke = 20;//14+(20*oskP);
    wide = (mw)-(mw/10);
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      size = 5+(wide-(wide*function[i])); //100+(20*i); //
      donut(i, col1, stroke, size, size, alpha[i]*alf*dimmer);

      wide = (mw/4)-(mw/10);
      size = 10+(wide-(wide*function1[i])); //100+(20*i); //
      donut(i+4, col1, stroke, size, size, alpha[i]*alf*dimmer);
    }

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], shld[0][2].x, shld[0][2].y);
      subwindow.image( blured[i], shld[2][2].x, shld[2][2].y);
      subwindow.image( blured[i], shld[4][2].x, shld[4][2].y);


      subwindow.image( blured[i], shldP[1][1].x, shldP[1][1].y);
      subwindow.image( blured[i], shldP[4][1].x, shldP[4][1].y);
      subwindow.image( blured[i], shldP[7][1].x, shldP[7][1].y);

      subwindow.image( blured[i+4], mx, my);
    }
    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 4) {
    stroke = mw/12; //16+(10*func1);
    for (int i = 0; i <4; i++) {
      size = 15+(mw*function[i]);
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col2, stroke, size, size, alpha[i]*alf*dimmer);
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
      stroke = 50+(50*noize*function[i]);
      star(i, 10+(beats[i]*mw), 110-(pulzs[i]*mh), -60*beats[i], col1, stroke, alpha[i]/4*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image(blured[0], mx, my);
    subwindow.image(blured[1], mx, my);
    subwindow.image(blured[2], mx, my);
    subwindow.image(blured[3], mx, my);

    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 6) {
    stroke = 50+(50*noize*pulz);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    star(0, 10+(pulz*mw), 10+(beat*mh), -30*pulz, col1, stroke, bt/4*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(NORMAL);
    subwindow.image(blured[0], mx, my);
    subwindow.endDraw();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 7) {
    if (beatCounter%16<8)  steps = (1+int(beat*4))%4;
    else steps = 3-int(beatCounter%4);
    float bt0 = (0.4*pulz)+(0.3*noize1)+(0.2*stutter); /// special fill for balls
    speed = beat;
    // spin(int n, float rad, float func, float rotate, float alph) {
    spin(0, medShieldRad, pulz, speed, bt1*alf*dimmer);
    spin(1, smallShieldRad, pulz, speed, bt*alf*dimmer);
    spin(2, bigShieldRad, pulz, -speed, bt*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image( blured[0], mShdP[0].x, mShdP[0].y);
    subwindow.image( blured[0], mShdP[3].x, mShdP[3].y);
    subwindow.image( blured[0], mShdP[6].x, mShdP[6].y);

    subwindow.image( blured[1], sShdP[2].x, sShdP[2].y);
    subwindow.image( blured[1], sShdP[5].x, sShdP[5].y);
    subwindow.image( blured[1], sShdP[8].x, sShdP[8].y);

    subwindow.fill(360*bt0*alf*dimmer);
    subwindow.ellipse(ballP[1].x, ballP[1].y, 10, 10);
    subwindow.ellipse(ballP[4].x, ballP[4].y, 10, 10);
    subwindow.ellipse(ballP[7].x, ballP[7].y, 10, 10);

    subwindow.image( blured[2], mx, my);

    bt0 = (0.4*pulzSlow)+(0.3*noize1); /// special fill for balls
    subwindow.fill(360*bt0*alf*dimmer);

    if (steps <2 ) subwindow.ellipse(mx, my, 30, 30);
    if (steps >=2) {
      subwindow.ellipse(ballP[1].x, ballP[1].y, 30, 30);
      subwindow.ellipse(ballP[4].x, ballP[4].y, 30, 30);
      subwindow.ellipse(ballP[7].x, ballP[7].y, 30, 30);
    }
    //if (steps < 3) {
    //  subwindow.ellipse(shldP[(7+steps)%9][(2-steps)%3].x, shldP[(7+steps)%9][(2-steps)%3].y, 30, 30);
    //  subwindow.ellipse(shldP[(4+steps)%9][(2-steps)%3].x, shldP[(4+steps)%9][(2-steps)%3].y, 30, 30);
    //  subwindow.ellipse(shldP[(1+steps)%9][(2-steps)%3].x, shldP[(1+steps)%9][(2-steps)%3].y, 30, 30);
    //}
    //println(steps);  


    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 8) {
    //steps = 9;
    //swap = int(func1*steps);
    //if (cc[103]>0) swap = int(millis()/50*chng); /// first pad button controls change - speed altered by first knob
    //int mod = (swap % steps + steps) % steps; /// code to always produce a positive number to allow reverse wrap around
    stroke = 20+(50*oskP);
    size = 10+((mw-60)-((mw-60)*func));
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    donut(0, col1, stroke, size, size, bt*alf*dimmer);
    size = 2+(mw/5-(mw/5*func));
    donut(1, col2, stroke, size, size, bt1*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image( blured[0], mShdP[0].x, mShdP[0].y);
    subwindow.image( blured[0], mShdP[3].x, mShdP[3].y);
    subwindow.image( blured[0], mShdP[6].x, mShdP[6].y);

    subwindow.image( blured[0], ballP[1].x, ballP[1].y);
    subwindow.image( blured[0], ballP[4].x, ballP[4].y);
    subwindow.image( blured[0], ballP[7].x, ballP[7].y);

    subwindow.image( blured[1], mx, my);
    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////
  if (viz == 9) {
    stroke = 90-(85*pulzSlow);
    size = mw+(50);
    //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
    for (int i = 0; i <4; i++) donut(i, col1, stroke, size-(size*function[i]*(i+1)), size-(size*function[i]*(i+1)), alpha[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], mx, my);
    subwindow.endDraw();
  }
  ////////////////////////////////////////////////////////// LOCK ///////////////////////////
  if (viz == 10) {
    // lockIt(int n, float func, float func1, float alph) {
    for (int i = 0; i <2; i++) lockIt(i, function[i], function1[i], alpha[i]*alf*dimmer, alpha1[i]*alf*dimmer);
    for (int i = 2; i <4; i++) lockIt(i, function[i], -function1[i], alpha1[i]*alf*dimmer, alpha1[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image(vis[i], mx, my);
    subwindow.endDraw();
  }

  subwindow.beginDraw();
  subwindow.blendMode(NORMAL);
  subwindow.endDraw();
  ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////// END OF PLAYWITHYOURSELF /////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////
}
