import controlP5.*;
ControlP5 cp5;

boolean glitchToggle, cansToggle = false, roofToggle = false, rigToggle = true, roofBasic = false;
float vizTimeSlider, colorSwapSlider, colorTimerSlider, cansDimmer, boothDimmer, digDimmer, backDropSlider, cansSlider;
float tweakSlider, blurSlider, bgNoiseBrightnessSlider, bgNoiseDensitySlider, manualSlider, stutterSlider, cansAlpha, deleteMeSlider;
float shimmerSlider, alphaSlider, rigDimmer, roofDimmer, seedsDimmer, seed2Dimmer, uvDimmer, controllerDimmer, funcSlider, pauseSlider;
float smokePump, smokeFan, smokeOnTime, smokeOffTime;

class ControlFrame extends PApplet {
  int controlW, controlH;
  float clm, row;
  PApplet parent;
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    controlW=_w;
    controlH=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  public void settings() {
    size(controlW, controlH);
  }
  public void setup() {
    this.surface.setAlwaysOnTop(true);
    this.surface.setLocation(size.surfacePositionX, size.surfacePositionY+parent.height+30);
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
    float y = 20;
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
    cp5.addSlider("alphaSlider")
      .plugTo(parent, "alphaSlider")
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.45) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("funcSlider")
      .plugTo(parent, "funcSlider")
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
    cp5.addToggle("rigToggle")
      .plugTo(parent, "rigToggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(rigToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ; 
    x += 60;
    cp5.addToggle("roofToggle")
      .plugTo(parent, "roofToggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(roofToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 60;
    cp5.addToggle("cansToggle")
      .plugTo(parent, "cansToggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(cansToggle)
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
  }
  void draw() {
    background(0);
    fill(rigColor.c);
    rect(width/2, 0, width, 2);

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
