/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// CANS //////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// MIRRORS /////////////////////////////////////////////////////////////////////////////////////////////////////

class OPCGrid {
  PVector[] mirror = new PVector[12];
  PVector[][] mirrorX = new PVector[7][3];
  PVector[] mirrorT = new PVector[7];
  PVector[] mirrorB = new PVector[7];
  PVector[] _mirror = new PVector[12];
  PVector uv; 

  float _mirrorWidth, mirrorWidth;
  int pd, ld, dist, mw, mh, _rigx, _rigy;
  int rigx = int(size.rig.x);
  int rigy = int(size.rig.y);
  float high;
  float wide;
  float mirrorAndGap;
  float seedWidth, cansWidth;

  int canWidth, can1X, can2X, can1Y, can2Y;
  float seed1Y, seed2Y, seed1X, seed2X, seed3X, seed3Y;

  OPCGrid () {
    pd = 6;             // distance between pixels
    ld = 16;            // number of leds per strip
    dist = 16;          // distance between mirrors;
    _mirrorWidth = ld*pd;

    mirrorAndGap = (pd*ld)+dist;

    float xStart = size.rig.x - (pd*ld*2)-(pd*ld/2)-(dist*2)-(dist/2);     // position for left hand mirror to start
    float yTop = size.rig.y - (pd*ld)-(dist);                              // height Valuve for top line of mirrors
    float yBottom = size.rig.y + (pd*ld) + dist;  
    float yMid = size.rig.y;                                                // height for bottom line of mirrors

    for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector ((xStart+(pd*ld*i))+(dist*i)-(pd*ld/2)-(dist/2), rigy-(dist)-(pd*ld));    /// PVECTORS for TOP GAPS 0-6
    for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector ((xStart+(pd*ld*i))+(dist*i)-(pd*ld/2)-(dist/2), rigy);                   /// PVECTORS for MIDDLE GAPS 0-6
    for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector ((xStart+(pd*ld*i))+(dist*i)-(pd*ld/2)-(dist/2), rigy+(dist)+(pd*ld));    /// PVECTORS for BOTTOM GAPS 0-6
    // panel 1
    _mirror[0] = new PVector (rigx-(mirrorAndGap/2)-mirrorAndGap, yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
    _mirror[1] = new PVector (rigx-(mirrorAndGap/2), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2

    _mirror[2] = new PVector (rigx-(mirrorAndGap/2)-mirrorAndGap, yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
    _mirror[3] = new PVector (rigx-(mirrorAndGap/2), yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2

    _mirror[4] = new PVector (rigx-(mirrorAndGap/2), yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
    _mirror[5] = new PVector (rigx-(mirrorAndGap/2)-mirrorAndGap, yBottom);                       /// PVECTORS for CENTER of MIRRORS 0-2

    // panel 2
    _mirror[6] = new PVector (rigx+(mirrorAndGap/2)+mirrorAndGap, yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
    _mirror[7] = new PVector (rigx+(mirrorAndGap/2), yBottom);                    /// PVECTORS for CENTER of MIRRORS 0-2

    _mirror[8] = new PVector (rigx+(mirrorAndGap/2)+mirrorAndGap, yMid);                   /// PVECTORS for CENTER of MIRRORS 0-2
    _mirror[9] = new PVector (rigx+(mirrorAndGap/2), yMid);                       /// PVECTORS for CENTER of MIRRORS 0-2

    _mirror[10] = new PVector (rigx+(mirrorAndGap/2), yTop);                     /// PVECTORS for CENTER of MIRRORS 0-2
    _mirror[11] = new PVector (rigx+(mirrorAndGap/2)+mirrorAndGap, yTop);                   /// PVECTORS for CENTER of MIRRORS 0-2
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE
    mirror[0] = new PVector (rigx-(mirrorAndGap/2)-mirrorAndGap, yTop);                  
    mirror[1] = new PVector (rigx-(mirrorAndGap/2), yTop);                  
    mirror[2] = new PVector (rigx+(mirrorAndGap/2), yTop);                  
    mirror[3] = new PVector (rigx+(mirrorAndGap/2)+mirrorAndGap, yTop);                 

    mirror[4] = new PVector (rigx-(mirrorAndGap/2)-mirrorAndGap, yMid);                   
    mirror[5] = new PVector (rigx-(mirrorAndGap/2), yMid);                
    mirror[6] = new PVector (rigx+(mirrorAndGap/2), yMid);                  
    mirror[7] = new PVector (rigx+(mirrorAndGap/2)+mirrorAndGap, yMid);                    

    mirror[8] = new PVector (rigx-(mirrorAndGap/2)-mirrorAndGap, yBottom);                  
    mirror[9] = new PVector (rigx-(mirrorAndGap/2), yBottom);                 
    mirror[10] = new PVector (rigx+(mirrorAndGap/2), yBottom);                  
    mirror[11] = new PVector (rigx+(mirrorAndGap/2)+mirrorAndGap, yBottom); 

    mirrorWidth = _mirrorWidth+16;        /// make bigger for full coverage in animations
    high = mirrorAndGap*4;
    wide = mirrorAndGap*3;
  }

  void kallidaMirrors(OPC opc, OPC opc1, int gridStep) {
    mh = int(mirrorAndGap*3);

    if (gridStep == 0) {
      /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
      for (int i = 0; i < 6; i++) {
        opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
        opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
        opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
        opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
      }
      /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
      for (int i = 6; i < 12; i++) {
        opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
        opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
        opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
        opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
      }
    } 
    //if (gridStep == 1) {                 
    //  float ygap = mirrorAndGap*3/6;
    //  for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, rigx-mirrorAndGap+4, rigy+(ygap*(i-2.5)), pd/1.8, 0, true);                 
    //  for (int i = 12; i >=6 ; i--) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, rigx+mirrorAndGap-4, rigy+(ygap*(i-2.5-6)), pd/1.8, 0, true);
    //}

    if (gridStep == 1) {
      for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8, 0, true);                 
      for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8, 0, false);
    }

    if (gridStep == 2) {
      for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, rigx-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6)), rigy, size.rigHeight/64, PI/2, true);                 
      for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, rigx-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6)), rigy, size.rigHeight/64, PI/2, false);
    }
  }


  void kallidaSeeds(OPC opc) {
    int fc = 2;                       // fadecandy number (first one used is 0)
    fc *=512;
    int channel = 0;
    int strt = 64*channel+fc;         // starting pixel number for cicle
    int leds = 64;                    // leds in strip
    int pd = 6;
  
    seedWidth = 110*pd;

    seed1X = size.rig.x;
    seed2X = size.rig.x;
    seed3X = size.rig.x;

    seed1Y = size.rig.y-(size.rigHeight/1.5);
    seed2Y = size.rig.y+(size.rigHeight/1.5);
    seed3Y = size.rig.y;


    ///////////////////////////////////// SEED 1 ///////////////////////////////////////////////
    opc.ledStrip(strt, leds, seed1X-(55*pd-(leds/2*pd)), seed1Y, pd, 0, false);     
    strt = strt+leds;               //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seed1X+(55*pd-(leds/2*pd)),seed1Y, pd, 0, true);

    ///////////////////////////////////// SEED 2 //////////////////////////////////////////////
    channel = 2;
    strt = 64*channel+fc;             // starting pixel number for cicle
    leds = 64;      
    opc.ledStrip(strt, leds, seed2X-(55*pd-(leds/2*pd)), seed2Y, pd, 0, false);             
    strt = strt+leds;                 //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seed2X+(55*pd-(leds/2*pd)), seed2Y, pd, 0, true);
    ///////////////////////////////////// SEED 3 //////////////////////////////////////////////
       channel = 4;
    strt = 64*channel+fc;         
    leds = 64;    
    pd = 4;
    opc.ledStrip(strt, leds, seed3X, seed3Y-(55*pd-(leds/2*pd)), pd, PI/2, false);             
    strt = strt+leds;                 //next led in same channel
    leds = 46;
    opc.ledStrip(strt, leds, seed3X, seed3Y+(55*pd-(leds/2*pd)), pd, PI/2, true);
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// CANS //////////////////////////////////////////

  void kallidaCans(OPC opc) {
    int wide = 250;
    int gap = wide/6;
    int fc = 4;
    fc *=512;
    int slot = 64;

    canWidth = wide;
    can1X = int(size.rig.x-((mirrorAndGap*1.5)+(wide/2.5)));
    can2X = int(size.rig.x-((mirrorAndGap*1.5)+(wide/2.5)));

    can1Y = int(size.rig.y-(mirrorAndGap/2));
    can2Y = int(size.rig.y+(mirrorAndGap/2));

    opc.ledStrip(fc+(slot*1), 6, int(can1X), int(can1Y), gap, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
    opc.ledStrip(fc+(slot*2), 6, int(can1X), int(can2Y), gap, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX ///////

    //////////////////////////////////////////// UV /////////////////////////////////////////////

    uv = new PVector(size.rig.x+5, size.rig.y);
    opc.led(fc+(slot*4), int(uv.x), int(uv.y));
  }

  void kallidaController(OPC opc, OPC opc2, int controllerGridStep) {

    int fc = 3;                       // fadecandy number (first one used is 0)
    fc *=512;
    int channel = 64;
    int leds = 23;                    // leds in strip
    int pd = 3;                // Y distance between pixels
    float xpos;
    float ypos;

    if (controllerGridStep == 0) {

      xpos = size.rig.x-(mirrorAndGap/2)-mirrorAndGap;
      ypos = size.rig.y-(mirrorAndGap);

      /////////////////////////////////// CONTROLLERS A //////////////////////////////

      opc.ledStrip(fc+(channel*0), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos-+(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*1), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      xpos = size.rig.x -(mirrorAndGap/2);
      ypos = size.rig.y ;

      opc.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-+(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

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
      /////////////////////////////////// CONTROLLERS B //////////////////////////////
      fc = 5;                       // fadecandy number (first one used is 0)
      fc *=512;

      xpos = size.rig.x+(mirrorAndGap/2)+mirrorAndGap;
      ypos = size.rig.y-(mirrorAndGap);

      /////////////////////////////////// CONTROLLERS B //////////////////////////////

      opc2.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc2.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      xpos = size.rig.x +(mirrorAndGap/2);
      ypos = size.rig.y ;

      opc2.ledStrip(fc+(channel*0), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      opc2.ledStrip(fc+(channel*1), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);
    }

    if (controllerGridStep == 1) {

      xpos = size.rig.x-(mirrorAndGap/2);
      ypos = size.rig.y-(mirrorAndGap);

      /////////////////////////////////// CONTROLLERS A //////////////////////////////

      opc.ledStrip(fc+(channel*0), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*1), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      xpos = size.rig.x -(mirrorAndGap/2);
      ypos = size.rig.y +(mirrorAndGap) ;

      opc.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////// CONTROLLERS B //////////////////////////////
      fc = 5;                       // fadecandy number (first one used is 0)
      fc *=512;

      xpos = size.rig.x+(mirrorAndGap/2);
      ypos = size.rig.y-(mirrorAndGap);

      /////////////////////////////////// CONTROLLERS B //////////////////////////////

      opc2.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc2.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      xpos = size.rig.x +(mirrorAndGap/2);
      ypos = size.rig.y+mirrorAndGap ;

      opc2.ledStrip(fc+(channel*0), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      opc2.ledStrip(fc+(channel*1), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);
    }
    if (controllerGridStep == 2) {

      xpos = size.rig.x-(mirrorAndGap/2)-(mirrorAndGap);
      ypos = size.rig.y;

      /////////////////////////////////// CONTROLLERS A //////////////////////////////

      opc.ledStrip(fc+(channel*0), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*1), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      xpos = size.rig.x -(mirrorAndGap/2);
      ypos = size.rig.y;

      opc.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////// CONTROLLERS B //////////////////////////////
      fc = 5;                       // fadecandy number (first one used is 0)
      fc *=512;

      xpos = size.rig.x+(mirrorAndGap/2);
      ypos = size.rig.y;

      /////////////////////////////////// CONTROLLERS B //////////////////////////////
      opc2.ledStrip(fc+(channel*0), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      opc2.ledStrip(fc+(channel*1), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      xpos = size.rig.x +(mirrorAndGap/2)+mirrorAndGap;
      ypos = size.rig.y;

      opc2.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc2.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);
    }

    if (controllerGridStep == 3) {

      xpos = size.rig.x-(mirrorAndGap/2)-(mirrorAndGap);
      ypos = size.rig.y+(mirrorAndGap)+(mirrorAndGap)-15;

      /////////////////////////////////// CONTROLLERS A //////////////////////////////
      opc.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      xpos = size.rig.x -(mirrorAndGap/2);

      ypos = size.rig.y+(mirrorAndGap)+(mirrorAndGap)-15;
      opc.ledStrip(fc+(channel*0), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);

      opc.ledStrip(fc+(channel*1), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////// CONTROLLERS B //////////////////////////////
      fc = 5;                       // fadecandy number (first one used is 0)
      fc *=512;

      xpos = size.rig.x+(mirrorAndGap/2);
      ypos = size.rig.y+(mirrorAndGap)+(mirrorAndGap)-15;

      opc2.ledStrip(fc+(channel*2), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*2)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, true);

      opc2.ledStrip(fc+(channel*3), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*3)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, false);

      xpos = size.rig.x +(mirrorAndGap/2)+mirrorAndGap;
      ypos = size.rig.y+(mirrorAndGap)+(mirrorAndGap)-15;

      opc2.ledStrip(fc+(channel*0), 23, xpos+(leds/2*pd+(pd/2)), ypos, pd, PI/2, false);
      opc2.ledStrip(fc+(channel*0)+leds, 23, xpos, ypos+(leds/2*pd+(pd/2)), pd, 0, true);

      opc2.ledStrip(fc+(channel*1), 23, xpos-(leds/2*pd+(pd/2)), ypos, pd, PI/2, true);
      opc2.ledStrip(fc+(channel*1)+leds, 23, xpos, ypos-(leds/2*pd+(pd/2)), pd, 0, false);
    }
  }


  void mirrorTest(boolean toggle, int mirrorStep) {
    /////////////////////////// TESTING MIRROR ORENTATION //////////////////
    if (toggle) {
      fill(0);
      rect(mirror[mirrorStep].x+(mirrorWidth/2), mirror[mirrorStep].y+(mirrorWidth/4), 3, mirrorWidth/2);
      rect(mirror[mirrorStep].x-(mirrorWidth/2), mirror[mirrorStep].y-(mirrorWidth/4), 3, mirrorWidth/2);
      fill(200);
      rect(mirror[mirrorStep].x+(mirrorWidth/4), mirror[mirrorStep].y+(mirrorWidth/2), mirrorWidth/2, 3);
      rect(mirror[mirrorStep].x-(mirrorWidth/4), mirror[mirrorStep].y-(mirrorWidth/2), mirrorWidth/2, 3);
      println("TESTING: "+mirrorStep);
    }
  }
}
