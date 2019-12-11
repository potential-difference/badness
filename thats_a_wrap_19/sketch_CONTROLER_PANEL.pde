boolean glitchToggle, roofBasic = false, testToggle;
float vizTimeSlider, colorSwapSlider, colorTimerSlider, boothDimmer, digDimmer, backDropSlider;
float tweakSlider, blurSlider, bgNoiseBrightnessSlider, bgNoiseDensitySlider, manualSlider, stutterSlider;
float shimmerSlider, funcSlider, beatSlider;
float smokePump, smokeFan, smokeOnTime, smokeOffTime;

class MainControlFrame extends ControlFrame {
  MainControlFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super (_parent, _controlW, _controlH, _xpos, _ypos);
    cp5 = new ControlP5(this);

    x = 10;
    y = 90;
    sliderY=y;

    //fullScreen();
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// GLOBAL SLIDERS ///////////////////////////////////////////////////////////
    loadSlider("boothDimmer", x, y, wide, high, 0, 1, 0.32, act1, bac1, slider1);
    loadSlider("digDimmer", x, y+row, wide, high, 0, 1, 0.2, act, bac, slider);
    loadSlider("vizTimeSlider", x, y+row*2, wide, high, 0, 1, 0.5, act1, bac1, slider1);
    loadSlider("colorTimerSlider", x, y+row*3, wide, high, 0, 1, 0.45, act, bac, slider);
    loadSlider("colorSwapSlider", x, y+row*4, wide, high, 0, 1, 0.9, act1, bac1, slider1);
    loadSlider("manualSlider", x, y+row*5, wide, high, 0, 1, 0.9, act, bac, slider);
    /////////////////////////////// GLOBAL TOGGLE BUTTONS//////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    x+=clm*5;
    x += 80;
    wide = 20;
    high = 20;
    loadToggle("onTop", onTop, x, y, wide, high, bac1, bac, slider);
    loadToggle("glitchToggle", glitchToggle, x, y+35, wide, high, bac1, bac, slider);
    x += 80;
    loadToggle("roofBasic", roofBasic, x, y, wide, high, bac1, bac, slider);
    loadToggle("syphonToggle", syphonToggle, x, y+35, wide, high, bac1, bac, slider);

    loadToggle("testToggle", testToggle, x+80, y, 55, 55, bac1, bac, slider);
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  void draw() {
    background(0);
    //////////////////////////////// SHOW INFO ABOUT CURRENT RIG ARRAY SELECTION //////////////////////////////////////////////////////////////// 
    float x = 10;
    float y = 25;
    textAlign(LEFT);
    textSize(18);
    fill(360);
    int totalAnims=0;      
    for (Rig rig : rigs) totalAnims += rig.animations.size();
    text("# of anims: "+totalAnims, x, y+45);
    ///////////// rig info/ ///////////////////////////////////////////////////////////////////
    fill(rigg.flash, 300);
    text("rigViz: " + rigg.vizIndex, x, y);
    text("bkgrnd: " + rigg.bgIndex, x, y+20);
    text("func's: " + rigg.functionIndexA + " / " + rigg.functionIndexB, x+100, y);
    text("alph's: " + rigg.alphaIndexA + " / " + rigg.alphaIndexB, x+100, y+20);
    /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
    ///// NEXT VIZ IN....
    x=250;
    fill(rigg.c, 300);
    fill(rigg.c, 100);
    String sec = nf(int(vizTime - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = int(vizTime - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(int(colTime - (millis()/1000 - rigg.colorTimer)) %60, 2, 0);
    min = int(colTime - (millis()/1000 - rigg.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+20);
    text("c-" + rigg.colorIndexA + "  " + "flash-" + rigg.colorIndexB, x, y+40);
    /////////////////////////////////////////////////// roof info ////////////////////////////////////////////////////////
    if (size.roofWidth > 0 && size.roofHeight > 0) {
      fill(rigg.c, 300);
      if (!roof.toggle) fill(rigg.c, 100);
      textSize(18);
      textAlign(RIGHT);
      x = size.roof.x+(size.roofWidth/2) - 130;
      text("roofViz: " + roof.vizIndex, x, y);
      text("bkgrnd: " + roof.bgIndex, x, y+20);
      text("func's: " + roof.functionIndexA + " / " + roof.functionIndexB, x+120, y);
      text("alph's: " + roof.alphaIndexA + " / " + roof.alphaIndexB, x+120, y+20);
    }
    /////////////////////////////////////////////////// cans info ////////////////////////////////////////////////////////
    if (size.cansHeight > 0 && size.cansWidth > 0) {
      fill(rigg.c, 300);
      if (!cans.toggle) fill(rigg.c, 100);
      textSize(18);
      textAlign(RIGHT);
      x = size.cans.x+(size.cansWidth/2) - 130;
      text("cansViz: " + cans.vizIndex, x, y);
      text("bkgrnd: " + cans.bgIndex, x, y+20);
      text("func's: " + cans.functionIndexA + " / " + cans.functionIndexB, x+120, y);
      text("alph's: " + cans.alphaIndexA + " / " + cans.alphaIndexB, x+120, y+20);
    }
    /*
     /////////////////////////////////////////////////// cans info ////////////////////////////////////////////////////////
     if (size.donutHeight > 0 && size.donutHeight > 0) {
     fill(rigg.c, 300);
     if (!donut.toggle) fill(rigg.c, 100);
     textSize(18);
     textAlign(LEFT);
     x = size.cans.x+(size.cansWidth/2) +25;
     text("donutViz: " + donut.vizIndex, x, y);
     text("bkgrnd: " + donut.bgIndex, x, y+20);
     text("func's: " + donut.functionIndexA + " / " + donut.functionIndexB, x+120, y);
     text("alph's: " + donut.alphaIndexA + " / " + donut.alphaIndexB, x+120, y+20);
     }
     */

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    sequencer(675, sliderY-20);
    pauseInfo(width-5, sliderY-15);
    dividerLines();
    fill(rigg.c);                              // divider for sliders
    // test for radio buttons
    rect(width/2, sliderY-7.5, width, 1);
    fill(ctest);
    rect(1000, sliderY+30, 50, 50);
    fill(flashtest);
    rect(1080, sliderY+30, 50, 50);
  }
}

class SliderFrame extends ControlFrame {
  SliderFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super (_parent, _controlW, _controlH, _xpos, _ypos);
    surface.setAlwaysOnTop(onTop);
    cp5 = new ControlP5(this);
    x = 10;
    y = 10;
    wide = 150;
    high = 20;
    int gap = 25;
    /*
    loadSlider("controller "+0, x, y, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+1, x, y+gap, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+2, x, y+gap*2, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+3, x, y+gap*3, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+4, x, y+gap*4, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+5, x, y+gap*5, wide, high, 0, 1, 0.32, act1, bac1, slider1);    
     loadSlider("controller "+6, x, y+gap*6, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+7, x, y+gap*7, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     loadSlider("controller "+8, x, y+gap*8, wide, high, 0, 1, 0.32, act1, bac1, slider1);
     */
    for (int i =0; i<16; i+=2) {
      gap = 25;
      String name = "controller "+i;
      String name1 = "controller "+(i+1);
      println(i);
      loadSlider(name, x, y+(i*gap), wide, high, 0, 1, 0.32, act1, bac1, slider1);
      loadSlider(name1, x, y+gap+(i*gap), wide, high, 0, 1, 0.32, act, bac, slider);
    }
  }
  void draw() {
    surface.setAlwaysOnTop(onTop);
    background(0);
    dividerLines();
  }
}

class ControlFrame extends PApplet {
  int controlW, controlH, wide, high, xpos, ypos;
  float clm, row, sliderY, x, y;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super();   

    parent = _parent;
    controlW=_controlW;
    controlH=_controlH;
    xpos = _xpos;
    ypos = _ypos;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  public void settings() {
    size(controlW, controlH);
  }
  public void setup() {
    this.surface.setSize(controlW, controlH);
    this.surface.setAlwaysOnTop(true);
    this.surface.setLocation(xpos, ypos);
    colorMode(HSB, 360, 100, 100);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();
    wide = 80;           // x size of sliders
    high = 14;           // y size of slider
    row = high +4;       // distance between rows
    clm = 210;
  }
  void draw() {
    /// override in subclass
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void loadSlider(String label, float x, float y, int wide, int high, float min, float max, float startVal, color act1, color bac1, color slider1) {
    cp5.addSlider(label)
      .plugTo(parent, label)
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(min, max)
      .setValue(startVal)    // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
  }
  void loadToggle(String label, Boolean toggle, float x, float y, int wide, int high, color bac1, color bac, color slider) {
    cp5.addToggle(label)
      .plugTo(parent, label)
      .setPosition(x, y)
      .setSize(wide, high)
      .setValue(toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
  }
  //////////////////////////////////////// CALL BACK FOR SLIDER CONTROL FROM OTHER VARIABLES
  // an event from slider sliderA will change the value of textfield textA here
  public void rigDimmer(float theValue) {
    int value = int(map(theValue, 0, 1, 0, 127));
    LPD8bus.sendControllerChange(0, 4, value) ;
  }
  void dividerLines() {
    fill(rigg.c, 100);                         // box around the outside
    rect(width/2, height-1, width, 1);  
    rect(width/2, 1, width, 1);                              
    rect(0, height/2, 1, height);
    rect(width-1, height/2, 1, height);
  }
  void sequencer(float x, float y) {
    int dist = 20;
    fill(rigg.flash, 100);
    for (int i = 0; i<(16); i++) rect(10+i*dist+x, y, 10, 10);
    fill(rigg.c);
    for (int i = 0; i<(16); i++) if (int(beatCounter%(16)) == i) rect(10+i*dist+x, y, 10, 10);
  }
  void pauseInfo(float x, float y) {
    if (pause > 0) { 
      textAlign(RIGHT);
      textSize(20); 
      fill(300+(60*stutter));
      text(pause*10+" sec NO AUDIO!!", x, y); //
    }
  }
  color ctest, flashtest;
  public void controlEvent(ControlEvent theEvent) {
    int intValue = int(theEvent.getValue());
    float value = theEvent.getValue();
    int someDelay = 30; // silence at startup
    if (frameCount > someDelay) {
      for (Rig rig : rigs) {                        
        if (theEvent.isFrom(rig.ddVizList)) {
          println(rig.name+" viz selected "+intValue);
          rig.vizIndex = intValue;
        }
        if (theEvent.isFrom(rig.ddBgList)) {
          println(rig.name+" background selected "+intValue);
          rig.bgIndex = intValue;
        }
        if (theEvent.isFrom(rig.ddAlphaList)) {
          println(rig.name+" alpah selected "+intValue);
          rig.alphaIndexA = intValue;
          rig.alphaIndexB = intValue;
        }
        if (theEvent.isFrom(rig.ddFuncList)) {
          println(rig.name+" func selected "+intValue);
          rig.functionIndexA = intValue;
          rig.functionIndexB = intValue;
        }
        if (theEvent.isFrom(rig.flashRadioButton)) {
          println(rig.name+" C index: "+intValue);
          rig.colorIndexB = intValue;
        }
        if (theEvent.isFrom(rig.cRadioButton)) {
          println(rig.name+" FLASH index: "+intValue);
          rig.colorIndexA = intValue;
        }
      }


      // plug sliders to cc[i];
      //for(int i = 0; i < 16;i++) control 1

      ///////////////////////////////////// say some shit 
      if (theEvent.isController()) {
        println("- controller "+theEvent.getController().getName()+" "+theEvent.getValue());
        if (theEvent.getController().getName() == "controller 0") {
          cc[41] = value;
          println(theEvent.getController().getName());
        }
      }
      //if (theEvent.isGroup()) println("- group "+theEvent.getName()+" "+theEvent.getValue());
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
  }
}
/*
// put inside controller change 
 if (cc[4]!=prevcc[4]) {
 prevcc[4]=cc[4];
 if (cc[4] != rigDimmer) cp5.getController("rigDimmer").setValue(cc[4]);
 }
 if (cc[5]!=prevcc[5]) {
 prevcc[5]=cc[5];
 if (cc[5] != cansDimmer) cp5.getController("cansDimmer").setValue(cc[5]);
 }
 if (cc[8]!=prevcc[8]) {
 prevcc[8]=cc[8];
 if (cc[8] != roofDimmer) cp5.getController("roofDimmer").setValue(cc[8]);
 }
 }
 //////////////////////////////////////// CALL BACK FOR SLIDER CONTROL FROM OTHER VARIABLES
 // an event from slider sliderA will change the value of textfield textA here
 public void rigDimmer(float theValue) {
 int value = int(map(theValue, 0, 1, 0, 127));
 LPD8bus.sendControllerChange(0, 4, value) ;
 }
 }
 
 */








/* // old sliders 
/*        
 cp5.addSlider("smokePump")
 .plugTo(parent, "smokePump")      .setPosition(x, y+row)
 .setPosition(x, y+row*3)
 .setSize(wide, high)
 .setRange(0, 1)
 .setValue(0.75) // start value of slider
 .setColorActive(act) 
 .setColorBackground(bac) 
 .setColorForeground(slider) 
 ;
 cp5.addSlider("smokeOnTime")
 .plugTo(parent, "smokeOnTime")      .setPosition(x, y+row)
 .setPosition(x, y+row*4)
 .setSize(wide, high)
 .setRange(0, 1)
 .setValue(0.5) // start value of slider
 .setColorActive(act1) 
 .setColorBackground(bac1) 
 .setColorForeground(slider1) 
 ;
 cp5.addSlider("smokeOffTime")
 .plugTo(parent, "smokeOffTime")      .setPosition(x, y+row)
 .setPosition(x, y+row*5)
 .setSize(wide, high)
 .setRange(0, 1)
 .setValue(0.5) // start value of slider
 .setColorActive(act) 
 .setColorBackground(bac) 
 .setColorForeground(slider) 
 ;
 x+=clm;
 //////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////// FOURTH coloum of sliders ///////////////////////////////////////
 
 cp5.addSlider("bgNoiseSlider")
 .plugTo(parent, "bgNoiseSlider")
 .setPosition(x, y+row*2)
 .setSize(wide, high)
 //.setFont(font)
 .setRange(0, 1)
 .setValue(0.3) // start value of slider
 .setColorActive(act1) 
 .setColorBackground(bac1) 
 .setColorForeground(slider1) 
 ;
 cp5.addSlider("bgNoiseBrightnessSlider")
 .plugTo(parent, "bgNoiseBrightnessSlider")
 .setPosition(x, y+row*3)
 .setSize(wide, high)
 //.setFont(font)
 .setRange(0, 1)
 .setValue(0.5) // start value of slider
 .setColorActive(act) 
 .setColorBackground(bac) 
 .setColorForeground(slider) 
 ;    
 cp5.addSlider("bgNoiseDensitySlider")
 .plugTo(parent, "bgNoiseDensitySlider")
 .setPosition(x, y+row*4)
 .setSize(wide, high)
 //.setFont(font)
 .setRange(0, 1)
 .setValue(0.1) // start value of slider
 .setColorActive(act1) 
 .setColorBackground(bac1) 
 .setColorForeground(slider1) 
 ;
 
 */
