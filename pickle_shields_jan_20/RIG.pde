public class Rig {
  float dimmer, alphaRate, funcRate, blurValue, bgNoise, manualAlpha, funcSwapRate, alphaSwapRate, bgSwapRate;
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
  HashMap<Integer, Ref> dimmers;
  int[] availableAnims;
  int[] availableBkgrnds;
  int[] availableAlphaEnvelopes;
  int[] availableFunctionEnvelopes;
  int[] availableColors;
  String[] animNames, backgroundNames, alphaNames, functionNames;
  int arrayListIndex;
  float infoX, infoY;
  float wideSlider, strokeSlider, highSlider;
  ControlP5 cp5;
  PApplet parent;
  ScrollableList ddVizList, ddBgList, ddAlphaListA, ddFuncListA, ddAlphaListB, ddFuncListB;
  RadioButton cRadioButton, flashRadioButton;

  Rig(float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);

    this.cp5 = controlFrame.cp5;

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;

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
    ////////////////////////////// LOAD CONTROLLERS //////////////////////////////////////////////////////////////////////////////
    float scaleFactor = 1.8;
    int x = 10;                               // starting x coordiante
    int y = 90;                               // starting y coordiante
    int swide = int(50*scaleFactor);          // x size of sliders
    int shigh = int(10*scaleFactor);          // y size of slider
    int listWidth = 140;                      // width of dropdown lists

    int gap = shigh/4;
    int row = shigh+4;                        // distance between rows
    int clm = shigh + listWidth + swide + x + 100;                // distance between columns
    clm = this.wide;                          // distance between columns based on rig width

    ///////////////////////////////// RADIO BUTTONS  //////////////////////////////////////////////////////////////////////////////
    cRadioButton = this.cp5.addRadioButton(name+" cRadioButton")
      .setPosition(x+(clm*arrayListIndex), y)
      .setSize(shigh, shigh);
    for (int i=0; i<availableColors.length; i++) {
      cRadioButton.addItem(name+" colc "+i, i);
      cRadioButton.getItem(name+" colc "+i)
        .setColorBackground(color(col[availableColors[i]], 100))
        .setColorForeground(color(col[availableColors[i]], 200))
        .setColorActive(color(col[availableColors[i]], 360));
      cRadioButton.hideLabels();
    }

    flashRadioButton = this.cp5.addRadioButton(name+" flashRadioButton")
      .setPosition(x+(clm*arrayListIndex)+shigh+gap, y)
      .setSize(shigh, shigh);
    for (int i=0; i<availableColors.length; i++) {
      flashRadioButton.addItem(name+" colFlash "+i, i);
      flashRadioButton.getItem(name+" colFlash "+i)
        .setColorBackground(color(col[availableColors[i]], 100))
        .setColorForeground(color(col[availableColors[i]], 200))
        .setColorActive(color(col[availableColors[i]], 360));
      flashRadioButton.hideLabels() ;
    }
    x += 2*(shigh+gap);

    ///////////////////////////////// DROPDOWN LISTS //////////////////////////////////////////////////////////////////////////////
    ddVizList = this.cp5.addScrollableList(name+" vizLizt").setPosition(x+(clm*arrayListIndex), y);
    ddBgList = this.cp5.addScrollableList(name+" bgList").setPosition(x+(clm*arrayListIndex), y+35);

    ddAlphaListA = this.cp5.addScrollableList(name+" alpahLizt").setPosition(x+(clm*arrayListIndex), y+70);
    ddFuncListA = this.cp5.addScrollableList(name+" funcLizt").setPosition(x+(clm*arrayListIndex), y+105);

    ddAlphaListB = this.cp5.addScrollableList(name+" alpahLiztB").setPosition(x+(clm*arrayListIndex)+listWidth/2+5, y+70);
    ddFuncListB = this.cp5.addScrollableList(name+" funcLiztB").setPosition(x+(clm*arrayListIndex)+listWidth/2+5, y+105);

    // the order of this has to be oppostie to the order they are displayed on screen
    customize(ddFuncListB, color(bac1, 200), bac, act, int(listWidth/2.1), "funcB");     // customize the list
    customize(ddAlphaListB, color(bac1, 200), bac, act, int(listWidth/2.1), "alphB");   // customize the list
    customize(ddFuncListA, color(bac1, 200), bac, act, int(listWidth/2.1), "funcA");     // customize the list
    customize(ddAlphaListA, color(bac1, 200), bac, act, int(listWidth/2.1), "alphA");   // customize the list

    customize(ddBgList, color(bac, 200), bac1, act, listWidth, name+" bkgrnd");       // customize the list
    customize(ddVizList, color(bac, 200), bac1, act, listWidth, name+" viz");       // customize the list

    x +=gap+listWidth;

    ///////////////////////////////// SLIDERS  ///////////////////////////////////////////////////////////////////////////////////
    loadSlider( "dimmer", x+(clm*arrayListIndex), y+(0*row), swide, shigh, 0, 1, 1, act1, bac1, slider1);
    this.cp5.getController(this.name+" "+"dimmer").setLabel(name +" dimmer");
    loadSlider( "alphaRate", x+(clm*arrayListIndex), y+(1*row), swide, shigh, 0, 1, 0.3, act, bac, slider);      // old alphaSlider - controls rate of DECAY for ALPHA
    this.cp5.getController(this.name+" "+"alphaRate").setLabel("alpha rate");
    loadSlider( "funcRate", x+(clm*arrayListIndex), y+(2*row), swide, shigh, 0, 1, 0.4, act1, bac1, slider1);    // old funcSlider - control rate of DECAY for FUNCTION
    this.cp5.getController(this.name+" "+"funcRate").setLabel("func rate");
    loadSlider( "blurValue", x+(clm*arrayListIndex), y+(3*row), swide, shigh, 0, 1, 0.5, act, bac, slider);      // blurriness of vizulisation 
    this.cp5.getController(this.name+" "+"blurValue").setLabel("blurriness");
    loadSlider( "funcSwapRate", x+(clm*arrayListIndex), y+(4*row), swide, shigh, 30, 0, 4, act1, bac1, slider1); // NUMBER of times FUNCTION changes PER VIZ
    this.cp5.getController(this.name+" "+"funcSwapRate").setLabel("func change");
    loadSlider( "alphaSwapRate", x+(clm*arrayListIndex), y+(5*row), swide, shigh, 30, 0, 6, act, bac, slider);   // NUMBER of times ALPHA changes PER VIZ
    this.cp5.getController(this.name+" "+"alphaSwapRate").setLabel("alpha change");
    loadSlider( "bgSwapRate", x+(clm*arrayListIndex), y+(6*row), swide, shigh, 30, 0, 12, act1, bac1, slider1);  // NUMBER of times BACKGROUND changes PER COLOUR
    this.cp5.getController(this.name+" "+"bgSwapRate").setLabel("bkgrnd change");

    loadSlider("strokeSlider", x+(clm*arrayListIndex), y+row*7, swide, shigh, 1, 5, 0, act, bac, slider);
    this.cp5.getController(this.name+" "+"strokeSlider").setLabel("stroke slider");
    loadSlider("wideSlider", x+(clm*arrayListIndex), y+row*8, swide, shigh, 1, 5, 0, act1, bac1, slider1);
    this.cp5.getController(this.name+" "+"wideSlider").setLabel("wide slider");
    loadSlider("highSlider", x+(clm*arrayListIndex), y+row*9, swide, shigh, 1, 5, 0, act, bac, slider);
    this.cp5.getController(this.name+" "+"highSlider").setLabel("high slider");

    loadSlider( "manualAlpha", x+(clm*arrayListIndex), y+(10*row), swide, shigh, 0, 1, 0.8, act1, bac1, slider1);  // RATE of ALPHA DECAY for manual control - needs to be impemented properly
    this.cp5.getController(this.name+" "+"manualAlpha").setLabel("manual alpha");


    ///////////////////////////////// TOGGLES  ///////////////////////////////////////////////////////////////////////////////////
    //loadToggle(noiseToggle, "noiseToggle", x+(clm*arrayListIndex), y+row*7.5, swide, 10);
    loadToggle(toggle, "toggle", x+(clm*arrayListIndex), y+row*11, swide-30, shigh);
    loadToggle(playWithYourSelf, "playWithYourSelf", x+(clm*arrayListIndex)+swide-25, y+row*11, 25, shigh);
    this.cp5.getController(this.name+" "+"playWithYourSelf").setLabel("p.w.y.s");


    /////////  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void loadToggle(boolean toggle, String label, float x, float y, int wide, int high) {
    this.cp5.addToggle(this.name+" "+label)
      .plugTo(this, label)
      .setLabel(label)
      .setPosition(x, y)
      .setSize(wide, high)      
      .setValue(toggle)
      //.setFont(font)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(act) 
      ;
  }
  void loadSlider(String label, float x, float y, int wide, int high, float min, float max, float startVal, color act1, color bac1, color slider1) {
    this.cp5.addSlider(name+" "+label)
      .plugTo(this, label)
      .setPosition(x, y)
      .setSize(wide, high)
      .setRange(min, max)
      //.setFont(font)
      .setValue(startVal)    // start value of slider
      .setColorActive(color(act1, 200)) 
      .setColorBackground(color(bac1, 200)) 
      .setColorForeground(color(slider1, 200)) 
      ;
  }
  void customize(ScrollableList ddl, color bac, color bac1, color act, int wide, String label) {
    ddl.setBackgroundColor(0); // color behind list - can hardly see it
    ddl.setItemHeight(40);
    ddl.setBarHeight(30);
    ddl.setWidth(wide);
    ddl.setCaptionLabel(label);
    //ddl.setFont(font);
    //for (int i=0; i<availableAnims.length; i++) ddl.addItem(label+i, i);
    ddl.setColorBackground(color(bac, 300));       // background color
    ddl.setColorActive(200);           // clicked color
    ddl.setColorCaptionLabel(#FFFAFA) ;
    ddl.setColorForeground(bac1) ;      // highlight color
    ddl.setColorLabel(#FFFAFA) ;       // text color for label
    ddl.close();
    ddl.bringToFront();
  }

  void ddListCallback( ScrollableList ddl, int index) {
    ddl.setValue(index);
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
      mirrorGradient(c, flash, 0.5);
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
    case 10:
      colorLayer.beginDraw();
      colorLayer.background(0);
      radialGradient(flash, c, sine);
      colorLayer.endDraw();
      break;
    case 11:
      colorLayer.beginDraw();
      colorLayer.background(0);
      radialGradient(c, flash, beat);
      bigShield(c, flash);
      balls(clash);
      colorLayer.endDraw();
      break;
    case 12:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(c);
      bigShield(flash, flash);
      colorLayer.endDraw();
      break;
    case 13:
      colorLayer.beginDraw();
      colorLayer.background(0);
      oneColour(flash);
      bigShield(c, clash);
      colorLayer.endDraw();
      break;
    case 14:
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
    /*
    if (syphonToggle) { 
     if (syphonImageReceived != null) image(syphonImageReceived, size.x, size.y, wide, high);
     } else 
     */
    image(colorLayer, size.x, size.y);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  /*
  void addAnim(int animIndex) {
   try{
   Anim anim = classMap.get(this.availableAnims[animIndex]).newInstance();
   }catch(Exception e){println("class name error:",e);}
   }
   */

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
      anim = new Checkers(this);
      break;
    case 12:  
      anim = new Rush(this);
      break;
    case 13:  
      anim = new Rushed(this);
      break;
    case 14:  
      anim = new SquareNuts(this);
      break;
    case 15:  
      anim = new DiagoNuts(this);
      break;
    case 16:  
      anim = new Swipe(this);
      break;
    case 17:  
      anim = new Swiped(this);
      break;
    case 18:  
      anim = new Teeth(this);
      break;
    case 19:
      anim = new AllOn(this);
      break;
    case 20:
      anim = new AllOff(this);
      break;
    }
    //    Ref t=new Ref(new float[]{1.0}, 0);
    //    if (t != null) anim.animDimmer = anim.animDimmer.mul(t);
    /*
    // ramp out all previous anims
     if (testToggle) {
     for (Anim an : animations) {
     float now = millis();
     //if (alphaIndexA == 1) {
     //  an.alphaEnvelopeA = new Ramp(now, now+avgmillis*alphaRate*3.0, an.alphaA, an.alphaA, 0.9).mul(new Ramp(now+avgmillis*alphaRate*3.0, now+avgmillis*alphaRate*4.0, 1.0, 0.1, 0.01));
     //} else {
     //an.alphaEnvelopeA = an.alphaEnvelopeA.mul(new Ramp(now, now+avgmillis*alphaRate*3.0, 0.8, 0.2, 0.01));
     //an.alphaEnvelopeA.end_time = min(int(now+avgmillis*alphaRate*1.0), an.alphaEnvelopeA.end_time);
     an.alphaEnvelopeA = an.alphaEnvelopeA.mul(0.8);
     //}
     //if (alphaIndexB == 1) {
     //  an.alphaEnvelopeB = new Ramp(now, now+avgmillis*alphaRate*3.0, an.alphaB, an.alphaB, 0.9).mul(new Ramp(now+avgmillis*alphaRate*3.0, now+avgmillis*alphaRate*4.0, 1.0, 0.1, 0.01));
     //} else {       
     //an.alphaEnvelopeB = an.alphaEnvelopeB.mul(new Ramp(now, now+avgmillis*alphaRate*3.0, 0.9, 0.2, 0.01));
     //an.alphaEnvelopeB.end_time = min(int(now+avgmillis*alphaRate*1.0), an.alphaEnvelopeB.end_time);
     an.alphaEnvelopeB = an.alphaEnvelopeB.mul(0.8);
     }
     }
     */
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


        //if (alphaIndexA == 1) {
        //an.alphaEnvelopeA = new Ramp(now, now+avgmillis*alphaRate*3.0, an.alphaA, an.alphaA, 0.9).mul(new Ramp(now+avgmillis*alphaRate*3.0, now+avgmillis*alphaRate*4.0, 1.0, 0.1, 0.01));
        //} else {
        //Envelope decayA = new Envelope an.alphaEnvelopeA.value(now).mul(0.9);
        //float decayA = an.alphaEnvelopeA.value(now)*0.6;
        //an.alphaA = an.alphaEnvelopeA.value(now)*0.6; // decayA; //an.alphaEnvelopeA.mul(new Ramp(now, now+avgmillis*alphaRate*3.0, 0.8, 0.2, 0.01));
        //an.alphaEnvelopeA.end_time = min(int(now+avgmillis*alphaRate*3.0), an.alphaEnvelopeA.end_time);
        //an.alphaEnvelopeA = an.alphaEnvelopeA.mul(0.95);
        //}
        //if (alphaIndexB == 1) {
        //  an.alphaEnvelopeB = new Ramp(now, now+avgmillis*alphaRate*3.0, an.alphaB, an.alphaB, 0.9).mul(new Ramp(now+avgmillis*alphaRate*3.0, now+avgmillis*alphaRate*4.0, 1.0, 0.1, 0.01));
        //} else {       
        //an.alphaEnvelopeB = an.alphaEnvelopeB.mul(new Ramp(now, now+avgmillis*alphaRate*3.0, 0.9, 0.2, 0.01));
        //an.alphaEnvelopeB.end_time = min(int(now+avgmillis*alphaRate*1.0), an.alphaEnvelopeB.end_time);
        //an.alphaEnvelopeB = an.alphaEnvelopeB.mul(0.95);
      }
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
