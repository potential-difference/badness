int ENV_FRAMES = 0;
int ENV_MILLIS = 1;
int ENV_TICK = ENV_MILLIS;
enum Env_State {
  ATTACK, SUSTAIN, DECAY
}

int now() {
  if (ENV_TICK == ENV_FRAMES) {
    return frameCount;
  } else {
    return millis();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class EnvelopeFactory {
  int envelope_index;
  Anim parent;         // remove??
  Envelope envelope;

  EnvelopeFactory(Anim _parent, int _envelope_index) {
    envelope_index = _envelope_index;
    parent = _parent;
    switch (envelope_index) {
    case 0: 
      envelope = new Envelope(parent, 800, 0, 1500, 0.2, 0, 1);
      break;
    case 1:
      envelope = new Envelope(parent, 1500, 1000, 200, 0.2, 0, 1);
      break;
    case 2:
      envelope = new Envelope(parent, 1000, 0, 2000, -manualSlider, 0, -funcSlider);
      break;
    default: 
      envelope = new Envelope(parent, 200, 1000, 1500, 0.2, 0, 1);
    }
  }
}

class Envelope {
  int attack_time, sustain_time, decay_time;
  int sustain_func_index, envelope_index;
  int start_time;
  float attack_curve, decay_curve;
  Anim parent;
  Env_State state;
  boolean finished = false;

  Envelope(Anim _parent, int _atime, int _stime, int _dtime, float _acurv, int _sfunc, float _dcurv) {
    start_time = now();
    attack_time = start_time + _atime;
    sustain_time = attack_time + _stime;
    decay_time = sustain_time + _dtime;
    attack_curve = _acurv;
    decay_curve = _dcurv;
    sustain_func_index = _sfunc;
    parent = _parent;
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
    if (curve >= 1) curve = 0.999999;
    if (curve <= -1) curve = -0.999999;
    if (curve == 0) return normalized_time;
    if (curve < 0) return inverse_curviness(normalized_time, 1+curve);
    return curviness(normalized_time, 1-curve);
  }
  float current_alpha() {
    int now=now();
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
      if (sustain_time - now > 0) alpha = 0.4+(stutter*0.6);
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
  
   float current_function() {
    int now=now();
    float function=-1;
    float normalized_time = -1;
    switch (state) {
    case ATTACK: 
      if (now >= attack_time) state = Env_State.SUSTAIN;                               // is it possible to make this switch the case?!
      normalized_time = float(now - start_time)/float(attack_time-start_time);
      function = supercurviness(normalized_time, attack_curve);
      break;
    case SUSTAIN:
      if (now >= sustain_time) state = Env_State.DECAY;
      if (sustain_time - now > 0) function = 1; //0.9+(stutter*0.1);
      //else function = 1;
      break;
    case DECAY: 
      if (now >= decay_time) finished = true; //parent.deleteme=true;
      normalized_time = float(now - sustain_time)/float(decay_time-sustain_time);
      function = supercurviness(1-normalized_time, decay_curve);
      break;
    }
    return function;
  }
}
/*
class EnvelopeFactory {
 int attack_time;
 int decay_time;
 int sustain_time;
 float attack_curv;
 int sustain_func_idx;
 float decay_curv;
 
 EnvelopeFactory(int at, int st, int dt, float ac, int sf, float dc) {
 attack_time=at;
 decay_time=dt;
 }
 
 Envelope newEnvelope(int envelope_index) {
 switch (envelope_index) {
 case 0: 
 return new Envelope(parent, 800, 1000, 1500, 0.2, 0, 1);
 case 1:
 return new Envelope(parent, 1500, 1000, 200, 0.2, 0, 1);
 default: 
 return new Envelope(parent, attack_time, sustain_time, decay_time, attack_curve, sustain_func_index, decay_curve);
 }
 }
 
 }
 */
/*
  Envelope newEnvelope(int overallTime){
 float attack_percent=0.2;
 float sustain_percent=0.7;
 float decay_percent=0.1;
 return new Envelope(int(overallTime*attack_percent),int(overallTime*sustain_percent),int(overallTime*decay_percent),0,0.0);
 }
 */



/*
//list of useful envelopes:
 class EnvelopeFactory {
 int attack_time;
 int decay_time;
 int sustain_time;
 float attack_curv;
 int sustain_func_idx;
 float decay_curv;
 
 EnvelopeFactory(int at, int st, int dt, float ac, int sf, float dc) {
 attack_time=at;
 decay_time=dt;
 sustain....etc.
 }
 
 }
 */
/* or...
 Envelope newEnvelope(int envelopeIndex){
 switch (envelope In                        
 }
 
 
 */
/*

 
 
 
 enum EnvelopeNames {
 FASTUP,SLOWDOWN,TURNAROUNDANDSLAPME }
 EnvelopeFactory[] envelopesByName = {
 new EnvelopeFactory(500,2000,0.5,3.0.8),//FASTUP
 new EnvelopeFactory(2000,300,35,......),//SLOWDOWN
 ,//TURNAROUNDANDSLAPME
 }
 */

/*
HashMap<String,EnvelopeFactory> envelopeNames = {
 "fastup":new EnvelopeFactory(500,2000,3000,0.5,3,0.8),
 "slowdown":new EnvelopeFactory(2000,300,35,-0.7,2,-0.1),
 ...
 }
 }
 */
/*

 
 animations.add(new Anim11(blah blah blah,rigg.envelopFactory.newEnvelope());
 animations.add(new Anim11(blah blah blah,envelopesByName[6].newEnvelope());
 animations.add(new Anim11(blah blah blah,envelopesByName[FASTUP].newEnvelope());
 
 env = new Envelope(blay blay blarg);
 env = envelopeFactory.newEnvelope(6);
 env = envelopeFactory.newEnvelope(FASTUP);
 env = envelopeFactory.newEnvelope(rigg.envelope_index);
 env = envelopeFactory.newEnvelope(random(envelopeFactory.length));
 animations.add(new Anim11(blah blah blah,env);
 
 */
