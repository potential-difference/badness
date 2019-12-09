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
