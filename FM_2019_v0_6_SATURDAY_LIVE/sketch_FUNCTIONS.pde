/////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
float alph[][] = new float[7][4];
float roofAlph[][] = new float[7][4];
float fct[][] = new float[8][4];
float roofFct[][] = new float[8][4];
float sineFast, sineSlow, sine, d, e, stutter;
float timer[] = new float[6];
void arrayDraw() {
  float tm = 0.05+(noize/50);
  timer[2] += beatSlider;            

  for (int i = 0; i<timer.length; i++) timer[i] += tm;

  timer[3] += (0.3*5);
  //timer[5] *=1.2;
  sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
  d = map(sin(timer[2] % HALF_PI), 0, 1, 1, 0);   //// 1-0-0-1 zero then 1 and then jump back to 0
  e = sin(timer[3] % HALF_PI);                    //// 0-1-0-1 one and then 0 jump back to one
  stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave

  //// array of functions
  fct[0] = pulzs;         
  fct[1] = beats;        
  fct[2] = pulzsSlow; 
  for (int i = 0; i < 4; i++) {
    fct[3][i] = (beatsSlow[i]*0.99)+(0.01*stutter);
    fct[4][i] = (0.99*pulzs[i])+(stutter*pulzs[i]*0.01);       
    fct[5][i] = (0.99*beatsSlow[i])+(stutter*pulzs[i]*0.01);
  }
  fct[6] = pulzsSlow;
  fct[7] = beatsSlow;

  //// array of alphas
  alph[0] = beats;
  alph[1] = pulzs;
  for (int i = 0; i < 4; i++) {
    alph[2][i] = beats[i]+(0.05*stutter);
    alph[3][i] =(0.8*beats[i])+(stutter*pulzs[i]*0.2);
    alph[4][i] = (0.8*pulzs[i])+(beats[i]*0.2*stutter);
  }
  alph[5] = beatsFast;
  alph[6] = pulzsSlow;
}
void roofArrayDraw() {
  for (int i = 0; i < fct.length; i++) {
    for (int o = 0; o < 4; o++) roofFct[i][o] = fct[i][o];
  }
  for (int i = 0; i < alph.length; i++) {
    for (int o = 0; o < 4; o++) roofAlph[i][o] = alph[i][o];
  }
}
//////////////////////////////////// BEATS //////////////////////////////////////////////
float beat, beatSlow, pulz, pulzSlow, pulzFast, beatFast, beatCounter;
float beats[] = new float[4];
float beatsSlow[] = new float[4];
float beatsFast[] = new float[4];
float pulzs[] = new float[4];
float pulzsSlow[] = new float[4];
float pulzsFast[] = new float[4];
float beatsCounter[] = new float [4];
long beatTimer;
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
void beats() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
  beatTimer++;
  beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  if (beatDetect.isOnset()) {
    beat = 1;
    beatFast = 1;
    beatSlow = 1;

    beatCounter = (beatCounter + 1) % 120;
    for (int i = 0; i < beats.length; i++) {
      if (beatCounter % 4 == i) { 
        beats[i] = 1; 
        beatsSlow[i] = 1;
        beatsFast[i] = 1;
        beatsCounter[i] = (beatsCounter[i] + 1) % 120;
      }
    }
    weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
    weightedcnt=1+(1-beatAlpha)*weightedcnt;
    avgtime=weightedsum/weightedcnt;
    beatTimer=0;
  }
  if (avgtime>0) {
    beat*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
    for (int i = 0; i < beats.length; i++) beats[i]*=pow(beatSlider*(0.001+cc[5]), (1/avgtime)); //  changes rate alpha fades out!!
    for (int i = 0; i < beats.length; i++) {
      if (beatCounter % 4 != i) beats[i]*=pow(beatSlider/3*(0.001+cc[5]), (1/avgtime));                               //  else if beat is 1,2 or 3 decay faster
    }
  } else { 
    beat*=0.95;
    for (int i = 0; i < beats.length; i++) beats[i]*=0.95;
  }
  if (beat < 0.8) beat *= 0.98;

  for (int i = 0; i < pulzs.length; i++) pulzs[i] = 1-beats[i];
  for (int i = 0; i < beatsFast.length; i++) beatsFast[i] *=0.9;
  for (int i = 0; i < pulzsFast.length; i++) pulzsFast[i] = 1-beatsFast[i];

  for (int i = 0; i < beatsSlow.length; i++) beatsSlow[i] -= 0.05;
  for (int i = 0; i < pulzsSlow.length; i++) pulzsSlow[i] = 1-beatsSlow[i];

  pulz = 1-beat;                     /// p is opposite of b
  beatFast *=0.7;                 
  pulzFast = 1-pulzFast;            /// bF is oppiste of pF

  beatSlow -= 0.05;
  pulzSlow = 1-beatSlow;

  float end = 0.01;
  if (beat < end) beat = end;
  for (int i = 0; i < beats.length; i++) if (beats[i] < end) beats[i] = end;

  if (pulzFast > 1) pulzFast = 1;
  if (beatFast < end) beatFast = end;
  for (int i = 0; i < beatsFast.length; i++) if (beatsFast[i] < end) beatsFast[i] = end;
  for (int i = 0; i < pulzsFast.length; i++) if (pulzsFast[i] > 1) pulzsFast[i] = 1;

  if (beatSlow < 0.4+(noize1*0.2)) beatSlow = 0.4+(noize1*0.2);
  for (int i = 0; i < beatsSlow.length; i++) if (beatsSlow[i] < end) beatsSlow[i] = end;
  if (pulzSlow > 1) pulzSlow = 1;
  for (int i = 0; i < pulzsSlow.length; i++) if (pulzsSlow[i] > 1) pulzsSlow[i] = 1;
} 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean test, work, info, play, stop, hold, hold1, one, two, three, four, five, six, seven, eight, nine, zero, minus, plus, space, shift, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
int keyNum;
void keyPressed() {  
  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (key == 'n') rigViz = (rigViz+1)%11;             //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') rigViz -=1;                                   //// STEP BACK TO PREVIOUS RIG VIZ
  if (rigViz <0) rigViz = 10;
  if (key == 'm') rigBgr = (rigBgr+1)%7;                                  //// CYCLE THROUGH RIG BACKGROUNDS

  /////////////////////////////// ROOF KEY FUNCTIONS ////////////////////////
  if (key == 'h') roofViz = (roofViz+1)%8;             //// STEP FORWARD TO NEXT RIG VIZ
  if (key == 'g') roofViz -= 1;   //// STEP BACK TO PREVIOUS RIG VIZ
  if (roofViz <0) roofViz = 7;
  if (key == 'j') roofBgr = (roofBgr+1)%7;        //// CYCLE THROUGH ROOF BACKGROUNDS

  if (key == ',') {                            //// CYCLE THROUGH RIG FUNCS
    fctIndex = (fctIndex+1)%fct.length; 
    fct1Index = (fct1Index+1)%fct.length;
  }  
  if (key == '.') {                            //// CYCLE THROUGH RIG ALPHAS
    alphIndex = (alphIndex+1)%alph.length; 
    alph1Index = (alph1Index+1)%alph.length;
  }   

  if (key == 'k') {                          //// CYCLE THROUGH ROOF FUNCS
    roofFctIndex = (roofFctIndex+1)%fct.length; 
    roofFct1Index = (roofFct1Index+1)%fct.length;
  }  
  if (key == 'l') {                            //// CYCLE THROUGH ROOF ALPHAS
    roofAlphIndex = (roofAlphIndex+1)%alph.length; 
    roofAlph1Index = (roofAlph1Index+1)%alph.length;
  }   
  if (key == 'c') co = (co+1)%col.length;      //// CYCLE THROUGH COLORS
  if (key == 'v') co1 = (co1+1)%col.length;


  //// SHIFT KEY TO SWITCH BETWEEN TOGGLE or HOLD key functions
  if (key == CODED) {
    switch(keyCode) {
    case SHIFT:
      shift = !shift;
      break;
    }
  }
  /// loops to change keyP[] to true when pressed, false when released to give hold control
  for (int i = 32; i <=63; i++) {
    // char n = char(i);
    if (key == char(i)) keyP[i]=true;
    if (keyP[i]) {
      fill(300);
      textSize(18);
      textAlign(CENTER);
      text("key press: " + i, size.info.x, 20); //// ptint onscreen ASCII number for key pressed
      //println(i);  //// print key
    }
  }
  for (int i = 91; i <=127; i++) {
    //  char n = char(i);
    if (key == char(i)) keyP[i]=true;
    if (keyP[i]) {
      fill(300);
      textSize(18);
      textAlign(CENTER);
      text("key press: " + i, size.info.x, 20);
      //println(i);  //// print key
    }
  }

  for (int i = 32; i <=63; i++) {
    //  char n = char(i);
    if (key == char(i)) {
      keyT[i] = !keyT[i];
      println(key, i, keyT[i]);  //// print key
    }
  }

  for (int i = 91; i <=127; i++) {
    if (key == char(i)) {
      keyT[i] = !keyT[i];
      println(key, i, keyT[i]);  //// print key
    }
  }


  /// switches for function  control
  switch(key) {
  case 'q':
    info = !info;
    break;
  case 't':
    test = !test;
    break;
  case 'w':
    work = !work;
    break;
  case '[':
    hold = !hold;
    break;
  case ']':
    hold1 = !hold1;
    break;
  case ';':
    colFlip = !colFlip;
    break;
  case 'l':
    colBeat = !colBeat;
    break;
  }
  /// TOGGLE KEYS active when SHIFT is FALSE ////
  if (!shift) {
    switch(key) {
    case '1':
      one = !one;
      break;
    case '2':
      two = !two;
      break;
    case '3':
      three = !three;
      break;
    case '4':
      four = !four;
      break;
    case '5':
      five = !five;
      break;
    case '6':
      six = !six;
      break;
    case '7':
      seven = !seven;
      break;
    case '8':
      eight = !eight;
      break;
    case '9':
      nine = !nine;
      break;
    case '0':
      zero = !zero;
      break;
    case '-':
      minus = !minus;
      break;
    case '+':
      plus = !plus;
      break;
    case ' ':
      space = !space;
      break;
    }
  } else if (shift) {
    one = false;
    two = false;
    three = false;
    four = false;
    five = false;
    six = false;
    seven = false;
    eight = false;
    nine = false; 
    zero = false;
    space = false;
    minus = false;
    plus = false;
  }
}

void keyReleased()
{
  /// loop to change key[] to false when released to give hold control
  for (int i = 32; i <=63; i++) {
    char n = char(i);
    if (key == n) keyP[i]=false;
  }
  for (int i = 91; i <=127; i++) {
    char n = char(i);
    if (key == n) keyP[i]=false;
  }
} 

///////////////////////////////////////// MIDI FUNCTIONS ///////////////////////////////////////////
float pad[] = new float[64];
void noteOn(Note note) {
  println();
  println("BUTTON: ", +note.pitch);
  
if(note.pitch == 36){
    fill(360*smokePump);
    rect(dmx.smoke[0].x, dmx.smoke[0].y, 10, 10);
  }

  if (+note.pitch > 99 && +note.pitch < 104) pad[0] = (+note.pitch);
  if (+note.pitch > 108 && +note.pitch < 112) pad[0] = (+note.pitch);
  if (+note.pitch > 103 && +note.pitch < 108)  pad[1] = (+note.pitch);
  if (+note.pitch > 112 && +note.pitch < 117)  pad[1] = (+note.pitch);
  if (+note.pitch > 108 && +note.pitch < 111)  pad[2] = (+note.pitch);
  if (+note.pitch > 112 && +note.pitch < 115)  pad[3] = (+note.pitch);
}

void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println();
  println("CC: ", number, "....", map(value, 0, 127, 0, 1));
  //spd = 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
float pause;
void pause(int pau) {
  if (beatDetect.isOnset()) {
    pause = 0;
    time[4] = millis()/1000;
  }
  if (beatDetect.isOnset() == false) {
    if (millis()/1000 - time[4] >= pau) {
      pause +=1;
      time[4] = millis()/1000;
    }
  }
  if (pause > 0) {
    beat  = d;
    for (int i = 0; i < beats.length; i++) if (beatCounter % 4 == i)  beats[i] = d;
    pulz = e;
    if (millis()/1000 - time[5] >= 4) {
      beatCounter +=1%120;
      time[5] = millis()/1000;  //// also update the stored time
      println("PAUSE ", pause);
    }
    if (pause == 10 || pause == 11) {
      beat  = 0;
      for (int i = 0; i < beats.length; i++) if (beatCounter % 4 == i)  beats[i] = 0;
      pulz = 0;
    }
    if (pause > 11) {
      beat  = sine;
      for (int i = 0; i < beats.length; i++) if (beatCounter % 4 == i)  beats[i] = sine;
      pulz = 1-sine;
    }
  }
}

/////////////////////////////////////////////// OSKP///////////////////////////////////////////
float osk1, oskP, timer1;
void oskPulse() {
  osk1 += 0.01;                ////// length of time for loop /////
  timer1 = log(map (sin(osk1), -1, 1, 0.1, 10000));
  timer1 += timer1;
  oskP = map(sin(timer1), -1, 1, 0, 1);
}
////////////////////////////////////////////// NOIZE ////////////////////////////////////////////
float noize, noize1, noize2, noize12;
void noize() {
  float dx = millis() * 0.0001;
  float z = millis() * 0.0001;

  noize = sin(10 * (noise(dx * 0.01, 0.01, z) - 0.4));
  noize2 = cos(10 * (noise(dx * 0.01, 0.01, z) - 0.4));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}
