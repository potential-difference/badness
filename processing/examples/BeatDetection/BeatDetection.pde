import processing.sound.*;
AudioIn in;
BeatDetector beatDetector;

void setup() {
  size(400, 200);
  background(255);

  in = new AudioIn(this, 0);
  in.start();
  beatDetector = new BeatDetector(this);
  beatDetector.input(in);
  
  // The sensitivity determines how long the detector will wait after detecting
  // a beat to detect the next one.
  beatDetector.sensitivity(100);
}

void draw() {
  background(0);

  // Draw debug graph in the background
  drawDebug();

  // If a beat is currently detected, light up the indicator
  if (beatDetector.isBeat()) {
    fill(255);
  } else {
    fill(0);
  }
  
  stroke(255);
  strokeWeight(1);
  rect(20, 20, 15, 15);
  
  fill(255);
  textAlign(LEFT, TOP);
  text("BEAT DETECTED", 40, 20);
}

void drawDebug() {
  stroke(255);
  strokeWeight(2);  
  double[] energyBuffer = beatDetector.getEnergyBuffer();
  int cursor = beatDetector.getEnergyCursor();
  float last = (float) energyBuffer[cursor] / 100 * height;
  float spacing = (float) width / (energyBuffer.length - 1);
  for (int j = 1; j < energyBuffer.length; j++) {
    int index = (j + cursor) % energyBuffer.length;    
    float energy = (float) energyBuffer[index] / 100 * height;
    line((j - 1) * spacing, height - last * 1, j * spacing, height - energy);
    last = energy;
  }

  boolean[] beatBuffer = beatDetector.getBeatBuffer();
  for (int j = 1; j < beatBuffer.length; j++) {
    int index = (j + cursor) % energyBuffer.length;
    boolean beat = beatBuffer[index];
    if (beat) {
      stroke(255, 255, 0);
      line(j * spacing, 0, j * spacing, height);
    }
  }
}
