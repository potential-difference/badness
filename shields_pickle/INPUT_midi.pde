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

    public void newMomentary(int note, FrameAction action) {
        // Set up new momentary action here
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
        // Handle note on event
    }

    public void noteOff(Note note) {
        // Handle note off event
    }

float cc[] = new float[128];                   //// An array where to store the last value received for each CC controller
void controllerChange(int channel, int number, int controllerChangeValue) {
  cc[number] = map(controllerChangeValue, 0, 127, 0, 1);
  println("cc[" + number + "]", "Velocity: "+cc[controllerChangeValue], "Channel: "+channel);
  //see if cc value is associated in our midi mapping
  if (midiManager.ccActions[number]!=null){
    midiManager.ccActions[number].send(cc[controllerChangeValue]);
  }
 
}
