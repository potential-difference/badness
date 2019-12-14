////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Envelope SimplePulse(Number attack_time, Number sustain_time, Number decay_time, float attack_curv, float decay_curv) {
  int t=millis();
  // the arguments after DURATION describe a curve - first one is STARTVALUE last one is ENDVALUE - anything inbetween creates the curve ALWAYS EQUALLY SPACED
  //Envelope upramp = new Ramp( STARTTIME , DURATION , STARTVALUE , ** vlaues here create curve ** , FINALVALUE );
  // in this case - during the attack_time and the sustain time the downramp = 1
  // attack curve: 0.5 = STRAIGHT, 0 = SWOOP-UP, 1 = ARC-UP
  Envelope upramp = new Ramp(t, t+attack_time.intValue(), 0.0, attack_curv, 1.0);
  Envelope dwnrmp = new Ramp(t+attack_time.intValue()+sustain_time.intValue(), t+attack_time.intValue()+sustain_time.intValue()+decay_time.intValue(), 1.0, decay_curv, 0.0);
  return upramp.mul(dwnrmp);
}
// THIS IS A FUNCTION NOT AN ENVELOPE - it RETURNS an ENVELOPE that starts sowly going from 0 TO 1 TO 0 and getting FASTER but still with the same AMPLITUDE
Envelope SlowFast(int start_time, int duration, int start_period, int end_period) {
  // this ramp is a stright line - starting at START_PERIOD and finishing at END_PERIOD over the DURATION variable
  Envelope period = new Ramp(start_time, start_time+duration, start_period, end_period);
  // passing envelope to SINE as PERIOD
  return new Sine(1.0, period); //Using an envelope as the parameter
}
// starts OSSCILIATING with the AMPLITUDE slowly RAMPING to 0.4, ADDITIONALLY ramping to 0.6 with the top 0.2 SQUIGGLING
Envelope Squiggle(int attack_t, int sustain_t, int decay_t, float attack_curv, float decay_curv, float sqiggle_curv, float squiggliness, int squiggle_spd) {
  Envelope base = SimplePulse(attack_t, sustain_t, decay_t, attack_curv, decay_curv);
  int sin_start=millis()+attack_t;
  int sin_duration=sustain_t+decay_t;
  int start_period=sin_duration;
  int end_period = sin_duration/5;
  // squiggle is always 0.4, squigglieness starts after ATTACKTIME and gets squigglier till end of SUSTAINTIME remains SQUIGGLING FOREVER
  //Envelope squiggle = SlowFast(sin_start, sin_duration, start_period, end_period).mul(new Ramp(sin_start, sin_start+sin_duration, 0.0, sqiggle_curv, squiggliness));
  Envelope squiggle = new Sine(1, squiggle_spd).mul(new Ramp(sin_start, sin_start+sin_duration, 0.0, sqiggle_curv, squiggliness)).add(1-squiggliness);
  return base.mul(squiggle);
}
Envelope SineBySine(float amplitude, int period, float amplitude1, int period1) {
  Envelope firstSine = new Sine(amplitude, period);
  return firstSine.mul(new Sine(amplitude1, period1));
}


Envelope PullDown(int attack_time, int sustain_time, int decay_time, float attack_curv, float decay_curv, float effect_value) {
  int t=millis();
  //Envelope upramp = new Ramp( STARTTIME , DURATION , STARTVALUE , ** vlaues here create curve ** , FINALVALUE );
  // attack curve: 0.5 = STRAIGHT, 0 = SWOOP-UP, 1 = ARC-UP
  Envelope downramp = new Ramp(t, t+attack_time, 1.0, attack_curv, effect_value);
  Envelope upramp = new Ramp(t+attack_time+sustain_time, t+attack_time+sustain_time+decay_time, effect_value, attack_curv, 1.0);
  return downramp.mul(upramp);
}

Envelope BlackOut(int attack_time, float attack_curv) {
  int t=millis();
  return new Ramp(t, t+attack_time, 1.0, attack_curv, 0);
}
Envelope NoizeEnv() {
  Envelope perl = new Perlin(new Linear(0.1*0.0001), 0.01, new Linear(0.0001));
  return perl.add(-0.4).mul(10).sin01();
}

//Envelope Beats(Number total_time,float decay_curv){


// return  
//}
// WRITE FUNCTION THAT CRUSHES RATE OF ALL ENVELOPES

Envelope CrushPulse(float attack_proportion, float sustain_proportion, float decay_proportion, Number total_time, float attack_curv, float decay_curv) {
  if (attack_proportion<0) attack_proportion=0;
  if (sustain_proportion<0) sustain_proportion=0;
  if (decay_proportion<0) decay_proportion=0;
  float total_prop = attack_proportion+sustain_proportion+decay_proportion;
  float attack_time = attack_proportion/total_prop*total_time.floatValue();
  float sustain_time = sustain_proportion/total_prop*total_time.floatValue();
  float decay_time = decay_proportion/total_prop*total_time.floatValue();
  return SimplePulse(attack_time, sustain_time, decay_time, attack_curv, decay_curv);
}

Envelope envelopeFactory(int envelope_index, Rig rig) {
  switch (envelope_index) {
  case 0: 
    //return SimplePulse(cc[41]*4000, cc[42]*4000, cc[43]*4000, cc[44], cc[45]);
    return CrushPulse(cc[41], cc[42], cc[43], avgmillis*rig.beatSlider*5+0.5, cc[44], cc[45]);
  case 1:
      return CrushPulse(cc[46], cc[47], cc[48], avgmillis*rig.beatSlider*5+0.5, cc[49], cc[50]);

    //return SimplePulse(cc[50]*4000, cc[51]*4000, cc[52]*4000, cc[53], cc[54]);
  case 2:
    return SineBySine(cc[50], int(cc[51]*4000), cc[51], int(cc[52]*4000));
  case 3:
    //Envelope Squiggle(int attack_t, int sustain_t, int decay_t, float attack_curv, float decay_curv, float sqiggle_curv, float squiggliness) {
    return Squiggle(int(cc[49]*4000), int(cc[50]*4000), int(cc[51]*4000), cc[52], cc[53], cc[54], cc[55], int(cc[56]*200));
  case 4:
    return SlowFast(millis(), 3000, 100, 1000);
  default: 
    return SimplePulse(cc[41]*4000, cc[42]*4000, int(cc[42]*4000), cc[44], cc[45]);
  }
}

Envelope functionEnvelopeFactory(int envelope_index, Rig rig) {
  switch (envelope_index) {
  case 0: 
    return SimplePulse(int(cc[41]*6000), int(cc[42]*6000), int(cc[42]*6000), cc[44], cc[45]);
  case 1:
    return SimplePulse(int(cc[50]*6000), int(cc[51]*6000), int(cc[52]*6000), cc[53], cc[54]);
  case 2:
    return SineBySine(cc[50], int(cc[51]*4000), cc[51], int(cc[52]*4000));
  case 3:
    return SimplePulse(500, 100, 500, cc[1], cc[2]);
  case 4:
    return SlowFast(millis(), 3000, 100, 1000);
  default: 
    return SimplePulse(int(cc[41]*4000), int(cc[42]*4000), int(cc[42]*4000), cc[44], cc[45]);
  }
}

/*
class ADSR extends Envelope {
 int attack_time, sustain_time, decay_time;
 int sustain_func_index, envelope_index;
 int start_time;
 float attack_curve, decay_curve;
 Env_State state;
 boolean finished = false;
 
 ADSR(int _atime, int _stime, int _dtime, float _acurv, int _sfunc, float _dcurv) {
 start_time = now();
 attack_time = start_time + _atime;
 sustain_time = attack_time + _stime;
 decay_time = sustain_time + _dtime;
 end_time = decay_time;//new Envelope formulation
 attack_curve = _acurv;
 decay_curve = _dcurv;
 sustain_func_index = _sfunc;
 state = Env_State.ATTACK;
 }
 
 float curviness(float normalized_time, float curve) {
 //low values, like 0.1 give exponential sweep up
 // high values >1 approach a straight line
 if (normalized_time<=0) normalized_time = 0;
 if (normalized_time>=1) normalized_time = 1;
 return curve * exp(normalized_time*log((1+curve)/curve))-curve;
 }
 float inverse_curviness(float normalized_time, float curve) {
 return 1-curviness(1-normalized_time, curve);
 }
 float supercurviness(float normalized_time, float curve) {
 //curve from -1 to 1
 if (curve >= 1) curve = 0.999;
 if (curve <= -1) curve = -0.999;
 if (curve == 0) return normalized_time;
 if (curve < 0) return inverse_curviness(normalized_time, 1+curve);
 return curviness(normalized_time, 1-curve);
 }
 float value(int now) {
 float alpha=-1;
 float normalized_time = -1;
 switch (state) {
 case ATTACK: 
 if (now >= attack_time) state = Env_State.SUSTAIN;                               // is it possible to make this switch the case?!
 normalized_time = float(now - start_time)/float(attack_time-start_time);
 alpha = supercurviness(normalized_time, attack_curve);
 break;
 case SUSTAIN:
 if (now >= sustain_time) state = Env_State.DECAY;
 //if (sustain_time - now > 0) alpha = 0.4+(stutter*0.6);
 //else alpha = 1;
 break;
 case DECAY: 
 if (now >= decay_time) finished = true; //parent.deleteme=true;
 normalized_time = float(now - sustain_time)/float(decay_time-sustain_time);
 alpha = supercurviness(1-normalized_time, decay_curve);
 break;
 }
 return alpha;
 }
 }
 */
