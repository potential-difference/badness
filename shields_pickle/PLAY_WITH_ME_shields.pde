void setupShieldMidiActions() {
    
    /////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SHIELDS ///////////////////////////////////
    offBangButton(48, shields);              // OFF BANG BUTTON: noteNumber, rig objects to turn off
    animOnBangButton(49, shields);           // ANIM ON BANG BUTTON: noteNumber, rig objects to add animation to
    allOnForeverBangButton(50, shields);     // ALL ON FOREVER BANG BUTTON: noteNumber, rig objects to add animation to
    
    blackCircleBangButton(51, shields);      // new button effect needs work        
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// MOMENTARY PAD BUTTON draws a black circle at a pixel position for a rig object
// void blackCircleBangButton(int noteNumber, Rig...rigs) {
//  midiManager.momentarySwitch(noteNumber, velocity -> {
//         if (velocity > 0) {
//             int length = shields.pixelPosition.size();
//             for (int i = 0; i < length; i++) {
//                 PVector pos = shields.pixelPosition.get(i);
//                 fill(360, 360*velocity);
//                 ellipse(pos.x, pos.y, 30, 30);
//                 println("black circle", pos);
//                 }
//             }
//         });           
// }


// MOMENTARY PAD BUTTON draws a black circle at a pixel position for a rig object
void blackCircleBangButton(int noteNumber, Rig...rigs) {
 midiManager.momentarySwitch(noteNumber, velocity -> {
                fill(360);
                ellipse(width/2,height/2, width, height);
                println("circel ", velocity);
            });
                  
}



