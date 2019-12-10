
abstract class ManualAnim extends Anim {

  ManualAnim(Rig _rig) {
    super(_rig);
    alphaRate = _rig.manualAlpha;
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
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////
 class AllOn extends ManualAnim {
 float manualAlpha;
 void trigger() {
 super.trigger();
 manualAlpha=1;
 }
 void decay() {
 super.decay();
 manualAlpha*=map(this.alphaRate, 0, 1, 0.5, 0.97);
 manualAlpha*=this.funcRate;
 }
 AllOn(Rig _rig) {
 super( _rig);
 alphaRate=manualSlider;
 }
 void draw() {
 window.background(360*manualAlpha);
 }
 }
 */
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BenjaminsBoxes extends Anim {
  BenjaminsBoxes (Rig _rig) {
    super(_rig);
    alphaEnvelopeA = new ADSR(200, 0, 1000, 0.2, 0, 0.2); // envelopeFactory(rig.alphaIndexA, rig);
    functionEnvelopeA =  new ADSR(1000, 0, 1000, 0.2, 0, 0.2); // envelopeFactory(rig.alphaIndexA, rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = vizHeight/2;
    high = 100;
    rotate = functionB*360;
    
    benjaminsBox(position[0].x, viz.y, col1, wide, vizHeight, functionA, rotate, alphaA);
    benjaminsBox(position[2].x, viz.y, col1, wide, vizHeight, functionA, rotate, alphaA);
    benjaminsBox(position[4].x, viz.y, col1, wide, vizHeight, functionA, rotate, alphaA);

    benjaminsBox(position[7].x, viz.y, col1, wide, vizHeight, 1-functionA, -rotate, alphaA);
    benjaminsBox(position[9].x, viz.y, col1, wide, vizHeight, 1-functionA, -rotate, alphaA);
    benjaminsBox(position[11].x, viz.y, col1, wide, vizHeight, 1-functionA, -rotate, alphaA);

    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Anim1 extends Anim { ///////// COME BACK TO THIS WITH NEW ENVELOPES
  Anim1(Rig _rig) {
    super(_rig);
    functionEnvelopeA = new ADSR(1, 1, 2000, 0, 0, 0.3);
    functionEnvelopeB = new ADSR(2000, 1, 1, 0.2, 0, 0);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 10+(30*functionA);
    if (_beatCounter % 8 < 3) rotate = -60*functionA;   /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    else rotate = 60*functionB;                         /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    wide = 10+(functionB*vizWidth);
    high = 110-(functionA*vizHeight);
    star(positionX[2][0].x, positionX[2][0].y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, rotate, alphaA);
    //
    println("functionA / B", functionA, functionB);
    println("wide/high 1", wide, high);

    wide = 10+(functionA*vizWidth);
    high = 110+(functionB*vizHeight);
    println("wide/high 2", wide, high);

    if (_beatCounter % 8 < 3) rotate = 60*functionA;    /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    else rotate = -60*functionB;                        /////////// CHANGE THIS TO A SPECIFIC FUNCTION IN THE ABOVE SECTION OF CODE
    star(positionX[4][0].x, positionX[4][0].y, col1, stroke, wide, high, rotate, alphaA);
    star(positionX[2][2].x, positionX[2][2].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Checkers extends Anim {
  Checkers(Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 20+(400*tweakSlider);
    rotate = 0;
    if (_beatCounter % 9 <4) { 
      for (int i = 0; i < opcGrid.columns; i+=2) {
        wide = (vizWidth*2)-(vizWidth/10);
        wide = 50+(wide-(wide*functionA)); 
        high = wide;
        donut(position[i].x, position[i].y, col1, stroke, wide, high, rotate, alphaA);
        donut(position[i+1 % opcGrid.columns+6].x, position[i+1 % opcGrid.columns+6].y, col1, stroke, wide, high, rotate, alphaA);
        wide = (vizWidth/4)-(vizWidth/10);
        wide = 10+(wide-(wide*functionB)); 
        high = wide;
        donut(position[i+1 % opcGrid.columns].x, position[i+1 % opcGrid.columns].y, col1, stroke, wide, high, rotate, alphaB);
        donut(position[i+6].x, position[i+6].y, col1, stroke, wide, high, rotate, alphaB);
      }
    } else { // opposite way around
      for (int i = 0; i < opcGrid.columns; i+=2) {
        wide  = (vizWidth*2)-(vizWidth/10);
        wide = 50+(wide-(wide*functionA)); 
        high = wide;
        donut(position[i+1 % opcGrid.columns].x, position[i+1 % opcGrid.columns].y, col1, stroke, wide, high, rotate, alphaB);
        donut(position[i+6].x, position[i+6].y, col1, stroke, wide, high, rotate, alphaB);
        wide = (vizWidth/4)-(vizWidth/10);
        wide = 10+(wide-(wide*functionB)); 
        high = wide;
        donut(position[i].x, position[i].y, col1, stroke, wide, high, rotate, alphaA);
        donut(position[i+1 % opcGrid.columns+6].x, position[i+1 % opcGrid.columns+6].y, col1, stroke, wide, high, rotate, alphaA);
      }
    }
    window.endDraw();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rings extends Anim {
  float animDimmer;
  Rings(Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 30+(90*functionA*oskP);
    wide = vizWidth*1.2;
    wide = wide-(wide*functionA);
    high = wide*2;
    rotate = 90*noize*functionB;
    donut(position[2].x, position[2].y, col1, stroke, wide, high, rotate, alphaA);
    donut(position[9].x, position[9].y, col1, stroke, wide, high, rotate, alphaA);
    stroke = 30+(90*functionB*oskP);
    wide = vizWidth*1.2;
    wide = wide-(wide*functionB);
    high = wide*2;
    rotate = -90*noize*functionA;
    donut(position[3].x, position[3].y, col1, stroke, wide, high, rotate, alphaA);
    donut(position[8].x, position[8].y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rush extends Anim {
  Rush (Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 500+(noize*150);
    if (_beatCounter % 8 < 3) {
      rush(position[0].x, position[3].y, col1, wide, vizHeight/2, functionA, alphaA);
      rush(position[11].x, position[8].y, col1, wide, vizHeight/2, -functionA, alphaA);
    } else {    
      rush(position[0]. x, position[3].y, col1, wide, vizHeight/2, -functionA, alphaA);
      rush(position[11].x, position[8].y, col1, wide, vizHeight/2, functionA, alphaA);
    }
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Rushed extends Anim {
  Rushed(Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 150+(noize*600*functionA);
    high = vizHeight/2;
    if (beatCounter % 6 < 4) {
      rush(viz.x, position[3].y, col1, wide, high, functionA, alphaA);
      rush(viz.x, position[3].y, col1, wide, high, -functionB, alphaB);
      rush(viz.x, position[3].y, col1, wide, high, -functionA, alphaA);
      rush(viz.x, position[3].y, col1, wide, high, functionB, alphaB);
      //
      rush(viz.x, position[8].y, col1, wide, high, -functionA, alphaB);
      rush(viz.x, position[8].y, col1, wide, high, functionB, alphaA);
      rush(viz.x, position[8].y, col1, wide, high, functionA, alphaB);
      rush(viz.x, position[8].y, col1, wide, high, -functionB, alphaA);
    } else {
      rush(viz.x, position[3].y, col1, wide, high, functionB, alphaB);
      rush(viz.x, position[3].y, col1, wide, high, -functionA, alphaA);
      rush(viz.x, position[3].y, col1, wide, high, -functionB, alphaB);
      rush(viz.x, position[3].y, col1, wide, high, functionA, alphaA);
      //
      rush(viz.x, position[8].y, col1, wide, high, -functionB, alphaA);
      rush(viz.x, position[8].y, col1, wide, high, functionA, alphaB);
      rush(viz.x, position[8].y, col1, wide, high, functionB, alphaA);
      rush(viz.x, position[8].y, col1, wide, high, -functionA, alphaB);
    }
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SquareNuts extends Anim { 
  SquareNuts(Rig _rig) { 
    super(_rig);
  }                                // maybe add beatcounter flip postion for this
  void draw() {
    window.beginDraw();
    window.background(0);
    stroke = 300-(200*noize);
    wide = vizWidth+(50);
    high = wide;
    if (rig == rigg) {
      squareNut(position[1].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(position[4].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
    } else {
      squareNut(window.width/4, window.height/4, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(window.width/4*3, window.height/4*3, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
    }
    window.endDraw();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Stars extends Anim {
  Stars(Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 10+(functionA*vizWidth*1.5);
    high = 10+(functionB*vizHeight*1.5);
    stroke = 30+(60*functionA*noize1);
    rotate = 30*functionB;
    star(positionX[1][1].x, viz.y, col1, stroke, wide, high, rotate, alphaA);
    rotate = -30*functionB;
    star(positionX[5][1].x, viz.y, col1, stroke, wide, high, rotate, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Swipe extends Anim {
  Swipe(Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 500+(noize*300);
    if   (beatCounter % 3 < 1) rush(position[0].x, viz.y, col1, wide, vizHeight, functionA, alphaA);
    else rush(position[0].x, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Swiped extends Anim {
  Swiped(Rig _rig) {
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 150+(noize1*500*functionB);
    rush(viz.x, viz.y, col1, wide, vizHeight, functionA, alphaA);
    rush(-vizWidth/2, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Teeth extends Anim {
  Teeth(Rig _rig) {
    super( _rig);
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
    squareNut(positionX[0][2].x, positionX[0][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[1][0].x, positionX[1][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[2][2].x, positionX[2][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[3][0].x, positionX[3][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[4][2].x, positionX[4][2].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[5][0].x, positionX[5][0].y, col1, stroke, wide, high, -45, alphaA);
    squareNut(positionX[6][2].x, positionX[6][2].y, col1, stroke, wide, high, -45, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Donut extends Anim {
  Donut(Rig _rig) {            // come back to this with new envelopes
    super(_rig);
  }
  void draw() {
    window.beginDraw();
    window.background(0);
    wide = 10+(vizWidth*(1-functionB));
    high = wide;
    stroke = 2+(vizWidth/2*functionA);
    //void donut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    donut(viz.x, viz.y, col1, stroke, wide, high, 0, alphaA);
    window.endDraw();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Fill extends Anim {
  Fill(Rig _rig) {
    super(_rig);
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
    alphaEnvelopeA = new ADSR(200, 0, 1000, 0.2, 0, 0.2); // envelopeFactory(rig.alphaIndexA, rig);
    functionEnvelopeA =  new ADSR(800, 0, 1000, 0.2, 0, 1); // envelopeFactory(rig.alphaIndexA, rig);
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
  Test(Rig _rig) {
    super(_rig);
    functionEnvelopeA =  new ADSR(1000, 0, 1000, 0.2, 0, 0.2); // envelopeFactory(rig.alphaIndexA, rig);
    functionEnvelopeB =  new ADSR(1500, 0, 1500, 0.2, 0, 0.2); // envelopeFactory(rig.alphaIndexA, rig);

    alphaEnvelopeA =  new ADSR(1000, 1000, 1000, 0.9, 0, 0.8); // envelopeFactory(rig.alphaIndexA, rig);
  }
  void draw() {  
    window.beginDraw();
    window.background(0);
    wide = 100;
    high = vizHeight/2; //*functionB;
    //this is good
    //drop(position[0].x, viz.y, col1, wide, vizHeight, functionA, alphaA);
    //drop(position[2].x, viz.y, col1, wide, vizHeight, functionA, alphaA);
    //drop(position[4].x, viz.y, col1, wide, vizHeight, functionA, alphaA);

    //drop(position[7].x, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
    //drop(position[9].x, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
    //drop(position[11].x, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);

    // this is good

    window.endDraw();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Anim {
  float alphaRate, funcRate, dimmer, alphMod=1, funcMod=1, funcFX=1, alphFX=1, alphaA, alphaB, functionA, functionB;
  int blury, prevblury, vizIndex, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, _beatCounter;
  color col1, col2;
  PVector viz;
  PVector[] position = new PVector[18];
  PVector[][] positionX = new PVector[7][3];  
  PGraphics window, pass1, pass2;
  float alph[] = new float[7];
  float func[] = new float[8];
  boolean deleteme=false;
  Envelope alphaEnvelopeA, alphaEnvelopeB, functionEnvelopeA, functionEnvelopeB;
  Tup animDimmer;
  Rig rig;

  Anim(Rig _rig) {
    animDimmer=new Tup(new float[]{1.0}, 0);
    rig = _rig;
    alphaRate = rig.alphaRate;
    funcRate = rig.funcRate;
    vizIndex = rig.vizIndex; 
    resetbeats();
    _beatCounter = beatCounter;
    col1 = white;
    col2 = white;

    blury = int(map(rig.blurValue, 0, 1, 0, 100));     //// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
    if (blury!=prevblury) prevblury=blury;

    window = rig.buffer;
    viz = new PVector(window.width/2, window.height/2);
    vizWidth = float(this.window.width);
    vizHeight = float(this.window.height);

    pass1 = rig.pass1;
    pass2 = rig.pass2;
    position = rig.position; 
    positionX = rig.positionX;

    alphaEnvelopeA = envelopeFactory(rig.alphaIndexA, rig);
    alphaEnvelopeB = envelopeFactory(rig.alphaIndexB, rig);
    functionEnvelopeA = envelopeFactory(rig.functionIndexA, rig);
    functionEnvelopeB = envelopeFactory(rig.functionIndexB, rig);
  }

  void draw() {
    //Override Me in subclass
    fill(300+(60*stutter));
    textSize(30);
    textAlign(CENTER);
    text("OOPS!!\nCHECK YOUR ANIM LIST", rig.size.x, rig.size.y-15);
  }
  float stroke, wide, high, rotate;
  Float vizWidth, vizHeight;
  void drawAnim() {
    int now = millis();
    alphaA = alphaEnvelopeA.value(now);
    alphaB = alphaEnvelopeB.value(now);
    alphaA*=rig.dimmer*animDimmer.get();
    alphaB*=rig.dimmer*animDimmer.get();          // not sure how to link this yet

    functionA = functionEnvelopeA.value(now); 
    functionB = functionEnvelopeB.value(now);
    //functionA*=funcFX;
    //functionB*=funcFX;

    if (alphaEnvelopeA.end_time<now && alphaEnvelopeB.end_time<now) deleteme = true;  // only delete when all finished

    this.draw();

    /*
    if (syphonToggle) {
     if (this.rig == rigg) {
     ///// only send the rig animations???!!!???!!! /////
     syphonImageSent.beginDraw();
     syphonImageSent.blendMode(LIGHTEST);
     syphonImageSent.image(pass2, syphonImageSent.width/2, syphonImageSent.height/2, syphonImageSent.width, syphonImageSent.height);
     syphonImageSent.endDraw();
     }
     }
     */
    blurPGraphics();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  void squareNut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(360, 360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.rect(0, 0, wide, high);
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void donut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(360, 360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void star(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(360, 360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.ellipse(0, 0, wide, high);
    window.rotate(radians(120));
    window.ellipse(0, 0, wide, high);
    window.rotate(radians(120));
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void rush(float xpos, float ypos, color col, float wide, float high, float func, float alph) {
    float moveA;
    float strt = xpos;
    moveA = (strt+((window.width)*func));
    window.imageMode(CENTER);
    window.tint(360, 360*alph);
    window.image(bar1, moveA, ypos, wide, high);
    window.noTint();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  float diagonallen(PVector w, float r) {
    r=abs(r)%PI;
    if (r>PI*0.5) r = PI-r;
    if (r<atan(w.y/w.x)) return w.x/cos(r);
    return w.y/cos(PI*0.5-r);
  }


  void benjaminsBox(float xpos, float ypos, color col, float wide, float high, float func, float rotate, float alph) {
    rotate = radians(rotate);

    PVector box = new PVector(window.width, window.height);
    float distance = (-diagonallen(box, rotate)*0.5)-(diagonallen(box, rotate)*0.5);
    float moveA = (-(distance/2)+(distance*func))*1.3;

    window.imageMode(CENTER);
    window.tint(360, 360*alph);
    window.fill(360, 360);

    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(rotate);
    window.image(bar1, moveA, 0, wide, high);
    window.noTint();
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void drop(float xpos, float ypos, color col, float wide, float high, float func, float alph) {
    float moveA;
    float strt = window.height-ypos;
    moveA = (strt-((window.height)*func))*1.3;
    window.imageMode(CENTER);
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(90));
    window.tint(360, 360*alph);
    window.image(bar1, moveA, 0, high, wide);
    window.noTint();
    window.popMatrix();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void blurPGraphics() {
    blur.set("blurSize", blury);
    blur.set("horizontalPass", 0);
    pass1.beginDraw();            
    pass1.shader(blur); 
    pass1.imageMode(CENTER);
    pass1.image(window, pass1.width/2, pass1.height/2, pass1.width, pass1.height);
    pass1.endDraw();
    blur.set("horizontalPass", 1);
    pass2.beginDraw();            
    pass2.shader(blur);  
    pass2.imageMode(CENTER);
    pass2.image(pass1, pass2.width/2, pass2.height/2, pass2.width, pass2.height);
    pass2.endDraw();
    image(pass2, rig.size.x, rig.size.y, window.width, window.height);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
  float getval() {
    try {
      return animDimmer.f[animDimmer.i];
    } 
    catch (Exception e) {
      return 1;
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
