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
}
//for passing to a rect


class BoothGrid extends OPCGrid{
  PVector smoke[][] = new PVector[2][2];
  Coord smokePump,smokeFan;
  PVector uvs[][] = new PVector[6][3];
  PVector blins[] = new PVector[4];
  Coord uvDimmer,uvSpeed,uvProgram;
  Coord booth,dig,mixer,blinders;
  BoothGrid(Map<String,OPC> opcs){
    opclist = opcs;

    booth = new Coord(size.booth.x-size.booth.wide/2+20,size.booth.y,40,15);
    dig = new Coord(booth.x+110,booth.y,20,booth.high);
    mixer = new Coord(dig.x + 30, dig.y,dig.wide,dig.high);
    OPC boothopc = opcs.get("FrontLeft");
    boothopc.led(0,int(booth.x-5),int(booth.y));
    boothopc.led(200,int(booth.x+5),int(booth.y));
    boothopc.led(100,int(mixer.x),int(mixer.y));//mixer
    boothopc.led(300,int(dig.x),int(dig.y));

    OPC entec = opcs.get("Entec");
    int x = (int)size.booth.x;//+100;
    int y = (int)size.booth.y;//-250;
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

    //BLINDERS
    x = (int)size.booth.x + 100;
    y = (int)size.booth.y;
    for (int i=0;i<4;i++){
      //blinderv[i][j] = new PVector(xx,yy);
      int xx = x + i*xgap;
      blins[i] = new PVector(xx,y);
      entec.led(9000+i,xx,y);
    }
    float blinx = 0.5*(blins[1].x+blins[2].x);
    blinders = new Coord(blinx,y,xgap*(blins.length+1),20);

  }

  //rect coordinates for
  //uv.dimmers,uv.program_speed,uv.program
  //
  
}

class MegaSeedsGrid extends OPCGrid{
  Rig rig;
  PVector front,centre;
  MegaSeedsGrid(Rig _rig,Map<String,OPC> opcs){
    opclist = opcs;
    rig = _rig;
    int fx=size.megaSeeds.x-50;
    int rx=size.megaSeeds.x+50;
    front = new PVector(fx, size.megaSeeds.y);
    centre = new PVector(rx, size.megaSeeds.y);
    opcs.get("FrontSeed").led(0,fx,size.megaSeeds.y);
    opcs.get("CentreSeed").led(0,rx,size.megaSeeds.y);

  }
}

class LanternInfo{
  String opcname;
  int start_pixel;
  int pixelcounts[];
  String unitname;
  LanternInfo(String name,String opcn,int stpix,int[] pixcounts){
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
class FMRoofGrid extends OPCGrid {
  Rig rig;
  //Map<String,PVector> opcPositions=new Map<String,PVector>;
  //Map<String,PVector> rigPositions=new Map<String,PVector>;
  FMRoofGrid(Rig _rig,Map<String,OPC> opcs,Map<String,LanternInfo> units,String[] unitnames){
    rig = _rig;
    //vertical strips left to right
    int nunits = unitnames.length;
    for (int i=0;i<nunits;i++){
      println("setting up "+unitnames[i]);
      LanternInfo unit = units.get(unitnames[i]);
      int xpos = rig.size.x-rig.size.wide/2 + (i+1)*rig.size.wide/(nunits+1);
      float xspacing = rig.size.wide/(nunits+1);
      //int ypos = rig.size.y;
      //int npixels = sum(unit.pixelcounts);
      OPC opc = opcs.get(unit.opcname);
      float spacing = (rig.size.high-100) / (unit.pixelcounts.length+1);
      boolean reverse = true;
      //opc.ledStrip(unit.start_pixel,npixels,xpos,ypos,spacing,PI/2,reverse);
      int pixelnumber=unit.start_pixel;
      for (int j=0;j<unit.pixelcounts.length;j++){
        int npixels=unit.pixelcounts[j];
        float ypos = rig.size.y-rig.size.high/2 + 50 + spacing*j;
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
  PVector medShieldBottomRight;
  PVector[][] shield; // = new PVector[numberOfPositions][numberOfRings];  
  PVector[] shields = new PVector[12];
  //PVector[] eggs = new PVector[2]; 
  //int eggLength;
  float[] ringSize;
  Rig rig;
  int bigShield = 0;
  int smallSheildRight=1;
  int smallSheildTop=2;
  int smallShieldLeft=3;
  int medShieldRight=4;
  int medShieldTop=5;
  int medSheildRight=6;
  int ballRight=7;
  int ballLeft=8;
  int ballBottom=9;
  //shields[medShieldBottomRight]
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
    void spiralShieldsOPC(Map<String,OPC> _opc) {
    opclist = _opc;
    ringSize = new float[] { rig.wide/8.3, rig.wide/5.5, rig.wide/4.5 };
    shieldSetup(9);

    medShieldWLED(opclist.get("MedShieldA"), 0, 0);   ///// SLOT b1 on BOX ///// 

    smallShieldWLED(opclist.get("SmallShieldA"), 8, 1); ///// SLOT b0 on BOX /////
    ballGrid(opclist.get("Balls"), 0, 7, 2);

    medShieldWLED(opclist.get("MedShieldB"), 6, 0);   ///// SLOT b5 on BOX /////
    smallShieldWLED(opclist.get("SmallShieldB"), 5, 1); ///// SLOT b4 on BOX /////
    ballGrid(opclist.get("Balls"), 1, 4, 2);

    medShieldWLED(opclist.get("MedShieldC"), 3, 0);   ///// SLOT b3 on BOX /////
    smallShieldWLED(opclist.get("SmallShieldC"), 2, 1); ///// SLOT b2 on BOX /////
    ballGrid(opclist.get("Balls"), 2, 1, 2);

    bigShieldWLED(opclist.get("BigShield"), int(size.shields.x), int(size.shields.y));     ///// SLOT b7 on BOX /////
    /////////////////////////// increase size of radius so its covered when drawing over it in the sketch

    medShieldBottomRight = new PVector (_shield[0][0].x, _shield[0][0].y);        // MEDIUM SHIELD
    shields[3] = new PVector (_shield[8][1].x, _shield[8][1].y);        // SMALL SHEILD
    shields[6] = new PVector (_shield[7][2].x, _shield[7][2].y);        // BALL

    shields[1] = new PVector (_shield[6][0].x, _shield[6][0].y);        // MEDIUM SHIELD
    shields[4] = new PVector (_shield[5][1].x, _shield[5][1].y);        // SMALL SHEILD
    shields[7] = new PVector (_shield[4][2].x, _shield[4][2].y);        // BALL

    shields[2] = new PVector (_shield[3][0].x, _shield[3][0].y);        // MEDIUM SHIELD
    shields[5] = new PVector (_shield[2][1].x, _shield[2][1].y);        // SMALL SHEILD
    shields[8] = new PVector (_shield[1][2].x, _shield[1][2].y);        // BALL

    shields[9] =  new PVector (_shield[7][2].x, _shield[7][2].y);       // BALL
    shields[10] = new PVector (_shield[4][2].x, _shield[4][2].y);       // BALL
    shields[11] = new PVector (_shield[1][2].x, _shield[1][2].y);       // BALL

    rig.positionX = _shield; 
    rig.position = shields;
  }
  //////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  void triangleShieldsOPC(Map<String,OPC> _opc) {
    opclist = _opc;
    ringSize = new float[] { rig.wide/9, rig.wide/5, rig.wide/4.5 };
    shieldSetup(12);
    //// SHIELDS - #1 slot on box; #2 position on ring; #3 number of LEDS in 5v ring 
    smallShieldWLED(opclist.get("SmallShieldA"), 2, 0); ///// SLOT b0 on BOX /////   
    medShieldWLED(opclist.get("MedShieldA"), 2, 1);   ///// SLOT b1 on BOX ///// 
    smallShieldWLED(opclist.get("SmallShieldB"), 6, 0); ///// SLOT b2 on BOX /////
    medShieldWLED(opclist.get("MedShieldB"), 6, 1);   ///// SLOT b3 on BOX /////
    smallShieldWLED(opclist.get("SmallShieldC"), 10, 0); ///// SLOT b4 on BOX /////
    medShieldWLED(opclist.get("MedShieldC"), 10, 1);   ///// SLOT b5 on BOX /////
    bigShieldWLED(opclist.get("BigShield"), int(size.shields.x), int(size.shields.y));     ///// SLOT b7 on BOX /////
    ballGrid(opclist.get("BigShield"), 0, 8, 1);
    ballGrid(opclist.get("BigShield"), 1, 0, 1);
    ballGrid(opclist.get("BigShield"), 2, 4, 1);

    shields[0] = new PVector (_shield[0][0].x, _shield[0][0].y);        // MEDIUM SHIELD
    shields[3] = new PVector (_shield[8][1].x, _shield[8][1].y);        // SMALL SHEILD
    shields[6] = new PVector (_shield[7][2].x, _shield[7][2].y);        // BALL

    shields[1] = new PVector (_shield[6][0].x, _shield[6][0].y);        // MEDIUM SHIELD
    shields[4] = new PVector (_shield[5][1].x, _shield[5][1].y);        // SMALL SHEILD
    shields[7] = new PVector (_shield[4][2].x, _shield[4][2].y);        // BALL

    shields[2] = new PVector (_shield[3][0].x, _shield[3][0].y);        // MEDIUM SHIELD
    shields[5] = new PVector (_shield[2][1].x, _shield[2][1].y);        // SMALL SHEILD
    shields[8] = new PVector (_shield[1][2].x, _shield[1][2].y);        // BALL

    shields[9] =  new PVector (_shield[7][2].x, _shield[7][2].y);       // BALL
    shields[10] = new PVector (_shield[4][2].x, _shield[4][2].y);       // BALL
    shields[11] = new PVector (_shield[1][2].x, _shield[1][2].y);       // BALL

    rig.positionX = _shield; 
    rig.position = shields;
  }
  void ballGrid(OPC opc, int numb, int positionA, int positionB) {
    opc.led(130+numb, int(_shield[positionA][positionB].x), int(_shield[positionA][positionB].y));
  }
  void bigShieldWLED(OPC opc, int xpos, int ypos) {
    ////// 10W LEDs in center ////
    int space = rig.wide/2/18;
    opc.led(0, xpos, ypos+space);
    opc.led(1, xpos+space, ypos);
    opc.led(2, xpos, ypos-space);
    opc.led(3, xpos-space, ypos);
    ///// LED STRIP ////
    int leds = 126;
    int strt = 4;
    _bigShieldRad = rig.wide/leds*16;       
    bigShieldRad = _bigShieldRad * 2 + 4; 
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_bigShieldRad)+xpos, (int(cos(radians((i-strt)*360/leds))*_bigShieldRad)+ypos));
    }
  }
  void medShieldWLED(OPC opc, int positionA, int positionB) {
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int positionX = int(_shield[positionA][positionB].x);
    int positionY = int(_shield[positionA][positionB].y);
    ////// 5V LED RING for MEDIUM SHIELDS
    int strt = 4;
    int leds = 33;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_medShieldRad)+int(positionX), (int(cos(radians((i-strt)*360/leds))*_medShieldRad)+int(positionY)));
    }

    ///// PLACE 4 HP LEDS in CENTER OF EACH RING /////
    for (int j = 1; j < 6; j +=2) {
      int space = rig.wide/2/20;
      opc.led(0, positionX, positionY+space);
      opc.led(1, positionX+space, positionY);
      opc.led(2, positionX, positionY-space);
      opc.led(3, positionX-space, positionY);
    }
  }
  void smallShieldWLED(OPC opc, int positionA, int positionB) {
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int positionX = int(_shield[positionA][positionB].x);
    int positionY = int(_shield[positionA][positionB].y);
    ////// 1 HP LED IN MIDDLE OF EACH SMALL SHIELD //////
    opc.led(0, int(positionX), int(positionY));
    /////// RING OF 5V LEDS TO MAKE SAMLL SHIELD ///////
    int leds = 48;
    int strt = 1;
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_smallShieldRad)+int(positionX), (int(cos(radians((i-strt)*360/leds))*_smallShieldRad)+int(positionY)));
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class OGOPCGrid extends OPCGrid{
  PVector[] mirror = new PVector[12];
  PVector[][] mirrorX = new PVector[7][4];
  PVector[] _mirror = new PVector[12];
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
  ///////////////////////////////////////////// CANS //////////////////////////////////////////////////
  void individualCansOPC(Rig _rig, OPC opc, boolean offset) {
    rig = _rig;
    //TODO: put into CANS opc
    OGOPCGrid opcGrid = ((OGOPCGrid)(rig.opcgrid));
    float xw = 6;
    float y = rig.size.y;
    if (offset) y = rig.size.y - rig.high/(xw+1)/(xw/2);

    for (int i=0; i<cans.length/xw; i++) cans[i] =     new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*1);
    for (int i=0; i<cans.length/xw; i++) cans[i+3] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*2);
    for (int i=0; i<cans.length/xw; i++) cans[i+6] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*3);
    for (int i=0; i<cans.length/xw; i++) cans[i+9] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*4);
    for (int i=0; i<cans.length/xw; i++) cans[i+12] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*5);
    for (int i=0; i<cans.length/xw; i++) cans[i+15] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*6);

    if (offset) {
      cans[1].y = y-(rig.high/2)+rig.high/(xw+1)*(1.5);
      cans[4].y = y-(rig.high/2)+rig.high/(xw+1)*(2.5);
      cans[7].y = y-(rig.high/2)+rig.high/(xw+1)*(3.5);
      cans[10].y = y-(rig.high/2)+rig.high/(xw+1)*(4.5);
      cans[13].y = y-(rig.high/2)+rig.high/(xw+1)*(5.5);
      cans[16].y = y-(rig.high/2)+rig.high/(xw+1)*(6.5);
    }

    int fc = 9 * 512;
    int channel = 64;
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*0+i), int(cans[i].x), int(cans[i].y));                   
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*1+i), int(cans[i+6].x), int(cans[i+6].y));                  
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*2+i), int(cans[i+12].x), int(cans[i+12].y));                  

    ////  set roof position to individual cans positions
    for (int i = 0; i < rig.position.length/2; i++) {
      rig.position[i].x=opcGrid.cans[i].x-(rig.size.x-(rig.wide/2));
      rig.position[i].y=opcGrid.cans[i].y-(rig.size.y-(rig.high/2));
      //
      rig.position[i+6].x=opcGrid.cans[i+12].x-(rig.size.x-(rig.wide/2));
      rig.position[i+6].y=opcGrid.cans[i+12].y-(rig.size.y-(rig.high/2));
    }
    rig.position[4].x=cans[7].x-(rig.size.x-(rig.wide/2));
    rig.position[4].y=cans[7].y-(rig.size.y-(rig.high/2));

    rig.position[7].x=cans[10].x-(rig.size.x-(rig.wide/2));
    rig.position[7].y=cans[10].y-(rig.size.y-(rig.high/2));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  void kallidaCansOPC(OPC opc) {
    int fc = 5 * 512;
    int channel = 64;
    int leds = 6;
    pd = int(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, int(cansString[0].x), int(cansString[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1)+(64*channel), leds, int(cansString[1].x), int(cansString[1].y), pd, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX ///////
    cansLength = _cansLength - (pd/2);
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////
void pickleCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    _cansLength = rig.high/1.2;
    
    //int fc = 2 * 512;
    int fc = 2560;
    int channel = 64;
    int leds = 6;
    pd = int(_cansLength/6);

    cansString[1] = new PVector(rig.size.x-(rig.wide/3), rig.size.y-(pd/4));
    cansString[0] = new PVector(rig.size.x, rig.size.y+(pd/4));
    cansString[2] = new PVector(rig.size.x+(rig.wide/3), rig.size.y-(pd/4));

    opc.ledStrip(fc+(channel*0), leds, int(cansString[0].x), int(cansString[0].y), pd, PI/2, false);                   /////  PLUG INTO slot 1 on CANS BOX (first tail) /////// 
    opc.ledStrip(fc+(channel*1), leds, int(cansString[1].x), int(cansString[1].y), pd, PI/2, false);                   /////  PLUG INTO slot 2 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*2), leds, int(cansString[2].x), int(cansString[2].y), pd, PI/2, false);                   /////  PLUG INTO slot 3 on CANS BOX /////// 

    cansLength = _cansLength - (pd/2);
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  void castleCansOPC(Rig _rig, OPC opc, OPC opc1, boolean offset) {
    rig = _rig;
    //TODO accessing opcGrid from within opcGrid is 
    //terrifying what does that even mean
    //This should probably just be deleted
    //Making sure this segfaults
    OGOPCGrid opcGrid = ((OGOPCGrid)new OPCGrid());
    float xw = 6;
    float y = rig.size.y;
    if (offset) y = rig.size.y - rig.high/(xw+1)/(xw/2);

    for (int i=0; i<cans.length/xw; i++) cans[i] =     new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*1);
    for (int i=0; i<cans.length/xw; i++) cans[i+3] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*2);
    for (int i=0; i<cans.length/xw; i++) cans[i+6] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*3);
    for (int i=0; i<cans.length/xw; i++) cans[i+9] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*4);
    for (int i=0; i<cans.length/xw; i++) cans[i+12] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*5);
    for (int i=0; i<cans.length/xw; i++) cans[i+15] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), y-(rig.high/2)+rig.high/(xw+1)*6);

    if (offset) {
      cans[1].y = y-(rig.high/2)+rig.high/(xw+1)*(1.5);
      cans[4].y = y-(rig.high/2)+rig.high/(xw+1)*(2.5);
      cans[7].y = y-(rig.high/2)+rig.high/(xw+1)*(3.5);
      cans[10].y = y-(rig.high/2)+rig.high/(xw+1)*(4.5);
      cans[13].y = y-(rig.high/2)+rig.high/(xw+1)*(5.5);
      cans[16].y = y-(rig.high/2)+rig.high/(xw+1)*(6.5);
    }

    int fc = 9 * 512;
    int channel = 64;
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*0+i), int(cans[i].x), int(cans[i].y)+80);     
    fc = 10 * 512;
    for (int i = 0; i < cans.length/3; i++) opc1.led(fc+(channel*1+i), int(cans[i+6].x), int(cans[i+6].y)+80);                  
    for (int i = 0; i < cans.length/3; i++) opc1.led(fc+(channel*2+i), int(cans[i+12].x), int(cans[i+12].y)+80);                  

    ////  set roof position to individual cans positions
    for (int i = 0; i < rig.position.length/2; i++) {
      rig.position[i].x=opcGrid.cans[i].x-(rig.size.x-(rig.wide/2));
      rig.position[i].y=opcGrid.cans[i].y-(rig.size.y-(rig.high/2));
      //
      rig.position[i+6].x=opcGrid.cans[i+12].x-(rig.size.x-(rig.wide/2));
      rig.position[i+6].y=opcGrid.cans[i+12].y-(rig.size.y-(rig.high/2));
    }
    rig.position[4].x=cans[7].x-(rig.size.x-(rig.wide/2));
    rig.position[4].y=cans[7].y-(rig.size.y-(rig.high/2));

    rig.position[7].x=cans[10].x-(rig.size.x-(rig.wide/2));
    rig.position[7].y=cans[10].y-(rig.size.y-(rig.high/2));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
/*  void kingsHeadCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    _cansLength = size.cansWidth;
    cansString[0] = new PVector(rig.size.x, rig.size.y-(rig.high/4));
    cansString[1] = new PVector(rig.size.x, rig.size.y);
    cansString[2] = new PVector(rig.size.x, rig.size.y+(rig.high/4));

    int fc = 0 * 512;
    int channel = 64;
    int leds = 6;
    pd = int(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, int(cansString[0].x), int(cansString[0].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1), leds, int(cansString[1].x), int(cansString[1].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*2), leds, int(cansString[2].x), int(cansString[2].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 2 on CANS BOX /////// 
    cansLength = _cansLength - (pd/2);
  }
*/
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*  void castleFireplaceCansOPC(Rig rig, OPC opc) {
    int fc = 10 * 512;
    int channel = 64;
    for (int i = 0; i < 6; i++) opc.led(fc+(channel*2+i), int(pars.size.x), int(pars.size.y-(pars.high/2)+100+(i*80)));
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// UV /////////////////////////////////////////////////////
  void kallidaUV(OPC opc) {
    int fc = 2 * 512;
    int channel = 64;                 
    opc.led(fc+(channel*7), int(uv.x), int(uv.y));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////// STRIP ///////////////////////////////////////////////////////////////
  void kingsHeadStripOPC(Rig _rig, OPC opc) {
    rig = _rig;
    int fc = 3 * 512;
    int channel = 64;
    int leds = 64;
    int pd = rig.wide/2/leds;
    for (int i = 0; i < 3; i++) strip[i] = new PVector (rig.size.x-(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));
    for (int i = 0; i < 3; i++) strip[i+3] = new PVector (rig.size.x+(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));

    for (int i=0; i<6; i++)  opc.ledStrip(fc+(channel), leds, int(strip[i].x), int(strip[i].y), pd, 0, true);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  void espTestOPC(Rig _rig, OPC opc) {
    rig = _rig;
    int fc = 0 * 512;
    int channel = 64;
    int leds = 120;
    int pd = rig.wide/2/leds;
    for (int i = 0; i < 3; i++) strip[i] = new PVector (rig.size.x-(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));
    for (int i = 0; i < 3; i++) strip[i+3] = new PVector (rig.size.x+(pd*leds/2), rig.size.y-(rig.high/2)+rig.high/6*(i*2+1));

    for (int i=0; i<1; i++) opc.ledStrip(fc+(channel*i), leds, int(strip[i].x), int(strip[i].y), 2, 0, true);
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

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  void shieldsBoothOPC(OPC opc) {
    booth = new PVector (104, 15);
    dig = new PVector (booth.x+110, booth.y);

    int fc = 5120;  
    int channel = 64;       

    // booth //
    opc.led(fc+(channel*0), int(booth.x-5), int(booth.y));
    opc.led(fc+(channel*1), int(booth.x+5), int(booth.y));

    // dig //
    opc.led(fc+(channel*2), int(dig.x+5), int(dig.y));
    opc.led(fc+(channel*3), int(dig.x-5), int(dig.y));
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  void kingsHeadBoothOPC(OPC opc) {
    int fc = 4 * 512;
    int channel = 64;       

    opc.led(fc+(channel*3), int(dig.x-5), int(dig.y));
    opc.led(fc+(channel*2), int(dig.x+5), int(dig.y));

    opc.led(fc+(channel*1), int(booth.x-5), int(booth.y));
  }

  void eggsOPC(OPC opc, Rig rig) {
    //rig = _rig;
    eggs[0] = new PVector(rig.size.x-75, rig.size.y);
    eggs[1] = new PVector(rig.size.x+75, rig.size.y);
    println("eggs x/y ", eggs[0], eggs[1]);
    eggLength = 100;
    int fc = 10 * 512;
    int channel = 64;
    opc.led(fc+(channel*5), int(eggs[0].x), int(eggs[0].y-(eggLength/2)));          
    opc.led(fc+(channel*5)+1, int(eggs[0].x), int(eggs[0].y));
    opc.led(fc+(channel*5)+2, int(eggs[0].x), int(eggs[0].y+(eggLength/2)));
    int leds = 28;
    opc.ledStrip(fc+(channel*5)+3, leds, int(eggs[0].x+10), int(eggs[0].y), rig.high/1.5/leds, PI/2, false);
    opc.ledStrip(fc+(channel*5)+3+leds, leds, int(eggs[0].x-10), int(eggs[0].y), rig.high/1.5/leds, PI/2, true);


    opc.led(fc+(channel*6), int(eggs[1].x), int(eggs[1].y-(eggLength/2)));          
    opc.led(fc+(channel*6)+1, int(eggs[1].x), int(eggs[1].y));
    opc.led(fc+(channel*6)+2, int(eggs[1].x), int(eggs[1].y+(eggLength/2)));

    eggLength += 20;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void pickleLanternsIndividual(Rig _rig, OPC opc, int fc) {
    rig = _rig;
    int Xoffset = int(rig.size.x - (rig.wide/2));

    fc *= 512;
    int channel = 64;
    opc.led(fc+(channel*0), int(rig.positionX[3][0].x + Xoffset), int(rig.positionX[3][0].y)); 

    opc.led(fc+(channel*1), int(rig.position[0].x + Xoffset), int(rig.position[0].y));       
    opc.led(fc+(channel*2), int(rig.position[5].x + Xoffset), int(rig.position[5].y));  

    opc.led(fc+(channel*3), int(rig.positionX[2][1].x + Xoffset), int(rig.positionX[2][1].y)); 
    opc.led(fc+(channel*4), int(rig.positionX[4][1].x + Xoffset), int(rig.positionX[4][1].y)); 

    opc.led(fc+(channel*5), int(rig.position[6].x + Xoffset), int(rig.position[6].y)); 
    opc.led(fc+(channel*6), int(rig.position[11].x + Xoffset), int(rig.position[11].y));  

    opc.led(fc+(channel*7), int(rig.positionX[3][2].x + Xoffset), int(rig.positionX[3][2].y));
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void pickleLanternsDaisyChain(Rig _rig, OPC opc, int fc) {
    rig = _rig;
    int Xoffset = int(rig.size.x - (rig.wide/2));

    fc *=512;
    int channel = 64;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// if you need to make another chain just change the 0 to 1 (or whichever slot the start of the chain is plugged into)
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    opc.led(fc+(channel*0+0), int(rig.positionX[3][0].x + Xoffset), int(rig.positionX[3][0].y)); 

    opc.led(fc+(channel*0+1), int(rig.position[0].x + Xoffset), int(rig.position[0].y));       
    opc.led(fc+(channel*0+2), int(rig.position[5].x + Xoffset), int(rig.position[5].y));      

    opc.led(fc+(channel*0+3), int(rig.positionX[2][1].x + Xoffset), int(rig.positionX[2][1].y)); 
    opc.led(fc+(channel*0+4), int(rig.positionX[4][1].x + Xoffset), int(rig.positionX[4][1].y)); 

    opc.led(fc+(channel*0+5), int(rig.position[6].x + Xoffset), int(rig.position[6].y)); 
    opc.led(fc+(channel*0+6), int(rig.position[11].x + Xoffset), int(rig.position[11].y));  

    opc.led(fc+(channel*0+7), int(rig.positionX[3][2].x + Xoffset), int(rig.positionX[3][2].y));
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void wigflexLanterns(Rig _rig, OPC opc) {
    rig = _rig;
    int Xoffset = int(rig.size.x - (rig.wide/2));

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// if you need to make another chain just change the 0 to 1 (or whichever slot the start of the chain is plugged into)
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    opc.led(0, int(rig.position[0].x + Xoffset), int(rig.position[0].y));       
    
    
    opc.led(3, int(rig.position[5].x + Xoffset), int(rig.position[5].y));      

    opc.led(1, int(rig.positionX[2][1].x + Xoffset), int(rig.positionX[2][1].y)); 
    opc.led(4, int(rig.positionX[4][1].x + Xoffset), int(rig.positionX[4][1].y)); 

    opc.led(2, int(rig.position[6].x + Xoffset), int(rig.position[6].y)); 
    opc.led(5, int(rig.position[11].x + Xoffset), int(rig.position[11].y));  

    opc.led(6, int(rig.positionX[3][0].x + Xoffset), int(rig.positionX[3][0].y)); 

    opc.led(8, int(rig.positionX[3][2].x + Xoffset), int(rig.positionX[3][2].y));
    opc.led(7, int(rig.positionX[3][1].x + Xoffset), int(rig.positionX[3][1].y)+(rig.high-(int(rig.high/1.2)))/2);
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
