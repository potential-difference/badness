//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean colBeat, debugToggle;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
void keyPressed() {  

    if (key == 'e') debugToggle = !debugToggle; // toggle debug 

    /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
    if (shields != null) {
        if (key == 'n') shields.vizIndex = (shields.vizIndex + 1) % shields.availableAnims.length;        //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
        if (key == 'b') shields.vizIndex -= 1;                            //// STEP BACK TO PREVIOUS RIG VIZ
        if (shields.vizIndex < 0) shields.vizIndex = shields.availableAnims.length - 1;
        if (key == 'm') shields.bgIndex = (shields.bgIndex + 1) % shields.availableBkgrnds.length;                 //// CYCLE THROUGH RIG BACKGROUNDS
        if (key == ',') {                                      //// CYCLE THROUGH RIG FUNCS
            shields.functionIndexA = (shields.functionIndexA + 1) % shields.availableFunctionEnvelopes.length; //animations.func.length; 
            shields.functionIndexB = (shields.functionIndexB + 1) % shields.availableFunctionEnvelopes.length; //fct.length;
        }  
        if (key == '.') {                                      //// CYCLE THROUGH RIG ALPHAS
            shields.alphaIndexA = (shields.alphaIndexA + 1) % shields.availableAlphaEnvelopes.length; //alph.length; 
            shields.alphaIndexB = (shields.alphaIndexB + 1) % shields.availableAlphaEnvelopes.length; //alph.length;
        }   
        if (key == 'c') shields.colorIndexA = (shields.colorIndexA + 1) % shields.col.length; //// CYCLE FORWARD THROUGH RIG COLORS
        if (key == 'v') shields.colorIndexB = (shields.colorIndexB + 1) % shields.col.length;         //// CYCLE BACKWARD THROUGH RIG COLORS
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// momentaory key pressed array /////////////////////////////////////////////////
    for (int i = 32; i <=  63; i++)  if (key == char(i)) keyP[i] = true;
    for (int i = 91; i <=  127; i++) if (key == char(i)) keyP[i] = true;
    ///////////////////////////////// toggle key pressed array ///////////////////////////////////////////////////////
    for (int i = 32; i <=  63; i++) {
        if (key == char(i)) keyT[i] = !keyT[i];
        if (key == char(i)) println(key, i, keyT[i]);
    }
    for (int i = 91;i <=  127; i++) {
        if (key == char(i)) keyT[i] = !keyT[i];
        if (key == char(i)) println(key, i, keyT[i]);
    }
}

void keyReleased() {
    /// loop to change key[] to false when released to give momentary control
    for (int i = 32; i <=  63; i++) {
        char released = char(i);
        if (key == released) keyP[i] = false;
    }
    for (int i = 91; i <=  127; i++) {
        char released = char(i);
        if (key == released) keyP[i] = false;
    }
} 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
