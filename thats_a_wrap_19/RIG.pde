public class Rig {
  float dimmer = 1, alphaRate, funcRate;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  color c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD;
  color col[] = new color[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  boolean firsttime_sketchcolor=true, toggle;
  int bgList = 8;
  ArrayList <Anim> animations;
  HashMap<Integer, Tup> dimmers;
  int arrayListIndex;

  int[] availableAnims;

  Rig(float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);

    availableAnims = new int[] {0, 1, 2, 3};  // default - changed when initalised;
    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);      // where this is the rig object

    dimmers = new HashMap<Integer, Tup>();

    int xw = 2;
    for (int i = 0; i < position.length/xw; i++) position[i] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*1);
    for (int i = 0; i < position.length/xw; i++) position[i+(position.length/xw)] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*2);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i=0; i<positionX.length; i++)  positionX[i][0] = new PVector(wide/(positionX.length)*(i+0.5), high/6*1);
    for (int i=0; i<positionX.length; i++)  positionX[i][1] = new PVector(wide/(positionX.length)*(i+0.5), high/4*2);
    for (int i=0; i<positionX.length; i++)  positionX[i][2] = new PVector(wide/(positionX.length)*(i+0.5), high/6*5);

    colorLayer = createGraphics(wide, high, P2D);
    colorLayer.beginDraw();
    colorLayer.noStroke();
    colorLayer.colorMode(HSB, 360, 100, 100);
    colorLayer.imageMode(CENTER);
    colorLayer.rectMode(CENTER);
    colorLayer.endDraw();

    buffer = createGraphics(wide, high, P2D);
    buffer.beginDraw();
    buffer.colorMode(HSB, 360, 100, 100);
    buffer.blendMode(NORMAL);
    buffer.ellipseMode(CENTER);
    buffer.rectMode(CENTER);
    buffer.imageMode(CENTER);
    buffer.noStroke();
    buffer.noFill();
    buffer.endDraw();

    ///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
    pass1 = createGraphics(wide/2, high/2, P2D);
    pass1.noSmooth();
    pass1.imageMode(CENTER);
    pass1.beginDraw();
    pass1.noStroke();
    pass1.endDraw();

    pass2 = createGraphics(wide/2, high/2, P2D);
    pass2.noSmooth();
    pass2.beginDraw();
    pass2.imageMode(CENTER);
    pass2.noStroke();
    pass2.endDraw();

    if (firsttime_sketchcolor) {
      colorSetup();                        // setup colors red bloo etc once
      firsttime_sketchcolor = false;
    }
    /////////////////////////////////////// COLOR ARRAY ARRANGEMENT ////////////////////////////////////////
    col[0] = purple; 
    col[1] = pink; 
    col[2] = orange1; 
    col[3] = bloo;
    col[4] = red;
    col[5] = orange1;
    col[6] = purple;
    col[7] = grin;
    col[8] = orange;
    col[9] = bloo;
    col[10] = purple;
    col[11] = pink;
    col[12] = orange;
    col[13] = orange1;
    col[14] = teal;
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void drawColorLayer() {

    switch(bgIndex) {
    case 0:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      colorLayer.endDraw();
      break;
    case 1:
      colorLayer.beginDraw();
      colorLayer.background(0);
      mirrorGradient(c, flash, 0.5);
      colorLayer.endDraw();
      break;
    case 2:
      colorLayer.beginDraw();
      colorLayer.background(0);
      sideBySide(c, flash);
      colorLayer.endDraw();
      break;
    case 3:
      colorLayer.beginDraw();
      colorLayer.background(0);
      horizontalMirrorGradient(c, flash, 1);
      colorLayer.endDraw();
      break;
    case 4:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(flash);
      colorLayer.endDraw();
      break;
    case 5:
      colorLayer.beginDraw();
      colorLayer.background(0);
      horizontalMirrorGradient(c, flash, noize1);
      colorLayer.endDraw();
      break;
    case 6:
      colorLayer.beginDraw();
      colorLayer.background(0);
      check(c, flash);
      colorLayer.endDraw();
      break;
    case 7:
      colorLayer.beginDraw();
      colorLayer.background(0);
      radiator(c, flash);
      colorLayer.endDraw();
    default:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      colorLayer.endDraw();
      break;
    }
    blendMode(MULTIPLY);
    /*
    if (syphonToggle) { 
     if (syphonImageReceived != null) image(syphonImageReceived, size.x, size.y, wide, high);
     } else 
     */
    image(colorLayer, size.x, size.y);
  }
  //////////////////////////////////////// END OF BACKGROUND CONTROL /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// VERTICAL MIRROR GRADIENT BACKGROUND ////////////////////////////////////////////////
  void mirrorGradient(color col1, color col2, float func) {
    //// LEFT SIDE OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    //colorLayer.noStroke();
    colorLayer.fill(col1);
    colorLayer.vertex(0, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height);
    colorLayer.endShape(CLOSE);
    //// RIGHT SIDE OF colorLayerIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.endShape(CLOSE);
  }
  /////////////////////////////////// RADIAL GRADIENT BACKGROUND //////////////////////////////////////////////////////////
  void radialGradient(color col1, color col2, float function) {
    colorLayer.background(col1);
    float radius = colorLayer.height*function;
    int numPoints = 12;
    float angle=360/numPoints;
    float rotate = 90+(function*angle);
    for (  int i = 0; i < numPoints; i++) {
      colorLayer.beginShape(POLYGON); 
      colorLayer.fill(col1);
      colorLayer.vertex(cos(radians((i)*angle+rotate))*radius+colorLayer.width/2, sin(radians((i)*angle+rotate))*radius+colorLayer.height/2);
      colorLayer.fill(col2);
      colorLayer.vertex(colorLayer.width/2, colorLayer.height/2);
      colorLayer.fill(col1);
      colorLayer.vertex(cos(radians((i+1)*angle+rotate))*radius+colorLayer.width/2, sin(radians((i+1)*angle+rotate))*radius+colorLayer.height/2);
      colorLayer.endShape(CLOSE);
    }
  }
  /// MIRROR GRADIENT BACKGROUND top one direction - bottom opposite direction ///
  void mirrorGradientHalfHalf(color col1, color col2, float func) {
    //////// TOP //// LEFT SIDE OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col1);
    colorLayer.vertex(0, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height/2);
    colorLayer.endShape(CLOSE);
    //// RIGHT SIDE OF colorLayerIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height/2);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.endShape(CLOSE);
    colorLayer.endDraw();
    //////////////////////////////////
    func = 1-func;
    colorLayer.beginDraw();
    ///// BOTTOM
    //// LEFT SIDE OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height/2);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height/2);
    colorLayer.endShape(CLOSE);
    //// RIGHT SIDE OF colorLayerIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height/2);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.endShape(CLOSE);
  }
  /////////////////////////////////////////////////// HORIZONAL GRADIENT ///////////////////////////////////////////////////////
  void horizontalMirrorGradient(color col1, color col2, float func) {
    //// TOP HALF OF GRADIENT
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col2);
    colorLayer.vertex(0, 0);
    colorLayer.vertex(colorLayer.width, 0);
    colorLayer.fill(col1);
    colorLayer.vertex(colorLayer.width, colorLayer.height*func);
    colorLayer.vertex(0, colorLayer.height*func);
    colorLayer.endShape(CLOSE);
    //// BOTTOM HALF OF GRADIENT 
    colorLayer.beginShape(POLYGON); 
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height*func);
    colorLayer.vertex(colorLayer.width, colorLayer.height*func);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width, colorLayer.height);
    colorLayer.vertex(0, colorLayer.height);
    colorLayer.endShape(CLOSE);
  }
  ///////////////////////////////////////// ONE COLOUR BACKGOUND //////////////////////////////////////////////////////////////////////////
  void oneColour(color col1) {
    colorLayer.background(col1);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void radiator(color col1, color col2) {
    colorLayer.fill(col2);
    //color colorStep  
    for (int i = 0; i < opcGrid.rad.length; i++) colorLayer.rect(this.position[i].x, this.position[i].y, 15, this.high/2.2);
  }
  ////////////////////////////////////////// CHECK BACKGROUND //////////////////////////////////////////////////////////////////////////////
  void check(color col1, color col2) {
    colorLayer.fill(col2);
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width, colorLayer.height);        
    ////////////////////////// Fill OPPOSITE COLOR //////////////
    colorLayer.fill(col1);  
    for (int i = 0; i < position.length/2; i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    for (int i = position.length/2+1; i < position.length; i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    //if (opcGrid.rows == 3) for (int i = opcGrid.columns*opcGrid.rows; i < opcGrid.mirror.length/opcGrid.rows+(opcGrid.columns*2); i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
  }
  /////////////////////////// TOP ROW ONE COLOUR BOTTOM ROW THE OTHER BACKGORUND ////////////////////////////////////////////////////////////////
  void sideBySide( color col1, color col2) {
    /////////////// TOP RECTANGLE ////////////////////
    colorLayer.fill(col2);
    colorLayer.rect(colorLayer.width/4, colorLayer.height/2, colorLayer.width/2, colorLayer.height);     
    /////////////// BOTTOM RECTANGLE ////////////////////
    colorLayer.fill(col1);                                
    colorLayer.rect(colorLayer.width/4*3, colorLayer.height/2, colorLayer.width/2, colorLayer.height);
  }


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void rigInfo() {
    float textHeight = 18;
    textSize(textHeight);
    String panelName = name;
    float nameWidth = textWidth(panelName);
    float x = size.x+(wide/2)-(nameWidth/2)-12;
    float y = size.y-(high/2)+21;

    fill(360);
    textAlign(CENTER);
    textLeading(18);
    text(panelName, x, y);

    fill(0, 100);
    stroke(rigg.flash, 60);
    strokeWeight(1);
    rect(x, y-(textHeight/2)+3, nameWidth+17, 30);
    noStroke();
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///// RECTANGLES TO SHOW CURRENT COLOURS /////
    x = size.x+(wide/2)-(nameWidth+17)-30;
    y = size.y-(high/2)+20;

    fill(0);
    rect(x, y-10, 10, 10);                 // rect to show CURRENT color C 
    rect(x+15, y-10, 10, 10);              // rect to show NEXT color C 
    rect(x, y, 10, 10);                    // rect to show CURRENT color FLASH 
    rect(x+15, y, 10, 10);                 // rect to show NEXT color FLASH1

    fill(0, 100);
    stroke(rigg.flash, 60);
    strokeWeight(1);
    rect(x+7.5, y-5, 30, 30);

    stroke(0);
    fill(this.c);          
    rect(x, y-10, 10, 10);                                     // rect to show CURRENT color C 
    fill(this.col[(this.colorIndexA+1)%this.col.length], 100);
    rect(x+15, y-10, 10, 10);                                  // rect to show NEXT color C 
    fill(this.flash);
    rect(x, y, 10, 10);                                        // rect to show CURRENT color FLASH 
    fill(this.col[(this.colorIndexB+1)%this.col.length], 100);  
    rect(x+15, y, 10, 10);                                     // rect to show NEXT color FLASH1
    noStroke();
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////// COLOR TIMER /////////////////////////////////////////////////////////////////////////
  float go = 0;
  boolean change;
  int colorTimer;
  void colorTimer(float colTime, int steps) {
    colorIndexA = this.colorIndexA;
    colorIndexB = this.colorIndexB;

    if (change == false) {
      colA = c;
      colC = flash;
    }
    if (millis()/1000 - colorTimer >= colTime) {
      change = true;
      println("COLOR CHANGE @", (hour()+":"+minute()+":"+second()));
      colorTimer = millis()/1000;
    } else change = false;
    if (change == true) {
      go = 1;
      colorIndexA =  (colorIndexA + steps) % (col.length-1);
      colB =  col[colorIndexA];
      colorIndexB = (colorIndexB + steps) % (col.length-1);
      colD = col[colorIndexB];
    }
    c = col[colorIndexA];
    c1 = col[colorIndexA];
    flash = col[colorIndexB];
    flash1 = col[colorIndexB];

    if (go > 0.1) change = true;
    else change = false;
    if (change == true) {
      c = lerpColorHSB(colB, colA, go);
      flash = lerpColorHSB(colD, colC, go);
    }
    go *= 0.97;
    if (go < 0.01) go = 0.001;
  }
  ////////////////////////////////////////////////////// HSB LERP COLOR FUNCTION //////////////////////////////
  // linear interpolate two colors in HSB space 
  color lerpColorHSB(color c1, color c2, float amt) {
    amt = min(max(0.0, amt), 1.0);
    float h1 = hue(c1), s1 = saturation(c1), b1 = brightness(c1);
    float h2 = hue(c2), s2 = saturation(c2), b2 = brightness(c2);
    // figure out shortest direction around hue
    float z = g.colorModeZ;
    float dh12 = (h1>=h2) ? h1-h2 : z-h2+h1;
    float dh21 = (h2>=h1) ? h2-h1 : z-h1+h2;
    float h = (dh21 < dh12) ? h1 + dh21 * amt : h1 - dh12 * amt;
    if (h < 0.0) h += z;
    else if (h > z) h -= z;
    colorMode(HSB);
    return color(h, lerp(s1, s2, amt), lerp(b1, b2, amt));
  }
  ////////////////////////////// COLOR SWAP //////////////////////////////////
  boolean colSwap;
  void colorSwap(float spd) {
    int t = int(millis()/70*spd % 2);
    int colA = c;
    int colB = flash;
    if ( t == 0) {
      colSwap = true;
      c = colB;
      flash = colA;
    } else colSwap = false;
  } 
  ////////////////////////////// COLOR FLIP //////////////////////////////////
  boolean colFlip;
  void colorFlip(boolean toggle) {
    int colA = c;
    int colB = flash;
    if (toggle) {
      c = colB;
      flash = colA;
    }
  }
  ///////////////////////////////////////// CLASH COLOR SETUP /////////////////////////////////
  void clash(float func) { 
    clash = lerpColorHSB(c, flash, func*0.2);           ///// MOVING, HALF RNAGE BETWEEN C and FLASH
    clash1 = lerpColorHSB(c, flash, 1-(func*0.2));      ///// MOVING, HALF RANGE BETWEEN FLASH and C
    clashed = lerpColor(c, flash, 0.2);                 ///// STATIC - HALFWAY BETWEEN C and FLASH
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void addAnim(int animindex) {
      Anim anim = new Anim(this);
      switch (animindex) {
    case 0:  
      anim = new Rush(this);
      break;
    case 1:  
        anim=new Anim0(this);
      break;
    case 2:  
      anim = new SquareNuts(this);
      break;
    case 3:  
      anim = new Stars(this);
      break;
    case 4:  
      anim = new Checkers(this);
      break;
    case 5:  
      anim = new Anim1(this);
      break;
    case 6:  
      anim = new Anim0(this);
      break;
    }
    
    Tup t=new Tup(new float[]{1.0},0);
    try{
      t=this.dimmers.get(animindex);
    }catch(Exception e){};
    if (t != null) anim.dimmerpointer = t;
    this.animations.add(anim);
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void draw() {
    clash(beat);
    drawAnimations();
    ////////////////////// draw colour layer /////////////////////////////////////////////////////////////////////////////////////////////////////
    blendMode(MULTIPLY);
    // this donesnt work anymore....
    if (cc[107] > 0 || keyT['r'] || glitchToggle) bgNoise(colorLayer, 0, 0, cc[7]); //PGraphics layer,color,alpha
    ////

    drawColorLayer();
    blendMode(NORMAL);
    rigInfo();
    removeAnimations();
    cordinatesInfo(this, keyT['q']);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void drawAnimations() {
    blendMode(LIGHTEST);
    for (int i = this.animations.size()-1; i >=0; i--) {                                  // loop  through the list
      Anim anims = this.animations.get(i);  
      anims.drawAnim();           // draw the animation
    }
  }

  void removeAnimations() {
    for (int i = 0; i < this.animations.size(); i++) {                                  // loop  through the list
      while (this.animations.size()>0  && this.animations.get(i).deleteme) animations.remove(i);           // remove the animations with deleteme = true
    }
  }
}

void cordinatesInfo(Rig rig, boolean _info) {
  if (_info) {
    textSize(12);
    textAlign(CENTER);
    fill(360);  
    for (int i = 0; i < rig.position.length; i++) text(i, rig.size.x-(rig.wide/2)+rig.position[i].x, rig.size.y-(rig.high/2)+rig.position[i].y);   /// mirrors Position info
    fill(200);  
    for (int i = 0; i < rig.positionX.length; i++) {
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][0].x, rig.size.y-(rig.high/2)+rig.positionX[i][0].y);   /// mirrors Position info
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][1].x, rig.size.y-(rig.high/2)+rig.positionX[i][1].y);   /// mirrors Position info
      text(i+".", rig.size.x-(rig.wide/2)+rig.positionX[i][2].x, rig.size.y-(rig.high/2)+rig.positionX[i][2].y);   /// mirrors Position info
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
PApplet getparent () {
 try {
 return (PApplet) getClass().getDeclaredField("this$0").get(this);
 }
 catch (ReflectiveOperationException cause) {
 throw new RuntimeException(cause);
 }
 }
 */
