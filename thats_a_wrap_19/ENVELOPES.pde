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

Envelope envelopeFactory(int envelope_index) {
  switch (envelope_index) {
  case 0: 
    return new ADSR(800, 0, 1500, 0.2, 0, 1);
  case 1:
    return new ADSR(1500, 1000, 200, 0.2, 0, 1);
  case 2:
    return new ADSR(1000, 0, 2000, -manualSlider, 0, -funcSlider);
  default: 
    return new ADSR( 200, 1000, 1500, 0.2, 0, 1);
  }
}

abstract class Envelope {
  int end_time;
  abstract float value(int time);
}

class ConstEnvelope extends Envelope {
  float val;
  ConstEnvelope(float val) {
    end_time=-1;
    this.val=val;
  }
  float now(int time) {
    return val;
  }
}

class AddEnvelope extends CompositeEnvelope {
  AddEnvelope(Envelope...e) {
    super(e);
  }
  float now(int time) {
    float res=0.0;
    for (Envelope c : children) {
      res+=c.now(time);
    }
    return res;
  }
}

class MulEnvelope extends CompositeEnvelope {
  MulEnvelope(Envelope...e) {
    super(e);
  }
  float now(int time) {
    float res=1.0;
    for (Envelope c : children) {
      res*=c.now(time);
    }
    return res;
  }
}

class Ramp extends Envelope {
  int start_time;
  ArrayList<Double> values;
  Ramp(int start_time, int end_time, Double...values) {
    this.start_time=start_time;
    this.end_time=end_time;
    this.values=Arrays.asList(values);
  }
  float fact(int a) {
    if (a<=1) return 1;
    return a * fact(a-1);
  }
  float binom(int a, int b) {
    //n!/(k!(n-k)!
    return float(fact(a)/(fact(b)*(fact(a-b))));
  }
  float now(int time) {
    /*nim code
     if (time<e.start_time): return e.points[0]
     if (time>e.end_time): return e.points[^1]
     let normt = float(time-e.start_time)/float(e.end_time-e.start_time)
     let n = e.points.len - 1
     for i,p in e.points.pairs:
     result += float(binom(n,i))*(1-normt)^(n-i)*normt^i*p
     */
    if (time<start_time) return values.get(0);
    if (time>end_time) return values.get(values.size()-1);//god arraylists are rubbish
    float normt = float(time-start_time)/float(end_time-start_time);
    int n = values.size()-1;
    float result=0.0;
    for (int i=0; i<values.size(); i++) {
      result += binom(n, i)*pow(1-normt, n-i)*pow(normt, i)*values.get(i);
    }
  }
}

//e.g. t=millis();Env_Sequence(Ramp(t,t+1000,{0.0,0.0,1.0}),Ramp(t+1500,t+2500,{1.0,1.0,0.0})
class SeqEnvelope extends CompositeEnvelope {
  SeqEnvelope(int start_time, Envelope...e) {
    end_time=0;
    //we add up the end_times
  }
}

abstract class CompositeEnvelope extends Envelope {
  ArrayList<Envelope> children;
  CompositeEnvelope(Envelope...e) {
    end_time=-1;
    children = Arrays.asList(e);
    for (Envelope e : children) {
      if (e.end_time>end_time) {
        end_time=e.end_time;
      }
    }
  }
  abstract float now();
}


class ADSR extends Envelope {

  int attack_time, sustain_time, decay_time;
  int sustain_func_index, envelope_index;
  int start_time;
  float attack_curve, decay_curve;
  Env_State state;
  boolean finished = false;
  int end_time;


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
  float value() {
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
