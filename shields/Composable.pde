//////////////////////////////////////////////////////////////////
//////////////Composition interface /////////////////////////////
interface Composable {
  float get();
}
interface Operator {
  float operate(int time,Object...o);
}

class Mul implements Operator {
  float operate(int time,Object...o){
    float prod=1.0;
    for(int i=0;i<o.length;i++){
      prod *= floatValue(o[i],time);
    }
    return prod;
  }
}
class Add implements Operator{
  float operate(int time,Object...o){
    float sum=0.0;
    for (int i=0;i<o.length;i++){
      sum += floatValue(o[i],time);
    }
    return sum;
  }
}
class Inv implements Operator{
  float operate(int time,Object...o){
    return 1.0/floatValue(o[0],time);
  }
}
class Sin01 implements Operator{
  float operate(int time, Object...o){
    return 0.5*(1+sin(floatValue(o[0],time)));
  }
}
///////////////////////helper functions//////////////////////////////
float floatValue(Object o){
  if (o instanceof Number) return ((Number)o).floatValue();
  if (o instanceof Composable) return ((Composable)o).get();
  throw new RuntimeException("floatValue expected Number,Composable, got "+o.getClass().getCanonicalName());
}
float floatValue(Object o,Number time){
  if (o instanceof Envelope) return ((Envelope)o).value(time.intValue());
  return floatValue(o);
}

/////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////Reference Class///////////////////////////////////////

class Ref implements Composable{
  float[] f;
  int i;
  Ref(){
    f=new float[]{1.0};
    i=0;
  }
  Ref(float[] ff,int ii){
    f=ff;
    i=ii;
  }
  Ref(float[] ff){
    f=ff;
    i=0;
  }
  float get(){
    if (f == null) return 1.0;
    if (i<0 || i>f.length) return 1.0;//should raise exception,really
    return f[i];
  }
  Ref add(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeRef(new Add(),out);
  }
  Ref mul(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeRef(new Mul(),out);
  }
  Ref inv(){
    return new CompositeRef(new Inv(),this);
  }
}

class CompositeRef extends Ref{
  Operator op;
  Object[] children;
  CompositeRef(Operator op,Object...o){
    this.op=op;
    this.children=o;
  }
  float get(){
    return op.operate(millis(),children);
  }
}


///////////////////////////////////////////////////////////////////
////////////////Envelope class/////////////////////////////////////

abstract class Envelope implements Composable{
  int end_time;
  abstract float value(int time);
  float get(){
    return value(millis());
  }
  Envelope add(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeEnvelope(new Add(),out);
  }
  Envelope mul(Object...o){
    Object[] out = Arrays.copyOf(o,o.length+1);
    out[o.length]=this;
    return new CompositeEnvelope(new Mul(),out);
  }
  Envelope inv(){
    return new CompositeEnvelope(new Inv(),this);
  }
  Envelope sin01(){
    return new CompositeEnvelope(new Sin01(),this);
  }
}
interface Env{
  abstract float value(int time);
}
class LambdaEnv extends Envelope{
  Env env;
  LambdaEnv(Env e){
    env = e;
  }
  float value(int time){
    return env.value(time);
  }
}

class CompositeEnvelope extends Envelope{
  Operator op;
  Object[] children;
  CompositeEnvelope(Operator op,Object...o){
    this.op=op;
    children=o;
    //Envelopes need to keep track of endtimes so Anim knows when they're over
    //we just take the last one
    //infinite envelopes like Sine will have a 0 end_time;
    end_time=-1;
    for(int i=0;i<o.length;i++){
      if (o[i] instanceof Envelope) {
        if (((Envelope)o[i]).end_time > end_time) end_time=((Envelope)o[i]).end_time;
      }
    }
  }
  float value(int time){
    return op.operate(time,children);
  }
}

//////////////////////////////////////////////////////////
///////////////////interesting stuff below////////////////

// goes from 0 to AMPLITUDE and BACK to 0 over number of MILLIS for cycle
class Sine extends Envelope {
  Object amplitude,period;
  Sine(Object amplitude,Object period){
    this.amplitude=amplitude;
    this.period=period;
  }
  float value(int time){
    float amp = floatValue(amplitude,time);
    float prd = floatValue(period,time);
    return amp*0.5*(1+sin(TWO_PI * time / prd));//sinwave from 0 to amplitude
  }
}
class Perlin extends Envelope{
  Object xScale,yScale,zScale;
  Perlin(Object xScale, Object yScale, Object zScale){
    this.xScale=xScale;
    this.yScale=yScale;
    this.zScale=zScale;
  }
  float value(int time){
    return noise(floatValue(xScale,time), floatValue(yScale,time), floatValue(zScale,time));
  }
}
class Linear extends Envelope{
  Object Scale;
  Linear(Object Scale){
    this.Scale=Scale;
    
  }
  float value(int time){
    return floatValue(Scale,time)*(float)time;
  }
}

class Ramp extends Envelope {
  int start_time;
  Object[] values;
  Ramp(Number start_time, Number end_time, Object...values) {
    this.start_time=start_time.intValue();
    this.end_time=end_time.intValue();
    this.values=values;
    //assert(values.length>0);
  }
  float fact(int a) {
    if (a<=1) return 1.0;
    return a * fact(a-1);
  }
  float binom(int a, int b) {
    //n!/(k!(n-k)!
    return fact(a)/(fact(b)*(fact(a-b)));
  }

  float value(int time) {
    /*nim code
     if (time<e.start_time): return e.points[0]
     if (time>e.end_time): return e.points[^1]
     let normt = float(time-e.start_time)/float(e.end_time-e.start_time)
     let n = e.points.len - 1
     for i,p in e.points.pairs:
     result += float(binom(n,i))*(1-normt)^(n-i)*normt^i*p
     */
    if (time<start_time) return floatValue(values[0]);
    if (time>end_time) return floatValue(values[values.length-1]);
    float normt = float(time-start_time)/float(end_time-start_time);
    int n = values.length-1;
    float result=0.0;
    for (int i=0; i<values.length; i++) {
      result += binom(n, i)*pow(1-normt, n-i)*pow(normt, i)*floatValue(values[i]);
    }
    return result;
  }
}
