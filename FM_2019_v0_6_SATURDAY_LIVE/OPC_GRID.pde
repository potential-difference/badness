class ShieldsOPCGrid {

  int numberOfPositions = 12;
  int numberOfShields = 6;
  int numberOfRings = 3;
  //  PVectors for positions of shields
  PVector[] _medShield = new PVector[numberOfShields];      
  PVector[] _smallShield = new PVector[numberOfShields];   
  PVector[] _ball = new PVector[numberOfShields];          
  PVector[][] _shield = new PVector[numberOfShields][numberOfRings];    
  PVector[] medShield = new PVector[numberOfPositions];     
  PVector[] smallShield = new PVector[numberOfPositions];   
  PVector[] ball = new PVector[numberOfPositions];          
  PVector[][] shield = new PVector[numberOfPositions][numberOfRings];   

  int rigx = int(size.rig.x);
  int rigy = int(size.rig.y); 

  float medRingSize = size.rigWidth/5;          ///// SIZE OF RING BIG SHIELDS ARE POSITION ON
  float smallRingSize = size.rigWidth/9;        ///// SIZE OF RING SMALL SHIELDS ARE POSITION ON
  float ballRingSize = size.rigWidth/7;         ///// SIZE OF RING BALLS ARE POSITIONED ON

  float bigShieldRad, medShieldRad, smallShieldRad;
  float _bigShieldRad, _medShieldRad, _smallShieldRad;

  ShieldsOPCGrid() {
    _bigShieldRad = size.rigWidth/64*7;       
    bigShieldRad = _bigShieldRad * 2 + 6;
  }

  PVector[] eggs = new PVector[2];
  int eggLength;

  void FMEggs(OPC opc) {
    eggs[0] = new PVector(size.roof.x-75, size.roof.y-200);
    eggs[1] = new PVector(size.roof.x+75, size.roof.y-200);
    eggLength = 100;
    int fc = 2;
    fc*=512;
    int slot = 64;
    //// both lights
    opc.led(fc+(slot*7), int(eggs[1].x), int(eggs[1].y-(eggLength/2)));          // digging light LEFT
    opc.led(fc+(slot*7)+1, int(eggs[1].x), int(eggs[1].y));
    opc.led(fc+(slot*7)+2, int(eggs[1].x), int(eggs[1].y+(eggLength/2)));

    eggLength += 20;
  }

  void FMShieldsGrid() {
    //shieldPositon();
    //// SHIELDS - #1 slot on box; #2 position on ring; #3 number of LEDS in 5v ring 
    smallShield(1, 1, 1, 48); ///// SLOT b0 on BOX /////   
    medShield(2, 1, 0, 33);   ///// SLOT b1 on BOX ///// 
    smallShield(3, 3, 1, 48); ///// SLOT b2 on BOX /////
    medShield(4, 3, 0, 32);   ///// SLOT b3 on BOX /////
    smallShield(5, 5, 1, 48); ///// SLOT b4 on BOX /////
    medShield(6, 5, 0, 32);   ///// SLOT b5 on BOX /////
    bigShield(7, int(size.rig.x), int(size.rig.y));     ///// SLOT b7 on BOX /////
    ballGrid(0, 0);
    ballGrid(1, 2);
    ballGrid(2, 4);
  }

  void shieldPositon() {
    float xpos, ypos;
    ///// MEDIUM SHIELD RING SETUP /////
    for (int i = 0; i < _medShield.length; i++) {    
      xpos = int(sin(radians((i)*360/numberOfShields))*medRingSize*2)+rigx;
      ypos = int(cos(radians((i)*360/numberOfShields))*medRingSize*2)+rigy;
      _medShield[i] = new PVector (xpos, ypos);
      _shield[i][0] = new PVector (xpos, ypos);
    }
    ///// MEDIUM SHIELD POSITION SETUP /////
    for (int i = 0; i < medShield.length; i++) {    
      xpos = int(sin(radians((i)*360/numberOfPositions))*medRingSize*2)+rigx;
      ypos = int(cos(radians((i)*360/numberOfPositions))*medRingSize*2)+rigy;
      medShield[i] = new PVector (xpos, ypos);
      shield[i][0] = new PVector (xpos, ypos);
    }
    ///// SMALL SHIELD RING SETUP /////
    for (int i = 0; i < _smallShield.length; i++) {    
      xpos = int(sin(radians((i)*360/numberOfShields))*smallRingSize*2)+rigx;
      ypos = int(cos(radians((i)*360/numberOfShields))*smallRingSize*2)+rigy;
      _smallShield[i] = new PVector (xpos, ypos);
      _shield[i][1] = new PVector (xpos, ypos);
    }
    for (int i = 0; i < smallShield.length; i++) {    
      xpos = int(sin(radians((i)*360/numberOfPositions))*smallRingSize*2)+rigx;
      ypos = int(cos(radians((i)*360/numberOfPositions))*smallRingSize*2)+rigy;
      smallShield[i] = new PVector (xpos, ypos);
      shield[i][1] = new PVector (xpos, ypos);
    }
    ///// BALL RING SETUP /////
    for (int i = 0; i < _ball.length; i++) {    
      xpos = int(sin(radians((i)*360/numberOfShields))*ballRingSize*2)+rigx;
      ypos = int(cos(radians((i)*360/numberOfShields))*ballRingSize*2)+rigy;
      _ball[i] = new PVector (xpos, ypos);
      _shield[i][2] = new PVector (xpos, ypos);
    }
    for (int i = 0; i < ball.length; i++) {    
      xpos = int(sin(radians((i)*360/numberOfPositions))*ballRingSize*2)+rigx;
      ypos = int(cos(radians((i)*360/numberOfPositions))*ballRingSize*2)+rigy;
      ball[i] = new PVector (xpos, ypos);
      shield[i][2] = new PVector (xpos, ypos);
    }
  }

  void FMShieldsGrid2() {
    //// SHIELDS - #1 slot on box; #2 position on ring; #3 number of LEDS in 5v ring 
    smallShield(1, 1, 0, 48); ///// SLOT b0 on BOX /////   
    medShield(2, 1, 1, 33);   ///// SLOT b1 on BOX ///// 
    smallShield(3, 5, 0, 48); ///// SLOT b2 on BOX /////
    medShield(4, 5, 1, 32);   ///// SLOT b3 on BOX /////
    smallShield(5, 3, 0, 48); ///// SLOT b4 on BOX /////
    medShield(6, 3, 1, 32);   ///// SLOT b5 on BOX /////
    bigShield(7, int(size.rig.x), int(size.rig.y));     ///// SLOT b7 on BOX /////
    ballGrid(0, 0);
    ballGrid(1, 2);
    ballGrid(2, 4);
  }

  void ballGrid(int numb, int position) {
    opc.led(1024+(64*numb), int(_ball[position].x), int(_ball[position].y));
  }

  void bigShield(int numb, int xpos, int ypos) {
    int strt = (128*numb)+64; 

    ////// HIGH POWER LED RING ////
    int space = size.rigWidth/2/18;
    opc.led(strt-64, xpos, ypos+space);
    opc.led(strt-64+1, xpos+space, ypos);
    opc.led(strt-64+2, xpos, ypos-space);
    opc.led(strt-64+3, xpos-space, ypos);
    ///// 5V LED STRIP ////
    int leds = 64;
    _bigShieldRad = size.rigWidth/leds*7;       
    bigShieldRad = _bigShieldRad * 2 + 4; 
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_bigShieldRad)+xpos, (int(cos(radians((i-strt)*360/leds))*_bigShieldRad)+ypos));
    }
  }
  void medShield(int numb, int positionA, int positionB, float leds) {
    int strt = (128*numb)+64;
    _medShieldRad = size.rigWidth/2/leds*5.12;
    medShieldRad = _medShieldRad * 2 + 4;
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int positionX = int(_shield[positionA][positionB].x);
    int positionY = int(_shield[positionA][positionB].y);
    ////// 5V LED RING for MEDIUM SHIELDS
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_medShieldRad)+int(positionX), (int(cos(radians((i-strt)*360/leds))*_medShieldRad)+int(positionY)));
    }
    ///// PLACE 4 HP LEDS in CENTER OF EACH RING /////
    for (int j = 1; j < 6; j +=2) {
      int space = size.rigWidth/2/20;
      opc.led(strt-64, positionX, positionY+space);
      opc.led(strt-64+1, positionX+space, positionY);
      opc.led(strt-64+2, positionX, positionY-space);
      opc.led(strt-64+3, positionX-space, positionY);
    }
  }

  void smallShield(int numb, int positionA, int positionB, float leds) {
    int strt = (128*numb)+64;
    _smallShieldRad = size.rigWidth/2/32*5.12; // original size size.rigWidth/2/leds*(3.125*2);
    smallShieldRad = _smallShieldRad * 2 + 3; 
    ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
    int positionX = int(_shield[positionA][positionB].x);
    int positionY = int(_shield[positionA][positionB].y);
    /////// RING OF 5V LEDS TO MAKE SAMLL SHIELD ///////
    for (int i=strt; i < strt+leds; i++) {     
      opc.led(i, int(sin(radians((i-strt)*360/leds))*_smallShieldRad)+int(positionX), (int(cos(radians((i-strt)*360/leds))*_smallShieldRad)+int(positionY)));
      ////// 1 HP LED IN MIDDLE OF EACH SMALL SHIELD //////
      for (int j = 0; j < 6; j +=2) {
        opc.led(strt-64, int(positionX), int(positionY));
      }
    }
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// BOOTH LIGHTS /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BoothOPCGrid {
  int boothX, boothY;
  PVector bth, dig;

  BoothOPCGrid(int xpos, int ypos) {
    bth = new PVector(xpos, ypos);
    dig = new PVector(xpos, ypos+20);

    int fc = 2;
    fc*=512;
    int slot = 64;
    //// both lights
    opc.led(fc+(slot*3), int(bth.x), int(bth.y));          // digging light LEFT
    opc.led(fc+(slot*4), int(bth.x)+20, int(bth.y));       // digging light RIGHT
    //// dig lights
    opc.led(fc+(slot*5), int(dig.x), int(dig.y));          // booth light LEFT
    opc.led(fc+(slot*6), int(dig.x)+20, int(dig.y));       // booth light RIGHT
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// CANS CANS CANS ///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class CansOPCGrid {

  int canLength;
  PVector cansLeft = new PVector(size.roof.x, size.roof.y);
  PVector cansRight = new PVector(size.roof.x, size.roof.y);
  //////////////// vertical grid layout

  //CansOPCGrid() {
  //cansLeft = new PVector(size.roof.x, size.roof.y);
  //   cansRight = new PVector(size.roof.x, size.roof.y);    int canLength = size.roofHeight-50;
  //}

  void FMCansMiddle(OPC opc, OPC opc1) {

    cansLeft = new PVector(size.roof.x, size.roof.y);
    cansRight = new PVector(size.roof.x, size.roof.y);

    canLength = size.roofHeight-50;
    int gap = canLength/18;

    int fc = 3;
    fc *=512;
    int slot = 64;
    opc.ledStrip(fc+(slot*0), 6, int(cansLeft.x), int(cansLeft.y)-(gap*6), gap, PI/2, false);   
    opc.ledStrip(fc+(slot*1), 6, int(cansLeft.x), int(cansLeft.y), gap, PI/2, true);   

    fc = 4;
    fc *=512;
    opc1.ledStrip(fc+(slot*0), 6, int(cansLeft.x), int(cansLeft.y)+(gap*6), gap, PI/2, false);
  }

  void FMCansSideToSide(OPC opc, OPC opc1) {

    cansLeft = new PVector(size.roof.x-(size.roofWidth/3), size.roof.y);
    cansRight = new PVector(size.roof.x+(size.roofWidth/3), size.roof.y);

    canLength = size.roofHeight-50;
    int gap = canLength/18;

    int fc = 3;
    fc *=512;
    int slot = 64;

    for (int i = 0; i < 6; i+=2) opc.led(fc+(slot*0)+i, int(cansRight.x), int(cansRight.y-(gap*(9-i))));
    for (int i = 1; i < 6; i+=2) opc.led(fc+(slot*0)+i, int(cansLeft.x), int(cansLeft.y-(gap*(9-i))));

    fc = 4;
    fc *=512;
    for (int i = 0; i < 6; i+=2) opc1.led(fc+(slot*0)+i, int(cansRight.x), int(cansRight.y-(gap*(9-i-12))));
    for (int i = 1; i < 6; i+=2) opc1.led(fc+(slot*0)+i, int(cansLeft.x), int(cansLeft.y-(gap*(9-i-12))));

    for (int i = 0; i < 6; i+=2) opc1.led(fc+(slot*1)+i, int(cansRight.x), int(cansRight.y-(gap*(9-i-6))));
    for (int i = 1; i < 6; i+=2) opc1.led(fc+(slot*1)+i, int(cansLeft.x), int(cansLeft.y-(gap*(9-i-6))));
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// SEEDS ///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SeedsOPCGrid {

  PVector[][] seed = new PVector[5][3];
  int gap = size.roofHeight / 6;
  int seedLength = size.roofHeight / 6 * 5;


  void FMSeeds(OPC opc, OPC opc1) {
    for ( int i = 0; i < 5; i++) seed[i][0] = new PVector(size.roof.x-(size.roofWidth/8), size.roofHeight/(seed.length+1)*(i+1));
    for ( int i = 0; i < 5; i++) seed[i][2] = new PVector(size.roof.x+(size.roofWidth/8), size.roofHeight/(seed.length+1)*(i+1.0));
    seed[0][2] = new PVector(size.roof.x+(size.roofWidth/8), size.roofHeight/(seed.length+1)*(0+1));

    for ( int i = 0; i < 5; i++) seed[i][1] = new PVector(size.roof.x, size.roofHeight/(seed.length+1)*(i+2.5));

    int fc = 3;
    fc*=512;
    int slot = 64;
    for (int i = 0; i < seed.length; i++) opc.led(fc+(slot*(2))+i, int(seed[i][0].x), int(seed[i][0].y)); 
    for (int i = 0; i < seed.length; i++) opc.led(fc+(slot*(3))+i, int(seed[i][2].x), int(seed[i][2].y)); 
    opc.led(fc+(slot*(1)), int(seed[0][1].x), int(seed[0][1].y)); 

    fc = 4;
    fc*=512;
    opc1.led(fc+(slot*(2)), int(seed[2][1].x), int(seed[2][1].y)); 
    opc1.led(fc+(slot*(3)), int(seed[1][1].x), int(seed[1][1].y)); 

    print(seed);
  }
}

class DMXGrid {
  PVector[] pars = new PVector[3];
  PVector[] smoke = new PVector[2];

  void FMSmoke(OPC opc, int xpos, int ypos) {
    smoke[0] = new PVector(xpos, ypos);
    smoke[1] = new PVector(xpos, ypos+20);

    opc.led(7000, int(smoke[0].x), int(smoke[0].y));
    opc.led(7001, int(smoke[1].x), int(smoke[1].y));
  }

  void FMPars(OPC opc, int xpos, int ypos) {
    pars[0] = new PVector(xpos, ypos);
    pars[1] = new PVector(xpos, ypos+20);
    pars[2] = new PVector(xpos, ypos+40);

    opc.led(6048, int(pars[0].x), int(pars[0].y));
    opc.led(6050, int(pars[1].x), int(pars[1].y));

    opc.led(6052, int(pars[0].x+20), int(pars[0].y));
    opc.led(6054, int(pars[1].x+20), int(pars[1].y));

    opc.led(6056, int(pars[2].x), int(pars[2].y));
    opc.led(6058, int(pars[2].x+20), int(pars[2].y));

    pars[0] = new PVector(xpos+10, ypos);
    pars[1] = new PVector(xpos+10, ypos+20);
    pars[2] = new PVector(xpos+10, ypos+40);
  }
}
