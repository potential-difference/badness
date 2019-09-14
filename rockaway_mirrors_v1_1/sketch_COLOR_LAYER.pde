int rigBgr, roofBgr; 
int bgList = 8;
void colorLayer(PGraphics subwindow, int index) {
  /////////////////////////////////////////////// RIG COLOR LAYERS ///////////////////////////////////////
  if (subwindow == rigColourLayer) {
    oneColourBG(0, c);
    mirrorGradientBG(1, c, flash, 0.5);  
    sideBySideBG(2, flash, c);
    checkSymmetricalBG(3, c, flash);
    cornersBG(4, flash, c);
    crossBG(5, c, flash);
    oneColourBG(6, flash);
    sideBySideBG(7, c, flash);

    subwindow.beginDraw();
    subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
    subwindow.endDraw();
  }

  if (subwindow == roofColourLayer) {
    color roofCol1 = c;
    color roofCol2 = flash;
    color roofClash = clash;

    mirrorGradientBG(0, roofCol1, roofCol2, 0.5);  
    //radialGradientBG(1, roofCol1, roofCol2, 0.1);
    horizontalMirrorGradBG(2, roofCol1, roofCol2, 0);
    horizontalMirrorGradBG(3, roofCol2, roofCol1, func);
    //roofArrangement(4, roofCol2, roofCol1);
    //roofBigSeeds(5, roofCol1, roofCol2);
    horizontalMirrorGradBG(6, roofCol1, roofCol2, func);

    subwindow.beginDraw();
    subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
    subwindow.endDraw();
  }
}
///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

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

/// ONE COLOUR BACKGOUND ///
PGraphics oneColourBG(int n, color col1) {
  bg[n].beginDraw();
  bg[n].background(col1);
  bg[n].endDraw();
  return bg[n];
}

/// SYMETRICAL BACKGOUND ///
PGraphics checkSymmetricalBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(col1);
  ///////////////  BACKGROUND /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col2);    
  bg[n].rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);

  bg[n].endDraw();
  return bg[n];
}

/// CHECK BACKGROUND ///
PGraphics checkBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(col1);
  ///////////////  BACKGROUND /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col2);     
  for (int i = 0; i <grid.mirror.length/3; i+=2)  bg[n].rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
  for (int i = 5; i <grid.mirror.length/3*2; i+=2)  bg[n].rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
  for (int i = 8; i <grid.mirror.length; i+=2)  bg[n].rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].endDraw();

  return bg[n];
}

PGraphics cornersBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// TOP RECTANGLE ////////////////////
  bg[n].fill(col2);
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  /////////////// BOTTOM RECTANGLE ////////////////////
  bg[n].fill(col1);                                
  bg[n].rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);

  bg[n].rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
  bg[n].rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);

  bg[n].endDraw();

  return bg[n];
}
/// TOP ROW ONE COLOUR BOTTOM ROW THE OTHER BACKGORUND///
PGraphics sideBySideBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// TOP RECTANGLE ////////////////////
  bg[n].fill(col2);
  bg[n].rect(bg[n].width/4, bg[n].height/2, bg[n].width/2, bg[n].height);     
  /////////////// BOTTOM RECTANGLE ////////////////////
  bg[n].fill(col1);                                
  bg[n].rect(bg[n].width/4*3, bg[n].height/2, bg[n].width/2, bg[n].height);     
  bg[n].endDraw();
  return bg[n];
}

//// top left and bottom right 3 mirror opposite colours /////
PGraphics crossBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(col1);
  bg[n].fill(col2);
  bg[n].rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorAndGap*3, grid.mirrorWidth);    
  bg[n].rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorAndGap*3, grid.mirrorWidth);    

  bg[n].endDraw();
  return bg[n];
}


PGraphics gradMirrorBG(int n, color col1, color col2) {
  bg[n].beginDraw();
  bg[n].background(col1);

  //// TOP HALF OF GRADIENT
  //bg[n].beginShape(POLYGON); 
  //bg[n].fill(col2);
  //bg[n].vertex(grid.mirror[0].x-(grid.mirrorWidth/2),grid.mirror[0].y-(grid.mirrorWidth/2));
  //bg[n].vertex(grid.mirror[0].x+(grid.mirrorWidth/2),grid.mirror[0].y+(grid.mirrorWidth/2));
  //bg[n].fill(col1);
  //bg[n].vertex(grid.mirror[0].x-(grid.mirrorWidth/2),grid.mirror[0].y+(grid.mirrorWidth/2));
  for (int i = 0; i < 6; i++) {
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].fill(col2);
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].endShape(CLOSE);

    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].fill(col2);
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].endShape(CLOSE);
  }

  for (int i = 6; i < 12; i++) {
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].fill(col2);
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].endShape(CLOSE);

    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].fill(col2);
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
    bg[n].vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].fill(col1);
    bg[n].vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
    bg[n].endShape(CLOSE);
  }
  bg[n].endDraw();

  return bg[n];
}

/*
PGraphics everyOtherBG(int n, color col1, color col2) {
 bg[n].beginDraw();
 bg[n].background(0);
 bg[n].fill(col1);
 bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);
 bg[n].fill(0);
 
 float space = 2;
 float thickness = 3;
 
 for (int i = 0; i < grid.mirror.length/2; i+=2) {
 for (float o = 0.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 } 
 for (int i = 7; i < grid.mirror.length; i+=2) {
 for (float o = 0.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 } 
 
 for (int i = 1; i < grid.mirror.length/2; i+=2) {
 for (float o = 1.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 } 
 for (int i = 6; i < grid.mirror.length; i+=2) {
 for (float o = 1.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 }
 
 bg[n].fill(col2, 120);
 for (int i = 0; i < grid.mirror.length/2; i+=2) {
 for (float o = 0.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirrorAndGap, thickness);
 }
 } 
 for (int i = 7; i < grid.mirror.length; i+=2) {
 for (float o = 0.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 } 
 
 for (int i = 1; i < grid.mirror.length/2; i+=2) {
 for (float o = 1.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 } 
 for (int i = 6; i < grid.mirror.length; i+=2) {
 for (float o = 1.5; o < ld; o+=space) {
 bg[n].rect(grid.mirror[i].x-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.mirror[i].y, thickness, grid.grid.mirrorAndGap);
 bg[n].rect(grid.mirror[i].x, grid.mirror[i].y-(grid.mirrorWidth/2)+(grid.mirrorWidth/ld*o), grid.grid.mirrorAndGap, thickness);
 }
 }
 
 bg[n].endDraw();
 
 return bg[n];
 }
 */
