import controlP5.*;
ControlP5 cp5;

boolean glitchToggle, roofBasic = false, syphonToggle = false, donutToggle = false;
float vizTimeSlider, colorSwapSlider, colorTimerSlider, cansDimmer, boothDimmer, digDimmer, backDropSlider, cansSlider;
float tweakSlider, blurSlider, bgNoiseBrightnessSlider, bgNoiseDensitySlider, manualSlider, stutterSlider, cansAlpha, deleteMeSlider;
float shimmerSlider, alphaSlider, rigDimmer, roofDimmer, seedsDimmer, seed2Dimmer, uvDimmer, controllerDimmer, funcSlider, pauseSlider;
float smokePump, smokeFan, smokeOnTime, smokeOffTime;

class ControlFrame extends PApplet {
  int controlW, controlH;
  float clm, row, sliderY;
  PApplet parent;
  public ControlFrame(PApplet _parent) {
    super();   
    parent = _parent;
    controlW=parent.width;
    controlH=250;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  public void settings() {
    fullScreen();
    size(controlW, controlH);
  }
  public void setup() {
    this.surface.setSize(controlW, controlH);
    this.surface.setAlwaysOnTop(true);
    this.surface.setLocation(size.surfacePositionX, size.surfacePositionY+parent.height+5);
    colorMode(HSB, 360, 100, 100);
    myFont = createFont("Lucida Sans", 18);
    textFont(myFont);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();
    cp5 = new ControlP5(this);
    // slider colours
    color act = #07E0D3;
    color act1 = #00FC84;
    color bac = #370064;
    color bac1 = #4D9315;
    color slider = #E07F07;
    color slider1 = #E0D607;
    float x = 10;
    float y = 90;
    sliderY=y;
    int wide = 80;           // x size of sliders
    int high = 14;           // y size of slider
    row = high +4;     // distance between rows
    clm = 210;         // distance between coloms
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// FIRST COLOUM OF SLIDERS ////////////////////////////////////////////
    cp5.addSlider("vizTimeSlider") // name used throughout sketch to link to slider
      .plugTo(parent, "vizTimeSlider")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("colorTimerSlider")
      .plugTo(parent, "colorTimerSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.45) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("colorSwapSlider")
      .plugTo(parent, "colorSwapSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("rigg.alphaRate")
      .plugTo(parent, "rigg.alphaRate")
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.45) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("rigg.funcRate")
      .plugTo(parent, "rigg.funcRate")
      .setPosition(x, y+row*4)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("manualSlider")
      .plugTo(parent, "manualSlider")
      .setPosition(x, y+row*5)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    ///////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// SECOND coloum of sliders ///////////////////////////////////////
    x =+ clm;
    cp5.addSlider("boothDimmer")
      .plugTo(parent, "boothDimmer")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.36)    // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("digDimmer")
      .plugTo(parent, "digDimmer")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.2) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("uvDimmer")
      .plugTo(parent, "uvDimmer")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.32) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("controllerDimmer")
      .plugTo(parent, "controllerDimmer")
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.4) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("cansAlpha")
      .plugTo(parent, "cansAlpha")
      .setPosition(x, y+row*4)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.6) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("deleteMeSlider")
      .plugTo(parent, "deleteMeSlider")
      .setPosition(x, y+row*5)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.65) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// THIRD coloum of sliders //////////////////////////////////
    x +=clm;
    cp5.addSlider("cansDimmer")
      .plugTo(parent, "cansDimmer")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(cc[5])    // start value []ppof slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("roofDimmer")
      .plugTo(parent, "roofDimmer")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(cc[8]) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("rigDimmer")
      .plugTo(parent, "rigDimmer")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(cc[4])    // start value []ppof slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
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
    cp5.addSlider("blurSlider")
      .plugTo(parent, "blurSlider")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.3) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("stutterSlider")
      .plugTo(parent, "stutterSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
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
    cp5.addSlider("pauseSlider")
      .plugTo(parent, "pauseSlider")
      .setPosition(x, y+row*5)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0.5, 5)
      .setValue(1) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;  
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////// BUTTONS ///////////////////////////////////////////////////////////////
    x +=clm;
    cp5.addToggle("rigg.toggle")
      .plugTo(parent, "rigg.toggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(rigg.toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ; 
    x += 60;
    cp5.addToggle("roof.toggle")
      .plugTo(parent, "roof.toggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(roof.toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 60;
    cp5.addToggle("cans.toggle")
      .plugTo(parent, "cans.toggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(cans.toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 60;
    cp5.addToggle("donut.toggle")
      .plugTo(parent, "donut.toggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(cans.toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 80;
    cp5.addToggle("onTop")
      .plugTo(parent, "onTop")
      .setPosition(x, y)
      .setSize(20, 20)
      .setValue(onTop)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addToggle("glitchToggle")
      .plugTo(parent, "glitchToggle")
      .setPosition(x, y+35)
      .setSize(20, 20)
      .setValue(glitchToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 80;
    cp5.addToggle("roofbasic")
      .plugTo(parent, "roofBasic")
      .setPosition(x, y)
      .setSize(20, 20)
      .setValue(roofBasic)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addToggle("syphonToggle")
      .plugTo(parent, "syphonToggle")
      .setPosition(x, y+35)
      .setSize(20, 20)
      .setValue(syphonToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
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
    for (Rig rigs : rigs) totalAnims += rigs.animations.size();
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
    if (!rigToggle) fill(rigg.c, 100);
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
      if (!roofToggle) fill(rigg.c, 100);
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
      if (!cansToggle) fill(rigg.c, 100);
      textSize(18);
      textAlign(RIGHT);
      x = size.cans.x+(size.cansWidth/2) - 130;
      text("cansViz: " + cans.vizIndex, x, y);
      text("bkgrnd: " + cans.bgIndex, x, y+20);
      text("func's: " + cans.functionIndexA + " / " + cans.functionIndexB, x+120, y);
      text("alph's: " + cans.alphaIndexA + " / " + cans.alphaIndexB, x+120, y+20);
    }
    /////////////////////////////////////////////////// cans info ////////////////////////////////////////////////////////
    if (size.donutHeight > 0 && size.donutHeight > 0) {
      fill(rigg.c, 300);
      if (!donutToggle) fill(rigg.c, 100);
      textSize(18);
      textAlign(LEFT);
      x = size.cans.x+(size.cansWidth/2) +25;
      text("donutViz: " + donut.vizIndex, x, y);
      text("bkgrnd: " + donut.bgIndex, x, y+20);
      text("func's: " + donut.functionIndexA + " / " + donut.functionIndexB, x+120, y);
      text("alph's: " + donut.alphaIndexA + " / " + donut.alphaIndexB, x+120, y+20);
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    sequencer(675, sliderY-20);
    pauseInfo(width-5, sliderY-15);
    dividerLines();
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  void dividerLines() {
    fill(rigg.c);                              // divider for sliders
    rect(width/2, sliderY-7.5, width, 1);
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
}
