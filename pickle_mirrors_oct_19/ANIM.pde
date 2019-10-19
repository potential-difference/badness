class Anim implements Animation {
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
  float xpos, ypos;

  Anim(float _xpos, float _ypos) {
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

    trigger();
    xpos = _xpos;
    ypos = _ypos;
  }

  float stroke, wide, high;
  PVector viz;
  Float vizWidth, vizHeight;

  void drawAnim() {
    alphaFunction();
    decay();
    PVector viz = new PVector(size.rig.x, size.rig.y);
    alpha = alph[rigAlphIndex]*alphFX*dimmer;
    function = func[fctIndex]*funcFX;
    col1 = color(white);
    col2 = color(white);
    vizWidth = float(blured.width*2);
    vizHeight = float(blured.height*2);

    switch (rigViz) {
    case 0:
      stroke = 300-(200*noize);
      wide = size.vizWidth+(50);
      high = wide;
      alpha = alph[rigAlphIndex]*alphFX*dimmer;
      function = func[fctIndex]*funcFX;
      visual[0].squareNut(col1, stroke, wide-(wide*function), high-(high*function), alpha);
      window.beginDraw();
      window.background(0);
      window.blendMode(LIGHTEST);
      //subwindow.image(visual[0].blured, viz.x, viz.y, blured.width*2.5, blured.height*2.5);
      //subwindow.image(visual[0].blured, grid.mirrorX[3][2].x, grid.mirrorX[3][2].y, blured.width*2.5, blured.height*2.5);
      window.fill(360*alpha);
      window.rect(viz.x, viz.y, 300*function, 300*function);
      window.endDraw();
      image(window, xpos, ypos);
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
  float beat, beatSlow, pulz, pulzSlow, pulzFast, beatFast;
  long beatTimer;
  void trigger() {
    beat = 1;
    beatFast = 1;
    beatSlow = 1;

    //    beatCounter = (beatCounter + 1) % 120;
    //    weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
    //    weightedcnt=1+(1-beatAlpha)*weightedcnt;
    //    avgtime=weightedsum/weightedcnt;
    //    beatTimer=0;
  }
  void decay() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
    //beatTimer++;
    //beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
    //// the last 10 onsets  0.02 would average the last 100
    //if (avgtime>0) beat*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
    //else 
    beat*=0.95;
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
}
