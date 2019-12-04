class Rig {
  float dimmer;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex, vizIndex;
  PGraphics colorLayer, buffer, pass1, pass2;
  PVector size;
  color c, flash, c1, flash1, clash, colorIndexA, colorIndexB = 1;
  color col[] = new color[15];
  PVector position[] = new PVector[12];
  PVector positionX[][] = new PVector[7][3];

  Rig(float _xpos, float _ypos, int _wide, int _high) {
    wide = _wide;
    high = _high;
    size = new PVector (_xpos, _ypos);

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
}
