OPC opc;
OPC opcLocal;
OPC opcMirror1; 
OPC opcMirror2;
OPC opcSeeds;
OPC opcCans;
OPC opcControllerA;
OPC opcControllerB;

SizeSettings size = new SizeSettings();
OPCGrid grid = new OPCGrid();

import themidibus.*;  
MidiBus TR8bus;       // midibus for TR8
MidiBus faderBus;     // midibus for APC mini
MidiBus LPD8bus;      // midibus for LPD8

import codeanticode.syphon.*;
PImage syphonImage;
SyphonClient client;

void settings() {
  size(size.sizeX, size.sizeY, P2D);
}

void setup()
{
  /// size moved to settings - see above
  //surface.setAlwaysOnTop(true);
  size.surfacePositionX = 720;
  size.surfacePositionY = 200;
  surface.setLocation(size.surfacePositionX, size.surfacePositionY);
  surface.setAlwaysOnTop(false);

  ///////////////// LOCAL opc /////////////////////
  //opc = new OPC(this, "127.0.0.1", 7890);            // Connect to the local instance of fcserver - MIRRORS
  //opcMirror1 = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRROR 1 - used coz of issues with the remote conneciton
  //opcMirror2 = new OPC(this, "127.0.0.1", 7890);       // Connect to the local instance of fcserver - MIRROR 1 - used coz of issues with the remote conneciton
  opcSeeds = new OPC(this, "127.0.0.1", 7890);         // Connect to the remote instance of fcserver - SEEDS BOX IN ROOF - also had issues with this one so had to remove it
  opcCans = new OPC(this, "127.0.0.1", 7890);          // Connect to the remote instance of fcserver - CANS BOX
  //opcControllerA = new OPC(this, "127.0.0.1", 7890);   // Connect to the remote instance of fcserver - LEFT TWO CONTROLLERS
  //opcControllerB = new OPC(this, "127.0.0.1", 7890);   // Connect to the remote instance of fcserver - RIGHT PAIR OF CONTROLLERS

  ///////////////// OPC over NETWORK /////////////////////
  opcMirror1 = new OPC(this, "192.168.0.70", 7890);       // Connect to the remote instance of fcserver - MIRROR 1
  //opcMirror2 = new OPC(this, "192.168.0.5", 7890);      // Connect to the remote instance of fcserver - MIRROR 2
  //opcCans = new OPC(this, "10.168.1.86", 7890);          // Connect to the remote instance of fcserver - CANS BOX
  opcSeeds = new OPC(this, "192.168.0.20", 7890);           // Connect to the remote instance of fcserver - SEEDS BOX IN ROOF - also had issues with this one so had to remove it
  opcControllerA = new OPC(this, "192.168.0.80", 7890);   // Connect to the remote instance of fcserver - LEFT TWO CONTROLLERS
  //opcControllerB = new OPC(this, "10.168.1.89", 7890);   // Connect to the remote instance of fcserver - RIGHT PAIR OF CONTROLLERS

  grid.kallidaMirrors(opcMirror1, opcMirror1, 0);               // grids 0-3 MIX IT UPPPPP 
  grid.kallidaCans(opcCans);                                  
  grid.kallidaUV(opcCans);
  grid.kallidaSeeds(opcSeeds);
  grid.kallidaControllers(opcControllerA, opcControllerA, 2);   // grids 0-3 MIX IT UPPPPP 

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  TR8bus = new MidiBus(this, "TR-8S", "TR8-S"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  LPD8bus = new MidiBus(this, "LPD8", "LPD8"); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  controlFrame = new ControlFrame(this, width, 130, "Controls"); // load control frame must come after shild ring etc

  blur = loadShader("blur.glsl");
  loadShaders(10);

  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75;
  cc[6] = 0.75;
  cc[8] = 1;
  
   // List Syphon Clients
  println("Available Syphon servers:");
  println(SyphonClient.listServers());

  // Create syhpon client to receive frames
  // from the first available running server: 
  client = new SyphonClient(this);

  println("Press ESC to exit, d to list the connected server.\n");
  frameRate(30);
}

void draw()
{
  background(0);
  if (client.newFrame()) {
    syphonImage = client.getImage(syphonImage);
    if (syphonImage != null) {
      image(syphonImage, 0, 0, syphonImage.width, syphonImage.height);
    }
  }
}
