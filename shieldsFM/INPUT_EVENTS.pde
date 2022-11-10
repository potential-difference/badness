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

  //// debound or thorttle this ////
  if (roofcentre != null) {
    // TODO make more of these for each rig allowing rigs to not exist
    if (key == 'j') roofcentre.vizIndex = (roofcentre.vizIndex+1)%roofcentre.availableAnims.length;  //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
    if (key == 'h') roofcentre.vizIndex = -1;  //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
    if (roofcentre.vizIndex <0) roofcentre.vizIndex = roofcentre.availableAnims.length-1;

  }
  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (shields != null){
    if (key == 'n') shields.vizIndex = (shields.vizIndex+1)%shields.availableAnims.length;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
    if (key == 'b') shields.vizIndex -=1;                            //// STEP BACK TO PREVIOUS RIG VIZ
    if (shields.vizIndex <0) shields.vizIndex = shields.availableAnims.length-1;
    if (key == 'm') shields.bgIndex = (shields.bgIndex+1)%shields.availableBkgrnds.length;                 //// CYCLE THROUGH RIG BACKGROUNDS
    if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
      shields.functionIndexA = (shields.functionIndexA+1)%shields.availableFunctionEnvelopes.length; //animations.func.length; 
      shields.functionIndexB = (shields.functionIndexB+1)%shields.availableFunctionEnvelopes.length; //fct.length;
    }  
    if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
      shields.alphaIndexA = (shields.alphaIndexA+1)% shields.availableAlphaEnvelopes.length; //alph.length; 
      shields.alphaIndexB = (shields.alphaIndexB+1)% shields.availableAlphaEnvelopes.length; //alph.length;
    }   
    if (key == 'c') shields.colorIndexA = (shields.colorIndexA+1)%shields.col.length; //// CYCLE FORWARD THROUGH RIG COLORS
    if (key == 'v') shields.colorIndexB = (shields.colorIndexB+1)%shields.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
float pad[] = new float[128];                //// An array where to store the last value received for each midi Note controller
float padVelocity[] = new float[128];
boolean padPressed[] = new boolean[128];
interface MidiAction{
  void send(float controllerchange);
}
interface FrameAction{
  void doit();
}
MidiAction ccActions[] = new MidiAction[128];
FrameAction everyFrameActions[] = new FrameAction[128];
MidiAction noteOnActions[]= new MidiAction[128];
FrameAction noteOffActions[]= new FrameAction[128];

void newMomentary(int note,FrameAction action){
  noteOnActions[note] = (float velocity) ->{
    everyFrameActions[note] = action;
  };
  noteOffActions[note] = ()->{everyFrameActions[note]=null;};
  println("new momentary for ",note);
}
//if you dont care about velocity you can use this function:
/*
newMomentary(35,()->{
  for (rig:rigs){
    rig.colorSwap(10000);
  }
})
this will
//if you want to use velocity you have to do it by hand:

noteOnActions[55] = (float velocity)->{
  everyFrameActions[55] = ()->{shields.dimmer=velocity;};
};
noteOffActions[55] = ()->{everyFrameActions[55]=null;}; 

//if you just want a thing to trigger once, just add it to noteOnActions
noteOnActions[56] = (float velocity)->{
  shield.animations.add(new StarMesh(shields));
};

*/

//////////////////////////////////////////////////////////
//Here's How Midi Mapping Works//
//midiMap[35] = (float cc)->{shields.dimmer = cc;};
////////That's it/////////////////////////////////////////

/*TODO:
  toggle behaviours with noteons,offs
  e.g. colorswap everything, add oskp to stuff

  to add a noteon behaviour to a pad:
  padMap[97] = (float velocity)->{shields.colorswap(10000);}
  //this will run every frame

*/


void noteOn( int channel, int pitch, int _velocity) {
  float velocity = map(_velocity, 0, 127, 0, 1);
  pad[pitch] = velocity;
  padPressed[pitch] = true;

  padPressed[pitch] = true;
  padVelocity[pitch] = velocity;
  if (noteOnActions[pitch]!=null){
    noteOnActions[pitch].send(velocity);
    println("sent ",velocity," to action",pitch);
  }
  println();
  println("padVelocity: "+pitch, "Velocity: "+velocity, "Channel: "+channel);

}
void noteOff(Note note) {
  padPressed[note.pitch] = false;
  padVelocity[note.pitch] = 0;
  if (noteOffActions[note.pitch]!=null){
    noteOffActions[note.pitch].doit();
    println("noteoff action for ",note.pitch);
  }
}
float cc[] = new float[128];                   //// An array where to store the last value received for each CC controller
void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println("cc[" + number + "]", "Velocity: "+cc[number], "Channel: "+channel);
  //see if cc value is associated in our midi mapping
  if (ccActions[number]!=null){
    ccActions[number].send(cc[number]);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void oscEvent(OscMessage theOscMessage) {
  //split address into parts
  String addr[]=theOscMessage.addrPattern().split("/");
  //String messageType=addr[addr.length-1];
  //addr[addr.length-1]="";
  //String address=String.join("/", addr);
  //int argument = (int)theOscMessage.arguments()[0];
  
  print("received osc message to "); // TODO ADD message arguments to this ....??
  printArray(addr);
  println();
  Object obj = this;
  Field fld;
  try{
    for (int i = 1;i < addr.length - 1;i++){
        fld = obj.getClass().getDeclaredField(addr[i]);
        obj = fld.get(obj);
      }
    fld = obj.getClass().getDeclaredField(addr[addr.length-1]);
    fld.set(obj,theOscMessage.arguments()[0]);
    if (keyT['q']) println("set ",fld.getName(),"to ",theOscMessage.arguments()[0]);
  }catch(Exception e){
    print("osc message ");
    printArray(addr);
    println(" failed with exception ",e);
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
