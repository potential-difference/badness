import java.util.*;
import java.io.*;
import java.lang.*;
import java.lang.reflect.*;

HashMap<String, Class> classMap = new HashMap<String, Class>();
Class[] classList= this.getClass().getClasses();

ArrayList <Anim> animations;
String[] availableAnimsNames;

void setup() {
  size(200, 200);
  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER);

  println("ANIM NAMES:");
  for (int i=0; i<classList.length; i++) {
    if (classList[i].getSuperclass() == new Anim().getClass()) {
      String name = classList[i].getName();
      classMap.put(name.substring(name.indexOf('$')+1), classList[i]);
      println(name.substring(name.indexOf('$')+1));
    }
  }

  // print the results at beginning //
  println();
  println("CLASSMAP");
  println(classMap);
  println();
  println("CLASS LIST:");
  println(classList);
  println();
  println("*** END OF SETUP ***");
  println();

  animations = new ArrayList<Anim>();
  availableAnimsNames = new String[] {"Square", "Circle"};
}

void draw() {
  background(0);
  int animIndex = (frameCount / 120) % availableAnimsNames.length;  // switch animIndex every 120 frames

  addAnimations(keyPressed, animIndex);

  drawAnimations();
  removeAnimations();

  fill(300); 
  text("anims "+this.animations.size(), 0, 10);    // show number of anims onscreen
}
void addAnimations(boolean trigger, int animIndex) {
  if (trigger) {
    try {
      String name = classList[0].getName();
      String sketch_name = name.substring(0, name.indexOf('$'));

      for (int i=0; i<classList.length; i++) {
        if (classList[i].getSuperclass() == Class.forName(sketch_name+"$Anim")) {

          println("anim to be tirggered....", classMap.get(availableAnimsNames[animIndex]));

          //Anim anim = (Anim)classMap.get(availableAnimsNames[animIndex]).newInstance(); 
          Anim anim = (Anim)classList[animIndex].newInstance();
          //Anim anim = classList[animIndex];

          this.animations.add(anim);
        }
      }
    }    
    catch(Exception e) {
      e.printStackTrace();
    }
  }
}

void drawAnimations() {
  blendMode(LIGHTEST);
  for (int i = this.animations.size()-1; i >=0; i--) {
    Anim anim = this.animations.get(i);  
    anim.drawAnim();
  }
}

void removeAnimations() {
  Iterator<Anim> animiter = this.animations.iterator();
  while (animiter.hasNext()) {
    if (animiter.next().deleteme) animiter.remove();
  }
}
