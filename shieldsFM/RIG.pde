enum RigType{
    Shields,Lanterns,Diamonds,MegaSeedA,Bar,MegaSeedB,MegaSeedC,TipiLeft,TipiRight,TipiCentre,OutsideRoof,OutsideGround,Cans,Strips,Seeds,Pars,Booth,Dig,UvPars // rigs
}
//static RigType Shields = RigType.Shields;
public class Rig {
  RigType type;
  OPCGrid opcgrid;
  float dimmer, alphaRate, functionRate, blurriness, bgNoise, manualAlpha, functionChangeRate, alphaChangeRate, backgroundChangeRate;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex, alphaTimer, functionTimer, vizTimer;
  PGraphics colorLayer, buffer, pass1, pass2;
  IntCoord size;
  color c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD, scol1, scol2, scol3;
  color col[] = new color[15];
  ArrayList <PVector> pixelPosition;       // TODO change from pistion[] to this
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  boolean firsttime_sketchcolor=true, noiseToggle, playWithYourSelf = true;
  ArrayList <Anim> animations;
  int[] availableAnims;
  int[] currentAnim;        // TODO implement this
  int[] availableBkgrnds;
  int[] availableAlphaEnvelopes;
  int[] availableFunctionEnvelopes;
  int[] availableColors;
  String[] animNames, backgroundNames, alphaNames, functionNames;
  String riginfo,localcoords,rigcoords, opcgridinfo;
  int arrayListIndex;
  float wideSlider, strokeSlider, highSlider;
  boolean beatTriggered;

  Rig(IntCoord coord, RigType _name) {
    type = _name;
    wide = coord.wide;
    high = coord.high;
    size = coord; //new PVector (coord.x,coord.y);
    pixelPosition = new ArrayList<PVector>();

    riginfo = "wide: "+wide+" high: "+high+" x,y: "+size.x+" "+size.y;
    println("## "+type+" COORDINATES");
    println(riginfo);

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;

    backgroundNames = new String[] {"one col c", "vert mirror grad", "side by side", "horiz mirror grad", 
      "one color flash", "moving horiz grad", "checked", "radiators", "stripes", "one two three"}; 

    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);          // where this is the rig object
    availableBkgrnds = new int[] {0, 1, 2, 3};    // default - changed when initalised;
    availableAlphaEnvelopes = new int[] {0, 1};// 2, 3, 4, 5};  
    availableFunctionEnvelopes = new int[] {0, 1, 2, 5, 6};  

    // setup grid of positons - TODO this needs work
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
    availableColors = new int[] { 0, 1, 2, 3, 13, 10, 11, 12, 2, 3}; /// ALWAYS DO FIRST!! //////////////
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
  ///////////////////////////  COLOUR LAYERS FOR RIG ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // why is this nessessary?!

    colorLayer.noStroke();
    colorLayer.fill(col1);  
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, opcGrid.bigShieldRad, opcGrid.bigShieldRad);
    colorLayer.fill(col2);      
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, opcGrid.bigShieldRad/2, opcGrid.bigShieldRad/2);
  }
  void balls(color col1) {
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // why is this nessessary?!

    colorLayer.fill(col1);     
    colorLayer.noStroke();
    colorLayer.ellipse(opcGrid.ballA.x, opcGrid.ballA.y, 15, 15);
    colorLayer.ellipse(opcGrid.ballB.x, opcGrid.ballB.y, 15, 15);
    colorLayer.ellipse(opcGrid.ballC.x, opcGrid.ballC.y, 15, 15);
  }
  
  void mediumShield(color col1, color col2) {
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // fixed typo in variable name

   colorLayer.fill(col1);      
    colorLayer.noStroke();

    drawShield(colorLayer, opcGrid.medShieldA, opcGrid.medShieldRad, col1, col2);
    drawShield(colorLayer, opcGrid.medShieldB, opcGrid.medShieldRad, col1, col2);
    drawShield(colorLayer, opcGrid.medShieldC, opcGrid.medShieldRad, col1, col2);
  }

  void smallShield(color col1) {
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // fixed typo in variable name

    colorLayer.fill(col1);      
    drawShield(colorLayer, opcGrid.smallShieldA, opcGrid.smallShieldRad, col1, col1);
    drawShield(colorLayer, opcGrid.smallShieldB, opcGrid.smallShieldRad, col1, col1);
    drawShield(colorLayer, opcGrid.smallShieldC, opcGrid.smallShieldRad, col1, col1);
     }

  ////////////////////// funcitons to draw shields quickly /////////////////////
  void drawCircle(PGraphics colorLayer, PVector position, float radius, color col){
    colorLayer.fill(col);
    colorLayer.noStroke();
    colorLayer.ellipse(position.x, position.y, radius, radius);
  }

  void drawShield(PGraphics colorLayer, PVector shield, float radius, color col1, color col2) {
    drawCircle(colorLayer, shield, radius, col1);
    drawCircle(colorLayer, shield, radius/2, col2);
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   void rigInfo() {
    // get the name of each rig and set x y coordiantes for the text
    float textHeight = 16;
    textSize(textHeight);
    float nameWidth = textWidth(type.name());
    int xOffset = 5;
    int yOffset = 15;
    float x = size.x-(wide/2)+xOffset; 
    float y = size.y-(high/2)+textHeight+2;
    // text name for each rig displayed top left of rig
    fill(360);
    textAlign(LEFT); // TODO this can be changed to (LEFT,TOP)
    text(type.name(), x, y);
    // box to draw around the text
    fill(0, 100);
    stroke(rigs.get(0).flash, 60);
    strokeWeight(1);
    rect(x+(nameWidth/2), y-(textHeight/2)+(yOffset/5), nameWidth+(xOffset*2), yOffset*1.5);
    noStroke();
     
    // text showing which is the current anim for each rig
    // TODO add anim.currentAnim index to make this easier to read
    int index = this.availableAnims[vizIndex]; 
    fill(200);
    text("viz: "+index, x, y+20);
    if (this.animations.size() > 0){
      Anim anim = this.animations.get(0);  
      text(anim.animName, x, y+40);
    }

    ///////////// rig info/ ///////////////////////////////////////////////////////////////////
    // fill(rigs.get(0).c1, 200);
    textAlign(LEFT, BOTTOM);
    textSize(14);
    x = size.x-(wide/2)+8; 
    y = size.y+(high/2)+2;    
    text("bg: " + this.availableBkgrnds[bgIndex], x, y);
    text("func: " + availableFunctionEnvelopes[functionIndexA] + " / " + availableFunctionEnvelopes[functionIndexB], x+40, y);
    text("alph: " + availableAlphaEnvelopes[alphaIndexA] + " / " + availableAlphaEnvelopes[alphaIndexB], x+110, y);
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////// SHOW BEAT DETECTION FOR EACH RIG //////////////////////////////////
    // quick n dirty way to show which rigs are detecting which beats.
    // TODO turn this in to a visual sequencer
    int rctsz = 12;
    x = size.x+(wide/2)-(rctsz/2);
    y = size.y+(high/2)+(rctsz/2);
    strokeWeight(1);
    stroke(rigs.get(0).c1,200);
    noFill();
    if (beatTriggered) fill(rigs.get(0).flash1,200); 
    rect(x,y-rctsz,rctsz,rctsz); // beatTriggered is per rig
    noStroke();
    beatTriggered = false;
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// RECTANGLES TO SHOW CURRENT COLOURS //////////////////////////////////
    // size of the coloured rectangle: scallable now
    rctsz = 10;
    x = size.x+(wide/2)-(rctsz*2)-(rctsz/2);
    y = size.y-(high/2)+(rctsz*2);
    // blackout area under rectangles
    fill(0);                              
    rect(x, y-(rctsz), rctsz, rctsz);            // rect to show CURRENT color C 
    rect(x+(rctsz/2), y-rctsz, rctsz, rctsz);    // rect to show NEXT color C 
    rect(x, y, rctsz, rctsz);                    // rect to show CURRENT color FLASH 
    rect(x+(rctsz/2), y, rctsz, rctsz);          // rect to show NEXT color FLASH1
    // box surrounding rectangles
    fill(0, 100);
    stroke(rigs.get(0).flash, 60);
    strokeWeight(1);
    rect(x+(rctsz*0.75), y-(rctsz/2), (rctsz*3)+(rctsz/2), (rctsz*3));
    // rectangles to show colours
    stroke(0);
    fill(this.c);          
    rect(x, y-(rctsz), rctsz, rctsz);                             // rect to show CURRENT color C 
    fill(this.col[(this.colorIndexA+1)%this.col.length], 100);
    rect(x+(rctsz*1.5), y-rctsz, rctsz, rctsz);                   // rect to show NEXT color C 
    fill(this.flash);
    rect(x, y, rctsz, rctsz);                                     // rect to show CURRENT color FLASH 
    fill(this.col[(this.colorIndexB+1)%this.col.length], 100);  
    rect(x+(rctsz*1.5), y, rctsz, rctsz);                         // rect to show NEXT color FLASH1
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
    if (millis()/1000 - colorTimer >= colTime*60) {
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


  //decayRate: higher is slower
  //curve: 0.5 is linear, 0.0 is u shaped 1.0 is n shaped 
  //think of it like control points on a bezier

  void animFader(float decayRate,float curve){
    int now = millis();
    for (int i = 0; i < this.animations.size()-1; i++) {   // loop  through the list excluding the last one added
      Anim an = this.animations.get(i);  
      int time_leftA = (int)((an.alphaEnvelopeA.end_time - now)*decayRate);
      int time_leftB = (int)((an.alphaEnvelopeB.end_time - now)*decayRate);
      an.alphaEnvelopeA = an.alphaEnvelopeA.mul(new Ramp(now,now+time_leftA,1.0,0.1,0.01));
      an.alphaEnvelopeB = an.alphaEnvelopeB.mul(new Ramp(now,now+time_leftB,1.0,0.1,0.01));
      an.alphaEnvelopeA.end_time = now + time_leftA;
      an.alphaEnvelopeB.end_time = now + time_leftB;
    }
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
    //TODO set this to a toggle so touchosc can turn it on and off.
    if (true) {
      //decayRate: higher is slower
      //curve: 0.5 is linear, 0.0 is u shaped 1.0 is n shaped 
      //think of it like control points on a bezier
      animFader(0.9,0.1);
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
    if (beatCounter % 16 == 0) clash(beat); // TODO // this shouldnt happen al the time - need more control over it!
    drawAnimations();
    blendMode(MULTIPLY);
    // this donesnt work anymore....
    if (cc[107] > 0 || keyT['r']) bgNoise(colorLayer, 0, 0, cc[55]); //PGraphics layer,color,alpha
   
    // TODO this can be used to draw white animations
    // if(type != RigType.booth) drawColorLayer(bgIndex);
    drawColorLayer(bgIndex);

    blendMode(NORMAL);
    rigInfo();
    removeAnimations();
    coordinatesInfo(this, keyT['e']);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
