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
  //println();
  //println("CC: ", number, "....", map(value, 0, 127, 0, 1), "- Channel:", channel);
}

void keyPressed() {
  if (key == ESC) {
    client.stop();
  } else if (key == 'd') {
    try {
      println("Connected to:");
      println(client.getServerName());
    } 
    catch (Exception e) {
      println(e);
    }
  }
}
