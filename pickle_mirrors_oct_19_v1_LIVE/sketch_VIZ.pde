class Visualisation {
  PGraphics vis = new PGraphics();
  PGraphics bg[] = new PGraphics[bgList];
  PGraphics colourLayer;
  PGraphics pass1 = new PGraphics();
  PGraphics blured = new PGraphics();
  PShader blur;
  PGraphics src;
  Visualisation() {
    //////////////////////////////// RIG VIS GRAPHICS ///////////////////
    vis = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    vis.beginDraw();
    vis.colorMode(HSB, 360, 100, 100);
    vis.blendMode(NORMAL);
    vis.ellipseMode(CENTER);
    vis.rectMode(CENTER);
    vis.imageMode(CENTER);
    vis.noStroke();
    vis.noFill();
    vis.endDraw();
    ///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
    blur = loadShader("blur.glsl");
    blur.set("blurSize", 40);
    blur.set("sigma", 30.0f);  
    pass1 = createGraphics(int(size.rigWidth*0.6), int(size.rigHeight*0.6), P2D);
    pass1.noSmooth();
    pass1.imageMode(CENTER);
    pass1.beginDraw();
    pass1.noStroke();
    pass1.endDraw();
    blured = createGraphics(int(size.rigWidth*0.6), int(size.rigHeight*0.6), P2D);
    blured.noSmooth();
    blured.beginDraw();
    blured.imageMode(CENTER);
    blured.noStroke();
    blured.endDraw();
  }
  void blurPGraphics() {
    blur.set("horizontalPass", 0);
    pass1.beginDraw();            
    pass1.shader(blur); 
    pass1.imageMode(CENTER);
    pass1.image(vis, pass1.width/2, pass1.height/2);
    pass1.endDraw();
    blur.set("horizontalPass", 1);
    blured.beginDraw();            
    blured.shader(blur);  
    blured.imageMode(CENTER);
    blured.image(pass1, blured.width/2, blured.height/2);
    blured.endDraw();
  }
  /////////////////////////////////// DONUT ///////////////////////////////////////////////////////////////////////////////////////
  PGraphics donut(color col, float stroke, float wide, float high, float alph) {
      vis.beginDraw();
      vis.colorMode(HSB, 360, 100, 100);
      vis.background(0);
      vis.strokeWeight(-stroke);
      vis.stroke(col, 360*alph);
      vis.pushMatrix();
      vis.translate(vis.width/2, vis.height/2);
      vis.ellipse(0, 0, wide, high);
      vis.popMatrix();
      vis.endDraw();
      blurPGraphics();
   
    return blured;
  }
  ///////////////////////////////////// SQUARE NUT /////////////////////////////////////////////////////////////////////////////////////////////////
  //PGraphics squareNut(float xpos, float ypos, color col, float stroke, float wide, float high, float alph) {
  //  try {
  //    window.strokeWeight(-stroke);
  //    window.stroke(col, 360*alph);
  //    window.pushMatrix();
  //    window.translate(xpos,ypos);
  //    window.rect(0, 0, wide, high);
  //    window.popMatrix();
  //    //blurPGraphics();
  //  } 
  //  catch (AssertionError e) {
  //    println(e);
  //    println(rigViz, col, stroke, wide, high, func, alph);
  //  }
  //  //return blured;
  //}
  /*
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
   
   ////////////////////////////// CHECKERS /////////////////////////////////
   PGraphics checkers(int n, color col, color col1, float alph) {
   vis[n].beginDraw();
   vis[n].background(0);
   vis[n].noStroke();  
   vis[n].rectMode(CENTER);
   if (beatCounter % 3 == 0) {
   vis[n].fill( col, 360*alph);
   vis[n].rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[9].x, grid.mirror[9].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
   }
   if (beatCounter % 3 == 1) {
   vis[n].fill( col1, 360*alph);
   vis[n].rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth); 
   vis[n].rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
   }
   
   if (beatCounter % 3 == 2) {
   vis[n].fill( col, 360*alph);
   vis[n].rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[9].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
   ///////////////////////////////////////////////////////////////////////////////////////////////
   vis[n].fill( col1, 360*alph);
   vis[n].rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[2].x, grid.mirror[2].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
   vis[n].rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth); 
   vis[n].rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
   }
   vis[n].endDraw();
   return vis[n];
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
   
   PGraphics rush(int n, color col, float wide, float high, float func, float alph) {
   float moveA;
   float strt = 0;
   if (beatCounter % 8 <4 )  moveA = (strt+(vis[n].width-strt)*func);
   else  moveA = (vis[n].width-strt)-(strt+(vis[n].width-strt)*func);
   vis[n].beginDraw();
   vis[n].colorMode(HSB, 360, 100, 100);
   vis[n].background(0);
   vis[n].imageMode(CENTER);
   vis[n].image(bar1, moveA, vis[n].height/2, wide, high);
   vis[n].tint(col, 360*alph);
   vis[n].endDraw();
   return vis[n];
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
   */
}