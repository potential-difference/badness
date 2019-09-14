/////////////////////////////////// DONUT ////////////////////////////////////
PGraphics donut(int n, color col, float stroke, float sz, float sz1, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(col, 360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    if (!toggle.rect) vis[n].ellipse(0, 0, 2+(sz)/2, 2+(sz1)/2);
    else rect(0, 0, 2+(sz), 2+(sz1));
    //vis[n].rect(0, 0, 2+(sz), 2+(sz1));
    vis[n].popMatrix();
    vis[n].endDraw();

    blur.set("horizontalPass", 0);
    pass1[n].beginDraw();            
    pass1[n].shader(blur); 
    pass1[n].imageMode(CENTER);
    pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
    pass1[n].endDraw();
    blur.set("horizontalPass", 1);
    blured[n].beginDraw();            
    blured[n].shader(blur);  
    blured[n].imageMode(CENTER);
    blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
    blured[n].endDraw();
  } 
  catch (AssertionError e) {
    println(e);
    println(rigViz, col, stroke, sz, sz1, func, alph);
  }
  return blured[n];
}

PGraphics donutRotate(int n, color col, float stroke, float sz, float sz1, float rot, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(col, 360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    vis[n].rotate(radians(rot));
    if (!toggle.rect)ellipse(0, 0, 2+(sz), 2+(sz1));
    else vis[n].rect(0, 0, 2+(sz), 2+(sz1));
    vis[n].popMatrix();
    vis[n].endDraw();

    blur.set("horizontalPass", 0);
    pass1[n].beginDraw();            
    pass1[n].shader(blur); 
    pass1[n].imageMode(CENTER);
    pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
    pass1[n].endDraw();
    blur.set("horizontalPass", 1);
    blured[n].beginDraw();            
    blured[n].shader(blur);  
    blured[n].imageMode(CENTER);
    blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
    blured[n].endDraw();
  } 
  catch (AssertionError e) {
    println(e);
    println(rigViz, col, stroke, sz, sz1, func, alph);
  }
  return blured[n];
}

/////////////////////////////////// DONUT ////////////////////////////////////
PGraphics solidNut(int n, color col, float stroke, float sz, float sz1, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].noStroke();
    vis[n].fill(360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    vis[n].ellipse(0, 0, 2+(sz)/2, 2+(sz1)/2);
    vis[n].popMatrix();
    vis[n].endDraw();

    blur.set("horizontalPass", 0);
    pass1[n].beginDraw();            
    pass1[n].shader(blur); 
    pass1[n].imageMode(CENTER);
    pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
    pass1[n].endDraw();
    blur.set("horizontalPass", 1);
    blured[n].beginDraw();            
    blured[n].shader(blur);  
    blured[n].imageMode(CENTER);
    blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
    blured[n].endDraw();
  } 
  catch (AssertionError e) {
    println(e);
    println(rigViz, col, stroke, sz, sz1, func, alph);
  }
  return blured[n];
}

//////////////////////////// STAR ////////////////////////////////
PGraphics star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].pushMatrix();
  vis[n].strokeWeight(-stroke);
  vis[n].stroke(360*alph);
  vis[n].noFill();
  vis[n].translate(vis[n].width/2, vis[n].height/2);
  vis[n].rotate(radians(rotate));
  if (!toggle.rect)vis[n].ellipse(0, 0, wide, high);
  else vis[n].rect(0, 0, wide, high);
  vis[n].rotate(radians(120));
  if (!toggle.rect)vis[n].ellipse(0, 0, wide, high);
  else vis[n].rect(0, 0, wide, high);
  vis[n].rotate(radians(120));
  if (!toggle.rect)vis[n].ellipse(0, 0, wide, high);
  else vis[n].rect(0, 0, wide, high);
  vis[n].popMatrix();
  vis[n].noStroke();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();            
  pass1[n].shader(blur);  
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw();            
  blured[n].shader(blur);  
  blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
  blured[n].endDraw();    
  return blured[n];
}

float rot1;
PGraphics spin(int n, float rad, float func, float rotate, float alph) {
  if (beatCounter%2 == 1) rot1 = (rot1 +2) % 360;
  if (beatCounter%2 == 0) rot1 = (rot1 -2) % 360;
  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].pushMatrix();
  vis[n].translate(vis[2].width/2, vis[2].height/2);
  vis[n].rotate(radians(rot1*rotate));
  vis[n].strokeWeight(-20);
  vis[n].stroke(360*alph);
  vis[n].arc(0, 0, rad, rad, radians(0), radians(90*func), OPEN);
  vis[n].arc(0, 0, rad, rad, radians(180), radians(180+(90*func)), OPEN);
  vis[n].stroke(360*alph);
  vis[n].arc(0, 0, rad, rad, radians(90), radians(90+(90*func)), OPEN);
  vis[n].arc(0, 0, rad, rad, radians(270), radians(270+(90*func)), OPEN);
  vis[n].popMatrix();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();   
  pass1[n].shader(blur); 
  pass1[n].imageMode(CENTER);
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw(); 
  blured[n].imageMode(CENTER);
  blured[n].shader(blur);  
  blured[n].image(vis[n], blured[n].width/2, blured[n].height/2);
  blured[n].endDraw();    

  return vis[n];
}


PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
  float moveA;
  float strt = wide/2;
  if (beatCounter % 8 <4 )  moveA = strt+((size.rigWidth-(strt*2))*func);
  else  moveA = strt+((size.rigWidth-(strt*2))*func);
  
  //moveA = vis[n].width-strt-((vis[n].width-(strt*2))*func);
  vis[n].beginDraw();
  vis[n].colorMode(HSB, 360, 100, 100);
  vis[n].background(0);
  vis[n].noStroke();
  vis[n].fill(col, 360);
  vis[n].rect(moveA, vis[n].height/2, wide, high);
  vis[n].noFill();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();   
  pass1[n].shader(blur); 
  pass1[n].imageMode(CENTER);
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw(); 
  blured[n].imageMode(CENTER);
  blured[n].shader(blur);  
  blured[n].image(vis[n], blured[n].width/2, blured[n].height/2);
  blured[n].endDraw();    

  return blured[n];
}

PGraphics bgNoise( int n, color col, float alph) {
  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].noStroke();
  vis[n].loadPixels();
  for (int x = 0; x < vis[n].width; x++) {                  // Loop through every pixel column
    for (int y = 0; y < vis[n].height; y++) {              // Loop through every pixel row
      int loc = x + y * vis[n].width;                      // Use the formula to find the 1D location
      vis[n].pixels[loc] = color(random(360*alph) );    // random alpha
    }
  }
  vis[n].blendMode(DARKEST);
  vis[n].updatePixels();
  vis[n].rectMode(CENTER);
  vis[n].fill(col);
  vis[n].rect(vis[n].width/2, vis[n].height/2, vis[n].width, vis[n].height);
  vis[n].blendMode(NORMAL);
  vis[n].endDraw();    
  return vis[n];
}
