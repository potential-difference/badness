//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean vizHold, colHold, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
void keyPressed() {  

  if (keyCode == BACKSPACE) {
    println("*** DELETE ALL ANIMS ***");
    for (Rig rig : rigs) {
      for (Anim anim : rig.animations) anim.deleteme = true; // immediately delete all anims
    }
  }

  //// debounce or thorttle this ////
  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (key == 'n') rigg.vizIndex = (rigg.vizIndex+1)%rigg.availableAnims.length;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') rigg.vizIndex -=1;                            //// STEP BACK TO PREVIOUS RIG VIZ
  if (rigg.vizIndex <0) rigg.vizIndex = rigg.availableAnims.length-1;
  if (key == 'm') rigg.bgIndex = (rigg.bgIndex+1)%rigg.availableBkgrnds.length;                 //// CYCLE THROUGH RIG BACKGROUNDS
  if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
    rigg.functionIndexA = (rigg.functionIndexA+1)%rigg.availableFunctionEnvelopes.length; //animations.func.length; 
    rigg.functionIndexB = (rigg.functionIndexB+1)%rigg.availableFunctionEnvelopes.length; //fct.length;
  }  
  if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
    rigg.alphaIndexA = (rigg.alphaIndexA+1)% rigg.availableAlphaEnvelopes.length; //alph.length; 
    rigg.alphaIndexB = (rigg.alphaIndexB+1)% rigg.availableAlphaEnvelopes.length; //alph.length;
  }   
  if (key == 'c') rigg.colorIndexA = (rigg.colorIndexA+1)%rigg.col.length; //// CYCLE FORWARD THROUGH RIG COLORS
  if (key == 'v') rigg.colorIndexB = (rigg.colorIndexB+1)%rigg.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////// ROOF KEY FUNCTIONS ///////////////////////////////////////////////////////////////////////////////

  if (key == '[') vizHold = !vizHold; 
  if (key == ']') colHold = !colHold; 

  if (key=='1') {
    controlFrame.cp5.saveProperties(controlFrameValues);
    println("** SAVED CONTROLER VALUES **");
  } else if (key=='2') {
    try {
      controlFrame.cp5.loadProperties(controlFrameValues);
      println("** LOADED CONTROLER VALUES **");
    }
    catch(Exception e) {
      println(e, "ERROR LOADING CONTROLLER VALUES");
    }
  }

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
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
