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
int rigBgList = 6, roofBgList = 6;
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
      sideBySide(col2, col1);
      window.endDraw();
      break;
    case 3:
      window.beginDraw();
      window.background(0);
      check(col1, col2);
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
      mirrorGradient2(col1, col2, 1);
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

  ///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////

  /// MIRROR GRADIENT BACKGROUND ///
  void mirrorGradient(color col1, color col2, float func) {
    //// LEFT SIDE OF GRADIENT
    window.beginShape(POLYGON); 
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
  /// MIRROR GRADIENT BACKGROUND ///
  void mirrorGradient2(color col1, color col2, float func) {

    //////// TOP
    //// LEFT SIDE OF GRADIENT
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

  void horizontalMirrorGrad(color col1, color col2, float func) {

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

  /// ONE COLOUR BACKGOUND ///
  void oneColour(color col1) {
    window.background(col1);
  }

  void checkSymmetrical(color col1, color col2) {
    /////////////// FILL COLOR ////////////////////
    window.fill(col1);
    ///////////////  BACKGROUND /////////////
    window.rect(window.width/2, window.height/2, window.width, window.height);     
    ////////////////// Fill OPPOSITE COLOR //////////////
    window.fill(col2);    
    window.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[3].x, grid.mirror[3].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[8].x, grid.mirror[8].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
  }

  /// CHECK BACKGROUND ///
  void check(color col1, color col2) {

    window.background(col1);
    ////////////////// Fill OPPOSITE COLOR //////////////
    window.fill(col2);     
    for (int i = 0; i < grid.mirror.length/grid.rows; i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
    //for (int i = grid.columns+1; i < grid.mirror.length/grid.rows+grid.columns; i++)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
    //if(grid.rows == 3) for (int i = grid.columns*grid.rows ; i < grid.mirror.length/grid.rows+(grid.columns*2); i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
  }

  void corners( color col1, color col2) {
    /////////////// TOP RECTANGLE ////////////////////
    window.fill(col2);
    window.rect(window.width/2, window.height/2, window.width, window.height);     
    /////////////// BOTTOM RECTANGLE ////////////////////
    window.fill(col1);                                
    window.rect(grid.mirror[0].x, grid.mirror[0].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[1].x, grid.mirror[1].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[4].x, grid.mirror[4].y, grid.mirrorWidth, grid.mirrorWidth);

    window.rect(grid.mirror[7].x, grid.mirror[7].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[10].x, grid.mirror[10].y, grid.mirrorWidth, grid.mirrorWidth);
    window.rect(grid.mirror[11].x, grid.mirror[11].y, grid.mirrorWidth, grid.mirrorWidth);
  }
  /// TOP ROW ONE COLOUR BOTTOM ROW THE OTHER BACKGORUND///
  void sideBySide( color col1, color col2) {
    /////////////// TOP RECTANGLE ////////////////////
    window.fill(col2);
    window.rect(window.width/4, window.height/2, window.width/2, window.height);     
    /////////////// BOTTOM RECTANGLE ////////////////////
    window.fill(col1);                                
    window.rect(window.width/4*3, window.height/2, window.width/2, window.height);
  }

  //// top left and bottom right 3 mirror opposite colours /////
  void cross( color col1, color col2) {
    window.background(col1);
    window.fill(col2);
    window.rect(grid.mirror[5].x, grid.mirror[5].y, grid.mirrorAndGap*3, grid.mirrorWidth);    
    window.rect(grid.mirror[6].x, grid.mirror[6].y, grid.mirrorAndGap*3, grid.mirrorWidth);
  }
  void gradMirror(color col1, color col2) {
    window.background(col1);

    //// TOP HALF OF GRADIENT
    //window.beginShape(POLYGON); 
    //window.fill(col2);
    //window.vertex(grid.mirror[0].x-(grid.mirrorWidth/2),grid.mirror[0].y-(grid.mirrorWidth/2));
    //window.vertex(grid.mirror[0].x+(grid.mirrorWidth/2),grid.mirror[0].y+(grid.mirrorWidth/2));
    //window.fill(col1);
    //window.vertex(grid.mirror[0].x-(grid.mirrorWidth/2),grid.mirror[0].y+(grid.mirrorWidth/2));
    for (int i = 0; i < 6; i++) {
      window.beginShape(POLYGON); 
      window.fill(col1);
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.fill(col2);
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.fill(col1);
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.endShape(CLOSE);

      window.beginShape(POLYGON); 
      window.fill(col1);
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.fill(col2);
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.fill(col1);
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.endShape(CLOSE);
    }

    for (int i = 6; i < 12; i++) {
      window.beginShape(POLYGON); 
      window.fill(col1);
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.fill(col2);
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.fill(col1);
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.endShape(CLOSE);

      window.beginShape(POLYGON); 
      window.fill(col1);
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.fill(col2);
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y-(grid.mirrorWidth/2));
      window.vertex(grid.mirror[i].x-(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.fill(col1);
      window.vertex(grid.mirror[i].x+(grid.mirrorWidth/2), grid.mirror[i].y+(grid.mirrorWidth/2));
      window.endShape(CLOSE);
    }
  }

  void cans(color col1) {
    window.fill(col1);
    window.rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
    window.rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);
    window.rect(grid.cans[2].x, grid.cans[2].y, grid.cansLength, 3);
  }
}
