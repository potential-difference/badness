interface Animation {
  void trigger();
  void decay();
}

class Anim implements Animation {
  /////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
  PGraphics window, pass1, blured;
  int blury, prevblury, vizIndex;
  float alphMod=1, funcMod=1, funcFX=1, alphFX=1;
  float xpos, ypos;
  PShader blur;
  color col1, col2;

  float alph[] = new float[7];
  float func[] = new float[8];

  Anim(float _xpos, float _ypos, int _vizIndex) {
    //// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
    blury = int(map(blurSlider, 0, 1, 0, 100));
    if (blury!=prevblury) {
      prevblury=blury;
    }

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
    blur.set("blurSize", blury);
    blur.set("sigma", 10.0f);  
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
    decay();
    alphaFunction();

    PVector viz = new PVector(size.rig.x, size.rig.y);
    col1 = white;
    col2 = white;
    vizWidth = float(blured.width*2);
    vizHeight = float(blured.height*2);

    float alphaA = alph[rigAlphIndex]*alphFX*dimmer;
    float functionA = func[fctIndex]*funcFX;
    float alphaB = alph[rigAlph1Index]*alphFX*dimmer;
    float functionB = func[fct1Index]*funcFX;

    switch (vizIndex) {
    case 0:
      window.beginDraw();
      window.background(0);
      stroke = 60+(120*functionB*oskP);
      wide = size.vizWidth+(0);
      wide = wide-(wide*functionB);
      high = wide;
      if (wide > 120) donut(viz.x, viz.y, col1, stroke, wide, high, alphaA);
      window.endDraw();
      break;
    case 1:
      window.beginDraw();
      window.background(0);
      stroke = 20+(400*tweakSlider); 
      if (beatCounter % 9 <3) { 
        for (int i = 0; i < grid.columns; i+=2) {
          wide = (size.vizWidth*2)-(size.vizWidth/10);
          wide = 50+(wide-(wide*functionA)); 
          high = wide;
          donut(grid.mirror[i].x, grid.mirror[i].y, col1, stroke, wide, high, alphaA);
          donut(grid.mirror[i+1 % grid.columns+6].x, grid.mirror[i+1 % grid.columns+6].y, col1, stroke, wide, high, alphaA);

          wide = (size.vizWidth/4)-(size.vizWidth/10);
          wide = 10+(wide-(wide*functionB)); 
          high = wide;
          donut(grid.mirror[i+1 % grid.columns].x, grid.mirror[i+1 % grid.columns].y, col1, stroke, wide, high, alphaB);
          donut(grid.mirror[i+6].x, grid.mirror[i+6].y, col1, stroke, wide, high, alphaB);
        }
      } else { // opposite way around
        for (int i = 0; i < grid.columns; i+=2) {
          wide  = (size.vizWidth*2)-(size.vizWidth/10);
          wide = 50+(wide-(wide*functionA)); 
          high = wide;
          donut(grid.mirror[i+1 % grid.columns].x, grid.mirror[i+1 % grid.columns].y, col1, stroke, wide, high, alphaB);
          donut(grid.mirror[i+6].x, grid.mirror[i+6].y, col1, stroke, wide, high, alphaB);

          wide = (size.vizWidth/4)-(size.vizWidth/10);
          wide = 10+(wide-(wide*functionB)); 
          high = wide;
          donut(grid.mirror[i].x, grid.mirror[i].y, col1, stroke, wide, high, alphaA);
          donut(grid.mirror[i+1 % grid.columns+6].x, grid.mirror[i+1 % grid.columns+6].y, col1, stroke, wide, high, alphaA);
        }
      }
      window.endDraw();
      break;
    }
    blurPGraphics();
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
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
    //// array of functions
    func[0] = 1-function;         
    func[1] = function;        
    func[2] = 1-functionSlow; 
    func[3] = (functionSlow*0.99)+(0.01*stutter);
    func[4] = (0.99*1-function)+(stutter*(1-function)*0.01);       
    func[5] = (0.99*functionSlow)+(stutter*(1-function)*0.01);
    func[6] = 1-functionSlow;
    func[7] = functionSlow;
    //// array of alphas
    alph[0] = alpha;
    alph[1] = 1-alpha;
    alph[2] = alpha+(0.05*stutter);
    alph[3] = (0.98*alpha)+(stutter*(1-alpha)*0.02);
    alph[4] = (0.98*(1-alpha))+(alpha*0.02*stutter);
    alph[5] = alphaFast;
    alph[6] = 1-alphaSlow;

    for (int i = 0; i < alph.length; i++) alph[i] *=alphMod;
    for (int i = 0; i < func.length; i++) func[i] *=funcMod;
  }
  //////////////////////////////////// TRIGGER //////////////////////////////////////////////
  float alpha, alphaFast, alphaSlow;
  float function, functionFast, functionSlow;
  void trigger() {
    alpha = 1;
    alphaFast = 1;
    alphaSlow = 1;

    function = 1;
    functionFast = 1;
    functionSlow = 1;
  }
  //////////////////////////////////////// DECAY ////////////////////////////////////////////////
  void decay() {            
    if (avgtime>0) {
      alpha*=pow(alphaSlider, (1/avgtime));       //  changes rate alpha fades out!!
      function*=pow(funcSlider, (1/avgtime));     //  changes rate alpha fades out!!
    } else {
      alpha*=0.95;
      function*=0.95;
    }
    if (alpha < 0.8) alpha *= 0.9;
    if (function < 0.8) function *= 0.9;

    alphaFast *=0.7;                 
    alphaSlow -= 0.05;

    functionFast *=0.7;                 
    functionSlow -= 0.05;

    float end = 0.001;
    if (alpha < end) alpha = end;
    if (alphaFast < end) alphaFast = end;
    if (alphaSlow < 0.4+(noize1*0.2)) alphaSlow = 0.4+(noize1*0.2);

    if (function < end) function = end;
    if (functionFast < end) functionFast = end;
    if (functionSlow < 0.4+(noize1*0.2)) functionSlow = 0.4+(noize1*0.2);
  }
}
