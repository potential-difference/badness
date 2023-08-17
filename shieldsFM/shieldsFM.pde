PrintWriter output; // Global variable to hold the PrintWriter object

import java.util.*;
import static java.util.Map.entry;  
import java.util.Arrays;
import java.net.*;
import ch.bildspur.artnet.*;
import java.lang.reflect.*;

SizeSettings size;

OPC opcLocal;
OPCGrid opcGrid;
//Gig Specific
ShieldsOPCGrid shieldsGrid;
BoothGrid boothGrid;
Rig shields,tipiLeft,tipiRight,tipiCentre,outsideRoof,outsideGround,booth,megaSeedA,megaSeedB,megaSeedC,cans,roof,uvPars;

ArrayList <Rig> rigs = new ArrayList<Rig>();  
PFont font;

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5 = new OscP5(this,8000);

import themidibus.*;  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep
MidiBus MPD8bus;

boolean onTop = false;
boolean testToggle, smokeToggle;
float boothDimmer=0.5, mixerDimmer=0.5, digDimmer=1.0, vizTime, colorChangeTime, colorSwapSlider, beatSlider = 0.3;
float smokePumpValue, smokeOnTime, smokeOffTime;
float uvDimmer=0.2;
float uvSpeed=0.5;
float uvProgram=0.5;
int colStepper = 1;
int time_since_last_anim=0;

void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size = new SizeSettings();
  size(size.sizeX, size.sizeY, P2D);
}
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
void setup()
{
  surface.setSize(size.sizeX, size.sizeY);
  surface.setAlwaysOnTop(onTop);

  output = createWriter("rig coords.md");
  printmd("## coordinate and position information for each rig"); 

  ///////////////// LOCAL opc /////////////////////
  Map<String,OPC> OPCs = Map.ofEntries(
    entry("BigShield", new WLED(this, "192.168.10.10", 21324)),
    entry("SmallShieldA", new WLED(this, "192.168.10.11", 21324)),    //bottom right
    entry("MedShieldA", new WLED(this, "192.168.10.12", 21324)),
    entry("SmallShieldB", new WLED(this, "192.168.10.13", 21324)),    // bottom left
    entry("MedShieldB", new WLED(this, "192.168.10.14", 21324)),
    entry("SmallShieldC", new WLED(this, "192.168.10.15", 21324)),    // top
    entry("MedShieldC", new WLED(this, "192.168.10.16", 21324)),      // c/f       
    entry("Entec",new OPC(this,"192.168.10.5",7890)),                 // benjamins laptop  

    entry("LunchBox1",new WLED(this,"192.168.10.21",21324)),
    //A:19 B:18 C:17 D:16 E:4

    entry("LunchBox2",new WLED(this,"192.168.10.22",21324)),
    //A:19 B:18 C:17 D:16 E:4

    entry("LunchBox3",new WLED(this,"192.168.10.23",21324)),
    //A:12 B:14 C:27 D:26 E:25

    entry("megaSeedA",new WLED(this,"192.168.10.30",21324)),
    entry("megaSeedB",new WLED(this,"192.168.10.31",21324)),
    entry("megaSeedC",new WLED(this,"192.168.10.32",21324))

  );

  Map<String,PixelMapping> channels = Map.ofEntries(
    // document this: ("stringOne","LunchBox1",0,new int[] {1,1,1})
    // TODO is there a better way to do this? there are a lot of the same variable...
   
    entry("pix0",new PixelMapping("pix0","LunchBox1",00,new int[]{1})),  // A 
    entry("pix1",new PixelMapping("pix1","LunchBox1",10,new int[]{1})),  // B
    entry("pix2",new PixelMapping("pix2","LunchBox1",20,new int[]{1})),  // C
    entry("pix3",new PixelMapping("pix3","LunchBox1",30,new int[]{1})),  // D
    entry("pix4",new PixelMapping("pix4","LunchBox1",40,new int[]{1})),  // E
    entry("pix5",new PixelMapping("pix5","LunchBox1",50,new int[]{1})),  // F
    entry("pix6",new PixelMapping("pix6","LunchBox1",60,new int[]{1})),  // G
    entry("pix7",new PixelMapping("pix7","LunchBox1",70,new int[]{1})),  // H
    entry("pix8",new PixelMapping("pix8","LunchBox1",80,new int[]{1})),  // I

    entry("pix9", new PixelMapping("pix9", "LunchBox2",00,new int[]{1})),  // A
    entry("pix10",new PixelMapping("pix10","LunchBox2",10,new int[]{1})),  // B
    entry("pix11",new PixelMapping("pix11","LunchBox2",20,new int[]{1})),  // C
    entry("pix12",new PixelMapping("pix12","LunchBox2",30,new int[]{1})),  // D
    entry("pix13",new PixelMapping("pix13","LunchBox2",40,new int[]{1})),  // E
    entry("pix14",new PixelMapping("pix14","LunchBox2",50,new int[]{1})),  // F
    entry("pix15",new PixelMapping("pix15","LunchBox2",60,new int[]{1})),  // G
    entry("pix16",new PixelMapping("pix16","LunchBox2",70,new int[]{1})),  // H
    entry("pix17",new PixelMapping("pix17","LunchBox2",80,new int[]{1})),  // I

    entry("pix18",new PixelMapping("pix18","LunchBox3",00,new int[]{1})),  // A
    entry("pix19",new PixelMapping("pix19","LunchBox3",10,new int[]{1})),  // B
    entry("pix20",new PixelMapping("pix20","LunchBox3",20,new int[]{1})),  // C
    entry("pix21",new PixelMapping("pix21","LunchBox3",30,new int[]{1})),  // D
    entry("pix22",new PixelMapping("pix22","LunchBox3",40,new int[]{1})),  // E
    entry("pix23",new PixelMapping("pix23","LunchBox3",50,new int[]{1})),  // F
    entry("pix24",new PixelMapping("pix24","LunchBox3",60,new int[]{1})),  // G
    entry("pix25",new PixelMapping("pix25","LunchBox3",70,new int[]{1})),  // H
    entry("pix26",new PixelMapping("pix26","LunchBox3",80,new int[]{1})),  // I

    entry("stringEight",new PixelMapping("stringEight","LunchBox3",100,new int[]{1,1,1})),
    entry("stringNine",new PixelMapping("stringNine","LunchBox3",200,new int[]{1,1,1})),

    entry("barleft", new PixelMapping("barleft","LunchBox3",300,new int[]{1})),
    entry("barmid", new PixelMapping("barmid","LunchBox3",400,new int[]{1})),
    entry("barright", new PixelMapping("barright","LunchBox3",500,new int[]{1}))
  );
  shields = new Rig(size.shields, RigType.Shields);
  shields.opcgrid = new ShieldsOPCGrid(shields);
  ((ShieldsOPCGrid)(shields.opcgrid)).bigTriangleShieldsOPC(OPCs); 

  boothGrid = new BoothGrid(OPCs);

  // new rigs need to be iniciated inside RIG.pde too
  megaSeedA = new Rig(size.megaSeedA,RigType.MegaSeedA);
  megaSeedA.opcgrid = new MegaSeedAGrid(megaSeedA,OPCs);
  megaSeedB = new Rig(size.megaSeedB,RigType.MegaSeedB);
  megaSeedB.opcgrid = new MegaSeedBGrid(megaSeedB,OPCs);
  megaSeedC = new Rig(size.megaSeedC,RigType.MegaSeedC);
  megaSeedC.opcgrid = new MegaSeedCGrid(megaSeedC,OPCs);

  outsideRoof = new Rig(size.outsideRoof, RigType.OutsideRoof);   // add size. inside size settings
                  // Blue class needs to be added to RigType ENUM in RIG.pde
  outsideRoof.opcgrid = new OutsideRoofGrid(outsideRoof,OPCs);  // add the blue CLASS in OPC_GRID.pde

  outsideGround = new Rig(size.outsideGround, // add size. inside size settings
  RigType.OutsideGround);                     // Blue class needs to be added to RigType ENUM in RIG.pde
  outsideGround.opcgrid = new OutsideGroundGrid(outsideGround,OPCs);  // add the blue CLASS in OPC_GRID.pde

  uvPars = new Rig(size.uvPars,RigType.UvPars);
  uvPars.opcgrid = new UvParsGrid(uvPars,OPCs);

  tipiLeft = new Rig(size.tipiLeft,RigType.TipiLeft);
  String tipiLeftChannels[] = {"pix0","pix1","pix2","pix3","pix4","pix5","pix6","pix7","pix8"};
  tipiLeft.opcgrid = new CircularRoofGrid(tipiLeft,OPCs,channels,tipiLeftChannels);

  tipiRight = new Rig(size.tipiRight,RigType.TipiRight);
  String tipiRightChannels[] = {"pix9","pix10","pix11","pix12","pix13","pix14","pix15","pix16","pix17"};
  tipiRight.opcgrid = new CircularRoofGrid(tipiRight,OPCs,channels,tipiRightChannels);

  tipiCentre = new Rig(size.tipiCentre,RigType.TipiCentre);
  String tipiCentreChannels[] = {"pix18","pix19","pix20","pix21","pix22","pix23","pix24","pix25","pix26"};
  tipiCentre.opcgrid = new CircularRoofGrid(tipiCentre,OPCs,channels,tipiCentreChannels);

  bar = new Rig(size.bar,RigType.Bar);
  String barunits[] = {"barleft","barmid","barright"};

  audioSetup(100, 0.2); ///// AUDIO SETUP - sensitivity, beatTempo /////
  midiSetup();
  drawingSetup();
  loadImages();
  loadShaders();
  alwaysDoFirst();
 
  for (Rig rig : rigs) setupLocalCoords(rig); // rig.pixelPosition used to store pixel coords in rig grid space
  for (Rig rig : rigs) markDownInfo(rig);     // print all rig info to md file.
  for(Rig rig : rigs) println(rig.type+" "+rig.pixelPosition); // print all rig into to termial
  output.flush(); // Flush the output to ensure all data is written to the file
  output.close(); // Close the PrintWriter object
  
  frameRate(30); // always needs to be last in setup
}
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
void draw()
{
  int start_time = millis();
  surface.setAlwaysOnTop(onTop);
  background(0);
  noStroke();
  beats(beatSlider);   
  //pause(10);           ////// number of seconds before no music detected and auto kicks in
  globalFunctions();
  
  
  if (frameCount > 10) playWithYourself(vizTime);
  // TODO made a global variable class to include these and alpha and funcs
  c = rigs.get(0).c;
  flash = rigs.get(0).flash;
  c1 = rigs.get(0).c1;
  flash1 = rigs.get(0).flash1;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////// PLAY WITH ME ////////////////////////////////////////////////////////////
  playWithMe();
  if (beatTrigger) { 
    
    for (Rig rig : rigs) {
        //if (testToggle) rig.animations.add(new Test(rig));

      rig.beatTriggered = true;
      rig.addAnim(rig.vizIndex);  // create a new anim object and add it to the beginning of the arrayList
        
      }
  }

  if (keyT['s']) for (Anim anim : shields.animations)  anim.funcFX = 1-(stutter*noize1*0.1);
 
  //////////////////// Must be after playwithme, before rig.draw() //////////////////////////////////////////////////////
  for (Rig rig : rigs) rig.draw();  
  ///////////////////////////////////////////// PLAY WITH ME MORE ///////////////////////////////////////////////////////
  playWithMeMore();
  ///////////////////////////////////////////// BOOTH & DIG /////////////////////////////////////////////////////////////
  boothLights(boothGrid);
  ///////////////////////////////////////////// UV BATONS FM22 //////////////////////////////////////////////////////////
  // uvBatons(boothGrid);
  ///////////////////////////////////////////// BLINDERS FM22 ///////////////////////////////////////////////////////////
  // blinders(boothGrid);
  ///////////////////////////////////////////// DISPLAY //////////////////////////////////////////////////////////////////
  testColors(keyT['t']);
  ///////////////////////////////////////////// !!!SMOKE!!! //////////////////////////////////////////////////////////////
  //dmxSmoke();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  mouseCircle(keyT['q']);
  onScreenInfo();
  pauseInfo();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// THE END ///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
