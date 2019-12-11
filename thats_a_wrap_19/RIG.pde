public class Rig {
  float dimmer = 1, alphaRate, funcRate, blurValue, manualAlpha;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  color c, flash, c1, flash1, clash, clash1, clashed, colorIndexA, colorIndexB = 1, colA, colB, colC, colD, scol1, scol2, scol3;
  color col[] = new color[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  boolean firsttime_sketchcolor=true, toggle, noiseToggle;
  ArrayList <Anim> animations;
  HashMap<Integer, Ref> dimmers;
  int[] availableAnims;
  int[] avaliableBkgrnds;
  int[] avaliableEnvelopes;
  int arrayListIndex;
  int value;
  ScrollableList ddVizList, ddBgList, ddAlphaList, ddFuncList;
  RadioButton cRadioButton, flashRadioButton;
  int lable;


  Rig(boolean _toggle, float _xpos, float _ypos, int _wide, int _high, String _name) {
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);
    toggle = _toggle;

    availableAnims = new int[] {0, 1, 2, 3};      // default - changed when initalised;
    animations = new ArrayList<Anim>();
    rigs.add(this);
    arrayListIndex = rigs.indexOf(this);          // where this is the rig object
    avaliableBkgrnds = new int[] {0, 1, 2, 3};    // default - changed when initalised;

    avaliableEnvelopes = new int[] {1, 2, 3, 4};  

    dimmers = new HashMap<Integer, Ref>();

    int clm = 250;           // distance between coloms
    float x = 10+clm;
    float y = 90;
    int swide = 80;           // x size of sliders
    int shigh = 14;           // y size of slider
    int row = shigh+4;       // distance between rows

    loadSlider("dimmer", x+(clm*arrayListIndex), 0, 0, 1, 1);
    loadSlider("alphaRate", x+(clm*arrayListIndex), 1, 0, 1, 0.5);
    loadSlider("funcRate", x+(clm*arrayListIndex), 2, 0, 1, 0.5);
    loadSlider("blurValue", x+(clm*arrayListIndex), 3, 0, 1, 0.5);
    loadSlider("bgNoise", x+(clm*arrayListIndex), 4, 0, 1, 0.5);
    loadSlider("manualAlpha", x+(clm*arrayListIndex), 5, 0, 1, 0.8);

    //void loadToggle(String label, float x, float y, int wide,int high) {
    loadToggle(noiseToggle, "noiseToggle", x+(clm*arrayListIndex), y+row*6, swide, 10);
    loadToggle(toggle, "toggle", x+(clm*arrayListIndex), y+row*7.5, swide, 20);

    //Group colorButtons = cp5.addGroup(name+"colorButtons")
    //  .setPosition(x+(clm*arrayListIndex)-60, y)
    //  .setWidth(30)
    //  .activateEvent(true)
    //  .setBackgroundColor(color(255, 80))
    //  .setBackgroundHeight(100)
    //  .setLabel("color")
    //  ;

    String sc = "c";
    cRadioButton = cp5.addRadioButton(name+" cRadioButton")
      .plugTo(this, "cRadioButton")
      .setLabel(this.name+" cRadioButton")
      .setPosition(x+(clm*arrayListIndex)-90, y)
      .setSize(15, shigh)
      .addItem(name+"black"+sc, 0)
      .addItem(name+"red"+sc, 1)
      .addItem(name+"green"+sc, 2)
      .addItem(name+"blue"+sc, 3)
      .addItem(name+"grey"+sc, 4)
      .hideLabels() 
      //.setGroup(colorButtons)
      ;
    String f = "flash";
    flashRadioButton = cp5.addRadioButton(name+" flashRadioButton")
      .plugTo(this, "flashRadioButton")
      .setLabel(this.name+" flashRadioButton")
      .setPosition(x+(clm*arrayListIndex)-70, y)
      .setSize(15, shigh);
    for (int i=0; i<col.length; i++) flashRadioButton.addItem(name+"col"+f+i, i);
    flashRadioButton.hideLabels() ;

    //loadRadioButtons(x+(clm*arrayListIndex)-90, y, 10, shigh);

    ddVizList = cp5.addScrollableList(name+"vizLizt").setPosition(x+(clm*arrayListIndex)-45, y);
    ddBgList = cp5.addScrollableList(name+"bkList").setPosition(x+(clm*arrayListIndex)-45, y+25);
    ddAlphaList = cp5.addScrollableList(name+"alpahLizt").setPosition(x+(clm*arrayListIndex)-45, y+60);
    ddFuncList = cp5.addScrollableList(name+"funcLizt").setPosition(x+(clm*arrayListIndex)-45, y+85);

    // the order of this has to be oppostie to the order they are displayed on screen
    customize(ddFuncList, bac1, bac, act, "func");     // customize the list
    customize(ddAlphaList, bac1, bac, act, "alpha");   // customize the list
    customize(ddBgList, bac, bac1, act, "bkg");       // customize the list
    customize(ddVizList, bac, bac1, act, "viz");       // customize the list

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
  void loadToggle(boolean toggle, String label, float x, float y, int wide, int high) {
    cp5.addToggle(this.name+" "+label)
      .plugTo(this, label)
      .setLabel(this.name+" "+label)
      .setPosition(x, y)
      .setSize(wide, high)      
      .setValue(toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
  }
  void loadSlider(String label, float x, int rowInt, float min, float max, float startVal) {
    int swide = 80;
    int shigh = 14;
    int row = shigh+4;       // distance between rows
    int y = 90;
    if (rowInt % 2 == 0) {
      scol1 = act;
      scol2 = bac;
      scol3 = slider;
    } else {
      scol1 = act1;
      scol2 = bac1;
      scol3 = slider1;
    }
    cp5.addSlider(name+" "+label)
      .plugTo(this, label)
      .setLabel(this.name+" "+label)
      .setPosition(x, y+(row*rowInt))
      .setSize(swide, shigh)
      .setRange(min, max)
      .setValue(startVal)
      .setColorActive(scol1) 
      .setColorBackground(scol2) 
      .setColorForeground(scol3) 
      ;
  }
  void loadRadioButtons(float x, float y, int wide, int high) {
  }

  void customize(ScrollableList ddl, color bac, color bac1, color act, String label) {
    // a convenience function to customize a DropdownList
    ddl.setBackgroundColor(slider1); // color behind list - can hardly see it
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.setWidth(40);
    ddl.setCaptionLabel(label);
    for (int i=0; i<availableAnims.length; i++) ddl.addItem(label+i, i);
    //ddl.scroll(0);
    ddl.setColorBackground(bac);       // background color
    ddl.setColorActive(act);           // clicked color
    ddl.setColorCaptionLabel(#FFFAFA) ;
    ddl.setColorForeground(bac1) ;      // highlight color
    ddl.setColorLabel(#FFFAFA) ;       // text color for label
    ddl.close();
    ddl.bringToFront();
  }
  public void dropdown(int n) {
    /* request the selected item based on index n and store in a char */
    String string = cp5.get(ScrollableList.class, "dropdown").getItem(n).get("name").toString();
    char c = string.charAt(0);
    //int value = cp5.get(ScrollableList.class, "dropdown").getItem(n).get.getValue();

    // Write the char to the serial port
    println(string, c);
  }

   void setValue(int theValue) {
    value = theValue;
  }
  void toggle(boolean toggleValue) {
    toggle = toggleValue;
  }
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
    x = size.x+(wide/2)-(nameWidth+17)-30;
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
    switch (animIndex) {
    case 0:  
      anim = new BenjaminsBoxes(this);
      break;
    case 1:  
      anim = new BenjaminsBoxes(this);
      break;
    case 2:  
      anim = new Checkers(this);
      break;
    case 3:  
      anim = new Rings(this);
      break;
    case 4:  
      anim = new Rush(this);
      break;
    case 5:  
      anim = new Rushed(this);
      break;
    case 6:  
      anim = new SquareNuts(this);
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
    default:
      anim = new Rings(this);
      break;
    }

    Ref t=new Ref(new float[]{1.0}, 0);
    try {
      t=this.dimmers.get(animIndex);
    }
    catch(Exception e) {
    };
    if (t != null) anim.animDimmer = t;
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

    blendMode(MULTIPLY);
    // this donesnt work anymore....
    if (cc[107] > 0 || keyT['r'] || glitchToggle) bgNoise(colorLayer, 0, 0, cc[7]); //PGraphics layer,color,alpha
    drawColorLayer();

    blendMode(NORMAL);
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
