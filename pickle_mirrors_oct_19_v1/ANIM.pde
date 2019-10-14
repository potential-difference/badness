class Anim implements Animation {
  /////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
  PGraphics window;
  int blury, prevblury;
  float alphMod=1, funcMod=1;
  float funcFX=1, alphFX=1, dimmer=1;
  float xpos, ypos;
  PGraphics vis = new PGraphics();
  PGraphics bg[] = new PGraphics[bgList];
  PGraphics colourLayer;
  PGraphics pass1 = new PGraphics();
  PGraphics blured = new PGraphics();
  PShader blur;
  PGraphics src;
  int vizIndex;

  float alph[] = new float[7];
  float func[] = new float[8];
  float sineFast, sineSlow, sine, d, e, stutter;
  float timer[] = new float[6];

  Anim(float _xpos, float _ypos, int _vizIndex) {
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
    ///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
    blur = loadShader("blur.glsl");
    blur.set("blurSize", 30);
    blur.set("sigma", 30.0f);  
    pass1 = createGraphics(int(window.width/2), int(window.height/2), P2D);
    pass1.noSmooth();
    pass1.imageMode(CENTER);
    pass1.beginDraw();
    pass1.noStroke();
    pass1.endDraw();
    blured = createGraphics(int(window.width/2), int(window.height/2), P2D);
    blured.noSmooth();
    blured.beginDraw();
    blured.imageMode(CENTER);
    blured.noStroke();
    blured.endDraw();

    trigger();
    xpos = _xpos;
    ypos = _ypos;
    vizIndex = _vizIndex;
  }

  float stroke, wide, high;
  PVector viz;
  Float vizWidth, vizHeight;

  void drawAnim() {
    alphaFunction();
    decay();
    PVector viz = new PVector(size.rig.x, size.rig.y);

    col1 = white;
    col2 = white;
    vizWidth = float(visual[0].blured.width*2);
    vizHeight = float(blured.height*2);

    float alphaA = this.alph[rigAlphIndex]*alphFX;
    float functionA = func[fctIndex]*funcFX;
    float alphaB = this.alph[rigAlph1Index]*alphFX;
    float functionB = func[fct1Index]*funcFX;


    switch (vizIndex) {
    case 0:
      window.beginDraw();
      window.background(0);

      stroke = 120;
      wide = size.vizWidth+(0);
      high = wide;
      donut(viz.x, viz.y, col1, stroke, wide-(wide*functionB), high-(high*functionB), alphaA);

      println(alphaA);

      window.endDraw();
      break;
    case 1:
      window.beginDraw();
      window.background(0);
      
      stroke = 300;
      high = size.vizWidth+(0);
      wide = high/2;
      squareNut(viz.x, viz.y, col1, stroke, wide-(wide*functionB), high-(high*functionB), alphaA);

      window.endDraw();
      break;
    }
    blurPGraphics();
  }

  /////////////////////////////////// SQUARE NUT /////////////////////////////////////////////////////////////////////////////////////////////////
  void squareNut(float xpos, float ypos, color col, float stroke, float wide, float high, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(col, 360*alph);
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rect(0, 0, wide, high);
    window.popMatrix();
  }
  /////////////////////////////////// DONUT NUT /////////////////////////////////////////////////////////////////////////////////////////////////
  void donut(float xpos, float ypos, color col, float stroke, float wide, float high, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(col, 360*alph);
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }

  void blurPGraphics() {
    blur.set("horizontalPass", 0);
    pass1.beginDraw();            
    pass1.shader(blur); 
    pass1.imageMode(CENTER);
    pass1.image(window, pass1.width/2, pass1.height/2, pass1.width, pass1.height);
    pass1.endDraw();
    blur.set("horizontalPass", 1);
    blured.beginDraw();            
    blured.shader(blur);  
    blured.imageMode(CENTER);
    blured.image(pass1, blured.width/2, blured.height/2);
    blured.endDraw();
    image(blured, window.width/2, window.height/2, window.width, window.height);
  }

  /////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
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
    this.alph[0] = beat;
    this.alph[1] = pulz;
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
  }
  void decay() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
    //beatTimer++;
    //beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
    //// the last 10 onsets  0.02 would average the last 100
    //if (avgtime>0) beat*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
    //else 
    beat*=0.95;
    if (beat < 0.8) beat *= 0.9;
    pulz = 1-beat;                     /// p is opposite of b
    beatFast *=0.7;                 
    pulzFast = 1-pulzFast;            /// bF is oppiste of pF
    beatSlow -= 0.05;
    pulzSlow = 1-beatSlow;
    float end = 0.001;
    if (beat < end) beat = end;
    if (pulzFast > 1) pulzFast = 1;
    if (beatFast < end) beatFast = end;
    if (beatSlow < 0.4+(noize1*0.2)) beatSlow = 0.4+(noize1*0.2);
    if (pulzSlow > 1) pulzSlow = 1;
  }
}
