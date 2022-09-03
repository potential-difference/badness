/*
public class ShieldsRig extends Rig{
    ShieldsRig(float _xpos, float _ypos, int _wide, int _high, String _name) {
      super(_rig);
      PVector bigShield;
      PVector[] mediumShield = new PVector[3];
      PVector[] smallShield = new PVector[3];
      PVector[] balls = new PVector[3];
    }
      

}
*/
public class Rig {
  float dimmer, alphaRate, functionRate, blurriness, bgNoise, manualAlpha, functionChangeRate, alphaChangeRate, backgroundChangeRate;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex, alphaTimer, functionTimer;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  color c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD, scol1, scol2, scol3;
  color col[] = new color[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  boolean firsttime_sketchcolor=true, toggle, noiseToggle, playWithYourSelf = true;
  ArrayList <Anim> animations;
  int[] availableAnims;
  int[] availableBkgrnds;
  int[] availableAlphaEnvelopes;
  int[] availableFunctionEnvelopes;
  int[] availableColors;
  String[] animNames, backgroundNames, alphaNames, functionNames;
  int arrayListIndex;
  float wideSlider, strokeSlider, highSlider, decaySlider;
  Rig(float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;
    backgroundNames = new String[] {"one col c", "vert mirror grad", "side by side", "horiz mirror grad", 
      "one color flash", "moving horiz grad", "checked", "radiators", "stripes", "one two three"}; 

    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);          // where this is the rig object
    availableBkgrnds = new int[] {0, 1, 2, 3};    // default - changed when initalised;
    availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5};  
    availableFunctionEnvelopes = new int[] {0, 1, 2, 5, 6};  

    int xw = 2;
    for (int i = 0; i < position.length/xw; i++) position[i] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*1);
    for (int i = 0; i < position.length/xw; i++) position[i+(position.length/xw)] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*2);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i=0; i<positionX.length; i++)  positionX[i][0] = new PVector(wide/(positionX.length)*(i+0.5), high/6*1);
    for (int i=0; i<positionX.length; i++)  positionX[i][1] = new PVector(wide/(positionX.length)*(i+0.5), high/4*2);
    for (int i=0; i<positionX.length; i++)  positionX[i][2] = new PVector(wide/(positionX.length)*(i+0.5), high/6*5);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    createGraphicLayers();
    /////////////////////////////////////// COLOR ARRAY ARRANGEMENT ////////////////////////////////////////
    if (firsttime_sketchcolor) {
      colorSetup();                        // setup colors red bloo etc once
      firsttime_sketchcolor = false;
    }
    availableColors = new int[] { 0, 1, 2, 3, 13, 10, 11, 12, 2, 3};
    col[0] = teal; 
    col[1] = orange; 
    col[2] = pink; 
    col[3] = purple;
    col[4] = bloo;
    col[5] = pink1;
    col[6] = orange;
    col[7] = pink;
    col[8] = orange;
    col[9] = bloo;
    col[10] = purple1;
    col[11] = pink1;
    col[12] = orange;
    col[13] = orange1;
    col[14] = teal;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void createGraphicLayers(){
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
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void drawColorLayer(int backgroundIndex) {
    int index = this.availableBkgrnds[backgroundIndex];
    switch(index) {
      case 0:
        colorLayer.beginDraw();
        colorLayer.background(0);
        oneColour(c);
        colorLayer.endDraw();
        break;
      case 1:
        colorLayer.beginDraw();
        colorLayer.background(0);
        oneColour(flash);
        colorLayer.endDraw();
        break;
      case 2:
        colorLayer.beginDraw();
        colorLayer.background(0);
        radialGradient(flash, c, sine);
        colorLayer.endDraw();
        break;
      case 3:
        colorLayer.beginDraw();
        colorLayer.background(0);
        radialGradient(c, flash, beat);
        bigShield(c, flash);
        balls(clash);
        colorLayer.endDraw();
        break;
      case 4:
        colorLayer.beginDraw();
        colorLayer.background(0);
        oneColour(c);
        bigShield(flash, flash);
        colorLayer.endDraw();
        break;
      case 5:
        colorLayer.beginDraw();
        colorLayer.background(0);
        oneColour(flash);
        bigShield(c, clash);
        colorLayer.endDraw();
        break;
      case 6:
        colorLayer.beginDraw();
        colorLayer.background(0);
        oneColour(c);
        bigShield(clash, clashed);
        mediumShield(flash, flash);
        smallShield(c);
        balls(clash1);
        colorLayer.endDraw();
        break;
      default:
        colorLayer.beginDraw();
        colorLayer.background(0);
        oneColour(c);
        colorLayer.endDraw();
        break;
      }
    blendMode(MULTIPLY);
    image(colorLayer, size.x, size.y);
  }
  ///////////////////////////////////////// RADIAL GRADIENT BACKGROUND //////////////////////////////////////////////////////////
  void radialGradient(color col1, color col2, float function) {
    colorLayer.background(col1);
    float radius = colorLayer.height*function; //*function;
    int numberofpoints = 12;
    float angle=360/numberofpoints;
    //float rotate = 90+(function*angle);
    float rotate = -30+(function*angle);
    for (  int i = 0; i < numberofpoints; i++) {
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
  ///////////////////////////////////////// ONE COLOUR BACKGOUND //////////////////////////////////////////////////////////////////////////
  void oneColour(color col1) {
    colorLayer.background(col1);
  }
  ///////////////////////////////////////// SHIELDS BACKGROUNDS /////////////////////////////////////////////////////////////////////////////////////////////
  void bigShield( color col1, color col2) {
    colorLayer.noStroke();
    colorLayer.fill(col1);      
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, shieldsGrid.bigShieldRad, shieldsGrid.bigShieldRad);
    colorLayer.fill(col2);      
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, shieldsGrid.bigShieldRad/2, shieldsGrid.bigShieldRad/2);
  }
  void balls(color col1) {
    colorLayer.fill(col1);     
    colorLayer.noStroke();
    colorLayer.ellipse(shieldsGrid.shields[7].x, shieldsGrid.shields[7].y, 15, 15);
    colorLayer.ellipse(shieldsGrid.shields[8].x, shieldsGrid.shields[8].y, 15, 15);
    colorLayer.ellipse(shieldsGrid.shields[9].x, shieldsGrid.shields[9].y, 15, 15);
  }
  void mediumShield(color col1, color col2) {
    colorLayer.fill(col1);      
    colorLayer.noStroke();
    colorLayer.ellipse(shieldsGrid.shields[0].x, shieldsGrid.shields[0].y, shieldsGrid.medShieldRad, shieldsGrid.medShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[1].x, shieldsGrid.shields[1].y, shieldsGrid.medShieldRad, shieldsGrid.medShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[2].x, shieldsGrid.shields[2].y, shieldsGrid.medShieldRad, shieldsGrid.medShieldRad);

    colorLayer.fill(col2);      
    colorLayer.ellipse(shieldsGrid.shields[0].x, shieldsGrid.shields[0].y, shieldsGrid.medShieldRad/2, shieldsGrid.medShieldRad/2);
    colorLayer.ellipse(shieldsGrid.shields[1].x, shieldsGrid.shields[1].y, shieldsGrid.medShieldRad/2, shieldsGrid.medShieldRad/2);
    colorLayer.ellipse(shieldsGrid.shields[2].x, shieldsGrid.shields[2].y, shieldsGrid.medShieldRad/2, shieldsGrid.medShieldRad/2);
  }
  void smallShield(color col1) {
    colorLayer.fill(col1);      
    colorLayer.ellipse(shieldsGrid.shields[3].x, shieldsGrid.shields[3].y, shieldsGrid.smallShieldRad, shieldsGrid.smallShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[4].x, shieldsGrid.shields[4].y, shieldsGrid.smallShieldRad, shieldsGrid.smallShieldRad);
    colorLayer.ellipse(shieldsGrid.shields[5].x, shieldsGrid.shields[5].y, shieldsGrid.smallShieldRad, shieldsGrid.smallShieldRad);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   void rigInfo() {
    float textHeight = 18;
    textSize(textHeight);
    float nameWidth = textWidth(name);
    float x = size.x+(wide/2)-(nameWidth/2)-12;
    float y = size.y-(high/2)+21;

    fill(360);
    textAlign(CENTER);
    textLeading(18);
    text(name, x, y);

    fill(0, 100);
    stroke(rigg.flash, 60);
    strokeWeight(1);
    rect(x, y-(textHeight/2)+3, nameWidth+17, 30);
    noStroke();
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    x = x-(nameWidth+17);
    y = size.y-(high/2)+20;

    ///// RECTANGLES TO SHOW CURRENT COLOURS /////
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
      colorIndexA =  (colorIndexA + steps) % (availableColors.length-1);
      colB =  col[colorIndexA];
      colorIndexB = (colorIndexB + steps) % (availableColors.length-1);
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
   void addAnim(int animIndex) {
    //Object[] classList = new Object[] { new BenjaminsBoxes(this), new StarMesh(this), new Rings(this), new Celtic(this)};

    Anim anim = new Anim(this);
    int index = this.availableAnims[animIndex];
    switch (index) {
    case 0:  
      anim = new BenjaminsBoxes(this);
      break;
    case 1:  
      anim = new StarMesh(this);
      break;
    case 2:  
      anim = new Rings(this);
      break;
    case 3:  
      anim = new Celtic(this);
      break;
    case 4:  
      anim = new SpiralFlower(this);
      break;
    case 5:  
      anim = new TwistedStar(this);
      break;
    case 6:  
      anim = new Stars(this);
      break;
    case 7:  
      anim = new SingleDonut(this);
      break;
    case 8:  
      anim = new BouncingDonut(this);
      break;
    case 9:  
      anim = new BouncingPolo(this);
      break;
    case 10:  
      anim = new Polo(this);
      break;
    case 11:  
      anim = new SquareNuts(this);
      break;
    case 12:  
      anim = new DiagoNuts(this);
      break;
    case 13:
      anim = new AllOn(this);
      break;
    case 14:
      anim = new AllOff(this);
      break;
    }
    this.animations.add(anim);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void drawAnimations() {
    blendMode(LIGHTEST);
    for (int i = this.animations.size()-1; i >=0; i--) {                                  // loop  through the list
      Anim anim = this.animations.get(i);  
      anim.drawAnim();           // draw the animation
    }
    /// alter all but the most recent animations
    if (testToggle) {
      for (int i = 0; i < this.animations.size()-1; i++) {   // loop  through the list excluding the last one added
        int animIndex = i;
        Anim an = this.animations.get(animIndex);  
        int now = millis();
        an.overalltime*=0.9;
        }
    }
  }

  void removeAnimations() {
    Iterator<Anim> animiter = this.animations.iterator();
    while (animiter.hasNext()) {
      if (animiter.next().deleteme) animiter.remove();
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void draw() {
    clash(beat);
    drawAnimations();
    blendMode(MULTIPLY);
    // this donesnt work anymore....
    if (cc[107] > 0 || keyT['r']) bgNoise(colorLayer, 0, 0, cc[55]); //PGraphics layer,color,alpha
    drawColorLayer(bgIndex);

    blendMode(NORMAL);
    rigInfo();
    removeAnimations();
    cordinatesInfo(this, keyT['e']);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
