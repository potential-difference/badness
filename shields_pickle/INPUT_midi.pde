import java.util.function.Consumer;

interface MidiAction {
  void send(float controllerChangeValue);
}

interface FrameAction {
    void execute(float velocity);
}

interface FrameActionWithoutVelocity {
    void execute();
}

class MidiManager {
    int numNotes = 128;
    private MidiAction[] ccActions = new MidiAction[numNotes];
    private FrameAction[] everyFrameActions = new FrameAction[numNotes];
    private MidiAction[] noteOnActions = new MidiAction[numNotes];
    private FrameActionWithoutVelocity[] noteOffActions = new FrameActionWithoutVelocity[numNotes];

    public MidiManager() {
        // Initialize noteOnActions and noteOffActions here
        for (int i = 0; i < numNotes; i++) {
            int note = i;
            noteOnActions[note] = velocity -> everyFrameActions[note] = null;
            noteOffActions[note] = () -> everyFrameActions[note] = null;
        }
    }

    public void momentarySwitch(int note, FrameAction action) {
      final int noteCopy = note; // Make a static copy of the note variable to use in the lambda
        noteOnActions[note] = velocity -> {
            everyFrameActions[noteCopy] = action;
            noteOffActions[noteCopy] = () -> {
              everyFrameActions[noteCopy] = null;
            };
        };
    }
    
    // TODO figure out why this doesnt work yet - function is void colorSwapBangButton(int noteNumber, Rig... rigs) {
    public void momentaryProcess(int note, FrameAction action) {
    //  final int noteCopy = note; // Make a static copy of the note variable to use in the lambda
        for (int i = 0; i < numNotes; i++) {
            noteOnActions[i] = velocity -> {
                for (int j = 0; j < numNotes; j++) {
                    FrameAction frameAction = everyFrameActions[j];
                    if (frameAction != null) {
                        frameAction.execute(velocity); // Execute the FrameAction with the provided velocity
                    }
                }
            };
        }
    }

    public void processFrame() {
      // Process frame actions here
      for (int i = 0; i < numNotes; i++) {
            FrameAction action = everyFrameActions[i];
            if (action != null) {
                action.execute(1.0f); // You can pass the desired velocity here
            }
        }
    }





    void controllerChange(int channel, int number, int controllerChangeValue) {
        // Handle controller change here
    }
}

float pad[] = new float[128];
float padVelocity[] = new float[128];
boolean padPressed[] = new boolean[128];
    
  
   

    public void noteOn(int channel, int pitch, int _velocity) {
      float velocity = map(_velocity, 0, 127, 0, 1);
      // Handle note on event here
      midiManager.noteOnActions[pitch].send(velocity);
      // println to show this is working
      println("noteOnActions["+pitch+"]", "Velocity: "+velocity);
    }
    

    public void noteOff(Note note) {
        // Handle note off event
        midiManager.noteOffActions[note.pitch].execute();
        // println to show this is working
        println("noteOffActions["+note.pitch+"]");
    }

    

float cc[] = new float[128];                   //// An array where to store the last value received for each CC controller
void controllerChange(int channel, int number, int _controllerChangeValue) {
  cc[number] = map(_controllerChangeValue, 0, 127, 0, 1);
  // number is the cc index
  // cc[number] is the value
  println("cc[" + number + "]", "Velocity: "+cc[number], "Channel: "+channel);
  //see if cc value is associated in our midi mapping
  if (midiManager.ccActions[number]!=null){
    midiManager.ccActions[number].send(cc[number]);
  }
 
}
