import java.util.function.Function;
//OPC GRID
//contains points of interest in whole-window coords
//and all the OPC objects relevant.
//A rig generally encapsulates an opcgrid 
//but for the misc stuff (booth,smoke,etc)
//they just get drawn to the screen
//and we handle it with rects.
class OPCGrid{
  Map<String,OPC> opclist;
  String opcGridInfo;
  OPCGrid(){}
}

class BoothGrid extends OPCGrid{
  PVector smoke[][] = new PVector[2][2];
  Coord smokePump,smokeFan;
  PVector uvs[][] = new PVector[6][3];
  PVector blins[] = new PVector[4];
  Coord uvDimmer,uvSpeed,uvProgram;
  Coord booth,dig,mixer,blinders;
  BoothGrid(Map<String,OPC> opcnodes){
    opclist = opcnodes;
    ////////////////////////// BOOTH, DIG, MIXER LIGHTS /////////////////////
    booth = new Coord(size.booth.x-size.booth.wide/2+35,size.booth.y-size.booth.high/2+20,30,15);
    dig = new Coord(booth.x,booth.y+20,booth.wide,booth.high);
    mixer = new Coord(dig.x, dig.y+20,dig.wide,dig.high);
    OPC boothopc = opcnodes.get("LunchBox1");
    boothopc.led(0,int(booth.x-5),int(booth.y));
    boothopc.led(200,int(booth.x+5),int(booth.y));
    boothopc.led(100,int(mixer.x),int(mixer.y));
    boothopc.led(300,int(dig.x),int(dig.y));
  }
}

// TODO set this up correctly for FM23
class UvParsGrid extends OPCGrid{
  Rig rig;
  //PVector centre;
  UvParsGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    // left tipi
    opcnodes.get("Entec").led(0,size.uvPars.x-15,size.uvPars.y);
    opcnodes.get("Entec").led(1,size.uvPars.x-10,size.uvPars.y);
    opcnodes.get("Entec").led(2,size.uvPars.x-5,size.uvPars.y);
    // right tipi
    opcnodes.get("Entec").led(3,size.uvPars.x+5,size.uvPars.y);
    opcnodes.get("Entec").led(4,size.uvPars.x+10,size.uvPars.y);
    opcnodes.get("Entec").led(5,size.uvPars.x+15,size.uvPars.y);
    /*// 
    opcnodes.get("Entec").led(6,size.uvPars.x-5,size.uvPars.y);
    opcnodes.get("Entec").led(7,size.uvPars.x+5,size.uvPars.y);
    opcnodes.get("Entec").led(8,size.uvPars.x+10,size.uvPars.y);
    opcnodes.get("Entec").led(9,size.uvPars.x+15,size.uvPars.y);
    */
  }
}
/*
 ///////////////////////// DMX UV BATONS /////////////////////////////////
    OPC entec = opcnodes.get("Entec");
    // FOUR LAMPS LAID OUT VERTICALY - EACH LAMP HAS 3 CHANNELS, DIMMER, SPEED, PROGRAM
    int x = int(mixer.x);           // CHANGES THE X POSITION OF THE BATONS
    int y = int(mixer.y+40);        // CHANGES THE Y POSITION OF THE BATONS
    int xgap = 10;
    int ygap = 10;
    for (int i=0;i<6;i++){
      for (int j=0;j<3;j++){
        int xx = x+j*xgap;
        int yy = y+i*ygap;
        uvs[i][j] = new PVector(xx,yy);
        entec.led(8000+j+3*i,xx,yy);
      }
    }
    float dimx = uvs[0][0].x;
    float spdx = uvs[0][1].x;
    float pgmx = uvs[0][2].x;
    float dimy = 0.5*(uvs[2][0].y + uvs[3][0].y);
    float spdy = 0.5*(uvs[2][1].y + uvs[3][1].y);
    float pgmy = 0.5*(uvs[2][2].y + uvs[3][2].y);
    float uvwide = xgap - 2;
    float uvhigh = ygap * 7;
    uvDimmer = new Coord(dimx,dimy,uvwide,uvhigh);
    uvSpeed = new Coord(spdx,spdy,uvwide,uvhigh);
    uvProgram = new Coord(pgmx,pgmy,uvwide,uvhigh);
*/

// TODO is there a better way of doing this so rigs can be an array list and more easily added?!
class MegaSeedAGrid extends OPCGrid{
  Rig rig;
  MegaSeedAGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("megaSeedA").led(0,size.megaSeedA.x,size.megaSeedA.y);           // rgb 100w
    opcnodes.get("megaSeedA").led(1,size.megaSeedA.x-20,size.megaSeedA.y);        // white 100w 
    opcnodes.get("megaSeedA").led(2,size.megaSeedA.x+20,size.megaSeedA.y);        // FILLAMENT spiral - GPIO 14
    PVector pv = new PVector(size.megaSeedA.x, size.megaSeedA.y);
    rig.pixelPosition.add(pv); // adding global coords to pixelPosition ArrayList
  }
}

class MegaSeedBGrid extends OPCGrid{
  Rig rig;
  MegaSeedBGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("megaSeedB").led(0,size.megaSeedB.x,size.megaSeedB.y);           // rgb 100w
    opcnodes.get("megaSeedB").led(1,size.megaSeedB.x-20,size.megaSeedB.y);        // white 100w 
    opcnodes.get("megaSeedB").led(2,size.megaSeedB.x+20,size.megaSeedB.y);        // FILLAMENT spiral - GPIO 14

    PVector pv = new PVector(size.megaSeedB.x, size.megaSeedB.y);
    rig.pixelPosition.add(pv); // adding global coords to pixelPosition ArrayList
  }
}

class MegaSeedCGrid extends OPCGrid{
  Rig rig;
  MegaSeedCGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("megaSeedC").led(0,size.megaSeedC.x,size.megaSeedC.y);           // rgb 100w
    opcnodes.get("megaSeedC").led(1,size.megaSeedC.x-20,size.megaSeedC.y);        // white 100w 
    opcnodes.get("megaSeedC").led(2,size.megaSeedC.x+20,size.megaSeedC.y);        // FILLAMENT spiral - GPIO 14

    // TODO add ring of 12v RGB leds to grid, led# 1-100
    // opcnodes.get("megaSeedC").led(1,size.megaSeedC.x+20,size.megaSeedC.y);        

    PVector pv = new PVector(size.megaSeedC.x, size.megaSeedC.y);
    rig.pixelPosition.add(pv); // adding global coords to pixelPosition ArrayList
  }
}

class OutsideRoofGrid extends OPCGrid{
  Rig rig;
  OutsideRoofGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("outsideRoof").led(0,size.outsideRoof.x,size.outsideRoof.y);           // rgb 100w
    opcnodes.get("outsideRoof").led(1,size.outsideRoof.x-20,size.outsideRoof.y);        // white 100w 
    opcnodes.get("outsideRoof").led(2,size.outsideRoof.x+20,size.outsideRoof.y);        // FILLAMENT spiral - GPIO 14
    PVector pv = new PVector(size.outsideRoof.x, size.outsideRoof.y);
    rig.pixelPosition.add(pv); // adding global coords to pixelPosition ArrayList
  }
}

class OutsideGroundGrid extends OPCGrid{
  Rig rig;
  OutsideGroundGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("outsideGround").led(0,size.outsideGround.x,size.outsideGround.y);           // rgb 100w
    opcnodes.get("outsideGround").led(1,size.outsideGround.x-20,size.outsideGround.y);        // white 100w 
    opcnodes.get("outsideGround").led(2,size.outsideGround.x+20,size.outsideGround.y);        // FILLAMENT spiral - GPIO 14
    PVector pv = new PVector(size.outsideGround.x, size.outsideGround.y);
    rig.pixelPosition.add(pv); // adding global coords to pixelPosition ArrayList
  }
}


class PixelMapping{
  String opcname;
  int start_pixel;
  int pixelcounts[];
  String unitname;
  PixelMapping(String name,String opcn,int stpix,int[] pixcounts){
    unitname = name;
    opcname = opcn;
    start_pixel = stpix;
    pixelcounts = pixcounts;
  }
}
int sum(int[] ints){
  int result=0;
  for (int i:ints){
    result += i;
  }
  return result;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
class CircularRoofGrid extends OPCGrid {
  Rig rig;
  CircularRoofGrid(Rig _rig,Map<String,OPC> opcnodes,Map<String,PixelMapping> channels,String[] channelnames){
    rig = _rig;
     // set radius of the circle of pixels
    float radius = float(rig.size.wide / 3);

    int nchannels = channelnames.length; // number of strings in the rig, doesnt have to be from the same ESP
    //we need to know how many total pixels there are
    // and with that we calculate where each one gets placed
    int total_pixels = 0;
    for(int i=0;i<nchannels;i++){
      PixelMapping channel = channels.get(channelnames[i]);
      total_pixels += channel.pixelcounts.length;
    }
    float angle_delta = TWO_PI / total_pixels;
    //a lambda that, given a pixel number, gives us an xy coordiante
    Function<Integer,PVector> coords = (Integer i) -> {
      float center_x = rig.size.x;
      float center_y = rig.size.y;
      return new PVector(sin(i*angle_delta)*radius+center_x,cos(i*angle_delta)*radius+center_y);
    };
    
    StringBuilder sb = new StringBuilder();
    int all_pixel_number = 0;
    for (int i=0;i<nchannels;i++){
      println("setting up "+channelnames[i]+": "+channelnames.length+" pixel strings in the rig");
      PixelMapping channel = channels.get(channelnames[i]);
      OPC opc = opcnodes.get(channel.opcname);
      int pixelnumber=channel.start_pixel;
      boolean reverse = true;
      //channel.pixelcounts.length = number of pixels in the string
      
      //rig specific math
      for (int j=0;j<channel.pixelcounts.length;j++){
        int npixels=channel.pixelcounts[j];
        for (int k=0; k<npixels;k++){
          PVector pv = coords.apply(all_pixel_number);  
          opc.led(pixelnumber,int(pv.x),int(pv.y));
          // adding opc postions to array list
          rig.pixelPosition.add(pv); 
          // print the info and coordinates
          // TODO implement this into the other rigs
          String pixeln = "lantern["+all_pixel_number+"] "; // the physical pixel in the space eg 0-9
          String channeln = "channel["+i+"] ";              // the physical output the string is plugged into on the box
          String wledn = "led #["+pixelnumber+"] ";         // which pixel is specified on WLED eg 0,1,2,100,101,102 etc
          String global = "global coords: "+pv.x + "  " + pv.y;
          String info = pixeln+channeln+wledn+global;
          sb.append(info).append("\n");          // TODO printed at the end of the setup
          
          // printmd(info); // 

          pixelnumber++;      // which pixel is specified on WLED eg 0,1,2,100,101,102 etc
          all_pixel_number++; // the physical pixel in the space eg 0-9 
        }
      }
    }
    rig.opcgridinfo = sb.toString();
    println(rig.type + " " + rig.opcgridinfo);
  }
}
 ////////////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////////

class ShieldsOPCGrid extends OPCGrid {
  //  PVectors for positions of shields
  PVector[][] _shield; // = new PVector[numberOfShields][numberOfRings];    
  PVector smallShieldA,medShieldA,smallShieldB,medShieldB,smallShieldC,medShieldC,bigShield,ballA,ballB,ballC;
  PVector[][] shield; // = new PVector[numberOfPositions][numberOfRings];  
  PVector[] shields = new PVector[9];
  //positions = new ArrayList<PVector>();
  float[] ringSize;
  Rig rig;
  float bigShieldRad, medShieldRad, smallShieldRad, _bigShieldRad, _medShieldRad, _smallShieldRad;

  ShieldsOPCGrid(Rig _rig) {
    rig = _rig;

    _bigShieldRad = rig.wide/64*7;       
    bigShieldRad = _bigShieldRad * 2 + 6;

    _smallShieldRad = rig.wide/2/48*5.12; 
    smallShieldRad = _smallShieldRad * 2 + 6; 

    _medShieldRad = rig.wide/2/32*5.12;
    medShieldRad = _medShieldRad * 2 + 6;
  }
  void shieldSetup(int _numberOfPositions) {
    float xpos, ypos;
    int numberOfRings = 3;
    _shield = new PVector[_numberOfPositions][numberOfRings];    
    for (int o = 0; o < ringSize.length; o ++) {
      for (int i = 0; i < _numberOfPositions; i++) {    
        xpos = int(sin(radians((i)*360/_numberOfPositions))*ringSize[o]*2)+rig.size.x;
        ypos = int(cos(radians((i)*360/_numberOfPositions))*ringSize[o]*2)+rig.size.y;
        _shield[i][o] = new PVector (xpos, ypos);
      }
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  void bigTriangleShieldsOPC(Map<String,OPC> _opc) {
    opclist = _opc;
    ringSize = new float[] { rig.wide/9, rig.wide/5, rig.wide/4.5 };
    shieldSetup(18);
    // SHIELDS - #1 shield address; #2 position on ring; #3 which ring 

    // Small Shield A is RIGHT of the RIG
    int pos = 3;
    int ring = 0;
    smallShieldWLED(opclist.get("SmallShieldA"), pos, ring);
    smallShieldA = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[0] = smallShieldA;


    // Med Shield A is RIGHT of the RIG
    ring = 1;
    medShieldWLED(opclist.get("MedShieldA"), pos, ring);
    medShieldA = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[1] = medShieldA;

    // Small Shield B is RIGHT of the RIG
    pos = 15;
    ring = 0;
    smallShieldWLED(opclist.get("SmallShieldB"), pos, ring);
    smallShieldB = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[2] = smallShieldB;

    // Med Shield B is RIGHT of the RIG
    ring = 1;
    medShieldWLED(opclist.get("MedShieldB"), pos, ring);
    medShieldB = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[3] = medShieldB;
    
    // Small Shield C is TOP of the rig
    pos = 9;
    ring = 0;
    smallShieldWLED(opclist.get("SmallShieldC"), pos, ring);
    smallShieldC = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[4] = smallShieldC;

    // Med Shield C is TOP of the rig
    ring = 1;
    medShieldWLED(opclist.get("MedShieldC"), pos, ring);
    medShieldC = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[5] = medShieldC;

    // Big Shield - Ball A, Ball B, Ball C
    bigShieldWLED(opclist.get("BigShield"), int(size.shields.x), int(size.shields.y));
    
    // ball A is LEFT of the rig 
    ring = 0;
    pos = 12; 
    ballGrid(opclist.get("BigShield"), 0, pos, ring);
    ballA = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[6] = ballA;
    // ball B is BOTTOM of the rig 
    pos = 0; 
    ballGrid(opclist.get("BigShield"), 1, pos, ring);
    ballB = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[7] = ballB;
    // ball C is RIGHT of rig
    pos = 6;
    ballGrid(opclist.get("BigShield"), 2, pos, ring);
    ballC = new PVector(_shield[pos][ring].x, _shield[pos][ring].y);
    shields[8] = ballC;
    
    rig.positionX = _shield; 
    rig.position = shields;

    for (int i = 0; i < shields.length; i++) {
      PVector pv = new PVector(shields[i].x,shields[i].y);
      rig.pixelPosition.add(pv); // adding global coords to pixelPosition ArrayList
    }
  }
  int bigRing = 124; // number of LEDS in the rig shield ring, important for ballGrid too
  void bigShieldWLED(OPC opc, int xpos, int ypos) {
    ////// 10W LEDs in center ////
    int space = rig.wide/2/18;
    opc.led(0, xpos, ypos+space);
    opc.led(1, xpos+space, ypos);
    opc.led(2, xpos, ypos-space);
    opc.led(3, xpos-space, ypos);
    ///// LED STRIP ////
    int leds = bigRing;
    int strt = 4;
    _bigShieldRad = rig.wide/leds*16;       
    bigShieldRad = _bigShieldRad * 2 + 4; 
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_bigShieldRad)+xpos, (int(cos(radians((i-strt)*360/leds))*_bigShieldRad)+ypos));
    }
  }
   void ballGrid(OPC opc, int numb, int positionA, int positionB) {
    opc.led(numb+(bigRing+4), int(_shield[positionA][positionB].x), int(_shield[positionA][positionB].y));
  }
  void medShieldWLED(OPC opc, int positionA, int positionB) {
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int xpos = int(_shield[positionA][positionB].x);
    int ypos = int(_shield[positionA][positionB].y);
    ////// LED RING for MEDIUM SHIELDS
    int strt = 4;
    int leds = 63;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_medShieldRad)+int(xpos), (int(cos(radians((i-strt)*360/leds))*_medShieldRad)+int(ypos)));
    }
    ///// PLACE 4 HP LEDS in CENTER OF EACH RING /////
    for (int j = 1; j < 6; j +=2) {
      int space = rig.wide/2/20;
      opc.led(0, xpos, ypos+space);
      opc.led(1, xpos+space, ypos);
      opc.led(2, xpos, ypos-space);
      opc.led(3, xpos-space, ypos);
    }
  }
  void smallShieldWLED(OPC opc, int positionA, int positionB) {
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int xpos = int(_shield[positionA][positionB].x);
    int ypos = int(_shield[positionA][positionB].y);
    ////// 1 HP LED IN MIDDLE OF EACH SMALL SHIELD //////
    opc.led(0, int(xpos), int(ypos));
    /////// RING OF LEDS TO MAKE SAMLL SHIELD ///////
    int leds = 48;
    int strt = 1;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_smallShieldRad)+int(xpos), (int(cos(radians((i-strt)*360/leds))*_smallShieldRad)+int(ypos)));
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////