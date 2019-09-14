boolean roofClashToggle;


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

  if (keyT[122]) roofClashToggle = true;
  else roofClashToggle = false;

  //////////////////////////////////////////////////////// FUCTION EFFECTS ////////////////////////////////////////////////
  if (cc[101] > 0) {
    stutter = map(sin(timer[4]*(cc[1]*16+1)), -1, 1, 0, 1);        
    for (int i=0; i<4; i++) function[i] = stutter; 
    println("FUNCTION = STUTTER * knob 1");
  }
  //////////////////////////////////////////////////////// ALPAH EFFECTS ///////////////////////////////
  if (cc[102] > 0) {   
    stutter = map(sin(timer[4]*(cc[1]*100+3)), -1, 1, 0, 1);        
    for (int i=0; i<4; i++) alpha[i] = (alpha[i]*cc[2]/2)+(stutter*cc[2]);
    for (int i=0; i<4; i++) roofAlpha[i] = (roofAlpha[i]*cc[2]/2)+(stutter*cc[2]);
    bt = (bt*cc[2]/2)+(stutter*cc[2]);
    bt1 = (bt1*cc[2]/2)+(stutter*cc[2]);
    roofBt = (bt*cc[2]/2)+(stutter*cc[2]);
    roofBt1 = (bt1*cc[2]/2)+(stutter*cc[2]);
    println("ALPHA = STUTTER * knob 2, (SPEED * knob 1)");
  }
  /////////////////////////////////////////////////////// COLOR EFFECTS //////////////////////////////////////////////////////////////////
  if (cc[103] > 0) {
    colorSwap(cc[3]*0.9999999999);
    println("COLOR SWAP * KNOB 3");
  }
  if ( cc[104] > 0) {
    colorFlip(true); 
    println("COLOR FLIP");
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////// ON OFF BUTTONS ///////////////////////////////
  if (cc[105] > 0) {
    for (int i=0; i<4; i++) {
      alpha[i] = 0;
      alpha1[i] = 0;
      bt = 0;
      bt1 = 0;
    }
    println("RIG OFF");
  }
  if (cc[106] > 0) {
    for (int i=0; i<4; i++) {
      alpha[i] = cc[4];
      alpha1[i] = cc[4];
      bt = cc[4];
      bt1 = cc[4];
    }
    println("RIG ON");
  }
  if (cc[107] > 0) {
    for (int i=0; i<4; i++) {
      roofAlpha[i] = 0;
      roofAlpha1[i] = 0;
      roofBt = 0;
      roofBt1 = 0;
    }
    println("ROOF OFF");
  }
  if (cc[108] > 0) {
    roofClashToggle = true;
    println("CANS CLASH");
  } else roofClashToggle = false;
}

void drumButtons() {
  float bangAdjust = 1;
  bangAdjust = cc[11];
  ////////////////////////////////// RIG BUTTONS ///////////////////////////////////////
  if (cc[109] > 0) {
    // big shield eye
    fill(flash, 360*cc[109]*bangAdjust);
    ellipse(size.rig.x, size.rig.y, grid.bigShieldRad, grid.bigShieldRad);
    fill(c, 360*cc[109]*bangAdjust);
    ellipse(size.rig.x, size.rig.y, 50, 50);
  }
  if (cc[110] > 0) {
    // smallsheilds
    fill(c, 360*cc[110]*bangAdjust);
    ellipse(grid.shield[2][0].x, grid.shield[2][0].y, grid.medShieldRad, grid.medShieldRad);
    ellipse(grid.shield[6][0].x, grid.shield[6][0].y, grid.medShieldRad, grid.medShieldRad);
    ellipse(grid.shield[10][0].x, grid.shield[10][0].y, grid.medShieldRad, grid.medShieldRad);
  }
  if (cc[111] > 0) {
    // med shields
    fill(flash, 360*cc[111]);
    ellipse(grid.shield[2][1].x, grid.shield[2][1].y, grid.medShieldRad, grid.medShieldRad);
    ellipse(grid.shield[6][1].x, grid.shield[6][1].y, grid.medShieldRad, grid.medShieldRad);
    ellipse(grid.shield[10][1].x, grid.shield[10][1].y, grid.medShieldRad, grid.medShieldRad);
  }
  if (cc[112] > 0) {
    /// balls
    fill(c, 360*cc[112]*bangAdjust);
    ellipse(grid.ball[0].x, grid.ball[0].y, 20, 20);
    ellipse(grid.ball[4].x, grid.ball[4].y, 20, 20);
    ellipse(grid.ball[8].x, grid.ball[8].y, 20, 20);
  }
  ////////////////////////////////// ROOF BUTTONS ///////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////
  bangAdjust = cc[15]/1.5;
  if (cc[113] > 0) {
    // cans
    stutter = map(sin(timer[4]*(cc[13]*5+3)), -1, 1, 0, 1);        
    fill(c, 360*cc[113]*bangAdjust);
    rect(cans.cansLeft.x, 0+(size.roofHeight*stutter), 10, 150);
    fill(flash, 360*cc[113]*bangAdjust);
    rect(cans.cansRight.x, size.roofHeight-(size.roofHeight*stutter), 10, 150);
  }
  if (cc[114] > 0) {
    // big seeds
    fill(c, 360*cc[114]*bangAdjust);
    ellipse(seeds.seed[0][0].x, seeds.seed[0][0].y, 15, 15);
    ellipse(seeds.seed[0][2].x, seeds.seed[0][2].y, 15, 15);
    ellipse(seeds.seed[1][1].x, seeds.seed[1][1].y, 15, 15);
    ellipse(seeds.seed[2][1].x, seeds.seed[2][1].y, 15, 15);
    ellipse(seeds.seed[4][0].x, seeds.seed[4][0].y, 15, 15);
    ellipse(seeds.seed[4][2].x, seeds.seed[4][2].y, 15, 15);
  }
  if (cc[115] > 0) {
    // small seeds
    fill(flash, 360*cc[115]*bangAdjust);
    ellipse(seeds.seed[1][0].x, seeds.seed[1][0].y, 15, 15);
    ellipse(seeds.seed[1][2].x, seeds.seed[1][2].y, 15, 15);
    ellipse(seeds.seed[2][0].x, seeds.seed[2][0].y, 15, 15);
    ellipse(seeds.seed[2][2].x, seeds.seed[2][2].y, 15, 15);
    ellipse(seeds.seed[3][0].x, seeds.seed[3][0].y, 15, 15);
    ellipse(seeds.seed[3][2].x, seeds.seed[3][2].y, 15, 15);
    ellipse(seeds.seed[0][1].x, seeds.seed[0][1].y, 15, 15);
  }

  ////////////////////////// ALL ON MADNESS ///////////////////////////////
  if (cc[116] > 0) {
    colorSwap(0.9999999999);
    fill(360, 360*cc[116]*bangAdjust);
    rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    rect(size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    fill(0);
    rect(cans.cansLeft.x, cans.cansLeft.y, 3, cans.canLength);
    rect(cans.cansRight.x, cans.cansRight.y, 3, cans.canLength);
    blendMode(MULTIPLY);
    roofBigSeeds(5, c, clash);
    solidBG(0, flash);
    eyeBG(0, clash, flash);
    ballsBG(0, c);
    //radGradBallBG(0, c, flash, 0); 
    image(bg[0], size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
    image(bg[5], size.roof.x, size.roof.y, size.roofWidth, size.roofHeight);
    blendMode(NORMAL);
  }
}


/*
void drumButtons() {
 float bangAdjust = 1;
 if (cc[116] > 0) {
 fill(clash, 360*cc[116]*bangAdjust);
 rect(size.rig.x, size.rig.y, size.rigWidth, size.rigHeight);
 }
 if (cc[109] > 0) {
 fill(c, 360*cc[109]*bangAdjust);
 ellipse(size.rig.x, size.rig.y, 50, 50);
 }
 if (cc[110] > 0) {
 fill(flash, 360*cc[110]*bangAdjust);
 ellipse(size.rig.x, size.rig.y, 50, 50);
 }
 if (cc[111] > 0) {
 noFill();
 stroke(flash, 360*cc[111]*bangAdjust);
 strokeWeight(20);
 ellipse(size.rig.x, size.rig.y, grid.bigShieldRad, grid.bigShieldRad);
 noStroke();
 }
 if (cc[112] > 0) {
 fill(flash, 360*cc[112]*bangAdjust);
 ellipse(grid.shield[2][0].x, grid.shield[2][0].y, grid.medShieldRad, grid.medShieldRad);
 ellipse(grid.shield[6][0].x, grid.shield[6][0].y, grid.medShieldRad, grid.medShieldRad);
 ellipse(grid.shield[10][0].x, grid.shield[10][0].y, grid.medShieldRad, grid.medShieldRad);
 }
 if (cc[113] > 0) {
 fill(flash, 360*cc[113]);
 ellipse(grid.shield[2][1].x, grid.shield[2][1].y, grid.medShieldRad, grid.medShieldRad);
 ellipse(grid.shield[6][1].x, grid.shield[6][1].y, grid.medShieldRad, grid.medShieldRad);
 ellipse(grid.shield[10][1].x, grid.shield[10][1].y, grid.medShieldRad, grid.medShieldRad);
 }
 if (cc[114] > 0) {
 fill(c, 360*cc[114]*bangAdjust);
 ellipse(grid.ball[0].x, grid.ball[0].y, 20, 20);
 ellipse(grid.ball[4].x, grid.ball[4].y, 20, 20);
 ellipse(grid.ball[8].x, grid.ball[8].y, 20, 20);
 }
 if (cc[115] > 0) {
 fill(flash, 360*cc[115]*bangAdjust);
 ellipse(grid.ball[0].x, grid.ball[0].y, 20, 20);
 ellipse(grid.ball[4].x, grid.ball[4].y, 20, 20);
 ellipse(grid.ball[8].x, grid.ball[8].y, 20, 20);
 }
 }
 */
