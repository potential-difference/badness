
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
  if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave

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
    alph[3][i] =(0.98*beats[i])+(stutter*pulzs[i]*0.02);
    alph[4][i] = (0.98*pulzs[i])+(beats[i]*0.02*stutter);
  }
  alph[5] = beatsFast;
  alph[6] = pulzsSlow;
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
boolean beatTrigger;
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
void beats() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
  beatTimer++;
  beatAlpha=0.2;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100

  // trigger beats from audio source
  beatTrigger = beatDetect.isOnset();
  // trigger beats without audio input
  float triggerLimit = (sineFast);
  //if (pause > 3) {
  //  if (triggerLimit > 0.9995) beatTrigger = true;
  //  else beatTrigger = false;
  //}

  if (beatTrigger) {
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
    for (int i = 0; i < beats.length; i++) {
      beats[i]*=pow(beatSlider, (1/avgtime)); //  changes rate alpha fades out!!
      if (beatCounter % 4 != i) beats[i]*=pow(beatSlider/3, (1/avgtime));                               //  else if beat is 1,2 or 3 decay faster
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

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
float pause;
void pause(int pau) {
  if (beatDetect.isOnset()) {
    pause = 0;
    time[4] = millis()/1000;
  }
  //if (beatDetect.isOnset() == false) {
  //  if (millis()/1000 - time[4] >= pau) {
  //    pause +=1;
  //    time[4] = millis()/1000;
  //  }
  //}
  //if (pause > 0) {
  //  if (millis()/1000 - time[5] >= 4) {
  //    //beatCounter +=1%120;
  //    time[5] = millis()/1000;  //// also update the stored time
  //  }
  //}
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
  float z = millis() * 0.0003;
  // changed to 1D noise
  noize = sin(dx); //sin(10 * (noise(dx * 0.01, 0.01, z) - 0.4));
  noize2 = cos(z); //cos(10 * (noise(dx * 0.01, 0.01, z/1.5) - 0.4));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}
