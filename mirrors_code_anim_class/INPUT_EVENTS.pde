int TR8CHANNEL = 9;
int BD = 0;
int SD = 1;
int LT = 2;
int MT = 3;
int HT = 4;
int RS = 5;
int HC = 6;
int CH = 7;

int BDTUNE = 20;
int BDDECAY = 23;
int BDLEVEL = 24;
int BDCTRL = 96;
int SDTUNE = 25;
int SDDECAY = 28;
int SDLEVEL = 29;
int SDCTRL = 102;
int LTTUNE = 46;
int LTDECAY = 47;
int LTLEVEL = 48;
int LTCTRL = 102;
int MTTUNE = 49;
int MTDECAY = 50;
int MTLEVEL = 51;
int MTCTRL = 103;
int HTTUNE = 52;
int HTDECAY = 53;
int HTLEVEL = 54;
int HTCTRL = 105;
int RSTUNE = 55;
int RSDECAY = 56;
int RSLEVEL = 57;
int RSCTRL = 105;
int HCTUNE = 58;
int HCDECAY = 59;
int HCLEVEL = 60;
int HCCTRL = 106;
int CHTUNE = 61;
int CHDECAY = 62;
int CHLEVEL = 63;
int CHCTRL = 107;

int DELAYLEVEL = 16;
int DELAYTIME = 17;
int DELAYFEEDBACK = 18;
int MASTERFXON = 15;
int MASTERFXLEVEL = 19;
int REVERBLEVEL = 91;
int NOTE_ON=ShortMessage.NOTE_ON;
int NOTE_OFF=ShortMessage.NOTE_OFF;
int PRGM_CHG=ShortMessage.PROGRAM_CHANGE;
int CTRL_CHG=ShortMessage.CONTROL_CHANGE;
int STOP=ShortMessage.STOP;
int START=ShortMessage.START;
int TIMING=ShortMessage.TIMING_CLOCK;


HashMap<String, int[]> oscAddrToMidiMap = new HashMap<String, int[]>();
void oscAddrSetup() {

  int startVal = 64;
  OscAddrMap.put("/throttle_box/throttle_button_1", startVal);
  OscAddrMap.put("/throttle_box/throttle_button_2", startVal);
  OscAddrMap.put("/throttle_box/trackball_x", startVal);
  OscAddrMap.put("/throttle_box/trackball_y", startVal);
  OscAddrMap.put("/throttle_box/throttle", startVal);
  OscAddrMap.put("/throttle_box/knob_1", startVal);
  OscAddrMap.put("/throttle_box/knob_2", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/instrument/0/volume", startVal);
  OscAddrMap.put("/instrument/1/volume", startVal);
  OscAddrMap.put("/instrument/2/volume", startVal);
  OscAddrMap.put("/instrument/3/volume", startVal);
  OscAddrMap.put("/instrument/4/volume", startVal);
  OscAddrMap.put("/instrument/5/volume", startVal);
  OscAddrMap.put("/instrument/6/volume", startVal);
  OscAddrMap.put("/instrument/7/volume", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/tune", startVal);
  OscAddrMap.put("/knob_box/1/tune", startVal);
  OscAddrMap.put("/knob_box/2/tune", startVal);
  OscAddrMap.put("/knob_box/3/tune", startVal);
  OscAddrMap.put("/knob_box/4/tune", startVal);
  OscAddrMap.put("/knob_box/5/tune", startVal);
  OscAddrMap.put("/knob_box/6/tune", startVal);
  OscAddrMap.put("/knob_box/7/tune", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/decay", startVal);
  OscAddrMap.put("/knob_box/1/decay", startVal);
  OscAddrMap.put("/knob_box/2/decay", startVal);
  OscAddrMap.put("/knob_box/3/decay", startVal);
  OscAddrMap.put("/knob_box/4/decay", startVal);
  OscAddrMap.put("/knob_box/5/decay", startVal);
  OscAddrMap.put("/knob_box/6/decay", startVal);
  OscAddrMap.put("/knob_box/7/decay", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/0/ctrl", startVal);
  OscAddrMap.put("/knob_box/1/ctrl", startVal);
  OscAddrMap.put("/knob_box/2/ctrl", startVal);
  OscAddrMap.put("/knob_box/3/ctrl", startVal);
  OscAddrMap.put("/knob_box/4/ctrl", startVal);
  OscAddrMap.put("/knob_box/5/ctrl", startVal);
  OscAddrMap.put("/knob_box/6/ctrl", startVal);
  OscAddrMap.put("/knob_box/7/ctrl", startVal);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/joystick_1", 0);
  OscAddrMap.put("/knob_box/joystick_2", 0);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////
}
int oneshotmap, colorselected;
boolean buttonT[] = new boolean [16];
boolean oneshotmessage;
HashMap<String, Integer> OscAddrMap = new HashMap<String, Integer>();
void oscEvent(OscMessage theOscMessage) {
  //split address into parts
  String addr[]=theOscMessage.addrPattern().split("/");
  String messageType=addr[addr.length-1];
  addr[addr.length-1]="";
  String address=String.join("/", addr);
  int argument = (int)theOscMessage.arguments()[0];

  if ( !(messageType.equals("throttle") || messageType.equals("throttle_button_2"))) {
    print("address = '"+address+"'");
    print(" mesgtype = '"+messageType+"'");
    println(" mesgArgument = "+argument);
  }
  //println();
  OscAddrMap.put(theOscMessage.addrPattern(), argument);
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// knob box /////////////////////////////////////////////////////////////////////
  if (messageType.equals("joystick_1") || messageType.equals("joystick_2")) {
    oneshotmap=int(OscAddrMap.get("/knob_box/joystick_1")*9+OscAddrMap.get("/knob_box/joystick_2"));
    println("oneshotmap = "+oneshotmap);
    if (oneshotmap>0) {
      oneShot(oneshotmap);
    }
  }
  if (messageType.equals("oneshot")) if (argument == 5) rigBgr = int(random(bgList));

  /////////////////////////////////////// button box //////////////////////////////////////
  if (messageType.equals("buttonSelected")) {
    if (argument<5) {
      buttonT[argument]=!buttonT[argument];
      println("button "+argument+" is selected");
      colorselected = argument;
    }
    if (argument >= 5 && argument < 16 ) rigViz = argument-5;
  }
  /////////////////////////////////// fader box /////////////////////////////////////////////
  //if (messageType.equals("kitChange")) colorControl(argument);


  ///////////////////////////////////////// throttle box ./////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean test, work, info, play, stop, space, shift, colBeat, vizHold, colHold;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
int keyNum;
int mirrorStep, gridStep;
void keyPressed() {  

  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  //if (key == 'n') rigViz = (rigViz+1)%rigVizList;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') rigViz -=1;                            //// STEP BACK TO PREVIOUS RIG VIZ
  //if (rigViz <0) rigViz = rigVizList-1;
  if (key == 'm') rigBgr = (rigBgr+1)%7;                 //// CYCLE THROUGH RIG BACKGROUNDS

  /////////////////////////////// ROOF KEY FUNCTIONS ////////////////////////
  if (key == 'h') roofViz = (roofViz+1)%8;               //// STEP FORWARD TO NEXT RIG VIZ
  if (key == 'g') roofViz -= 1;                          //// STEP BACK TO PREVIOUS RIG VIZ
  if (roofViz <0) roofViz = 7;
  if (key == 'j') roofBgr = (roofBgr+1)%7;               //// CYCLE THROUGH ROOF BACKGROUNDS

  if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
    fctIndex = (fctIndex+1)%fct.length; 
    fct1Index = (fct1Index+1)%fct.length;
  }  
  if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
    rigAlphIndex = (rigAlphIndex+1)%alph.length; 
    rigAlph1Index = (rigAlph1Index+1)%alph.length;
  }   
  if (key == 'k') {                                      //// CYCLE THROUGH ROOF FUNCS
    roofFctIndex = (roofFctIndex+1)%fct.length; 
    roofFct1Index = (roofFct1Index+1)%fct.length;
  }  
  if (key == 'l') {                                      //// CYCLE THROUGH ROOF ALPHAS
    roofAlphIndex = (roofAlphIndex+1)%alph.length; 
    roofAlph1Index = (roofAlph1Index+1)%alph.length;
  }   
  if (key == 'c') rig.colorA = (rig.colorA+1)%rig.col.length;         //// CYCLE FORWARD THROUGH RIG COLORS
  if (key == 'v') rig.colorB = (rig.colorB+1)%rig.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS
  if (key == 'x') colorselected = (colorselected + 1) % 5;

  if (key == 'd') roof.colorA = (roof.colorA+1)%roof.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  if (key == 'f') roof.colorB = (roof.colorB+1)%roof.col.length;      //// CYCLE BACKWARD THROUGH ROOF COLORS

  if (key == 'q') info = !info;
  if (key == 't') test = !test;
  if ( key == 'w') work = !work;
  if (key == '[') vizHold = !vizHold; 
  if (key == ']') colHold = !colHold; 

  /////////////////////////////////// momentaory key pressed array /////////////////////////////////////////////////
  for (int i = 32; i <=63; i++)  if (key == char(i)) keyP[i]=true;
  for (int i = 91; i <=127; i++) if (key == char(i)) keyP[i]=true;
  ///////////////////////////////// toggle key pressed array ///////////////////////////////////////////////////////
  for (int i = 32; i <=63; i++) {
    if (key == char(i)) keyT[i] = !keyT[i];
    if (key == char(i)) println(key, i, keyT[i]);
  }
  for (int i = 91; i <=127; i++) {
    if (key == char(i)) keyT[i] = !keyT[i];
    if (key == char(i)) println(key, i, keyT[i]);
  }
}

void keyReleased()
{
  /// loop to change key[] to false when released to give hold control
  for (int i = 32; i <=63; i++) {
    char n = char(i);
    if (key == n) keyP[i]=false;
  }
  for (int i = 91; i <=127; i++) {
    char n = char(i);
    if (key == n) keyP[i]=false;
  }
} 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// MIDI FUNCTIONS /////////////////////////////////////////////////////////////////////
float pad[] = new float[64];
void noteOn(Note note) {
  //println();
  //println("BUTTON: ", +note.pitch);
}
float cc[] = new float[128];                   //// An array where to store the last value received for each knob
float prevcc[] = new float[128];
void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println();
  println("CC: ", number, "....", map(value, 0, 127, 0, 1), "- Channel:", channel);
}
