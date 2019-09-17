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
  /*
 oscAddrToMidiMap.put("/instrument/0/noteon", new int[]{  NOTE_ON, TR8CHANNEL, BD });
   oscAddrToMidiMap.put("/instrument/1/noteon", new int[]{  NOTE_ON, TR8CHANNEL, SD });
   oscAddrToMidiMap.put("/instrument/2/noteon", new int[]{  NOTE_ON, TR8CHANNEL, LT });
   oscAddrToMidiMap.put("/instrument/3/noteon", new int[]{  NOTE_ON, TR8CHANNEL, MT });
   oscAddrToMidiMap.put("/instrument/4/noteon", new int[]{  NOTE_ON, TR8CHANNEL, HT });
   oscAddrToMidiMap.put("/instrument/5/noteon", new int[]{  NOTE_ON, TR8CHANNEL, RS });
   oscAddrToMidiMap.put("/instrument/6/noteon", new int[]{  NOTE_ON, TR8CHANNEL, HC });
   oscAddrToMidiMap.put("/instrument/7/noteon", new int[]{  NOTE_ON, TR8CHANNEL, CH });
   */
  oscAddrToMidiMap.put("/instrument/0/volume", new int[]{  CTRL_CHG, TR8CHANNEL, BDLEVEL});
  oscAddrToMidiMap.put("/instrument/1/volume", new int[]{  CTRL_CHG, TR8CHANNEL, SDLEVEL});
  oscAddrToMidiMap.put("/instrument/2/volume", new int[]{  CTRL_CHG, TR8CHANNEL, LTLEVEL});
  oscAddrToMidiMap.put("/instrument/3/volume", new int[]{  CTRL_CHG, TR8CHANNEL, MTLEVEL});
  oscAddrToMidiMap.put("/instrument/4/volume", new int[]{  CTRL_CHG, TR8CHANNEL, HTLEVEL});
  oscAddrToMidiMap.put("/instrument/5/volume", new int[]{  CTRL_CHG, TR8CHANNEL, RSLEVEL});
  oscAddrToMidiMap.put("/instrument/6/volume", new int[]{  CTRL_CHG, TR8CHANNEL, HCLEVEL});
  oscAddrToMidiMap.put("/instrument/7/volume", new int[]{  CTRL_CHG, TR8CHANNEL, CHLEVEL});

  oscAddrToMidiMap.put("/instrument/0/tune", new int[]{  CTRL_CHG, TR8CHANNEL, BDTUNE});
  oscAddrToMidiMap.put("/instrument/1/tune", new int[]{  CTRL_CHG, TR8CHANNEL, SDTUNE});
  oscAddrToMidiMap.put("/instrument/2/tune", new int[]{  CTRL_CHG, TR8CHANNEL, LTTUNE});
  oscAddrToMidiMap.put("/instrument/3/tune", new int[]{  CTRL_CHG, TR8CHANNEL, MTTUNE});
  oscAddrToMidiMap.put("/instrument/4/tune", new int[]{  CTRL_CHG, TR8CHANNEL, HTTUNE});
  oscAddrToMidiMap.put("/instrument/5/tune", new int[]{  CTRL_CHG, TR8CHANNEL, RSTUNE});
  oscAddrToMidiMap.put("/instrument/6/tune", new int[]{  CTRL_CHG, TR8CHANNEL, HCTUNE});
  oscAddrToMidiMap.put("/instrument/7/tune", new int[]{  CTRL_CHG, TR8CHANNEL, CHTUNE});

  oscAddrToMidiMap.put("/instrument/0/decay", new int[]{  CTRL_CHG, TR8CHANNEL, BDDECAY});
  oscAddrToMidiMap.put("/instrument/1/decay", new int[]{  CTRL_CHG, TR8CHANNEL, SDDECAY});
  oscAddrToMidiMap.put("/instrument/2/decay", new int[]{  CTRL_CHG, TR8CHANNEL, LTDECAY});
  oscAddrToMidiMap.put("/instrument/3/decay", new int[]{  CTRL_CHG, TR8CHANNEL, MTDECAY});
  oscAddrToMidiMap.put("/instrument/4/decay", new int[]{  CTRL_CHG, TR8CHANNEL, HTDECAY});
  oscAddrToMidiMap.put("/instrument/5/decay", new int[]{  CTRL_CHG, TR8CHANNEL, RSDECAY});
  oscAddrToMidiMap.put("/instrument/6/decay", new int[]{  CTRL_CHG, TR8CHANNEL, HCDECAY});
  oscAddrToMidiMap.put("/instrument/7/decay", new int[]{  CTRL_CHG, TR8CHANNEL, CHDECAY});

  oscAddrToMidiMap.put("/instrument/0/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, BDCTRL});
  oscAddrToMidiMap.put("/instrument/1/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, SDCTRL});
  oscAddrToMidiMap.put("/instrument/2/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, LTCTRL});
  oscAddrToMidiMap.put("/instrument/3/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, MTCTRL});
  oscAddrToMidiMap.put("/instrument/4/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, HTCTRL});
  oscAddrToMidiMap.put("/instrument/5/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, RSCTRL});
  oscAddrToMidiMap.put("/instrument/6/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, HCCTRL});
  oscAddrToMidiMap.put("/instrument/7/ctrl", new int[]{  CTRL_CHG, TR8CHANNEL, CHCTRL});


  //oscAddrToMidiMap.put("/global/kitselect/", new int[]{ PRGM_CHG, 10 });   /////////////////////////change once benjamin uploads new code
  oscAddrToMidiMap.put("/global/patternChange", new int[]{ PRGM_CHG, 9 });

  oscAddrToMidiMap.put("/globalEffects/throttle", new int[]{ CTRL_CHG, TR8CHANNEL, MASTERFXLEVEL });
  oscAddrToMidiMap.put("/globalEffects/throttleButton", new int[]{ CTRL_CHG, TR8CHANNEL, MASTERFXON});

  oscAddrToMidiMap.put("/globalEffects/control1", new int[]{ CTRL_CHG, TR8CHANNEL, REVERBLEVEL});
  oscAddrToMidiMap.put("/globalEffects/control2", new int[]{ CTRL_CHG, TR8CHANNEL, DELAYLEVEL});

  oscAddrToMidiMap.put("/globalEffects/x", new int[]{ CTRL_CHG, TR8CHANNEL, DELAYFEEDBACK});
  oscAddrToMidiMap.put("/globalEffects/y", new int[]{ CTRL_CHG, TR8CHANNEL, DELAYTIME});

  /*
  int DELAYLEVEL = 16;
   int DELAYTIME = 17;
   int DELAYFEEDBACK = 18;
   int MASTERFXON = 15;
   int MASTERFXLEVEL = 19;
   int REVERBLEVEL = 91;
   */

  //oscAddrToMidiMap.put("/globalEffects/kitSelect/", new int[]{ PRGM_CHG, TR8CHANNEL});
}

HashMap<String, Integer> OscAddrMap = new HashMap<String, Integer>();
//HashMap<String, int[]> oscAddrToMidiMap = new HashMap<String, int[]>();
//HashMap<String, int[]> OscAddrMap = new HashMap<String, Triggerable>();


//HashMap<String, Triggerable> OscEventMap = new HashMap<String, Triggerable>();

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  //first send it right back out as midi
  /* try {
   int midiaddr[] = oscAddrToMidiMap.get(theOscMessage.addrPattern());
   int midival = (int)theOscMessage.arguments()[0];                                        //bit of an assumption, but it'll work if we send ints<127
   
   if (midiaddr.length == 2) {
   int kitval = midival;
   TR8bus.sendMessage(midiaddr[0], midiaddr[1], kitval);                                //send PROGRAM CHANGE message  
   println("send PROGRAM message ", +midiaddr[0]+" "+midiaddr[1]+" "+kitval);
   } else {
   TR8bus.sendMessage(midiaddr[0], midiaddr[1], midiaddr[2], midival);                   //send every other message
   //println("send MIDI message ", +midiaddr[0]+" "+midiaddr[1]+" "+midiaddr[2]+" "+midival);
   }
   }
   
   catch(Exception e) {
   println("Osc address "+theOscMessage.addrPattern()+" not in oscAddrToMidiMap");
   }
   */


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
  //somewhere else:
  //    to get /global/decay value
  //    try{
  //      OscAddrMap.get("/global/decay");//returns int
  //     }catch(Exception e){println(e);}
  /*try {
   OscAddrMap.get(address).trigger(messageType, theOscMessage.arguments());    /// TO DO: sort out the trigger function so this works
   
   }
   catch(Exception e) {
   };*/

//  if (messageType.equals("masterFXon") == true) {
//    float rigHue = hue(rig.c), sat = saturation(rig.c), bright = brightness(rig.c);
//    //float reSat = 
//    rig.c = color(hue, sat, bright);
//  }
  //if (messageType.equals("throttleValue"))
  //  if (messageType.equals("throttleButton"))

      if (messageType.equals("oneshot")) {
        if (argument == 21) rigBgr = int(random(0, 8));
      }
  if (messageType.equals("kitChange")) {
    colorControl(argument);
  }
  if (messageType.equals("buttonSelected")) {
    if (argument<5) {
      button[argument]=!button[argument];
      println(button[argument]);
    }
    if (argument==10) {
      button[argument]=!button[argument];
    }
    if (argument > 4 && argument < 10 ) rigViz = argument-5;
    if (argument > 10 && argument < 16 ) rigViz = argument-11;
  }
  if (argument==10) {
    int steps = 1;
    rig.colorA =  (rig.colorA + steps) % (rig.col.length-1);
    rig.colB =  rig.col[rig.colorA];
    rig.colorB = (rig.colorB + steps) % (rig.col.length-1);
    rig.colD = rig.col[rig.colorB];
    //co2 = (co2 + steps) % (col.length-1);
    //co3 = (co3 + steps) % (col.length-1);
  }
}
