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

void playWithMe() {
    
    shields.alphaRate = cc[13];
    shields.functionRate = cc[29];
    shields.strokeSlider = cc[49];

    try {
        Field dimmer = Rig.class.getDeclaredField("dimmer");  // Get the Field object using reflection
        float value = cc[77];
        dimmer.set(shields, value);    // set the dimmer value of the shields rig
        if(debugToggle) println("Value from pad: " + value);
        } catch (NoSuchFieldException | IllegalAccessException e) {
        println ("failed with exception ",e);
    }
      
    /*
    ////////////////////////////////////// Momentary pad button actions //////////////////////////////
    for (int idx = 0;idx < 128;idx++) {//action: everyFrameActions){
    FrameAction action = everyFrameActions[idx];
    if (action != null) {
    action.doit();
}
}
    */
    ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS /////////////////////////////////////////
    if (keyP['o']) rigs.get(0).colorSwap(0.9999999999);               // COLOR SWAP MOMENTARY 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // if (keyT['i']) rigs.get(0).colorFlip(keyT['i']);                  // COLOR FLIP TOGGLE 
    // if (keyP['u']) rigs.get(0).colorFlip(keyP['u']);                  // COLOR FLIP MOMENTARY
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ///////////////////////////// *** MANUAL ANIM WORK THAT DOESNT WORK **** ////////////////////////////
    /*
    float debouncetime = 100;
    try {
    if (millis()-lastTime[44]>debouncetime) {
    if (padVelocity[44]>0) shields.animations.add(new Checkers (shields));
    if (shields.animations.size() > 0 ) { 
    Anim theanim = shields.animations.get(shields.animations.size()-1);
    //Envelope manualA = CrushPulse(0.0, 0, 1, shields.manualAlpha*500, 0.0, 0.0);
    Envelope manualA = CrushPulse(0.05, 0.0, 1.0, avgmillis*(shields.manualAlpha+0.5), 0.0, 0.0);
    theanim.alphaEnvelopeA = manualA;
    theanim.alphaEnvelopeB = manualA;
    lastTime[44]=millis();
}
}
} 
    catch(Exception e) {
    println(e, "playwithyourself error");
}
    */
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////  COLOUR //////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*
    if (millis()-lastTime[41]>debouncetime) {
    if (padVelocity[41]>0) for (Anim anim : shields.animations) {
    anim.functionEnvelopeA = anim.functionEnvelopeA.mul(0.6+(stutter*0.4));  //     anim.functionEnvelopeA.mul((1-cc[54])+(stutter*cc[54]));
    anim.functionEnvelopeB = anim.functionEnvelopeB.mul(0.6+(stutter*0.4));    //anim.functionEnvelopeB.mul((1-cc[54])+(stutter*cc[54]));
}
    lastTime[41]=millis();
}
  
    //if (padVelocity[51] > 0) roof.colorSwap(0.9999999999);
    //if (padVelocity[43] > 0) pars.colorSwap(0.9999999999);                // COLOR SWAP MOMENTARY
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// PLAY WITH DRAWING FUNCTIONS ////////////////////////////////////////////////////////////// 
void playWithMeMore() {
    
    /////////////////////////////////////////////////////// 
    
    /////background noise over whole window/////
    /*
    if (padVelocity[50] > 0) {
    pars.colorLayer.beginDraw();
    pars.colorLayer.background(0, 0, 0, 0);
    pars.colorLayer.endDraw();
    //void bgNoise(PGraphics layer, color _col, float bright, float fizzyness) {
    
    bgNoise(pars.colorLayer, pars.flash, map(padVelocity[50], 0, 1, 0, pars.dimmer), cc[47]);   //PGraphics layer,color,alpha
    image(pars.colorLayer, pars.size.x, pars.size.y, pars.wide, pars.high);
}
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




