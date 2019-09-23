
class SizeSettings {
  int rigWidth, rigHeight, roofWidth, roofHeight, sliderHeight, infoWidth, infoHeight, vizWidth, vizHeight;
  PVector rig, roof, info, viz, rigWindow;
  int surfacePositionX, surfacePositionY;
  int sizeX, sizeY;

  SizeSettings() {
    rigWidth = 600;                                    // WIDTH of rigViz
    rigHeight = 550;                                   // HEIGHT of rigViz
    rig = new PVector(rigWidth/2, (rigHeight/2)-30);   // cordinates for center of rig
    rigWindow = new PVector(rigWidth/2, rigHeight/2);

    vizWidth = rigWidth;
    vizHeight = rigHeight;
    viz = new PVector (rig.x, rig.y);

    roofWidth = 0;
    roofHeight = rigHeight;
    roof = new PVector (rigWidth+roofWidth/2, roofHeight/2);

    sliderHeight = 70;         // height of slider area at bottom of sketch window

    infoWidth = 300;
    infoHeight = rigHeight+sliderHeight;
    info = new PVector (rigWidth+roofWidth+(infoWidth/2), infoHeight/2);

    sizeX = rigWidth+roofWidth+infoWidth;
    sizeY = sliderHeight+rigHeight;
  }
}
//////////////////////////// AUDIO SETUP ////////////////////////////////////
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import javax.sound.sampled.*;
Minim minim;
AudioInput in;
BeatDetect beatDetect;
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
void audioSetup(int sensitivity) {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);

  beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  weightedsum=0;
  weightedcnt=0;
  avgtime=0;
  avgvolume = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
PGraphics pass1[] = new PGraphics[16];
PGraphics blured[] = new PGraphics[16];
PShader blur;
PGraphics src;
int blury, prevblury;
void loadShaders(int blury) {
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);  
  src = createGraphics(size.rigWidth, size.rigHeight, P3D); 
  for (int i = 0; i < pass1.length; i++) {
    pass1[i] = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    pass1[i].noSmooth();
    pass1[i].imageMode(CENTER);
    pass1[i].beginDraw();
    pass1[i].noStroke();
    pass1[i].endDraw();
  }
  for (int i = 0; i < blured.length; i++) {
    blured[i] = createGraphics(int(size.rigWidth*1.2), int(size.rigHeight*1.2), P2D);
    blured[i].noSmooth();
    blured[i].beginDraw();
    blured[i].imageMode(CENTER);
    blured[i].noStroke();
    blured[i].endDraw();
  }
}
