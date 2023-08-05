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
  OPCGrid(){}
  ArrayList<PVector> pixelPositions = new ArrayList<PVector>();

}
//for passing to a rect


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

class UvParsGrid extends OPCGrid{
  Rig rig;
  //PVector centre;
  UvParsGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("Entec").led(0,size.uvPars.x,size.uvPars.y);
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

class MegaSeedBGrid extends OPCGrid{
  Rig rig;
  MegaSeedBGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("megaSeedB").led(0,size.megaSeedB.x,size.megaSeedB.y);
  }
}

class MegaSeedAGrid extends OPCGrid{
  Rig rig;
  MegaSeedAGrid(Rig _rig,Map<String,OPC> opcnodes){
    opclist = opcnodes;
    rig = _rig;
    opcnodes.get("megaSeedA").led(0,size.megaSeedA.x,size.megaSeedA.y);
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
          // sets the rig.posistion[] coordinates to the pixel coords
          // this is wrong - rig.position should be local to the rig
          rig.position[k] = pv;   
          opc.led(pixelnumber,int(pv.x),int(pv.y));
          // adding opc postions to array list
          rig.pixelPosition.add(rig.position[k]);
          // print the coords
          String pixeln = "lantern["+all_pixel_number+"] ";
          String channeln = "channel["+i+"] ";
          String wledn = "led #["+pixelnumber+"] ";
          String global = "global coords: "+rig.position[k].x + "  " + rig.position[k].y;
          String info = pixeln+channeln+wledn+global;
          println(pixeln,channeln,global);
          printmd(info); // prints coordinates for positions in the rig
          
          // can use this information to print the channel number and position in the string
          pixelnumber++;
          all_pixel_number++;
        }
      }
      // TODO implement this into the other rigs 
      // for (int k=0; k < rig.position.length;k++){
      //   PVector rigPosition = rig.position[k]; // Assuming rig is an array of PVectors
      //   println(position);
      //   printmd(position); // prints coordinates for positions in the rig
      // }


    }
  }
}

class VerticalRoofGrid extends OPCGrid {
  Rig rig;
  VerticalRoofGrid(Rig _rig,Map<String,OPC> opcnodes,Map<String,PixelMapping> channels,String[] channelnames){
    rig = _rig;
    //vertical strips left to right
    int nunits = channelnames.length; // number of strings in the rig, doesnt have to be from the same ESP
    for (int i=0;i<nunits;i++){
      println("setting up "+channelnames[i]+": "+channelnames.length+" pixel strings in the rig");
      PixelMapping channel = channels.get(channelnames[i]);
      OPC opc = opcnodes.get(channel.opcname);
      int pixelnumber=channel.start_pixel;
      boolean reverse = true;
      //channel.pixelcounts.length = number of pixels in the string
      
      //rig specific math
      int xpos = rig.size.x-rig.size.wide/2 + (i+1)*rig.size.wide/(nunits+1);
      float xspacing = rig.size.wide/(nunits+1);
      //int ypos = rig.size.y;
      float spacing = (rig.size.high) / (channel.pixelcounts.length+1);
      
      for (int j=0;j<channel.pixelcounts.length;j++){
        int npixels=channel.pixelcounts[j];

        // offset centers the pixels based on number of pixels
        float offset = (rig.size.high) / (channel.pixelcounts.length+2); 
        float ypos = rig.size.y-rig.size.high/2 + offset + spacing*j;
        // println("xpos "+xpos+" ypos "+ypos+ " spacing "+spacing+" offset "+offset);
        if (npixels==1) {opc.led(pixelnumber,xpos,int(ypos));
        }else if (npixels==25){
          float gridspacing = min(spacing,xspacing)*0.5/5;
          opc.ledGrid(pixelnumber,5,5,xpos,ypos,gridspacing,gridspacing,0,false);
        }
        pixelnumber += npixels;
      }
    }
  }
}

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
  ////////////////////////// todo add this to class ShieldsOpcGrid ///////////////////////////////////////
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
    println(rig.position.length);

    // print the rig.positon - positions of all the shields
    printmd("## "+rig.type+" POSITION");
    for (int k=0; k < rig.position.length;k++){
      PVector rigPosition = rig.position[k]; // Assuming rig is an array of PVectors
      String position = "local coords["+ k +"] "+ rigPosition.x + "  " + rigPosition.y;
      println(position);
      printmd(position); // prints coordinates for positions in the rig  
    }
    // print the positionX.positions of all the COORDINATES used for ANIMATIONS
    // printmd("## "+rig.type+" POSITION");
    // for (int k=0; k < rig.position.length;k++){
    // PVector rigPosition = rig.position[k]; // Assuming rig is an array of PVectors
      //String position = "local coords["+ k +"] "+ rigPosition.x + "  " + rigPosition.y;
      //println(position);
      //printmd(position); // prints coordinates for positions in the rig  
   // }
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
    ////// 5V LED RING for MEDIUM SHIELDS
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
    /////// RING OF 5V LEDS TO MAKE SAMLL SHIELD ///////
    int leds = 48;
    int strt = 1;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_smallShieldRad)+int(xpos), (int(cos(radians((i-strt)*360/leds))*_smallShieldRad)+int(ypos)));
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class OGOPCGrid extends OPCGrid{
  PVector[] seeds = new PVector[4];
  PVector[] cansString = new PVector[3];
  PVector[] cans = new PVector[18];
  PVector[] eggs = new PVector[2];
  PVector[] strip = new PVector[6];
  PVector[] controller = new PVector[4];
  
  PVector booth, dig, smokeFan, smokePump, uv;
  float yTop;                            // height Valuve for top line of mirrors
  float yBottom;  
  float yMid = size.shields.y;   
  int eggLength;

  Rig rig;

  int pd, ld, dist, controllerGridStep, rows, columns;
  float mirrorAndGap, seedsLength, _seedsLength, seeds2Length, _seeds2Length, cansLength, _cansLength, _mirrorWidth, mirrorWidth, controllerWidth;

  OGOPCGrid () {

  }

  
  
  
  

  /////////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////// BOOTH LIGHTS ///////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void standAloneBoothOPC(OPC opc) {
    booth = new PVector (104, 15);
    dig = new PVector (booth.x+110, booth.y);

    int fc = 10 * 512;
    int channel = 64;       

    opc.led(fc+(channel*3), int(booth.x-5), int(booth.y));
    opc.led(fc+(channel*4), int(booth.x+5), int(booth.y));

    opc.led(fc+(channel*1), int(dig.x-5), int(dig.y));
    opc.led(fc+(channel*2), int(dig.x+5), int(dig.y));
  }

  ////////////////////////////////// DMX  /////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void dmxParsOPC(Rig _rig, OPC opc, int numberOfPars) {
    rig = _rig;
    int gap = rig.high/(numberOfPars+2);
    for (int i = 0; i < numberOfPars*2; i+=2) opc.led(6048+i, int(rig.size.x), int(rig.size.y-(gap*numberOfPars/2)+(gap/2)+(i/2*gap)));
  } 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void dmxSmokeOPC(OPC opc) {
    smokePump = new PVector (height-10, width-20);
    smokeFan = new PVector (smokePump.x+10, smokePump.y);

    opc.led(7000, int(smokePump.x), int(smokePump.y));
    opc.led(7001, int(smokeFan.x), int(smokeFan.y));
  } 
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
