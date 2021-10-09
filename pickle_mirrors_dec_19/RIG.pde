public class Rig {
  float dimmer, alphaRate, funcRate, blurValue, bgNoise, manualAlpha, beatSlider; 
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  color c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD, scol1, scol2, scol3;
  color col[] = new color[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  boolean firsttime_sketchcolor=true, toggle, noiseToggle, play;
  ArrayList <Anim> animations;
  HashMap<Integer, Ref> dimmers;
  int[] availableAnims;
  int[] availableBkgrnds;
  int[] availableAlphaEnvelopes;
  int[] availableFunctionEnvelopes;
  int[] availableColors;
  String[] animNames, backgroundNames, alphaNames, functionNames;
  int arrayListIndex;
  float infoX, infoY;
  ControlP5 cp5;
  PApplet parent;
  ScrollableList ddVizList, ddBgList, ddAlphaList, ddFuncList, ddAlphaListB, ddFuncListB;
  RadioButton cRadioButton, flashRadioButton;

  Rig(boolean _toggle, float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);
    toggle = _toggle;

    this.cp5 = controlFrame.cp5;

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;

    animNames = new String[] {"benjmains boxes", "checkers", "rings", "rush", "rushed", 
      "square nuts", "diaganol nuts", "stars", "swipe", "swiped", "teeth", "donut", "all on", "all off"}; 
    backgroundNames = new String[] {"one col c", "vert mirror grad", "side by side", "horiz mirror grad", 
      "one color flash", "moving horiz grad", "checked", "radiators", "stripes", "one two three"}; 

    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);          // where this is the rig object
    availableBkgrnds = new int[] {0, 1, 2, 3};    // default - changed when initalised;
    availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5};  
    availableFunctionEnvelopes = new int[] {0, 1, 2, 5, 6};  

    //dimmers = new HashMap<Integer, Ref>();

    int xw = 2;
    for (int i = 0; i < position.length/xw; i++) position[i] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*1);
    for (int i = 0; i < position.length/xw; i++) position[i+(position.length/xw)] = new PVector (wide/(position.length/xw+1)*(i+1), high/(xw+1)*2);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    for (int i=0; i<positionX.length; i++)  positionX[i][0] = new PVector(wide/(positionX.length)*(i+0.5), high/6*1);
    for (int i=0; i<positionX.length; i++)  positionX[i][1] = new PVector(wide/(positionX.length)*(i+0.5), high/4*2);
    for (int i=0; i<positionX.length; i++)  positionX[i][2] = new PVector(wide/(positionX.length)*(i+0.5), high/6*5);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    /////////////////////////////////////// COLOR ARRAY ARRANGEMENT ////////////////////////////////////////
    if (firsttime_sketchcolor) {
      colorSetup();                        // setup colors red bloo etc once
      firsttime_sketchcolor = false;
    }
    availableColors = new int[] { 0, 1, 2, 3, 4, 5, 6};
    col[0] = teal; 
    col[1] = orange; 
    col[2] = pink; 
    col[3] = purple;
    col[4] = bloo;
    col[5] = red;
    col[6] = grin;
    col[7] = pink;
    col[8] = orange;
    col[9] = bloo;
    col[10] = purple;
    col[11] = pink;
    col[12] = orange;
    col[13] = orange1;
    col[14] = teal;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    ////////////////////////////// LOAD CONTROLLERS //////////////////////////////////////////////////////////////////////////////
    int clm = 300;           // distance between coloms
    float x = clm;
    float y = 90;
    int swide = 80;           // x size of sliders
    int shigh = 14;           // y size of slider
    int row = shigh+4;       // distance between rows
    ///////////////////////////////// SLIDERS  ///////////////////////////////////////////////////////////////////////////////////
    loadSlider( "dimmer", x+(clm*arrayListIndex), y+(0*row), swide, shigh, 0, 1, dimmer, act1, bac1, slider1);
    loadSlider( "alphaRate", x+(clm*arrayListIndex), y+(1*row), swide, shigh, 0, 1, 0.5, act, bac, slider);
    loadSlider( "funcRate", x+(clm*arrayListIndex), y+(2*row), swide, shigh, 0, 1, 0.5, act1, bac1, slider1);
    loadSlider( "blurValue", x+(clm*arrayListIndex), y+(3*row), swide, shigh, 0, 1, 0.5, act, bac, slider);
    loadSlider( "bgNoise", x+(clm*arrayListIndex), y+(4*row), swide, shigh, 0, 1, 0.5, act1, bac1, slider1);
    loadSlider( "manualAlpha", x+(clm*arrayListIndex), y+(5*row), swide, shigh, 0, 1, 0.8, act, bac, slider);
    loadSlider( "beatSlider", x+(clm*arrayListIndex), y+(6*row), swide, shigh, 0, 1, 0.2, act1, bac1, slider1);
    ///////////////////////////////// TOGGLES  ///////////////////////////////////////////////////////////////////////////////////
    loadToggle(noiseToggle, "noiseToggle", x+(clm*arrayListIndex), y+row*7.5, swide, 10);
    loadToggle(toggle, "toggle", x+(clm*arrayListIndex), y+row*9, swide-30, 20);
    loadToggle(play, "play", x+(clm*arrayListIndex)+swide-25, y+row*9, 25, 20);
    ///////////////////////////////// RADIO BUTTONS  //////////////////////////////////////////////////////////////////////////////
    cRadioButton = cp5.addRadioButton(name+" cRadioButton")
      //.plugTo(this, "cRadioButton")
      //.setLabel(this.name+" cRadioButton")
      .setPosition(x+(clm*arrayListIndex)-130, y)
      .setSize(15, shigh);
    for (int i=0; i<availableColors.length; i++) {
      cRadioButton.addItem(name+" colc "+i, i);
      cRadioButton.getItem(name+" colc "+i)
        .setColorBackground(color(col[availableColors[i]], 100))
        .setColorForeground(color(col[availableColors[i]], 200))
        .setColorActive(color(col[availableColors[i]], 360));
      cRadioButton.hideLabels();
    }

    flashRadioButton = cp5.addRadioButton(name+" flashRadioButton")
      //.plugTo(this, "flashRadioButton")
      //.setLabel(this.name+" flashRadioButton")
      .setPosition(x+(clm*arrayListIndex)-110, y)
      .setSize(15, shigh);
    for (int i=0; i<availableColors.length; i++) {
      flashRadioButton.addItem(name+" colFlash "+i, i);
      flashRadioButton.getItem(name+" colFlash "+i)
        .setColorBackground(color(col[availableColors[i]], 100))
        .setColorForeground(color(col[availableColors[i]], 200))
        .setColorActive(color(col[availableColors[i]], 360));
      flashRadioButton.hideLabels() ;
    }
    ///////////////////////////////// DROPDOWN LISTS //////////////////////////////////////////////////////////////////////////////
    ddVizList = cp5.addScrollableList(name+" vizLizt").setPosition(x+(clm*arrayListIndex)-90, y);
    ddBgList = cp5.addScrollableList(name+" bkList").setPosition(x+(clm*arrayListIndex)-90, y+25);
    ddAlphaList = cp5.addScrollableList(name+" alpahLizt").setPosition(x+(clm*arrayListIndex)-90, y+60);
    ddFuncList = cp5.addScrollableList(name+" funcLizt").setPosition(x+(clm*arrayListIndex)-90, y+85);

    ddAlphaListB = cp5.addScrollableList(name+" alpahLiztB").setPosition(x+(clm*arrayListIndex)-45, y+60);
    ddFuncListB = cp5.addScrollableList(name+" funcLiztB").setPosition(x+(clm*arrayListIndex)-45, y+85);

    // the order of this has to be oppostie to the order they are displayed on screen
    customize(ddFuncListB, color(bac1, 200), bac, act, 40, "funcB");     // customize the list
    customize(ddAlphaListB, color(bac1, 200), bac, act, 40, "alphB");   // customize the list
    customize(ddFuncList, color(bac1, 200), bac, act, 40, "funcA");     // customize the list
    customize(ddAlphaList, color(bac1, 200), bac, act, 40, "alphA");   // customize the list

    customize(ddBgList, color(bac, 200), bac1, act, 85, name+" bkgrnd");       // customize the list
    customize(ddVizList, color(bac, 200), bac1, act, 85, name+" viz");       // customize the list

    /////////  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void loadToggle(boolean toggle, String label, float x, float y, int wide, int high) {
    cp5.addToggle(this.name+" "+label)
      .plugTo(this, label)
      .setLabel(label)
      .setPosition(x, y)
      .setSize(wide, high)      
      .setValue(toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(act) 
      ;
  }

  void loadSlider(String label, float x, float y, int wide, int high, float min, float max, float startVal, color act1, color bac1, color slider1) {
    cp5.addSlider(name+" "+label)
      //.setLabel(label)
      .plugTo(this, label)
      .setPosition(x, y)
      .setSize(wide, high)
      .setRange(min, max)
      .setValue(startVal)    // start value of slider
      .setColorActive(color(act1, 200)) 
      .setColorBackground(color(bac1, 200)) 
      .setColorForeground(color(slider1, 200)) 
      ;
  }

  void customize(ScrollableList ddl, color bac, color bac1, color act, int wide, String label) {
    ddl.setBackgroundColor(0); // color behind list - can hardly see it
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.setWidth(wide);
    ddl.setCaptionLabel(label);
    for (int i=0; i<availableAnims.length; i++) ddl.addItem(label+i, i);
    ddl.setColorBackground(color(bac, 300));       // background color
    ddl.setColorActive(200);           // clicked color
    ddl.setColorCaptionLabel(#FFFAFA) ;
    ddl.setColorForeground(bac1) ;      // highlight color
    ddl.setColorLabel(#FFFAFA) ;       // text color for label
    ddl.close();
    ddl.bringToFront();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void drawColorLayer() {
    int index = availableBkgrnds[bgIndex];
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
      break;
    case 8:
      colorLayer.beginDraw();
      colorLayer.background(0);
      stripes(c, flash);
      colorLayer.endDraw();
      break;
    case 9:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneTwoThree(c, flash);
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
    /*
    if (syphonToggle) { 
     if (syphonImageReceived != null) image(syphonImageReceived, size.x, size.y, wide, high);
     } else 
     */
    image(colorLayer, size.x, size.y);
  }
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
    for (int i = 0; i < opcGrid.rad.length; i++) colorLayer.rect(this.position[i].x, this.position[i].y, 15, this.high/2.2);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void check(color col1, color col2) {
    colorLayer.fill(col2);
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width, colorLayer.height);        
    colorLayer.fill(col1);  
    for (int i = 0; i < position.length/2; i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    for (int i = position.length/2+1; i < position.length; i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    //if (opcGrid.rows == 3) for (int i = opcGrid.columns*opcGrid.rows; i < opcGrid.mirror.length/opcGrid.rows+(opcGrid.columns*2); i+=2)  colorLayer.rect(position[i].x, position[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void sideBySide( color col1, color col2) {
    colorLayer.fill(col2);
    colorLayer.rect(colorLayer.width/4, colorLayer.height/2, colorLayer.width/2, colorLayer.height);     
    colorLayer.fill(col1);                                
    colorLayer.rect(colorLayer.width/4*3, colorLayer.height/2, colorLayer.width/2, colorLayer.height);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void oneTwoThree( color col1, color col2) {
    colorLayer.background(col1);
    colorLayer.fill(col2);                                
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width/3*2, colorLayer.height);
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void stripes( color col1, color col2) {
    colorLayer.background(col1);
    colorLayer.fill(col2);                                
    colorLayer.rect(colorLayer.width/2, colorLayer.height/2, colorLayer.width/3, colorLayer.height);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void rigInfo() {

    float textHeight = 18;
    textSize(textHeight);

    float nameWidth = textWidth(name);
    float x = size.x+(wide/2)-(nameWidth/2)-12;
    float y = size.y-(high/2)+21;

    if (this == cans) y -=30;;

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
    
    if (this == cans) y -=30;;

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
  void addAnim(int animIndex) {
    Anim anim = new Anim(this);

    //    println(name+" aval anims");
    //println(availableAnims);
    int index = this.availableAnims[animIndex];

    //println(name+" index", index);
    //println();

    switch (index) {
    case 0:  
      anim = new BenjaminsBoxes(this);
      break;
    case 1:  
      anim = new Checkers(this);
      break;
    case 2:  
      anim = new Rings(this);
      break;
    case 3:  
      anim = new Rush(this);
      break;
    case 4:  
      anim = new Rushed(this);
      break;
    case 5:  
      anim = new SquareNuts(this);
      break;
    case 6:  
      anim = new DiagoNuts(this);
      break;
    case 7:  
      anim = new Stars(this);
      break;
    case 8:  
      anim = new Swipe(this);
      break;
    case 9:  
      anim = new Swiped(this);
      break;
    case 10:  
      anim = new Teeth(this);
      break;
    case 11:  
      anim = new Donut(this);
      break;
    case 12:
      anim = new AllOn(this);
      break;
    case 13:
      anim = new AllOff(this);
      break;
    }
    //    Ref t=new Ref(new float[]{1.0}, 0);
    //    if (t != null) anim.animDimmer = anim.animDimmer.mul(t);

    // ramp out all previous anims
    if (testToggle) {
      for (Anim an : animations) {
        float now = millis();
        if (alphaIndexA == 1) {
          an.alphaEnvelopeA = new Ramp(now, now+avgmillis*alphaRate*3.0, an.alphaA, an.alphaA, 0.9).mul(new Ramp(now+avgmillis*alphaRate*3.0, now+avgmillis*alphaRate*4.0, 1.0, 0.1, 0.1));
        } else {
          an.alphaEnvelopeA = an.alphaEnvelopeA.mul(new Ramp(now, now+avgmillis*alphaRate*3.0, 0.8, 0.2, 0.1));
          an.alphaEnvelopeA.end_time = min(int(now+avgmillis*alphaRate*5.0), an.alphaEnvelopeA.end_time);
        }
        if (alphaIndexB == 1) {
          an.alphaEnvelopeB = new Ramp(now, now+avgmillis*alphaRate*3.0, an.alphaB, an.alphaB, 0.9).mul(new Ramp(now+avgmillis*alphaRate*3.0, now+avgmillis*alphaRate*4.0, 1.0, 0.1, 0.1));
        } else {       
          an.alphaEnvelopeB = an.alphaEnvelopeB.mul(new Ramp(now, now+avgmillis*alphaRate*3.0, 0.9, 0.2, 0.1));
          an.alphaEnvelopeB.end_time = min(int(now+avgmillis*alphaRate*5.0), an.alphaEnvelopeB.end_time);
        }
      }
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
  }
  import java.util.*;
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

    //dimmer = cc[40];
    blendMode(MULTIPLY);
    // this donesnt work anymore....
    if (cc[107] > 0 || keyT['r'] || glitchToggle) bgNoise(colorLayer, 0, 0, cc[55]); //PGraphics layer,color,alpha
    drawColorLayer();

    blendMode(NORMAL);
    cans.infoX +=100;
    rigInfo();
    removeAnimations();
    cordinatesInfo(this, keyT['q']);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


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
