class Rig {
  float dimmer;
  int wide, high, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, bgIndex;
  PGraphics colorLayer, buffer, pass1, pass2, window;
  PVector position[], positionX[][], size;
  color c, flash, c1, flash1, clash, colorIndexA, colorIndexB = 1;
  color col[] = new color[15];

  Rig(float _xpos, float _ypos, int _wide, int _high, PVector _position[],PVector _positionX[][]) {
    wide = _wide;
    high = _high;
        
    println("rig.size", _xpos, _ypos);
    println();

    position = _position;
    positionX = _positionX;
    size = new PVector (_xpos, _ypos);

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
    
    window = buffer;

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
