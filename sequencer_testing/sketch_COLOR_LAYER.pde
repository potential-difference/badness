int rigBgList = 6, roofBgList = 6;
class ColorLayer extends SketchColor {
  PGraphics window;
  color col1, col2;
  PVector layer;
  int bgIndex;
  Rig rig;

  ColorLayer(Rig _rig) {
    super(_rig);
    rig = _rig;
    bgIndex = rig.bgIndex;
    window = rig.colorLayer;
    layer = rig.size;
    col1 = rig.c;
    col2 = rig.flash;
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
      sideBySide(col2, col1);
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
      oneColour(col2);
      window.endDraw();
      break;
    case 5:
      window.beginDraw();
      window.background(0);
      horizontalMirrorGradient(col1, col2, noize1);
      window.endDraw();
      break;
    case 6:
      window.beginDraw();
      window.background(0);
      check(col1, col2);
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
    for (int i = 0; i < opcGrid.mirror.length/opcGrid.rows; i+=2)  window.rect(opcGrid.mirror[i].x, opcGrid.mirror[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    for (int i = opcGrid.columns+1; i < opcGrid.mirror.length/opcGrid.rows+opcGrid.columns; i+=2)  window.rect(opcGrid.mirror[i].x, opcGrid.mirror[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
    if (opcGrid.rows == 3) for (int i = opcGrid.columns*opcGrid.rows; i < opcGrid.mirror.length/opcGrid.rows+(opcGrid.columns*2); i+=2)  window.rect(opcGrid.mirror[i].x, opcGrid.mirror[i].y, opcGrid.mirrorWidth, opcGrid.mirrorWidth);
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
