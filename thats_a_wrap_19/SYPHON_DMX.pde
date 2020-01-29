int xred(int c) {
  return c >> 16 & 0xFF;
}
int xgrn(int c) {
  return c>>8 & 0xFF;
}
int xblu(int c) {
  return c & 0xFF;
}
int xcolor(byte a, byte b, byte c) {
  return (0xff<<24) | ((a&0xff)<<16) | ((b&0xff) << 8) | (c&0xff);
}

ArtNetClient artnet;
byte[] dmxData = new byte[512];
int triggertimes[] = new int[512];
void DMXSetup(){
  artnet = new ArtNetClient();
  artnet.start();
}
void DMXcontrollingUs() {
  int debouncetime=100;
  int subnet=0;
  int universe=0;
  dmxData = artnet.readDmxData(subnet,universe);  
  //attach bits of the code to DMX channels
  //attach to vizIndex
  if (dmxData[4]>0 ) {
    rigg.vizIndex=int(map(dmxData[3], 1, 255, 0, rigg.availableAnims.length-1)+0.5);//plus 0.5 rounds rather than truncates
  }
  //DMX attach color
  if (dmxData[0]>0 || dmxData[1]>0 || dmxData[2]>0) {
    rigg.c = xcolor(dmxData[0], dmxData[1], dmxData[2]);
    rigg.flash = xcolor(dmxData[0],dmxData[1],dmxData[2]);
  }
  //DMX attach trigger
  if (dmxData[7]>0 ) {
    //debounce
    if (triggertimes[7]<millis()+debouncetime) {
      rigg.addAnim(rigg.availableAnims[rigg.vizIndex]);
      triggertimes[7]=millis();
    }
  }
  //DMX attach float
  if (dmxData[8]>0 && false) {
    roof.dimmer = map(dmxData[8], 1, 255, 0, 1);
  }
}


////import codeanticode.syphon.*;
//PGraphics syphonImageReceived, syphonImageSent;
////SyphonClient syphonClient;
////SyphonServer syphonServer;

boolean syphonToggle = false;
/*
void syphonSetup(boolean toggle) {
 if (toggle) {
 HashMap<String, String>[] allServers = SyphonClient.listServers();
 print("Available Syphon servers: ");
 print(allServers);
 if (allServers.length == 0) print("NO Syphon servers avaliable");
 String matt_servname = "MATTS-MACBOOK-PRO.LOCAL (VDMX-NDI® Output 1)";
 //String matt_servname2 = "MATTS-MACBOOK-PRO.LOCAL (VDMX-NDI® Output 2)";
 String matt_appname = "NDISyphon";
 syphonClient = new SyphonClient(this, matt_appname, matt_servname);// create syphon client to receive frames
 //syphonClient2 = new SyphonClient(this, matt_appname, matt_servname2);// create syphon client to receive frames
 
 syphonServer = new SyphonServer(this, "mirrors syphon");   // Create syhpon server to send frames out.
 println();
 syphonImageSent = createGraphics(rigg.wide, rigg.high, P2D);
 syphonImageSent.imageMode(CENTER);
 }
 syphonToggle = false;
 }
 
 
 void syphonLoadSentImage(boolean toggle) {
 if (toggle) {
 syphonImageSent.beginDraw();
 syphonImageSent.background(0);
 syphonImageSent.endDraw();
 if (syphonClient.newFrame()) syphonImageReceived = syphonClient.getGraphics(syphonImageReceived); // load the pixels array with the updated image info (slow)
 }
 }
 
 
 
 void syphonSendImage(boolean toggle) {
 if (toggle) {
 syphonServer.sendImage(syphonImageSent);
 image(syphonImageSent, size.rig.x+112.5, 455, 225, 87.5);
 if (syphonImageReceived != null) image(syphonImageReceived, size.rig.x-112.5, 455, 225, 87.5);
 }
 }
 */
