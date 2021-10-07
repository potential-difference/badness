int rigBgr, roofBgr; 
void colorLayer(PGraphics subwindow, int index) {
  //////////////////////////////////////////////////////////// COLOR LAYER (BACKGROUNDS) /////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////// APPLY BLENDING COLOUR AFTER IMAGE IS DRAWN ///////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////// RIG COLOR LAYERS ///////////////////////////////////////
  if (subwindow == rigColourLayer) {
    //if (rigBgr == 0) 
    radGradBallBG(0, c, flash, 0);  
    //if (rigBgr == 1) 
    radialGradientBG(1, c, flash, func);
    //if (rigBgr == 2) 
    bigOppBG(2, c, flash);
    //if (rigBgr == 3) 
    eyeBG(3, c, flash);
    //if (rigBgr == 4) 
    radGradEyeBG(4, flash, c, func);
    //if (rigBgr == 5) 
    sipralBG(5, flash, c);
    //if (rigBgr == 6) 
    threeColBG(6, c, flash);

    cansBG(index, flash, flash);
    if (beatCounter%16 > 8) cansBG(index, flash, clash);
    if (beatCounter % 64 > 48) cansBG(index, c, flash);
    if (beatCounter % 32 < 12) cansBG(index, clash, clash1);

    if (visualisation>0) {
      subwindow.beginDraw();
      //subwindow.blendMode(MULTIPLY);
      subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
      subwindow.endDraw();
    }
  }

  if (subwindow == roofColourLayer) {
    mirrorGradientBG(0, c, flash, 0.5);  
    horizontalMirrorGradBG(1, c, flash, func);
    horizontalMirrorGradBG(2, c, flash, 0);
    horizontalMirrorGradBG(3, flash, c, 0.5);
    roofClashOutsideBG(4, flash, c);
    roofClashInsideBG(5, c, flash);
    roofMosaicBG(6, c, flash);

    if (visualisation1 >0) {
      subwindow.beginDraw();
      //subwindow.blendMode(MULTIPLY);
      subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
      subwindow.endDraw();
    }
  }

  ///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
}

//void colorLayer(PGraphics subwindow) {
//  //////////////////////////////////////////////////////////// COLOR LAYER (BACKGROUNDS) /////////////////////////////////////////////////////////////
//  ///////////////////////////////////////////////////// APPLY BLENDING COLOUR AFTER IMAGE IS DRAWN ///////////////////////////////////

//  //if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;

//  //////////////////////////////////////////////////////////////////////////////////////////////////////////
//  /////////////////////////////////////////////// RIG COLOR LAYERS ///////////////////////////////////////
//  if (subwindow == rigWindow) {
//    if (rigBgr == 0) radGradBallBG(0, c, flash, 0);  
//    if (rigBgr == 1) radialGradientBG(0, c, flash, func);
//    if (rigBgr == 2) bigOppBG(0, c, flash);
//    if (rigBgr == 3) eyeBG(0, c, flash);
//    if (rigBgr == 4) radGradEyeBG(0, flash, c, func);
//    if (rigBgr == 5) sipralBG(0, flash, c);
//    if (rigBgr == 6) threeColBG(0, c, flash);
//    if (visualisation>0) {
//      subwindow.beginDraw();
//      //subwindow.blendMode(MULTIPLY);
//      subwindow.image(bg[0], mx, my, mw, mh);
//      subwindow.endDraw();
//    }
//  }
//  //////////////////////////////////////////////////////////////////////////////////////////////////////////
//  /////////////////////////////////////////////// ROOF COLOR LAYERS ///////////////////////////////////////
//  if (subwindow == roofWindow) {
//    if (roofBgr == 0) mirrorGradientBG(1, c, flash, 0.5);  
//    if (roofBgr == 1) horizontalMirrorGradBG(1, c, flash, func);
//    if (roofBgr == 2) horizontalMirrorGradBG(1, c, flash, 0);
//    if (roofBgr == 3) horizontalMirrorGradBG(1, flash, c, 0.5);
//    if (roofBgr == 4) roofClashOutsideBG(1, flash, c);
//    if (roofBgr == 5) roofClashInsideBG(1, c, flash);
//    if (roofBgr == 6) roofMosaicBG(1, c, flash);

//    if (visualisation1 >0) {
//      subwindow.beginDraw();
//      subwindow.blendMode(MULTIPLY);
//      subwindow.image(bg[1], mx, my, rw, rh);
//      subwindow.endDraw();
//    }
//  }
//  blendMode(NORMAL);

//  ///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
//}
PGraphics cansBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].noStroke();
  bg[n].rectMode(CENTER);
  bg[n].fill(col1);
  for (int i  =0; i<6; i+=2) bg[n].rect(canX-(canWidth/2)+(i*38)+5, canY+1, 38, 6);
  bg[n].fill(col2);
  for (int i  =1; i<6; i+=2) bg[n].rect(canX-(canWidth/2)+(i*38)+5, canY+1, 38, 6);
  bg[n].rectMode(CENTER);
  bg[n].endDraw();

  return bg[n];
}



/// MIRROR GRADIENT BACKGROUND ///
PGraphics mirrorGradientBG(int n, color col1, color col2, float func) {
  bg[n].beginDraw();
  bg[n].background(0, 0);

  //// LEFT SIDE OF GRADIENT
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col1);
  bg[n].vertex(0, 0);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, 0);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, bg[n].height);
  bg[n].fill(col1);
  bg[n].vertex(0, bg[n].height);
  bg[n].endShape(CLOSE);
  //// RIGHT SIDE OF bg[n]IENT
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, 0);
  bg[n].fill(col1);
  bg[n].vertex(bg[n].width, 0);
  bg[n].fill(col1);
  bg[n].vertex(bg[n].width, bg[n].height);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, bg[n].height);
  bg[n].endShape(CLOSE);
  bg[n].endDraw();

  //image(bg[n],mx,my,mw,mh);
  return bg[n];
}

PGraphics horizontalMirrorGradBG(int n, color col1, color col2, float func) {
  bg[n].beginDraw();
  bg[n].background(0);
  //// TOP HALF OF GRADIENT
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col2);
  bg[n].vertex(0, 0);
  bg[n].vertex(bg[n].width, 0);
  bg[n].fill(col1);
  bg[n].vertex(bg[n].width, bg[n].height*func);
  bg[n].vertex(0, bg[n].height*func);
  bg[n].endShape(CLOSE);
  //// BOTTOM HALF OF GRADIENT 
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col1);
  bg[n].vertex(0, bg[n].height*func);
  bg[n].vertex(bg[n].width, bg[n].height*func);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width, bg[n].height);
  bg[n].vertex(0, bg[n].height);
  bg[n].endShape(CLOSE);
  bg[n].endDraw();
  return bg[n];
}

/// RADIAL GRADIENT BACKGROUND ///
PGraphics radialGradientBG(int n, color col1, color col2, float function) {
  bg[n].beginDraw();
  bg[n].background(col1);
  float radius = bg[n].width;
  int numPoints = 3;
  float angle=360/numPoints;
  float rotate = 90+(function*angle);
  for (  int i = 0; i < numPoints; i++) {
    //bg[n].fill(col2);
    //bg[n].rect(bg[n].width/2,bg[n].height/2,bg[n].width,bg[n].height);
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i)*angle+rotate))*radius+bg[n].width/2, sin(radians((i)*angle+rotate))*radius+bg[n].height/2);
    bg[n].fill(col2);
    bg[n].vertex(bg[n].width/2, bg[n].height/2);
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i+1)*angle+rotate))*radius+bg[n].width/2, sin(radians((i+1)*angle+rotate))*radius+bg[n].height/2);
    bg[n].endShape(CLOSE);
  }
  bg[n].endDraw();

  return bg[n];
}

/// OPPOSITE COLOUR BIG SHIELD BACKGROUND ///
PGraphics bigOppBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(col1);
  ///////////////  BACKGROUND /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col2);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].endDraw();

  return bg[n];
}

/// 2x OPPOSITE COLOUR BIG SHIELD CLASH BACKGORUND///
PGraphics eyeBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(col2);
  ///////////////  BACKGROUND /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].fill(clashed);                                
  bg[n].ellipse(mx, my, 30, 30);
  bg[n].endDraw();

  return bg[n];
}
/// RADIAL GRADIENT BACKGROUND with EYE ///
PGraphics radGradEyeBG(int n, color col1, color col2, float function) {
  bg[n].beginDraw();
  bg[n].background(col1);
  float radius = bg[n].width;
  int numPoints = 3;
  float angle=360/numPoints;
  float rotate = -30+(function*angle);
  for (  int i = 0; i < numPoints; i++) {
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i)*angle+rotate))*radius+bg[n].width/2, sin(radians((i)*angle+rotate))*radius+bg[n].height/2);
    bg[n].fill(col2);
    bg[n].vertex(bg[n].width/2, bg[n].height/2);
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i+1)*angle+rotate))*radius+bg[n].width/2, sin(radians((i+1)*angle+rotate))*radius+bg[n].height/2);
    bg[n].endShape(CLOSE);
  }
  ////////////////// Fill BIG SHIELD OPPOSITE COLOR //////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].fill(col2);                                
  bg[n].ellipse(mx, my, 30, 30);
  bg[n].endDraw();

  return bg[n];
}
/// RADIAL GRADIENT BACKGROUND with EYE and BALLS ///
PGraphics radGradBallBG(int n, color col1, color col2, float function) {
  bg[n].beginDraw();
  bg[n].background(col1);
  float radius = bg[n].width;
  int numPoints = 3;
  float angle=360/numPoints;
  float rotate = -30+(function*angle);
  for (  int i = 0; i < numPoints; i++) {
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i)*angle+rotate))*radius+bg[n].width/2, sin(radians((i)*angle+rotate))*radius+bg[n].height/2);
    bg[n].fill(col2);
    bg[n].vertex(bg[n].width/2, bg[n].height/2);
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i+1)*angle+rotate))*radius+bg[n].width/2, sin(radians((i+1)*angle+rotate))*radius+bg[n].height/2);
    bg[n].endShape(CLOSE);
  }
  ////////////////// Fill BIG SHIELD OPPOSITE COLOR //////////////
  bg[n].fill(clash);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].fill(clash1);                                
  bg[n].ellipse(mx, my, 30, 30);

  ///////////// BALLS //////////////////////
  bg[n].fill(clashed);      
  bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  bg[n].ellipse(ballP[4].x, ballP[4].y, 7, 7);
  bg[n].ellipse(ballP[1].x, ballP[1].y, 7, 7);

  bg[n].endDraw();

  return bg[n];
}

/// EACH SPIAL ARM SEPERATE COLOUR ///
PGraphics sipralBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(clash);
  ///////////////  BIG SHIELD RING /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height); 
  ////////////////// BIG SHIELD HP LEDS /////////////
  bg[n].fill(clash1);
  bg[n].ellipse(mx, my, 30, 30);
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col2);                                
  ////////////////// BOTTOM ARM ///////////////////
  bg[n].ellipse(mShdP[0].x, mShdP[0].y, medShieldRad, medShieldRad);
  bg[n].ellipse(sShdP[8].x, sShdP[8].y, smallShieldRad, smallShieldRad);
  bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col1);                                
  /////////////////// LEFT ARM //////////////
  bg[n].ellipse(mShdP[6].x, mShdP[6].y, medShieldRad, medShieldRad);
  bg[n].ellipse(sShdP[5].x, sShdP[5].y, smallShieldRad, smallShieldRad);  
  bg[n].ellipse(ballP[4].x, ballP[4].y, 7, 7);
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(clashed);       
  //////////////////// RIGHT ARM //////////////////mmm
  bg[n].ellipse(mShdP[3].x, mShdP[3].y, medShieldRad, medShieldRad);
  bg[n].ellipse(sShdP[2].x, sShdP[2].y, smallShieldRad, smallShieldRad);
  bg[n].ellipse(ballP[1].x, ballP[1].y, 7, 7);
  bg[n].endDraw();
  return bg[n];
}

/// OPPOSITE COLOUR SHIELDS BACKGROUND ///
PGraphics threeColBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  //////// FILL IN BACKGROUND TO SEE VIZ ///////
  bg[n].fill(col1, 180);
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);  

  //////////////////// BIG SHIELD CLASH /////////////
  bg[n].fill(col2);
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  ////////////////// BIG SHIELD HP LEDS //////////////
  //bg[n].fill(clashed);
  //bg[n].ellipse(mx, my, 30, 30);

  ////////////////// MEDIUM SHIELD RING AND HP LEDS ///////////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(mShdP[0].x, mShdP[0].y, medShieldRad, medShieldRad);
  bg[n].ellipse(mShdP[3].x, mShdP[3].y, medShieldRad, medShieldRad);  
  bg[n].ellipse(mShdP[6].x, mShdP[6].y, medShieldRad, medShieldRad);
  ////////////////// BIG SHIELD HP LEDS ////////////////
  bg[n].ellipse(mx, my, 30, 30);

  ///////////////  SMALL SHIELDS /////////////
  bg[n].fill(clashed);
  bg[n].ellipse(sShdP[2].x, sShdP[2].y, smallShieldRad, smallShieldRad);
  bg[n].ellipse(sShdP[5].x, sShdP[5].y, smallShieldRad, smallShieldRad);  
  bg[n].ellipse(sShdP[8].x, sShdP[8].y, smallShieldRad, smallShieldRad); 
  ///////////// BALLS //////////////////////
  bg[n].fill(col2);      
  bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  bg[n].ellipse(ballP[4].x, ballP[4].y, 7, 7);
  bg[n].ellipse(ballP[1].x, ballP[1].y, 7, 7);

  bg[n].endDraw();
  return bg[n];
}

/////// 
PGraphics roofClashOutsideBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);

  bg[n].fill(clash);
  bg[n].rect(bg[n].width/8, bg[n].height/2, bg[n].width/4, bg[n].height);   
  bg[n].rect(bg[n].width/8*7, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(col1);
  bg[n].rect(bg[n].width/8*3, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(col2);
  bg[n].rect(bg[n].width/8*5, bg[n].height/2, bg[n].width/4, bg[n].height);
  bg[n].endDraw();

  return bg[n];
}

/////// 
PGraphics roofClashInsideBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);

  bg[n].fill(col1);
  bg[n].rect(bg[n].width/8, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(col2);
  bg[n].rect(bg[n].width/8*7, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(clash);
  bg[n].rect(bg[n].width/8*3, bg[n].height/2, bg[n].width/4, bg[n].height);
  bg[n].fill(clash1);

  bg[n].rect(bg[n].width/8*5, bg[n].height/2, bg[n].width/4, bg[n].height);
  bg[n].endDraw();

  return bg[n];
}

PGraphics roofMosaicBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);

  for (int i =0; i < 15; i= i+2) {
    bg[n].fill(col1);
    bg[n].rect(bg[n].width/8, rh/8*i, bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*3, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*5, rh/8*(i), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*7, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].fill(col2);
    bg[n].rect(bg[n].width/8, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*3, rh/8*(i), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*5, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*7, rh/8*(i), bg[n].width/4, rh/8);
  }
  bg[n].endDraw();

  return bg[n];
}
