interface Animation {
  void trigger();
  void decay();
}


class AllOn extends ManualAnim{
  AllOn(float _alphaSlider, float _funcSlider){
    super(_alphaSlider,_funcSlider);
  }
  void draw(){
    window.background(360*alpha);
    //window.rect(window.width,window.height,window.width/2,window.height/2);
  }
}


abstract class ManualAnim extends Anim{
  float alphaSlider;
  float funcSlider;
  ManualAnim(float _alphaSlider, float _funcSlider){
    super(-1);
    alphaSlider=_alphaSlider;
    funcSlider=_funcSlider;
  }
  void draw() {
  }
  void drawAnim() {
    decay();
    alphaFunction();
    window.beginDraw();
    window.background(0);
    draw();
    window.endDraw();
    blurPGraphics();
  }
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

  Anim(int _vizIndex) {
    resetbeats(); 
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
    vizIndex = _vizIndex;
  }

  float stroke, wide, high, rotate;
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
      stroke = 30+(90*functionA*oskP);
      wide = size.vizWidth*1.2;
      wide = wide-(wide*functionA);
      high = wide*2;
      rotate = 90*noize*functionB;
      donut(grid.mirror[2].x, grid.mirror[2].y, col1, stroke, wide, high, rotate, alphaA);
      donut(grid.mirror[9].x, grid.mirror[9].y, col1, stroke, wide, high, rotate, alphaA);
      stroke = 30+(90*functionB*oskP);
      wide = size.vizWidth*1.2;
      wide = wide-(wide*functionB);
      high = wide*2;
      rotate = -90*noize*functionA;
      donut(grid.mirror[3].x, grid.mirror[3].y, col1, stroke, wide, high, rotate, alphaA);
      donut(grid.mirror[8].x, grid.mirror[8].y, col1, stroke, wide, high, rotate, alphaA);
      window.endDraw();
      break;
    case 1:
      window.beginDraw();
      window.background(0);
      stroke = 20+(400*tweakSlider);
      rotate = 0;
      if (beatCounter % 9 <3) { 
        for (int i = 0; i < grid.columns; i+=2) {
          wide = (size.vizWidth*2)-(size.vizWidth/10);
          wide = 50+(wide-(wide*functionA)); 
          high = wide;
          donut(grid.mirror[i].x, grid.mirror[i].y, col1, stroke, wide, high, rotate, alphaA);
          donut(grid.mirror[i+1 % grid.columns+6].x, grid.mirror[i+1 % grid.columns+6].y, col1, stroke, wide, high, rotate, alphaA);

          wide = (size.vizWidth/4)-(size.vizWidth/10);
          wide = 10+(wide-(wide*functionB)); 
          high = wide;
          donut(grid.mirror[i+1 % grid.columns].x, grid.mirror[i+1 % grid.columns].y, col1, stroke, wide, high, rotate, alphaB);
          donut(grid.mirror[i+6].x, grid.mirror[i+6].y, col1, stroke, wide, high, rotate, alphaB);
        }
      } else { // opposite way around
        for (int i = 0; i < grid.columns; i+=2) {
          wide  = (size.vizWidth*2)-(size.vizWidth/10);
          wide = 50+(wide-(wide*functionA)); 
          high = wide;
          donut(grid.mirror[i+1 % grid.columns].x, grid.mirror[i+1 % grid.columns].y, col1, stroke, wide, high, rotate, alphaB);
          donut(grid.mirror[i+6].x, grid.mirror[i+6].y, col1, stroke, wide, high, rotate, alphaB);

          wide = (size.vizWidth/4)-(size.vizWidth/10);
          wide = 10+(wide-(wide*functionB)); 
          high = wide;
          donut(grid.mirror[i].x, grid.mirror[i].y, col1, stroke, wide, high, rotate, alphaA);
          donut(grid.mirror[i+1 % grid.columns+6].x, grid.mirror[i+1 % grid.columns+6].y, col1, stroke, wide, high, rotate, alphaA);
        }
      }
      window.endDraw();
      break;
    case 2:
      window.beginDraw();
      window.background(0);
      stroke = 10+(30*function);
      if (beatCounter % 8 < 3) rotate = -60*func[0];
      else rotate = 60* func[0];
      wide = 10+(func[0]*size.vizWidth);
      high = 110-(func[1]*size.vizHeight);
      star(grid.mirrorX[2][0].x, grid.mirrorX[2][0].y, col1, stroke, wide, high, rotate, alphaA);
      star(grid.mirrorX[4][2].x, grid.mirrorX[4][2].y, col1, stroke, wide, high, rotate, alphaA);

      wide = 10+(func[1]*size.vizWidth);
      high = 110+(func[0]*size.vizHeight);
      if (beatCounter % 8 < 3) rotate = 60*func[1];
      else rotate = -60*func[1];
      star(grid.mirrorX[4][0].x, grid.mirrorX[4][0].y, col1, stroke, wide, high, rotate, alphaA);
      star(grid.mirrorX[2][2].x, grid.mirrorX[2][2].y, col1, stroke, wide, high, rotate, alphaA);
      window.endDraw();
      break;
    case 3:
      window.beginDraw();
      window.background(0);
      wide = 500+(noize*150);
      if (beatCounter % 8 < 3) {
        rush(grid.mirror[0].x, grid.mirror[0].y, col1, wide, vizHeight/2, functionA, alphaA);
        rush(grid.mirror[6].x, grid.mirror[6].y, col1, wide, vizHeight/2, 1-functionA, alphaA);
      } else {
        rush(grid.mirror[0].x, grid.mirror[0].y, col1, wide, vizHeight/2, 1-functionA, alphaA);
        rush(grid.mirror[6].x, grid.mirror[6].y, col1, wide, vizHeight/2, functionA, alphaA);
      }
      window.endDraw();
      break;
    case 4:
      window.beginDraw();
      window.background(0);
      wide = 150+(noize*600*functionA);
      rush(viz.x, grid.mirror[0].y, col1, wide, vizHeight/2, functionA, alphaA);
      rush(viz.x, grid.mirror[0].y, col1, wide, vizHeight/2, 1-functionB, alphaA);
      rush(-vizWidth/2, grid.mirror[0].y, col1, wide, vizHeight/2, 1-functionA, alphaA);
      rush(-vizWidth/2, grid.mirror[0].y, col1, wide, vizHeight/2, functionB, alphaA);

      rush(viz.x, grid.mirror[6].y, col1, wide, vizHeight/2, 1-functionA, alphaA);
      rush(viz.x, grid.mirror[6].y, col1, wide, vizHeight/2, functionB, alphaA);
      rush(-vizWidth/2, grid.mirror[6].y, col1, wide, vizHeight/2, functionA, alphaA);
      rush(-vizWidth/2, grid.mirror[6].y, col1, wide, vizHeight/2, 1-functionB, alphaA);
      window.endDraw();
      break;
    case 5:
      window.beginDraw();
      window.background(0);
      wide = 10+(functionA*size.vizWidth*1.5);
      high = 10+(functionB*size.vizHeight*1.5);
      stroke = 30+(60*functionA*noize1);
      rotate = 30;
      star(grid.mirrorX[1][1].x, grid.mirrorX[1][1].y, col1, stroke, wide, high, rotate, alphaA);
      rotate = -30;
      star(grid.mirrorX[5][1].x, grid.mirrorX[5][1].y, col1, stroke, wide, high, rotate, alphaA);
      window.endDraw();
      break;
    case 6:
      window.beginDraw();
      window.background(0);

      stroke = 300-(200*noize);
      wide = size.vizWidth+(50);
      high = wide;
      squareNut(grid.mirror[1].x, grid.mirrorX[1][1].y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(grid.mirror[4].x, grid.mirrorX[4][1].y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);

      window.endDraw();
      break;
    default:
      break;
    }
    blurPGraphics();
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// SQUARE NUT /////////////////////////////////////////////////////////////////////////////////////////////////
  void squareNut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(col, 360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.rect(0, 0, wide, high);
    window.popMatrix();
  }
  /////////////////////////////////// DONUT /////////////////////////////////////////////////////////////////////////////////////////////////
  void donut(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(col, 360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }
  /////////////////////////////////// STAR ////////////////////////////////////////////////////////////////////////
  void star(float xpos, float ypos, color col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(col, 360*alph);
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


  void rush(float xpos, float ypos, color col, float wide, float high, float func, float alph) {
    float moveA;
    float strt = xpos;
    moveA = (strt+(window.width)*func);
    //if (beatCounter % 8 <4 )  moveA = (strt+(window.width-strt)*func);
    //else  moveA = (window.width-strt)-(strt+(window.width-strt)*func);
    window.imageMode(CENTER);
    window.image(bar1, moveA, ypos, wide, high);
    window.tint(col, 360*alph);
  }

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
    alph[6] = alphaSlow;

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
  boolean deleteme=false;
  //////////////////////////////////////// DECAY ////////////////////////////////////////////////
  void decay() {            
    if (avgtime>0) {
      alpha*=pow(alphaSlider, (1/avgtime));       //  changes rate alpha fades out!!
      function*=pow(funcSlider, (1/avgtime));     //  changes rate alpha fades out!!
    } else {
      alpha*=0.95*alphaSlider;
      function*=0.95*funcSlider;
    }
    if (alpha < 0.8) alpha *= 0.9;
    if (function < 0.8) function *= 0.9;

    alphaFast *=0.7;                 
    alphaSlow -= 0.05;

    functionFast *=0.7;  
    if (functionSlow < 0.4) functionSlow *= 0.99*noize1;
    else functionSlow -= 0.02;

    float end = 0.001;
    if (alpha < end) alpha = end+(shimmer*0.1);
    if (alphaFast < end) alphaFast = end;
    if (alphaSlow < 0.4+(noize1*0.2)) alphaSlow = 0.4+(noize1*0.2);

    if (function < end) function = end;
    if (functionFast < end) functionFast = end;
    if (functionSlow < end) {
      functionSlow = end;
      deleteme=true;
    }
  }
}
