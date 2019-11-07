class CansColorLayer extends ColorLayer {
  CansColorLayer(int bgIndex) {
    super(bgIndex);
    col1 = cansColor.c;
    col2 = cansColor.flash;
    window = cansBuffer.colorLayer;
    layer = size.cans;
  }
}
class RoofColorLayer extends ColorLayer {
  RoofColorLayer(int bgIndex) {
    super(bgIndex);
    col1 = roofColor.c;
    col2 = roofColor.flash;
    window = roofBuffer.colorLayer;
    layer = size.roof;
  }
}
int rigBgr, roofBgr; 
int rigBgList = 7, roofBgList = 6;
class ColorLayer extends SketchColor {
  PGraphics window;
  color col1, col2;
  PVector layer;
  int bgIndex;

  ColorLayer(int _bgIndex) {
    window = rigBuffer.colorLayer;
    layer = size.rig;
    col1 = rigColor.c;
    col2 = rigColor.flash;
    bgIndex =_bgIndex;
  }
  void drawColorLayer() {
    switch(bgIndex) {
    case 0:
      window.beginDraw();
      window.background(0);
      oneColour(col1);
      window.endDraw();
      break;
    case 1:
      window.beginDraw();
      window.background(0);
      mirrorGradient(col1, col2, 0.5);
      window.endDraw();
      break;
    case 2:
      window.beginDraw();
      window.background(0);
      mirrorGradient(col2, col1, noize);
      window.endDraw();
      break;
    case 3:
      window.beginDraw();
      window.background(0);
      horizontalMirrorGradient(col1, col2, 1);
      window.endDraw();
      break;
    case 4:
      window.beginDraw();
      window.background(0);
      dubsonLogo(col2, col1, 0);
      window.endDraw();
      break;
    case 5:
      window.beginDraw();
      window.background(0);
      radialGradient(col1, col2, 0.3+noize1);
      window.endDraw();
      break;
    case 6:
      window.beginDraw();
      window.background(0);
      dubsonLogo(col1, col2, noize1);
      window.endDraw();
      break;
    default:
      window.beginDraw();
      window.background(0);
      oneColour(col1);
      window.endDraw();
      break;
    }
    image(window, layer.x, layer.y);
  }
  //////////////////////////////////////// END OF BACKGROUND CONTROL /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void dubsonLogo(color col1, color col2, float func) {
    window.background(col2);
    window.fill(col1);
    window.ellipse(window.width/2, window.height/2, window.width/2*(func*1.2+1), window.width/2.2*(func*1.2+1));
  }

  /////////////////////////////////// RADIAL GRADIENT BACKGROUND //////////////////////////////////////////////////////////
  void radialGradient(color col1, color col2, float function) {
    window.background(col1);
    float radius = window.height*function;
    int numPoints = 12;
    float angle=360/numPoints;
    float rotate = 90+(function*angle);
    for (  int i = 0; i < numPoints; i++) {
      window.beginShape(POLYGON); 
      window.fill(col1);
      window.vertex(cos(radians((i)*angle+rotate))*radius+window.width/2, sin(radians((i)*angle+rotate))*radius+window.height/2);
      window.fill(col2);
      window.vertex(window.width/2, window.height/2);
      window.fill(col1);
      window.vertex(cos(radians((i+1)*angle+rotate))*radius+window.width/2, sin(radians((i+1)*angle+rotate))*radius+window.height/2);
      window.endShape(CLOSE);
    }
  }
  /////////////////////////////////// VERTICAL MIRROR GRADIENT BACKGROUND ////////////////////////////////////////////////
  void mirrorGradient(color col1, color col2, float func) {
    //// LEFT SIDE OF GRADIENT
    window.beginShape(POLYGON); 
    //window.noStroke();
    window.fill(col1);
    window.vertex(0, 0);
    window.fill(col2);
    window.vertex(window.width*func, 0);
    window.fill(col2);
    window.vertex(window.width*func, window.height);
    window.fill(col1);
    window.vertex(0, window.height);
    window.endShape(CLOSE);
    //// RIGHT SIDE OF windowIENT
    window.beginShape(POLYGON); 
    window.fill(col2);
    window.vertex(window.width*func, 0);
    window.fill(col1);
    window.vertex(window.width, 0);
    window.fill(col1);
    window.vertex(window.width, window.height);
    window.fill(col2);
    window.vertex(window.width*func, window.height);
    window.endShape(CLOSE);
  }
  /// MIRROR GRADIENT BACKGROUND top one direction - bottom opposite direction ///
  void mirrorGradientHalfHalf(color col1, color col2, float func) {
    //////// TOP //// LEFT SIDE OF GRADIENT
    window.beginShape(POLYGON); 
    window.fill(col1);
    window.vertex(0, 0);
    window.fill(col2);
    window.vertex(window.width*func, 0);
    window.fill(col2);
    window.vertex(window.width*func, window.height/2);
    window.fill(col1);
    window.vertex(0, window.height/2);
    window.endShape(CLOSE);
    //// RIGHT SIDE OF windowIENT
    window.beginShape(POLYGON); 
    window.fill(col2);
    window.vertex(window.width*func, 0);
    window.fill(col1);
    window.vertex(window.width, 0);
    window.fill(col1);
    window.vertex(window.width, window.height/2);
    window.fill(col2);
    window.vertex(window.width*func, window.height/2);
    window.endShape(CLOSE);
    window.endDraw();
    //////////////////////////////////
    func = 1-func;
    window.beginDraw();
    ///// BOTTOM
    //// LEFT SIDE OF GRADIENT
    window.beginShape(POLYGON); 
    window.fill(col1);
    window.vertex(0, window.height/2);
    window.fill(col2);
    window.vertex(window.width*func, window.height);
    window.fill(col2);
    window.vertex(window.width*func, window.height);
    window.fill(col1);
    window.vertex(0, window.height/2);
    window.endShape(CLOSE);
    //// RIGHT SIDE OF windowIENT
    window.beginShape(POLYGON); 
    window.fill(col2);
    window.vertex(window.width*func, window.height/2);
    window.fill(col1);
    window.vertex(window.width, window.height/2);
    window.fill(col1);
    window.vertex(window.width, window.height);
    window.fill(col2);
    window.vertex(window.width*func, window.height);
    window.endShape(CLOSE);
  }
  /////////////////////////////////////////////////// HORIZONAL GRADIENT ///////////////////////////////////////////////////////
  void horizontalMirrorGradient(color col1, color col2, float func) {
    //// TOP HALF OF GRADIENT
    window.beginShape(POLYGON); 
    window.fill(col2);
    window.vertex(0, 0);
    window.vertex(window.width, 0);
    window.fill(col1);
    window.vertex(window.width, window.height*func);
    window.vertex(0, window.height*func);
    window.endShape(CLOSE);
    //// BOTTOM HALF OF GRADIENT 
    window.beginShape(POLYGON); 
    window.fill(col1);
    window.vertex(0, window.height*func);
    window.vertex(window.width, window.height*func);
    window.fill(col2);
    window.vertex(window.width, window.height);
    window.vertex(0, window.height);
    window.endShape(CLOSE);
  }
  ///////////////////////////////////////// ONE COLOUR BACKGOUND ////////////////////////////////////////////////////////////////
  void oneColour(color col1) {
    window.background(col1);
  }
  ////////////////////////////////////////// CHECK BACKGROUND //////////////////////////////////////////////////////////////////////////////
  void check(color col1, color col2) {
    window.fill(col2);
    window.rect(window.width/2, window.height/2, window.width, window.height);        
    ////////////////////////// Fill OPPOSITE COLOR //////////////
    window.fill(col1);  
    for (int i = 0; i < grid.mirror.length/grid.rows; i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
    for (int i = grid.columns+1; i < grid.mirror.length/grid.rows+grid.columns; i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
    if (grid.rows == 3) for (int i = grid.columns*grid.rows; i < grid.mirror.length/grid.rows+(grid.columns*2); i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
  }
  /////////////////////////// TOP ROW ONE COLOUR BOTTOM ROW THE OTHER BACKGORUND ////////////////////////////////////////////////////////////////
  void sideBySide( color col1, color col2) {
    /////////////// TOP RECTANGLE ////////////////////
    window.fill(col2);
    window.rect(window.width/4, window.height/2, window.width/2, window.height);     
    /////////////// BOTTOM RECTANGLE ////////////////////
    window.fill(col1);                                
    window.rect(window.width/4*3, window.height/2, window.width/2, window.height);
  }
}
