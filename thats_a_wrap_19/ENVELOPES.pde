////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Envelope SimplePulse(int attack_time,int sustain_time,int decay_time,float attack_curv,float decay_curv){
  int t=millis();
  Envelope upramp = new Ramp(t,t+attack_time,0.0,0.5*(1+attack_curv),1.0);
  Envelope dwnrmp = new Ramp(t+attack_time+sustain_time,t+attack_time+sustain_time+decay_time,1.0,0.5*(1+decay_curv),0.0);
  return upramp.mul(dwnrmp);
}
Envelope SlowFast(int start_time,int duration,int start_period,int end_period){
  now=start_time;
  Envelope period = new Ramp(now,now+duration,start_period,end_period);
  return new Sine(1.0,period);
}
Envelope ADSR(int attack_t,int sustain_t,int decay_t,float attack_curv,float decay_curv){
  Envelope base = SimplePulse(attack_t,sustain_t,decay_t,attack_curv,decay_curv);
  int sin_start=millis()+attack_t;
  int sin_duration=sustain_t;
  int start_period=sin_duration;
  int end_period = sin_duration/20;
  Envelope squiggle = SlowFast(sin_start,sin_duration,start_period,end_period).mul(0.6).add(0.4);
  return base.mul(squiggle);
}

Envelope envelopeFactory(int envelope_index, Rig rig) {
  switch (envelope_index) {
  case 0: 
    return ADSR(800, 100, 1500, 0.2, 1);
  case 1:
    return ADSR(1500, 1000, 2000, 0.2, 1);
  case 2:
    return ADSR(1000, 0, 2000, -rig.alphaRate, -rig.funcRate);
  default: 
    return ADSR(1000, 0, 1000, 0.2, 0.2); // envelopeFactory(rig.alphaIndexA, rig);
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
