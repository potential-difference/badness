float[] lastTime = new float[cc.length];
void setupMidiActions() {
    
    /////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SHIELDS ///////////////////////////////////
    offBangButton(64, shields);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
    animOnBangButton(65, shields);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
    allOnForeverBangButton(66, shields);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
    /////////////////////////////////////////////////////////////////////////
    ///////////////////////////// LANTERNS //////////////////////////////////
    offBangButton(60,tipiLeft,tipiRight);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
    animOnBangButton(61,tipiLeft,tipiRight);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
    allOnForeverBangButton(62,tipiLeft,tipiRight);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
    //////////////////////////////////////////////////////////////////////////
    ////////////////////////// MEGA SEEDS ////////////////////////////////////
    offBangButton(56,megaSeedA,megaSeedB,megaSeedC);          // OFF BANG BUTTON: noteNumber, rig objects to turn off
    animOnBangButton(57,megaSeedA,megaSeedB,megaSeedC);       // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
    allOnForeverBangButton(58,megaSeedA,megaSeedB,megaSeedC); // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// UV PARS /////////////////////////////////////
    offBangButton(52,uvPars);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
    animOnBangButton(53,uvPars);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
    allOnForeverBangButton(54,uvPars);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
    /////////////////////////////////////////////////////////////////////////
    ////////////////////////// FILLAMENTS ///////////////////////////////////
    animOnBangButton(67,filaments);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
    allOnForeverBangButton(63,filaments);       // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
    /////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////
    
    colorSwapBangButton(59,shields,tipiLeft); // COLOR SWAP BANG BUTTON: noteNumber, rig objects to add animation to
    colorFlipBangButton(55,shields,tipiLeft,tipiRight,megaSeedA,megaSeedB,megaSeedC); // COLOR FLIP BANG BUTTON: noteNumber, rig objects to add animation to
    
    /*
    //CONSTANT BUTTON sets colorSwap for the given rig objects
    //TODO this is WIP and doesn't work yet - maybe a java barrier
    float customFunctionRate = 0.5f; // Adjust the function rate as needed
    Consumer<Float> colorSwapConsumer = velocity -> shields.colorSwap(velocity);
    midiManager.constantButton(59, colorSwapConsumer, customFunctionRate, shields);
    */
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// MOMENTARYPAD BUTTON turns OFF all the animations in the given rig objects
void offBangButton(int noteNumber, Rig...rigs) {
    midiManager.noteOnActions[noteNumber] = (float velocity) -> {
        for (Rig rig : rigs) {
            for (Anim anim : rig.animations) {
                anim.deleteme = true;             // delete all the animations in the given rig objects
            } 
            rig.onBeat = false;
        }
    };  
    midiManager.noteOffActions[noteNumber] = () -> {
        for (Rig rig : rigs)rig.onBeat = true;
    };
}

// MOMENTARY PAD BUTTON addsthe CURRENT ANIMATION to the given rig objects
// TODO change the alpha of the added anim so it reamins on screeen while the button is held down
// and can be controlled by a knob or a slider
void animOnBangButton(int noteNumber, Rig...rigs) {
    AnimationHolder[] animationHolders = new AnimationHolder[rigs.length];
    // TODO im not sure this loop is exaclty right but it does work
    midiManager.noteOnActions[noteNumber] = velocity -> {
        for (int i = 0; i < rigs.length;i++) {
            Rig rig = rigs[i];            // get the animation at the current vizIndex and add it to the animations list
            Anim anim = rig.animAtIndex(rig.vizIndex);
            anim.manuallyAdded = true;    // flag anim as manually added so it doesn't get deleted by PLAY WITH YOURSELF
            animationHolders[i] = new AnimationHolder(rig, anim); // create a new AnimationHolder object and add it to the array
            rig.animations.add(animationHolders[i].anim); 
        }
    };
    midiManager.noteOffActions[noteNumber] = () -> {
        for (AnimationHolder animationHolder : animationHolders) {
            if (animationHolder != null) {
                if (animationHolder.anim.manuallyAdded) {
                    animationHolder.anim.deleteme = true;
                }
            }
        }
    };
}

// MOMENTARY PAD BUTTON adds ALL ON FOREVER to the givenrig objects
void allOnForeverBangButton(int noteNumber, Rig...rigs) {
    AnimationHolder[] animationHolders = new AnimationHolder[rigs.length];
    // TODO im not sure this loop is exaclty right but it doeswork
    midiManager.noteOnActions[noteNumber] = velocity -> {
        for (int i = 0; i < rigs.length; i++) {
            Rig rig = rigs[i];
            Anim anim = new AllOnForever(rig, velocity);
            anim.manuallyAdded = true;              // flag anim as manually added soit doesn't get deleted by PLAY WITH YOURSELF
            animationHolders[i] = new AnimationHolder(rig, anim); // create a new AnimationHolder object and add it to the array
            rig.animations.add(animationHolders[i].anim); 
        }
    };
    midiManager.noteOffActions[noteNumber] = () -> {
        for (AnimationHolder animationHolder : animationHolders) {
            if (animationHolder != null) {
                if (animationHolder.anim.manuallyAdded) {
                    animationHolder.anim.deleteme = true;
                }
            }
        }
    };
}


// MOMENTARY PAD BUTTON sets colorFlip for the given rig objects
void colorFlipBangButton(int noteNumber, Rig...rigs) {
    midiManager.momentarySwitch(noteNumber, velocity -> {
        if (velocity > 0) {
            for (Rig rig : rigs) {
                rig.colFlip = true;
                println(rig.type," colorFlip", velocity); // velocity always = 1 currently 
                // though i'd fixed this!!
            }
        }
    });
}

// MOMENTARY PAD BUTTON sets colorSwap for the given rig objects
// TODO this is WIP and doesn't work yet 
void colorSwapBangButton(int noteNumber, Rig...rigs) {
    midiManager.momentaryProcess(noteNumber, velocity -> {
        if (velocity > 0) { // Check if the button is pressed (velocity > 0)
            for (Rig rig : rigs) {
                rig.colorSwap(velocity);
                println(rig.type," colorSwap", velocity);
            }
        }
        midiManager.noteOffActions[noteNumber] = () -> {
            for (Rig rig : rigs) rig.colorSwap(rig.colorSwapRate);
        };
    });
}




