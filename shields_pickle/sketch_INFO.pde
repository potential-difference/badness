/* KEY FUNCTIONS

'c' steps through one of the colours
'v' steps theough the other colour - current and upcoming colours are displayed in small boxes below the main animation
'b' steps the animations backwards 
'n' steps the animations forward
'm' changes the backgrounds
',' changes the function
'.' changes the alpha
'l' toggle colour change on beat
';' toggle swaps color c/flash
''' swaps color c/flash - press and hold
'\' color swap
'[' viz hold - stops the timer counting down for next viz change
']' color hold - stops the timer counting down for next colour change
'q' toggles mouse coordiantes and moveable dot
't' toggle TEST - cycles though all colours to test LEDs
'w' toggle WORK LIGHTS - all WHITE 

*/
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
void onScreenInfo() {
    mouseInfo();
    dividerLines();
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////// SHOW INFO ABOUT CURRENT RIG ARRAY SELECTION ///////////////////////////// 
    float x = size.info.x - size.info.wide / 2 + 10;
    float y = size.info.y - size.info.high / 2 + 20;
    textAlign(LEFT);
    textSize(18);
    fill(300);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////// INFO ABOUT SKETCH AND BEATS /////////////////////////////////////////////
    text(int(frameRate) + " fps", x, y);            // framerate
    text("BMP " + nf(bmp,0,1), x + 60, y);          // bmp display - TODO i dont think this works correctly
    text("millis: " + int(avgmillis), x + 145, y);  // avgmillis since last beat
    //////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////// RIG VIZ | ALPHA | FUNC | BG INFO //////////////////////////////////////////
    fill(300);
    text("rigViz: " + shields.availableAnims[shields.vizIndex], x, y + 20);
    text("bkgrnd: " + shields.availableBkgrnds[shields.bgIndex], x, y + 40);
    text("func's: " + shields.availableFunctionEnvelopes[shields.functionIndexA] + " / " + shields.availableFunctionEnvelopes[shields.functionIndexB], x + 110, y + 20);
    text("alph's: " + shields.availableAlphaEnvelopes[shields.alphaIndexA] + " / " + shields.availableAlphaEnvelopes[shields.alphaIndexB], x + 110, y + 40);
    text("color A/B: " + shields.availableColors[shields.colorIndexA] + " / " + shields.availableColors[shields.colorIndexB], x , y + 60);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /////////// info about PLAYWITHYOURSELF functions ////////////////////////////////////////////////
    fill(300);
    y += 10;
    String sec = nf(int(vizChangeTime * 60 - (millis() / 1000 - rigs.get(0).vizTimer)) % 60, 2, 0);
    int min = int(vizChangeTime * 60 - (millis() / 1000 - rigs.get(0).vizTimer)) / 60 % 60;
    text("next viz in: " + min + ":" + sec, x, y + 80);
    ///// NEXT COLOR CHANGE IN....
    sec = nf(int(colorChangeTime * 60 - (millis() / 1000 - rigs.get(0).colorTimer)) % 60, 2, 0);
    min = int(colorChangeTime * 60 - (millis() / 1000 - rigs.get(0).colorTimer)) / 60 % 60;
    text("next color in: " + min + ":" + sec, x, y + 100);
    int totalAnims = 0;      
    for (Rig rig : rigs) totalAnims += rig.animations.size();
    text("# of anims: " + totalAnims, x,y + 120);
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////// ENVELOPES VIZULIZATION ///////////////////////////////////////////
    x += 25;              // STARTING xpos for each section
    y += 150;             // STARTING ypos for 1st section
    float length = 150;   // LENGTH of each vizulization
    float box = 10;       // SIZE of each box
    float gap = 2.5;      // GAP between boxes
    float dist = box + (gap * 2);  // DIST between each box
    float y1 = y + (length / 2) + (dist * 2.5);   // STARTING ypos for 2nd section, confusing the maths here oops
    textAlign(CENTER);
    textSize(14);
    strokeWeight(1);
    fill(c1, 200);         // FILL for the text
    stroke(c1, 120);       // STROKE for the lines
    int i = 0;             // COUNTER for each box
    float vizulizationWidth = (size.info.wide / 3);  // WIDTH of vizulization, distance the boxes travel across screen
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////// draw vertical lines around vizulizations showing ALPHA A /////////////////////////
    float linex = x - dist - box;                // STARTING xpos for 1st line
    line(linex, y - (dist / 2), linex, y + (length / 2) + dist);
    float linexx = x + vizulizationWidth;        // STARTING xpos for 2nd line
    line(linexx, y - (dist / 2), linexx, y + (length / 2) + dist);
    // onscreen text to show this section is for the alphaA envelopes 
    float textx = (linexx - linex) / 2 + linex;   // CENTER of the 1st section
    text("ALPHA A", textx, y - 10);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////// draw lines around vizulizations showing FUNCTION A, same xpos as 1st line, ypos is y1
    line(linex, y1 - (dist / 2), linex, y1 + (length / 2) + dist);
    line(linexx, y1 - (dist / 2), linexx, y1 + (length / 2) + dist);
    // onscreen text to show this section is for the functionA envelopes
    text("FUNCTION A", textx, y1 - 10);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////// draw vertical lines around vizulizations showing ALPHA B /////////////////////////
    linex = linexx + dist;                                  // STARTING xpos for 1st line
    line(linex, y - (dist / 2), linex, y + (length / 2) + dist);
    linexx = linex + vizulizationWidth + dist + box;        // STARTING xpos for 2nd line
    line(linexx, y - (dist / 2), linexx, y + (length / 2) + dist);
    // onscreen text to show this section is for the alphaB envelopes 
    textx = (linexx - linex) / 2 + linex;   // CENTER of the 2nd section
    text("ALPHA B", textx, y - 10);
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////// draw lines around vizulizations showing FUNCTION B, same xpos as 1st line, ypos is y1
    line(linex, y1 - (dist / 2), linex, y1 + (length / 2) + dist);
    line(linexx, y1 - (dist / 2), linexx, y1 + (length / 2) + dist);
    // onscreen text to show this section is for the functionB envelopes
    text("FUNCTION B", textx, y1 - 10);
    //////////////////////////////////////////////////////////////////////////////////////////////////        
    try{
        for (Anim anim : shields.animations) {
            if (i < shields.animations.size() - 1) {    // if not the last one
                fill(c1, 120);                          // fill with c1
            } else {                                    // if the last one
                fill(flash1, 300);                      // fill with flash1
            }
            rect(x + (box * 2) + (anim.alphaA * vizulizationWidth - (dist * 2 + gap)), y + (dist * i), box, box);          // ALPHA A viz 
            rect(linex + (dist * 3) + (anim.alphaB * vizulizationWidth - (dist * 2 + gap)), y + (dist * i), box, box);     // ALPHA B viz
            
            rect(x + (box * 2) + (anim.functionA * vizulizationWidth - (dist * 2 + gap)), y1 + (dist * i), box, box);       // FUNCTION A viz  
            rect(linex + (dist * 3) + (anim.functionB * vizulizationWidth - (dist * 2 + gap)), y1 + (dist * i), box, box);  // FUNCTION B viz
            
            i += 1;
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////
    catch(Exception e) {
        println(e);
        println("erorr on alpah / function  envelope visulization");
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
void pauseInfo() {
    if (pause > 0) { 
        textAlign(RIGHT,BOTTOM);
        textSize(18); 
        fill(360);
        text("NO AUDIO!! PAUSE RUNNING", width - 20,height); 
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
void mouseCircle(boolean _info) {
    if (_info) {
        // draw circle over mouse to check LEDS
        float fillx = (millis() % 360);
        fill(fillx);  
        ellipse(mouseX, mouseY, 10, 10);
    } 
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
void mouseInfo() {
    // display mousecoordiantes in the bottom right.
    fill(360);
    textAlign(RIGHT,BOTTOM);
    textSize(14);
    text(" x" + mouseX + " y" + mouseY, width,height);
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
void coordinatesInfo(Rig rig, boolean _info) {
    if (_info) {
        textSize(12);
        textAlign(LEFT);
        fill(rig.c);  
        float centerX = rig.size.x - (rig.wide / 2);
        float centerY = rig.size.y - (rig.high / 2);
        for (int i = 0; i < rig.position.length; i++) {
            PVector position = rig.position[i];
            text(i, centerX + position.x, centerY + position.y); // Position info
            // TODO we also want the name of the opcgrid associated for setup, not essential but would be nice
        }
        fill(rig.flash);
        int length = rig.pixelPosition.size();
        for (int i = 0; i < length; i++) {
            PVector pv = rig.pixelPosition.get(i);
            text("" + i, centerX + pv.x, centerY + pv.y);
        }
    } 
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
void dividerLines() {
    noFill();
    stroke(rigs.get(0).c1, 200);
    strokeWeight(1);
    for (Rig rig : rigs) rect(rig.size);
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////