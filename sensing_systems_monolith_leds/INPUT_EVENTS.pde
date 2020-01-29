
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean vizHold, colHold, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
void keyPressed() {  

  if (key == CODED) {
    //println("keycode", keyCode);
    if (keyCode == 157) {
      println("*** DELETE ALL ANIMS ***");
      for (Rig rig : rigs) {
        //for (Anim anim : rig.animations) anim.deleteme = true; // immediately delete all anims
      }
    }
  }

  //// debound or thorttle this ////

  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (key == 'n') da.vizIndex = (da.vizIndex+1)%da.availableAnims.length;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') da.vizIndex -=1;                            //// STEP BACK TO PREVIOUS RIG VIZ
  if (da.vizIndex <0) da.vizIndex = da.availableAnims.length-1;
  if (key == 'm') da.bgIndex = (da.bgIndex+1)%da.availableBkgrnds.length;                 //// CYCLE THROUGH RIG BACKGROUNDS
  if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
    da.functionIndexA = (da.functionIndexA+1)%da.availableFunctionEnvelopes.length; //animations.func.length; 
    da.functionIndexB = (da.functionIndexB+1)%da.availableFunctionEnvelopes.length; //fct.length;
  }  
  if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
    da.alphaIndexA = (da.alphaIndexA+1)% da.availableAlphaEnvelopes.length; //alph.length; 
    da.alphaIndexB = (da.alphaIndexB+1)% da.availableAlphaEnvelopes.length; //alph.length;
  }   
  if (key == 'c') da.colorIndexA = (da.colorIndexA+1)%da.col.length; //// CYCLE FORWARD THROUGH RIG COLORS
  if (key == 'v') da.colorIndexB = (da.colorIndexB+1)%da.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////// ROOF KEY FUNCTIONS ///////////////////////////////////////////////////////////////////////////////
  if (key == 'h') ro.vizIndex = (ro.vizIndex+1)%ro.availableAnims.length;               //// STEP FORWARD TO NEXT RIG VIZ
  if (key == 'g') ro.vizIndex -= 1;                          //// STEP BACK TO PREVIOUS RIG VIZ
  if (ro.vizIndex <0) ro.vizIndex = ro.availableAnims.length-1;
  if (key == 'j') ro.bgIndex = (ro.bgIndex+1)%ro.availableBkgrnds.length;               //// CYCLE THROUGH ROOF BACKGROUNDS
  if (key == 'k') {                                      //// CYCLE THROUGH ROOF FUNCS
    ro.functionIndexA = (ro.functionIndexA+1)%ro.availableFunctionEnvelopes.length; 
    ro.functionIndexB = (ro.functionIndexB+1)%ro.availableFunctionEnvelopes.length;
  }  
  if (key == 'l') {                                      //// CYCLE THROUGH ROOF ALPHAS
    ro.alphaIndexA = (ro.alphaIndexA+1)%ro.availableAlphaEnvelopes.length; 
    ro.alphaIndexB = (ro.alphaIndexB+1)%ro.availableAlphaEnvelopes.length;
  }
  if (key == 'd') {
    ro.colorIndexA = (ro.colorIndexA+1)%pa.col.length;      //// CYCLE FORWARD THROUGH ROOF COLORS
  }
  if (key == 'f') {
    ro.colorIndexB = (ro.colorIndexB+1)%pa.col.length;      //// CYCLE BACKWARD THROUGH ROOF COLORS
  }

  for (Rig rig : rigs) {
    rig.ddListCallback(rig.ddVizList, rig.vizIndex);
    rig.ddListCallback(rig.ddFuncListA, rig.functionIndexA);
    rig.ddListCallback(rig.ddFuncListB, rig.functionIndexB);
    rig.ddListCallback(rig.ddAlphaListA, rig.alphaIndexA);
    rig.ddListCallback(rig.ddAlphaListB, rig.alphaIndexB);
    rig.ddListCallback(rig.ddBgList, rig.bgIndex);
  }


  //ro.alphaIndexA = da.alphaIndexA;
  //ro.alphaIndexB = da.alphaIndexB;

  //ro.functionIndexA = ro.functionIndexA;
  //ro.functionIndexA = ro.functionIndexA;

  //ro.c = da.c;
  //ro.flash = da.flash;


  if (key == '[') vizHold = !vizHold; 
  if (key == ']') colHold = !colHold; 


  if (key=='1') {
    controlFrame.cp5.saveProperties(controlFrameValues);//"cp5values.json");
    sliderFrame.cp5.saveProperties(sliderFrameValues);//"cp5SliderValues.json");
    //this.cp5.saveProperties(mainFrameValues);
    println("** SAVED CONTROLER VALUES **");
    //println("saved to", controlFrameValues, sliderFrameValues);
  } else if (key=='2') {
    try {
      controlFrame.cp5.loadProperties(controlFrameValues);
      sliderFrame.cp5.loadProperties(sliderFrameValues);
      //this.cp5.loadProperties(mainFrameValues);
      println("** LOADED CONTROLER VALUES **");
      //println("loaded from", controlFrameValues, sliderFrameValues);
    }
    catch(Exception e) {
      println(e, "ERROR LOADING CONTROLLER VALUES");
    }
  }



  //  switch(key) {
  //    case('1'):
  //    /* make the ScrollableList behave like a ListBox */
  //    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.LIST);
  //    break;
  //    case('2'):
  //    /* make the ScrollableList behave like a DropdownList */
  //    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.DROPDOWN);
  //    break;
  //    case('3'):
  //    /*change content of the ScrollableList */
  //    List l = Arrays.asList("a-1", "b-1", "c-1", "d-1", "e-1", "f-1", "g-1", "h-1", "i-1", "j-1", "k-1");
  //    cp5.get(ScrollableList.class, "dropdown").setItems(l);
  //    break;
  //    case('4'):
  //    /* remove an item from the ScrollableList */
  //    cp5.get(ScrollableList.class, "dropdown").removeItem("k-1");
  //    break;
  //    case('5'):
  //    /* clear the ScrollableList */
  //    cp5.get(ScrollableList.class, "dropdown").clear();
  //    break;
  //  }

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
float pad[] = new float[128];                //// An array where to store the last value received for each midi Note controller
float padVelocity[] = new float[128];
boolean padPressed[] = new boolean[128];
int midiMap;
void noteOn( int channel, int pitch, int _velocity) {
  float velocity = map(_velocity, 0, 127, 0, 1);
  pad[pitch] = velocity;
  padPressed[pitch] = true;

  padPressed[pitch] = true;
  padVelocity[pitch] = velocity;

  println();
  println("padVelocity: "+pitch, "Velocity: "+velocity, "Channel: "+channel);
}
void noteOff(Note note) {
  padPressed[note.pitch] = false;
  padVelocity[note.pitch] = 0;
}
float cc[] = new float[128];                   //// An array where to store the last value received for each CC controller
void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println("cc[" + number + "]", "Velocity: "+cc[number], "Channel: "+channel);

  String name = "slider "+(number-40);
  try {
    //sliderFrame.cp5.getController(name).setValue(cc[number]);
    sliderFrame.cp5.getController(name).setValue(cc[number]);
  } 
  catch (Exception e) {
    println(e);
    println("*** !!CHECK YOUR MIDI MAPPING!! ***");
    println();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  OscAddrMap.put(theOscMessage.addrPattern(), argument);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
