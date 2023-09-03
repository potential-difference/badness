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
    int numChannels = 9;
    private MidiAction[] ccActions = new MidiAction[numNotes];
    private FrameAction[] everyFrameActions = new FrameAction[numNotes];
    private MidiAction[] noteOnActions = new MidiAction[numNotes];
    private FrameActionWithoutVelocity[] noteOffActions = new FrameActionWithoutVelocity[numNotes];
    
    private boolean[] buttonPressed = new boolean[numNotes];
    private long[] buttonPressStartTime = new long[numNotes];
    private long longPressDuration = 1000; // Define the duration for a long press in milliseconds
        
    public MidiManager() {
        // Initialize noteOnActions and noteOffActions here
        for (int i = 0; i < numNotes; i++) {
            int note = i;
            noteOnActions[note] = velocity -> everyFrameActions[note] = null;
            noteOffActions[note] = () -> everyFrameActions[note] = null;
            println("MidiManager: noteOnActions[" + note + "] pressed");
        }
    }
    
    public void momentarySwitch(int note, FrameAction action) {
        final int noteCopy = note; // Make a static copy of the note variable to use in the lambda
        noteOnActions[note] = velocity -> {
           
            everyFrameActions[noteCopy] = action;
            noteOffActions[noteCopy] = () -> {
                everyFrameActions[noteCopy] = null;
                buttonPressed[noteCopy] = false; // Button is released, reset the flag
            };
            buttonPressed[noteCopy] = true; // Button is pressed, set the flag
            buttonPressStartTime[noteCopy] = millis(); // Record the press start time
            println("Button " + noteCopy + " pressed in MidiManger. Toggled: " + buttonPressed[noteCopy]);
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
        
        // Check for long presses
        for (int i = 0; i < numNotes; i++) {
            if (buttonPressed[i] && millis() - buttonPressStartTime[i] >= longPressDuration) {
                // Handle long press here
                // Toggle a boolean or perform any other action
                // Example: Toggle a boolean variable
                //  boolean isToggled = !isButtonToggled[i];
                println("Button " + i + " long pressed in MidiManger. Toggled: " + buttonPressed[i]);
                buttonPressed[i] = false; // Reset the flag
            }
        }
        
    }
    
    void controllerChange(int channel, int number, int controllerChangeValue) {
        // Handle controller change here
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
int numChannels = 9; //midiManager.numChannels;
int numNotes = 128; //midiManager.numNotes;
int longPressDuration = 5000; // Define the duration for a long press in milliseconds
boolean[][] padPressed = new boolean[numChannels][numNotes];
boolean[][] padToggle = new boolean[numChannels][numNotes];
long[][] padStartTime = new long[numChannels][numNotes]; // Create an array to store start times for each note
public void noteOn(int channel, int pitch, int _velocity) {
    float velocity = map(_velocity, 0, 127, 0, 1);

    midiManager.noteOnActions[pitch].send(velocity);

    /*
    // Check if the button is already pressed
    if (!padPressed[channel][pitch]) {
        // Button is not pressed, set it as pressed
        padPressed[channel][pitch] = true;
        // Start a timer to detect long press
        padStartTime[channel][pitch] = millis();
       // padVelocity[channel][pitch] = velocity;
    } else {
        // Button is already pressed, check for a long press
        if (millis() - padStartTime[channel][pitch] >= longPressDuration) {
            // Handle long-press action here
            // Example: Toggle a boolean variable
            padStartTime[channel][pitch] = millis(); // Reset the timer
            boolean isToggled = !padToggle[channel][pitch];
            println("Button " + pitch + " in Channel " + channel + " long pressed. Toggled: " + isToggled);
        }
    }
    */
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

