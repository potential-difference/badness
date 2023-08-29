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
    public void momentaryProcess(int note, FrameAction _action) {
        final int noteCopy = note; // Make a static copy of the note variable to use in the lambda
        noteOnActions[note] = velocity -> {
            for (int i = 0; i < numNotes; i++) {
                FrameAction action = everyFrameActions[i];
                if (action != null) {
                    action.execute(velocity); // You can pass the desired velocity here
                }
                // everyFrameActions[noteCopy] = action;
                //  if (action != null) {
                //  action.execute(velocity); // Execute the FrameAction with the provided velocity
                //  }
                noteOffActions[noteCopy] = () -> {
                    everyFrameActions[noteCopy] = null;
                };
            };
        };
    }
    
    public void processFrame() {
        //Process frame actions here
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

public void noteOn(int channel, int pitch, int _velocity) {
    float velocity = map(_velocity, 0, 127, 0, 1);
    // Handle note on event here
    midiManager.noteOnActions[pitch].send(velocity);
    // println to show this is working
    println("noteOnActions[" + pitch + "]", "Velocity: " + velocity);
}

public void noteOff(Note note) {
    // Handle note off event
    midiManager.noteOffActions[note.pitch].execute();
    // println to show this is working
    println("noteOffActions[" + note.pitch + "]");
}

// An array where to store the last value received for each CC controller
// cc[channel][number] is the value
// MDP8 is channel 0 // LaunchPad is channel 8
float cc[][] = new float[9][128];   
void controllerChange(int channel, int number, int _controllerChangeValue) {
    cc[channel][number] = map(_controllerChangeValue, 0, 127, 0, 1);
    // channel is the midi channel
    // number is the cc index
    // cc[channel][number] is the value
    println("Channel: " + channel, " cc[" + number + "]", "Velocity: " + cc[channel][number]);
    //see if cc value is associated in our midi mapping
    // if (midiManager.ccActions[number]!= null) {
    //     midiManager.ccActions[number].send(cc[channel][number]);
    // }
}

