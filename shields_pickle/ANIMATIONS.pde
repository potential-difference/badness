// the idea of this was to have a separate alphaRate
// but it's not set anywhere. maybe cp5 used to do it?
// oh, does what's it called touchosc change it?
// you'd have to have a slider in touchosc do it
// we should at least set a default
abstract class ManualAnim extends Anim {
  ManualAnim(Rig _rig) {
    super(_rig);
    rig.alphaRate = rig.manualAlpha;
  }
  void draw() {
  }
  void drawAnim() {
    super.drawAnim();
    window.beginDraw();
    window.background(0);
    draw();
    window.endDraw();
    image(window, rig.size.x, rig.size.y, window.width, window.height);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class AllOn extends Anim {
  AllOn(Rig _rig) {
    super( _rig);
    rig.alphaRate=rig.manualAlpha;
    animName = "AllOn";
  }
  void draw() {
    window.beginDraw();
    window.background(360*alphaA);
    window.endDraw();
  }
}
class AllOnForever extends Anim {
  float __velocity;
  AllOnForever(Rig _rig, float _velocity){
    super(_rig);
    __velocity = _velocity;
  }
  void draw(){
    window.beginDraw();
    window.background(360*__velocity);
    window.endDraw();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class AllOff extends Anim {
  AllOff(Rig _rig) {
    super( _rig);
    rig.alphaRate=rig.manualAlpha;
    animName = "AllOff";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class StarMesh extends Anim {
  StarMesh ( Rig _rig) {
    super (_rig);
    animName = "starMesh";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = (rig.high+rig.wide)/(rig.wide/15);
    stroke *= strokeSlider+0.1;

    wide = (10+(functionA*rig.wide*1.5));
    high = (10+((1-functionA)*rig.high*1.5));
    rotate = -30*functionB;

    switch (rig.type){
      case Shields:
      ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(rig.opcgrid);
      star(opcGrid.smallShieldA.x,opcGrid.smallShieldA.y, col1, stroke, wide, high, rotate, alphaA);
      star(opcGrid.smallShieldB.x,opcGrid.smallShieldB.y, col1, stroke, wide, high, rotate, alphaA);
      star(opcGrid.smallShieldC.x,opcGrid.smallShieldC.y, col1, stroke, wide, high, rotate, alphaA);
      break;
      default:
      star(window.width/6, window.height/6, col1, stroke, wide, high, -rotate, alphaA);
      star(window.width/6*5, window.height/6, col1, stroke, wide, high, -rotate, alphaA);
      star(window.width/2, window.height/6*5, col1, stroke, wide, high, -rotate, alphaA);
    }
    window.endDraw();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Celtic extends Anim {
  Celtic (Rig _rig) {
    super(_rig);
    animName = "Celtic";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = (10+(functionA*rig.wide*1.5));
    high = (10+((1-functionA)*rig.high*1.5));
    stroke = 10+((rig.high+rig.wide)/40*strokeSlider); 
    rotate = 0;
    switch(rig.type){
      case Shields:
        ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(rig.opcgrid);
        donut(positionX[9][0].x, positionX[9][0].y, col1, stroke, wide, high, rotate, alphaA);
        donut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, rotate-60, alphaA);
        donut(positionX[15][0].x, positionX[15][0].y, col1, stroke, wide, high, rotate+60, alphaA);
      break;
      default:
        donut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, rotate, alphaA);
        donut(positionX[3][1].x, positionX[3][1].y, col1, stroke, wide, high, rotate-90, alphaA);
        donut(positionX[3][2].x, positionX[3][2].y, col1, stroke, wide, high, rotate+90, alphaA);
    }
    window.endDraw();
  }
}

class SpiralFlower extends Anim {
  SpiralFlower(Rig _rig) {
    super(_rig);
    animName = "SpiralFlower";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = (rig.high+rig.wide)/40*strokeSlider;
    wide = 5+(wide-(wide*functionA)); 
    high = wide;
    rotate = 0;
    switch(rig.type){
      case Shields:
      donut(positionX[1][0].x, positionX[1][0].y, col1, stroke, wide, high, rotate, alphaA);
      donut(positionX[5][1].x, positionX[5][1].y, col1, stroke, wide, high, rotate, alphaA);
      donut(positionX[7][2].x, positionX[7][2].y, col1, stroke, wide, high, rotate, alphaA);

      donut(positionX[7][0].x, positionX[7][0].y, col1, stroke, wide, high, rotate, alphaA);
      donut(positionX[11][1].x, positionX[11][1].y, col1, stroke, wide, high, rotate, alphaA);
      donut(positionX[13][2].x, positionX[13][2].y, col1, stroke, wide, high, rotate, alphaA);

      donut(positionX[13][0].x, positionX[13][0].y, col1, stroke, wide, high, rotate, alphaA);
      donut(positionX[17][1].x, positionX[17][1].y, col1, stroke, wide, high, rotate, alphaA);
      donut(positionX[1][2].x, positionX[1][2].y, col1, stroke, wide, high, rotate, alphaA);

    default:
    //  donut(positionX[1][0].x, positionX[1][0].y, col1, stroke, wide, high, rotate, alphaA);
    //   donut(positionX[5][1].x, positionX[5][1].y, col1, stroke, wide, high, rotate, alphaA);
    //   donut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, rotate, alphaA);
    }
    window.endDraw();
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BenjaminsBoxes extends Anim {
  BenjaminsBoxes (Rig _rig) {
    super(_rig);
    animName = "BenjaminsBoxes";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 600;
    high = 1000;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    rotate = 45+(15*noize); //+(functionB*30);
    float xpos = 10+(noize*window.width/4);
    float ypos = viz.y;
    benjaminsBox(xpos, ypos, col1, wide, high, functionA, rotate, alphaA);
    benjaminsBox(xpos, ypos, col1, wide, high, functionA, -rotate, alphaA);

    xpos = vizWidth-10-(noize*window.width/4);
    benjaminsBox(xpos, ypos, col1, wide, high, 1-functionA, rotate, alphaA);
    benjaminsBox(xpos, ypos, col1, wide, high, 1-functionA, -rotate, alphaA);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Anim1 extends Anim { ///////// COME BACK TO THIS WITH NEW ENVELOPES
  Anim1(Rig _rig) {
    super(_rig);
    animName = "Anim1";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 10+(30*functionA);
    if (_beatCounter % 8 < 3) rotate = -60*functionA;   /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    else rotate = 60*functionB;                         /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    wide = 10+(functionB*vizWidth);
    high = 110-(functionA*vizHeight);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    star(positionX[2][0].x, positionX[2][0].y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, rotate, alphaA);
    //
    println("functionA / B", functionA, functionB);
    println("wide/high 1", wide, high);

    wide = 10+(functionA*vizWidth);
    high = 110+(functionB*vizHeight);

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;


    if (_beatCounter % 8 < 3) rotate = 60*functionA;    /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    else rotate = -60*functionB;                        /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    star(positionX[4][0].x, positionX[4][0].y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[2][2].x, positionX[2][2].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rings extends Anim {
  /*
  what benjamin would do
   Object wide,stroke,high; in anim main class
   make Processing/Java complain when you try to set wide/high
   so you get an error if you do it wrong
   in draw:
   wide.set(vizWidth*1.2) etc.
   wide.set(wide.get() - (wide.get()*functionA);
   if wide is a Ref, this allows us to later
   anim.wide.mul(wideslider);
   and the internals of the anim subclass don't need to have to remember to * by wideslider every time
   this is sort of what Ref() is for.
   */

  Rings(Rig _rig) {
    super(_rig);
    animName = "rings";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 15+((rig.high+rig.wide)/40*functionA);
    stroke *= 2* strokeSlider + 0.1;
    wide = vizWidth*1.2;
    wide = wide-(wide*functionA);
    high = wide*2;
    rotate = 120*noize*functionB;

    wide *=wideSlider;
    high *=highSlider;

    switch (rig.type){
      case Shields:
      donut(positionX[3][0].x,positionX[3][0].y, col1, stroke, wide, high, -rotate-60, alphaA);
      donut(positionX[9][0].x,positionX[9][0].y, col1, stroke, wide, high, -rotate, alphaA);
      donut(positionX[15][0].x,positionX[15][0].y, col1, stroke, wide, high, -rotate+60, alphaA);
      break;
      default:
      donut(window.width/4,window.height/4, col1, stroke, wide, high, -rotate, alphaA);
      donut(window.width/4*3,window.height/4, col1, stroke, wide, high, -rotate-60, alphaA);
      donut(window.width/2,window.height/4*3, col1, stroke, wide, high, -rotate+60, alphaA);
    }

    stroke = 15+((rig.high+rig.wide)/2/20*functionB*oskP)+(10*strokeSlider);
    wide = vizWidth*1.2;
    wide = wide-(wide*functionB);
    high = wide*2;
    rotate = -120*noize*functionA;

    wide *=wideSlider;
    high *=highSlider;

    switch (rig.type){
      case Shields:
      donut(positionX[0][1].x,positionX[0][1].y, col1, stroke, wide, high, rotate-60, alphaB);
      donut(positionX[6][1].x,positionX[6][1].y, col1, stroke, wide, high, rotate, alphaB);
      donut(positionX[12][1].x,positionX[12][1].y, col1, stroke, wide, high, rotate+60, alphaB);
      // donut(position[6].x, position[6].y, col1, stroke, wide, high, rotate, alphaB);
      // donut(position[7].x, position[7].y, col1, stroke, wide, high, rotate-60, alphaB);
      //donut(position[8].x, position[8].y, col1, stroke, wide, high, rotate+60, alphaB);
      break;
      default:
      donut(window.width/4,window.height/4, col1, stroke, wide, high, -rotate, alphaA);
      donut(window.width/4*3,window.height/4, col1, stroke, wide, high, -rotate-60, alphaA);
      donut(window.width/2,window.height/4*3, col1, stroke, wide, high, -rotate+60, alphaA);
    }
   
    window.endDraw();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SquareNuts extends Anim { 
  SquareNuts(Rig _rig) { 
    super(_rig);
    animName = "SquareNuts";
  }                                // maybe add beatcounter flip postion for this
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 300-(200*functionB);
    wide = vizWidth+(50);
    high = wide;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    switch (rig.type) {
    case Shields:
      squareNut(position[1].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(position[4].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
    default:
      squareNut(window.width/4, window.height/4, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(window.width/4*3, window.height/4*3, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
    }
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class DiagoNuts extends Anim { 
  DiagoNuts(Rig _rig) { 
    super(_rig);
    animName = "DiagoNuts";
  }                                // maybe add beatcounter flip postion for this
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 100-(400*functionA);
    wide = vizWidth+(50);
    high = wide;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    switch (rig.type) {
    case Shields:
      squareNut(position[1].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
      squareNut(position[4].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
      break;
    default:
      squareNut(window.width/4, window.height/4, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
      squareNut(window.width/4*3, window.height/4*3, col1, stroke, wide-(wide*functionA), high-(high*functionA), 45, alphaA);
    }
    window.endDraw();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Stars extends Anim {
  Stars(Rig _rig) {
    super(_rig);
    animName = "stars";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 2+(functionA*vizWidth*1.5);
    high = 2+(functionB*vizHeight*1.5);
    stroke = 15+(30*functionA);
    rotate = 30+(30*functionB);

    stroke *= 1.5*strokeSlider+0.1;
    wide *=wideSlider;
    high *=highSlider;

    switch (rig.type){
    case Shields:
      star(positionX[6][0].x, positionX[6][0].y, col1, stroke, wide, high, -rotate, alphaA);
      star(positionX[12][0].x, positionX[12][0].y, col1, stroke, wide, high, -rotate, alphaA);
      star(positionX[0][0].x, positionX[0][0].y, col1, stroke, wide, high, -rotate, alphaA);
      break;
    default:
      star(window.width/4, window.height/4, col1, stroke, wide, high, -rotate, alphaA);
      star(window.width/4*3, window.height/4*3, col1, stroke, wide, high, -rotate, alphaA);
    
      star(window.width,window.height, col1, stroke, wide, high, -rotate, alphaA);
     }

  stroke = 12+(10*functionA);
  switch (rig.type){
    case Shields:
      wide = 5+((ShieldsOPCGrid)(rig.opcgrid)).bigShieldRad*1.2*(1-functionB);
    default:
      
    }
    //wide = 5+(shieldsGrid.bigShieldRad*1.2*(1-functionB));
    high = wide;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaB);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Teeth extends Anim {
  Teeth(Rig _rig) {
    super( _rig);
    animName = "Teeth";
    //functionBEnvelope = new(oskP Envelope); /////////////////////////////////
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    //stroke = 50+(100*functionB);
    stroke = 50+(100*oskP);
    wide = vizWidth+(50);
    wide = wide-(wide*functionA);
    high = wide;

    stroke *=strokeSlider;
    wide *=wideSlider;
    high *=highSlider;

    //squareNut(positionX[0][2].x, positionX[0][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[1][0].x, positionX[1][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[2][2].x, positionX[2][2].y, col1, stroke, wide, high, -45, alphaA);
    //squareNut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[5][0].x, positionX[5][0].y, col1, stroke, wide, high, -45, alphaA);
    //squareNut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, -45, alphaA);

    wide = wide-(wide*functionB);
    high = wide;
    squareNut(positionX[0][2].x, positionX[0][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, -45, alphaA);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class TwistedStar extends Anim {
  TwistedStar(Rig _rig) {
    super(_rig);
    animName = "TwistedStar";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    stroke = 10+((rig.high+rig.wide)/2/20*functionB);
    stroke *= 2*strokeSlider+0.1;

    switch (rig.type){
      case Shields:
        ShieldsOPCGrid opcGrid = (ShieldsOPCGrid)(rig.opcgrid);
        wide = opcGrid.bigShieldRad/2+(functionA*rig.wide*1.2);
        high = opcGrid.bigShieldRad/2+((1-functionA)*rig.high*1.2);
        break;
      default:
        wide = (rig.wide/64*7*2+6)/2+(functionA*rig.wide*1.2);
        high = (rig.wide/64*7*2+6)/2+((1-functionA)*rig.high*1.2);
    }
    // TODO fix this, remove shields 
    // float wideB = shieldsGrid.bigShieldRad/2+(functionB*rig.high*1.2);
    // float highB = shieldsGrid.bigShieldRad/2+((1-functionB)*rig.wide*1.2);

    float wideB = 100/2+(functionB*rig.high*1.2);
    float highB = 100/2+((1-functionB)*rig.wide*1.2);
    
    rotate = 60*functionA;
    //void star(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    starNine(viz.x, viz.y, col1, stroke, wide, high, wideB, highB, 40+rotate, alphaA, alphaB); 
    //10+(beats[i]*mw), 110-(pulzs[i]*mh), -60*beats[i], col1, stroke, alpha[i]/4*alf*dimmer);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SingleDonut extends Anim {
  SingleDonut(Rig _rig) {            
    super(_rig);
    animName = "SingleDonut";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 10+(rig.wide*1.2*(1-functionA));
    high = 10+(rig.high*1.2*(1-functionA));
    
    stroke = (rig.high+rig.wide)/10;
    stroke *= 2*strokeSlider+0.1;

    wide *=wideSlider*2;
    high *=highSlider*2;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BouncingDonut extends Anim {
  int beatcounted;
  int numberofanims;
  BouncingDonut(Rig _rig) {            
    super(_rig);
    animName = "bouncingDonut";
    numberofanims = rig.animations.size();
    beatcounted = (_beatCounter % (numberofanims+1));
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = rig.wide*1.2-(rig.wide*1.2*functionA*((beatcounted+1)));
    high = rig.high*1.2-(rig.high*1.2*functionA*((beatcounted+1)));
    
    stroke = (rig.high+rig.wide)/(rig.wide/20);
    stroke *= 2*strokeSlider+0.1;

    wide *=wideSlider*2;
    high *=highSlider*2;

    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BouncingPolo extends Anim {
  int beatcounted;
  int numberofanims;
  BouncingPolo(Rig _rig) {            
    super(_rig);
    animName = "BouncingPolo";
    numberofanims = rig.animations.size();
    beatcounted = (_beatCounter % (numberofanims+1));
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = (rig.wide*1.2*functionA*((beatcounted+1)));
    high = (rig.high*1.2*functionA*((beatcounted+1)));
    ;
    stroke = wide*functionA;
    wide *=wideSlider;
    high *=highSlider;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA); 
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Polo extends Anim {
  Polo(Rig _rig) {            
    super(_rig);
    animName = "Polo";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = rig.wide*1.2*(1-functionA);
    high = rig.high*1.2*(1-functionA);
    
    stroke = wide*functionB;
    stroke *= 2*strokeSlider+0.1;

    wide *= 2*wideSlider;
    high *= 2*highSlider;
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Fill extends Anim {
  Fill(Rig _rig) {
    super(_rig);
    animName = "Fill";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    window.noStroke();

    if (_beatCounter % 9 < 4) window.fill(360*alphaA);
    else window.fill(360*alphaB);
    window.rect(window.width/4, viz.y, window.width/2, window.height);
    //
    if (_beatCounter % 9 < 4) window.fill(360*alphaB);
    else window.fill(360*alphaA);
    window.rect(window.width/4*3, viz.y, window.width/2, window.height);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Avoid extends Anim {
  Avoid(Rig _rig) {
    super(_rig);
    animName = "Avoid";
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = -window.width*functionA;
    wide = window.width;
    high = wide;
    squareNut(viz.x, viz.y, col1, stroke, wide, high, 0, 1);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Test extends Anim {
  int atk, sus, dec, atk1, sus1, dec1, str, dur, str_per, end_per;
  float atk_curv, dec_curv, atk_curv1, dec_curv1;
  Test(Rig _rig) {
    super(_rig);
    animName = "Test";
  }
  void draw() {  
    window.beginDraw();
    window.background(0);
    wide = 100;
    high = vizHeight/2; //*functionB;

    window.fill(360*alphaA);
    window.rect(viz.x, viz.y, 100, 100);
    window.endDraw();
  }
}