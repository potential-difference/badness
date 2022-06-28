//can these go inside MainControlFrame?
boolean testToggle, smokeToggle;
float boothDimmer, digDimmer, vizTime, colorTime, colorSwapSlider, beatSlider = 0.3;
float smokePumpValue, smokeOnTime, smokeOffTime;

class MainControlFrame extends ControlFrame {
  //private boolean initialized = false;
  MainControlFrame(PApplet _parent, int _controlW, int _controlH, int _xpos, int _ypos) {
    super (_parent, _controlW, _controlH, _xpos, _ypos);
  }
  void setup() {
    super.setup();
    /////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    this.x = this.width-65;
    this.wide = 20;
    this.high = 20;
    rigg = new Rig(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight, "RIG");

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// GLOBAL SLIDERS ///////////////////////////////////////////////////////////

    x = 450;
    y = 90;
    wide = 120;           // x size of sliders
    high = 16;           // y size of slider
    row = high +4;       // distance between rows
    loadSlider("boothDimmer", x, y, wide, high, 0, 1, 0.32, act1, bac1, slider1);
    this.cp5.getController("boothDimmer").setLabel("booth dimmer");
    loadSlider("digDimmer", x, y+row, wide, high, 0, 1, 0.2, act, bac, slider);
    this.cp5.getController("digDimmer").setLabel("dig dimmer");
    loadSlider("vizTime", x, y+row*2, wide, high, 0.5, 30, 5, act1, bac1, slider1);
    this.cp5.getController("vizTime").setLabel("viz timer");

    loadSlider("colorTime", x, y+row*3, wide, high, 0.5, 30, 6, act, bac, slider);
    this.cp5.getController("colorTime").setLabel("color timer");
    loadSlider("colorSwapSlider", x, y+row*4, wide, high, 0, 1, 0.9, act1, bac1, slider1);
    this.cp5.getController("colorSwapSlider").setLabel("color swap");


    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    MCFinitialized = true;
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
    if (!rigg.toggle) fill(rigg.c, 100);
    text("rigViz: " + rigg.availableAnims[rigg.vizIndex], x, y);
    text("bkgrnd: " + rigg.availableBkgrnds[rigg.bgIndex], x, y+20);
    text("func's: " + rigg.availableFunctionEnvelopes[rigg.functionIndexA] + " / " + rigg.availableFunctionEnvelopes[rigg.functionIndexB], x+110, y);
    text("alph's: " + rigg.availableAlphaEnvelopes[rigg.alphaIndexA] + " / " + rigg.availableAlphaEnvelopes[rigg.alphaIndexB], x+110, y+20);
    /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
    ///// NEXT VIZ IN....
    x=250;
    fill(rigg.c, 300);

    String sec = nf(int(vizTime*60 - (millis()/1000 - vizTimer)) % 60, 2, 0);
    int min = int(vizTime*60 - (millis()/1000 - vizTimer)) /60 % 60;
    text("next viz in: "+min+":"+sec, x, y);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(int(colorTime*60 - (millis()/1000 - rigg.colorTimer)) %60, 2, 0);
    min = int(colorTime*60 - (millis()/1000 - rigg.colorTimer)) /60 %60;
    text("next color in: "+ min+":"+sec, x, y+20);
    //text("c-" + rigg.colorIndexA + "  " + "flash-" + rigg.colorIndexB, x, y+40);

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    int sliderY =90;
    sequencer(rigg.wide, sliderY-20);
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
  }
  void setup() {
    super.setup();
    surface.setAlwaysOnTop(onTop);
    x = 10;
    y = 10;
    wide = 120;           // x size of sliders
    high = 16;           // y size of slider
    row = high +4;       // distance between rows
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// GLOBAL SLIDERS ///////////////////////////////////////////////////////////
    /*
    loadSlider("boothDimmer", x, y, wide, high, 0, 1, 0.32, act1, bac1, slider1);
    this.cp5.getController("boothDimmer").setLabel("booth dimmer");
    loadSlider("digDimmer", x, y+row, wide, high, 0, 1, 0.2, act, bac, slider);
    this.cp5.getController("digDimmer").setLabel("dig dimmer");
    loadSlider("vizTime", x, y+row*2, wide, high, 0.5, 30, 5, act1, bac1, slider1);
    this.cp5.getController("vizTime").setLabel("viz timer");

    loadSlider("colorTime", x, y+row*3, wide, high, 0.5, 30, 6, act, bac, slider);
    this.cp5.getController("colorTime").setLabel("color timer");
    loadSlider("colorSwapSlider", x, y+row*4, wide, high, 0, 1, 0.9, act1, bac1, slider1);
    this.cp5.getController("colorSwapSlider").setLabel("color swap");
*/
    high = 12;
    int gap =  high +4;
    y = this.y+row*11;
    for (int i =0; i<16; i+=2) {
      // load sliders that work as equlilavent for midi knobs
      String name = "slider "+i;
      String name1 = "slider "+(i+1);
      loadSlider( name, x, y+(i*gap), wide, high, 0, 1, 0.32, act1, bac1, slider1);
      loadSlider( name1, x, y+gap+(i*gap), wide, high, 0, 1, 0.32, act, bac, slider);
    }
    // bang buttons work as equlilivant to midi pad buttons

    SFinitialized = true;
  }
  //draw depends on both sliderframe and main control frame
  void draw() {

    surface.setAlwaysOnTop(onTop);
    background(0);
    dividerLines();
  }
}

class ControlFrame extends PApplet {
  int controlW, controlH, wide, high, xpos, ypos;
  float clm, row, x, y;
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
    //fullScreen();
  }
  public void setup() {
    frameRate(10);
    this.surface.setSize(controlW, controlH);
    this.surface.setAlwaysOnTop(onTop);
    //this.surface.setLocation(xpos, ypos);
    //pixelDensity(2);
    colorMode(HSB, 360, 100, 100);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();
    cp5 = new ControlP5(this);
    cp5.getProperties().setFormat(ControlP5.SERIALIZED);
  }
  void draw() {  
    /// override in subclass
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void loadSlider(String label, float _x, float _y, int _wide, int _high, float min, float max, float startVal, color act1, color bac1, color slider1) {
    this.cp5.addSlider(label)
      .plugTo(parent, label)
      .setPosition(_x, _y)
      .setSize(_wide, _high)
      //.setFont(font)
      .setRange(min, max)
      .setValue(startVal)    // start value of slider
      .setColorActive(color(act1, 200)) 
      .setColorBackground(color(bac1, 200)) 
      .setColorForeground(color(slider1, 200)) 
      ;
  }
  void loadToggle(String label, Boolean toggle, float x, float y, int wide, int high, color bac1, color bac, color slider) {
    this.cp5.addToggle(label)
      .plugTo(parent, label)
      .setPosition(x, y)
      .setSize(wide, high)
      .setValue(toggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(act) 
      ;
  }

  //////////////////////////////////////// CALL BACK FOR SLIDER CONTROL FROM OTHER VARIABLES
  public void rigDimmer(float theValue) {
    int value = int(map(theValue, 0, 1, 0, 127));
    LPD8bus.sendControllerChange(0, 4, value) ;
  }
  void dividerLines() {
    fill(rigg.c, 200);                         // box around the outside
    rect(width/2, height-1, width, 1);  
    rect(width/2, 0, width, 1);                              
    rect(0, height/2, 1, height);
    rect(width-1, height/2, 1, height);
  }
  void sequencer(float x, float y) {
    int dist = 20;
    fill(rigg.flash, 100);
    for (int i = 0; i<(16); i++) rect(10+i*dist+x, y, 10, 10);
    fill(rigg.c);
    for (int i = 0; i<(16); i++) if (int(beatCounter%(16)) == i) rect(10+i*dist+x, y, 10, 10);
    textAlign(LEFT);
    textSize(14);
    text("BC: "+beatCounter, x+(16*dist), y+5);
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
    //float[] arrayValue = theEvent.getArrayValue();
    int someDelay = 120; // silence at startup
    for (Rig rig : rigs) {                        
      if (theEvent.isFrom(rig.ddVizList)) {
        if (frameCount > someDelay)    println(rig.name+" viz selected "+intValue);
        rig.vizIndex = intValue;
      }
      if (theEvent.isFrom(rig.ddBgList)) {
        if (frameCount > someDelay)    println(rig.name+" background selected "+intValue);
        rig.bgIndex = intValue;
      }
      if (theEvent.isFrom(rig.ddAlphaListA)) {
        if (frameCount > someDelay)    println(rig.name+" alpahA selected "+intValue);
        rig.alphaIndexA = intValue;
      }
      if (theEvent.isFrom(rig.ddFuncListA)) {
        if (frameCount > someDelay)   println(rig.name+" funcA selected "+intValue);
        rig.functionIndexA = intValue;
      }
      if (theEvent.isFrom(rig.ddAlphaListB)) {
        if (frameCount > someDelay)  println(rig.name+" alpahB selected "+intValue);
        rig.alphaIndexB = intValue;
      }
      if (theEvent.isFrom(rig.ddFuncListB)) {
        if (frameCount > someDelay)   println(rig.name+" funcB selected "+intValue);
        rig.functionIndexB = intValue;
      }
      try {
        if (intValue >= 0) {
          if (theEvent.isFrom(rig.flashRadioButton)) {
            if (frameCount > someDelay)     println(rig.name+" C plugged to index: "+intValue);
            rig.colorIndexB = intValue;
          }
          if (theEvent.isFrom(rig.cRadioButton)) {
            if (frameCount > someDelay)     println(rig.name+" FLASH plugged to index: "+intValue);
            rig.colorIndexA = intValue;
          }
        }
      }
      catch (Exception e) {
        println(e);
        println("*** !!COLOR PLUGGING WRONG!! ***");
      }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (theEvent.isController()) {
      if (frameCount > someDelay)   println("- controller "+theEvent.getController().getName()+" "+theEvent.getValue());
      try {
        if (theEvent.getController().getName().startsWith("slider")) {
          String name = theEvent.getController().getName();
          setCCfromController(name, value);
        }
        //   if( theEvent.getController().getName().startsWith("bang")){
        //     for (int i=0;i<col.length;i++) {
        //if (theEvent.getController().getName().equals("bang"+i)) {
        //  col[i] = color(random(255));
        //}
      }
      catch (Exception e) {
        println(e);
        println("*** !!SOMETHING WRONG WITH YOUR SLIDER MAPPING YO!! ***");
      }
    }
    //if (theEvent.isGroup()) println("- group "+theEvent.getName()+" "+theEvent.getValue());
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
}
void setCCfromBang(String name, float value) {
}

void setCCfromController(String name, float value) {
  int ones = int(name.substring(7, 8));
  int tens = 0;
  if (name.length() > 8) {
    tens = int(name.substring(7, 8));
    ones = int(name.substring(8, 9));
  }
  int  index = tens * 10 + ones + 40;
  cc[index] = value;

  int someDelay = 120; // silence at startup
  if (frameCount > someDelay) println("set cc["+index+"]", value);
}
