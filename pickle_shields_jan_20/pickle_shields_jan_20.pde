OPC opcLocal, opcMirror1, opcMirror2, opcNode4, opcNode3, opcNode6, opcNode7, opcWifi, opcNode1;
WLED wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls, wledSeedsA, wledSeedsB;

import java.util.*;
import controlP5.*;
import ch.bildspur.artnet.*;
ControlP5 main_cp5;

boolean SHITTYLAPTOP = false;//false;

final int PORTRAIT = 0;
final int LANDSCAPE = 1;
final int SHIELDS = 3;
final int RIG = 0;
final int ROOF = 1;

SizeSettings size;
OPCGrid opcGrid;
ShieldsOPCGrid shieldsGrid;
ControlFrame controlFrame, sliderFrame;

Rig rigg, roof, cans, mirrors, strips, donut, seeds, pars;
ArrayList <Rig> rigs = new ArrayList<Rig>();  
PFont font;

import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import themidibus.*;  
MidiBus TR8bus;           // midibus for TR8
MidiBus faderBus;         // midibus for APC mini
MidiBus LPD8bus;          // midibus for LPD8
MidiBus beatStepBus;      // midibus for Artuia BeatStep

String controlFrameValues, sliderFrameValues, mainFrameValues;

boolean onTop = false;
boolean MCFinitialized, SFinitialized;
void settings() {
    System.setProperty("jogl.disable.openglcore", "true");
    size = new SizeSettings(SHIELDS);
    size(size.sizeX, size.sizeY, P2D);
    // *** TO DO *** // figure out why this is not working 
    size.surfacePositionX = 900;
    if (SHITTYLAPTOP) size.surfacePositionX = 0;
    size.surfacePositionY = 80;
}
void setup()
{
    surface.setSize(size.sizeX, size.sizeY);
    surface.setAlwaysOnTop(onTop);
    /*
    printArray( PFont.list() ); //_______ list all available fonts
    font = createFont("Liberation Sans Narrow Bold Italic", 18); //_ select a font
    textFont(font); //___________________ set font for text function
    */
    //surface.setLocation(size.surfacePositionX, size.surfacePositionY);
    MCFinitialized = false;
    controlFrame = new MainControlFrame(this, width, 380, size.surfacePositionX, size.surfacePositionY + height + 5); // load control frame must come after shild ring etc
    opcGrid = new OPCGrid();
    
    //order of these is important for layout of sliders
    print("MainControlFrame");
    while(!MCFinitialized) {
        delay(100);
        print(".");
    }
    println(".");
    
    int frameWidth = 220;
    SFinitialized = false;
    sliderFrame = new SliderFrame(this, frameWidth, 560, size.surfacePositionX - frameWidth - 5, size.surfacePositionY); // load control frame must come after shild ring etc
    
    print("SliderFrame");
    //wait for MCF,SF to be initialized
    while(!SFinitialized) {
        delay(100);
        print(".");
    }
    println(".");
    ///////////////// LOCAL opc /////////////////////
    opcLocal = new OPC(this, "127.0.0.1", 7890);        // Connect to the local instance of fcserver - MIRRORS
    
    wledBigShield = new WLED(this, "192.168.10.10", 21324);
    wledShieldA = new WLED(this, "192.168.10.11", 21324);
    wledShieldB = new WLED(this, "192.168.10.12", 21324);
    wledShieldC = new WLED(this, "192.168.10.13", 21324);
    wledShieldD = new WLED(this, "192.168.10.14", 21324);
    wledShieldE = new WLED(this, "192.168.10.15", 21324);
    wledShieldF = new WLED(this, "192.168.10.16", 21324);
    wledBalls   = new WLED(this, "192.168.10.17", 21324);
    
    wledSeedsA   = new WLED(this, "192.168.10.20", 21324);
    wledSeedsB   = new WLED(this, "192.168.10.21", 21324);


    

    ///////////////// OPC over NETWORK /////////////////////
    //opcMirror1 = new OPC(this, "192.168.10.2", 7890);     // left hand mirror
    //opcMirror2 = new OPC(this, "192.168.10.5", 7890);     // right hand mirror
    opcNode4 = new OPC(this, "192.168.10.211", 7890);       // NODE IN THE SHIELDS BOX
    opcNode3 = new OPC(this, "192.168.10.3", 7890);         // NODE IN CANS BOX
    opcNode7 = new OPC(this, "192.168.10.7", 7890);         // NODE IN LANTERNS BOX 
    
    opcNode1 = new OPC(this, "192.168.8.1", 7890);         // NODE IN LANTERNS BOX 

    //int numberOfPars;
    //opcGrid.dmxParsOPC(pars, opcLocal, numberOfPars = 6);   // ENTTEC BOX PLUGGED INTO LAPTOP VIZ USB - run json locally - pars DMX address 1,5,9,13,17,21
    //opcGrid.dmxSmokeOPC(opcLocal);                          // ENTTEC BOX PLUGGED INTO LAPTOP VIZ USB - run json locally - smoke machine DMX address 100
    
    shieldsGrid = new ShieldsOPCGrid(rigg);  
    
    OPC[] shieldOPCs = {wledBigShield, wledShieldA, wledShieldB, wledShieldC, wledShieldD, wledShieldE, wledShieldF, wledBalls};
    //shieldsGridOPCs = {opcLocal, opcLocal, opcLocal, opcLocal, opcLocal, opcLocal, opcLocal, opcLocal};
    
   shieldsGrid.spiralShieldsOPC(shieldOPCs);        // SHIELDS plug into RIGHT SLOTS A-F = 1-6 *** BIG SHIELD = 7 *** H-G = LEFT SLOTS 0-2 ***
    opcGrid.standAloneBoothOPC(opcLocal);                      // BOOTH and DIG lights plug into SHIELDS BOX LEFT slots: booth 3 & 5, dig 4 & 5 or use splitter joiners
    
    // *** PUT ALL THE ROOF GRIDS ETC HERE *** //
    if (roof!= null) {
        // each lantern plugged into its own slot on the box, 0 - 7
         opcGrid.pickleCansOPC(roof, opcNode1);    
    } 
    
    // *** PUT ALL THE CANS GRIDS ETC HERE *** //
    if (cans!= null) {
        opcGrid.eggsOPC(opcLocal, cans);
        //opcGrid.pickleLanternsDaisyChain(cans, opcNode3, fadecandy = 10);  
        // one chain starting at slot 0 on the box - see function if you need to add another chain  
    } 
    
    
    audioSetup(100); ///// AUDIO SETUP - sensitivity /////
    midiSetup();
    drawingSetup();
    loadImages();
    loadShaders();
    setupSpecifics();
    //syphonSetup(syphonToggle);
    //artNetSetup();
    
    controlFrameValues = sketchPath("cp5ControlFrameValues");
    sliderFrameValues  = sketchPath("cp5SliderFrameValues");
    //mainFrameValues  = sketchPath("cp5MainFrameValues");
    try {
        controlFrame.cp5.loadProperties(controlFrameValues);
        sliderFrame.cp5.loadProperties(sliderFrameValues);
    }
    catch(Exception e) {
        println(e);
        println("*** !!PROBABLY NO PROPERTIES FILE!! ***");
    }
   
    frameRate(30); // always needs to be last in setup
}
int colStepper = 1;
int time_since_last_anim = 0;
void draw()
    {
    int start_time = millis();
    surface.setAlwaysOnTop(onTop);
    background(0);
    noStroke();
    beatDetect.detect(in.mix);
    beats();
    //pause(10);            ////// number of seconds before no music detected and auto kicks in
    globalFunctions();
    //syphonLoadSentImage(syphonToggle);
    
    if (frameCount > 10) playWithYourself(vizTime * 60);
    c = rigg.c;
    flash = rigg.flash;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    playWithMe();
    if (beatTrigger) { 
        for (Rig rig : rigs) {
            if (rig.toggle) {
                //if (testToggle) rig.animations.add(new Test(rig));
                //println(rig.name+" vizIndex", rig.vizIndex);
                rig.addAnim(rig.vizIndex);           // create a new anim object and add it to the beginning of the arrayList
            }
        }
    }
    
    if (keyT['s']) for (Anim anim : rigg.animations)  anim.funcFX = 1 - (stutter * noize1 * 0.1);
    //////////////////////////////////////////// Artnet  /////////////
    //DMXcontrollingUs();
    //////////////////// Must be after playwithme, before rig.draw()////
    
    for (Rig rig : rigs) rig.draw();  
    
    //////////////////////////////////////////// PLAY WITH ME MORE /////////////////////////////////////////////////////////////////////////////////
    playWithMeMore();
    
    //////////////////////////////////////////// BOOTH & DIG ///////////////////////////////////////////////////////////////////////////////////////
    boothLights();
    //////////////////////////////////////////// DISPLAY ///////////////////////////////////////////////////////////////////////////////////////////
    workLights(keyT['w']);
    testColors(keyT['t']);
    //////////////////////////////////////////// !!!SMOKE!!! ///////////////////////////////////////////////////////////////////////////////////////
    //dmxSmoke();
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    mouseInfo(keyT['q']);
    frameRateInfo(5, 20);               // display frame rate X, Y /////
    dividerLines();
    //gid.mirrorTest(false);            // true to test physical mirror orientation
    //syphonSendImage(syphonToggle);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
