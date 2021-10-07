void SpiralShieldGrid() {
  //smallShield(0, 8, 48); ///// SLOT b0 on BOX /////
  medShield(1, 0, 33);   ///// SLOT b1 on BOX ///// 
  smallShield(2, 2, 48); ///// SLOT b2 on BOX /////
  medShield(3, 3, 32);   ///// SLOT b3 on BOX /////
  smallShield(4, 5, 48); ///// SLOT b4 on BOX /////
  medShield(5, 6, 32);   ///// SLOT b5 on BOX /////
  bigShield(0, mx, my);     ///// SLOT b7 on BOX /////
  ballGrid(2, 1);
  ballGrid(0, 4);
  ballGrid(1, 7);
  /////////////////////////// increase size of radius so its covered when drawing over it in the sketch
  smallShieldRad +=3;
  medShieldRad +=3;
  bigShieldRad +=3;
}

PVector[] mShd = new PVector[9];
PVector[] sShd = new PVector[9];
PVector[] ball = new PVector[9]; 
PVector[] mShdP = new PVector[9];
PVector[] sShdP = new PVector[9];
PVector[] ballP = new PVector[9]; 
// new PVectors for positions of shields
PVector[][] shld = new PVector[9][3];
PVector[][] shldP = new PVector[9][3];


void shieldRingSetup(int xPosition, int yPosition, int numberOfPositions, int numberOfShields, float medRingSize, float smallRingSize, float ballRingSize) {

  //shieldRingSetup(mx, my, 6, 9, medRingSize, smallRingSize, ballRingSize);    ////// SETUP RING SIZE FOR SHIELD POSITION, number of postitions on ring //////

  ///// MEDIUM SHIELD RING SETUP /////
  for (int i = 0; i < mShd.length; i++) {    
    float xpos = int(sin(radians((i)*360/numberOfShields))*medRingSize*2)+xPosition;
    float ypos = int(cos(radians((i)*360/numberOfShields))*medRingSize*2)+yPosition;
    mShdP[i] = new PVector (xpos, ypos);
    shldP[i][0] = new PVector (xpos, ypos);
    xpos = int(sin(radians((i)*360/numberOfPositions))*medRingSize*2)+xPosition;
    ypos = int(cos(radians((i)*360/numberOfPositions))*medRingSize*2)+yPosition;
    mShd[i] = new PVector (xpos, ypos);
    shld[i][0] = new PVector (xpos, ypos);
  }
  ///// SMALL SHIELD RING SETUP /////
  for (int i = 0; i < sShd.length; i++) {    
    float xpos = int(sin(radians((i)*360/numberOfShields))*smallRingSize*2)+xPosition;
    float ypos = int(cos(radians((i)*360/numberOfShields))*smallRingSize*2)+yPosition;
    sShdP[i] = new PVector (xpos, ypos);
    shldP[i][1] = new PVector (xpos, ypos);
    xpos = int(sin(radians((i)*360/numberOfPositions))*smallRingSize*2)+xPosition;
    ypos = int(cos(radians((i)*360/numberOfPositions))*smallRingSize*2)+yPosition;
    sShd[i] = new PVector (xpos, ypos);
    shld[i][1] = new PVector (xpos, ypos);
  }
  ///// BALL RING SETUP /////
  for (int i = 0; i < ball.length; i++) {    
    float xpos = int(sin(radians((i)*360/numberOfShields))*ballRingSize*2)+xPosition;
    float ypos = int(cos(radians((i)*360/numberOfShields))*ballRingSize*2)+yPosition;
    ballP[i] = new PVector (xpos, ypos);
    shldP[i][2] = new PVector (xpos, ypos);
    xpos = int(sin(radians((i)*360/numberOfPositions))*ballRingSize*2)+xPosition;
    ypos = int(cos(radians((i)*360/numberOfPositions))*ballRingSize*2)+yPosition;
    ball[i] = new PVector (xpos, ypos);
    shld[i][2] = new PVector (xpos, ypos);
  }
}

void ballGrid(int numb, int position) {
  opc.led(1024+(64*numb), int(ballP[position].x), int(ballP[position].y));
}

float bigShieldRad;
void bigShield(int numb, int xpos, int ypos) {
  int strt = (128*numb)+64; 
  ////// HIGH POWER LED RING ////
  int space = mw/2/18;
  opc.led(strt-64, xpos, ypos+space);
  opc.led(strt-64+1, xpos+space, ypos);
  opc.led(strt-64+2, xpos, ypos-space);
  opc.led(strt-64+3, xpos-space, ypos);
  ///// 5V LED STRIP ////
  int leds = 64;
  bigShieldRad = mw/leds*7;              
  for (int i=strt; i < strt+leds; i++) {     
    opc.led(i, int(sin(radians((i-strt)*360/leds))*bigShieldRad)+xpos, (int(cos(radians((i-strt)*360/leds))*bigShieldRad)+ypos));
  }
}
float medShieldRad;
void medShield(int numb, int position, float leds) {
  int strt = (128*numb)+64;
  medShieldRad = mw/2/leds*5.12;

  ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
  int positionX = int(mShdP[position].x);
  int positionY = int(mShdP[position].y);

  ////// 5V LED RING for MEDIUM SHIELDS
  for (int i=strt; i < strt+leds; i++) {     
    opc.led(i, int(sin(radians((i-strt)*360/leds))*medShieldRad)+int(positionX), (int(cos(radians((i-strt)*360/leds))*medShieldRad)+int(positionY)));
  }
  ///// PLACE 4 HP LEDS in CENTER OF EACH RING /////
  for (int j = 1; j < 6; j +=2) {
    int space = mw/2/20;
    opc.led(strt-64, positionX, positionY+space);
    opc.led(strt-64+1, positionX+space, positionY);
    opc.led(strt-64+2, positionX, positionY-space);
    opc.led(strt-64+3, positionX-space, positionY);
  }
}

float smallShieldRad;
void smallShield(int numb, int position, float leds) {
  int strt = (128*numb)+64;
  smallShieldRad = mw/2/leds*(3.125*2);
  /////// RING OF 5V LEDS TO MAKE SAMLL SHIELD ///////
  for (int i=strt; i < strt+leds; i++) {     
    opc.led(i, int(sin(radians((i-strt)*360/leds))*smallShieldRad)+int(sShdP[position].x), (int(cos(radians((i-strt)*360/leds))*smallShieldRad)+int(sShdP[position].y)));

    ////// 1 HP LED IN MIDDLE OF EACH SMALL SHIELD //////
    for (int j = 0; j < 6; j +=2) {
      opc.led(strt-64, int(sShdP[position].x), int(sShdP[position].y));
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void FMShieldGrid(int xpos, int ypos) {
  float medRingSize = mw/4.5;        ///// SIZE OF RING BIG SHIELDS ARE POSITIONED ON
  float smallRingSize = mw/8.4;        ///// SIZE OF RING SMALL SHIELDS ARE POSITIONED O 
  float ballRingSize = width/6;         ///// SIZE OF RING BALLS ARE POSITIONED ON
  shieldRingSetup(xpos, ypos, 6, 9, medRingSize, smallRingSize, ballRingSize);    ////// SETUP RING SIZE FOR SHIELD POSITION, number of postitions on ring //////

  //// SHIELDS - #1 slot on box; #2 position on ring; #3 number of LEDS in 5v ring 
  smallShield(0, 1, 48); ///// SLOT b0 on BOX /////   
  medShield(1, 1, 33);   ///// SLOT b1 on BOX ///// 

  smallShield(2, 5, 48); ///// SLOT b2 on BOX /////
  medShield(3, 5, 32);   ///// SLOT b3 on BOX /////

  smallShield(4, 3, 48); ///// SLOT b4 on BOX /////
  medShield(5, 3, 32);   ///// SLOT b5 on BOX /////

  bigShield(7, xpos, ypos);     ///// SLOT b7 on BOX /////

  ballGrid(2, 2);
  ballGrid(0, 4);
  ballGrid(1, 0);

  /////////////////////////// increase size of radius so its covered when drawing over it in the sketch
  smallShieldRad +=3;
  medShieldRad +=3;
  bigShieldRad +=3;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// PICKELD CANS & BOOTH //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////// ROOF CANS START AT 2048 !!! SPUTNIK BOX STARTS at 1536 !!!! ///////////////
///// BOOTH LIGHTS ///////   ///// 4-7 on box /////
int boothX, boothY;
void boothLights(int xpos, int ypos) {
  boothX = xpos;
  boothY = ypos;

  int fc = 2;
  fc*=512;
  int slot = 64;

  opc.led(fc+(slot*3), boothX, boothY);       // digging light LEFT
  opc.led(fc+(slot*4), boothX+20, boothY);    // digging light RIGHT

  opc.led(fc+(slot*5), boothX, boothY+30);       // booth light LEFT
  opc.led(fc+(slot*6), boothX+20, boothY+30);       // booth light RIGHT
}

int canX;
int canY;
int canWidth;
//////////////// ROOF CANS START AT 2048 !!! SPUTNIK BOX STARTS at 1536 !!!! ///////////////
//////////////// vertical grid layout
void NYEcans() {
  int gap = mw/11;
  int fc = 4;
  fc *=512;
  int slot = 64;

  canX = mx/2*3-20;
  canY = my-120;
  canWidth = 220;

  opcWifi.ledStrip(fc+(slot*1), 6, int(canX), int(canY), gap, 0, false);  /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
  opcWifi.ledStrip(fc+(slot*2), 6, int(canX), int(canY+2), gap, 0, false);  /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 

  //opc.ledStrip(fc+(slot*2), 3, int(can1X), int(can1Y), gap, (PI/2), !toggle);     /////  3 CANS PLUG INTO slot 2 on CANS BOX /////// 
  //opc.ledStrip(fc+(slot*3), 3, int(can1X), int(can1Y+(gap*4+gap/2)), gap, (PI/2), toggle);  /////  6 CANS PLUG INTO slot 3 on CANS BOX ///////
  //opc.ledStrip(fc+(slot*4), 3, int(can1X), int(can2Y), gap, (PI/2), !toggle);  /////  3 CANS PLUG INTO slot 4 on CANS BOX ///////
}

void PickledCans() {
  int gap = 40;
  int fc = 2;
  fc *=512;
  int slot = 64;

  canX = mx;
  canY = my+(180);

  opc.ledStrip(fc+(slot*7), 6, int(canX), int(canY), gap, 0, true);  /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
  //opc.ledStrip(fc+(slot*2), 3, int(can1X), int(can1Y), gap, (PI/2), !toggle);     /////  3 CANS PLUG INTO slot 2 on CANS BOX /////// 
  //opc.ledStrip(fc+(slot*3), 3, int(can1X), int(can1Y+(gap*4+gap/2)), gap, (PI/2), toggle);  /////  6 CANS PLUG INTO slot 3 on CANS BOX ///////
  //opc.ledStrip(fc+(slot*4), 3, int(can1X), int(can2Y), gap, (PI/2), !toggle);  /////  3 CANS PLUG INTO slot 4 on CANS BOX ///////
}
