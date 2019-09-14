import controlP5.*;
ControlFrame controlFrame;

float vizTimeSlider, colorSwapSlider, colorTimerSlider, bgDimmer, boothDimmer, digDimmer, roofPulse, backParsSlider, backDropSlider, cansSlider, movesSlider;
float cansPulse, cans1Pulse, cans2Pluse, cans3Pulse, speedSlider, tweakSlider, testSlider3, blurSlider, rigDimmer, multiViz1, multiViz2, multiViz3;
float shimmerSlider, beatSlider, boothParSlider, backParSlider, secondVizSlider, roofDimmer, frontParsDimmer, rearParsDimmer;
float frontSeedLevel, rearSeedLevel, eggDimmer, smokePump, smokeOnTime,smokeOffTime, smallSeedsSlider, bigSeedsSlider;

class ControlFrame extends PApplet {

  int controlW, controlH;
  PApplet parent;
  ControlP5 cp5;

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
    surface.setAlwaysOnTop(true);
    surface.setLocation(size.surfacePositionX, size.surfacePositionY+parent.height);

    rectMode(CENTER);
    ellipseMode(CENTER);
    imageMode(CENTER);
    noStroke();

    cp5 = new ControlP5(this);

    // slider colours
    color act = #07E0D3;
    color act1 = #00FC84;
    color bac = #370064;
    color bac1 = #225F01;
    color slider = #E07F07;
    color slider1 = #E0D607;
    /// font for slider info
    //PFont pfont = createFont("Abadi MT Condensed Light", 16, true);  // what the fuk?!
    //ControlFont font = new ControlFont(pfont);

    float x = 10;
    float y = 20;
    int wide = 80;           // x size of sliders
    int high = 14;           // y size of slider
    float row = high +4;     // distance between rows
    float clm = 210;         // distance between coloms

    //////////////////////////////// FIRST COLOUM OF SLIDERS
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
    ////////////////////////////////// 2nd coloum of sliders
    cp5.addSlider("boothDimmer")
      .plugTo(parent, "boothDimmer")
      .setPosition(x+clm, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.4)    // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("digDimmer")
      .plugTo(parent, "digDimmer")
      .setPosition(x+clm, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.6) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("eggDimmer")
      .plugTo(parent, "eggDimmer")
      .setPosition(x+clm, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.4) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;

    x +=clm+clm;
    ///////////////////////////////// third coloum of sliders
    cp5.addSlider("frontSeedLevel")
      .plugTo(parent, "frontSeedLevel")

      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.0)    // start value []ppof slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("rearSeedLevel")
      .plugTo(parent, "rearSeedLevel")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.3) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("beatSlider")
      .plugTo(parent, "beatSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.85) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x+= clm;
    /////////////////////////////// FOURTH coloum of sliders
    cp5.addSlider("cansSlider")
      .plugTo(parent, "cansSlider")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.8) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("smallSeedsSlider")
      .plugTo(parent, "smallSeedsSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(1) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("bigSeedsSlider")
      .plugTo(parent, "bigSeedsSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;

    x+=clm;   
    /////////////////////////////// FITH coloum of sliders
    cp5.addSlider("roofDimmer")
      .plugTo(parent, "roofDimmer")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.8) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("frontParsDimmer")
      .plugTo(parent, "frontParsDimmer")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.2) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("rearParsDimmer")
      .plugTo(parent, "rearParsDimmer")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.3) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    x+=clm;
    ///////////////////////////////// SIXTH coloum of sliders
    cp5.addSlider("rigDimmer")
      .plugTo(parent, "rigDimmer")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(dimmer)    // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("shimmerSlider")
      .plugTo(parent, "shimmerSlider")      .setPosition(x, y+row)
      .setPosition(x, y+row)
      .setSize(wide, high)
      .setRange(0, 1)
      .setValue(0.5) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("smokePump")
      .plugTo(parent, "smokePump")      .setPosition(x, y+row)
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      .setRange(0, 1)
      .setValue(0.75) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
      cp5.addSlider("smokeOnTime")
      .plugTo(parent, "smokeOnTime")      .setPosition(x, y+row)
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      .setRange(0, 1)
      .setValue(0.5) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
       cp5.addSlider("smokeOffTime")
      .plugTo(parent, "smokeOffTime")      .setPosition(x, y+row)
      .setPosition(x, y+row*4)
      .setSize(wide, high)
      .setRange(0, 1)
      .setValue(0.5) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;


    /////////////////////// test sliders to change variables vertical 
    //cp5.addSlider("speedSlider")
    //  .setPosition(5, 130)
    //  .setSize(high, wide)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0.5) // start value of slider
    //  .setColorActive(act1) 
    //  .setColorBackground(bac1) 
    //  .setColorForeground(slider1) 
    //  ;
    //cp5.addSlider("tweakSlider")
    //  .setPosition(5, 230)
    //  .setSize(high, wide)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0.2) // start value of slider
    //  .setColorActive(act) 
    //  .setColorBackground(bac) 
    //  .setColorForeground(slider) 
    //  ;
    //cp5.addSlider("testSlider3")
    //  .setPosition(5, 530)
    //  .setSize(high, wide)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0.5) // start value of slider
    //  .setColorActive(act1) 
    //  .setColorBackground(bac1) 
    //  .setColorForeground(slider1) 
    //  ;
  }

  void draw() {
    background(0);
    fill(c);
    rect(width/2, 0, width, 2);
  }
}
