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
void artNetSetup(){
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
    shields.vizIndex=int(map(dmxData[3], 1, 255, 0, shields.availableAnims.length-1)+0.5);//plus 0.5 rounds rather than truncates
  }
  //DMX attach color
  if (dmxData[0]>0 || dmxData[1]>0 || dmxData[2]>0) {
    shields.c = xcolor(dmxData[0], dmxData[1], dmxData[2]);
    shields.flash = xcolor(dmxData[0],dmxData[1],dmxData[2]);
  }
  //DMX attach trigger
  if (dmxData[7]>0 ) {
    //debounce
    if (triggertimes[7]<millis()+debouncetime) {
      shields.addAnim(shields.availableAnims[shields.vizIndex]);
      triggertimes[7]=millis();
    }
  }
  //DMX attach float
  if (dmxData[8]>0 && false) {
    roof.dimmer = map(dmxData[8], 1, 255, 0, 1);
  }
}

