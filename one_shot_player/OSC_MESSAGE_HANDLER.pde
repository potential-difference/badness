HashMap<String, Integer> OscAddrMap = new HashMap<String, Integer>();
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  //split address into parts
  String addr[]=theOscMessage.addrPattern().split("/");
  String messageType=addr[addr.length-1];
  addr[addr.length-1]="";
  String address=String.join("/", addr);
  print("address ='"+address+"'");
  println(" mesgtype ='"+messageType+"'");
  int argument = (int)theOscMessage.arguments()[0];
  println(" mesgArgument = "+argument);
  OscAddrMap.put(theOscMessage.addrPattern(), argument);

  if (messageType.equals("oneshot") == true) {
    if (argument <255) {
      int oneshotmap = int(map(argument, 1, 254, 1, player.length-1)); 
      player[oneshotmap].play();
    }
  }
}
int shot;
void keyPressed() { 

  //int oneshotmap = int(map(argument, 1, 254, 1, player.length-1)); 
  shot = (shot + 1) % 80; 
  if (key == ' ') oneShot(shot);
}
