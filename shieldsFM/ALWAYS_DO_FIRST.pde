void alwaysDoFirst() {
  //This is confusing.  can these be words please
  //like, shields.availableAnims = {Donuts,GoodAnim3,BoxesRed} or sth. an enum? can it be an enum?

  for (Rig rig : rigs){
    switch (rig.type){
    case Shields:
      rig.availableAnims = new int[] {1, 2, 6, 7, 8};      // setup which anims are used on which rig here
      rig.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
      rig.availableFunctionEnvelopes = new int[] {0, 1, 2};  
      rig.availableBkgrnds = new int[] {0, 1, 2, 3, 4, 5, 6};   
      break;
    default:
      rig.availableAnims = new int[] {1, 2, 6, 7, 8, 4};      // setup which anims are used on which rig here
      rig.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
      rig.availableFunctionEnvelopes = new int[] {0, 1, 2};  
      rig.availableBkgrnds = new int[] {0, 1, 2, 3, 4, 5, 6}; 
    }
  }
  //shields.availableColors = new int[] { 0, 1, 2, 3, 4, 13, 10, 11, 12, 2, 3};
  //roof.availableColors = shields.availableColors; // = new int[] { 0, 1, 2, 3, 4, 13, 10, 11, 12, 2, 3};

  shields.vizIndex = 2;
  shields.functionIndexA = 0;
  shields.functionIndexB = 1;
  shields.alphaIndexA = 0;
  shields.alphaIndexB = 0;
  shields.bgIndex = 0;

  shields.colorIndexA = 2;
  shields.colorIndexB = 1;

  megaSeedFront.vizIndex = 5;
  megaSeedCentre.vizIndex = 5;
  roofmid.colorIndexA = 2;
  roofmid.colorIndexB = 1;
  roofsides.colorIndexA = 3;
  roofsides.colorIndexB = 2;

  megaSeedCentre.colorIndexA = 1;
  megaSeedCentre.colorIndexB = 2;

  megaSeedFront.colorIndexA = 2;
  megaSeedFront.colorIndexB = 1;

///// TODO  make an easy way of changing colour
  
 
  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 100; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  cc[1] = 0.75;
  cc[2] = 0.75;
  cc[5] = 0.3;
  cc[6] = 0.75;
  cc[4] = 1;
  cc[8] = 1;

  for (int i= 36; i < 52; i++)cc[i] = 0;

  shields.dimmer = 1;
  shields.alphaRate = 0.5;
  shields.functionRate = 0.5;
  shields.wideSlider = 0.5;
  shields.highSlider = 0.5;
  shields.strokeSlider= 1;
  shields.blurriness = 0.2;

  roofmid.dimmer = 0.45;
  roofmid.alphaRate = 0.84;
  roofmid.functionRate = 0.56;
  roofmid.blurriness = 0.075;
  roofmid.strokeSlider = 0.9;

  roofsides.dimmer = 0.8;
  roofsides.alphaRate = 0.45;
  roofsides.functionRate = 0.72;
  roofsides.blurriness = 0.25;
  roofsides. strokeSlider = 0.9;

  megaSeedCentre.dimmer = 0.7;
  megaSeedCentre.alphaRate = 0.73;
  megaSeedCentre.functionRate = 0.6;
  megaSeedCentre.blurriness = 0.05;
  megaSeedCentre.strokeSlider = 0.7;

  megaSeedFront.dimmer = 0.4;
  megaSeedFront.alphaRate = 0.9;
  megaSeedFront.functionRate = 0.3;
  megaSeedFront.blurriness = 0.04;
  megaSeedFront.strokeSlider = 0.9;

  //booth.dimmer = 0.18;
  //mixer.dimmer = 0.15;
  //dig.dimmer = 0.11;
  
  uvDimmer = 0.03;
  uvSpeed = 0.57;
  uvProgram = 0.306;

  vizTime = 1;
  colorChangeTime = 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// COLOR SETUP CHOSE COLOUR VALUES ///////////////////////////////////////////////
color red, pink, yell, grin, bloo, purple, teal, orange, aqua, white, black;
color red1, pink1, yell1, grin1, bloo1, purple1, teal1, aqua1, orange1;
color red2, pink2, yell2, grin2, bloo2, purple2, teal2, aqua2, orange2;
color c, flash;
color act = #07E0D3;
color act1 = #00FC84;
color bac = #370064;
color bac1 = #4D9315;
color slider = #E07F07;
color slider1 = #E0D607;
void colorSetup() {

  colorMode(HSB, 360, 100, 100);
  white = color(0, 0, 100);
  black = color(0, 0, 0);

  float alt = 0;
  float sat = 100;
  aqua = color(150+alt, sat, 100);
  pink = color(323+alt, sat, 90);
  bloo = color(239+alt, sat, 100);
  yell = color(50+alt, sat, 100);
  grin = color(115+alt, sat, 60);
  orange = color(30+alt, sat, 90);
  purple = color(290+alt, sat, 70);
  teal = color(170+alt, sat, 60);
  red = color(7+alt, sat, 100);
  // colors that aren't affected by color swap
  float sat1 = 100;
  aqua1 = color(190+alt, 80, 100);
  pink1 = color(323-alt, sat1, 90);
  bloo1 = color(239-alt, sat1, 100);
  yell1 = color(50-alt, sat1, 100);
  grin1 = color(160-alt, sat1, 60);
  orange1 = color(34.02-alt, sat1, 90);
  purple1 = color(290-alt, sat1, 70);
  teal1 = color(170-alt, sat1, 60);
  red1 = color(15-alt, sat1, 100);
  /// alternative colour similar to original for 2 colour blends
  float sat2 = 100;
  alt = +6;
  aqua2 = color(190-alt, 80, 100);
  pink2 = color(323-alt, sat2, 90);
  bloo2 = color(239-alt, sat2, 100);
  yell2 = color(50-alt, sat2, 100);
  grin2 = color(160-alt, sat2, 100);
  orange2 = color(34.02-alt, sat2, 90);
  purple2 = color(290-alt, sat2, 70);
  teal2 = color(170-alt, sat2, 85);
  red2 = color(15-alt, sat2, 100);
}
