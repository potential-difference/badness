class OPCGrid {
  PVector[] mirror = new PVector[12];
  PVector[][] mirrorX = new PVector[7][4];
  PVector[] _mirror = new PVector[12];
  PVector[] seed = new PVector[3];
  PVector[] cansString = new PVector[3];
  PVector[] cans = new PVector[18];
  PVector[] strip = new PVector[6];
  PVector[] controller = new PVector[4];
  PVector uv; 
  PVector booth, dig;
  Rig rig;

  int pd, ld, dist, controllerGridStep, rows, columns;
  float mirrorAndGap, seedLength, _seedLength, seed2Length, _seed2Length, cansLength, _cansLength, _mirrorWidth, mirrorWidth, controllerWidth;

  OPCGrid () {
    pd = 6;             // distance between pixels
    ld = 16;            // number of leds per strip
    dist = 16*3;          // distance between mirrors;
    _mirrorWidth = ld*pd;
    mirrorAndGap = (pd*ld)+dist;

    switch (size.orientation) {
    case PORTRAIT:
      float yTop = size.rig.y - mirrorAndGap;                              // height Valuve for top line of mirrors
      float yBottom = size.rig.y + mirrorAndGap;  
      float yMid = size.rig.y;   
      rows = 3;
      columns = 4;
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-(mirrorAndGap*rows/2));
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-(mirrorAndGap/2));                   /// PVECTORS for MIDDLE GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+(mirrorAndGap/2));  /// PVECTORS for BOTTOM GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][3] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+(mirrorAndGap*rows/2));    /// PVECTORS for TOP GAPS 0-6
      // panel 1
      _mirror[0] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[1] = new PVector (size.rig.x-(mirrorAndGap/2), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[2] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[3] = new PVector (size.rig.x-(mirrorAndGap/2), yMid);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[4] = new PVector (size.rig.x-(mirrorAndGap/2), yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[5] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yBottom);                       /// PVECTORS for CENTER of MIRRORS 0-2
      // panel 2
      _mirror[6] =  new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yBottom);                 /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[7] =  new PVector (size.rig.x+(mirrorAndGap/2), yBottom);                    /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[8] =  new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yMid);                   /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[9] =  new PVector (size.rig.x+(mirrorAndGap/2), yMid);                       /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[10] = new PVector (size.rig.x+(mirrorAndGap/2), yTop);                     /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[11] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yTop);                   /// PVECTORS for CENTER of MIRRORS 0-2
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////// PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE /////////////////////////////////////////////////////
      mirror[0] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yTop);                  
      mirror[1] = new PVector (size.rig.x-(mirrorAndGap/2), yTop);                  
      mirror[2] = new PVector (size.rig.x+(mirrorAndGap/2), yTop);                  
      mirror[3] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yTop);                 
      mirror[4] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yMid);                   
      mirror[5] = new PVector (size.rig.x-(mirrorAndGap/2), yMid);                
      mirror[6] = new PVector (size.rig.x+(mirrorAndGap/2), yMid);                  
      mirror[7] = new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yMid);                    
      mirror[8] = new PVector (size.rig.x-(mirrorAndGap/2)-mirrorAndGap, yBottom);                  
      mirror[9] = new PVector (size.rig.x-(mirrorAndGap/2), yBottom);                 
      mirror[10]= new PVector (size.rig.x+(mirrorAndGap/2), yBottom);                  
      mirror[11]= new PVector (size.rig.x+(mirrorAndGap/2)+mirrorAndGap, yBottom); 
      break;
    case LANDSCAPE: 
      yTop = size.rig.y - (mirrorAndGap/2);                              // height Valuve for top line of mirrors
      yBottom = size.rig.y + (mirrorAndGap/2);  
      rows = 2;
      columns = 6;
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][0] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y-mirrorAndGap);    /// PVECTORS for TOP GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][1] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y);                   /// PVECTORS for MIDDLE GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][2] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y+mirrorAndGap);    /// PVECTORS for BOTTOM GAPS 0-6
      for (int i = 0; i < mirrorX.length; i++) mirrorX[i][3] = new PVector (size.rig.x-(mirrorAndGap*columns/2)+((mirrorAndGap)*i), size.rig.y);    /// PVECTORS for TOP GAPS 0-6
      // panel 1
      _mirror[0] = new PVector (size.rig.x-(mirrorAndGap*2.5), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[1] = new PVector (size.rig.x-(mirrorAndGap*2.5), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[2] = new PVector (size.rig.x-(mirrorAndGap*1.5), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[3] = new PVector (size.rig.x-(mirrorAndGap*1.5), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[4] = new PVector (size.rig.x-(mirrorAndGap*0.5), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[5] = new PVector (size.rig.x-(mirrorAndGap*0.5), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      // panel 2
      _mirror[6] = new PVector (size.rig.x+(mirrorAndGap*0.5), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[7] = new PVector (size.rig.x+(mirrorAndGap*0.5), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[8] = new PVector (size.rig.x+(mirrorAndGap*1.5), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[9] = new PVector (size.rig.x+(mirrorAndGap*1.5), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[10] = new PVector (size.rig.x+(mirrorAndGap*2.5), yTop);                  /// PVECTORS for CENTER of MIRRORS 0-2
      _mirror[11] = new PVector (size.rig.x+(mirrorAndGap*2.5), yBottom);                  /// PVECTORS for CENTER of MIRRORS 0-2
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////// PVECTORS FOR CENTER OF MIRRORS FOR USE IN CODE /////////////////////////////////////////////////////
      mirror[0] = new PVector (size.rig.x-(mirrorAndGap*2.5), yTop);                  
      mirror[1] = new PVector (size.rig.x-(mirrorAndGap*1.5), yTop);                  
      mirror[2] = new PVector (size.rig.x-(mirrorAndGap*0.5), yTop);                  
      mirror[3] = new PVector (size.rig.x+(mirrorAndGap*0.5), yTop);                
      mirror[4] = new PVector (size.rig.x+(mirrorAndGap*1.5), yTop);                   
      mirror[5] = new PVector (size.rig.x+(mirrorAndGap*2.5), yTop);                
      mirror[6] = new PVector (size.rig.x-(mirrorAndGap*2.5), yBottom);                   
      mirror[7] = new PVector (size.rig.x-(mirrorAndGap*1.5), yBottom);                   
      mirror[8] = new PVector (size.rig.x-(mirrorAndGap*0.5), yBottom);                  
      mirror[9] = new PVector (size.rig.x+(mirrorAndGap*0.5), yBottom);                 
      mirror[10]= new PVector (size.rig.x+(mirrorAndGap*1.5), yBottom);                  
      mirror[11]= new PVector (size.rig.x+(mirrorAndGap*2.5), yBottom);
      break;
    }
    mirrorWidth = _mirrorWidth+16;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    booth = new PVector (width - 30, 110);
    dig = new PVector (width - 30, 125);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// MIRRORS //////////////////////////////////////////////
  void mirrorsOPC(OPC opc, OPC opc1, int gridStep) {
    switch (size.orientation) {  
    case PORTRAIT:
      switch(gridStep) {
      case 0:
        for (int i = 0; i < 6; i++) {       /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
          opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
          opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
        }
        for (int i = 6; i < 12; i++) {       /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
          opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
          opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
        }
        break;
      case 1:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8, 0, true);                 
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.8, 0, false);
        break;
      case 2:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, size.rig.x-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6)), size.rig.y, size.rigHeight/64, PI/2, true);                 
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, size.rig.x-(size.rigWidth/2)+(size.rigWidth/12*(i+0.6)), size.rig.y, size.rigHeight/64, PI/2, false);
        break;
      default:
        for (int i = 0; i < 6; i++) {       /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
          opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);
          opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
        }
        for (int i = 6; i < 12; i++) {       /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
          opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip 
          opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
          opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip
        }
        break;
      }
      break;
    case LANDSCAPE:
      switch(gridStep) {
      case 0:    /////////////// LEFT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 0; i < 6; i++) {
          opc.ledStrip((64*(5-i))+(ld*0), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);                 // TOP horizontal strip 
          opc.ledStrip((64*(5-i))+(ld*1), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);             // LEFT vertical strip
          opc.ledStrip((64*(5-i))+(ld*2), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);          // BOTTOM horizontal strip
          opc.ledStrip((64*(5-i))+(ld*3), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);               // RIGHT vertical strip
        }
        /////////////// RIGHT HAND PANNEL OF MIRRORS /////////////////////////////////
        for (int i = 6; i < 12; i++) {
          opc1.ledStrip(512+(64*(i-6))+(ld*0), ld, _mirror[i].x, _mirror[i].y+(ld/2*pd), pd, 0, false);           // Bottom horizontal strip 
          opc1.ledStrip(512+(64*(i-6))+(ld*1), ld, _mirror[i].x+(ld/2*pd), _mirror[i].y, pd, (PI/2), true);       // Right Vertical strip       
          opc1.ledStrip(512+(64*(i-6))+(ld*2), ld, _mirror[i].x, _mirror[i].y-(ld/2*pd), pd, 0, true);           // Top horizontal strip
          opc1.ledStrip(512+(64*(i-6))+(ld*3), ld, _mirror[i].x-(ld/2*pd), _mirror[i].y, pd, (PI/2), false);         // Left Vertical strip
        }
        break;
      case 1:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[2].x, 50+((size.rigHeight-55)/6*i), pd/1.2, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[8].x, 50+((size.rigHeight-55)/6*(i-6)), pd/1.2, 0, true);                 // TOP horizontal strip
        break;
      case 2:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.6, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, _mirror[i].x, _mirror[i].y, pd/3.6, 0, true);
        break;
      case 3:
        for (int i = 0; i < 6; i++) opc.ledStrip((64*(5-i))+(ld*0), ld*4, size.rig.x, 48+((size.rigHeight-55)/12*i), pd*1.8, 0, true);                 // TOP horizontal strip
        for (int i = 6; i < 12; i++) opc1.ledStrip(512+(64*(i-6))+(ld*0), ld*4, size.rig.x, 52+((size.rigHeight-55)/12*(i)), pd*1.8, 0, true);                 // TOP horizontal strip
        break;
      }
      break;
    }
    rigg.position=opcGrid.mirror;
    rigg.positionX=opcGrid.mirrorX;
  }
  ////////////////////////////////////// MIRROR TEST ///////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////// CATERPILLARS ////////////////////////////////////////////////////////////////////////////////
  PVector [] cat = new PVector[12];

  void catipillarsOPC(Rig _rig, OPC opc) {
    rig = _rig;

    int xpos = int(size.roof.x-(size.roofWidth/4));
    int _xpos = xpos;
    println(xpos);
    int ypos = int(size.roof.y);

    ///////////////////// Left Caterpillar - FC 5
    // 6 SQAURES
    int fc = 5 * 512;                       // fadecandy number (first one used is 0)
    int strips = 6;
    int gap = 30;         // X distance between strips
    int pixelDist = 4;                      // Y distance between pixels
    for (int i = 0; i < strips; i++) {
      _xpos = int(xpos+((i-(strips/2))*gap+(gap/2)));
      opc.ledStrip(fc+(i*64), 64, _xpos, ypos, pixelDist, (PI/2), false);
      cat[i] = new PVector (_xpos, ypos);      // PVectors for center of each strip in 2D array - LEFT chandelear is ZERO
    } 

    _xpos = int(xpos+((0-(strips/2))*gap+(gap/2)));

    int vertPixels = 40;

    //FRAME Section 1 - ch.6
    int channel = 6;                   // channel leds are soldered to on the FadeCandy
    int strt = 64*channel+fc;         // starting pixel number for channel
    int leds = 20;
    pixelDist = int(pixelDist*1.8); //(pixelDist*64+gap)/leds;
    int frameXpos = _xpos - gap;
    int frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //left 1/2 middle to top
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);
    frameYpos = int(ypos-(vertPixels/2*pixelDist)-(pixelDist/2));
    int _pixelDist = int((gap*(strips+1.5)/leds)); 
    //top whole left to right
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(180), true); //RICH - WILL 180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //top right side 1/2 right to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); //RICH - WILL -90 MAKE THE PIXEL ORDER GO FROM TOP TO BOTTOM?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //FRAME Section 2 - ch.7
    channel = 7;                   // channel leds are soldered to on the FadeCandy
    strt = 64*channel+fc;         // starting pixel number for channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //right vertical 1/2 middle to bottom
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); 
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);  //// come back to this
    frameYpos = int(ypos+(vertPixels/2*pixelDist)+(pixelDist/2));
    //bottom whole right to left
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(-180), false); //RICH - WILL -180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos - gap;
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //bottom left to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////// RIGHT Caterpillar - FC 6
    fc = 6 * 512;     
    pixelDist = 4;                      // Y distance between pixels
    xpos = int(size.roof.x+(size.roofWidth/4));

    for (int i = 0; i < strips; i++) {
      _xpos = int(xpos+((i-(strips/2))*gap+(gap/2)));
      opc.ledStrip(fc+(i*64), 64, _xpos, ypos, pixelDist, (PI/2), false);
      cat[i+strips] = new PVector (_xpos, ypos);      // PVectors for center of each strip in 2D array - LEFT chandelear is ZERO
    }

    _xpos = int(xpos+((0-(strips/2))*gap+(gap/2)));

    //FRAME Section 1 - ch.6
    channel = 6;                   // channel leds are soldered to on the FadeCandy
    strt = 64*channel+fc;         // starting pixel number for channel
    leds = 20;
    pixelDist = int(pixelDist*1.8);
    frameXpos = _xpos - gap;
    frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //left 1/2 middle to top
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);
    frameYpos = int(ypos-(vertPixels/2*pixelDist)-(pixelDist/2));
    //top whole left to right
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(180), true); //RICH - WILL 180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos - ((vertPixels-leds)*pixelDist/2);
    //top right side 1/2 right to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); //RICH - WILL -90 MAKE THE PIXEL ORDER GO FROM TOP TO BOTTOM?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //FRAME Section 2 - ch.7
    channel = 7;                   // channel leds are soldered to on the FadeCandy
    strt = 64*channel+fc;         // starting pixel number for channel
    leds = 20;
    frameXpos = _xpos+(strips*gap);
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //right vertical 1/2 middle to bottom
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(-90), true); 
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 13;
    frameXpos = _xpos+((strips-1)*gap/2);  //// come back to this
    frameYpos = int(ypos+(vertPixels/2*pixelDist)+(pixelDist/2));
    //bottom whole right to left
    opc.ledStrip(strt, leds, frameXpos, frameYpos, _pixelDist, radians(-180), false); //RICH - WILL -180 MAKE THE PIXEL ORDER GO FROM LEFT TO RIGHT?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    strt = strt+leds;         //next led in same channel
    leds = 20;
    frameXpos = _xpos - gap;
    frameYpos = ypos + ((vertPixels-leds)*pixelDist/2);
    //bottom left to middle
    opc.ledStrip(strt, leds, frameXpos, frameYpos, pixelDist, radians(90), true); //RICH - WILL 90 MAKE THE PIXEL ORDER GO FROM BOTTOM TO TOP?...
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////  set roof position to individual cans positions
    for (int i = 0; i < rig.position.length; i++) {
      rig.position[i].x=opcGrid.cat[i].x-(rig.size.x-(rig.wide/2));
      rig.position[i].y=opcGrid.cat[i].y-(rig.size.y-(rig.high/2));
      //
      //rig.position[i+6].x=opcGrid.cat[i+12].x-(rig.size.x-(rig.wide/2));
      //rig.position[i+6].y=opcGrid.cat[i+12].y-(rig.size.y-(rig.high/2));
    }
    //rig.position[4].x=cat[7].x-(rig.size.x-(rig.wide/2));
    //rig.position[4].y=cans[7].y-(rig.size.y-(rig.high/2));

    //rig.position[7].x=cans[10].x-(rig.size.x-(rig.wide/2));
    //rig.position[7].y=cans[10].y-(rig.size.y-(rig.high/2));
  }


  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// SEEDS ///////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////// CANS //////////////////////////////////////////////////
  void individualCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    float xw = 6;
    for (int i=0; i<cans.length/xw; i++) cans[i] =     new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), rig.size.y-(rig.high/2)+rig.high/(xw+1)*1);
    for (int i=0; i<cans.length/xw; i++) cans[i+3] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), rig.size.y-(rig.high/2)+rig.high/(xw+1)*2);
    for (int i=0; i<cans.length/xw; i++) cans[i+6] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), rig.size.y-(rig.high/2)+rig.high/(xw+1)*3);
    for (int i=0; i<cans.length/xw; i++) cans[i+9] =   new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), rig.size.y-(rig.high/2)+rig.high/(xw+1)*4);
    for (int i=0; i<cans.length/xw; i++) cans[i+12] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), rig.size.y-(rig.high/2)+rig.high/(xw+1)*5);
    for (int i=0; i<cans.length/xw; i++) cans[i+15] =  new PVector (rig.size.x-(rig.wide/2)+(rig.wide/(cans.length/xw+1)*(i+1)), rig.size.y-(rig.high/2)+rig.high/(xw+1)*6);

    int fc = 2 * 512;
    int channel = 64;
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*0+i), int(cans[i].x), int(cans[i].y));                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*1+i), int(cans[i+6].x), int(cans[i+6].y));                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    for (int i = 0; i < cans.length/3; i++) opc.led(fc+(channel*2+i), int(cans[i+12].x), int(cans[i+12].y));                   /////  6 CANS PLUG INTO slot 0 on CANS BOX ///////

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
  void kallidaCansOPC(OPC opc) {
    int fc = 5 * 512;
    int channel = 64;
    int leds = 6;
    pd = int(_cansLength/6);
    opc.ledStrip(fc+(channel*0), leds, int(cansString[0].x), int(cansString[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*1)+(64*channel), leds, int(cansString[1].x), int(cansString[1].y), pd, 0, false);      /////  6 CANS PLUG INTO slot 1 on CANS BOX ///////
    cansLength = _cansLength - (pd/2);
  } /////////////////////////////////////////////////////////////////////////////////////////////////////
  void pickleCansOPC(Rig _rig, OPC opc) {
    rig = _rig;
    _cansLength = size.cansWidth;
    cansString[0] = new PVector(rig.size.x, rig.size.y-(rig.high/4));
    cansString[1] = new PVector(rig.size.x, rig.size.y);
    cansString[2] = new PVector(rig.size.x, rig.size.y+(rig.high/4));

    int fc = 2 * 512;
    int channel = 64;
    int leds = 6;
    pd = int(_cansLength/6);
    opc.ledStrip(fc+(channel*5), leds, int(cansString[0].x), int(cansString[0].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*6), leds, int(cansString[1].x), int(cansString[1].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*7), leds, int(cansString[2].x), int(cansString[2].y), pd, 0, false);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 

    cansLength = _cansLength - (pd/2);
  } /////////////////////////////////////////////////////////////////////////////////////////////////////
  void kingsHeadCansOPC(Rig _rig, OPC opc) {
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
    opc.ledStrip(fc+(channel*1), leds, int(cansString[1].x), int(cansString[1].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    opc.ledStrip(fc+(channel*2), leds, int(cansString[2].x), int(cansString[2].y), pd, 0, true);                   /////  6 CANS PLUG INTO slot 0 on CANS BOX /////// 
    cansLength = _cansLength - (pd/2);
  }
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

  ////////////////////////////////////// BOOTH LIGHTS ///////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void pickleBoothOPC(OPC opc) {
    int fc = 2 * 512;
    int channel = 64;       

    opc.led(fc+(channel*0), int(dig.x-5), int(dig.y));
    opc.led(fc+(channel*1), int(dig.x+5), int(dig.y));

    opc.led(fc+(channel*2), int(booth.x-5), int(booth.y));
  }

  void kingsHeadBoothOPC(OPC opc) {
    int fc = 4 * 512;
    int channel = 64;       

    opc.led(fc+(channel*3), int(dig.x-5), int(dig.y));
    opc.led(fc+(channel*2), int(dig.x+5), int(dig.y));

    opc.led(fc+(channel*1), int(booth.x-5), int(booth.y));
  }
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
