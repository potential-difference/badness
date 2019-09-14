/////////////////////////////////// DONUT ////////////////////////////////////
PGraphics donut(int n, color col, float stroke, float wide, float high, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    vis[n].ellipse(0, 0, wide, high);
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
    println(rigViz, col, stroke, wide, high, func, alph);
  }
  return blured[n];
}

/////////////////////////////////// DONUT ////////////////////////////////////
PGraphics squareNut(int n, color col, float stroke, float wide, float high, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    vis[n].rect(0, 0, wide, high);
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
    println(rigViz, col, stroke, wide, high, func, alph);
  }
  return blured[n];
}

PGraphics flowerOfLife(int n, color col, float stroke, float sz, float sz1, float alph, float alph1) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(360*alph);
    vis[n].pushMatrix();
    vis[n].blendMode(LIGHTEST);
    vis[n].translate(vis[n].width*0.08, vis[n].height*0.08);
    for (int i =0; i<9; i+=2) vis[n].ellipse(grid.shield[i][0].x, grid.shield[i][0].y, 2+(sz), 2+(sz1));
    vis[n].stroke(360*alph1);
    for (int i =1; i<9; i+=2) vis[n].ellipse(grid.shield[i][0].x, grid.shield[i][0].y, 2+(sz), 2+(sz1));

    vis[n].ellipse(grid.shield[3][0].x, grid.shield[3][0].y, 2+(sz), 2+(sz1));
    vis[n].ellipse(grid.shield[5][0].x, grid.shield[5][0].y, 2+(sz), 2+(sz1));

    vis[n].stroke(360*alph1);

    vis[n].ellipse(grid.shield[1][2].x, grid.shield[1][2].y, 2+(sz), 2+(sz1));
    vis[n].ellipse(grid.shield[4][2].x, grid.shield[4][2].y, 2+(sz), 2+(sz1));
    vis[n].ellipse(grid.shield[7][2].x, grid.shield[7][2].y, 2+(sz), 2+(sz1));
    vis[n].blendMode(NORMAL);

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
  //return vis[n];
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
    vis[n].ellipse(0, 0, 2+(sz), 2+(sz1));
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
  vis[n].rotate(radians((40*tweakSlider)+rotate));
  vis[n].ellipse(0, 0, wide, high);
  vis[n].rotate(radians(120));
  vis[n].ellipse(0, 0, wide, high);
  vis[n].rotate(radians(120));
  vis[n].ellipse(0, 0, wide, high);
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

PGraphics lockIt(int n, float func, float func1, float alph, float alph1) {

  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].imageMode(CENTER);
  vis[n].pushMatrix();
  vis[n].translate(vis[2].width/2, vis[2].height/2);

  float rotate = func;
  float rotBeats = 12;
  if (beatCounter%rotBeats < rotBeats/4) rotate = -func;
  if (beatCounter%rotBeats < rotBeats/8) rotate = -func1;

  float end = radians(25);
  float start = radians(0);

  float  big = 100+(func*200);
  float small = 150;
  float add = grid.smallShieldRad*2;
  if (func > 0.8) add = 0;

  float y = (grid.shield[0][1].y)-size.rig.y;             // distance from center

  vis[n].rotate(end);
  vis[n].rotate(radians(rotate*(360/4+start)));

  vis[n].rotate(radians(360/9*3));
  vis[n].tint(col1, 360*alph1);
  vis[n].image(bar1, 0, y, big, 20+add);
  vis[n].tint(col1, 360*alph);

  vis[n].image(bar1, 00, grid.bigShieldRad/2, small, grid.bigShieldRad*1.2);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph1);
  vis[n].image(bar1, 0, y, big, 20+add);
  vis[n].tint(col1, 360*alph);

  vis[n].image(bar1, 0, grid.bigShieldRad/2, small, grid.bigShieldRad*1.2);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph1);
  vis[n].image(bar1, 0, y, big, 20+add);
  vis[n].tint(col1, 360*alph);

  vis[n].image(bar1, 0, grid.bigShieldRad/2, small, grid.bigShieldRad*1.2);


  y = (grid.shield[0][0].y)-size.rig.y;
  //vis[n].rotate(radians(360/9));
  vis[n].tint(col1, 360*alph);
  //vis[n].image(bar1, 0, y, big/2, medShieldRad*1.8);
  vis[n].image(bar1, 0, y, small, grid.medShieldRad*1.8);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph);
  //vis[n].image(bar1, 0, y, big/2, medShieldRad*1.8); 
  vis[n].image(bar1, 0, y, small, grid.medShieldRad*1.8);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph);
  //vis[n].image(bar1, 0, y, big/2, medShieldRad*1.8);
  vis[n].image(bar1, 0, y, small, grid.medShieldRad*1.8);

  vis[n].noTint();
  vis[n].popMatrix();
  vis[n].endDraw();
  return vis[n];
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

////////////////////////////////////////////////////////////// PULSE ///////////////////////////////////////////
PGraphics pulse(int n, color col1, color col2, float alph) {
  float r = red(color(col1));
  float g = green(color(col1));
  float b = blue(color(col1));

  float r1 = red(color(col2));
  float g1 = green(color(col2));
  float b1 = blue(color(col2));

  float t = millis() * 0.0004;
  randomSeed(0);
  src.beginDraw();
  src.noStroke();
  src.colorMode(RGB);
  src.background(r, r, b);
  src.fill(255, 200);
  src.blendMode(NORMAL);

  src.directionalLight(r, r, r, -1, 0, 0.4);
  src.directionalLight(g/1.5, g/1.5, g/1.5, -1, 0, 0.2);
  src.directionalLight(b1/1.5, b1/1.5, b1/1/5, -1, 1, 0);
  src.directionalLight(r1, g1, b1, 1, 1, 0);

  // Lots of rotating cubes
  for (int i = 0; i < 80; i++) {
    src.pushMatrix();

    // This part is the chaos demon.
    src.translate(map(noise(random(1000), t * 0.07), 0, 1, -width, width*2), 
      map(noise(random(1000), t * 0.07), 0, 1, -height, height*2), 0);

    // Progression of time
    src.rotateX(t * 0.4 + randomGaussian());
    src.rotateY(t * 0.0122222 + randomGaussian());

    // But of course.
    src.box(height * abs(0.2 + 0.2 * randomGaussian()));
    src.popMatrix();
  }

  // Separable blur filter
  src.colorMode(HSB, 360, 100, 100);
  src.endDraw();

  imageMode(CENTER);

  blur.set("horizontalPass", 0);
  pass1[n].imageMode(CENTER);

  pass1[n].beginDraw();   
  pass1[n].shader(blur);  
  pass1[n].image(src, pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();

  blur.set("horizontalPass", 1);
  blured[n].beginDraw();            
  blured[n].shader(blur);  
  blured[n].imageMode(CORNER);
  blured[n].image(pass1[n], 0, 0);
  blured[n].endDraw();   
  colorMode(HSB, 360, 100, 100);
  return blured[n];
}

PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
  float moveA;
  float strt = wide/2;
  if (beatCounter % 8 > 3)  moveA = strt+((size.rigWidth-(strt*2))*func);
  else  moveA = size.rigWidth-strt-((size.rigWidth-(strt*2))*func);

  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].noStroke();
  vis[n].fill(col, 360*alph);
  vis[n].rect( moveA, vis[n].height/2, wide, high);
  vis[n].noFill();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();            
  pass1[n].shader(blur);  
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw();            
  blured[n].shader(blur);  
  blured[n].image(pass1[n], 0, 0, vis[n].width/2, vis[n].height/2);
  blured[n].endDraw();    
  return blured[n];
}
