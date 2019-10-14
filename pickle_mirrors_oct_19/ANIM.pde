class Anim {
  /////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
  //ArrayList <PGraphics> vis = new ArrayList <PGraphics>(8);
  PGraphics window;
  PGraphics vis = new PGraphics();
  PGraphics bg[] = new PGraphics[bgList];
  PGraphics colourLayer;
  PGraphics pass1 = new PGraphics();
  PGraphics blured = new PGraphics();
  PShader blur;
  PGraphics src;
  int blury, prevblury;
  float alphMod=1, funcMod=1;
  float alpha, function, funcFX=1, alphFX=1, dimmer=1;
  Anim() {

    window = createGraphics(int(size.rigWidth), int(size.rigHeight), P2D);
    window.beginDraw();
    window.colorMode(HSB, 360, 100, 100);
    window.blendMode(NORMAL);
    window.ellipseMode(CENTER);
    window.rectMode(CENTER);
    window.imageMode(CENTER);
    window.noStroke();
    window.noFill();
    window.endDraw();

    //////////////////////////////// RIG VIS GRAPHICS ///////////////////
    vis = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    vis.beginDraw();
    vis.colorMode(HSB, 360, 100, 100);
    vis.blendMode(NORMAL);
    vis.ellipseMode(CENTER);
    vis.rectMode(CENTER);
    vis.imageMode(CENTER);
    vis.noStroke();
    vis.noFill();
    vis.endDraw();
    ///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
    blur = loadShader("blur.glsl");
    blur.set("blurSize", 40);
    blur.set("sigma", 30.0f);  
    pass1 = createGraphics(int(size.rigWidth*0.6), int(size.rigHeight*0.6), P2D);
    pass1.noSmooth();
    pass1.imageMode(CENTER);
    pass1.beginDraw();
    pass1.noStroke();
    pass1.endDraw();
    blured = createGraphics(int(size.rigWidth*0.6), int(size.rigHeight*0.6), P2D);
    blured.noSmooth();
    blured.beginDraw();
    blured.imageMode(CENTER);
    blured.noStroke();
    blured.endDraw();
  }
  /*
     ///////////////////////////// COLOR LAYER / BG GRAPHICS ////////////////////////////
   for ( int n = 0; n<bg.length; n++) {
   bg[n] = createGraphics(int(size.rigWidth), int(size.rigHeight), P2D);
   bg[n].beginDraw();
   bg[n].colorMode(HSB, 360, 100, 100);
   bg[n].ellipseMode(CENTER);
   bg[n].rectMode(CENTER);
   bg[n].imageMode(CENTER);
   bg[n].noStroke();
   bg[n].noFill();
   bg[n].endDraw();
   }
   ////////////////////////////////  colour layer  ///////////////////
   colourLayer = createGraphics(int(size.roofWidth), int(size.roofHeight), P2D);
   colourLayer.beginDraw();
   colourLayer.colorMode(HSB, 360, 100, 100);
   colourLayer.imageMode(CENTER);
   colourLayer.rectMode(CENTER);
   colourLayer.endDraw();
   */

  float stroke, wide, high;
  PVector viz;
  Float vizWidth, vizHeight;

  void drawAnim(PGraphics subwindow, float xpos, float ypos) {
    alphaFunction();
    decay();
    PVector viz = new PVector(size.rig.x, size.rig.y);
    alpha = alph[rigAlphIndex]*alphFX*dimmer;
    function = func[fctIndex]*funcFX;

    switch (rigViz) {
    case 0:
      stroke = 300-(200*noize);
      wide = size.vizWidth+(50);
      high = wide;
      alpha = alph[rigAlphIndex]*alphFX*dimmer;
      function = func[fctIndex]*funcFX;
      squareNut(col1, stroke, wide-(wide*function), high-(high*function), alpha);
      subwindow.beginDraw();
      subwindow.background(0);
      subwindow.blendMode(LIGHTEST);
      subwindow.image(blured, viz.x,viz.y, blured.width*2.5, blured.height*2.5);
      //subwindow.image(blured, grid.mirrorX[3][2].x, grid.mirrorX[3][2].y, blured.width*2.5, blured.height*2.5);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      println("DRAW", "ALPHA "+alpha);
      break;
    case 1:
      //stroke = 20;
      //wide = 10+(size.rigWidth-(size.rigWidth*function));
      //high = wide;
      //// star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
      //star(10+(pulz*wide), 10+(beat*high), -30*pulz, col1, stroke, alpha);

      //subwindow.beginDraw();
      //subwindow.background(0);
      //subwindow.blendMode(LIGHTEST);
      //subwindow.image( blured, size.viz.x, size.viz.y-(size.viz.y/1.5), size.vizWidth*2, size.vizHeight*2);
      //subwindow.image( blured, size.viz.x, size.viz.y, size.roofWidth*2, size.roofHeight*2);
      //subwindow.image( blured, size.viz.x, size.viz.y+(size.viz.y/1.5), size.roofWidth*2, size.roofHeight*2);
      //image(subwindow, xpos, ypos);

      break;
    }
  }
  /////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
  float alph[] = new float[7];
  float func[] = new float[8];
  float sineFast, sineSlow, sine, d, e, stutter;
  float timer[] = new float[6];

  void alphaFunction() {
    float tm = 0.05+(noize/50);
    timer[2] += beatSlider;            
    for (int i = 0; i<timer.length; i++) timer[i] += tm;
    timer[3] += (0.3*5);
    sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
    sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
    sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
    if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
    else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave

    //// array of functions
    func[0] = pulz;         
    func[1] = beat;        
    func[2] = pulzSlow; 
    func[3] = (beatSlow*0.99)+(0.01*stutter);
    func[4] = (0.99*pulz)+(stutter*pulz*0.01);       
    func[5] = (0.99*beatSlow)+(stutter*pulz*0.01);
    func[6] = pulzSlow;
    func[7] = beatSlow;

    //// array of alphas
    alph[0] = beat;
    alph[1] = pulz;
    alph[2] = beat+(0.05*stutter);
    alph[3] =(0.98*beat)+(stutter*pulz*0.02);
    alph[4] = (0.98*pulz)+(beat*0.02*stutter);
    alph[5] = beatFast;
    alph[6] = pulzSlow;

    for (int i = 0; i < alph.length; i++) alph[i] *=alphMod;
    for (int i = 0; i < func.length; i++) func[i] *=funcMod;
  }
  //////////////////////////////////// BEATS //////////////////////////////////////////////
  float beat, beatSlow, pulz, pulzSlow, pulzFast, beatFast, beatCounter;
  long beatTimer;
  void trigger() {
    beat = 1;
    beatFast = 1;
    beatSlow = 1;

    beatCounter = (beatCounter + 1) % 120;
    weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
    weightedcnt=1+(1-beatAlpha)*weightedcnt;
    avgtime=weightedsum/weightedcnt;
    beatTimer=0;
  }
  void decay() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
    beatTimer++;
    beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
    // the last 10 onsets  0.02 would average the last 100
    if (avgtime>0) beat*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
    else beat*=0.95;
    if (beat < 0.8) beat *= 0.98;
    pulz = 1-beat;                     /// p is opposite of b
    beatFast *=0.7;                 
    pulzFast = 1-pulzFast;            /// bF is oppiste of pF
    beatSlow -= 0.05;
    pulzSlow = 1-beatSlow;
    float end = 0.01;
    if (beat < end) beat = end;
    if (pulzFast > 1) pulzFast = 1;
    if (beatFast < end) beatFast = end;
    if (beatSlow < 0.4+(noize1*0.2)) beatSlow = 0.4+(noize1*0.2);
    if (pulzSlow > 1) pulzSlow = 1;
  }

  /////////////////////////////////// SQUARE NUT ////////////////////////////////////
  PGraphics squareNut(color col, float stroke, float wide, float high, float alph) {
    try {
      vis.beginDraw();
      vis.colorMode(HSB, 360, 100, 100);
      vis.background(0);
      vis.strokeWeight(-stroke);
      vis.stroke(col, 360*alph);
      vis.pushMatrix();
      vis.translate(vis.width/2, vis.height/2);
      vis.rect(0, 0, wide, high);
      vis.popMatrix();
      vis.endDraw();
      
      blurPGraphics();
    } 
    catch (AssertionError e) {
      println(e);
      println(rigViz, col, stroke, wide, high, func, alph);
    }
    return blured;
  }
  /*
  PGraphics star(float wide, float high, float rotate, color col, float stroke, float alph) {
   vis.beginDraw();
   vis.background(0);
   vis.pushMatrix();
   vis.strokeWeight(-stroke);
   vis.stroke(col*alph);
   vis.noFill();
   vis.translate(vis.width/2, vis.height/2);
   vis.rotate(radians(rotate));
   if (!toggle.rect)vis.ellipse(0, 0, wide, high);
   else vis.rect(0, 0, wide, high);
   vis.rotate(radians(120));
   if (!toggle.rect)vis.ellipse(0, 0, wide, high);
   else vis.rect(0, 0, wide, high);
   vis.rotate(radians(120));
   if (!toggle.rect)vis.ellipse(0, 0, wide, high);
   else vis.rect(0, 0, wide, high);
   vis.popMatrix();
   vis.noStroke();
   vis.endDraw();
   blurPGraphics();
   return blured;
   }
   */

  void blurPGraphics() {
    blur.set("horizontalPass", 0);
    pass1.beginDraw();            
    pass1.shader(blur); 
    pass1.imageMode(CENTER);
    pass1.image(vis, pass1.width/2, pass1.height/2, pass1.width, pass1.height);
    pass1.endDraw();
    blur.set("horizontalPass", 1);
    blured.beginDraw();            
    blured.shader(blur);  
    blured.imageMode(CENTER);
    blured.image(pass1, blured.width/2, blured.height/2);
    blured.endDraw();
    println("BLURRED");
  }
}
