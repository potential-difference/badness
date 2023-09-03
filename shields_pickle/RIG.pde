enum RigType{
    Shields,Lanterns,Diamonds,
    OutsideGround,OutsideRoof,
    MegaSeedA,MegaSeedB,MegaSeedC,
    TipiLeft,TipiRight,TipiCentre,
    FrontCans,
    Bar,Mirrors,Cans,Strips,Seeds,Pars,
    Booth,Dig,UvPars,Filaments,MegaWhite,
    BoothCans,
    Test
}
public class Rig {
  RigType type;
  OPCGrid opcgrid;
  float dimmer, alphaRate, functionRate, colorSwapRate,
  blurriness,
  functionChangeRate, alphaChangeRate, backgroundChangeRate,
  manualAlpha, bgNoise;
  int wide, high, 
  alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, 
  bgIndex, vizIndex, 
  alphaTimer, functionTimer, vizTimer, bgTimer, lastColorSwapTime; // TODO check on lastCOlorSwapTime
  PGraphics colorLayer, buffer, pass1, pass2;
  IntCoord size;
  color c, flash, c1, flash1, 
  clash, clash1, clashed, 
  colorIndexA = 0, colorIndexB = 1, 
  colA, colB, colC, colD, 
  scol1, scol2, scol3;
  color col[] = new color[15];
  ArrayList <PVector> pixelPosition;       // TODO change from pistion[] to this
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  boolean firsttime_sketchcolor=true, noiseToggle,
  playWithYourSelf = true,
  vizHold, colHold, bgHold,
  onBeat=true; //add animations on a new beat
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

    backgroundNames = new String[] {"one col c", "vert mirror grad", "side by side", "horiz mirror grad", 
    "one color flash", "moving horiz grad", "checked", "radiators", "stripes", "one two three"}; 

    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);          // where this is the rig object
    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;
    availableBkgrnds = new int[] {0, 1, 2, 3};    // default - changed when initalised;
    availableAlphaEnvelopes = new int[] {0, 1};   // default - changed when initalised; 
    availableFunctionEnvelopes = new int[] {0, 1, 2, 5, 6};  // default - changed when initalised;

    // setup grid of positons - TODO this needs work
    int xw = 2;
    for (int i = 0; i < position.length/xw; i++) position[i] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*1);
    for (int i = 0; i < position.length/xw; i++) position[i+(position.length/xw)] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*2);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i=0; i<positionX.length; i++)  positionX[i][0] = new PVector(wide/(positionX.length)*(i+0.5), high/6*1);
    for (int i=0; i<positionX.length; i++)  positionX[i][1] = new PVector(wide/(positionX.length)*(i+0.5), high/4*2);
    for (int i=0; i<positionX.length; i++)  positionX[i][2] = new PVector(wide/(positionX.length)*(i+0.5), high/6*5);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    createGraphicLayers();
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////// COLOR ARRAY ARRANGEMENT ///////////////////////////////////
    if (firsttime_sketchcolor) {
      colorSetup();                        // setup colors red bloo etc once
      firsttime_sketchcolor = false;
    }
    availableColors = new int[] { 0, 1, 2, 3, 13, 10, 11, 12, 2, 3}; /// ALWAYS DO FIRST!! ////////////
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
    //////////////////////////////////////////////////////////////////////////////////////////////////  
  }
  Rig init_grid(Class<?> opcgrid){ return this;}
  //////////////////////////////////////////////////////////////////////////////////////////////////
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
      ////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////////
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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////  COLOUR LAYERS FOR RIG /////////////////////////////////////////
 //  void addAnim(){ this.addAnim(this.vizIndex);}

  void drawColorLayer(int backgroundIndex) {
    
    int index = this.availableBkgrnds[backgroundIndex];    
    colorLayer.beginDraw();
    colorLayer.noStroke();
    colorLayer.background(0);
    
    if (type == RigType.Shields){    
      switch (index) {
        case 0:
          oneColour(c);
          break;
        case 1:
          oneColour(flash);
          break;
        case 2:
          radialGradient(flash, c, sine);
          break;
        case 8:
          radialGradient(flash, c, beat);
          break;
        case 3:
          radialGradient(c, flash, beat);
          bigShield(c, flash);
          balls(clash);
          break;
        case 4:
          oneColour(c);
          bigShield(flash, flash);
          break;
        case 5:
          oneColour(flash);
          bigShield(c, clash);
          break;
        case 6:
          oneColour(c);
          bigShield(clash, clashed);
          mediumShield(flash, flash);
          smallShield(c);
          balls(clash1);
          break;
        case 7:
          everyOtherColor(c,1);
          everyOtherColor(flash,2);
          everyOtherColor(clashed,3);
          break;
        default:
          oneColour(c);
          break;
      }
    } else {
       switch (index) {
        case 0:
          oneColour(c);
          break;
        case 1:
          oneColour(flash);
          break;
        case 2:
          radialGradient(flash, c, sine);
          break;
        case 3:
          radialGradient(flash, c, beat);
          break;
        case 4:
          oneColour(c);
          colorLayer.stroke(clashed);
          colorLayer.strokeWeight(2);
          everyOtherColor(c,1);
          everyOtherColor(flash,2);
          everyOtherColor(clashed,3);
          colorLayer.noStroke();
          break;
        case 5:
          verticalMirrorGradientHalfHalf(flash, c, 0.2);
          break;
        case 6:
          verticalMirrorGradientHalfHalf(c, flash, beat);
          break;
        case 7:
          verticalMirrorGradient(flash, c, 0.5);
          break;
        case 8:
          horizontalMirrorGradient(flash, c, 0.5);
          break;
        case 9: 
          horizontalMirrorGradient(c, flash, sine);
          break;
        default:
          oneColour(c);
          break;
      }
    }
    colorLayer.endDraw();
    image(colorLayer, size.x, size.y);
  }

  

  //////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// RADIAL GRADIENT BACKGROUND /////////////////////////////
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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// ONE COLOUR BACKGOUND ///////////////////////////////////
  void oneColour(color col1) {
    // println(type," one colour");
    colorLayer.background(col1);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// EVERY INDEX BACKGOUND ///////////////////////////////////
  void everyOtherColor(color col1, int index) {
    // loop through array list of pixel positions PVectors
    for (int i = 0; i < pixelPosition.size(); i++) {
      PVector pos = pixelPosition.get(i);
      if (i % index == 0) {
        colorLayer.fill(col1);
        colorLayer.ellipse(pos.x, pos.y, 30, 30);
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////// funcitons to draw shields quickly /////////////////////////////////////////
  void drawCircle(PGraphics colorLayer, PVector position, float radius, color col){
    colorLayer.fill(col);
    colorLayer.ellipse(position.x, position.y, radius, radius);
  }

  void drawShield(PGraphics colorLayer, PVector shield, float radius, color col1, color col2) {
    drawCircle(colorLayer, shield, radius, col1);
    drawCircle(colorLayer, shield, radius/2, col2);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// SHIELDS BACKGROUNDS ////////////////////////////////////
  void bigShield( color col1, color col2) {
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // why is this nessessary?!
    // returned this error
    // RIG.pde:214:0:214:0: ClassCastException: class shields_pickle$MegaSeedCGrid cannot be cast to class 
    // shields_pickle$ShieldsOPCGrid (shields_pickle$MegaSeedCGrid and shields_pickle$ShieldsOPCGrid are in unnamed module of loader 'app')
    // need to be careful about which background is used with which rig
    // can we make this idiot proof?!
    colorLayer.fill(col1);  
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, opcGrid.bigShieldRad, opcGrid.bigShieldRad);
    colorLayer.fill(col2);      
    colorLayer.ellipse(colorLayer.width/2, colorLayer.height/2, opcGrid.bigShieldRad/2, opcGrid.bigShieldRad/2);
  }
  void balls(color col1) {
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // why is this nessessary?!
    colorLayer.fill(col1);     
    colorLayer.ellipse(opcGrid.ballA.x, opcGrid.ballA.y, 15, 15);
    colorLayer.ellipse(opcGrid.ballB.x, opcGrid.ballB.y, 15, 15);
    colorLayer.ellipse(opcGrid.ballC.x, opcGrid.ballC.y, 15, 15);
  }
  
  void mediumShield(color col1, color col2) {
    ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(opcgrid);  // fixed typo in variable name
    colorLayer.fill(col1);      
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

   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// VERTICAL MIRROR GRADIENT BACKGROUND ////////////////////////////////////////////////
  void verticalMirrorGradient(color col1, color col2, float func) {
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
  
  /// MIRROR GRADIENT BACKGROUND top one direction - bottom opposite direction ///
  void verticalMirrorGradientHalfHalf(color col1, color col2, float func) {
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
    colorLayer.vertex(colorLayer.width*func, colorLayer.height/2);
    colorLayer.fill(col2);
    colorLayer.vertex(colorLayer.width*func, colorLayer.height);
    colorLayer.fill(col1);
    colorLayer.vertex(0, colorLayer.height);
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

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////
   void rigInfo() {
    /////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// RIG NAME ///////////////////////////////////////////////////
    float textHeight = 16;
    textSize(textHeight);
    float nameWidth = textWidth(type.name());
    int xOffset = 5;
    int yOffset = 15;
    float x = size.x-(wide/2)+xOffset; 
    float y = size.y-(high/2)+textHeight+2;
    fill(360);
    textAlign(LEFT);              // TODO this can be changed to (LEFT,TOP)
    text(type.name(), x, y);      // the actual rig name is wirtten here
    fill(0, 100);
    stroke(rigs.get(0).flash, 60);
    strokeWeight(1);
    rect(x+(nameWidth/2), y-(textHeight/2)+(yOffset/5), nameWidth+(xOffset*2), yOffset*1.5);
    noStroke();
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// ANIM NAME / NUMBER //////////////////////////////////////////
    // TODO add anim.currentAnim index to make this easier to read
    int index = this.availableAnims[vizIndex]; 
    fill(200);
    text("viz: "+index, x, y+20);
    if (this.animations.size() > 0){
      Anim anim = this.animations.get(0);  
      if(debugToggle) text(anim.animName, x, y+40); // TODO this displays the anim name - needs a better position on screen
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// HOLD FUNCTIONS  /////////////////////////////////////////////
    // TODO add anim.currentAnim index to make this easier to read
    x = size.x-(wide/2)+xOffset + 100; 
    y = size.y-(high/2)+textHeight+2;
    fill(200);
    text("vizHold "+vizHold, x, y);
    if(colHold) text("colHold", x+40, y);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// ALPHA / FUNC / BG INFO //////////////////////////////////////////
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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////// COLOR TIMER ///////////////////////////////////////////
  float go = 0;
  boolean change;
  int colorTimer;

  void colorTimer(int steps) {
    if (!change) {
      colA = c;
      colC = flash;
    }
    
    if (millis() / 1000 - colorTimer >= colorChangeTime * 60) { // multiply colorChangeTime by seconds 
      //println("COLOR CHANGE @", hour() + ":" + minute() + ":" + second());
      colorTimer = millis() / 1000;
      change = true;
    } else change = false;
        
    if (change) {
      go = 1;
      colorIndexA = (colorIndexA + steps) % (availableColors.length - 1);
      colB = col[colorIndexA];
      colorIndexB = (colorIndexB + steps) % (availableColors.length - 1);
      colD = col[colorIndexB];
    }
    
    c = col[colorIndexA];
    c1 = col[colorIndexA];
    flash = col[colorIndexB];
    flash1 = col[colorIndexB];

    if (go > 0.1) change = true;
    else change = false;
    
    if (change) {
      c = lerpColorHSB(colB, colA, go);
      flash = lerpColorHSB(colD, colC, go);
    }

    color originalColor1 = c;
    float originalBrightness1 = brightness(originalColor1);
    float adjustedBrightness1 = originalBrightness1 * cc[0][9]; // TODO change this to a variable that is easier to track
    color adjustedColor1 = color(hue(originalColor1), saturation(originalColor1), adjustedBrightness1);

    c = adjustedColor1;

    color originalColor2 = flash;
    float originalBrightness2 = brightness(originalColor2);
    float adjustedBrightness2 = originalBrightness2 * cc[0][13]; // TODO change this to a variable that is easier to track
    color adjustedColor2 = color(hue(originalColor2), saturation(originalColor2), adjustedBrightness2);

    flash = adjustedColor2;

    // TODO these cc[] variables need to be changed to a rig specific dimmer for c & flash
    
    go *= 0.97;
    if (go < 0.01) go = 0.001;
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////// HSB LERP COLOR FUNCTION ///////////////////////////////////
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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////// COLOR SWAP /////////////////////////////////////////////
  // TODO improve the variation on this so that it can be controlled by slider / pad
  // TODO reinstate in PLAY WITH YOURSELF mode
  void colorSwap(float spd) {
    int swap = int(millis()/70*spd % 2);
    println("spd ", spd, "swap: "+swap);
    int colA = c;
    int colB = flash;
    if ( swap == 0) {
      c = colB;
      flash = colA;
    } 
  } 
  //////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////
  // function to flip the colors, happens in rig.draw()
  boolean colFlip;
  void colorFlip() {
    int colA = c;
    int colB = flash;
    if (colFlip) {
      c = colB;
      flash = colA;
      // println(type,"color flip = ", colFlip); // debugging
    } else {
      c = colA;
      flash = colB;
    }
    colFlip = false;
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////// CLASH COLOR SETUP ///////////////////////////////////////////
  void clash(float func) { 
    clash = lerpColorHSB(c, flash, func*0.2);           ///// MOVING, HALF RNAGE BETWEEN C and FLASH
    clash1 = lerpColorHSB(c, flash, 1-(func*0.2));      ///// MOVING, HALF RANGE BETWEEN FLASH and C
    clashed = lerpColor(c, flash, 0.5);                 ///// STATIC - HALFWAY BETWEEN C and FLASH
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////// ADD ANIM //////////////////////////////////////////////
  void addAnim(){ this.addAnim(this.vizIndex);}
  void addAnim(int animIndex) { this.animations.add(animAtIndex(animIndex)); }
    //Object[] classList = new Object[] { new BenjaminsBoxes(this), new StarMesh(this), new Rings(this), new Celtic(this)};
  Anim animAtIndex(int animIndex){
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
    return anim;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////// ANIM FADER ////////////////////////////////////////////

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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////// DRAW ANIM ///////////////////////////////////////////////////
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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////// REMOVE ANIM /////////////////////////////////////////////////
  void removeAnimations() {
    Iterator<Anim> animiter = this.animations.iterator();
    while (animiter.hasNext()) {
      if (animiter.next().deleteme) animiter.remove();
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// RIG DRAW ///////////////////////////////////////////////////
  void draw() {
    //if (beatCounter % 16 == 0) clash(beat); // TODO // this shouldnt happen al the time - need more control over it!
    if (frameCount > 10) playWithYourself(this); 

    if(type != RigType.Test){ 
      drawAnimations();
      blendMode(MULTIPLY);
    }
    if(type == RigType.Test){
      if(debugToggle){
        playWithYourself(this);

    drawAnimations();
        blendMode(MULTIPLY);
      }
    }
    colorFlip();
    clash(beat);    // TODO improve global variable beat - add envelope functionality to this
    // draw a colour layer for all rigs except the filaments & uv pars & MegaWhite - leaving these ones white 
    if(type != RigType.Filaments && type != RigType.UvPars && type != RigType.MegaWhite) drawColorLayer(bgIndex);
    blendMode(NORMAL);
    rigInfo();
    removeAnimations();
    coordinatesInfo(this, debugToggle);
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
