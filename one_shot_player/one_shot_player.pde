//////////////////////////// AUDIO SETUP ////////////////////////////////////
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import javax.sound.sampled.*;
import javax.sound.midi.ShortMessage;       // shorthand names for each control on the TR8
Minim minim;
AudioPlayer player[];

import oscP5.*;
import netP5.*;
OscP5 oscP5[] = new OscP5[4];

import java.util.*;//for arraylist
import java.nio.file.*;//for Path

void setup()
{
  size(600, 200);
  minim = new Minim(this);
  player = new AudioPlayer[81];
  
  ArrayList<String> path_arraylist = new ArrayList<String>(Arrays.asList(split(sketchPath(),'/')));
  path_arraylist.remove(path_arraylist.size() - 1);
  
  String parent_folder = String.join("/",path_arraylist);
  String wav_folder = String.join("/",parent_folder,"one_shot_wavs");
  println("WAV FOLDER:",wav_folder );
  
  for (int i = 1; i <= 80; i++) {
   int hundreds = i/100;
   int tens = (i%100)/10;
   int ones = i%10;
   String number =str(hundreds)+str(tens)+str(ones);
   player[i] = minim.loadFile(wav_folder+"/"+"oneshot_"+number+".wav");
   }
   
  println("audio loaded");

  /* start oscP5, listening for incoming messages at port 5000 */
  for (int i = 0; i < 4; i++) oscP5[i] = new OscP5(this, 5000+i);
  oscSetup();
}

void draw()
{
  background(0);
  fill(255);
  float x = 10;
  float y =  30;
  float gap = 15;
  text("THROTTLE BOX", x, y - gap);
  try {
    text("throttle "+str(OscAddrMap.get("/throttle_box/throttle")), x, y);
  }
  catch(Exception e) {
  }
  try {
    text("knob 1 "+str(OscAddrMap.get("/throttle_box/knob_1")), x, y+gap);
  }
  catch(Exception e) {
  }
  try {
    text("knob 2 "+str(OscAddrMap.get("/throttle_box/knob_2")), x, y+(gap*2));
  }
  catch(Exception e) {
  }
  try {
    text("button1 "+str(OscAddrMap.get("/throttle_box/throttle_button_1")), x, y+(gap*3));
  }
  catch(Exception e) {
  }
  try {
    text("button2 "+str(OscAddrMap.get("/throttle_box/throttle_button_2")), x, y+(gap*4));
  }
  catch(Exception e) {
  }
  try {
    text("tackball x "+str(OscAddrMap.get("/throttle_box/trackball_x")), x, y+(gap*5));
  }
  catch(Exception e) {
  }
  try {
    text("tackball y "+str(OscAddrMap.get("/throttle_box/trackball_y")), x, y+(gap*6));
  }
  catch(Exception e) {
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  x = 150;
  rect(x-15, 0, 2, height);
  text("KNOB BOX", x, y - gap);
  try {
    text("joystick 1 "+str(OscAddrMap.get("/knob_box/joystick_1")), x, y);
  }
  catch(Exception e) {
  }
  try {
    text("joystick 2 "+str(OscAddrMap.get("/knob_box/joystick_2")), x, y+gap);
  }
  catch(Exception e) {
  }
  for (int i=0; i<8; i++) {
    try {
      text("inst "+str(i)+" "+str(OscAddrMap.get("/knob_box/"+str(i)+"/delay")), x, y+(gap*2));
    }
    catch(Exception e) {
    }
  }
  try {
    text("knob 2 "+str(OscAddrMap.get("/knob_box/knob_2")), x, y+(gap*3));
  }
  catch(Exception e) {
  }
  try {
    text("knob 3 "+str(OscAddrMap.get("/knob_box/knob_3")), x, y+(gap*4));
  }
  catch(Exception e) {
  }
  try {
    text("swtich  "+str(OscAddrMap.get("/knob_box/switch")), x, y+(gap*5));
  }
  catch(Exception e) {
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  x = 300;
  rect(x-15, 0, 2, height);
  text("BUTTON BOX", x, y - gap);
  try {
    for (int i = 0; i < 16; i++) {
      if ( i < 4) text("btn"+i+" "+str(OscAddrMap.get("/button_box/button_"+i)), x, y+(gap*i));
      if ( i >= 4 && i < 8 ) text("btn"+i+" "+str(OscAddrMap.get("/button_box/button_"+i)), x+10, y+(gap*i));
      if ( i >= 8 && i < 12 ) text("btn"+i+" "+str(OscAddrMap.get("/button_box/button_"+i)), x+20, y+(gap*i));
      if ( i >= 12 && i < 16 ) text("btn"+i+" "+str(OscAddrMap.get("/button_box/button_"+i)), x+30, y+(gap*i));
    }
  }
  catch(Exception e) {
  }
  try {
    text("knob 1 "+str(OscAddrMap.get("/knob_box/knob_1")), x, y+(gap*4));
  }
  catch(Exception e) {
  }
  try {
    text("reset "+str(OscAddrMap.get("/knob_box/reset")), x, y+(gap*5));
  }
  catch(Exception e) {
  }
  try {
    text("switch "+str(OscAddrMap.get("/knob_box/switch")), x, y+(gap*6));
  }
  catch(Exception e) {
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  x = 450;
  rect(x-15, 0, 2, height);
  text("FADER BOX", x, y - gap);
  try {
    for (int i = 0; i < 8; i++) text("fader "+i+" "+str(OscAddrMap.get("/knob_box/fader_"+i)), x, y+(gap*i));
  }
  catch(Exception e) {
  }
  try {
    text("switch "+str(OscAddrMap.get("/knob_box/switch")), x, y+(gap*8));
  }
  catch(Exception e) {
  }
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// FIN //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
