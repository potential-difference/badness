HashMap<String, Integer> OscAddrMap = new HashMap<String, Integer>();
/* incoming osc message are forwarded to the oscEvent method. */
int oneshotmap = 0;

void oscSetup() {
  int startVal = 64;
  /*
    OscAddrMap.put("/throttle_box/throttle_button_1", startVal);
   OscAddrMap.put("/throttle_box/throttle_button_2", startVal);
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
   */
  ////////////////////////////////////////////////////////////////////////////////////////////////
  OscAddrMap.put("/knob_box/joystick_1", 0);
  OscAddrMap.put("/knob_box/joystick_2", 0);
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  //split address into parts
  String addr[]=theOscMessage.addrPattern().split("/");
  String messageType=addr[addr.length-1];
  addr[addr.length-1]="";
  String address=String.join("/", addr);
  print("address = '"+address+"'");
  print(" mesgtype = '"+messageType+"'");
  int argument = (int)theOscMessage.arguments()[0];
  println(" mesgArgument = "+argument);
  OscAddrMap.put(theOscMessage.addrPattern(), argument);
println("put");
  if (messageType.equals("joystick_1") || messageType.equals("joystick_2")) {
    oneshotmap=int(OscAddrMap.get("/knob_box/joystick_1")*9+OscAddrMap.get("/knob_box/joystick_2"));
    println("oneshotmap = "+oneshotmap);
    if (oneshotmap>0) {
      oneShot(oneshotmap);
    }
  }
}
int shot;
void keyPressed() { 

  //int oneshotmap = int(map(argument, 1, 254, 1, player.length-1)); 
  shot = (shot + 1) % 80; 
  if (key == ' ') oneShot(shot);
}
