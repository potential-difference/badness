int rigBgr, roofBgr; 

void colorLayer(PGraphics subwindow, int index) {
  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////// RIG COLOR LAYERS ///////////////////////////////////////
  if (subwindow == rigColourLayer) {
    //switch (index) {
    //case 0:
    radGradBallBG(0, c, flash, 0); 
    //break;
    //case 1:
    radialGradientBG(1, c, flash, func);
    //break;
    //case 2:
    bigOppBG(2, c, flash);
    //break;
    //case 3:
    solidBG(3, flash);
    eyeBG(3, clash, c);
    //break;
    //case 4:
    radialGradientBG(4, flash, c, func);
    eyeBG(4, flash, c);
    //break;
    //case 5:
    solidBG(5, c);
    ballsBG(5, clash);
    //break;
    //case 6:
    threeColBG(6, c, flash);
    //break;
    //}

    if (beatCounter % 96 > 76) {
      if (beatCounter % 2 == 0) ballsBG(index, clash);
    }
    //cansBG(index, flash, flash);
    //if (beatCounter%16 > 8) cansBG(index, flash, clash);
    //if (beatCounter % 64 > 48) cansBG(index, c, flash);
    //if (beatCounter % 32 < 12) cansBG(index, clash, clash1);

    ////////////////////////////// DRAW THE COLOR LAYER ///////////////////////////////////
    subwindow.beginDraw();
    subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
    subwindow.endDraw();

    if (rigViz == 0) {
      eyeBG(index, flash, clash);
      subwindow.beginDraw();
      subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
      subwindow.endDraw();
    }
  }

  if (subwindow == roofColourLayer) {
    color roofCol1 = c;
    color roofCol2 = flash;
    color roofClash = clash;

    if (roofClashToggle) {
      roofCol1 = flash;
      roofCol2 = clash;
    }

    mirrorGradientBG(0, roofCol1, roofCol2, 0.5);  
    radialGradientBG(1, roofCol1, roofCol2, 0.1);
    horizontalMirrorGradBG(2, roofCol1, roofCol2, 0);
    horizontalMirrorGradBG(3, roofCol2, roofCol1, func);
    roofArrangement(4, roofCol2, roofCol1);
    roofBigSeeds(5, roofCol1, roofCol2);
    horizontalMirrorGradBG(6, roofCol1, roofCol2, func);


    subwindow.beginDraw();
    subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
    subwindow.endDraw();
  }

  ///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
}


PGraphics ballsBG(int n, color col) {
  bg[n].beginDraw();
  bg[n].noStroke();
  bg[n].fill(col);
  ///////////// BALLS //////////////////////
  bg[n].ellipse(grid.ball[0].x, grid.ball[0].y, 12, 12);
  bg[n].ellipse(grid.ball[4].x, grid.ball[4].y, 12, 12);
  bg[n].ellipse(grid.ball[8].x, grid.ball[8].y, 12, 12);
  bg[n].endDraw();
  return bg[n];
}
PGraphics solidBG(int n, color col) {
  bg[n].beginDraw();
  bg[n].background(col);
  bg[n].endDraw();
  return bg[n];
}

PGraphics eyeBG(int n, color col, color col1) {
  bg[n].beginDraw();
  ////////////////// Fill BIG SHIELD OPPOSITE COLOR //////////////
  bg[n].fill(col);                                
  bg[n].ellipse(size.rig.x, size.rig.y, grid.bigShieldRad, grid.bigShieldRad);
  bg[n].fill(col1);                                
  bg[n].ellipse(size.rig.x, size.rig.y, 50, 50);
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

  //image(bg[n],mx,my,size.rigWidth,size.rigHeight);
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
  int numPoints = 6;
  float angle=360/numPoints;
  float rotate = 90+(function*angle);

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
  bg[n].ellipse(size.rig.x, size.rig.y, grid.bigShieldRad, grid.bigShieldRad);
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
  bg[n].ellipse(size.rig.x, size.rig.y, grid.bigShieldRad, grid.bigShieldRad);
  bg[n].fill(clash1);                                
  bg[n].ellipse(size.rig.x, size.rig.y, 50, 50);

  ///////////// BALLS //////////////////////
  bg[n].fill(clashed);      
  bg[n].ellipse(grid.ball[0].x, grid.ball[0].y, 12, 12);
  bg[n].ellipse(grid.ball[4].x, grid.ball[4].y, 12, 12);
  bg[n].ellipse(grid.ball[8].x, grid.ball[8].y, 12, 12);

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
  bg[n].ellipse(size.rig.x, size.rig.y, grid.bigShieldRad, grid.bigShieldRad);
  ////////////////// BIG SHIELD HP LEDS //////////////
  ////////////////// MEDIUM SHIELD RING AND HP LEDS ///////////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(grid.medShield[2].x, grid.medShield[2].y, grid.medShieldRad, grid.medShieldRad);
  bg[n].ellipse(grid.medShield[6].x, grid.medShield[6].y, grid.medShieldRad, grid.medShieldRad);  
  bg[n].ellipse(grid.medShield[10].x, grid.medShield[10].y, grid.medShieldRad, grid.medShieldRad);  
  ////////////////// BIG SHIELD HP LEDS ////////////////
  bg[n].ellipse(size.rig.x, size.rig.y, 50, 50);
  ///////////////  SMALL SHIELDS /////////////
  bg[n].fill(clashed);
  bg[n].ellipse(grid.smallShield[2].x, grid.smallShield[2].y, grid.medShieldRad, grid.medShieldRad);
  bg[n].ellipse(grid.smallShield[6].x, grid.smallShield[6].y, grid.medShieldRad, grid.medShieldRad);  
  bg[n].ellipse(grid.smallShield[10].x, grid.smallShield[10].y, grid.medShieldRad, grid.medShieldRad);  
  ///////////// BALLS //////////////////////
  bg[n].fill(col2);      
  //bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  bg[n].ellipse(grid.ball[0].x, grid.ball[0].y, 12, 12);
  bg[n].ellipse(grid.ball[4].x, grid.ball[4].y, 12, 12);
  bg[n].ellipse(grid.ball[8].x, grid.ball[8].y, 12, 12);
  bg[n].endDraw();
  return bg[n];
}

/////// 
PGraphics roofArrangement(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(clash);

  bg[n].fill(col2);
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width/6, bg[n].height);

  bg[n].fill(col1);
  bg[n].rect(bg[n].width/8*3, bg[n].height/2, bg[n].width/6, bg[n].height);   
  bg[n].rect(bg[n].width/8*5, bg[n].height/2, bg[n].width/6, bg[n].height);
  bg[n].ellipse(bg[n].width/2, bg[n].height/2+50, 30, 30);

  bg[n].fill(col2);
  bg[n].ellipse(bg[n].width/8*3, bg[n].height/2-200, 30, 30);   
  bg[n].ellipse(bg[n].width/8*5, bg[n].height/2-200, 30, 30);  

  bg[n].ellipse(bg[n].width/8*3, bg[n].height/2+100, 30, 30);   
  bg[n].ellipse(bg[n].width/8*5, bg[n].height/2+100, 30, 30); 

  bg[n].endDraw();
  return bg[n];
}

/////// 
PGraphics roofBigSeeds(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(flash);

  /// big seeds different color
  bg[n].fill(col1);
  bg[n].ellipse(bg[n].width/2-75, bg[n].height/2-200, 50, 50);   
  bg[n].ellipse(bg[n].width/2+75, bg[n].height/2-200, 50, 50);   

  bg[n].ellipse(bg[n].width/2, bg[n].height/2+50, 50, 50);   
  bg[n].ellipse(bg[n].width/2, bg[n].height/2+150, 50, 50);   
  bg[n].ellipse(bg[n].width/2-75, bg[n].height/2+200, 50, 50);   
  bg[n].ellipse(bg[n].width/2+75, bg[n].height/2+200, 50, 50);   

  bg[n].endDraw();
  return bg[n];
}
/*
PGraphics roofMosaicBG(int n, color col1, color col2) {
 bg[n].beginDraw();
 bg[n].background(0);
 
 for (int i =0; i < 15; i= i+2) {
 bg[n].fill(col1);
 bg[n].rect(bg[n].width/8, size.roofHeight/8*i, bg[n].width/4, rh/8);
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
 */
