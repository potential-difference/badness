public class Anim {
  float alphaA, alphaB, functionA, functionB;
  boolean deleteme=false;
  int timestarted;
  float stroke, wide, high, rotate;

 public Anim() {
    alphaA = 1;
    alphaB = 0;
    functionA = 1;
    functionB = 1;
    timestarted = millis();
  }

  void draw() {
  }

  void drawAnim() {
    alphaA *=0.95;
    alphaB = 1-alphaA;
    functionA *=0.97;
    functionB *=0.8;
    int now = millis();
    if ( now - timestarted > 3000) deleteme = true;
    if (alphaA < 0.01) deleteme = true;
    this.draw();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public class Square extends Anim {
  public Square() {
    super();
  }
  void draw() {
    wide = width*(functionB);
    high = height*(functionB);

    fill(360*alphaB);
    rect(width/2, height/2, wide, high);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public class Circle extends Anim {
 public Circle() {            
    super();
  }
  void draw() {
    wide = width*(functionA);
    high = height*(functionA);

    fill(360*alphaA);
    ellipse(width/2, height/2, wide, high);
  }
}
