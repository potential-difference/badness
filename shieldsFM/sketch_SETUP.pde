void rect(Coord c){rect(c.x,c.y,c.wide,c.high);}
void rect(IntCoord c){rect(c.x,c.y,c.wide,c.high);}
class Coord{
  float x,y,wide,high;
  Coord(float _x,float _y,float _wide,float _high){
    x=_x; y=_y; wide=_wide; high=_high;
  }
}
class IntCoord{
  int x,y,wide,high;
  IntCoord(int _x,int _y,int _wide,int _high){
    x = _x; y=_y;wide=_wide;high=_high;
  }
}

class SizeSettings {
  // for loop to setup components based on what rigs there are or the other way around.
  // need less places where you have to make changes!
  // maybe this could be a config thing though so each instance is just a reference to 
  // a name in the config file so thats the only place you change things...?!
  IntCoord shields,tipiLeft,tipiRight,tipiCentre,megaSeedA,megaSeedB,info,booth,bar,uvPars;
  //PVector rig, roof, cans, donut, pars, info;
  int sizeX, sizeY;

  SizeSettings() {
    int rigWidth = 600;   
    int rigHeight = 600;    
    
    shields = new IntCoord(rigWidth/2, rigHeight/2, rigWidth, rigHeight);
    
    ////////////////////////////////  TOP LINE OF RIGS - RIGHT OF MAIN ONE ///////////////////////
    // Update rigWidth and rigHeight using shields.wide/4
    rigWidth = int(shields.wide/2.8);
    rigHeight = int(shields.wide/2.8);
    
    // number of rigs required 
    int numObjects = 3;
    int numOfRows = 2;
    int numOfColumns = 2;
    // Use arrays to store the x and y coordinates
    int[] xCoordinates = new int[numObjects];
    int[] yCoordinates = new int[numObjects];
    
    // Calculate the x coordiantes for the objects: will become centre of the rig
    xCoordinates[0] = shields.wide + rigWidth / 2;
    xCoordinates[1] = xCoordinates[0] + rigWidth;
    xCoordinates[2] = xCoordinates[0];
    // Calculate the y coordiantes for the objects: will become centre of the rig
    yCoordinates[0] = rigHeight/2;
    yCoordinates[1] = rigHeight/2;
    yCoordinates[2] = yCoordinates[0] + rigHeight;

    // print to console to check everything is working correctly.
    for(int i = 0; i < numObjects; i++ ) {
      println("xCoordinates[" + i + "] " + xCoordinates[i]);
      println("yCoordinates[" + i + "] " + yCoordinates[i]);
      println();
    }
         
    // Create an array to store the created objects
    IntCoord[] roofCoords = new IntCoord[numObjects];
    // Use a for loop to create the objects and store them in the array
    for (int i = 0; i < numObjects; i++) {
      roofCoords[i] = new IntCoord(xCoordinates[i], yCoordinates[i], rigWidth, rigHeight);
      println("roofCoords[" + i + "] " + roofCoords[i].x + " " + roofCoords[i].y);
    }
    
    tipiLeft = roofCoords[0];
    tipiRight = roofCoords[1];
    tipiCentre = roofCoords[2];    

    // Calculate the x and y coordinates for the info object
    int infoWidth = 250;
    int infoHeight = shields.high;
    int xCoordinate = roofCoords[numOfColumns - 1].x + rigWidth / 2 + infoWidth / 2;
    int yCoordinate = shields.y;
    
    
    // Create the info object using the calculated coordinates and updated rigWidth
    info = new IntCoord(xCoordinate, yCoordinate, infoWidth, infoHeight);
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////  BOTTOM LINE OF RIGS /////////////////////////////////////
    rigHeight = 100;
    rigWidth = 200;
    
    // Calculate the y coordinate for the bottom row of objects
    int bottomRigY = shields.high + rigHeight/2;
    
    // Create the megaSeedA object
    megaSeedA = new IntCoord(rigWidth/2, bottomRigY, rigWidth, rigHeight);
    
    // Update the x coordinate for megaSeedB using megaSeedA's properties
    int megaSeedBx = megaSeedA.x + rigWidth;
    megaSeedB = new IntCoord(megaSeedBx, bottomRigY, rigWidth, rigHeight);
    
    // Update the x coordinate for uvPars using megaSeedB's properties
    int uvParsx = megaSeedBx + megaSeedB.wide/2 + rigWidth/2;
    uvPars = new IntCoord(uvParsx, bottomRigY, rigWidth, rigHeight);
    
    // Update the x coordinate for bar using uvPars's properties
    int barx = uvParsx + uvPars.wide/2 + rigWidth/2;
    bar = new IntCoord(barx, bottomRigY, rigWidth, rigHeight);
    
    // Update the rigWidth using info's properties
    rigWidth = info.wide;
    
    // Create the booth object using info's properties and the updated rigWidth
    booth = new IntCoord(info.x, bottomRigY, rigWidth, rigHeight);
   
    ////////////////////////////////  OVERALL SIZE ///////////////////////////// 
    // Calculate the overall size of the application by adding the widths and heights of the components
    // still has to be done manually - definatly room for improvement 
    // TODO - add this stuff to the config file!!
    sizeX = shields.wide + tipiLeft.wide + tipiRight.wide + info.wide;
    sizeY = shields.high + megaSeedA.high;
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
void midiSetup() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  String[] inputs = MidiBus.availableInputs();
  //String[] outputs = MidiBus.availableOutputs(); 
  for (String in : inputs){//(int idx=0;idx < inputs.length;idx++){//in : inputs){
    //String in = inputs[idx];
    if (in.contains("TR-8S")) { 
      TR8bus = new MidiBus(this, in,in);
      println("Found TR8: ",in);
    }
    if (in.contains("LPD8")) {
      LPD8bus = new MidiBus(this,in,in);
      println("Found LPD8: ", in);
    }
    if (in.contains("BeatStep")) { 
      beatStepBus = new MidiBus(this,in,in);
      println("Found Arturia BeatStep: ", in);
    }
    if (in.contains("MPD218")) { 
      MPD8bus = new MidiBus(this,in,in);
      println("Found AKAI MPD218: ", in);
    }
  }
  setupMidiActions();
}

//////////////////////////////////////// LOAD IMAGES ///////////////////////////
PImage bar1, flames; 
void loadImages() {
  flames = loadImage("1.jpg");
  bar1 = loadImage("bar1.png");
}
//////////////////////////// AUDIO SETUP ////////////////////////////////////

import processing.sound.*;
AudioIn in;
BeatDetector beatDetect;
float avgvolume, weightedsum, weightedcnt, beatTempo;
void audioSetup(int sensitivity, float beatTempo) {
  // beatTempo affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
    
  in = new AudioIn(this, 0);
  in.start();
  beatDetect = new BeatDetector(this);
  beatDetect.input(in);
  beatDetect.sensitivity(sensitivity);

  weightedsum=0;
  weightedcnt=0;
  avgvolume = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////// SETUP SKETCH DRAWING NORMALS ////////////////////////
void drawingSetup() {
  colorMode(HSB, 360, 100, 100);
  blendMode(ADD);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  noStroke();
  strokeWeight(20);
  //hint(DISABLE_OPTIMIZED_STROKE);
}

PShader blur;
void loadShaders() {
  float blury = int(10);
  blur = loadShader("blur.glsl");
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);
}

void printmd(String content) {
  String[] lines = content.split("\n");

  // Use the relative path to your .md file.
  String filePath = "data/markdown.md";
  saveStrings(filePath, lines);
  println("Markdown file saved!");
}