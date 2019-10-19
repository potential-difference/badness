/////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
float sineFast, sineSlow, sine, stutter, shimmer;
float timer[] = new float[6];
void globalFunctions() {
  float tm = 0.05+(noize/50);
  timer[2] += alphaSlider;            

  for (int i = 0; i<timer.length; i++) timer[i] += tm;

  timer[3] += (0.3*5);
  timer[5] *=1.2;
  sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
  if (cc[102] > 0) stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave

  shimmer = (shimmerSlider/2+(stutter*0.4*noize1*0.2));

  noize();
  oskPulse();
}
//////////////////////////////////// BEATS //////////////////////////////////////////////
int beatCounter;
long beatTimer;
boolean beatTrigger;
float beat;
void beats() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
  beatTimer++;
  beatAlpha=0.2; //this affects how quickly code adapts to tempo changes 0.2 averages the last 10 onsets  0.02 would average the last 100

  if (beatDetect.isOnset()) {
    beat = 1;
    beatCounter = (beatCounter + 1) % 120;
    weightedsum=beatTimer+(1-beatAlpha)*weightedsum;
    weightedcnt=1+(1-beatAlpha)*weightedcnt;
    avgtime=weightedsum/weightedcnt;
    beatTimer=0;
  }
  if (avgtime>0) beat*=pow(alphaSlider, (1/avgtime));       //  changes rate alpha fades out!!
  else beat*=0.95;

  float end = 0.001;
  if (beat < end) beat = end;
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
  osk1 += 0.01;               
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
  noize2 = cos(10 * (noise(dx * 0.01, 0.01, z/1.5) - 0.4));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}

void bgNoise(PGraphics layer,color col,float alpha){
  layer.loadPixels();
  for (int x=0;x<size.rigWidth;x++){
    for (int y=0;y<size.rigHeight;y++){
      color pixel=layer.pixels[x+y*size.rigWidth];
      //col=int(random(255*alpha))<<24 | col&0xffffff;
      color out;
      if (random(1.0)<alpha) {
        out=col;
      }else{
        out=pixel;
      }
      layer.pixels[x+y*size.rigWidth]=out;
    }
  }
  layer.updatePixels();
}
