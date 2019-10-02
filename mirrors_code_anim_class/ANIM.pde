


class Anim implements Animation  {
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

    //trigger();
    //decay();
  }
  float stroke, wide, high;
  PVector viz;
  Float vizWidth, vizHeight;

  void drawAnim(PGraphics subwindow, float xpos, float ypos) {


    alphaFunction();
    PVector viz = new PVector(size.rig.x, size.rig.y);
    vizWidth = float(blured.width*2);
    vizHeight = float(blured.height*2);
    col1 = color(white);
    col2 = color(white);
    alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
    function = func[fctIndexA]*funcFX;

    switch (rigViz) {
    case 0:
      stroke = 100-(80*noize);
      wide = size.vizWidth+(50);
      high = wide;
      alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
      function = func[fctIndexA]*funcFX;
      visual[0].squareNut(col1, stroke, wide-(wide*function), high-(high*function), alpha);
      subwindow.beginDraw();
      subwindow.background(0);
      subwindow.blendMode(LIGHTEST);
      subwindow.image(visual[0].blured, grid.mirrorX[1][1].x, grid.mirrorX[1][1].y, blured.width*2.5, blured.height*2.5);
      subwindow.image(visual[0].blured, grid.mirrorX[3][2].x, grid.mirrorX[3][2].y, blured.width*2.5, blured.height*2.5);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      break;
    case 1:
      wide = size.vizWidth/2;
      high = size.vizHeight*2;
      alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
      function = func[fctIndexA]*funcFX;
      stroke = 20+(noize1*50*function);
      visual[0].donut(col1, stroke, wide-(wide*function), high-(high*function), alpha);

      wide = size.vizWidth*2;
      high = size.vizHeight/2;
      alpha = alph[rigAlphaIndexB]*alphFX*dimmer;
      function = func[fctIndexB]*funcFX;
      stroke = 20+(noize1*50*function);
      visual[1].donut(col1, stroke, wide-(wide*function), high-(high*function), alpha);

      subwindow.beginDraw();
      subwindow.background(0);
      subwindow.blendMode(LIGHTEST);
      subwindow.image(visual[0].blured, grid.mirror[4].x, grid.mirror[4].y, blured.width*3, blured.height*3);
      subwindow.image(visual[1].blured, viz.x, viz.y, blured.width*2.5, blured.height*2.5);
      subwindow.image(visual[0].blured, grid.mirror[7].x, grid.mirror[7].y, blured.width*3, blured.height*3);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      break;
    case 2:
      float reSize = (size.vizWidth*3)-(size.vizWidth/10);
      alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
      stroke = 10+(50*tweakSlider); 
      function = func[fctIndexA]*funcFX;
      wide = 50+(reSize-(reSize*function)); 
      high = wide;
      visual[0].donut(col1, stroke, wide, high, alpha);

      alpha = alph[rigAlphaIndexB]*alphFX*dimmer;
      function = func[fctIndexB]*funcFX;
      reSize = (size.vizWidth/4)-(size.vizWidth/10);
      wide = 10+(reSize-(reSize*function)); 
      high = wide;
      visual[1].donut(col1, stroke, wide, high, alpha);

      subwindow.beginDraw();
      subwindow.background(0);
      subwindow.blendMode(LIGHTEST);
      for (int o = 0; o < 4; o++)  subwindow.image( visual[0].blured, grid.mirror[o].x, grid.mirror[o].y);
      for (int o = 8; o < 12; o++) subwindow.image( visual[0].blured, grid.mirror[o].x, grid.mirror[o].y);
      for (int o = 4; o < 8; o++)  subwindow.image( visual[1].blured, grid.mirror[o].x, grid.mirror[o].y);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      break;
    case 3:
      stroke = size.vizWidth/16; 
      wide = (size.vizWidth*2);
      high = (size.vizHeight*2);
      alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
      function = func[fctIndexA]*funcFX;
      for ( int i = 0; i < visual.length; i++) visual[i].donut(col1, stroke, wide-(wide*function*(i+1)), high-(high*function*(i+1)), alpha);
      subwindow.beginDraw();
      subwindow.background(0); 
      subwindow.blendMode(LIGHTEST);
      for (int i = 0; i <visual.length; i++) subwindow.image( visual[i].blured, grid.mirror[5].x, grid.mirror[5].y, vizWidth, vizHeight);
      for (int i = 0; i <visual.length; i++) subwindow.image( visual[i].blured, grid.mirror[6].x, grid.mirror[6].y, vizWidth, vizHeight);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    case 4:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      function = func[fctIndexA]*funcFX;
      alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
      stroke = 2+(8*function);
      wide = 10+(beat*size.vizWidth);
      high = 110-(pulz*size.vizHeight);
      visual[0].star(wide, high, -60*beat, col1, stroke, alpha);  

      wide = 10+(pulz*size.vizWidth);
      high = 110+(beat*size.vizHeight);
      alpha = alph[rigAlphaIndexB]*alphFX*dimmer;
      visual[1].star(wide, high, 60*pulz, col1, stroke, alpha);

      subwindow.beginDraw();
      subwindow.background(0);
      subwindow.blendMode(LIGHTEST);
      subwindow.image(visual[0].blured, grid.mirrorX[1][1].x, grid.mirrorX[1][1].y, vizWidth*1.2, vizHeight*1.2);
      subwindow.image(visual[1].blured, grid.mirrorX[3][1].x, grid.mirrorX[3][1].y, vizWidth*1.2, vizHeight*1.2);
      subwindow.image(visual[1].blured, grid.mirrorX[1][2].x, grid.mirrorX[1][2].y, vizWidth*1.2, vizHeight*1.2);
      subwindow.image(visual[0].blured, grid.mirrorX[3][2].x, grid.mirrorX[3][2].y, vizWidth*1.2, vizHeight*1.2);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      break;
    case 5:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      toggle.rect = true;
      function = func[fctIndexA]*funcFX;
      alpha = alph[rigAlphaIndexA]*alphFX*dimmer;
      stroke = 2+(15*noize*function);
      wide = 10+(pulz*size.vizWidth*1.5);
      high = 10+(beat*size.vizHeight*1.5);
      if (beatCounter % 3 == 0) {
        visual[0].star(wide, high, -120*noize*function, col1, stroke, alpha);  
        visual[1].star(wide, high, 120*noize*function, col1, stroke, alpha);
      } else {
        visual[0].star(wide, high, 120*noize2*function, col1, stroke, alpha);  
        visual[1].star(wide, high, -120*noize2*function, col1, stroke, alpha);
      }
      subwindow.beginDraw();
      subwindow.background(0);
      subwindow.blendMode(LIGHTEST);
      subwindow.image(visual[0].blured, grid.mirror[4].x, grid.mirror[4].y, vizWidth*1.4, vizHeight*1.4);
      subwindow.image(visual[1].blured, grid.mirror[7].x, grid.mirror[7].y, vizWidth*1.4, vizHeight*1.4);
      //subwindow.image(visual[1].blured, viz.x, viz.y, vizWidth*1.4, vizHeight*1.4);
      subwindow.endDraw();
      image(subwindow, xpos, ypos);
      break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /*
    case 6:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
       for (int i = 0; i < 4; i++) {
       stroke = 40+(80*oskP);
       wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function));
       high = wide;
       // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
       donut(i, col1, stroke, wide, high, alpha*alf*dimmer);
       }
       for (int i = 0; i < 4; i++) {
       stroke = 40+(80*noize2);
       wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function1[i]));
       high = wide;
       // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
       squareNut(i+4, col1, stroke, wide, high, alpha1[i]*alf*dimmer);
       }
       subwindow.beginDraw();
       subwindow.background(0);
       subwindow.blendMode(LIGHTEST);
       for (int i = 0; i < 4; i++) {
       subwindow.image( blured[i], grid.mirror[0].x, grid.mirror[0].y, size.vizWidth*2, size.vizHeight*2);
       subwindow.image( blured[i], grid.mirror[3].x, grid.mirror[3].y, size.vizWidth*2, size.vizHeight*2);
       subwindow.image( blured[i], grid.mirror[8].x, grid.mirror[8].y, size.vizWidth*2, size.vizHeight*2);
       subwindow.image( blured[i], grid.mirror[11].x, grid.mirror[11].y, size.vizWidth*2, size.vizHeight*2);
       
       subwindow.image( blured[i+4], grid.mirror[5].x, grid.mirror[5].y, size.vizWidth*2, size.vizHeight*2);
       subwindow.image( blured[i+4], grid.mirror[6].x, grid.mirror[6].y, size.vizWidth*2, size.vizHeight*2);
       }
       break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       case 7:  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
       // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
       for (int i=0; i<4; i++) {
       stroke = 25+(100*function[i]);
       star(i, 10+(function[i]*size.vizWidth*2), 110-(function1[i]*size.vizHeight), 45*beats[i]*noize1, col1, stroke, alpha[i]*alf*dimmer);
       }
       subwindow.beginDraw();
       subwindow.background(0);
       subwindow.blendMode(LIGHTEST);
       for (int i = 0; i < 4; i++) {
       subwindow.image(blured[i], size.rig.x-(size.vizWidth/2), size.rig.y-(size.vizHeight/2), size.vizWidth*2.5, size.vizHeight*2);
       subwindow.image(blured[i], size.rig.x+(size.vizWidth/2), size.rig.y+(size.vizHeight/2), size.vizWidth*2.5, size.vizHeight*2);
       }
       break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       case 8: /////////////////////////////////////////////////////////////////////////////////////////////////////////////
       stroke = 56+(43*noize*func);
       // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
       star(0, 10+(pulz*size.vizWidth), 10+(beats[0]*size.vizHeight), 120*pulzs[0], col1, stroke, alpha[0]*alf*dimmer);
       star(2, 10+(pulz*size.vizWidth), 10+(beats[2]*size.vizHeight), -120*pulzs[2], col1, stroke, alpha[2]*alf*dimmer);
       
       star(1, 10+(beats[1]*size.vizWidth), 10+(pulzs[1]*size.vizHeight), 120*beats[1], col1, stroke, alpha1[1]*alf*dimmer);
       star(3, 10+(beats[3]*size.vizWidth), 10+(pulzs[3]*size.vizHeight), -120*beats[3], col1, stroke, alpha1[3]*alf*dimmer);
       subwindow.beginDraw();
       subwindow.background(0);
       subwindow.blendMode(LIGHTEST);
       for (int i = 0; i <4; i+=2) {
       subwindow.image(blured[i], grid.mirror[1].x, grid.mirror[1].y);
       subwindow.image(blured[i], grid.mirror[5].x, grid.mirror[5].y);
       subwindow.image(blured[i], grid.mirror[9].x, grid.mirror[9].y);
       
       subwindow.image(blured[i], grid.mirror[2].x, grid.mirror[2].y);
       subwindow.image(blured[i], grid.mirror[6].x, grid.mirror[6].y);
       subwindow.image(blured[i], grid.mirror[10].x, grid.mirror[10].y);
       }
       for (int i = 1; i <4; i+=2) {
       subwindow.image(blured[i], grid.mirror[0].x, grid.mirror[0].y);
       subwindow.image(blured[i], grid.mirror[4].x, grid.mirror[4].y);
       subwindow.image(blured[i], grid.mirror[8].x, grid.mirror[8].y);
       
       subwindow.image(blured[i], grid.mirror[3].x, grid.mirror[3].y);
       subwindow.image(blured[i], grid.mirror[7].x, grid.mirror[7].y);
       subwindow.image(blured[i], grid.mirror[11].x, grid.mirror[11].y);
       }
       break; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       case 9: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       //PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
       wide = 500+(noize*150);
       for (int i = 0; i < 4; i+=2) rush(i, col1, wide, size.vizHeight, function[i], alpha[0]*alf*dimmer);
       for (int i = 1; i < 4; i+=2) rush(i, col1, wide, size.vizHeight, 1-function[i], alpha[0]*alf*dimmer);
       subwindow.beginDraw();
       subwindow.background(0);
       subwindow.blendMode(LIGHTEST);
       for (int i = 0; i < 4; i++) subwindow.image(vis[i], size.viz.x, size.viz.y);
       break;   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       case 10: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       //PGraphics rush(int n, color col, color col1, float wide, float high, float func, float alph) {
       //wide = 800-(noize1*100*func);
       for (int i = 0; i < 4; i++) {
       wide = 800-(noize1*100*function[i]);
       rush(i, col1, wide, grid.mirrorAndGap, function[i], alpha[0]*alf*dimmer);
       rush(i+4, col1, wide, grid.mirrorAndGap, 1-function[i], alpha[0]*alf*dimmer);
       }
       subwindow.beginDraw();
       subwindow.background(0);
       subwindow.blendMode(LIGHTEST);
       for (int i = 0; i < 4; i++) {
       subwindow.image(vis[i+4], size.viz.x+(size.vizWidth/2+grid.dist), grid.mirror[0].y);
       subwindow.image(vis[i], size.viz.x-(size.vizWidth/2+grid.dist), grid.mirror[0].y);
       
       subwindow.image(vis[i+4], size.viz.x-(size.vizWidth/2+grid.dist), size.viz.y);
       subwindow.image(vis[i], size.viz.x+(size.vizWidth/2+grid.dist), size.viz.y);
       
       subwindow.image(vis[i+4], size.viz.x+(size.vizWidth/2+grid.dist), grid.mirror[8].y);
       subwindow.image(vis[i], size.viz.x-(size.vizWidth/2+grid.dist), grid.mirror[8].y);
       }
       break;
       */
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
    func[3] = (beatSlow*0.99)+(0.005*stutter);
    func[4] = (0.99*pulz)+(stutter*pulz*0.005);       
    func[5] = (0.99*beatSlow)+(stutter*pulz*0.005);
    func[6] = pulzSlow;
    func[7] = beatSlow;

    //// array of alphas
    alph[0] = beat;
    alph[1] = pulz;
    alph[2] = beat+(0.05*stutter);
    alph[3] = (0.98*beat)+(stutter*pulz*0.02);
    alph[4] = (0.98*pulz)+(beat*0.02*stutter);
    alph[5] = beatFast;
    alph[6] = pulzSlow;

    for (int i = 0; i < alph.length; i++) alph[i] *=alphMod;
    for (int i = 0; i < func.length; i++) func[i] *=funcMod;
  }
  //////////////////////////////////// BEATS //////////////////////////////////////////////
  float beat, beatSlow, pulz, pulzSlow, pulzFast, beatFast, beatCounter;

  //long beatTimer;
  //float avgtime, avgvolume;
  //float weightedsum, weightedcnt;
  //float beatAlpha;
  void trigger() {
    beat = 1;
    beatFast = 1;
    beatSlow = 1;

    //beatCounter = (beatCounter + 1) % 120;
    //weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
    //weightedcnt=1+(1-beatAlpha)*weightedcnt;
    //avgtime=weightedsum/weightedcnt;
    //beatTimer=0;
  }
  void decay() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
    //beatTimer++;
    //beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
    // the last 10 onsets  0.02 would average the last 100
    float rate = map(beatSlider, 0, 1, 0.1, 1.5);
    if (avgtime>0) {
      beat*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
      for (int i = 0; i < animations.size(); i++) {
        if (beatCounter % animations.size() != i) {
          beat*=pow(rate, (1/avgtime));                               //  else if beat is 1,2 or 3 decay faster
          println("PREVIOUS BEAT");
        }
        if (beatCounter % animations.size() == i) {
          beat*=pow(rate/3, (1/avgtime)); //  changes rate alpha fades out!!
          println("CURRENT BEAT");
        }
      }
    } else { 
      beat*=0.95;
    }
    //if (avgtime>0) {
    //  beat*=pow(rate, (1/avgtime)); //  changes rate alpha fades out!!
    //  for (int i = 0; i < animations.size(); i++) if (beatCounter % animations.size() != i) beat*=pow(rate/5, (1/avgtime));  //  else if beat is 1,2 or 3 decay faster
    //} else beat*=0.95;
    //beat*=0.95;
    if (beat < 0.8) beat *= 0.98;
    beatFast *=0.9;                 
    beatSlow -=0.03;

    float end = 0.01;
    if (beat < end) beat = 0;
    if (beatFast < end) beatFast = 0;
    if (beatSlow < end) beatSlow = 0;
    pulz = 1-beat;                     
    pulzFast = 1-beatFast;            
    pulzSlow = 1-beatSlow;

    //println(beat);
    //println(beatSlow);
    //println(beatFast);
    //println(pulz);
    //println(pulzSlow);
    //println(pulzFast);
    //println();
  }

  /*
  /////////////////////////////////// SQUARE NUT ////////////////////////////////////
   PGraphics squareNut(color col, float stroke, float wide, float high, float alph) {
   //
   try {
   vis.beginDraw();
   vis.colorMode(HSB, 360, 100, 100);
   vis.background(0);
   vis.strokeWeight(-stroke);
   vis.stroke(360*alph);
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
   }
   */
}
