// A class to hold both the rig and the associated animation
class AnimationHolder {
  Rig rig;
  Anim anim;

  AnimationHolder(Rig rig, Anim anim) {
    this.rig = rig;
    this.anim = anim;
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Anim {
  float alphMod=1, funcMod=1, funcFX=1, alphFX=1, alphaA, alphaB, functionA, functionB;
  int blury, prevblury, vizIndex, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB, _beatCounter;
  color col1, col2;
  PVector viz;
  PVector[] position = new PVector[18];
  PVector[][] positionX = new PVector[7][3];  
  PGraphics window, pass1, pass2;
  float alph[] = new float[7];
  float func[] = new float[8];
  boolean deleteme = false, manuallyAdded = false;
  String animName;
  Envelope alphaEnvelopeA, alphaEnvelopeB, functionEnvelopeA, functionEnvelopeB;
  ArrayList<Envelope> avaliableEnvelopes;
  ArrayList<Float> alphaEnvelopeValues;
  Ref dimmer;
  Rig rig;
  //float overalltime;
  float strokeSlider, wideSlider, highSlider;
  float vizWidth,vizHeight;
  Anim(Rig _rig) {
    dimmer= ()->{return 1.0;};//new Ref(new float[]{1.0}, 0);
    rig = _rig;
   
    _beatCounter = (int)beatCounter;//kill this with fire
    col1 = white;
    col2 = white;
    animName = "default";

    blury = int(map(rig.blurriness, 0, 1, 0, 100));     //// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
    if (blury!=prevblury) prevblury=blury;

    window = rig.buffer;
    viz = new PVector(window.width/2, window.height/2);
    vizWidth = float(this.window.width);
    vizHeight = float(this.window.height);

    pass1 = rig.pass1;
    pass2 = rig.pass2;
    position = rig.position; 
    positionX = rig.positionX;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    //overalltime = avgmillis;
    
    alphaEnvelopeA = alphaEnvelopeFactory(rig.availableAlphaEnvelopes[rig.alphaIndexA], rig, avgmillis);
    alphaEnvelopeB = alphaEnvelopeFactory(rig.availableAlphaEnvelopes[rig.alphaIndexB], rig, avgmillis);
    //if(functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexA], rig) != NaN)
    functionEnvelopeA = functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexA], rig);
    functionEnvelopeB = functionEnvelopeFactory(rig.availableFunctionEnvelopes[rig.functionIndexB], rig);
    
    // setup the avaliableEnvelop ArrayList<>();
    avaliableEnvelopes = new ArrayList<Envelope>();
    alphaEnvelopeValues = new ArrayList<Float>();

    for (int i = 0; i < rig.availableAlphaEnvelopes.length; i++) {
    int alphaEnvelopeValue = rig.availableAlphaEnvelopes[i]; // Get the value from the array
    // alphaEnvelopeFactory is a method that creates envelopes
    Envelope newEnvelope = alphaEnvelopeFactory(alphaEnvelopeValue, rig, avgmillis);
    avaliableEnvelopes.add(newEnvelope); // Add the new envelope to the ArrayList
    }

    strokeSlider = rig.strokeSlider;
    wideSlider = rig.wideSlider;
    highSlider = rig.highSlider;
  }

  void draw() {
    //Override Me in subclass
    fill(300+(60*stutter));
    textSize(30);
    textAlign(CENTER);
    text("OOPS!!\nCHECK YOUR ANIM LIST", rig.size.x, rig.size.y-15);
  }
  float stroke, wide, high, rotate;
  //Object highobj;
  void drawAnim() {
    int now = millis();
    
    alphaA = alphaEnvelopeA.value(now) * rig.dimmer * this.dimmer.get();
    alphaB = alphaEnvelopeB.value(now) * rig.dimmer * this.dimmer.get();

    // loop through the avaliableEnvelopes ArrayList and update the list with value(now)
    for (Envelope envelope : avaliableEnvelopes) {
        float envelopeValue = envelope.value(now); // Get the value of the envelope at the current time
        alphaEnvelopeValues.add(envelopeValue);    // Add the envelope value to the ArrayList
    }

    Float funcX = functionEnvelopeA.value(now);
    if (!Float.isNaN(funcX)) functionA = funcX; 
    //functionEnvelopeA.value(now); 

    Float funcZ = functionEnvelopeB.value(now);
    if (!Float.isNaN(funcZ)) functionB = funcZ;
    //functionB = functionEnvelopeB.value(now);

    if (alphaEnvelopeA.end_time<now && alphaEnvelopeB.end_time<now && !manuallyAdded) deleteme = true;  // only delete when all finished

    this.draw();
    blurPGraphics();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  void squareNut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.rect(0, 0, wide, high);
    window.popMatrix();
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void donut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    try {
      window.strokeWeight(-stroke);
      window.stroke(360*alph);
      window.noFill();
      window.pushMatrix();
      window.translate(xpos, ypos);
      window.rotate(radians(rotate));
      window.ellipse(0, 0, wide, high);
      window.popMatrix();
    }
    catch(Exception e) {
      println(e, "BENJAMIN REALLY NEEDDS TO FIX THIS");
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void star(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    try {
      this.window.strokeWeight(-stroke);
      this.window.stroke(360*alph);
      this.window.noFill();
      this.window.pushMatrix();                      //  ERROR too many calls to push matrix
      this.window.translate(xpos, ypos);
      this.window.rotate(radians(rotate));
      this.window.ellipse(0, 0, wide, high);         //  ERROR neagtive array size exception
      this.window.rotate(radians(120));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(120));
      this.window.ellipse(0, 0, wide, high);
      this.window.popMatrix();
    }  
    catch(Exception e) {
      println(wide, high);
      //NegativeArraySizeException();
      String message = e.getMessage();
      Throwable cause = e.getCause();
      println("message:", e, "cause", cause);
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void starNine(float xpos, float ypos, color col, float stroke, float wide, float high, float wideB, float highB, float rotate, float alph, float alphB) {
    try {
      int rot = 36;
      this.window.strokeWeight(-stroke);
      this.window.stroke(360*alph);
      this.window.noFill();
      this.window.pushMatrix();                      //  ERROR too many calls to push matrix
      this.window.translate(xpos, ypos);
      this.window.rotate(radians(rotate));
      this.window.ellipse(0, 0, wide, high);         //  ERROR neagtive array size exception
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(rot));
      this.window.ellipse(0, 0, wideB, highB);
      this.window.popMatrix();
    }  
    catch(Exception e) {
      println(wide, high);
      //NegativeArraySizeException();
      String message = e.getMessage();
      Throwable cause = e.getCause();
      println("message:", e, "cause", cause);
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  void starNineA(float xpos, float ypos, color col, float stroke, float wide, float high, float wideB, float highB, float rotate, float alph, float alphB) {
    try {
      this.window.strokeWeight(-stroke);
      this.window.stroke(360*alph);
      this.window.noFill();
      this.window.pushMatrix();                      //  ERROR too many calls to push matrix
      this.window.translate(xpos, ypos);
      this.window.rotate(radians(rotate));
      this.window.ellipse(0, 0, wide, high);         //  ERROR neagtive array size exception
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wide, high);
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alphB);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.rotate(radians(40));
      this.window.stroke(360*alph);
      this.window.ellipse(0, 0, wideB, highB);
      this.window.popMatrix();
    }  
    catch(Exception e) {
      println(wide, high);
      //NegativeArraySizeException();
      String message = e.getMessage();
      Throwable cause = e.getCause();
      println("message:", e, "cause", cause);
    }
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
    window.tint(360*alph);
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
    window.tint(360*alph);
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
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
