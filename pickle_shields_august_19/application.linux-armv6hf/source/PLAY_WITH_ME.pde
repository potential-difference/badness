void playWithMe() {
  float base = 0.4;
  float top = stutter*0.1;
  blendMode(NORMAL);

  color col1a = c;
  color col2a = flash;

  if (keyT[42]) {
    col1a = 0;
    col2a = 0;
    base = 1;
    top = 1;
  }

  /////////////////////// TOGGLE KEYS ///////////////////////
  ////////////////////////////////////////////////////////////

  ////  if (shift) {
  //// if (keyPressed) {
  //if (keyP[int('7')]) bigHP(col1a, base+top);
  //if (keyP[int('8')]) bigRing(col2a, base+top);

  //if (keyP[int('4')]) smallHP(col2a, base+top);
  //if (keyP[int('5')]) smallRing(col1a, base+top);

  //if (keyP[int('1')]) medHP(col2a, base+top);
  //if (keyP[int('2')]) medRing(col1a, base+top);

  //if (keyP[int('0')]) balls(col2a, base+top);

  //if (keyP[int('.')]) cans(col2a, base+top);
  ////if (keyP[int('-')]) cansRight(col2a, base+top);


  //if (keyT[55])       bigHP(col1a, base+top);
  //if (keyT[56])       bigRing(col2a, base+top);

  //if (keyT[52])     smallHP(col2a, base+top);
  //if (keyT[53])      smallRing(col1a, base+top);

  //if (keyT[49])      medHP(col1a, base+top);
  //if (keyT[50])       medRing(col2a, base+top);

  //if (keyT[48])     balls(col2a, base+top);

  //if (keyT[46])     cans(col2a, base+top*cc[8]);
  ////if (keyT[45])      cansRight(col2a, base+top*cc[7]);

  //// OVERRIDE ////
  //if (minus)  allOff();
  //if (keyP[int(' ')]) allOff();

  //////////////////////// PLAY WITH YOURSELF - PAD /////////////////////
  float speed = 1;
  float spd = 1;
  float chng = map(cc[3], 0, 1, -1, 1);  /// first pad button controls change - speed altered by first knob

  //////////////////////////////////////////////////////// FUCTION EFFECTS ////////////////////////////////////////////////
  if (cc[102] > 0) {
    //if (keyP[55]) {
    for (int i=0; i<4; i++) function[i] = stutter; 
    println("FUNCTION = STUTTER");
  }
  //////////////////////////////////////////////////////// ALPAH EFFECTS ///////////////////////////////
  if (cc[103] > 0) {   
    //if (keyP[56]) {
    for (int i=0; i<4; i++) alpha[i] = (alpha[i]*cc[3]/2)+(stutter*cc[3]);
    bt = (bt*cc[3]/2)+(stutter*cc[3]);
    bt1 = (bt1*cc[3]/2)+(stutter*cc[3]);

    println("ALPHA = STUTTER * knob 3");
  }


  if (cc[104] > 0) {
    //if (keyP[52]) {
    for (int i=0; i<4; i++) {
      alpha[i] = cc[4];
      //rigDimmer = 1;
      alpha1[i] = cc[4];
      bt = cc[4];
      bt1 = cc[4];
    }
    println("ALPHA = 1");
  }
  if (cc[108] > 0) {
    //if (keyP[53]) {
    for (int i=0; i<4; i++) {
      alpha[i] = 0;
      alpha1[i] = 0;
      bt = 0;
      bt1 = 0;
    }
    println("ALPHA 1 = 0");
  }

  /////////////////////////////////////////////////////// COLOR EFFECTS //////////////////////////////////////////////////////////////////
  //if (cc[106] > 0) {
  //  c = lerpColor(col[co1], col[co], cc[6]);
  //  flash = lerpColor(col[co], col[co1], cc[6]);
  //  println("COLOR LERP");
  //}
  //if (keyP[50]) {
  if ( cc[105] > 0) {
    colorFlip(true); 
    println("COLOR FLIP");
  }
  if (cc[101] > 0) {
    //if (keyP[51]) {
    colorSwap((cc[1]+1)*10000000);  
    println("COLOR SWAP * KNOB 1");
  }

  //if (cc[105]>0) beatSlider = cc[5];
  //    //triangleStrobeBANG(4, cc[5]);
  //    blendMode(LIGHTEST);
  //    image(vis[4], mx, my);
  //    println("STROBE - brightness * knob 8");
  //    blendMode(NORMAL);
  //  }
  ////////////// *** change these to bang buttons ///////////////
  //if (keyP[97]) portal(0, 0, 1);  
  //if (keyP[115]) portal2(0, 0, 1);
}
