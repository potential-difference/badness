import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javax.sound.midi.ShortMessage; 
import oscP5.*; 
import netP5.*; 
import themidibus.*; 
import java.net.*; 
import java.util.Arrays; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import javax.sound.sampled.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class lightbox_code extends PApplet {

OPC opc;
OPC opcLocal;
OPC opcMirrors; 
OPC opcMirror1; 
OPC opcMirror2;
OPC opcSeeds;
OPC opcCans;
OPC opcControllerA;
OPC opcControllerB;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid grid;
ControlFrame controlFrame;
Toggle toggle = new Toggle();

SketchColor rigColor, roofColor, cansColor;
ColorLayer rigLayer, roofLayer, cansLayer;
Buffer rigBuffer, roofBuffer, cansBuffer;

ArrayList <Anim> animations;

       // shorthand names for each control on the TR8


OscP5 oscP5[] = new OscP5[4];

  
MidiBus TR8bus;       // midibus for TR8
MidiBus faderBus;     // midibus for APC mini
MidiBus LPD8bus;      // midibus for LPD8

PFont myFont;
boolean onTop = false;
public void settings() {
  size = new SizeSettings(LANDSCAPE);

  size(size.sizeX, size.sizeY, P2D);
  size.surfacePositionX = 900;   //pi settings
  size.surfacePositionY = 40;    //pi settings
  //size.surfacePositionX = 1560;  // laptop settings
  //size.surfacePositionY = 180;  // laptop settings
}
float dimmer = 1;
public void setup()
{
  surface.setAlwaysOnTop(onTop);
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  grid = new OPCGrid();

  ///////////////// LOCAL opc /////////////////////
  opcLocal = new OPC(this, "127.0.0.1", 7890);
  //opcMirrors = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRRORS
  //opcCans = new OPC(this, "127.0.0.1", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  ///////////////// OPC over NETWORK /////////////////////
  //opcMirrors = new OPC(this, "192.168.0.70", 7890);       // Connect to the remote instance of fcserver - MIRROR 1
  //opcCans = new OPC(this, "192.168.0.10", 7890);          // Connect to the remote instance of fcserver - CANS BOX

  //grid.mirrorsOPC(opcMirrors, opcMirrors, 0);               // grids 0-3 MIX IT UPPPPP 
  //grid.pickleCansOPC(opcCans);               
  //grid.pickleBoothOPC(opcCans);   
  grid.lightboxOPC(opcLocal);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  rigBuffer = new Buffer(size.rigWidth, size.rigHeight);
  roofBuffer = new Buffer(size.roofWidth, size.roofHeight);
  cansBuffer = new Buffer(size.cansWidth, size.cansHeight);

  drawingSetup();
  loadImages();
  loadGraphics();
  loadShaders();
  colorSetup();  
  rigColor = new SketchColor();
  roofColor = new SketchColor(); 
  cansColor = new SketchColor();

  rigViz = 0;
  roofViz = 10;
  rigBgr = 5;
  roofBgr = 4;

  rigColor.colorA = 1;
  rigColor.colorB = 2;
  roofColor.colorA = 9;
  roofColor.colorB = 10;
  cansColor.colorA = 7;
  cansColor.colorB = 11;
  dimmer = 0.8f;

  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75f;
  cc[2] = 0.75f;
  cc[5] = 0.3f;
  cc[6] = 0.75f;
  cc[8] = 1;
  cc[MASTERFXON] = 0;

  controlFrame = new ControlFrame(this, 1200, 130, "Controls"); // load control frame must come after shild ring etc
  animations = new ArrayList<Anim>();
  animations.add(new Anim(0, alphaSlider, funcSlider, rigDimmer));
  frameRate(30);
}
float vizTime, colTime;
int roofViz, rigViz, colStepper = 1;
int time_since_last_anim=0;
public void draw()
{
  //println("framerate: "+int(frameRate));

  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                                ////// number of seconds before no music detected and auto kicks in
  globalFunctions();
  vizTime = 60*15*vizTimeSlider;
  if (frameCount > 10) playWithYourself(vizTime); 
  rigColor.clash(noize1);

  //////////// WHY DOESN't THIS WORK???? ?/////////////////////////////
  ///// ECHO RIG DIMMER SLIDER AND MIDI SLIDER 4 to control rig dimmer but only whne slider is changed
  //if (cc[4]!=prevcc[4]) {
  //  prevcc[4]=cc[4];
  //  if (cc[4] != rigDimmer) cp5.getController("rigDimmer").setValue(cc[4]);
  //}  

  //if (cc[8]!=prevcc[8]) {
  //   prevcc[8]=cc[8];
  //   if (cc[8] != roofDimmer) cp5.getController("roofDimmer").setValue(cc[8]);
  // }  

  rigDimmer = cc[4]; // come back to this with wigxxxflex code?!
  roofDimmer = cc[8]; // come back to this with wigflex code?!

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  playWithMe();
  // create a new anim object and add it to the beginning of the arrayList
  if (beatTrigger) if (rigToggle)    animations.add(new Anim(rigViz, alphaSlider, funcSlider, rigDimmer));   

  //if (beatCounter % 9 < 3) animations.add(new DubsonAnim( alphaSlider, funcSlider, roofDimmer)); 
  // limit the number of animations
  while (animations.size()>0 && animations.get(0).deleteme) animations.remove(0);
  if (animations.size() >= 12) animations.remove(0);  
  // adjust animations
  if (keyT['a']) for (Anim anim : animations)  anim.alphFX = 1-(stutter*0.1f);
  if (keyT['s']) for (Anim anim : animations)  anim.funcFX = 1-(stutter*noize1*0.1f);
  //draw animations
  blendMode(LIGHTEST);
  for (int i = animations.size()-1; i >=0; i--) {                                  // loop  through the list
    Anim anim = animations.get(i);  
    anim.drawAnim();           // draw the animation
  }
  
 
  ////////////////////// draw colour layer /////////////////////////////////////////////////////////////////////////////////////////////////////
  blendMode(MULTIPLY);
  rigLayer = new ColorLayer(rigBgr);
  rigLayer.drawColorLayer();
  blendMode(NORMAL);


  /////////////////////////////////////////// DUBSON LOGO ///////////////////////////////////////////////////////
  //if (beatCounter % 9 < 6) {
  //  noStroke();
  //  float tempAlpha = (((1-beat)*0.6))+(0.2*noize1*(1-beat))+(0.05*(1-beat)*stutter);
  //  fill(white, 360*tempAlpha);
  //  ellipse(size.rig.x, size.rig.y, width/4, height/4.4);
  //}
  //  ////////////////////// draw colour layer /////////////////////////////////////////////////////////////////////////////////////////////////////
  //blendMode(MULTIPLY);
  //roofLayer = new ColorLayer(roofBgr);
  //roofLayer.drawColorLayer();
  //blendMode(NORMAL);

  
  ///////////////////////////////////////// DUBSON LOGO ///////////////////////////////////////////////////////
  if (beatCounter % 9 < 6) {
    noStroke();
    float tempAlpha = (((1-beat)*0.6f))+(0.2f*noize1*(1-beat))+(0.05f*(1-beat)*stutter);
    fill(rigColor.clash, 360*tempAlpha);
    ellipse(size.rig.x, size.rig.y, width/4, height/4.4f);
  }
  //////////////////////////////////////// PLAY WITH ME MORE /////////////////////////////////////////////////////////////////////////////////
  playWithMeMore();
  //////////////////////////////////////////// BOOTH & DIG ///////////////////////////////////////////////////////////////////////////////////////
  //boothLights();
  //////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////
  workLights(keyT['w']);
  testColors(keyT['t']);
  onScreenInfo();                   // display info about current settings, viz, funcs, alphs etc
  //gid.mirrorTest(false);          // true to test physical mirror orientation
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

interface Animation {
  public void trigger();
  public void decay();
}
abstract class ManualAnim extends Anim {
  ManualAnim(float _alphaRate, float _funcRate, float _dimmer) {
    super( -1, _alphaRate, _funcRate, _dimmer);
  }
  public void draw() {
  }
  public void drawAnim() {
    super.drawAnim();
    decay();
    alphaFunction();
    window.beginDraw();
    window.background(0);
    draw();
    window.endDraw();
    image(window, viz.x, viz.y, window.width, window.height);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class AllOn extends ManualAnim {
  float manualAlpha;
  public void trigger() {
    super.trigger();
    manualAlpha=1;
  }
  public void decay() {
    super.decay();
    manualAlpha*=map(this.alphaRate, 0, 1, 0.5f, 0.97f);
    manualAlpha*=this.funcRate;
  }
  AllOn(float _alphaRate, float _funcRate, float _dimmer) {
    super(_alphaRate, _funcRate, _dimmer);
    dimmer = _dimmer;
    alphaRate=_alphaRate;
    funcRate=_funcRate;
  }
  public void draw() {
    window.background(360*manualAlpha*dimmer);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class RoofOn extends AllOn {
  public void trigger() {
    super.trigger();
  }
  public void decay() {
    super.decay();
  }
  RoofOn(float _alphaRate, float _funcRate, float _dimmer) {
    super(_alphaRate, _funcRate, _dimmer);
    viz = size.roof;
    window = roofBuffer.buffer;
  }
  public void draw() {
    window.background(360*manualAlpha*dimmer);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class CansOn extends AllOn {
  public void trigger() {
    super.trigger();
  }
  public void decay() {
    super.decay();
  }
  CansOn(float _alphaRate, float _funcRate, float _dimmer) {
    super(_alphaRate, _funcRate, _dimmer);
    viz = size.cans;
    window = cansBuffer.buffer;
  }
  public void draw() {
    window.background(360*manualAlpha*dimmer);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
class MirrorsOn extends AllOn {
  public void trigger() {
    super.trigger();
  }
  public void decay() {
    super.decay();
  }
  MirrorsOn(float _alphaRate, float _funcRate, float _dimmer) {
    super(_alphaRate, _funcRate, _dimmer);
    viz = size.rig;
    window = rigBuffer.buffer;
  }
  public void draw() {
    window.background(360*manualAlpha*dimmer);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
class Anim implements Animation {
  float alphaRate, funcRate, dimmer, alphaA, functionA, alphaB, functionB, alphMod=1, funcMod=1, funcFX=1, alphFX=1;
  int blury, prevblury, vizIndex, alphaIndexA, alphaIndexB, functionIndexA, functionIndexB;
  int col1, col2;
  PVector viz;
  PVector[] position = new PVector[12];
  PVector[][] positionX = new PVector[8][4];  
  PGraphics window, bluredA, bluredB;
  float alph[] = new float[7];
  float func[] = new float[8];

  Anim(int _vizIndex, float _alphaRate, float _funcRate, float _dimmer) {
    alphaRate = _alphaRate;
    funcRate = _funcRate;
    alphMod = _dimmer;
    resetbeats(); 
    trigger();

    //// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
    blury = PApplet.parseInt(map(blurSlider, 0, 1, 0, 100));
    if (blury!=prevblury) {
      prevblury=blury;
    }
    col1 = white;
    col2 = white;

    vizIndex = _vizIndex;
    viz = size.rig;
    window = rigBuffer.buffer;
    bluredA = rigBuffer.pass1;
    bluredB = rigBuffer.pass2;
    alphaIndexA = rigAlphaIndexA;
    alphaIndexB = rigAlphaIndexB;
    functionIndexA = rigFunctionIndexA;
    functionIndexB = rigFunctionIndexB;

    //position = grid.mirror;
    for (int i =0; i<position.length/2; i++) position[i] = new PVector((window.width/(position.length/2+1))*(i+1), window.height/3*1);
    for (int i =0; i<position.length/2; i++) position[i+6] = new PVector((window.width/(position.length/2+1))*(i+1), window.height/3*2);

    for (int i=0; i<positionX.length; i++)  positionX[i][0] = new PVector(window.width/(positionX.length+1)*(i+1), window.height/5*1);
    for (int i=0; i<positionX.length; i++)  positionX[i][1] = new PVector(window.width/(positionX.length+1)*(i+1), window.height/5*2);
    for (int i=0; i<positionX.length; i++)  positionX[i][2] = new PVector(window.width/(positionX.length+1)*(i+1), window.height/5*3);
    for (int i=0; i<positionX.length; i++)  positionX[i][3] = new PVector(window.width/(positionX.length+1)*(i+1), window.height/5*4);
  }

  float stroke, wide, high, rotate;
  Float vizWidth, vizHeight;
  public void drawAnim() {
    decay();
    alphaFunction();

    vizWidth = PApplet.parseFloat(this.window.width);
    vizHeight = PApplet.parseFloat(this.window.height);
    //for (int i = 0; i < position.length; i++) text(i, position[i].x, position[i].y);   /// mirrors Position info
    //for (int i = 0; i < positionX.length; i++) text("."+i, positionX[i][0].x, positionX[i][0].y);   /// mirrors Position info
    //for (int i = 0; i < positionX.length; i++) text("."+i, positionX[i][1].x, positionX[i][1].y);   /// mirrors Position info
    //for (int i = 0; i < positionX.length; i++) text("."+i, positionX[i][2].x, positionX[i][2].y);   /// mirrors Position info
    //for (int i = 0; i < positionX.length; i++) text("."+i, positionX[i][3].x, positionX[i][3].y);   /// mirrors Position info

    //
    // this should probably be moved to playwithyourself
    //

    /////////////////////////////////////// SHIMMER control for rig ////////////////////////////
    if (beatCounter % 42 > 36) { 
      alphaA = alph[alphaIndexA]+(shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
      alphaB = alph[alphaIndexB]+(shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
    } else {
      alphaA = alph[alphaIndexA]/1.2f;    //*(0.6+0.4*noize12)/1.5;  //// set alpha to selected alpha with bit of variation
      alphaB = alph[alphaIndexB]/1.2f;   //*(0.6+0.4*noize1)/1.5;  //// set alpha1 to selected alpha with bit of variation
    }
    //////////////// bright flash every 6 beats - counters all code above /////////
    if (beatCounter%6 == 0) {
      alphaA  = alph[alphaIndexA]*1.2f;
      alphaB  = alph[alphaIndexB]*1.2f;
    }

    alphaA *=alphFX*alf;
    alphaB *=alphFX*alf;
    functionA =func[functionIndexA]*funcFX;
    functionB =func[functionIndexB]*funcFX;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    switch (vizIndex) {
    case 0:
      window.beginDraw();
      window.background(0);
      stroke = 45+(90*functionA*oskP);
      wide = vizWidth*1.2f;
      wide = wide-(wide*functionA);
      high = wide*2;
      rotate = 90*noize*functionB;
      donut(position[2].x, position[2].y, col1, stroke, wide, high, rotate, alphaA);
      donut(position[9].x, position[9].y, col1, stroke, wide, high, rotate, alphaA);
      stroke = 30+(90*functionB*oskP);
      wide = vizWidth*1.2f;
      wide = wide-(wide*functionB);
      high = wide*2;
      rotate = -90*noize*functionA;
      donut(position[3].x, position[3].y, col1, stroke, wide, high, rotate, alphaA);
      donut(position[8].x, position[8].y, col1, stroke, wide, high, rotate, alphaA);
      window.endDraw();
      break;
    case 1:
      window.beginDraw();
      window.background(0);
      stroke = 10+(45*function);
      if (beatCounter % 8 < 3) rotate = -60*func[0];
      else rotate = 60* func[0];
      wide = 10+(func[0]*vizWidth);
      high = 110-(func[1]*vizHeight);
      star(positionX[0][0].x, positionX[0][0].y, col1, stroke, wide, high, rotate, alphaA);
      star(positionX[7][3].x, positionX[7][3].y, col1, stroke, wide, high, rotate, alphaA);
      //
      wide = 10+(func[1]*vizWidth);
      high = 110+(func[0]*vizHeight);
      if (beatCounter % 8 < 3) rotate = 60*func[1];
      else rotate = -60*func[1];
      star(positionX[7][0].x, positionX[7][0].y, col1, stroke, wide, high, rotate, alphaA);
      star(positionX[0][3].x, positionX[0][3].y, col1, stroke, wide, high, rotate, alphaA);
      window.endDraw();
      break;
    case 2:
      window.beginDraw();
      window.background(0);
      wide = 10+(functionA*vizWidth*1.5f);
      high = 10+(functionB*vizHeight*1.5f);
      stroke = 30+(60*functionA*noize1);
      rotate = 30;
      donut(positionX[1][1].x, viz.y, col1, stroke, wide, high, rotate, alphaA);
      rotate = -30;
      donut(positionX[6][1].x, viz.y, col1, stroke, wide, high, rotate, alphaA);
      window.endDraw();
      break;
    case 3:
      window.beginDraw();
      window.background(0);
      stroke = 300-(200*noize);
      wide = vizWidth/1.5f;
      high = wide;
      squareNut(position[1].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      squareNut(position[4].x, viz.y, col1, stroke, wide-(wide*functionA), high-(high*functionA), 0, alphaA);
      window.endDraw();
      break;
    case 4:
      window.beginDraw();
      window.background(0);
      stroke = 20+(200*oskP);
      wide = vizWidth/2;
      wide = wide-(wide*(1-functionA));
      high = wide;
      donut(viz.x, viz.y, col1, stroke, wide, high, -45, alphaA);
      window.endDraw();
      break;
    case 5:
      window.beginDraw();
      window.background(0);
      wide = 500+(noize*300);
      if   (beatCounter % 3 < 1) rush(position[0].x, viz.y, col1, wide, vizHeight, functionA, alphaA);
      else rush(position[0].x, viz.y, col1, wide, vizHeight, 1-functionA, alphaA);
      window.endDraw();
      break;
    case 6:
      window.beginDraw();
      window.background(0);
      //stroke = 20+(200*oskP);
      wide = vizWidth;
      wide = 50+wide-(wide*(1-functionA));
      high = wide;
      solidNut(viz.x, viz.y, col1, stroke, wide, high, -45, alphaA);
      window.endDraw();
      break;
    default:
      break;
    }
    blurPGraphics();
    //image(window, viz.x,viz.y);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// SQUARE NUT /////////////////////////////////////////////////////////////////////////////////////////////////
  public void squareNut(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
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
  public void donut(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.stroke(col, 360*alph);
    window.noFill();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }
  /////////////////////////////////// SOLIDNUT /////////////////////////////////////////////////////////////////////////////////////////////////
  public void solidNut(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
    window.strokeWeight(-stroke);
    window.fill(col, 360*alph);
    window.noStroke();
    window.pushMatrix();
    window.translate(xpos, ypos);
    window.rotate(radians(rotate));
    window.ellipse(0, 0, wide, high);
    window.popMatrix();
  }
  /////////////////////////////////// STAR ////////////////////////////////////////////////////////////////////////
  public void star(float xpos, float ypos, int col, float stroke, float wide, float high, float rotate, float alph) {
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
  /////////////////////////////////////// RUSH /////////////////////////////////////////////////////////
  public void rush(float xpos, float ypos, int col, float wide, float high, float func, float alph) {
    float moveA;
    float strt = xpos;
    moveA = (strt+(window.width)*func);
    window.imageMode(CENTER);
    window.tint(col, 360*alph);
    window.image(bar1, moveA, ypos, wide, high);
    window.noTint();
  }
  ////////////////////////////////////////////////////////////////////////////////////////
  public void blurPGraphics() {
    blur.set("blurSize", blury);
    blur.set("horizontalPass", 0);
    bluredA.beginDraw();            
    bluredA.shader(blur); 
    bluredA.imageMode(CENTER);
    bluredA.image(window, bluredA.width/2, bluredA.height/2);
    bluredA.endDraw();
    blur.set("horizontalPass", 1);
    bluredB.beginDraw();            
    bluredB.shader(blur);  
    bluredB.imageMode(CENTER);
    bluredB.image(bluredA, bluredB.width/2, bluredB.height/2);
    bluredB.endDraw();
    image(bluredB, viz.x, viz.y, window.width, window.height);
  }
  /////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
  public void alphaFunction() {
    //// array of functions
    func[0] = 1-function;         
    func[1] = function;        
    func[2] = 1-functionSlow; 
    func[3] = (functionSlow*0.99f)+(0.01f*stutter);
    func[4] = (0.99f*1-function)+(stutter*(1-function)*0.01f);       
    func[5] = (0.99f*functionSlow)+(stutter*(1-function)*0.01f);
    func[6] = 1-functionSlow;
    func[7] = functionSlow;
    //// array of alphas
    alph[0] = alpha;
    alph[1] = 1-alpha;
    alph[2] = alpha+(0.05f*stutter);
    alph[3] = (0.98f*alpha)+(stutter*(1-alpha)*0.02f);
    alph[4] = (0.98f*(1-alpha))+(alpha*0.02f*stutter);
    alph[5] = alphaFast;
    alph[6] = alphaSlow;
    for (int i = 0; i < alph.length; i++) alph[i] *=alphMod;
    for (int i = 0; i < func.length; i++) func[i] *=funcMod;
  }
  //////////////////////////////////// TRIGGER //////////////////////////////////////////////
  float alpha, alphaFast, alphaSlow;
  float function, functionFast, functionSlow;
  float deleteMeTimer;
  public void trigger() {
    alpha = 1;
    alphaFast = 1;
    alphaSlow = 1;
    function = 1;
    functionFast = 1;
    functionSlow = 1;
    deleteMeTimer = 1;
  }
  //////////////////////////////////////// DECAY ////////////////////////////////////////////////
  boolean deleteme=false;
  public void decay() {            
    if (avgtime>0) {
      alpha*=pow(alphaRate, (1/avgtime));       //  changes rate alpha fades out!!
      function*=pow(funcRate, (1/avgtime));     //  changes rate alpha fades out!!
      deleteMeTimer*=pow(deleteMeSlider, 1/avgtime); //lifetime
    } else {
      alpha*=0.95f*alphaRate;
      function*=0.95f*funcRate;
      deleteMeTimer*=0.98f*deleteMeSlider;
    }

    if (alpha < 0.8f) alpha *= 0.9f;
    if (function < 0.8f) function *= 0.9f;

    alphaFast *=0.7f;                 
    alphaSlow -= 0.05f;

    functionFast *=0.7f;  
    if (functionSlow < 0.4f) functionSlow *= 0.99f*noize1;
    else functionSlow -= 0.02f;

    float end = 0.001f;

    if (alpha < end) alpha = end+(shimmer*0.1f);
    if (alphaFast < end) alphaFast = end;
    if (alphaSlow < 0.4f+(noize1*0.2f)) alphaSlow = 0.4f+(noize1*0.2f);

    if (function < end) function = end;
    if (functionFast < end) functionFast = end;
    if (functionSlow < end)  functionSlow = end;

    if (deleteMeTimer < end) deleteme = true;
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean vizHold, colHold, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
public void keyPressed() {  

  //// debound or thorttle this ////

  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (key == 'n') rigViz = (rigViz+1)%rigVizList;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') rigViz -=1;                            //// STEP BACK TO PREVIOUS RIG VIZ
  if (rigViz <0) rigViz = rigVizList-1;
  if (key == 'm') rigBgr = (rigBgr+1)%rigBgList;                 //// CYCLE THROUGH RIG BACKGROUNDS

  /////////////////////////////// ROOF KEY FUNCTIONS ////////////////////////
  if (key == 'h') roofViz = (roofViz+1)%roofVizList;               //// STEP FORWARD TO NEXT RIG VIZ
  if (key == 'g') roofViz -= 1;                          //// STEP BACK TO PREVIOUS RIG VIZ
  if (roofViz <0) roofViz = roofVizList-1;
  if (key == 'j') roofBgr = (roofBgr+1)%roofBgList;               //// CYCLE THROUGH ROOF BACKGROUNDS

  if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
    rigFunctionIndexA = (rigFunctionIndexA+1)%funcLength; //animations.func.length; 
    rigFunctionIndexB = (rigFunctionIndexB+1)%funcLength; //fct.length;
  }  
  if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
    rigAlphaIndexA = (rigAlphaIndexA+1)% alphLength; //alph.length; 
    rigAlphaIndexB = (rigAlphaIndexB+1)% alphLength; //alph.length;
  }   
  if (key == 'k') {                                      //// CYCLE THROUGH ROOF FUNCS
    roofFunctionIndexA = (roofFunctionIndexA+1)%funcLength; 
    roofFunctionIndexB = (roofFunctionIndexB+1)%funcLength;
  }  
  if (key == 'l') {                                      //// CYCLE THROUGH ROOF ALPHAS
    roofAlphaIndexA = (roofAlphaIndexA+1)%alphLength; 
    roofAlphaIndexB = (roofAlphaIndexB+1)%alphLength;
  }   
  if (key == 'c') rigColor.colorA = (rigColor.colorA+1)%rigColor.col.length; //// CYCLE FORWARD THROUGH RIG COLORS
  if (key == 'v') rigColor.colorB = (rigColor.colorB+1)%rigColor.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS

  if (key == 'd') {
    roofColor.colorA = (roofColor.colorA+1)%roofColor.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
    cansColor.colorA = (cansColor.colorA+1)%cansColor.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  }
  if (key == 'f') {
    roofColor.colorB = (roofColor.colorB+1)%roofColor.col.length;      //// CYCLE BACKWARD THROUGH ROOF COLORS
    cansColor.colorB = (cansColor.colorB+1)%cansColor.col.length;      //// CYCLE BACKWARD THROUGH ROOF COLORS
  }
  if (key == '[') vizHold = !vizHold; 
  if (key == ']') colHold = !colHold; 

  /////////////////////////////////// momentaory key pressed array /////////////////////////////////////////////////
  for (int i = 32; i <=63; i++)  if (key == PApplet.parseChar(i)) keyP[i]=true;
  for (int i = 91; i <=127; i++) if (key == PApplet.parseChar(i)) keyP[i]=true;
  ///////////////////////////////// toggle key pressed array ///////////////////////////////////////////////////////
  for (int i = 32; i <=63; i++) {
    if (key == PApplet.parseChar(i)) keyT[i] = !keyT[i];
    if (key == PApplet.parseChar(i)) println(key, i, keyT[i]);
  }
  for (int i = 91; i <=127; i++) {
    if (key == PApplet.parseChar(i)) keyT[i] = !keyT[i];
    if (key == PApplet.parseChar(i)) println(key, i, keyT[i]);
  }
}

public void keyReleased()
{
  /// loop to change key[] to false when released to give hold control
  for (int i = 32; i <=63; i++) {
    char n = PApplet.parseChar(i);
    if (key == n) keyP[i]=false;
  }
  for (int i = 91; i <=127; i++) {
    char n = PApplet.parseChar(i);
    if (key == n) keyP[i]=false;
  }
} 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// MIDI FUNCTIONS /////////////////////////////////////////////////////////////////////
float pad[] = new float[128];                //// An array where to store the last value received for each midi Note controller
boolean padPressed[] = new boolean[128];
public void noteOn(Note note) {
  float velocity = map(note.velocity, 0, 127, 0, 1);
  pad[note.pitch] = velocity;
  padPressed[note.pitch] = true;
  println();
  println("PAD: "+note.pitch, "Velocity: "+velocity);
}
public void noteOff(Note note) {
  padPressed[note.pitch] = false;
}
float cc[] = new float[128];                   //// An array where to store the last value received for each CC controller
float prevcc[] = new float[128];
public void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println();
  println("CC: "+number, "Velocity: "+map(value, 0, 127, 0, 1), "Channel: "+channel);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
HashMap<String, int[]> oscAddrToMidiMap = new HashMap<String, int[]>();
public void oscAddrSetup() {

  int startVal = 64;
  OscAddrMap.put("/throttle_box/throttle_button_1", startVal);
  OscAddrMap.put("/throttle_box/throttle_button_2", startVal);
  OscAddrMap.put("/throttle_box/trackball_x", startVal);
  OscAddrMap.put("/throttle_box/trackball_y", startVal);
  OscAddrMap.put("/throttle_box/throttle", startVal);
  OscAddrMap.put("/throttle_box/knob_1", startVal);
  OscAddrMap.put("/throttle_box/knob_2", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/instrument/0/volume", startVal);
  OscAddrMap.put("/instrument/1/volume", startVal);
  OscAddrMap.put("/instrument/2/volume", startVal);
  OscAddrMap.put("/instrument/3/volume", startVal);
  OscAddrMap.put("/instrument/4/volume", startVal);
  OscAddrMap.put("/instrument/5/volume", startVal);
  OscAddrMap.put("/instrument/6/volume", startVal);
  OscAddrMap.put("/instrument/7/volume", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/tune", startVal);
  OscAddrMap.put("/knob_box/1/tune", startVal);
  OscAddrMap.put("/knob_box/2/tune", startVal);
  OscAddrMap.put("/knob_box/3/tune", startVal);
  OscAddrMap.put("/knob_box/4/tune", startVal);
  OscAddrMap.put("/knob_box/5/tune", startVal);
  OscAddrMap.put("/knob_box/6/tune", startVal);
  OscAddrMap.put("/knob_box/7/tune", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/decay", startVal);
  OscAddrMap.put("/knob_box/1/decay", startVal);
  OscAddrMap.put("/knob_box/2/decay", startVal);
  OscAddrMap.put("/knob_box/3/decay", startVal);
  OscAddrMap.put("/knob_box/4/decay", startVal);
  OscAddrMap.put("/knob_box/5/decay", startVal);
  OscAddrMap.put("/knob_box/6/decay", startVal);
  OscAddrMap.put("/knob_box/7/decay", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/ctrl", startVal);
  OscAddrMap.put("/knob_box/1/ctrl", startVal);
  OscAddrMap.put("/knob_box/2/ctrl", startVal);
  OscAddrMap.put("/knob_box/3/ctrl", startVal);
  OscAddrMap.put("/knob_box/4/ctrl", startVal);
  OscAddrMap.put("/knob_box/5/ctrl", startVal);
  OscAddrMap.put("/knob_box/6/ctrl", startVal);
  OscAddrMap.put("/knob_box/7/ctrl", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/joystick_1", 0);
  OscAddrMap.put("/knob_box/joystick_2", 0);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////
}
int oneshotmap, colorselected;
boolean buttonT[] = new boolean [16];
boolean oneshotmessage;
HashMap<String, Integer> OscAddrMap = new HashMap<String, Integer>();
public void oscEvent(OscMessage theOscMessage) {
  //split address into parts
  String addr[]=theOscMessage.addrPattern().split("/");
  String messageType=addr[addr.length-1];
  addr[addr.length-1]="";
  String address=String.join("/", addr);
  int argument = (int)theOscMessage.arguments()[0];

  if ( !(messageType.equals("throttle") || messageType.equals("throttle_button_2"))) {
    print("address = '"+address+"'");
    print(" mesgtype = '"+messageType+"'");
    println(" mesgArgument = "+argument);
  }
  OscAddrMap.put(theOscMessage.addrPattern(), argument);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int TR8CHANNEL = 9;
int BD = 0;
int SD = 1;
int LT = 2;
int MT = 3;
int HT = 4;
int RS = 5;
int HC = 6;
int CH = 7;

int BDTUNE = 20;
int BDDECAY = 23;
int BDLEVEL = 24;
int BDCTRL = 96;
int SDTUNE = 25;
int SDDECAY = 28;
int SDLEVEL = 29;
int SDCTRL = 102;
int LTTUNE = 46;
int LTDECAY = 47;
int LTLEVEL = 48;
int LTCTRL = 102;
int MTTUNE = 49;
int MTDECAY = 50;
int MTLEVEL = 51;
int MTCTRL = 103;
int HTTUNE = 52;
int HTDECAY = 53;
int HTLEVEL = 54;
int HTCTRL = 105;
int RSTUNE = 55;
int RSDECAY = 56;
int RSLEVEL = 57;
int RSCTRL = 105;
int HCTUNE = 58;
int HCDECAY = 59;
int HCLEVEL = 60;
int HCCTRL = 106;
int CHTUNE = 61;
int CHDECAY = 62;
int CHLEVEL = 63;
int CHCTRL = 107;

int DELAYLEVEL = 16;
int DELAYTIME = 17;
int DELAYFEEDBACK = 18;
int MASTERFXON = 15;
int MASTERFXLEVEL = 19;
int REVERBLEVEL = 91;
int NOTE_ON=ShortMessage.NOTE_ON;
int NOTE_OFF=ShortMessage.NOTE_OFF;
int PRGM_CHG=ShortMessage.PROGRAM_CHANGE;
int CTRL_CHG=ShortMessage.CONTROL_CHANGE;
int STOP=ShortMessage.STOP;
int START=ShortMessage.START;
int TIMING=ShortMessage.TIMING_CLOCK;
/*
 * Simple Open Pixel Control client for Processing,
 * designed to sample each LED's color from some point on the canvas.
 *
 * Micah Elizabeth Scott, 2013
 * This file is released into the public domain.
 */




public class OPC implements Runnable
{
  Thread thread;
  Socket socket;
  OutputStream output, pending;
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;

  OPC(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    thread = new Thread(this);
    thread.start();
    this.enableShowLocations = true;
    parent.registerMethod("draw", this);

  }

  // Set the location of a single LED
  public void led(int index, int x, int y)  
  {
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }
  
  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip.
  public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0f) * spacing * c + 0.5f),
        (int)(y + (i - (count-1)/2.0f) * spacing * s + 0.5f));
    }
  }

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
  public void ledRing(int index, int count, float x, float y, float radius, float angle)
  {
    for (int i = 0; i < count; i++) {
      float a = angle + i * 2 * PI / count;
      led(index + i, (int)(x - radius * cos(a) + 0.5f),
        (int)(y - radius * sin(a) + 0.5f));
    }
  }

  // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  public void ledGrid(int index, int stripLength, int numStrips, float x, float y,
               float ledSpacing, float stripSpacing, float angle, boolean zigzag)
  {
    float s = sin(angle + HALF_PI);
    float c = cos(angle + HALF_PI);
    for (int i = 0; i < numStrips; i++) {
      ledStrip(index + stripLength * i, stripLength,
        x + (i - (numStrips-1)/2.0f) * stripSpacing * c,
        y + (i - (numStrips-1)/2.0f) * stripSpacing * s, ledSpacing,
        angle, zigzag && (i % 2) == 1);
    }
  }

  // Set the location of 64 LEDs arranged in a uniform 8x8 grid.
  // (x,y) is the center of the grid.
  public void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag)
  {
    ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag);
  }

  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  public void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }
  
  // Enable or disable dithering. Dithering avoids the "stair-stepping" artifact and increases color
  // resolution by quickly jittering between adjacent 8-bit brightness levels about 400 times a second.
  // Dithering is on by default.
  public void setDithering(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x01;
    else
      firmwareConfig |= 0x01;
    sendFirmwareConfigPacket();
  }

  // Enable or disable frame interpolation. Interpolation automatically blends between consecutive frames
  // in hardware, and it does so with 16-bit per channel resolution. Combined with dithering, this helps make
  // fades very smooth. Interpolation is on by default.
  public void setInterpolation(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x02;
    else
      firmwareConfig |= 0x02;
    sendFirmwareConfigPacket();
  }

  // Put the Fadecandy onboard LED under automatic control. It blinks any time the firmware processes a packet.
  // This is the default configuration for the LED.
  public void statusLedAuto()
  {
    firmwareConfig &= 0x0C;
    sendFirmwareConfigPacket();
  }    

  // Manually turn the Fadecandy onboard LED on or off. This disables automatic LED control.
  public void setStatusLed(boolean on)
  {
    firmwareConfig |= 0x04;   // Manual LED control
    if (on)
      firmwareConfig |= 0x08;
    else
      firmwareConfig &= ~0x08;
    sendFirmwareConfigPacket();
  } 

  // Set the color correction parameters
  public void setColorCorrection(float gamma, float red, float green, float blue)
  {
    colorCorrection = "{ \"gamma\": " + gamma + ", \"whitepoint\": [" + red + "," + green + "," + blue + "]}";
    sendColorCorrectionPacket();
  }
  
  // Set custom color correction parameters from a string
  public void setColorCorrection(String s)
  {
    colorCorrection = s;
    sendColorCorrectionPacket();
  }

  // Send a packet with the current firmware configuration settings
  public void sendFirmwareConfigPacket()
  {
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }
 
    byte[] packet = new byte[9];
    packet[0] = 0;          // Channel (reserved)
    packet[1] = (byte)0xFF; // Command (System Exclusive)
    packet[2] = 0;          // Length high byte
    packet[3] = 5;          // Length low byte
    packet[4] = 0x00;       // System ID high byte
    packet[5] = 0x01;       // System ID low byte
    packet[6] = 0x00;       // Command ID high byte
    packet[7] = 0x02;       // Command ID low byte
    packet[8] = firmwareConfig;

    try {
      pending.write(packet);
    } catch (Exception e) {
      dispose();
    }
  }

  // Send a packet with the current color correction settings
  public void sendColorCorrectionPacket()
  {
    if (colorCorrection == null) {
      // No color correction defined
      return;
    }
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }

    byte[] content = colorCorrection.getBytes();
    int packetLen = content.length + 4;
    byte[] header = new byte[8];
    header[0] = 0;          // Channel (reserved)
    header[1] = (byte)0xFF; // Command (System Exclusive)
    header[2] = (byte)(packetLen >> 8);
    header[3] = (byte)(packetLen & 0xFF);
    header[4] = 0x00;       // System ID high byte
    header[5] = 0x01;       // System ID low byte
    header[6] = 0x00;       // Command ID high byte
    header[7] = 0x01;       // Command ID low byte

    try {
      pending.write(header);
      pending.write(content);
    } catch (Exception e) {
      dispose();
    }
  }

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  public void draw()
  {
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }
    if (output == null) {
      return;
    }

    int numPixels = pixelLocations.length;
    int ledAddress = 4;

    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];

      packetData[ledAddress] = (byte)(pixel >> 16);
      packetData[ledAddress + 1] = (byte)(pixel >> 8);
      packetData[ledAddress + 2] = (byte)pixel;
      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
  }
  
  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  public void setPixelCount(int numPixels)
  {
    int numBytes = 3 * numPixels;
    int packetLen = 4 + numBytes;
    if (packetData == null || packetData.length != packetLen) {
      // Set up our packet buffer
      packetData = new byte[packetLen];
      packetData[0] = 0;  // Channel
      packetData[1] = 0;  // Command (Set pixel colors)
      packetData[2] = (byte)(numBytes >> 8);
      packetData[3] = (byte)(numBytes & 0xFF);
    }
  }
  
  // Directly manipulate a pixel in the output buffer. This isn't needed
  // for pixels that are mapped to the screen.
  public void setPixel(int number, int c)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = (byte) (c >> 16);
    packetData[offset + 1] = (byte) (c >> 8);
    packetData[offset + 2] = (byte) c;
  }
  
  // Read a pixel from the output buffer. If the pixel was mapped to the display,
  // this returns the value we captured on the previous frame.
  public int getPixel(int number)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      return 0;
    }
    return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
  }

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  public void writePixels()
  {
    if (packetData == null || packetData.length == 0) {
      // No pixel buffer
      return;
    }
    if (output == null) {
      return;
    }

    try {
      output.write(packetData);
    } catch (Exception e) {
      dispose();
    }
  }

  public void dispose()
  {
    // Destroy the socket. Called internally when we've disconnected.
    // (Thread continues to run)
    if (output != null) {
      println("Disconnected from OPC server", host);
    }
    socket = null;
    output = pending = null;
  }

  public void run()
  {
    // Thread tests server connection periodically, attempts reconnection.
    // Important for OPC arrays; faster startup, client continues
    // to run smoothly when mobile servers go in and out of range.
    for(;;) {

      if(output == null) { // No OPC connection?
        try {              // Make one!
          socket = new Socket(host, port);
          socket.setTcpNoDelay(true);
          pending = socket.getOutputStream(); // Avoid race condition...
          println("Connected to OPC server", host);
          sendColorCorrectionPacket();        // These write to 'pending'
          sendFirmwareConfigPacket();         // rather than 'output' before
          output = pending;                   // rest of code given access.
          // pending not set null, more config packets are OK!
        } catch (ConnectException e) {
          dispose();
        } catch (IOException e) {
          dispose();
        }
      }

      // Pause thread to avoid massive CPU load
      try {
        thread.sleep(500);
      }
      catch(InterruptedException e) {
      }
    }
  }
}
class OPCGrid {
  PVector[] mirror = new PVector[12];
  PVector[][] mirrorX = new PVector[7][4];
  PVector[] _mirror = new PVector[12];
  PVector[] seed = new PVector[3];
  PVector[] cans = new PVector[3];
  PVector[] roof = new PVector[18];
  PVector[] controller = new PVector[4];
  PVector booth, dig, uv, lightbox;

  int pd, ld, dist, controllerGridStep, rows, columns;
  float mirrorAndGap, seedLength, _seedLength, seed2Length, _seed2Length, cansLength, _cansLength, _mirrorWidth, mirrorWidth, controllerWidth;

  OPCGrid () {
    pd = 6;             // distance between pixels
    ld = 16;            // number of leds per strip
    dist = 16*3;          // distance between mirrors;
    _mirrorWidth = ld*pd;
    mirrorAndGap = (pd*ld)+dist;

    switch (size.orientation) {
    case PORTRAIT:
      float yTop = size.rig.y - mirrorAndGap;                              // height Valuve for top line of mirrors
      float yBottom = size.rig.y + mirrorAndGap;  
      float yMid = size.rig.y;   
      rows = 3;
      columns = 4;
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-(mirrorAndGap*rows/2));
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-(mirrorAndGap/2));                   /// PVECTORS for MIDDLE GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+(mirrorAndGap/2));  /// PVECTORS for BOTTOM GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][3] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+(mirrorAndGap*rows/2));    /// PVECTORS for TOP GAPS 0-6
      // panel 1
      _mirror[0] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[1] = new PVector (size.rig.x-(mirrorAndGap/2), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[2] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[3] = new PVector (size.rig.x-(mirrorAndGap/2), yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[4] = new PVector (size.rig.x-(mirrorAndGap/2), yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[5] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yBottom);                       /// PVECTORS for CENTER of MIRRORS 0-2
      // panel 2
      _mirror[6] =  new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[7] =  new PVector (size.rig.x+(mirrorAndGap/2), yBottom);                    /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[8] =  new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yMid);                   /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[9] =  new PVector (size.rig.x+(mirrorAndGap/2), yMid);                       /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[10] = new PVector (size.rig.x+(mirrorAndGap/2), yTop);                     /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[11] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yTop);                   /// PVECTORS for CENTER of MIRRORS 0-2
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////// PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE /////////////////////////////////////////////////////
      mirror[0] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yTop);                  
      mirror[1] = new PVector (size.rig.x-(mirrorAndGap/2), yTop);                  
      mirror[2] = new PVector (size.rig.x+(mirrorAndGap/2), yTop);                  
      mirror[3] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yTop);                 
      mirror[4] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yMid);                   
      mirror[5] = new PVector (size.rig.x-(mirrorAndGap/2), yMid);                
      mirror[6] = new PVector (size.rig.x+(mirrorAndGap/2), yMid);                  
      mirror[7] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yMid);                    
      mirror[8] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yBottom);                  
      mirror[9] = new PVector (size.rig.x-(mirrorAndGap/2), yBottom);                 
      mirror[10]= new PVector (size.rig.x+(mirrorAndGap/2), yBottom);                  
      mirror[11]= new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yBottom); 
      break;
    case LANDSCAPE: 
      yTop = size.rig.y - (mirrorAndGap/2);                              // height Valuve for top line of mirrors
      yBottom = size.rig.y + (mirrorAndGap/2);  
      rows = 2;
      columns = 6;
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-mirrorAndGap);    /// PVECTORS for TOP GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y);                   /// PVECTORS for MIDDLE GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+mirrorAndGap);    /// PVECTORS for BOTTOM GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][3] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y);    /// PVECTORS for TOP GAPS 0-6
      // panel 1
      _mirror[0] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[1] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[2] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[3] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[4] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[5] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      // panel 2
      _mirror[6] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[7] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[8] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[9] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[10] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[11] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////// PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE /////////////////////////////////////////////////////
      mirror[0] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yTop);                  
      mirror[1] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yTop);                  
      mirror[2] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yTop);                  
      mirror[3] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yTop);                
      mirror[4] = new PVector (size.rig.x+(mirrorAndGap*1.5f), yTop);                   
      mirror[5] = new PVector (size.rig.x+(mirrorAndGap*2.5f), yTop);                
      mirror[6] = new PVector (size.rig.x-(mirrorAndGap*2.5f), yBottom);                   
      mirror[7] = new PVector (size.rig.x-(mirrorAndGap*1.5f), yBottom);                   
      mirror[8] = new PVector (size.rig.x-(mirrorAndGap*0.5f), yBottom);                  
      mirror[9] = new PVector (size.rig.x+(mirrorAndGap*0.5f), yBottom);                 
      mirror[10]= new PVector (size.rig.x+(mirrorAndGap*1.5f), yBottom);                  
      mirror[11]= new PVector (size.rig.x+(mirrorAndGap*2.5f), yBottom);
      break;
    }
    mirrorWidth = _mirrorWidth+16;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// CANS POSTIONS ///////////////////////////////////////////////////////////////
    _cansLength = size.cansWidth;
    cans[0] = new PVector(size.cans.x, size.cans.y-(size.cansHeight/4));
    cans[1] = new PVector(size.cans.x, size.cans.y);
    cans[2] = new PVector(size.cans.x, size.cans.y+(size.cansHeight/4));
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// ROOF POSITION /////////////////////////////////////////////////////////////////////
    float xw = 6;
    for (int i=0; i<roof.length/6; i++) roof[i] =     new PVector (size.roof.x-(size.roofWidth/2)+size.roofWidth/(roof.length/xw+1)*(i+1), size.roofHeight/7*1);
    for (int i=0; i<roof.length/6; i++) roof[i+3] =   new PVector (size.roof.x-(size.roofWidth/2)+size.roofWidth/(roof.length/xw+1)*(i+1), size.roofHeight/7*2);
    for (int i=0; i<roof.length/6; i++) roof[i+6] =   new PVector (size.roof.x-(size.roofWidth/2)+size.roofWidth/(roof.length/xw+1)*(i+1), size.roofHeight/7*3);
    for (int i=0; i<roof.length/6; i++) roof[i+9] =   new PVector (size.roof.x-(size.roofWidth/2)+size.roofWidth/(roof.length/xw+1)*(i+1), size.roofHeight/7*4);
    for (int i=0; i<roof.length/6; i++) roof[i+12] =  new PVector (size.roof.x-(size.roofWidth/2)+size.roofWidth/(roof.length/xw+1)*(i+1), size.roofHeight/7*5);
    for (int i=0; i<roof.length/6; i++) roof[i+15] =  new PVector (size.roof.x-(size.roofWidth/2)+size.roofWidth/(roof.length/xw+1)*(i+1), size.roofHeight/7*6);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    lightbox = new PVector(size.rig.x, size.rig.y);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    booth = new PVector (width - 30, 110);
    dig = new PVector (width - 30, 125);
  }

  public void lightboxOPC(OPC opc) {
    float xpos = lightbox.x;
    float ypos = lightbox.y;
    pd = size.rigWidth/20;
    int fc = 0*512;

    opc.ledStrip(fc+484, 18, xpos+(pd/4), ypos-(pd/2*12-pd/4), pd, 0, true);
    opc.ledStrip(fc+466, 18, xpos-(pd/4), ypos-(pd/2*11-pd/4), pd, 0, false);
    opc.ledStrip(fc+448, 18, xpos+(pd/4), ypos-(pd/2*10-pd/4), pd, 0, true);
    // FC hole 2
    opc.ledStrip(fc+420, 18, xpos-(pd/4), ypos-(pd/2*9-pd/4), pd, 0, true);
    opc.ledStrip(fc+402, 18, xpos+(pd/4), ypos-(pd/2*8-pd/4), pd, 0, false);
    opc.ledStrip(fc+384, 18, xpos-(pd/4), ypos-(pd/2*7-pd/4), pd, 0, true);
    // FC hole 3
    opc.ledStrip(fc+356, 18, xpos+(pd/4), ypos-(pd/2*6-pd/4), pd, 0, true);
    opc.ledStrip(fc+338, 18, xpos-(pd/4), ypos-(pd/2*5-pd/4), pd, 0, false);
    opc.ledStrip(fc+320, 18, xpos+(pd/4), ypos-(pd/2*4-pd/4), pd, 0, true);
    // FC hole 4
    opc.ledStrip(fc+292, 18, xpos-(pd/4), ypos-(pd/2*3-pd/4), pd, 0, true);
    opc.ledStrip(fc+274, 18, xpos+(pd/4), ypos-(pd/2*2-pd/4), pd, 0, false);
    opc.ledStrip(fc+256, 18, xpos-(pd/4), ypos-(pd/2*1-pd/4), pd, 0, true);
    // FC hole 5
    opc.ledStrip(fc+228, 18, xpos+(pd/4), ypos+(pd/2*1-pd/4), pd, 0, true);
    opc.ledStrip(fc+210, 18, xpos-(pd/4), ypos+(pd/2*2-pd/4), pd, 0, false);
    opc.ledStrip(fc+192, 18, xpos+(pd/4), ypos+(pd/2*3-pd/4), pd, 0, true);
    // FC hole 6
    opc.ledStrip(fc+164, 18, xpos-(pd/4), ypos+(pd/2*4-pd/4), pd, 0, true);
    opc.ledStrip(fc+146, 18, xpos+(pd/4), ypos+(pd/2*5-pd/4), pd, 0, false);
    opc.ledStrip(fc+128, 18, xpos-(pd/4), ypos+(pd/2*6-pd/4), pd, 0, true);
    // FC hole 7
    opc.ledStrip(fc+100, 18, xpos+(pd/4), ypos+(pd/2*7-pd/4), pd, 0, true);
    opc.ledStrip(fc+82, 18, xpos-(pd/4), ypos+(pd/2*8-pd/4), pd, 0, false);
    opc.ledStrip(fc+64, 18, xpos+(pd/4), ypos+(pd/2*9-pd/4), pd, 0, true); 
    // FC hole 8
    opc.ledStrip(fc+36, 18, xpos-(pd/4), ypos+(pd/2*10-pd/4), pd, 0, true);
    opc.ledStrip(fc+18, 18, xpos+(pd/4), ypos+(pd/2*11-pd/4), pd, 0, false);
    opc.ledStrip(fc+00, 18, xpos-(pd/4), ypos+(pd/2*12-pd/4), pd, 0, true);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// MIRRORS //////////////////////////////////////////////
  public void mirrorsOPC(OPC opc, OPC opc1, int gridStep) {
    switch (size.orientation) {  
    case PORTRAIT:
      switch(gridStep) {
      case 0:
        for (int i = 0; i < 6; i++) {       /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
          opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
          opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
        }
        for (int i = 6; i < 12; i++) {       /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
          opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
          opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
        }
        break;
      case 1:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8f, 0, true);                 
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8f, 0, false);
        break;
      case 2:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, size.rig.x-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6f)), size.rig.y, size.rigHeight/64, PI/2, true);                 
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, size.rig.x-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6f)), size.rig.y, size.rigHeight/64, PI/2, false);
        break;
      default:
        for (int i = 0; i < 6; i++) {       /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
          opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
          opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
        }
        for (int i = 6; i < 12; i++) {       /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
          opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
          opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
        }
        break;
      }
      break;
    case LANDSCAPE:
      switch(gridStep) {
      case 0:    /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 0; i < 6; i++) {
          opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);                 // TOP horizontal strip 
          opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
          opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
        }
        /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 6; i < 12; i++) {
          opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip 
          opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip       
          opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
        }
        break;
      case 1:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[2].x, 50+((size.rigHeight-55)/6*i), pd/1.2f, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[8].x, 50+((size.rigHeight-55)/6*(i-6)), pd/1.2f, 0, true);                 // TOP horizontal strip
        break;
      case 2:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.6f, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.6f, 0, true);
        break;
      case 3:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, size.rig.x, 48+((size.rigHeight-55)/12*i), pd*1.8f, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, size.rig.x, 52+((size.rigHeight-55)/12*(i)), pd*1.8f, 0, true);                 // TOP horizontal strip
        break;
      }
      break;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// SEEDS ///////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// CANS //////////////////////////////////////////////////
  public void kallidaCans(OPC opc) {
    int fc = 5 * 512;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, PApplet.parseInt(cans[0].x), PApplet.parseInt(cans[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1)+(64*channel), leds, PApplet.parseInt(cans[1].x), PApplet.parseInt(cans[1].y), pd, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX ///////
    cansLength = _cansLength - (pd/2);
  }
  public void pickleCansOPC(OPC opc) {
    int fc = 2 * 512;
    int channel = 64;
    int leds = 6;
    pd = PApplet.parseInt(_cansLength/6);
    opc.ledStrip(fc+(channel*5), leds, PApplet.parseInt(cans[0].x), PApplet.parseInt(cans[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*6), leds, PApplet.parseInt(cans[1].x), PApplet.parseInt(cans[1].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*7), leds, PApplet.parseInt(cans[2].x), PApplet.parseInt(cans[2].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 

    cansLength = _cansLength - (pd/2);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// UV /////////////////////////////////////////////////////
  public void kallidaUV(OPC opc) {
    int fc = 2 * 512;
    int channel = 64;                 
    opc.led(fc+(channel*7), PApplet.parseInt(uv.x), PApplet.parseInt(uv.y));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// CONTROL PANNLS ////////////////////////////////////////

  //////////// check which controllers are which here when setting up
  // left to right should be 0 - 3;

  public void kallidaControllers(OPC opc, OPC opc2, int controllerGridStep) {
    int fc = 3 * 512;                 // fadecandy number (first one used is 0)
    int channel = 64;                 // pair of holes on fadecandy board
    int leds = 23;                    // leds in strip
    int pd = 3;                       // distance between pixels
    controllerWidth = pd*leds+8;
    switch(controllerGridStep) {
    case 0:
      controller[0] = new PVector(mirror[0].x, mirror[0].y);
      controller[1] = new PVector(mirror[5].x, mirror[5].y);
      controller[2] = new PVector(mirror[6].x, mirror[6].y);
      controller[3] = new PVector(mirror[3].x, mirror[3].y);
      break;
    case 1:
      controller[0] = new PVector(mirror[1].x, mirror[1].y);
      controller[1] = new PVector(mirror[2].x, mirror[2].y);
      controller[2] = new PVector(mirror[9].x, mirror[9].y);
      controller[3] = new PVector(mirror[10].x, mirror[10].y);
      break;
    case 2:
      controller[0] = new PVector(mirror[4].x, mirror[4].y);
      controller[1] = new PVector(mirror[5].x, mirror[5].y);
      controller[2] = new PVector(mirror[6].x, mirror[6].y);
      controller[3] = new PVector(mirror[7].x, mirror[7].y);
      break;
    case 3:
      controller[0] = new PVector(mirror[8].x, mirror[8].y+_mirrorWidth+(dist/3));
      controller[1] = new PVector(mirror[9].x, mirror[9].y+_mirrorWidth+(dist/3));
      controller[2] = new PVector(mirror[10].x, mirror[10].y+_mirrorWidth+(dist/3));
      controller[3] = new PVector(mirror[11].x, mirror[11].y+_mirrorWidth+(dist/3));
      break;
    case 4:
      controller[0] = new PVector(mirror[0].x, mirror[0].y);
      controller[1] = new PVector(mirror[8].x, mirror[8].y);
      controller[2] = new PVector(mirror[3].x, mirror[3].y);
      controller[3] = new PVector(mirror[11].x, mirror[11].y);
      break;
    default:
      controller[0] = new PVector(mirror[0].x, mirror[0].y);
      controller[1] = new PVector(mirror[5].x, mirror[5].y);
      controller[2] = new PVector(mirror[6].x, mirror[6].y);
      controller[3] = new PVector(mirror[3].x, mirror[3].y);
      break;
    }
    /////////////////////////////////// CONTROLLER A 1 ///////////////////////////////
    fc = 3 * 512;   
    opc.ledStrip(fc+(channel*0), 23, controller[0].x-(leds/2*pd+(pd/2)), controller[0].y, pd, PI/2, true);
    opc.ledStrip(fc+(channel*0)+leds, 23, controller[0].x, controller[0].y-+(leds/2*pd+(pd/2)), pd, 0, false);
    opc.ledStrip(fc+(channel*1), 23, controller[0].x+(leds/2*pd+(pd/2)), controller[0].y, pd, PI/2, false);
    opc.ledStrip(fc+(channel*1)+leds, 23, controller[0].x, controller[0].y+(leds/2*pd+(pd/2)), pd, 0, true);
    /////////////////////////////////// CONTROLLER A 2 ///////////////////////////////
    opc.ledStrip(fc+(channel*2), 23, controller[1].x-(leds/2*pd+(pd/2)), controller[1].y, pd, PI/2, true);
    opc.ledStrip(fc+(channel*2)+leds, 23, controller[1].x, controller[1].y-+(leds/2*pd+(pd/2)), pd, 0, false);
    opc.ledStrip(fc+(channel*3), 23, controller[1].x+(leds/2*pd+(pd/2)), controller[1].y, pd, PI/2, false);
    opc.ledStrip(fc+(channel*3)+leds, 23, controller[1].x, controller[1].y+(leds/2*pd+(pd/2)), pd, 0, true);
    /////////////////////////////////// CONTROLLER B 1 ///////////////////////////////
    //fc = 3 * 512;            
    opc2.ledStrip(fc+(channel*4), 23, controller[2].x-(leds/2*pd+(pd/2)), controller[2].y, pd, PI/2, true);
    opc2.ledStrip(fc+(channel*4)+leds, 23, controller[2].x, controller[2].y-(leds/2*pd+(pd/2)), pd, 0, false);
    opc2.ledStrip(fc+(channel*5), 23, controller[2].x+(leds/2*pd+(pd/2)), controller[2].y, pd, PI/2, false);
    opc2.ledStrip(fc+(channel*5)+leds, 23, controller[2].x, controller[2].y+(leds/2*pd+(pd/2)), pd, 0, true);
    /////////////////////////////////// CONTROLLER B 2 ///////////////////////////////
    opc2.ledStrip(fc+(channel*6), 23, controller[3].x+(leds/2*pd+(pd/2)), controller[3].y, pd, PI/2, false);
    opc2.ledStrip(fc+(channel*6)+leds, 23, controller[3].x, controller[3].y+(leds/2*pd+(pd/2)), pd, 0, true);
    opc2.ledStrip(fc+(channel*7), 23, controller[3].x-(leds/2*pd+(pd/2)), controller[3].y, pd, PI/2, true);
    opc2.ledStrip(fc+(channel*7)+leds, 23, controller[3].x, controller[3].y-(leds/2*pd+(pd/2)), pd, 0, false);
  }
  public void mirrorTest(boolean toggle, int mirrorStep) {
    /////////////////////////// TESTING MIRROR ORENTATION //////////////////
    if (toggle) {
      fill(0);
      rect(mirror[mirrorStep].x+(mirrorWidth/2), mirror[mirrorStep].y+(mirrorWidth/4), 3, mirrorWidth/2);
      rect(mirror[mirrorStep].x-(mirrorWidth/2), mirror[mirrorStep].y-(mirrorWidth/4), 3, mirrorWidth/2);
      fill(200);
      rect(mirror[mirrorStep].x+(mirrorWidth/4), mirror[mirrorStep].y+(mirrorWidth/2), mirrorWidth/2, 3);
      rect(mirror[mirrorStep].x-(mirrorWidth/4), mirror[mirrorStep].y-(mirrorWidth/2), mirrorWidth/2, 3);
      println("TESTING: "+mirrorStep);
    }
  }

  public void pickleBoothOPC(OPC opc) {
    int fc = 2 * 512;
    int channel = 64;       

    opc.led(fc+(channel*0), PApplet.parseInt(dig.x-5), PApplet.parseInt(dig.y));
    opc.led(fc+(channel*1), PApplet.parseInt(dig.x+5), PApplet.parseInt(dig.y));

    opc.led(fc+(channel*2), PApplet.parseInt(booth.x-5), PApplet.parseInt(booth.y));
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//possible helper class
//class GridCoords{
//int arg1
//int arg2
//float arg3
//int xpos
//int ypos
//int pd.
// etc....
//GridCoords(_arg1,_arg2...){
//init all of them
//}
//}
//then use it like a c struct sorry if that doesn't make it make mor sense
//gridargs=new GridCoords(foo,bar,baz);
//opc.ledStrip(gridargs);
//gridargs.arg1=foo2;
//opc.ledStrip(gridargs);
public void playWithMe() {
  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
  if (keyP['o']) rigColor.colorSwap(0.9999999999f);               // COLOR SWAP MOMENTARY 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyT['i']) rigColor.colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
  if (keyP['u']) rigColor.colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////////////////////////////////
  if (keyT['y']) {
    colorLerping(rigColor, (1-beat)*2);
    colorLerping(roofColor, (1-beat)*1.5f);
  }
  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR /////////////////////////////////
  if (vizHold) vizTimer = millis()/1000;              // hold viz change timer
  if (colHold) {
    rigColor.colorTimer = millis()/1000;              // hold color change timer
    roofColor.colorTimer = millis()/1000;              // hold color change timer
    cansColor.colorTimer = millis()/1000;              // hold color change timer
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (keyP[' ']) animations.add(new Anim(rigViz, alphaSlider, funcSlider, rigDimmer));         // or space bar!
  //if (keyP[' ']) animations.add(new RoofAnim(roofViz, alphaSlider, funcSlider, roofDimmer));   // or space bar!
  //if (keyP[' ']) animations.add(new CansAnim(roofViz, alphaSlider, funcSlider, roofDimmer));   // or space bar!

  if (keyP['a']) animations.add(new RoofOn(manualSlider, stutter, rigDimmer));
  if (keyP['s']) {
    animations.add(new RoofOn(manualSlider, stutter, rigDimmer));
    rigColor.colorFlip(true);
  }
  if (keyP['z'] ) animations.add(new MirrorsOn(manualSlider, stutter, rigDimmer));
  if (keyP['`'] ) { 
    animations.add(new MirrorsOn(manualSlider, stutter, roofDimmer));
    roofColor.colorFlip(true);
  }
  float alphaRate = cc[1];
  float funcRate = cc[2];

  if (cc[101] > 0) animations.add(new Anim(rigViz, alphaRate, funcRate, cc[101])); // current animation
  if (cc[102] > 0) animations.add(new Anim(9, alphaRate, funcRate, cc[102])); // current animation
  if (cc[103] > 0) { 
    rigColor.colorSwap(0.9999999999f);                // COLOR SWAP MOMENTARY
    roofColor.colorSwap(0.9999999999f);
  }
  if (cc[104] > 0) {
    animations.add(new MirrorsOn(manualSlider, 1-(stutter*stutterSlider), cc[104]));
    rigColor.colorFlip(true);
  }
  if (cc[107] > 0) animations.add(new RoofOn(manualSlider, 1-(stutter*stutterSlider), cc[107]));
  if (cc[108] > 0) { 
    animations.add(new CansOn(manualSlider, 1-(stutter*stutterSlider), cc[108]));
    cansColor.colorFlip(true);
  }

  for (int i = 0; i < 8; i++) if (padPressed[101+i]) animations.add(new Anim(i, alphaRate, funcRate, pad[101+i])); // use pad buttons to play differnt viz
  for (int i = 0; i<8; i++) if (keyP[49+i]) animations.add(new Anim(i, manualSlider, funcSlider, rigDimmer));       // use number buttons to play differnt viz
  if (keyP[48]) animations.add(new MirrorsOn(manualSlider, 1, rigDimmer));                                             // '0' triggers all on for the rig
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
public void playWithMeMore() {
  /////background noise over whole window/////
  if (cc[105] > 0) {
    rigBuffer.colorLayer.beginDraw();
    rigBuffer.colorLayer.background(0, 0, 0, 0);
    rigBuffer.colorLayer.endDraw();
    bgNoise(rigBuffer.colorLayer, rigColor.flash, map(cc[105], 0, 1, 0.2f, 1), cc[5]);   //PGraphics layer,color,alpha
    image(rigBuffer.colorLayer, size.rigWidth/2, size.rigHeight/2);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void cansControl(int col, float alpha) {
  fill(col, 360*alpha);
  rect(grid.cans[0].x, grid.cans[0].y, grid.cansLength, 3);
  rect(grid.cans[1].x, grid.cans[1].y, grid.cansLength, 3);
}
public void rigControl(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke( col, 360*alpha);
  for (int i  = 0; i < grid.mirror.length; i++) rect(grid.mirror[i].x, grid.mirror[i].y, grid._mirrorWidth, grid._mirrorWidth);
  noStroke();
}
public void seedsControlA(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(grid.seed[0].x, grid.seed[0].y, grid.seedLength, 3);
  noStroke();
}
public void seedsControlB(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(grid.seed[1].x, grid.seed[1].y, grid.seedLength, 3);
  noStroke();
}
public void seedsControlC(int col, float alpha) {
  noFill();
  strokeWeight(5);
  stroke(col, 360*alpha);  
  rect(grid.seed[2].x, grid.seed[2].y, 3, grid.seed2Length);
  noStroke();
}
public void controllerControl(int col, float alpha) {
  fill(col, 360*alpha);
  rect(grid.controller[0].x, grid.controller[0].y, grid.controllerWidth, grid.controllerWidth);
  rect(grid.controller[1].x, grid.controller[1].y, grid.controllerWidth, grid.controllerWidth);
  rect(grid.controller[2].x, grid.controller[2].y, grid.controllerWidth, grid.controllerWidth);
  rect(grid.controller[3].x, grid.controller[3].y, grid.controllerWidth, grid.controllerWidth);
}
int rigAlphaIndexA, rigAlphaIndexB = 1, rigFunctionIndexA, rigFunctionIndexB = 1;
int rigVizList = 7, roofVizList = 11, alphLength = 7, funcLength = 8;
int roofAlphaIndexA, roofAlphaIndexB = 1, roofFunctionIndexA, roofFunctionIndexB = 1;
float alf;
int vizTimer, alphaTimer, functionTimer;
public void playWithYourself(float vizTm) {
  ///////////////// VIZ TIMER /////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - vizTimer >= vizTm) {
    rigViz = PApplet.parseInt(random(rigVizList));
    roofViz = PApplet.parseInt(random(roofVizList));
    alf = 0; ////// set new viz to 0 to fade up viz /////
    println("VIZ:", rigViz, "@", (hour()+":"+minute()+":"+second()));
    vizTimer = millis()/1000;
  }
  float divide = 4; ///////// NUMBER OF TIMES ALPHA CHANGES PER VIZ
  ///////////// ALPHA TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - alphaTimer >= vizTm/divide) { ///// alpha timer changes 4 times every viz change /////
    rigAlphaIndexA = PApplet.parseInt(random(alphLength));  //// select from alpha array
    rigAlphaIndexB = PApplet.parseInt(random(alphLength)); //// select from alpha array
    roofAlphaIndexA = PApplet.parseInt(random(alphLength));  //// select from alpha array
    roofAlphaIndexB = PApplet.parseInt(random(alphLength)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", rigAlphaIndexA, "new af1:", rigAlphaIndexB);
    alphaTimer = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (millis()/1000 - functionTimer >= vizTm/divide) {    ////// change function n times for every state change
    rigFunctionIndexA = PApplet.parseInt(random(funcLength));  //// select from function array
    rigFunctionIndexB = PApplet.parseInt(random(funcLength));  //// select from function array
    roofFunctionIndexA = PApplet.parseInt(random(funcLength));  //// select from function array
    roofFunctionIndexB = PApplet.parseInt(random(funcLength));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", rigFunctionIndexA, "new fc1:", rigFunctionIndexB);
    functionTimer = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ //////////////////////////////////////////////////////////////////////////
  if (alf < 1)  alf += 0.05f;
  if (alf > 1) alf = 1;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// PLAY WITH COLOUR ////////////////////////////////////////////////////////////////
  colTime = 60*2;
  rigColor.colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours
  //roofColor.colorTimer(colTime/1.5, 2); //// seconds between colour change, number of steps to cycle through colours
  //cansColor.colorTimer(colTime/2, 2); //// seconds between colour change, number of steps to cycle through colours
 
  if (millis()/1000*60 == 0) rigBgr = (rigBgr + 1) % rigBgList;               // change colour layer automatically

  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  ///////////////////////////////////// COLORSWAP TIMER /////////////////////////////////////////////////////////////////
  if (colorSwapSlider > 0) {
    rigColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    roofColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
    cansColor.colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  }
  if (beatCounter%64<2) rigColor.colorSwap(1000000*noize);  
  if (beatCounter%82>79) roofColor.colorSwap(1000000*noize);
  if (beatCounter%64>61) cansColor.colorSwap(1000000*noize);

  ////////////////////////////////////////// COLOR FLIP ///////////////////////////////////////////////////////////////////
  for (int i = 16; i<22; i+=2) if ( beatCounter % 128 == i) rigColor.colFlip = true;
  else rigColor.colFlip = false;
  for (int i = 11; i<19; i+=2) if ( beatCounter % 128 == i) roofColor.colFlip = true;
  else roofColor.colFlip = false;

  rigColor.colorFlip(rigColor.colFlip);
  roofColor.colorFlip(roofColor.colFlip);
  cansColor.colorFlip(cansColor.colFlip);

  ///////////////////////////////////////// LERP COLOUR //////////////////////////////////////////////////////////////////
  if (beatCounter % 64 > 60)  colorLerping(rigColor, (1-beat)*2);
  if (beatCounter % 96 > 90)  colorLerping(roofColor, (1-beat)*1.5f);
  if (beatCounter % 32 > 28)  colorLerping(cansColor, (1-beat)*1.5f);

  colBeat = false;
  //rigColor.c = lerpColor(rigColor.col[rigColor.colorB], rigColor.col[rigColor.colorA], beatFast);
  //rigColor.flash = lerpColor(rigColor.col[rigColor.colorA], rigColor.col[rigColor.colorB], beatFast);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

public void colorLerping(SketchColor object, float function) {
  object.c = lerpColor(object.col[object.colorB], object.col[object.colorA], function);
  object.flash = lerpColor(object.col[object.colorA], object.col[object.colorB], function);
  colBeat = true;
}
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
int rigBgList = 7, roofBgList = 6;
class ColorLayer extends SketchColor {
  PGraphics window;
  int col1, col2;
  PVector layer;
  int bgIndex;

  ColorLayer(int _bgIndex) {
    window = rigBuffer.colorLayer;
    layer = size.rig;
    col1 = rigColor.c;
    col2 = rigColor.flash;
    bgIndex =_bgIndex;
  }
  public void drawColorLayer() {
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
      mirrorGradient(col1, col2, 0.5f);
      window.endDraw();
      break;
    case 2:
      window.beginDraw();
      window.background(0);
      mirrorGradient(col2, col1, noize);
      window.endDraw();
      break;
    case 3:
      window.beginDraw();
      window.background(0);
      horizontalMirrorGradient(col1, col2, 1);
      window.endDraw();
      break;
    case 4:
      window.beginDraw();
      window.background(0);
      dubsonLogo(col2, col1, 0);
      window.endDraw();
      break;
    case 5:
      window.beginDraw();
      window.background(0);
      radialGradient(col1, col2, 0.3f+noize1);
      window.endDraw();
      break;
    case 6:
      window.beginDraw();
      window.background(0);
      dubsonLogo(col1, col2, noize1);
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
  //////////////////////////////////////// END OF BACKGROUND CONTROL /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void dubsonLogo(int col1, int col2, float func) {
    window.background(col2);
    window.fill(col1);
    window.ellipse(window.width/2, window.height/2, window.width/2*(func*1.2f+1), window.width/2.2f*(func*1.2f+1));
  }

  /////////////////////////////////// RADIAL GRADIENT BACKGROUND //////////////////////////////////////////////////////////
  public void radialGradient(int col1, int col2, float function) {
    window.background(col1);
    float radius = window.height*function;
    int numPoints = 12;
    float angle=360/numPoints;
    float rotate = 90+(function*angle);
    for (  int i = 0; i < numPoints; i++) {
      window.beginShape(POLYGON); 
      window.fill(col1);
      window.vertex(cos(radians((i)*angle+rotate))*radius+window.width/2, sin(radians((i)*angle+rotate))*radius+window.height/2);
      window.fill(col2);
      window.vertex(window.width/2, window.height/2);
      window.fill(col1);
      window.vertex(cos(radians((i+1)*angle+rotate))*radius+window.width/2, sin(radians((i+1)*angle+rotate))*radius+window.height/2);
      window.endShape(CLOSE);
    }
  }
  /////////////////////////////////// VERTICAL MIRROR GRADIENT BACKGROUND ////////////////////////////////////////////////
  public void mirrorGradient(int col1, int col2, float func) {
    //// LEFT SIDE OF GRADIENT
    window.beginShape(POLYGON); 
    //window.noStroke();
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
  /// MIRROR GRADIENT BACKGROUND top one direction - bottom opposite direction ///
  public void mirrorGradientHalfHalf(int col1, int col2, float func) {
    //////// TOP //// LEFT SIDE OF GRADIENT
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
    //////////////////////////////////
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
  /////////////////////////////////////////////////// HORIZONAL GRADIENT ///////////////////////////////////////////////////////
  public void horizontalMirrorGradient(int col1, int col2, float func) {
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
  ///////////////////////////////////////// ONE COLOUR BACKGOUND ////////////////////////////////////////////////////////////////
  public void oneColour(int col1) {
    window.background(col1);
  }
  ////////////////////////////////////////// CHECK BACKGROUND //////////////////////////////////////////////////////////////////////////////
  public void check(int col1, int col2) {
    window.fill(col2);
    window.rect(window.width/2, window.height/2, window.width, window.height);        
    ////////////////////////// Fill OPPOSITE COLOR //////////////
    window.fill(col1);  
    for (int i = 0; i < grid.mirror.length/grid.rows; i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
    for (int i = grid.columns+1; i < grid.mirror.length/grid.rows+grid.columns; i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
    if (grid.rows == 3) for (int i = grid.columns*grid.rows; i < grid.mirror.length/grid.rows+(grid.columns*2); i+=2)  window.rect(grid.mirror[i].x, grid.mirror[i].y, grid.mirrorWidth, grid.mirrorWidth);
  }
  /////////////////////////// TOP ROW ONE COLOUR BOTTOM ROW THE OTHER BACKGORUND ////////////////////////////////////////////////////////////////
  public void sideBySide( int col1, int col2) {
    /////////////// TOP RECTANGLE ////////////////////
    window.fill(col2);
    window.rect(window.width/4, window.height/2, window.width/2, window.height);     
    /////////////// BOTTOM RECTANGLE ////////////////////
    window.fill(col1);                                
    window.rect(window.width/4*3, window.height/2, window.width/2, window.height);
  }
}

class SketchColor {
  int c, flash, c1, flash1, colorA, colorB = 1, colA, colB, colC, colD;
  int col[] = new int[15];

  SketchColor() {
    /////////////////////////////////////// COLOR ARRAY SETUP ////////////////////////////////////////
    col[0] = purple; 
    col[1] = pink; 
    col[2] = orange1; 
    col[3] = teal;
    col[4] = red;
    col[5] = bloo;
    col[6] = pink;
    col[7] = grin;
    col[8] = orange;
    col[9] = yell;
    col[10] = purple;
    col[11] = grin;
    col[12] = aqua;
    col[13] = orange1;
    col[14] = teal;
  }

  //////////////////////////////////////////////////// COLOR TIMER ////////////////////////////////
  float go = 0;
  boolean change;
  int colorTimer;
  public void colorTimer(float colTime, int steps) {
    if (change == false) {
      colA = c;
      colC = flash;
    }
    if (millis()/1000 - colorTimer >= colTime) {
      change = true;
      println("COLOR CHANGE @", (hour()+":"+minute()+":"+second()));
      colorTimer = millis()/1000;
    } else change = false;
    if (change == true) {
      go = 1;
      colorA =  (colorA + steps) % (col.length-1);
      colB =  col[colorA];
      colorB = (colorB + steps) % (col.length-1);
      colD = col[colorB];
    }
    c = col[colorA];
    c1 = col[colorA];
    flash = col[colorB];
    flash1 = col[colorB];

    if (go > 0.1f) change = true;
    else change = false;
    if (change == true) {
      c = lerpColorHSB(colB, colA, go);
      flash = lerpColorHSB(colD, colC, go);
    }
    go *= 0.97f;
    if (go < 0.01f) go = 0.001f;
  }
  ////////////////////////////////////////////////////// HSB LERP COLOR FUNCTION //////////////////////////////
  // linear interpolate two colors in HSB space 
  public int lerpColorHSB(int c1, int c2, float amt) {
    amt = min(max(0.0f, amt), 1.0f);
    float h1 = hue(c1), s1 = saturation(c1), b1 = brightness(c1);
    float h2 = hue(c2), s2 = saturation(c2), b2 = brightness(c2);
    // figure out shortest direction around hue
    float z = g.colorModeZ;
    float dh12 = (h1>=h2) ? h1-h2 : z-h2+h1;
    float dh21 = (h2>=h1) ? h2-h1 : z-h1+h2;
    float h = (dh21 < dh12) ? h1 + dh21 * amt : h1 - dh12 * amt;
    if (h < 0.0f) h += z;
    else if (h > z) h -= z;
    colorMode(HSB);
    return color(h, lerp(s1, s2, amt), lerp(b1, b2, amt));
  }
  ////////////////////////////// COLOR SWAP //////////////////////////////////
  boolean colSwap;
  public void colorSwap(float spd) {
    int t = PApplet.parseInt(millis()/70*spd % 2);
    int colA = c;
    int colB = flash;
    if ( t == 0) {
      colSwap = true;
      c = colB;
      flash = colA;
    } else colSwap = false;
  } 
  ////////////////////////////// COLOR FLIP //////////////////////////////////
  boolean colFlip;
  public void colorFlip(boolean toggle) {
    int colA = c;
    int colB = flash;
    if (toggle) {
      c = colB;
      flash = colA;
    }
  }
  ///////////////////////////////////////// CLASH COLOR SETUP /////////////////////////////////
  int clash, clash1, clash2, clash12, clashed;
  public void clash(float func) { 
    int flashHalf = lerpColor(c, flash, 0.75f);
    int cHalf = lerpColor(c, flash, 0.25f); 

    clash = lerpColorHSB(c, flash, func*0.15f);     ///// MOVING, HALF RNAGE BETWEEN C and FLASH
    clash1 = lerpColorHSB(c, flash, 1-(func*0.3f));            ///// MOVING, HALF RANGE BETWEEN FLASH and C
    clash2 = lerpColorHSB(flash, c, func*0.3f);          ///// MOVING, FULL RANGE BETWEEN C and FLASH
    clash12 = lerpColorHSB(flash, c, 1-(func*0.3f));          ///// MOVING, FULL RANGE BETWEEN FLASH and C
    clashed = lerpColor(c, flash, 0.2f);    ///// STATIC - HALFWAY BETWEEN C and FLASH
  }
}

/////////////////////////// COLOR SETUP CHOSE COLOUR VALUES ///////////////////////////////////////////////
int red, pink, yell, grin, bloo, purple, teal, orange, aqua, white, black;
int red1, pink1, yell1, grin1, bloo1, purple1, teal1, aqua1, orange1;
int red2, pink2, yell2, grin2, bloo2, purple2, teal2, aqua2, orange2;
public void colorSetup() {
  colorMode(HSB, 360, 100, 100);
  white = color(0, 0, 100);
  black = color(0, 0, 0);

  float alt = 0;
  float sat = 100;
  aqua = color(150+alt, sat, 100);
  pink = color(323+alt, sat, 90);
  bloo = color(239+alt, sat, 100);
  yell = color(50+alt, sat, 100);
  grin = color(115+alt, sat, 100);
  orange = color(30+alt, sat, 90);
  purple = color(290+alt, sat, 70);
  teal = color(170+alt, sat, 85);
  red = color(7+alt, sat, 100);
  // colors that aren't affected by color swap
  float sat1 = 100;
  aqua1 = color(190+alt, 80, 100);
  pink1 = color(323-alt, sat1, 90);
  bloo1 = color(239-alt, sat1, 100);
  yell1 = color(50-alt, sat1, 100);
  grin1 = color(160-alt, sat1, 100);
  orange1 = color(34.02f-alt, sat1, 90);
  purple1 = color(290-alt, sat1, 70);
  teal1 = color(170-alt, sat1, 85);
  red1 = color(15-alt, sat1, 100);
  /// alternative colour similar to original for 2 colour blends
  float sat2 = 100;
  alt = +6;
  aqua2 = color(190-alt, 80, 100);
  pink2 = color(323-alt, sat2, 90);
  bloo2 = color(239-alt, sat2, 100);
  yell2 = color(50-alt, sat2, 100);
  grin2 = color(160-alt, sat2, 100);
  orange2 = color(34.02f-alt, sat2, 90);
  purple2 = color(290-alt, sat2, 70);
  teal2 = color(170-alt, sat2, 85);
  red2 = color(15-alt, sat2, 100);
}
/////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
float sineFast, sineSlow, sine, stutter, shimmer;
float timer[] = new float[6];
public void globalFunctions() {
  noize();
  oskPulse();
  
  float tm = 0.05f+(noize/50);
  timer[2] += alphaSlider;            
  for (int i = 0; i<timer.length; i++) timer[i] += tm;
  timer[3] += (0.3f*5);
  timer[5] *=1.2f;
  sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
  if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  shimmer = (shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
  
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// BEAT DETECT THROUGHOUT SKETCH //////////////////////////////////////////////////////////////////////////
int beatCounter;
long beatTimer;
boolean beatTrigger;
float beat;
public void resetbeats() {
  beat = 1;
  beatCounter = (beatCounter + 1) % 120;
  weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
  weightedcnt=1+(1-beatAlpha)*weightedcnt;
  avgtime=weightedsum/weightedcnt;
  beatTimer=0;
}
///////////////////////////////////////// BEATS /////////////////////////////////////////////////////////////////////
public void beats() {            
  beatTimer++;
  beatAlpha=0.2f; //this affects how quickly code adapts to tempo changes 0.2 averages the last 10 onsets  0.02 would average the last 100
  beatTrigger = false;
  if (beatDetect.isOnset()) beatTrigger = true;
  // trigger beats without audio input
  if (pause > 1) if (frameCount % PApplet.parseInt((random(12, 25))*pauseSlider) == 0) beatTrigger = true;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (beatTrigger) resetbeats();
  if (avgtime>0) beat*=pow(alphaSlider, (1/avgtime));       //  changes rate alpha fades out!!
  else beat*=0.95f;
  float end = 0.001f;
  if (beat < end) beat = end;
}
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
int pause, pauseTimer;
public void pause(int secondsToWait) {
  if (beatDetect.isOnset()) {
    pause = 0;
    pauseTimer = millis()/1000;
  } else {
    if (millis()/1000 - pauseTimer >= secondsToWait) {
      pause +=1;
      pauseTimer = millis()/1000;
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// BOOTH AND DIG LIGHTS /////////////////////////////////////////////////////////////////////
public void boothLights() {
  fill(rigColor.c1, 360*boothDimmer);
  rect(grid.booth.x, grid.booth.y, 30, 10);
  fill(rigColor.flash1, 360*digDimmer);
  rect(grid.dig.x, grid.dig.y, 30, 10);
}
/////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
public void testColors(boolean _test) {
  if (_test) {
    fill((millis()/50)%360, 100, 100);           
    rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    rect(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    rect(size.cans.x, size.cans.y, size.cansWidth, size.cansHeight);
    rect(grid.booth.x, grid.booth.y, 30, 10);
    rect(grid.dig.x, grid.dig.y, 30, 10);
  }
}
/////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
public void workLights(boolean _work) {
  if (_work) {
    pause = 10;
    fill(360*cc[9], 360*cc[10]);
    rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    rect(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    rect(size.cans.x, size.cans.y, size.cansWidth, size.cansHeight);
    rect(grid.booth.x, grid.booth.y, 30, 10);
    rect(grid.dig.x, grid.dig.y, 30, 10);
  }
}
/////////////////////////////////////////////// OSKP///////////////////////////////////////////
float osk1, oskP, timer1;
public void oskPulse() {
  osk1 += 0.01f;               
  timer1 = log(map (sin(osk1), -1, 1, 0.1f, 10000));
  timer1 += timer1;
  oskP = map(sin(timer1), -1, 1, 0, 1);
}
////////////////////////////////////////////// NOIZE ////////////////////////////////////////////
float noize, noize1, noize2, noize12;
public void noize() {
  float dx = millis() * 0.0001f;
  float z = millis() * 0.0001f;
  noize = sin(10 * (noise(dx * 0.01f, 0.01f, z) - 0.4f));
  noize2 = cos(10 * (noise(dx * 0.01f, 0.01f, z/1.5f) - 0.4f));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}

public void bgNoise(PGraphics layer, int _col, float bright, float alpha) {
  int col=color(hue(_col), saturation(_col), 100*bright);
  layer.loadPixels();
  for (int x=0; x<size.rigWidth; x++) {
    for (int y=0; y<size.rigHeight; y++) {
      int pixel=layer.pixels[x+y*size.rigWidth];
      //col=int(random(255*alpha))<<24 | col&0xffffff;
      int out;
      if (random(1.0f)<alpha) {
        out=col;
      } else {
        out=pixel;
      }
      layer.pixels[x+y*size.rigWidth]=out;
    }
  }
  layer.updatePixels();
}
/* KEY FUNCTIONS
 
 'c' steps through one of the colours
 'v' steps theough the other colour - current and upcoming colours are displayed in small boxes below the main animation
 'b' steps the animations backwards 
 'n' steps the animations forward
 'm' changes the backgrounds
 ',' changes the function
 '.' changes the alpha
 'l' toggle colour change on beat
 ';' toggle swaps color c/flash
 ''' swaps color c/flash - press and hold
 '\' color swap
 '[' viz hold - stops the timer counting down for next viz change
 ']' color hold - stops the timer counting down for next colour change
 'q' toggles mouse coordiantes and moveable dot
 't' toggle TEST - cycles though all colours to test LEDs
 'w' toggle WORK LIGHTS - all WHITE 
 
 */
public void onScreenInfo() {
  textSize(18);
  fill(300+(60*stutter));
  textAlign(RIGHT);
  textLeading(18);
    float y = height-5;

  //text("RIG PANEL", size.rig.x+(size.rigWidth/2)-5, size.rig.y-(size.rigHeight/2)+20);
  //if (size.roofWidth >10)  text("ROOF PANEL", size.roof.x+(size.roofWidth/2)-5, size.rig.y-(size.rigHeight/2)+20);
  //if (size.cansWidth >10|| size.cansHeight>10) text("CANS PANEL", size.rig.x+(size.rigWidth/2)-5, size.rig.y+(size.rigHeight/2)-5);
  text("anims: "+animations.size(), width - 15, y);
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////// SHOW INFO ABOUT CURRENT ARRAY SELECTION ////////////////////////////////////////////////////////////////
 
  textAlign(LEFT);
  float x = 70;
  textSize(18);
  ///////////// rig info/ ///////////////////////////////////////////////////////////////////
  text("viz:" + rigViz, x, y);
    text("bg:" + rigBgr, x+50, y);

  /*
  text("func's: " + rigFunctionIndexA + " / " + rigFunctionIndexB, x+100, y);
  text("alph's: " + rigAlphaIndexA + " / " + rigAlphaIndexB, x+100, y+20);
  ///////////// roof info ////////////////////////////////////////////////////////
  if (size.roofWidth > 10 ) {
    textAlign(RIGHT);
    x = size.roof.x+(size.roofWidth/2) - 130;
    text("roofViz: " + roofViz, x, y);
    text("bkgrnd: " + roofBgr, x, y+20);
    text("func's: " + roofFunctionIndexA + " / " + roofFunctionIndexB, x+120, y);
    text("alph's: " + roofAlphaIndexA + " / " + roofAlphaIndexB, x+120, y+20);
  }
  ///////////// cans info ////////////////////////////////////////////////////////
  if (size.cansHeight > 10 || size.cansWidth > 10) {
    textAlign(RIGHT);
    x = size.cans.x+(size.cansWidth/2) - 130;
    text("cansViz: " + roofViz, x, y);
    text("bkgrnd: " + roofBgr, x, y+20);
    text("func's: " + roofFunctionIndexA + " / " + roofFunctionIndexB, x+120, y);
    text("alph's: " + roofAlphaIndexA + " / " + roofAlphaIndexB, x+120, y+20);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////// info about PLAYWITHYOURSELF functions /////////////////////////////////////////////////////////////////////////////////////////////
  y = 20;
  x=width-5;
  textAlign(RIGHT);
  fill(rigColor.c, 300);
  ///// NEXT VIZ IN....
  String sec = nf(int(vizTime - (millis()/1000 - vizTimer)) % 60, 2, 0);
  int min = int(vizTime - (millis()/1000 - vizTimer)) /60 % 60;
  text("next viz in: "+min+":"+sec, x, y);
  ///// NEXT COLOR CHANGE IN....
  sec = nf(int(colTime - (millis()/1000 - rigColor.colorTimer)) %60, 2, 0);
  min = int(colTime - (millis()/1000 - rigColor.colorTimer)) /60 %60;
  text("next color in: "+ min+":"+sec, x, y+20);
  text("c-" + rigColor.colorA + "  " + "flash-" + rigColor.colorB, x, y+40);
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  */
  pauseInfo();
  //colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, y);          ///// display frame rate X, Y /////
  //sequencer();
  //toggleKeysInfo();
  cordinatesInfo(keyT['q']);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //dividerLines();
}
public void pauseInfo() {
  if (pause > 0) { 
    textAlign(RIGHT);
    textSize(20); 
    fill(0,100,100,300);
    text("NO AUDIO!!", width-5, height-2);
  }
}
public void cordinatesInfo(boolean _info) {
  if (_info) {
    /////// DISPLAY MOUSE COORDINATES
    textAlign(LEFT);
    fill(360);  
    ellipse(mouseX, mouseY+10, 10, 10);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, mouseX, mouseY );
    /////  LABLELS to show what PVectors are what 
    textSize(12);
    textAlign(CENTER);
    for (int i = 0; i < grid.mirror.length; i++) text(i, grid.mirror[i].x, grid.mirror[i].y);   /// mirrors Position info
    //for (int i = 0; i < grid.roof.length; i++) if (size.roof.x>0) text(i, grid.roof[i].x, grid.roof[i].y);
  }
}
public void sequencer() {
  fill(rigColor.flash);
  int dist = 20;
  float y = 80;
  for (int i = 0; i<(size.infoHeight-size.sliderHeight)/dist-(y/dist); i++) if (PApplet.parseInt(beatCounter%(dist-(y/dist))) == i) rect(size.info.x-(size.infoWidth/2)+10, 10+i*dist+y, 10, 10);
  fill(rigColor.c, 100);
  for (int i = 0; i<(size.infoHeight-size.sliderHeight)/dist-(y/dist); i++) rect(size.info.x-(size.infoWidth/2)+10, 10+i*dist+y, 10, 10);
}
public void dividerLines() {
  fill(rigColor.flash);
  rect(size.rigWidth, height/2, 1, height);                     ///// vertical line to show end of rig viz area
  rect(size.rig.x, size.rigHeight, size.rigWidth, 1);             //// horizontal line to divide landscape rig / roof areas
  rect(size.rigWidth+size.roofWidth, height/2, 1, height);      ///// vertical line to show end of roof viz area
  fill(rigColor.flash, 80);    
  rect((size.rigWidth+size.roofWidth)/2, height-size.sliderHeight, size.rigWidth+size.roofWidth, 1);                              ///// horizontal line to show bottom area
}
public void colorInfo() {
  ///// RECTANGLES TO SHOW BEAT DETECTION AND CURRENT COLOURS /////
  float y = height-7.5f;
  float x = 17;
  // RIG ///
  fill(rigColor.c);          
  rect(x, y-10, 10, 10);               // rect to show CURRENT color C 
  fill(rigColor.col[(rigColor.colorA+1)%rigColor.col.length], 100);
  rect(x+15, y-10, 10, 10);              // rect to show NEXT color C 
  fill(rigColor.flash);
  rect(x, y, 10, 10);                  // rect to show CURRENT color FLASH 
  fill(rigColor.col[(rigColor.colorB+1)%rigColor.col.length], 100);  
  rect(x+15, y, 10, 10);                 // rect to show NEXT color FLASH1
  // roof
  if (size.roofWidth>0|| size.roofHeight>0) {
    x = size.roof.x+(size.roofWidth/2)-25;
    fill(roofColor.c);          
    rect(x, y-10, 10, 10);              // rect to show CURRENT color C 
    fill(roofColor.col[(roofColor.colorA+1)%roofColor.col.length], 100);
    rect(x+15, y-10, 10, 10);               // rect to show NEXT color C 
    fill(roofColor.flash);          
    rect(x, y, 10, 10);                 // rect to show CURRENT color FLASH 
    fill(roofColor.col[(roofColor.colorB+1)%roofColor.col.length], 100);
    rect(x+15, y, 10, 10);                  // rect to show NEXT color FLASH1
  }
  // cans
  if (size.cansWidth>0|| size.cansHeight>0) {
    x = size.cans.x+(size.cansWidth/2)-25;
    fill(roofColor.c);          
    rect(x, y-10, 10, 10);              // rect to show CURRENT color C 
    fill(cansColor.col[(cansColor.colorA+1)%cansColor.col.length], 100);
    rect(x+15, y-10, 10, 10);               // rect to show NEXT color C 
    fill(cansColor.flash);          
    rect(x, y, 10, 10);                 // rect to show CURRENT color FLASH 
    fill(cansColor.col[(cansColor.colorB+1)%cansColor.col.length], 100);
    rect(x+15, y, 10, 10);                  // rect to show NEXT color FLASH1
  }
}
public void frameRateInfo(float x, float y) {
  textAlign(LEFT);
  textSize(18);
  fill(360);  
  text(PApplet.parseInt(frameRate) + " fps", x, y); // framerate display
  //frame.setTitle(int(frameRate) + " fps"); //framerate as title
}
public void toggleKeysInfo() {
  textSize(18);
  textAlign(RIGHT);
  float y = 180;
  float x = width-5;
  fill(50);
  if (vizHold)  fill(300+(60*stutter));
  text("[ = VIZ HOLD", x, y);
  fill(50);
  if (colHold) fill(300+(60*stutter));
  text("] = COL HOLD", x, y+20);
  y +=20;
  fill(50);
  if (keyT['p']) fill(300+(60*stutter));
  text("P = shimmer", x, y+40);
  fill(50);
  if (!rigColor.colSwap) fill(300+(60*stutter));
  text("O = color swap", x, y+60);
  fill(50);
  if (rigColor.colFlip) fill(300+(60*stutter));
  text("I / U = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("Y = color beat", x, y+100);
  y+=20;
  fill(50);
}

class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, sliderHeight, infoWidth, infoHeight, vizWidth, vizHeight, cansWidth, cansHeight;
  PVector rig, roof, info, cans;
  int surfacePositionX, surfacePositionY, sizeX, sizeY, orientation;

  SizeSettings(int _orientation) {
    orientation = _orientation;
    switch (orientation) {
    case PORTRAIT:
      rigWidth = 600;                                    // WIDTH of rigViz
      rigHeight = 400;                                   // HEIGHT of rigViz
      rig = new PVector(rigWidth/2, rigHeight/2);   // cordinates for center of rig
      break;
    case LANDSCAPE:
      rigWidth = 300;                                    // WIDTH of rigViz
      rigHeight = 200;    
      rig = new PVector(rigWidth/2, rigHeight/2);   // cordinates for center of rig
      break;
    }

    //////////////////////////////// LANDSCAPE CANS SETUP UNDER RIG ///////////////////////
    cansWidth = rigWidth;
    cansHeight = 5;
    cans = new PVector (rig.x, rigHeight+(cansHeight/2));
    //////////////////////////////// LANDSCAPE ROOF SETUP to RIGHT of RIG ///////////////////////
    roofWidth = 2;
    roofHeight = rigHeight+cansHeight;
    roof = new PVector (rigWidth+(roofWidth/2), roofHeight/2);
    ////////////////////////////////////////////////////////////////////////////////////////////
    

    sliderHeight = 15;         // height of slider area at bottom of sketch window

    infoWidth = 2;
    infoHeight = rigHeight+sliderHeight;
    info = new PVector (rigWidth+roofWidth+(infoWidth/2), infoHeight/2);

    sizeX = rigWidth+infoWidth+roofWidth;
    sizeY = sliderHeight+rigHeight+cansHeight;
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
class Toggle {
  boolean rect = false;
  Toggle() {
    rect = false;
  }
}

//////////////////////////////////////// LOAD IMAGES ///////////////////////////
PImage bar1, flames; 
public void loadImages() {
  flames = loadImage("1.jpg");
  bar1 = loadImage("bar1.png");
}
//////////////////////////// AUDIO SETUP ////////////////////////////////////







Minim minim;
AudioInput in;
BeatDetect beatDetect;
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
public void audioSetup(int sensitivity) {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);

  beatAlpha=0.2f;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  weightedsum=0;
  weightedcnt=0;
  avgtime=0;
  avgvolume = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
AudioPlayer player[];
public void loadAudio() {
  //////////////////////////////// load one shot sounds ///////////////////////////////
  player = new AudioPlayer[81];
  for (int i = 1; i <= 80; i++) {
    int hundreds = i/100;
    int tens = (i%100)/10;
    int ones = i%10;
    String number =str(hundreds)+str(tens)+str(ones);
    player[i] = minim.loadFile("oneshot_"+number+".wav");
  }
  println("audio loaded");
}
////////////////////////////////// SETUP SKETCH DRAWING NORMALS ////////////////////////
public void drawingSetup() {
  myFont = createFont("Lucida Sans Unicode", 18);
  textFont(myFont);
  textSize(18);
  colorMode(HSB, 360, 100, 100);
  blendMode(ADD);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  noStroke();
  strokeWeight(20);
  //hint(DISABLE_OPTIMIZED_STROKE);
}
class Buffer {
  PGraphics colorLayer, buffer, pass1, pass2;
  Buffer(int wide, int high) {

    colorLayer = createGraphics(wide, high, P2D);
    colorLayer.beginDraw();
    colorLayer.noStroke();
    colorLayer.colorMode(HSB, 360, 100, 100);
    colorLayer.imageMode(CENTER);
    colorLayer.rectMode(CENTER);
    colorLayer.endDraw();

    buffer = createGraphics(wide, high, P2D);
    buffer.beginDraw();
    buffer.colorMode(HSB, 360, 100, 100);
    buffer.blendMode(NORMAL);
    buffer.ellipseMode(CENTER);
    buffer.rectMode(CENTER);
    buffer.imageMode(CENTER);
    buffer.noStroke();
    buffer.noFill();
    buffer.endDraw();

    ///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
    pass1 = createGraphics(wide/2, high/2, P2D);
    pass1.noSmooth();
    pass1.imageMode(CENTER);
    pass1.beginDraw();
    pass1.noStroke();
    pass1.endDraw();

    pass2 = createGraphics(wide/2, high/2, P2D);
    pass2.noSmooth();
    pass2.beginDraw();
    pass2.imageMode(CENTER);
    pass2.noStroke();
    pass2.endDraw();
  }
}
/////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
PGraphics bg[] = new PGraphics[rigBgList];
PGraphics rigWindow, roofWindow, cansWindow, infoWindow, rigColourLayer, roofColourLayer, rigBluredA, rigBluredB, roofBluredA, roofBluredB;
public void loadGraphics() {
  //////////////////////////////// info subwindow  ///////////////////
  infoWindow = createGraphics(size.infoWidth, size.infoHeight, P2D);
  infoWindow.beginDraw();
  infoWindow.colorMode(HSB, 360, 100, 100);
  infoWindow.ellipseMode(CENTER);
  infoWindow.imageMode(CENTER);
  infoWindow.rectMode(CENTER);
  infoWindow.endDraw();
  ///////////////////////////// COLOR LAYER / BG GRAPHICS ////////////////////////////
  for ( int n = 0; n<bg.length; n++) {
    bg[n] = createGraphics(PApplet.parseInt(size.rigWidth), PApplet.parseInt(size.rigHeight), P2D);
    bg[n].beginDraw();
    bg[n].colorMode(HSB, 360, 100, 100);
    bg[n].ellipseMode(CENTER);
    bg[n].rectMode(CENTER);
    bg[n].imageMode(CENTER);
    bg[n].noStroke();
    bg[n].noFill();
    bg[n].endDraw();
  }
}
PShader blur;
public void loadShaders() {
  float blury = PApplet.parseInt(map(blurSlider, 0, 1, 0, 100));
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}

ControlP5 cp5;

boolean glitchToggle, cansToggle = false, roofToggle = false, rigToggle = true;
float vizTimeSlider, colorSwapSlider, colorTimerSlider, cansDimmer, boothDimmer, digDimmer, backDropSlider, cansSlider;
float tweakSlider, blurSlider, bgNoiseBrightnessSlider, bgNoiseDensitySlider, manualSlider, stutterSlider, cansAlpha, deleteMeSlider;
float shimmerSlider, alphaSlider, rigDimmer, roofDimmer, seedsDimmer, seed2Dimmer, uvDimmer, controllerDimmer, funcSlider, pauseSlider;

class ControlFrame extends PApplet {
  int controlW, controlH;
  float clm, row;
  PApplet parent;
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    controlW=_w;
    controlH=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  public void settings() {
    size(controlW, controlH);
  }
  public void setup() {
    this.surface.setAlwaysOnTop(true);
    this.surface.setLocation(size.surfacePositionX-controlW+parent.width, size.surfacePositionY+parent.height+35);
    myFont = createFont("Lucida Sans", 18);
    textFont(myFont);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();
    cp5 = new ControlP5(this);
    // slider colours
    int act = 0xff07E0D3;
    int act1 = 0xff00FC84;
    int bac = 0xff370064;
    int bac1 = 0xff4D9315;
    int slider = 0xffE07F07;
    int slider1 = 0xffE0D607;
    float x = 10;
    float y = 20;
    int wide = 80;           // x size of sliders
    int high = 14;           // y size of slider
    row = high +4;     // distance between rows
    clm = 210;         // distance between coloms
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// FIRST COLOUM OF SLIDERS ////////////////////////////////////////////
    cp5.addSlider("vizTimeSlider") // name used throughout sketch to link to slider
      .plugTo(parent, "vizTimeSlider")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("colorTimerSlider")
      .plugTo(parent, "colorTimerSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.45f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("colorSwapSlider")
      .plugTo(parent, "colorSwapSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("alphaSlider")
      .plugTo(parent, "alphaSlider")
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.45f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("funcSlider")
      .plugTo(parent, "funcSlider")
      .setPosition(x, y+row*4)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("manualSlider")
      .plugTo(parent, "manualSlider")
      .setPosition(x, y+row*5)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    ///////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// SECOND coloum of sliders ///////////////////////////////////////
    x =+ clm;
    cp5.addSlider("boothDimmer")
      .plugTo(parent, "boothDimmer")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.35f)    // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("digDimmer")
      .plugTo(parent, "digDimmer")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("uvDimmer")
      .plugTo(parent, "uvDimmer")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.32f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("controllerDimmer")
      .plugTo(parent, "controllerDimmer")
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.4f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("cansAlpha")
      .plugTo(parent, "cansAlpha")
      .setPosition(x, y+row*4)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.6f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("deleteMeSlider")
      .plugTo(parent, "deleteMeSlider")
      .setPosition(x, y+row*5)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// THIRD coloum of sliders //////////////////////////////////
    x +=clm;
    cp5.addSlider("cansDimmer")
      .plugTo(parent, "cansDimmer")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(1)    // start value []ppof slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("roofDimmer")
      .plugTo(parent, "roofDimmer")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(dimmer) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("rigDimmer")
      .plugTo(parent, "rigDimmer")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(dimmer)    // start value []ppof slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x+=clm;
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////// FOURTH coloum of sliders ///////////////////////////////////////
    cp5.addSlider("blurSlider")
      .plugTo(parent, "blurSlider")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.6f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("stutterSlider")
      .plugTo(parent, "stutterSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("bgNoiseSlider")
      .plugTo(parent, "bgNoiseSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.3f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("bgNoiseBrightnessSlider")
      .plugTo(parent, "bgNoiseBrightnessSlider")
      .setPosition(x, y+row*3)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;    
    cp5.addSlider("bgNoiseDensitySlider")
      .plugTo(parent, "bgNoiseDensitySlider")
      .setPosition(x, y+row*4)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.1f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("pauseSlider")
      .plugTo(parent, "pauseSlider")
      .setPosition(x, y+row*5)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0.5f, 5)
      .setValue(1) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;  
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////// BUTTONS ///////////////////////////////////////////////////////////////
    x +=clm;
    cp5.addToggle("rigToggle")
      .plugTo(parent, "rigToggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(rigToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ; 
    x += 60;
    cp5.addToggle("roofToggle")
      .plugTo(parent, "roofToggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(roofToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 60;
    cp5.addToggle("cansToggle")
      .plugTo(parent, "cansToggle")
      .setPosition(x, y)
      .setSize(50, 50)      
      .setValue(cansToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    x += 80;
    cp5.addToggle("onTop")
      .plugTo(parent, "onTop")
      .setPosition(x, y)
      .setSize(20, 20)
      .setValue(onTop)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addToggle("glitchToggle")
      .plugTo(parent, "glitchToggle")
      .setPosition(x, y+35)
      .setSize(20, 20)
      .setValue(glitchToggle)
      .setColorActive(bac1) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
  }
  public void draw() {
    background(0);
    fill(rigColor.c);
    rect(width/2, 0, width, 2);
  }
  //////////////////////////////////////// CALL BACK FOR SLIDER CONTROL FROM OTHER VARIABLES
  // an event from slider sliderA will change the value of textfield textA here
  public void rigDimmer(float theValue) {
    int value = PApplet.parseInt(map(theValue, 0, 1, 0, 127));
    LPD8bus.sendControllerChange(0, 4, value) ;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "lightbox_code" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
