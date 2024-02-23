void setDefaultParameters(Rig rig, float dimmer, float alphaRate, float functionRate, 
                         int backgroundChangeRate, float wideSlider, float highSlider, 
                         float strokeSlider, float blurriness) {
  rig.dimmer = dimmer;                // Set the dimmer value for the rig
  rig.alphaRate = alphaRate;          // Set the alpha change rate for the rig
  rig.functionRate = functionRate;    // Set the function change rate for the rig
  rig.backgroundChangeRate = backgroundChangeRate;  // Set how frequently the background changes per color change
  rig.wideSlider = wideSlider;        // Set the width slider value for the rig
  rig.highSlider = highSlider;        // Set the height slider value for the rig
  rig.strokeSlider = strokeSlider;    // Set the stroke slider value for the rig
  rig.blurriness = blurriness;        // Set the blurriness value for the rig
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// Set default parameter values for rig settings ///////////////////////////////
void setStatupSettings(Rig rig) {
  switch (rig.type) {
    case Shields:
      rig.vizIndex = 2;
      rig.functionIndexA = 0;
      rig.functionIndexB = 1;
      rig.colorIndexA = 2;
      rig.colorIndexB = 1;
      break;
    case FrontCans:
    case OutsideRoof:
    case OutsideGround:
    default:
      rig.vizIndex = 0;
      rig.colorIndexA = 2;
      rig.colorIndexB = 1;
      rig.bgIndex = 0;
      break;
  }
}

void alwaysDoFirst() {
  // Animation and configuration setups
  for (Rig rig : rigs) {
    // Set default animation and configurations
    rig.availableAnims = new int[] {1, 2, 6, 7, 8};
    rig.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5};  
    rig.availableFunctionEnvelopes = new int[] {0, 1, 2};  
    rig.availableBkgrnds = new int[] {8, 0, 1, 2, 7};   
    rig.availableColors = new int[] { 0, 1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 13}; 
    // Dimmer, alphaRate, functionRate, backgroundChangeRate, wideSlider, highSlider, strokeSlider, blurriness
    setDefaultParameters(rig, 0.5, 0.5, 0.5, 4, 0.5, 0.5, 0.5, 0.2);  
    setStatupSettings(rig);

    // Modify settings for specific cases
    switch (rig.type) {
      case Shields:
        rig.availableAnims = new int[] {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        rig.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
        rig.availableFunctionEnvelopes = new int[] {0, 1, 2};  
        rig.availableBkgrnds = new int[] {0,1,2,3,4,5,6};   
        // Dimmer, alphaRate, functionRate, backgroundChangeRate, wideSlider, highSlider, strokeSlider, blurriness
        setDefaultParameters(rig, 0.5, 0.5, 0.5, 4, 0.5, 0.5, 0.5, 0.2);  
        setStatupSettings(rig);
        break;
      case BoothCans:
        rig.dimmer = 0;
        break;
      case TipiLeft:
        setDefaultParameters(rig, 0.3, 0.84, 0.56, 4, 0.5, 0.5, 0.9, 0.075);  
        break;
      case TipiRight:
        setDefaultParameters(rig, 0.3, 0.84, 0.56, 4, 0.5, 0.5, 0.9, 0.075);  
        break;
      case OutsideRoof:
        rig.strokeSlider = 1;
        rig.wideSlider = 1;
        rig.highSlider = 1;
        break;
      case OutsideGround:
        rig.availableAnims = new int[] {6, 7, 13};
        break;
      case Test:
        rig.availableAnims = new int[] {0,1,2,3,4,5,6,7,8,9,10,11,12,13};
        rig.availableBkgrnds = new int[] {0,1,2,3,4,5,6,7,8,9};
        break;
      default:
        break;
    }
  }

  int numChannels = cc.length;
  int numCCValues = cc[0].length; 
  for (int channel = 0; channel < numChannels; channel++) {
      for (int ccValueIndex = 0; ccValueIndex < numCCValues; ccValueIndex++) {
          cc[channel][ccValueIndex] = 1;
      }
  }

  // for (int i = 0; i < cc.length; i++) cc[0][i]=0;   // set all midi values to 0;
  // // TODO why is this essential 
  // for (int i = 0; i < 100; i++) cc[i] = 1;       // set all knobs to 1 ready for shit happen
  
  vizChangeTime = 10;   // time in minutes - TODO sort this out onto slider 
  colorChangeTime = 5;  // time in minutes - TODO sort this out onto slider 

  cc[8][36] = 0.05;
  cc[8][56] = 0.2;
  boothDimmer = 0.05;
  mixerDimmer = 0.2;
  cc[8][20] = 0.5;
  // quick n dirty shield faders
  cc[0][77] = 0.5; //rig
  cc[0][78] = 0; // smalll shields + egg dimmer
  cc[0][79] = 0;  // balls dimmer
  cc[0][50] = 0; // big shield dimmer
  cc[0][80] = 0.1; // filaments dimmer
  cc[0][81] = 0;  // big shield on
  cc[0][82] = 0; // small shields + egg on
  cc[0][83] = 0; // balls on
  cc[0][84] = 0; // fialments on
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// COLOR SETUP CHOSE COLOUR VALUES ///////////////////////////////////////////////
color red, pink, yell, grin, bloo, purple, teal, orange, aqua, white, black;
color red1, pink1, yell1, grin1, bloo1, purple1, teal1, aqua1, orange1;
color red2, pink2, yell2, grin2, bloo2, purple2, teal2, aqua2, orange2;
color c, flash, c1, flash1;
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

