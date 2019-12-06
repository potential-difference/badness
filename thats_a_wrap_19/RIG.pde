class Rig {
  float dimmer = 1;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  color c, flash, c1, flash1, clash, colorIndexA, colorIndexB = 1;
  color col[] = new color[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];
  String name;
  SketchColor scolor;
  ColorLayer clayer;
  //PApplet parent;
  Rig rig;

  Rig(PApplet parent, float _xpos, float _ypos, int _wide, int _high, String _name) {
    //parent = getparent();
    //parent = _parent;
    //println(parent);
    //parent.registeethod("draw", this);


    rig = this;
    name = _name;
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);
    scolor = new SketchColor(this);//e.g rigColor -> rigg.scolor.flash
    clayer = new ColorLayer(this);

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
    stroke(rigg.flash,60);
    strokeWeight(1);
    rect(x, y-(textHeight/2)+3, nameWidth+17, 30);
    noStroke();
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///// RECTANGLES TO SHOW CURRENT COLOURS /////
    x = size.x+(wide/2)-(nameWidth+17)-30;
    y = size.y-(high/2)+20;

    fill(0);
    rect(x, y-10, 10, 10);               // rect to show CURRENT color C 
    rect(x+15, y-10, 10, 10);              // rect to show NEXT color C 
    rect(x, y, 10, 10);                  // rect to show CURRENT color FLASH 
    rect(x+15, y, 10, 10);                 // rect to show NEXT color FLASH1

    fill(0, 100);
    stroke(rigg.flash,60);
    strokeWeight(1);
    rect(x+7.5, y-5, 30, 30);

    stroke(0);
    fill(rig.c);          
    rect(x, y-10, 10, 10);               // rect to show CURRENT color C 
    fill(rig.col[(rig.colorIndexA+1)%rig.col.length], 100);
    rect(x+15, y-10, 10, 10);              // rect to show NEXT color C 
    fill(rig.flash);
    rect(x, y, 10, 10);                  // rect to show CURRENT color FLASH 
    fill(rig.col[(rig.colorIndexB+1)%rig.col.length], 100);  
    rect(x+15, y, 10, 10);                 // rect to show NEXT color FLASH1
    noStroke();
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  PApplet getparent () {
    try {
      return (PApplet) getClass().getDeclaredField("this$0").get(this);
    }
    catch (ReflectiveOperationException cause) {
      throw new RuntimeException(cause);
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void draw() {
    //info();
  }
}




//void clash (){
//  scolor.clash();
//}
