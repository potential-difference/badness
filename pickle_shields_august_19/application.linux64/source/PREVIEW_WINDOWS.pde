PGraphics vizPreview(PGraphics subwindow) {
  //////////////////////////////// RIG PREVIEW GRAPHICS /////////////////////////////////////// 
  float size = 40;
  float ypos = 105;
  float xpos = size/2+20+45;
  float dim = 360*0.6;

  subwindow.beginDraw(); 
  for (int i = 0; i< 11; i++) {

    if (i>6) { 
      xpos = 2*size+50;
      ypos = -6*size+30;
    }
    subwindow.tint(dim);
    subwindow.image(colorPreview[rigBgr], xpos, ypos+(size*i+5*i), size, size);        // draw color layer to screen - preview boxes
    subwindow.blendMode(MULTIPLY);
    subwindow.image(vizPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all vizulisation previews
    subwindow.blendMode(NORMAL);

    /////////////////////////////////////////////////// highlight roof viz ////////////////////////////////////////////////////////////////
    if (visualisation1 == i) {    
      subwindow.noTint();
      subwindow.image(colorPreview[rigBgr], xpos, ypos+(size*i+5*i), size, size);        // draw color layer to screen - preview boxes
      subwindow.blendMode(MULTIPLY);
      subwindow.image(vizPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all vizulisation previews
      subwindow.blendMode(NORMAL);
      subwindow.noFill();
      subwindow.strokeWeight(1);
      subwindow.stroke(c, 180);
      subwindow.rect(xpos, ypos+(size*i+5*i), size+2, size+2);                  // rectablge to hightlight which one is selected
      subwindow.rectMode(CORNER);
      subwindow.stroke(clashed, 210);
      subwindow.fill(flash, 360);
      subwindow.noStroke();
      subwindow.rect(xpos+size/2-3, ypos+1+(size*i+5*i)+size/2, 4, -(size+2)*cc[8]*secondVizSlider);     // 
      subwindow.rectMode(CENTER);
    }

    /////////////////////////////////////////////////// highlight rig viz //////////////////////////////////////////////////////////////// 
    if (visualisation == i) {
      subwindow.noTint();
      subwindow.image(colorPreview[rigBgr], xpos, ypos+(size*i+5*i), size, size);        // draw color layer to screen - preview boxes
      subwindow.blendMode(MULTIPLY);
      subwindow.image(vizPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all vizulisation previews
      subwindow.blendMode(NORMAL);
      subwindow.noFill();
      subwindow.strokeWeight(1);
      subwindow.stroke(flash, 180);
      subwindow.rect(xpos, ypos+(size*i+5*i), size, size);
      subwindow.rectMode(CORNER);
      subwindow.stroke(clashed, 210);
      subwindow.fill(c, 360);
      subwindow.noStroke();
      subwindow.rect(xpos+size/2-4, ypos+(size*i+5*i)+size/2, 4, -size*cc[4]*rigDimmer);
      subwindow.rectMode(CENTER);
    }
  }
  subwindow.noStroke();
  subwindow.noTint();
  subwindow.endDraw();
  return subwindow;
}

PGraphics colorPreview(PGraphics subwindow) {
  //// display the different color layers and highlight the current one
  float size = 40;
  float ypos = 105;
  float xpos = size/2+20;
  float dim = 360*0.3;

  for (int i = 0; i < 7; i++) colorPreviews(colorPreview[i], i, bg[i]); // generate all of the rig previews using masking
  subwindow.beginDraw(); 
  subwindow.background(0);
  for (int i = 0; i < 7; i++) {
    subwindow.tint(360, dim);
    subwindow.image(rigWindow, xpos, ypos+(size*i+5*i), size, size);      // draw current viz
    subwindow.blendMode(MULTIPLY);
    subwindow.image(colorPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all color layer patterns
    subwindow.blendMode(NORMAL);

    if (rigBgr == i) {
      subwindow.tint(360, 360);                              // tint CURRENT bright
      subwindow.image(rigWindow, xpos, ypos+(size*i+5*i), size, size);      // draw current viz
      subwindow.blendMode(MULTIPLY);
      subwindow.image(colorPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all color layer patterns
      subwindow.blendMode(NORMAL);
      subwindow.noFill();
      subwindow.strokeWeight(1);
      subwindow.stroke(c, 180);
      subwindow.rect(xpos, ypos+(size*i+5*i), size, size);
    }
  }
  subwindow.stroke(flash, 180);
  //subwindow.resetShader();
  subwindow.noTint();
  subwindow.rect(xpos+size/2+2, 3*size+ypos+(3*5), 0, 7*size+(6*5));
  subwindow.endDraw();
  return subwindow;
}

PGraphics colorPreviews(PGraphics subwindow, int index, PGraphics background) {
  subwindow.beginDraw(); 
  subwindow.background(0);
  //if (keyT[96])
  //subwindow.shader(maskShader);  
  subwindow.image(background, subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);      // draw all color layer patterns
  //subwindow.resetShader();
  subwindow.endDraw();
  return colorPreview[index];
}
