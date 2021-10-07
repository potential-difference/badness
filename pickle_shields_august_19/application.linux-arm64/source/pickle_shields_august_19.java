import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import themidibus.*; 
import java.net.*; 
import java.util.Arrays; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import javax.sound.sampled.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pickle_shields_august_19 extends PApplet {

OPC opc;
OPC opcWifi;


 //Import the midi library
MidiBus myBus; // The MidiBus
float cc[] = new float[128];   //// An array where to store the last value received for each knob
int time[] = new int[12]; // array of timers to use throughout the sketch
int w, h, ww, hh, mx, my, mh, mw, rx, ry, rw, rh, iw, ih, ix, iy, sh; // size variables
int surfacePositionX = 780, surfacePositionY = 600;

PShader maskShader;
PGraphics maskImage, maskedImage;
PVector[] DMXpar = new PVector[6];

PFont myFont;


public void settings() {
  mw = 400;          // WIDTH of rigViz
  mh = 400;          // HEIGHT of rigViz
  mx = mw/2;          // X coordiante for center of rigViz 
  my = mh/2;        // Y coordiante for center of rigViz

  rw = 400;          // WIDTH of roofViz
  rh = mh;          // HEIGHT of roofViz
  rx = mw+(rw/2);    // X coordiante for center of roofViz
  ry = rh/2;           // Y coordiante for center of roofViz

  sh = 70;         // height of slider area at bottom of sketch window

  iw = 300;          // WIDTH of info area
  ih = mh+sh;          // HEIGHT of info area
  ix = mw+rw+(iw/2); // X coordiante for center of infoArea
  iy = ih/2;

  size(mw+rw+iw, sh+mh, P2D);
  w = width;
  h = height;
  ww = w >> 1;  // half of width
  hh = h >> 1;  // half of height
}

public void setup()
{
  /// size moved to settings - see above
  surface.setAlwaysOnTop(true);
  surface.setLocation(surfacePositionX, surfacePositionY);

  audioSetup(100); ///// AUDIO SETUP - sensitivity /////

  opc = new OPC(this, "127.0.0.1", 7890);   // Connect to the local instance of fcserver
  ///////////////// OPC over WIFI - uncomment below /////////////////////
  //opcWifi = new OPC(this, "sputnik.local", 7890);   // Connect to the wifi instance of fcserver

  float medRingSize = mw/8;        ///// SIZE OF RING BIG SHIELDS ARE POSITION ON
  float smallRingSize = mw/5;    ///// SIZE OF RING SMALL SHIELDS ARE POSITION ON
  float ballRingSize = mw/4;         ///// SIZE OF RING BALLS ARE POSITIONED ON
  shieldRingSetup(mx, my, 6, 9, medRingSize, smallRingSize, ballRingSize);    ////// SETUP RING SIZE FOR SHIELD POSITION, number of postitions on ring //////
  SpiralShieldGrid();
  boothLights(w-35, 115);
  //NYEcans();
  PickledCans();
  pickleDMXBattonsGrid();

  //int pd = 5;
  //int leds = 23;

  //opc.ledStrip(0, 23, mx, my+(leds/2*pd+(pd/2)), pd, 0, false);
  //opc.ledStrip(leds, 23, mx+(leds/2*pd+(pd/2)), my, pd, PI/2, true);

  //opc.ledStrip(64, 23, mx-(leds/2*pd+(pd/2)), my, pd, PI/2, true);
  //opc.ledStrip(64+leds, 23, mx, my-(leds/2*pd+(pd/2)), pd, 0, false);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  println();
  myBus = new MidiBus(this, 0, 1);      /// PAD 1

  dimmer = 1; // must come before load control frame
  cf = new ControlFrame(this, w, 130, "Controls"); // load control frame must come after shild ring etc

  drawingSetup();
  loadImages();
  loadGraphics();
  colorSetup();
  colorArray();

  // loadSliders();
  blur = loadShader("blur.glsl");
  loadShaders(10);

  maskShader = loadShader("mask.glsl");
  maskShader.set("mask", rigWindow);
  maskImage = createGraphics(mw, mh, P2D);
  maskImage.noSmooth();
  maskImage.imageMode(CENTER);

  maskedImage = createGraphics(mw, mh, P2D);
  maskedImage.noSmooth();
  maskedImage.imageMode(CENTER);

  visualisation = 4;
  visualisation1 = 1;
  rigBgr = 1;    
  co = 1;    // set c start
  co1 = 2;   // set flash start
  for (int i = 0; i < cc.length; i++) cc[i]=0;   // set all midi values to 0;
  for (int i = 0; i < 9; i++) cc[i] = 1;         // set all knobs to 1 ready for shit happen
  //keyT[107] = true; // turn shimmer on from start
  //hint(DISABLE_OPTIMIZED_STROKE);
  cc[1] = 0.75f;
  cc[6] = 0.75f;
  cc[8] = 0;

  frameRate(30);
}
float vizTime, colTime;
int roofViz, rigViz, colStepper = 1;

public void draw()
{
  background(0);
  noStroke();
  beatDetect.detect(in.mix);
  beats();
  pause(10);                        ////// number of seconds before no music detected
  noize();
  oskPulse();
  arrayDraw();
  clash(func);                         ///// clash colour changes on function in brackets

  ////// adjust blur amount using slider only when slider is changed - cheers Benjamin!! ////////
  blury = PApplet.parseInt(map(blurSlider, 0, 1, 0, 20));
  if (blury!=prevblury) {
    prevblury=blury;
    loadShaders(blury);
  }

  //if (keyT[97]) colStepper = 2;
  //else colStepper = 1;
  colTime = colorTimerSlider*60*30;
  colorTimer(colTime, 1); //// seconds between colour change, number of steps to cycle through colours

  //dimmer = cc[4]*rigDimmer;
  vizTime = 60*15*vizTimeSlider;
  playWithYourself(vizTime); 
  playWithMe();

  //for (int i = 0; i< 11; i++) vizSelection(vizPreview[i], i, cc[4]*rigDimmer);                     // loop to iniciate all viz at once

  vizSelection(vizPreview[visualisation], visualisation, cc[4]*rigDimmer);                           // develop one visulisation
  //if (secondVizSlider > 0) vizSelection(vizPreview[visualisation1], visualisation1, cc[8]*secondVizSlider);    // develop 2nd visulisation
  //visualisation2 = (visualisation1+1)%11;
  //if (roofDimmer > 0) vizSelection(vizPreview[visualisation2], visualisation2, roofDimmer);    // develop 2nd visulisation


  if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;                // change colour layer automatically
  colorLayer(rigColourLayer, rigBgr);                                // develop colour layer
  rigWindow.beginDraw();
  rigWindow.background(0);
  rigWindow.blendMode(NORMAL);
  if (secondVizSlider>0 && cc[8] > 0) {  
    rigWindow.blendMode(BLEND);                                                   // changing this blend mode produces really interesting results - would be great on a drop down box
    rigWindow.image(vizPreview[visualisation1], mx, my);                        // draw secondVIZ to RIG WINDOW blending with colour layer
  }
  rigWindow.image(vizPreview[visualisation], mx, my);                           // draw VIZ to RIG WINDOW blending with colour layer
  rigWindow.endDraw();





  image(rigWindow, mx, my);
  blendMode(MULTIPLY);
  image(rigColourLayer, mx, my, mw, mh);                        // draw rig colour layer to rig window
  blendMode(NORMAL);


  colorLayer(roofColourLayer, roofBgr);  
  roofWindow.beginDraw();
  roofWindow.background(0);
  roofWindow.blendMode(NORMAL);
  roofWindow.image(vizPreview[visualisation2], rx, ry);                           // draw VIZ to RIG WINDOW blending with colour layer
  roofWindow.endDraw();

  //toggle roof viz with tilda key '~' 
  if (keyT[96]) {
    image(roofWindow, rx, ry, rw, rh);                 // draw VIZ to ROOF WINDOW blending with colour layer
    blendMode(MULTIPLY);
    image(roofColourLayer, rx, ry, rw, rh);                      // draw roof colour layer to roog window
    blendMode(NORMAL);
  }

  // code to develop and then draw preview boxes 
  if (frameCount<12)visualisation = (visualisation+1)%11; // quick n dirty loop to render all previews at startup
  colorPreview(infoWindow);
  vizPreview(infoWindow);
  image(infoWindow, ix, iy);



  //****************************************************************************************//
  ///////////////////  *** TESTING THIS OUT - KEY A activates multiviz layers *** ///////////////
  //playWithMany();   ////////// MULTIVIZ SLIDERS TURN ON OTHER VIZ ACTIVE
  /////////////// change color of multiviz layer ///////////
  //c = col[(co+1)% (col.length-1)]; 
  //flash = col[(co1+1)% (col.length-1)]; 
  //colorLayer();    ///////// WAS BACKGROUNDS AT BOTTOM OF PLAYWITHYOUSELF
  //****************************************************************************************//

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// CANS SHIT ///////////////////////////////////////////////////////////////////////////////
  canWidth = 220;
  noStroke();
  blendMode(NORMAL);
  if (rigDimmer > 0 ) {
    if (visualisation>0) {
      if (beat < 0.3f) {
        fill(flash, ((0.6f*pulz)+(0.3f*noize1)+(0.05f*pulz*stutter))*360*bgDimmer);
        rect(canX, canY+1, canWidth, 6);
      }
    } else { 
      fill(flash, ((0.6f*pulz)+(0.3f*noize1)+(0.05f*pulz*stutter))*360*bgDimmer);
      rect(canX, canY+1, canWidth, 6);
    }

    //if (visualisation>0) {
    //  if (beatCounter % 6 == 1) {
    //    fill(clash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
    //    rect(canX, canY+1, canWidth, 6);
    //  }
    //}
  }
  blendMode(MULTIPLY);
  fill(0, 360-(360*bgDimmer));
  rect(canX, canY, canWidth, 3);
  blendMode(NORMAL);

  if (cc[106] > 0) {   
    //if (keyP[57]) {
    //for (int i=0; i<4; i++) alpha1[i] = (alpha1[i]*cc[7]/2)+(stutter*cc[7]);
    //fill(flash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
    fill(clash1, (360)*cc[6]);
    rect(canX, canY+1, canWidth, 6);
    println("BG ON SHIMMERY * knob 7");
  }

  if (cc[107] > 0) {   
    //if (keyP[57]) {
    //for (int i=0; i<4; i++) alpha1[i] = (alpha1[i]*cc[7]/2)+(stutter*cc[7]);
    //fill(flash, ((0.6*pulz)+(0.3*noize1)+(0.05*pulz*stutter))*360*bgDimmer);
    fill(clash, (240+(120*stutter))*cc[7]);
    rect(canX, canY+1, canWidth, 6);
    println("BG ON SHIMMERY * knob 7");
  }

  /// background on a bit when key A pressed
  if (keyT[97]) {
    fill(c, (240+(120*noize*beat))*cc[7]);
    rect(canX, canY+1, canWidth, 6);
  }




  ///////////////////////////////////////////////////////////////////////
  /////////////////////////////////// BOOTH LIGHTS //////////////////////////////////
  fill(0);
  rect(boothX+10, boothY, 30, 10);
  fill(flash1, 360*boothDimmer);
  rect(boothX+10, boothY, 30, 10);

  ///////////////////////// DIGGING LIGHTS /////////////////
  fill(0, 360-(360*digDimmer));
  rect(boothX+10, boothY+30, 30, 10);
  fill(c1, 360*digDimmer);
  rect(boothX+10, boothY+30, 30, 10);

  //////////////////////////////// DMX ROOF SHIZ /////////////////////////
  //////////////// ROOF RUSH BANG BUTTON ///////////////
  //if (cc][[][107] > 0) roofRush();
  ///////////////// ROOF STOBE BANG BUTTON ///////////////
  //if (cc[104] > 0 || keyP[43]) roofStrobe();

  /////////////////// TEST ALL COLOURS - TURN ALL LEDS ON AND CYCLE COLOURS ////////////////////////////////
  if (test) {
    fill((millis()/50)%360, 100, 100);
    rect(mx, my, w, h);
  }
  /////////////////// WORK LIGHTS - ALL ON WHITE SO YOU CAN SEE SHIT ///////////////////////////
  if (work) {
    fill(360);
    rect(ww, hh, w, h);
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  onScreenInfo();                ///// display info about current settings, viz, funcs, alphs etc
  colorInfo();                   ///// rects to show current color and next colour
  frameRateInfo(5, 20);          ///// display frame rate X, Y /////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fill(flash);
  rect(mw, hh, 1, h);           ///// vertical line to show end of rig viz area
  rect(mw+rw, hh, 1, h);        ///// vertical line to show end of roof viz area
  fill(flash, 80);    
  rect((mw+rw)/2, h-sh, mw+rw, 1);            ///// horizontal line to show bottom area

  // DMX CONTROL PIXELS
  fill(360);
  rect(w-2, 2, 4, 4);
  fill(0);
  rect(2, 2, 6, 6);
} 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// THE END //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 * Simple Open Pixel Control client for Processing,
 * designed to sample each LED's color from some point on the canvas.
 *
 * Micah Elizabeth Scott, 2013
 * This file is released into the public domain.
 */




public class OPC implements Runnable
{
  Thread thread;
  Socket socket;
  OutputStream output, pending;
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;

  OPC(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    thread = new Thread(this);
    thread.start();
    this.enableShowLocations = true;
    parent.registerMethod("draw", this);

  }

  // Set the location of a single LED
  public void led(int index, int x, int y)  
  {
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }
  
  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip.
  public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0f) * spacing * c + 0.5f),
        (int)(y + (i - (count-1)/2.0f) * spacing * s + 0.5f));
    }
  }

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
  public void ledRing(int index, int count, float x, float y, float radius, float angle)
  {
    for (int i = 0; i < count; i++) {
      float a = angle + i * 2 * PI / count;
      led(index + i, (int)(x - radius * cos(a) + 0.5f),
        (int)(y - radius * sin(a) + 0.5f));
    }
  }

  // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  public void ledGrid(int index, int stripLength, int numStrips, float x, float y,
               float ledSpacing, float stripSpacing, float angle, boolean zigzag)
  {
    float s = sin(angle + HALF_PI);
    float c = cos(angle + HALF_PI);
    for (int i = 0; i < numStrips; i++) {
      ledStrip(index + stripLength * i, stripLength,
        x + (i - (numStrips-1)/2.0f) * stripSpacing * c,
        y + (i - (numStrips-1)/2.0f) * stripSpacing * s, ledSpacing,
        angle, zigzag && (i % 2) == 1);
    }
  }

  // Set the location of 64 LEDs arranged in a uniform 8x8 grid.
  // (x,y) is the center of the grid.
  public void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag)
  {
    ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag);
  }

  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  public void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }
  
  // Enable or disable dithering. Dithering avoids the "stair-stepping" artifact and increases color
  // resolution by quickly jittering between adjacent 8-bit brightness levels about 400 times a second.
  // Dithering is on by default.
  public void setDithering(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x01;
    else
      firmwareConfig |= 0x01;
    sendFirmwareConfigPacket();
  }

  // Enable or disable frame interpolation. Interpolation automatically blends between consecutive frames
  // in hardware, and it does so with 16-bit per channel resolution. Combined with dithering, this helps make
  // fades very smooth. Interpolation is on by default.
  public void setInterpolation(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x02;
    else
      firmwareConfig |= 0x02;
    sendFirmwareConfigPacket();
  }

  // Put the Fadecandy onboard LED under automatic control. It blinks any time the firmware processes a packet.
  // This is the default configuration for the LED.
  public void statusLedAuto()
  {
    firmwareConfig &= 0x0C;
    sendFirmwareConfigPacket();
  }    

  // Manually turn the Fadecandy onboard LED on or off. This disables automatic LED control.
  public void setStatusLed(boolean on)
  {
    firmwareConfig |= 0x04;   // Manual LED control
    if (on)
      firmwareConfig |= 0x08;
    else
      firmwareConfig &= ~0x08;
    sendFirmwareConfigPacket();
  } 

  // Set the color correction parameters
  public void setColorCorrection(float gamma, float red, float green, float blue)
  {
    colorCorrection = "{ \"gamma\": " + gamma + ", \"whitepoint\": [" + red + "," + green + "," + blue + "]}";
    sendColorCorrectionPacket();
  }
  
  // Set custom color correction parameters from a string
  public void setColorCorrection(String s)
  {
    colorCorrection = s;
    sendColorCorrectionPacket();
  }

  // Send a packet with the current firmware configuration settings
  public void sendFirmwareConfigPacket()
  {
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }
 
    byte[] packet = new byte[9];
    packet[0] = 0;          // Channel (reserved)
    packet[1] = (byte)0xFF; // Command (System Exclusive)
    packet[2] = 0;          // Length high byte
    packet[3] = 5;          // Length low byte
    packet[4] = 0x00;       // System ID high byte
    packet[5] = 0x01;       // System ID low byte
    packet[6] = 0x00;       // Command ID high byte
    packet[7] = 0x02;       // Command ID low byte
    packet[8] = firmwareConfig;

    try {
      pending.write(packet);
    } catch (Exception e) {
      dispose();
    }
  }

  // Send a packet with the current color correction settings
  public void sendColorCorrectionPacket()
  {
    if (colorCorrection == null) {
      // No color correction defined
      return;
    }
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }

    byte[] content = colorCorrection.getBytes();
    int packetLen = content.length + 4;
    byte[] header = new byte[8];
    header[0] = 0;          // Channel (reserved)
    header[1] = (byte)0xFF; // Command (System Exclusive)
    header[2] = (byte)(packetLen >> 8);
    header[3] = (byte)(packetLen & 0xFF);
    header[4] = 0x00;       // System ID high byte
    header[5] = 0x01;       // System ID low byte
    header[6] = 0x00;       // Command ID high byte
    header[7] = 0x01;       // Command ID low byte

    try {
      pending.write(header);
      pending.write(content);
    } catch (Exception e) {
      dispose();
    }
  }

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  public void draw()
  {
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }
    if (output == null) {
      return;
    }

    int numPixels = pixelLocations.length;
    int ledAddress = 4;

    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];

      packetData[ledAddress] = (byte)(pixel >> 16);
      packetData[ledAddress + 1] = (byte)(pixel >> 8);
      packetData[ledAddress + 2] = (byte)pixel;
      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
  }
  
  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  public void setPixelCount(int numPixels)
  {
    int numBytes = 3 * numPixels;
    int packetLen = 4 + numBytes;
    if (packetData == null || packetData.length != packetLen) {
      // Set up our packet buffer
      packetData = new byte[packetLen];
      packetData[0] = 0;  // Channel
      packetData[1] = 0;  // Command (Set pixel colors)
      packetData[2] = (byte)(numBytes >> 8);
      packetData[3] = (byte)(numBytes & 0xFF);
    }
  }
  
  // Directly manipulate a pixel in the output buffer. This isn't needed
  // for pixels that are mapped to the screen.
  public void setPixel(int number, int c)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = (byte) (c >> 16);
    packetData[offset + 1] = (byte) (c >> 8);
    packetData[offset + 2] = (byte) c;
  }
  
  // Read a pixel from the output buffer. If the pixel was mapped to the display,
  // this returns the value we captured on the previous frame.
  public int getPixel(int number)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      return 0;
    }
    return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
  }

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  public void writePixels()
  {
    if (packetData == null || packetData.length == 0) {
      // No pixel buffer
      return;
    }
    if (output == null) {
      return;
    }

    try {
      output.write(packetData);
    } catch (Exception e) {
      dispose();
    }
  }

  public void dispose()
  {
    // Destroy the socket. Called internally when we've disconnected.
    // (Thread continues to run)
    if (output != null) {
      println("Disconnected from OPC server", host);
    }
    socket = null;
    output = pending = null;
  }

  public void run()
  {
    // Thread tests server connection periodically, attempts reconnection.
    // Important for OPC arrays; faster startup, client continues
    // to run smoothly when mobile servers go in and out of range.
    for(;;) {

      if(output == null) { // No OPC connection?
        try {              // Make one!
          socket = new Socket(host, port);
          socket.setTcpNoDelay(true);
          pending = socket.getOutputStream(); // Avoid race condition...
          println("Connected to OPC server", host);
          sendColorCorrectionPacket();        // These write to 'pending'
          sendFirmwareConfigPacket();         // rather than 'output' before
          output = pending;                   // rest of code given access.
          // pending not set null, more config packets are OK!
        } catch (ConnectException e) {
          dispose();
        } catch (IOException e) {
          dispose();
        }
      }

      // Pause thread to avoid massive CPU load
      try {
        thread.sleep(500);
      }
      catch(InterruptedException e) {
      }
    }
  }
}
public void SpiralShieldGrid() {
  //smallShield(0, 8, 48); ///// SLOT b0 on BOX /////
  medShield(1, 0, 33);   ///// SLOT b1 on BOX ///// 
  smallShield(2, 2, 48); ///// SLOT b2 on BOX /////
  medShield(3, 3, 32);   ///// SLOT b3 on BOX /////
  smallShield(4, 5, 48); ///// SLOT b4 on BOX /////
  medShield(5, 6, 32);   ///// SLOT b5 on BOX /////
  bigShield(0, mx, my);     ///// SLOT b7 on BOX /////
  ballGrid(2, 1);
  ballGrid(0, 4);
  ballGrid(1, 7);
  /////////////////////////// increase size of radius so its covered when drawing over it in the sketch
  smallShieldRad +=3;
  medShieldRad +=3;
  bigShieldRad +=3;
}

PVector[] mShd = new PVector[9];
PVector[] sShd = new PVector[9];
PVector[] ball = new PVector[9]; 
PVector[] mShdP = new PVector[9];
PVector[] sShdP = new PVector[9];
PVector[] ballP = new PVector[9]; 
// new PVectors for positions of shields
PVector[][] shld = new PVector[9][3];
PVector[][] shldP = new PVector[9][3];


public void shieldRingSetup(int xPosition, int yPosition, int numberOfPositions, int numberOfShields, float medRingSize, float smallRingSize, float ballRingSize) {

  //shieldRingSetup(mx, my, 6, 9, medRingSize, smallRingSize, ballRingSize);    ////// SETUP RING SIZE FOR SHIELD POSITION, number of postitions on ring //////

  ///// MEDIUM SHIELD RING SETUP /////
  for (int i = 0; i < mShd.length; i++) {    
    float xpos = PApplet.parseInt(sin(radians((i)*360/numberOfShields))*medRingSize*2)+xPosition;
    float ypos = PApplet.parseInt(cos(radians((i)*360/numberOfShields))*medRingSize*2)+yPosition;
    mShdP[i] = new PVector (xpos, ypos);
    shldP[i][0] = new PVector (xpos, ypos);
    xpos = PApplet.parseInt(sin(radians((i)*360/numberOfPositions))*medRingSize*2)+xPosition;
    ypos = PApplet.parseInt(cos(radians((i)*360/numberOfPositions))*medRingSize*2)+yPosition;
    mShd[i] = new PVector (xpos, ypos);
    shld[i][0] = new PVector (xpos, ypos);
  }
  ///// SMALL SHIELD RING SETUP /////
  for (int i = 0; i < sShd.length; i++) {    
    float xpos = PApplet.parseInt(sin(radians((i)*360/numberOfShields))*smallRingSize*2)+xPosition;
    float ypos = PApplet.parseInt(cos(radians((i)*360/numberOfShields))*smallRingSize*2)+yPosition;
    sShdP[i] = new PVector (xpos, ypos);
    shldP[i][1] = new PVector (xpos, ypos);
    xpos = PApplet.parseInt(sin(radians((i)*360/numberOfPositions))*smallRingSize*2)+xPosition;
    ypos = PApplet.parseInt(cos(radians((i)*360/numberOfPositions))*smallRingSize*2)+yPosition;
    sShd[i] = new PVector (xpos, ypos);
    shld[i][1] = new PVector (xpos, ypos);
  }
  ///// BALL RING SETUP /////
  for (int i = 0; i < ball.length; i++) {    
    float xpos = PApplet.parseInt(sin(radians((i)*360/numberOfShields))*ballRingSize*2)+xPosition;
    float ypos = PApplet.parseInt(cos(radians((i)*360/numberOfShields))*ballRingSize*2)+yPosition;
    ballP[i] = new PVector (xpos, ypos);
    shldP[i][2] = new PVector (xpos, ypos);
    xpos = PApplet.parseInt(sin(radians((i)*360/numberOfPositions))*ballRingSize*2)+xPosition;
    ypos = PApplet.parseInt(cos(radians((i)*360/numberOfPositions))*ballRingSize*2)+yPosition;
    ball[i] = new PVector (xpos, ypos);
    shld[i][2] = new PVector (xpos, ypos);
  }
}

public void ballGrid(int numb, int position) {
  opc.led(1024+(64*numb), PApplet.parseInt(ballP[position].x), PApplet.parseInt(ballP[position].y));
}

float bigShieldRad;
public void bigShield(int numb, int xpos, int ypos) {
  int strt = (128*numb)+64; 
  ////// HIGH POWER LED RING ////
  int space = mw/2/18;
  opc.led(strt-64, xpos, ypos+space);
  opc.led(strt-64+1, xpos+space, ypos);
  opc.led(strt-64+2, xpos, ypos-space);
  opc.led(strt-64+3, xpos-space, ypos);
  ///// 5V LED STRIP ////
  int leds = 64;
  bigShieldRad = mw/leds*7;              
  for (int i=strt; i < strt+leds; i++) {     
    opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*bigShieldRad)+xpos, (PApplet.parseInt(cos(radians((i-strt)*360/leds))*bigShieldRad)+ypos));
  }
}
float medShieldRad;
public void medShield(int numb, int position, float leds) {
  int strt = (128*numb)+64;
  medShieldRad = mw/2/leds*5.12f;

  ////// USED FOR CIRCULAR / TIRANGULAR ARRANGEMENT /////
  int positionX = PApplet.parseInt(mShdP[position].x);
  int positionY = PApplet.parseInt(mShdP[position].y);

  ////// 5V LED RING for MEDIUM SHIELDS
  for (int i=strt; i < strt+leds; i++) {     
    opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*medShieldRad)+PApplet.parseInt(positionX), (PApplet.parseInt(cos(radians((i-strt)*360/leds))*medShieldRad)+PApplet.parseInt(positionY)));
  }
  ///// PLACE 4 HP LEDS in CENTER OF EACH RING /////
  for (int j = 1; j < 6; j +=2) {
    int space = mw/2/20;
    opc.led(strt-64, positionX, positionY+space);
    opc.led(strt-64+1, positionX+space, positionY);
    opc.led(strt-64+2, positionX, positionY-space);
    opc.led(strt-64+3, positionX-space, positionY);
  }
}

float smallShieldRad;
public void smallShield(int numb, int position, float leds) {
  int strt = (128*numb)+64;
  smallShieldRad = mw/2/leds*(3.125f*2);
  /////// RING OF 5V LEDS TO MAKE SAMLL SHIELD ///////
  for (int i=strt; i < strt+leds; i++) {     
    opc.led(i, PApplet.parseInt(sin(radians((i-strt)*360/leds))*smallShieldRad)+PApplet.parseInt(sShdP[position].x), (PApplet.parseInt(cos(radians((i-strt)*360/leds))*smallShieldRad)+PApplet.parseInt(sShdP[position].y)));

    ////// 1 HP LED IN MIDDLE OF EACH SMALL SHIELD //////
    for (int j = 0; j < 6; j +=2) {
      opc.led(strt-64, PApplet.parseInt(sShdP[position].x), PApplet.parseInt(sShdP[position].y));
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public void FMShieldGrid(int xpos, int ypos) {
  float medRingSize = mw/4.5f;        ///// SIZE OF RING BIG SHIELDS ARE POSITIONED ON
  float smallRingSize = mw/8.4f;        ///// SIZE OF RING SMALL SHIELDS ARE POSITIONED O 
  float ballRingSize = width/6;         ///// SIZE OF RING BALLS ARE POSITIONED ON
  shieldRingSetup(xpos, ypos, 6, 9, medRingSize, smallRingSize, ballRingSize);    ////// SETUP RING SIZE FOR SHIELD POSITION, number of postitions on ring //////

  //// SHIELDS - #1 slot on box; #2 position on ring; #3 number of LEDS in 5v ring 
  smallShield(0, 1, 48); ///// SLOT b0 on BOX /////   
  medShield(1, 1, 33);   ///// SLOT b1 on BOX ///// 

  smallShield(2, 5, 48); ///// SLOT b2 on BOX /////
  medShield(3, 5, 32);   ///// SLOT b3 on BOX /////

  smallShield(4, 3, 48); ///// SLOT b4 on BOX /////
  medShield(5, 3, 32);   ///// SLOT b5 on BOX /////

  bigShield(7, xpos, ypos);     ///// SLOT b7 on BOX /////

  ballGrid(2, 2);
  ballGrid(0, 4);
  ballGrid(1, 0);

  /////////////////////////// increase size of radius so its covered when drawing over it in the sketch
  smallShieldRad +=3;
  medShieldRad +=3;
  bigShieldRad +=3;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// PICKELD CANS & BOOTH //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////// ROOF CANS START AT 2048 !!! SPUTNIK BOX STARTS at 1536 !!!! ///////////////
///// BOOTH LIGHTS ///////   ///// 4-7 on box /////
int boothX, boothY;
public void boothLights(int xpos, int ypos) {
  boothX = xpos;
  boothY = ypos;

  int fc = 2;
  fc*=512;
  int slot = 64;

  opc.led(fc+(slot*3), boothX, boothY);       // digging light LEFT
  opc.led(fc+(slot*4), boothX+20, boothY);    // digging light RIGHT

  opc.led(fc+(slot*5), boothX, boothY+30);       // booth light LEFT
  opc.led(fc+(slot*6), boothX+20, boothY+30);       // booth light RIGHT
}

int canX;
int canY;
int canWidth;
//////////////// ROOF CANS START AT 2048 !!! SPUTNIK BOX STARTS at 1536 !!!! ///////////////
//////////////// vertical grid layout
public void NYEcans() {
  int gap = mw/11;
  int fc = 4;
  fc *=512;
  int slot = 64;

  canX = mx/2*3-20;
  canY = my-120;
  canWidth = 220;

  opcWifi.ledStrip(fc+(slot*1), 6, PApplet.parseInt(canX), PApplet.parseInt(canY), gap, 0, false);  /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
  opcWifi.ledStrip(fc+(slot*2), 6, PApplet.parseInt(canX), PApplet.parseInt(canY+2), gap, 0, false);  /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 

  //opc.ledStrip(fc+(slot*2), 3, int(can1X), int(can1Y), gap, (PI/2), !toggle);     /////  3 CANS PLUG INTO slot 2 on CANS BOX /////// 
  //opc.ledStrip(fc+(slot*3), 3, int(can1X), int(can1Y+(gap*4+gap/2)), gap, (PI/2), toggle);  /////  6 CANS PLUG INTO slot 3 on CANS BOX ///////
  //opc.ledStrip(fc+(slot*4), 3, int(can1X), int(can2Y), gap, (PI/2), !toggle);  /////  3 CANS PLUG INTO slot 4 on CANS BOX ///////
}

public void PickledCans() {
  int gap = 40;
  int fc = 2;
  fc *=512;
  int slot = 64;

  canX = mx;
  canY = my+(180);

  opc.ledStrip(fc+(slot*7), 6, PApplet.parseInt(canX), PApplet.parseInt(canY), gap, 0, true);  /////  6 CANS PLUG INTO slot 1 on CANS BOX /////// 
  //opc.ledStrip(fc+(slot*2), 3, int(can1X), int(can1Y), gap, (PI/2), !toggle);     /////  3 CANS PLUG INTO slot 2 on CANS BOX /////// 
  //opc.ledStrip(fc+(slot*3), 3, int(can1X), int(can1Y+(gap*4+gap/2)), gap, (PI/2), toggle);  /////  6 CANS PLUG INTO slot 3 on CANS BOX ///////
  //opc.ledStrip(fc+(slot*4), 3, int(can1X), int(can2Y), gap, (PI/2), !toggle);  /////  3 CANS PLUG INTO slot 4 on CANS BOX ///////
}
public void pickledDMXcontrol() {
  //// MAIN BOOTH OFF ///
  // blendMode(MULTIPLY);
  fill(0, 360);
  float y = 765;
  rect(roof1X, y, 10, 80);
  rect(roof2X, y, 10, 80);
  rect(roof3X, y, 10, 80);
  rect(roof4X, y, 10, 80);
  y = 695;
  rect(roof1X, y, 10, 10); //// roof lights in front of booth //// 
  rect(roof2X, y, 10, 10);
  rect(roof3X, y, 10, 10); //// roof lights in front of booth //// 
  rect(roof4X, y, 10, 10); //// roof lights next to laptop //// 
  blendMode(NORMAL);
}
////////////////////////////// override ON / OFF for spare DMX pixels, strobe, brightness etc ///////
public void DMXOverride() {
  fill(0);
  rect(5, 5, 20, 20);     ///////// rect for DMX control pixels OFF ////
  rect(ww, h-35, w, 80);
  fill(360);
  rect(w-5, 5, 10, 10);  ///////// rect for DMX control pixels ON ////
}

public void pickleDMXBattonsGrid() {
  opc.led(6001, 2, 2);
  opc.led(6003, 2, 4);
  opc.led(6005, 2, 6);

  opc.led(6002, rx-50, 100);
  opc.led(6000, rx, ry);
  opc.led(6004, rx+50, 350);
}

float DMXspotsX;
float DMXspotsY; 
public void pickleDMXspotsAdjust(float alph) {
  ///// PICKLE DMX DIM /////
  fill(0, 360-(360*alph));
  rect(DMXspotsX, DMXspotsY-200, 140, 180);
  blendMode(NORMAL);
  ///// PICKLE BAR LIGHTS /////
  fill(c1, 200); //// ON color C
  rect(DMXspotsX-60, DMXspotsY+57, 20, 30);
  //// PICKLE BOOTH LIGHTS ////
  fill(0);  ///// OFF
  rect(DMXspotsX, DMXspotsY+160, 140, 20);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// PICKLED DMX SETUP //////////////////////////////////////////////////////////////////

int roof1X, roof2X, roof3X, roof4X, roofY;
public void pickleDMXSpotsGrid(int xpos, int ypos) {
  //// OVERALL BRIGHNESS CONTROL, FAR RIGHT, ALWAYS ON ////
  opc.led(2000, w-5, 5);   //// *** change this back!!
  ///// AMBER CONTROL, FAR LEFT, ALWAYS OFF  ////
  opc.led(4000, 10, 3);
  //// STROBE CONTROL, FAR LEFT, ALWAYS OFF ///
  opc.led(5000, 5, 5);

  int n = 2;    //// HORIZTONAL DISTANCE BETWEEN PIXELS /////
  float m = 25;   //// VERTICAL DISTANCE BETWEEN PIXELS /////
  int v = 0;
  int c = 0;


  ///////// global variables for X and Y postion of roof spot lines //////////
  roof1X = xpos-PApplet.parseInt(rw/2/n*1.5f+v);
  roof2X = xpos-PApplet.parseInt(rw/2/n/2+c);
  roof3X = xpos+PApplet.parseInt(rw/2/n/2+c);
  roof4X = xpos+PApplet.parseInt(rw/2/n*1.5f+v);
  roofY = ypos;
  ypos = PApplet.parseInt(m*15/1.8f);
  /////// ROOF LEDS START AT 3000 /////
  opc.led(3000, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*1)));
  opc.led(3001, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*1)));
  opc.led(3002, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*1)));
  opc.led(3003, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*1)));

  opc.led(3004, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*2)));
  opc.led(3005, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*2)));

  opc.led(3006, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*3)));
  opc.led(3007, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*3)));
  opc.led(3008, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*3)));
  opc.led(3009, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*3)));

  ////// BAR /////
  opc.led(3010, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*4)));
  opc.led(3011, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*4)));
  opc.led(3012, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*4)));
  opc.led(3013, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*4)));
  ////// BAR /////
  opc.led(3014, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*5)));
  opc.led(3015, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*5)));
  ////// BAR /////
  opc.led(3016, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*6)));
  opc.led(3017, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*6)));
  opc.led(3018, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*6)));
  opc.led(3019, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*6)));

  opc.led(3020, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*7)));
  opc.led(3021, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*7)));
  opc.led(3022, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*7)));
  opc.led(3023, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*7)));

  opc.led(3024, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*8)));
  opc.led(3025, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*8)));

  opc.led(3026, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*9)));
  opc.led(3027, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*9)));
  opc.led(3028, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*9)));
  opc.led(3029, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*9)));

  opc.led(3030, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*10)));
  opc.led(3031, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*10)));
  opc.led(3032, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*10)));
  opc.led(3033, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*10)));

  opc.led(3034, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*11)));
  opc.led(3035, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*11)));

  opc.led(3036, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*12)));
  opc.led(3037, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*12)));
  opc.led(3038, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*12)));
  opc.led(3039, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*12)));

  opc.led(3040, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*13)));
  opc.led(3041, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*13)));
  opc.led(3042, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*13)));
  opc.led(3043, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*13)));

  opc.led(3044, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*14)));
  opc.led(3045, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*14)));

  opc.led(3046, xpos-PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*15)));
  opc.led(3047, xpos-(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*15)));
  opc.led(3048, xpos+(rw/2/n/2+c), PApplet.parseInt((ry-ypos)+(m*15)));
  opc.led(3049, xpos+PApplet.parseInt(rw/2/n*1.5f+v), PApplet.parseInt((ry-ypos)+(m*15)));
}
public void playWithMe() {
  float base = 0.4f;
  float top = stutter*0.1f;
  blendMode(NORMAL);

  int col1a = c;
  int col2a = flash;

  if (keyT[42]) {
    col1a = 0;
    col2a = 0;
    base = 1;
    top = 1;
  }

  /////////////////////// TOGGLE KEYS ///////////////////////
  ////////////////////////////////////////////////////////////

  ////  if (shift) {
  //// if (keyPressed) {
  //if (keyP[int('7')]) bigHP(col1a, base+top);
  //if (keyP[int('8')]) bigRing(col2a, base+top);

  //if (keyP[int('4')]) smallHP(col2a, base+top);
  //if (keyP[int('5')]) smallRing(col1a, base+top);

  //if (keyP[int('1')]) medHP(col2a, base+top);
  //if (keyP[int('2')]) medRing(col1a, base+top);

  //if (keyP[int('0')]) balls(col2a, base+top);

  //if (keyP[int('.')]) cans(col2a, base+top);
  ////if (keyP[int('-')]) cansRight(col2a, base+top);


  //if (keyT[55])       bigHP(col1a, base+top);
  //if (keyT[56])       bigRing(col2a, base+top);

  //if (keyT[52])     smallHP(col2a, base+top);
  //if (keyT[53])      smallRing(col1a, base+top);

  //if (keyT[49])      medHP(col1a, base+top);
  //if (keyT[50])       medRing(col2a, base+top);

  //if (keyT[48])     balls(col2a, base+top);

  //if (keyT[46])     cans(col2a, base+top*cc[8]);
  ////if (keyT[45])      cansRight(col2a, base+top*cc[7]);

  //// OVERRIDE ////
  //if (minus)  allOff();
  //if (keyP[int(' ')]) allOff();

  //////////////////////// PLAY WITH YOURSELF - PAD /////////////////////
  float speed = 1;
  float spd = 1;
  float chng = map(cc[3], 0, 1, -1, 1);  /// first pad button controls change - speed altered by first knob

  //////////////////////////////////////////////////////// FUCTION EFFECTS ////////////////////////////////////////////////
  if (cc[102] > 0) {
    //if (keyP[55]) {
    for (int i=0; i<4; i++) function[i] = stutter; 
    println("FUNCTION = STUTTER");
  }
  //////////////////////////////////////////////////////// ALPAH EFFECTS ///////////////////////////////
  if (cc[103] > 0) {   
    //if (keyP[56]) {
    for (int i=0; i<4; i++) alpha[i] = (alpha[i]*cc[3]/2)+(stutter*cc[3]);
    bt = (bt*cc[3]/2)+(stutter*cc[3]);
    bt1 = (bt1*cc[3]/2)+(stutter*cc[3]);

    println("ALPHA = STUTTER * knob 3");
  }


  if (cc[104] > 0) {
    //if (keyP[52]) {
    for (int i=0; i<4; i++) {
      alpha[i] = cc[4];
      //rigDimmer = 1;
      alpha1[i] = cc[4];
      bt = cc[4];
      bt1 = cc[4];
    }
    println("ALPHA = 1");
  }
  if (cc[108] > 0) {
    //if (keyP[53]) {
    for (int i=0; i<4; i++) {
      alpha[i] = 0;
      alpha1[i] = 0;
      bt = 0;
      bt1 = 0;
    }
    println("ALPHA 1 = 0");
  }

  /////////////////////////////////////////////////////// COLOR EFFECTS //////////////////////////////////////////////////////////////////
  //if (cc[106] > 0) {
  //  c = lerpColor(col[co1], col[co], cc[6]);
  //  flash = lerpColor(col[co], col[co1], cc[6]);
  //  println("COLOR LERP");
  //}
  //if (keyP[50]) {
  if ( cc[105] > 0) {
    colorFlip(true); 
    println("COLOR FLIP");
  }
  if (cc[101] > 0) {
    //if (keyP[51]) {
    colorSwap((cc[1]+1)*10000000);  
    println("COLOR SWAP * KNOB 1");
  }

  //if (cc[105]>0) beatSlider = cc[5];
  //    //triangleStrobeBANG(4, cc[5]);
  //    blendMode(LIGHTEST);
  //    image(vis[4], mx, my);
  //    println("STROBE - brightness * knob 8");
  //    blendMode(NORMAL);
  //  }
  ////////////// *** change these to bang buttons ///////////////
  //if (keyP[97]) portal(0, 0, 1);  
  //if (keyP[115]) portal2(0, 0, 1);
}
int counter, visualisation, visualisation1,visualisation2, af, af1 = 1, fc, fc1 = 1, swap;
float x, y, alf, bt, bt1, dimmer, func, func1;
int col1, col2;

float alpha[] = new float[4];
float alpha1[] = new float[4];

float function[] = new float[4];
float function1[] = new float[4];

PVector[] panelM = new PVector[9];
PVector[] panelT = new PVector[9];
PVector[] panelB = new PVector[9]; 

public void playWithYourself(float vizTm) {

  ///////////////// VIZ TIMER ////////////////////////////////////////
  if (millis()/1000 - time[0] >= vizTm) {
    counter = (counter + 1) % 3;
    if (counter == 0) {
      visualisation = PApplet.parseInt(random(1,11));
      visualisation1 = PApplet.parseInt(random(1,11));

      alf = 0; ////// set new viz to 0 to fade up viz /////
    }
    if (counter > 0 ) {
      visualisation = PApplet.parseInt(random(1,11));
      visualisation1 = PApplet.parseInt(random(1,11));
      alf = 0; ////// set new viz to 0 to fade up viz /////
    }
    println("VIZ:", visualisation, "COUNTER:", counter, "@", (hour()+":"+minute()+":"+second()));
    time[0] = millis()/1000;
  }
  float divide = 4; ///////// NUMBER OF TIMES ALPHA CHANGES PER VIZ
  ///////////// ALPHA TIMER ///////////////////////////////////////////////////////////
  if (millis()/1000 - time[1] >= vizTm/divide) { ///// alpha timer changes 4 times every viz change /////
    af = PApplet.parseInt(random(alph.length));  //// select from alpha array
    af1 = PApplet.parseInt(random(alph.length)); //// select from alpha array
    alf = 0; ////// set  viz to 0 to fade up viz when alpha changes /////
    println("alpha change @", (hour()+":"+minute()+":"+second()), "new af:", af, "new af1:", af1);
    time[1] = millis()/1000;
  }
  divide = 6; //////////////// NUMBER OF TIMES FUNCTION CHANGES PER VIZ
  //////////// FUNCTION TIMER ////////////////////////////////////////////////////////
  if (millis()/1000 - time[2] >= vizTm/divide) {    ////// change function n times for every state change
    fc = PApplet.parseInt(random(fct.length));  //// select from function array
    fc1 = PApplet.parseInt(random(fct.length));  //// select from function array
    alf = 0; ////// set  viz to 0 to fade up viz when fucntion changes /////
    println("function change @", (hour()+":"+minute()+":"+second()), "new fc:", fc, "new fc1:", fc1);
    time[2] = millis()/1000;
  }
  ///////////////////////////////// FADE UP NEXT VIZ ////////////
  if (alf < 1)  alf += 0.05f;
  if (alf > 1) alf = 1;
  //////////////////////////////////////////////////// END OF PLAY WITH YOURSELF AUTO CONTROL //////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////// SET FUNCTIONS AND ALPHAS TO USE THROUGHT SKETCH ////////////////
  for (int i =0; i< beats.length; i++) {
    /// key K to toggle shimmer
    if (keyT[107]) { 
      alpha[i] = alph[af][i]+(shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
      alpha1[i] = alph[af1][i]+(shimmerSlider/2+(stutter*0.4f*noize1*0.2f));

      if (beatCounter%4 == i) bt = alph[af][i]+(shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
      if (beatCounter%4 == i) bt1 = alph[af1][i]+(shimmerSlider/2+(stutter*0.4f*noize1*0.2f));
      ////////// maybe add this if K button isn't good
      //bt = bt+(0.3+(noize1*0.3));
      //bt1 = bt1+(0.3+(noize1*0.3));
    } else {
      alpha[i] = alph[af][i]/1;    //*(0.6+0.4*noize12)/1.5;  //// set alpha to selected alpha with bit of variation
      alpha1[i] = alph[af1][i]/1;   //*(0.6+0.4*noize1)/1.5;  //// set alpha1 to selected alpha with bit of variation
      if (beatCounter%4 == i) bt = alph[af][i];
      if (beatCounter%4 == i) bt1 = alph[af1][i];
    }
    //////////////// bright flash every 6 beats - counters all code above /////////
    if (beatCounter%6 == 0) {
      alpha[i]  = alph[af][i];
      alpha1[i]  = alph[af1][i];
    }
  }
  for (int i =0; i< beats.length; i++) {
    function[i] = fct[fc][i];  /// set func to selected function
    function1[i] = fct[fc1][i]; /// get func1 to selected function
    if (beatCounter%4 == i) func = fct[fc][i];
    if (beatCounter%4 == i) func1 = fct[fc1][i];
  }

  /////////////////////////////////////// COLORSWAP TIMER ///////////////////////////////////
  if (colorSwapSlider > 0)  colorSwap(colorSwapSlider*10000000*oskP);         //// spped of  colour swap; c/flash
  if (beatCounter%64<8) colorSwap(1000000*noize);   
  if (colorSwapSlider == 0) colorSwap(0);

  ////////////////////////////////////////// HOLD BUTTONS FOR VIZ AND COLOUR ///////////////////////////
  if (hold)  time[0] = millis()/1000;  //// hold viz change timer
  if (hold1) time[3] = millis()/1000;  //// hold color change timer

  ////////////////////////////////////// COLOR SWAP AND FLIP BUTTONS //////////////////////////////////////
  colorFlip(colFlip);                      // COLOR FLIP on ';' key (toggle)
  if (keyP[92])  colorSwap(0.9999999999f); /// COLOR SWAP on '\'  key
  if (keyP[39])  colorFlip(keyP[39]);      // COLOR SWAP ON '"' key (press and hold)

  ///////////////////////////////////////  COLOR FLIP ON BEAT ///////////////////////////////////
  for (int i=0; i<13; i+=2) if (beatCounter%32 == i) colorFlip(true);

  ////////////////////////////// LERP COLOUR ON BEAT /////////////////////////////
  if (keyT[108]) {
    c = lerpColor(col[co1], col[co], beatFast);
    flash = lerpColor(col[co], col[co1], beatFast);
  }
  if (beatCounter % 18 > 13) {
    c = lerpColor(col[co1], col[co], beatFast);
    flash = lerpColor(col[co], col[co1], beatFast);
  }

  /////////////////////////// TOGGLE MODIFIERS ///////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////
  /////////////// *** key X toggles different beat pattern 
  //if (keyT[120]) {
  //  steps = 4;
  //  if (beatCounter%steps==0) bt = beats[0];
  //  if (beatCounter%steps==1) bt = pulz;
  //  if (beatCounter%steps==2) bt = beats[2];
  //  if (beatCounter%steps==3) bt = beats[2];

  //  if (beatCounter%steps==0) bt1 = pulz;
  //  if (beatCounter%steps==1) bt1 = beat;
  //  if (beatCounter%steps==2) bt1 = pulzSlow;
  //  if (beatCounter%steps==3) bt1 = beat;
  //}
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
public PGraphics vizPreview(PGraphics subwindow) {
  //////////////////////////////// RIG PREVIEW GRAPHICS /////////////////////////////////////// 
  float size = 40;
  float ypos = 105;
  float xpos = size/2+20+45;
  float dim = 360*0.6f;

  subwindow.beginDraw(); 
  for (int i = 0; i< 11; i++) {

    if (i>6) { 
      xpos = 2*size+50;
      ypos = -6*size+30;
    }
    subwindow.tint(dim);
    subwindow.image(colorPreview[rigBgr], xpos, ypos+(size*i+5*i), size, size);        // draw color layer to screen - preview boxes
    subwindow.blendMode(MULTIPLY);
    subwindow.image(vizPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all vizulisation previews
    subwindow.blendMode(NORMAL);

    /////////////////////////////////////////////////// highlight roof viz ////////////////////////////////////////////////////////////////
    if (visualisation1 == i) {    
      subwindow.noTint();
      subwindow.image(colorPreview[rigBgr], xpos, ypos+(size*i+5*i), size, size);        // draw color layer to screen - preview boxes
      subwindow.blendMode(MULTIPLY);
      subwindow.image(vizPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all vizulisation previews
      subwindow.blendMode(NORMAL);
      subwindow.noFill();
      subwindow.strokeWeight(1);
      subwindow.stroke(c, 180);
      subwindow.rect(xpos, ypos+(size*i+5*i), size+2, size+2);                  // rectablge to hightlight which one is selected
      subwindow.rectMode(CORNER);
      subwindow.stroke(clashed, 210);
      subwindow.fill(flash, 360);
      subwindow.noStroke();
      subwindow.rect(xpos+size/2-3, ypos+1+(size*i+5*i)+size/2, 4, -(size+2)*cc[8]*secondVizSlider);     // 
      subwindow.rectMode(CENTER);
    }

    /////////////////////////////////////////////////// highlight rig viz //////////////////////////////////////////////////////////////// 
    if (visualisation == i) {
      subwindow.noTint();
      subwindow.image(colorPreview[rigBgr], xpos, ypos+(size*i+5*i), size, size);        // draw color layer to screen - preview boxes
      subwindow.blendMode(MULTIPLY);
      subwindow.image(vizPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all vizulisation previews
      subwindow.blendMode(NORMAL);
      subwindow.noFill();
      subwindow.strokeWeight(1);
      subwindow.stroke(flash, 180);
      subwindow.rect(xpos, ypos+(size*i+5*i), size, size);
      subwindow.rectMode(CORNER);
      subwindow.stroke(clashed, 210);
      subwindow.fill(c, 360);
      subwindow.noStroke();
      subwindow.rect(xpos+size/2-4, ypos+(size*i+5*i)+size/2, 4, -size*cc[4]*rigDimmer);
      subwindow.rectMode(CENTER);
    }
  }
  subwindow.noStroke();
  subwindow.noTint();
  subwindow.endDraw();
  return subwindow;
}

public PGraphics colorPreview(PGraphics subwindow) {
  //// display the different color layers and highlight the current one
  float size = 40;
  float ypos = 105;
  float xpos = size/2+20;
  float dim = 360*0.3f;

  for (int i = 0; i < 7; i++) colorPreviews(colorPreview[i], i, bg[i]); // generate all of the rig previews using masking
  subwindow.beginDraw(); 
  subwindow.background(0);
  for (int i = 0; i < 7; i++) {
    subwindow.tint(360, dim);
    subwindow.image(rigWindow, xpos, ypos+(size*i+5*i), size, size);      // draw current viz
    subwindow.blendMode(MULTIPLY);
    subwindow.image(colorPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all color layer patterns
    subwindow.blendMode(NORMAL);

    if (rigBgr == i) {
      subwindow.tint(360, 360);                              // tint CURRENT bright
      subwindow.image(rigWindow, xpos, ypos+(size*i+5*i), size, size);      // draw current viz
      subwindow.blendMode(MULTIPLY);
      subwindow.image(colorPreview[i], xpos, ypos+(size*i+5*i), size, size);      // draw all color layer patterns
      subwindow.blendMode(NORMAL);
      subwindow.noFill();
      subwindow.strokeWeight(1);
      subwindow.stroke(c, 180);
      subwindow.rect(xpos, ypos+(size*i+5*i), size, size);
    }
  }
  subwindow.stroke(flash, 180);
  //subwindow.resetShader();
  subwindow.noTint();
  subwindow.rect(xpos+size/2+2, 3*size+ypos+(3*5), 0, 7*size+(6*5));
  subwindow.endDraw();
  return subwindow;
}

public PGraphics colorPreviews(PGraphics subwindow, int index, PGraphics background) {
  subwindow.beginDraw(); 
  subwindow.background(0);
  //if (keyT[96])
  //subwindow.shader(maskShader);  
  subwindow.image(background, subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);      // draw all color layer patterns
  //subwindow.resetShader();
  subwindow.endDraw();
  return colorPreview[index];
}
public PGraphics vizDisplay(PGraphics subwindow, int index) {
  subwindow.beginDraw();
  subwindow.background(0);
  subwindow.image(vizPreview[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);   
  subwindow.noTint();
  subwindow.endDraw();

  return subwindow;
}
int steps = 0;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// VIZ SELECTION and PREVIEW ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
public void vizSelection(PGraphics subwindow, int viz, float dimmer) {

  println("viz "+viz);

  // variables to use in the construction of each vis[n]
  float stroke, wide, high, size, speed;
  col1 = color(white);
  col2 = color(white);
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////// VIZ SELECTION //////////////////////////////////////////////////////////////////////////
  blendMode(NORMAL);
  if (viz == 0) {
    blury *= 2;
    /////////////////////////////// make brighter //////////////////////////////
    pulse(4, c, flash, 1); ///((0.6)+bt*alf)*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.tint(360, (360*(0.6f)+bt*alf)*dimmer);
    subwindow.image(blured[4], mx, my);
    subwindow.noTint();
    subwindow.endDraw();
  }
  /////////////////////////////////////////////// FLOWER OF LIFE ////////////////////////////////////////////////////////////
  if (viz == 1) {
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      stroke = 20;//14+(20*oskP);
      wide = 50;
      size = 10+(wide-(wide*function[i])); //100+(20*i); //
      // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
      star(i, 10+(pulz*mw), 10+(beat*mh), -30*pulz, col1, stroke, alpha[i]*alf*dimmer);

      //flowerOfLife(i, col1, stroke, size, size, alpha[i]*alf*dimmer, alpha1[i]*alf*dimmer);
      //donut(i+4, col1, stroke, size, size, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], shldP[2][1].x, shldP[2][1].y, mw*2, mh*2);
      subwindow.image( blured[i], shldP[5][1].x, shldP[5][1].y, mw*2, mh*2);
      subwindow.image( blured[i], shldP[8][1].x, shldP[8][1].y, mw*2, mh*2);

      //subwindow.image( blured[i+4], mx, my);
    }

    //subwindow.beginDraw();
    //  subwindow.background(0);
    //  subwindow.blendMode(LIGHTEST);
    //  subwindow.image( blured[0], ballP[0].x, ballP[0].y, mw, mh);
    //  subwindow.image( blured[0], ballP[3].x, ballP[3].y, mw, mh);
    //  subwindow.image( blured[0], ballP[6].x, ballP[6].y, mw, mh);
    //  subwindow.endDraw();

    subwindow.endDraw();
  }
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if (viz == 2) {
   // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
   for (int i = 0; i < 4; i++) {
   stroke = 10+(mw/10*0.2f); //16+(10*func1);
   size = 10+(mw-(mw*function[i]-20));
   donut(i, col1, stroke, size, size, alpha[i]*alf*dimmer);
   }
   
   subwindow.beginDraw();
   subwindow.background(0);
   subwindow.blendMode(LIGHTEST);
   for (int i = 0; i < 4; i++) {
   subwindow.image( blured[i], shldP[2][0].x, shldP[2][0].y);
   subwindow.image( blured[i], shldP[5][0].x, shldP[5][0].y);
   subwindow.image( blured[i], shldP[8][0].x, shldP[8][0].y);
   }
   subwindow.endDraw();
   }
   
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 3) {
    stroke = 20;//14+(20*oskP);
    wide = (mw)-(mw/10);
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    for (int i = 0; i < 4; i++) {
      size = 5+(wide-(wide*function[i])); //100+(20*i); //
      donut(i, col1, stroke, size, size, alpha[i]*alf*dimmer);

      wide = (mw/4)-(mw/10);
      size = 10+(wide-(wide*function1[i])); //100+(20*i); //
      donut(i+4, col1, stroke, size, size, alpha[i]*alf*dimmer);
    }

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i < 4; i++) {
      subwindow.image( blured[i], shld[0][2].x, shld[0][2].y);
      subwindow.image( blured[i], shld[2][2].x, shld[2][2].y);
      subwindow.image( blured[i], shld[4][2].x, shld[4][2].y);


      subwindow.image( blured[i], shldP[1][1].x, shldP[1][1].y);
      subwindow.image( blured[i], shldP[4][1].x, shldP[4][1].y);
      subwindow.image( blured[i], shldP[7][1].x, shldP[7][1].y);

      subwindow.image( blured[i+4], mx, my);
    }
    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 4) {
    stroke = mw/12; //16+(10*func1);
    for (int i = 0; i <4; i++) {
      size = 15+(mw*function[i]);
      // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
      donut(i, col2, stroke, size, size, alpha[i]*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0); 
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], mx, my);
    subwindow.endDraw();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 5) {
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    for (int i=0; i<4; i++) {
      stroke = 50+(50*noize*function[i]);
      star(i, 10+(beats[i]*mw), 110-(pulzs[i]*mh), -60*beats[i], col1, stroke, alpha[i]/4*alf*dimmer);
    }
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image(blured[0], mx, my);
    subwindow.image(blured[1], mx, my);
    subwindow.image(blured[2], mx, my);
    subwindow.image(blured[3], mx, my);

    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 6) {
    stroke = 50+(50*noize*pulz);
    // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
    star(0, 10+(pulz*mw), 10+(beat*mh), -30*pulz, col1, stroke, bt/4*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(NORMAL);
    subwindow.image(blured[0], mx, my);
    subwindow.endDraw();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 7) {
    if (beatCounter%16<8)  steps = (1+PApplet.parseInt(beat*4))%4;
    else steps = 3-PApplet.parseInt(beatCounter%4);
    float bt0 = (0.4f*pulz)+(0.3f*noize1)+(0.2f*stutter); /// special fill for balls
    speed = beat;
    // spin(int n, float rad, float func, float rotate, float alph) {
    spin(0, medShieldRad, pulz, speed, bt1*alf*dimmer);
    spin(1, smallShieldRad, pulz, speed, bt*alf*dimmer);
    spin(2, bigShieldRad, pulz, -speed, bt*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image( blured[0], mShdP[0].x, mShdP[0].y);
    subwindow.image( blured[0], mShdP[3].x, mShdP[3].y);
    subwindow.image( blured[0], mShdP[6].x, mShdP[6].y);

    subwindow.image( blured[1], sShdP[2].x, sShdP[2].y);
    subwindow.image( blured[1], sShdP[5].x, sShdP[5].y);
    subwindow.image( blured[1], sShdP[8].x, sShdP[8].y);

    subwindow.fill(360*bt0*alf*dimmer);
    subwindow.ellipse(ballP[1].x, ballP[1].y, 10, 10);
    subwindow.ellipse(ballP[4].x, ballP[4].y, 10, 10);
    subwindow.ellipse(ballP[7].x, ballP[7].y, 10, 10);

    subwindow.image( blured[2], mx, my);

    bt0 = (0.4f*pulzSlow)+(0.3f*noize1); /// special fill for balls
    subwindow.fill(360*bt0*alf*dimmer);

    if (steps <2 ) subwindow.ellipse(mx, my, 30, 30);
    if (steps >=2) {
      subwindow.ellipse(ballP[1].x, ballP[1].y, 30, 30);
      subwindow.ellipse(ballP[4].x, ballP[4].y, 30, 30);
      subwindow.ellipse(ballP[7].x, ballP[7].y, 30, 30);
    }
    //if (steps < 3) {
    //  subwindow.ellipse(shldP[(7+steps)%9][(2-steps)%3].x, shldP[(7+steps)%9][(2-steps)%3].y, 30, 30);
    //  subwindow.ellipse(shldP[(4+steps)%9][(2-steps)%3].x, shldP[(4+steps)%9][(2-steps)%3].y, 30, 30);
    //  subwindow.ellipse(shldP[(1+steps)%9][(2-steps)%3].x, shldP[(1+steps)%9][(2-steps)%3].y, 30, 30);
    //}
    //println(steps);  


    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (viz == 8) {
    //steps = 9;
    //swap = int(func1*steps);
    //if (cc[103]>0) swap = int(millis()/50*chng); /// first pad button controls change - speed altered by first knob
    //int mod = (swap % steps + steps) % steps; /// code to always produce a positive number to allow reverse wrap around
    stroke = 20+(50*oskP);
    size = 10+((mw-60)-((mw-60)*func));
    // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
    donut(0, col1, stroke, size, size, bt*alf*dimmer);
    size = 2+(mw/5-(mw/5*func));
    donut(1, col2, stroke, size, size, bt1*alf*dimmer);

    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    subwindow.image( blured[0], mShdP[0].x, mShdP[0].y);
    subwindow.image( blured[0], mShdP[3].x, mShdP[3].y);
    subwindow.image( blured[0], mShdP[6].x, mShdP[6].y);

    subwindow.image( blured[0], ballP[1].x, ballP[1].y);
    subwindow.image( blured[0], ballP[4].x, ballP[4].y);
    subwindow.image( blured[0], ballP[7].x, ballP[7].y);

    subwindow.image( blured[1], mx, my);
    subwindow.endDraw();
  }

  /////////////////////////////////////////////////////////////////////////////////////
  if (viz == 9) {
    stroke = 90-(85*pulzSlow);
    size = mw+(50);
    //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
    for (int i = 0; i <4; i++) donut(i, col1, stroke, size-(size*function[i]*(i+1)), size-(size*function[i]*(i+1)), alpha[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image( blured[i], mx, my);
    subwindow.endDraw();
  }
  ////////////////////////////////////////////////////////// LOCK ///////////////////////////
  if (viz == 10) {
    // lockIt(int n, float func, float func1, float alph) {
    for (int i = 0; i <2; i++) lockIt(i, function[i], function1[i], alpha[i]*alf*dimmer, alpha1[i]*alf*dimmer);
    for (int i = 2; i <4; i++) lockIt(i, function[i], -function1[i], alpha1[i]*alf*dimmer, alpha1[i]*alf*dimmer);
    subwindow.beginDraw();
    subwindow.background(0);
    subwindow.blendMode(LIGHTEST);
    for (int i = 0; i <4; i++) subwindow.image(vis[i], mx, my);
    subwindow.endDraw();
  }

  subwindow.beginDraw();
  subwindow.blendMode(NORMAL);
  subwindow.endDraw();
  ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////// END OF PLAYWITHYOURSELF /////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////
}
int rigBgr, roofBgr; 
public void colorLayer(PGraphics subwindow, int index) {
  //////////////////////////////////////////////////////////// COLOR LAYER (BACKGROUNDS) /////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////// APPLY BLENDING COLOUR AFTER IMAGE IS DRAWN ///////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////// RIG COLOR LAYERS ///////////////////////////////////////
  if (subwindow == rigColourLayer) {
    //if (rigBgr == 0) 
    radGradBallBG(0, c, flash, 0);  
    //if (rigBgr == 1) 
    radialGradientBG(1, c, flash, func);
    //if (rigBgr == 2) 
    bigOppBG(2, c, flash);
    //if (rigBgr == 3) 
    eyeBG(3, c, flash);
    //if (rigBgr == 4) 
    radGradEyeBG(4, flash, c, func);
    //if (rigBgr == 5) 
    sipralBG(5, flash, c);
    //if (rigBgr == 6) 
    threeColBG(6, c, flash);

    cansBG(index, flash, flash);
    if (beatCounter%16 > 8) cansBG(index, flash, clash);
    if (beatCounter % 64 > 48) cansBG(index, c, flash);
    if (beatCounter % 32 < 12) cansBG(index, clash, clash1);

    if (visualisation>0) {
      subwindow.beginDraw();
      //subwindow.blendMode(MULTIPLY);
      subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
      subwindow.endDraw();
    }
  }

  if (subwindow == roofColourLayer) {
    mirrorGradientBG(0, c, flash, 0.5f);  
    horizontalMirrorGradBG(1, c, flash, func);
    horizontalMirrorGradBG(2, c, flash, 0);
    horizontalMirrorGradBG(3, flash, c, 0.5f);
    roofClashOutsideBG(4, flash, c);
    roofClashInsideBG(5, c, flash);
    roofMosaicBG(6, c, flash);

    if (visualisation1 >0) {
      subwindow.beginDraw();
      //subwindow.blendMode(MULTIPLY);
      subwindow.image(bg[index], subwindow.width/2, subwindow.height/2, subwindow.width, subwindow.height);
      subwindow.endDraw();
    }
  }

  ///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
}

//void colorLayer(PGraphics subwindow) {
//  //////////////////////////////////////////////////////////// COLOR LAYER (BACKGROUNDS) /////////////////////////////////////////////////////////////
//  ///////////////////////////////////////////////////// APPLY BLENDING COLOUR AFTER IMAGE IS DRAWN ///////////////////////////////////

//  //if (beatCounter%128 == 0) rigBgr = (rigBgr + 1)% 7;

//  //////////////////////////////////////////////////////////////////////////////////////////////////////////
//  /////////////////////////////////////////////// RIG COLOR LAYERS ///////////////////////////////////////
//  if (subwindow == rigWindow) {
//    if (rigBgr == 0) radGradBallBG(0, c, flash, 0);  
//    if (rigBgr == 1) radialGradientBG(0, c, flash, func);
//    if (rigBgr == 2) bigOppBG(0, c, flash);
//    if (rigBgr == 3) eyeBG(0, c, flash);
//    if (rigBgr == 4) radGradEyeBG(0, flash, c, func);
//    if (rigBgr == 5) sipralBG(0, flash, c);
//    if (rigBgr == 6) threeColBG(0, c, flash);
//    if (visualisation>0) {
//      subwindow.beginDraw();
//      //subwindow.blendMode(MULTIPLY);
//      subwindow.image(bg[0], mx, my, mw, mh);
//      subwindow.endDraw();
//    }
//  }
//  //////////////////////////////////////////////////////////////////////////////////////////////////////////
//  /////////////////////////////////////////////// ROOF COLOR LAYERS ///////////////////////////////////////
//  if (subwindow == roofWindow) {
//    if (roofBgr == 0) mirrorGradientBG(1, c, flash, 0.5);  
//    if (roofBgr == 1) horizontalMirrorGradBG(1, c, flash, func);
//    if (roofBgr == 2) horizontalMirrorGradBG(1, c, flash, 0);
//    if (roofBgr == 3) horizontalMirrorGradBG(1, flash, c, 0.5);
//    if (roofBgr == 4) roofClashOutsideBG(1, flash, c);
//    if (roofBgr == 5) roofClashInsideBG(1, c, flash);
//    if (roofBgr == 6) roofMosaicBG(1, c, flash);

//    if (visualisation1 >0) {
//      subwindow.beginDraw();
//      subwindow.blendMode(MULTIPLY);
//      subwindow.image(bg[1], mx, my, rw, rh);
//      subwindow.endDraw();
//    }
//  }
//  blendMode(NORMAL);

//  ///////////////////////////// END OF BACKGROUNDS ///////////////////////////////////////
//}
public PGraphics cansBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].noStroke();
  bg[n].rectMode(CENTER);
  bg[n].fill(col1);
  for (int i  =0; i<6; i+=2) bg[n].rect(canX-(canWidth/2)+(i*38)+5, canY+1, 38, 6);
  bg[n].fill(col2);
  for (int i  =1; i<6; i+=2) bg[n].rect(canX-(canWidth/2)+(i*38)+5, canY+1, 38, 6);
  bg[n].rectMode(CENTER);
  bg[n].endDraw();

  return bg[n];
}



/// MIRROR GRADIENT BACKGROUND ///
public PGraphics mirrorGradientBG(int n, int col1, int col2, float func) {
  bg[n].beginDraw();
  bg[n].background(0, 0);

  //// LEFT SIDE OF GRADIENT
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col1);
  bg[n].vertex(0, 0);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, 0);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, bg[n].height);
  bg[n].fill(col1);
  bg[n].vertex(0, bg[n].height);
  bg[n].endShape(CLOSE);
  //// RIGHT SIDE OF bg[n]IENT
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, 0);
  bg[n].fill(col1);
  bg[n].vertex(bg[n].width, 0);
  bg[n].fill(col1);
  bg[n].vertex(bg[n].width, bg[n].height);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width*func, bg[n].height);
  bg[n].endShape(CLOSE);
  bg[n].endDraw();

  //image(bg[n],mx,my,mw,mh);
  return bg[n];
}

public PGraphics horizontalMirrorGradBG(int n, int col1, int col2, float func) {
  bg[n].beginDraw();
  bg[n].background(0);
  //// TOP HALF OF GRADIENT
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col2);
  bg[n].vertex(0, 0);
  bg[n].vertex(bg[n].width, 0);
  bg[n].fill(col1);
  bg[n].vertex(bg[n].width, bg[n].height*func);
  bg[n].vertex(0, bg[n].height*func);
  bg[n].endShape(CLOSE);
  //// BOTTOM HALF OF GRADIENT 
  bg[n].beginShape(POLYGON); 
  bg[n].fill(col1);
  bg[n].vertex(0, bg[n].height*func);
  bg[n].vertex(bg[n].width, bg[n].height*func);
  bg[n].fill(col2);
  bg[n].vertex(bg[n].width, bg[n].height);
  bg[n].vertex(0, bg[n].height);
  bg[n].endShape(CLOSE);
  bg[n].endDraw();
  return bg[n];
}

/// RADIAL GRADIENT BACKGROUND ///
public PGraphics radialGradientBG(int n, int col1, int col2, float function) {
  bg[n].beginDraw();
  bg[n].background(col1);
  float radius = bg[n].width;
  int numPoints = 3;
  float angle=360/numPoints;
  float rotate = 90+(function*angle);
  for (  int i = 0; i < numPoints; i++) {
    //bg[n].fill(col2);
    //bg[n].rect(bg[n].width/2,bg[n].height/2,bg[n].width,bg[n].height);
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i)*angle+rotate))*radius+bg[n].width/2, sin(radians((i)*angle+rotate))*radius+bg[n].height/2);
    bg[n].fill(col2);
    bg[n].vertex(bg[n].width/2, bg[n].height/2);
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i+1)*angle+rotate))*radius+bg[n].width/2, sin(radians((i+1)*angle+rotate))*radius+bg[n].height/2);
    bg[n].endShape(CLOSE);
  }
  bg[n].endDraw();

  return bg[n];
}

/// OPPOSITE COLOUR BIG SHIELD BACKGROUND ///
public PGraphics bigOppBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(col1);
  ///////////////  BACKGROUND /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col2);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].endDraw();

  return bg[n];
}

/// 2x OPPOSITE COLOUR BIG SHIELD CLASH BACKGORUND///
public PGraphics eyeBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(col2);
  ///////////////  BACKGROUND /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);     
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].fill(clashed);                                
  bg[n].ellipse(mx, my, 30, 30);
  bg[n].endDraw();

  return bg[n];
}
/// RADIAL GRADIENT BACKGROUND with EYE ///
public PGraphics radGradEyeBG(int n, int col1, int col2, float function) {
  bg[n].beginDraw();
  bg[n].background(col1);
  float radius = bg[n].width;
  int numPoints = 3;
  float angle=360/numPoints;
  float rotate = -30+(function*angle);
  for (  int i = 0; i < numPoints; i++) {
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i)*angle+rotate))*radius+bg[n].width/2, sin(radians((i)*angle+rotate))*radius+bg[n].height/2);
    bg[n].fill(col2);
    bg[n].vertex(bg[n].width/2, bg[n].height/2);
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i+1)*angle+rotate))*radius+bg[n].width/2, sin(radians((i+1)*angle+rotate))*radius+bg[n].height/2);
    bg[n].endShape(CLOSE);
  }
  ////////////////// Fill BIG SHIELD OPPOSITE COLOR //////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].fill(col2);                                
  bg[n].ellipse(mx, my, 30, 30);
  bg[n].endDraw();

  return bg[n];
}
/// RADIAL GRADIENT BACKGROUND with EYE and BALLS ///
public PGraphics radGradBallBG(int n, int col1, int col2, float function) {
  bg[n].beginDraw();
  bg[n].background(col1);
  float radius = bg[n].width;
  int numPoints = 3;
  float angle=360/numPoints;
  float rotate = -30+(function*angle);
  for (  int i = 0; i < numPoints; i++) {
    bg[n].beginShape(POLYGON); 
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i)*angle+rotate))*radius+bg[n].width/2, sin(radians((i)*angle+rotate))*radius+bg[n].height/2);
    bg[n].fill(col2);
    bg[n].vertex(bg[n].width/2, bg[n].height/2);
    bg[n].fill(col1);
    bg[n].vertex(cos(radians((i+1)*angle+rotate))*radius+bg[n].width/2, sin(radians((i+1)*angle+rotate))*radius+bg[n].height/2);
    bg[n].endShape(CLOSE);
  }
  ////////////////// Fill BIG SHIELD OPPOSITE COLOR //////////////
  bg[n].fill(clash);                                
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  bg[n].fill(clash1);                                
  bg[n].ellipse(mx, my, 30, 30);

  ///////////// BALLS //////////////////////
  bg[n].fill(clashed);      
  bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  bg[n].ellipse(ballP[4].x, ballP[4].y, 7, 7);
  bg[n].ellipse(ballP[1].x, ballP[1].y, 7, 7);

  bg[n].endDraw();

  return bg[n];
}

/// EACH SPIAL ARM SEPERATE COLOUR ///
public PGraphics sipralBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  /////////////// FILL COLOR ////////////////////
  bg[n].fill(clash);
  ///////////////  BIG SHIELD RING /////////////
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height); 
  ////////////////// BIG SHIELD HP LEDS /////////////
  bg[n].fill(clash1);
  bg[n].ellipse(mx, my, 30, 30);
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col2);                                
  ////////////////// BOTTOM ARM ///////////////////
  bg[n].ellipse(mShdP[0].x, mShdP[0].y, medShieldRad, medShieldRad);
  bg[n].ellipse(sShdP[8].x, sShdP[8].y, smallShieldRad, smallShieldRad);
  bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(col1);                                
  /////////////////// LEFT ARM //////////////
  bg[n].ellipse(mShdP[6].x, mShdP[6].y, medShieldRad, medShieldRad);
  bg[n].ellipse(sShdP[5].x, sShdP[5].y, smallShieldRad, smallShieldRad);  
  bg[n].ellipse(ballP[4].x, ballP[4].y, 7, 7);
  ////////////////// Fill OPPOSITE COLOR //////////////
  bg[n].fill(clashed);       
  //////////////////// RIGHT ARM //////////////////mmm
  bg[n].ellipse(mShdP[3].x, mShdP[3].y, medShieldRad, medShieldRad);
  bg[n].ellipse(sShdP[2].x, sShdP[2].y, smallShieldRad, smallShieldRad);
  bg[n].ellipse(ballP[1].x, ballP[1].y, 7, 7);
  bg[n].endDraw();
  return bg[n];
}

/// OPPOSITE COLOUR SHIELDS BACKGROUND ///
public PGraphics threeColBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);
  //////// FILL IN BACKGROUND TO SEE VIZ ///////
  bg[n].fill(col1, 180);
  bg[n].rect(bg[n].width/2, bg[n].height/2, bg[n].width, bg[n].height);  

  //////////////////// BIG SHIELD CLASH /////////////
  bg[n].fill(col2);
  bg[n].ellipse(mx, my, bigShieldRad, bigShieldRad);
  ////////////////// BIG SHIELD HP LEDS //////////////
  //bg[n].fill(clashed);
  //bg[n].ellipse(mx, my, 30, 30);

  ////////////////// MEDIUM SHIELD RING AND HP LEDS ///////////////////
  bg[n].fill(col1);                                
  bg[n].ellipse(mShdP[0].x, mShdP[0].y, medShieldRad, medShieldRad);
  bg[n].ellipse(mShdP[3].x, mShdP[3].y, medShieldRad, medShieldRad);  
  bg[n].ellipse(mShdP[6].x, mShdP[6].y, medShieldRad, medShieldRad);
  ////////////////// BIG SHIELD HP LEDS ////////////////
  bg[n].ellipse(mx, my, 30, 30);

  ///////////////  SMALL SHIELDS /////////////
  bg[n].fill(clashed);
  bg[n].ellipse(sShdP[2].x, sShdP[2].y, smallShieldRad, smallShieldRad);
  bg[n].ellipse(sShdP[5].x, sShdP[5].y, smallShieldRad, smallShieldRad);  
  bg[n].ellipse(sShdP[8].x, sShdP[8].y, smallShieldRad, smallShieldRad); 
  ///////////// BALLS //////////////////////
  bg[n].fill(col2);      
  bg[n].ellipse(ballP[7].x, ballP[7].y, 7, 7);
  bg[n].ellipse(ballP[4].x, ballP[4].y, 7, 7);
  bg[n].ellipse(ballP[1].x, ballP[1].y, 7, 7);

  bg[n].endDraw();
  return bg[n];
}

/////// 
public PGraphics roofClashOutsideBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);

  bg[n].fill(clash);
  bg[n].rect(bg[n].width/8, bg[n].height/2, bg[n].width/4, bg[n].height);   
  bg[n].rect(bg[n].width/8*7, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(col1);
  bg[n].rect(bg[n].width/8*3, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(col2);
  bg[n].rect(bg[n].width/8*5, bg[n].height/2, bg[n].width/4, bg[n].height);
  bg[n].endDraw();

  return bg[n];
}

/////// 
public PGraphics roofClashInsideBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);

  bg[n].fill(col1);
  bg[n].rect(bg[n].width/8, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(col2);
  bg[n].rect(bg[n].width/8*7, bg[n].height/2, bg[n].width/4, bg[n].height);   

  bg[n].fill(clash);
  bg[n].rect(bg[n].width/8*3, bg[n].height/2, bg[n].width/4, bg[n].height);
  bg[n].fill(clash1);

  bg[n].rect(bg[n].width/8*5, bg[n].height/2, bg[n].width/4, bg[n].height);
  bg[n].endDraw();

  return bg[n];
}

public PGraphics roofMosaicBG(int n, int col1, int col2) {
  bg[n].beginDraw();
  bg[n].background(0);

  for (int i =0; i < 15; i= i+2) {
    bg[n].fill(col1);
    bg[n].rect(bg[n].width/8, rh/8*i, bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*3, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*5, rh/8*(i), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*7, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].fill(col2);
    bg[n].rect(bg[n].width/8, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*3, rh/8*(i), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*5, rh/8*(i+1), bg[n].width/4, rh/8);
    bg[n].rect(bg[n].width/8*7, rh/8*(i), bg[n].width/4, rh/8);
  }
  bg[n].endDraw();

  return bg[n];
}
//////////////////////////////////////////////////// COLOR TIMER ////////////////////////////////
int c, flash, c1, flash1, co, co1 = 1, co2, co3, colA, colB, colC, colD;
float go;
boolean change;
public void colorTimer(float colTime, int steps) {
  if (change == false) {
    colA = c;
    colC = flash;
  }

  if (millis()/1000 - time[3] >= colTime) {
    change = true;
    println("COLOR CHANGE @", (hour()+":"+minute()+":"+second()));
    time[3] = millis()/1000;
  } else change = false;
  if (change == true) {
    go = 1;
    co =  (co + steps) % (col.length-1);
    colB =  col[co];
    co1 = (co1 + steps) % (col.length-1);
    colD = col[co1];
    co2 = (co2 + steps) % (col.length-1);
    co3 = (co3 + steps) % (col.length-1);
  }

  c = col[co];
  c1 = col[co];
  flash = col[co1];
  flash1 = col[co1];

  if (go > 0.1f) change = true;
  else change = false;
  if (change == true) {
    c = lerpColorHSB(colB, colA, go);
    flash = lerpColorHSB(colD, colC, go);
  }

  go *= 0.97f;
  if (go < 0.01f) go = 0.001f;
}
////////////////////////////////////////////////////// HSB LERP COLOR FUNCTION //////////////////////////////
// linear interpolate two colors in HSB space 
public int lerpColorHSB(int c1, int c2, float amt) {
  amt = min(max(0.0f, amt), 1.0f);
  float h1 = hue(c1), s1 = saturation(c1), b1 = brightness(c1);
  float h2 = hue(c2), s2 = saturation(c2), b2 = brightness(c2);
  // figure out shortest direction around hue
  float z = g.colorModeZ;
  float dh12 = (h1>=h2) ? h1-h2 : z-h2+h1;
  float dh21 = (h2>=h1) ? h2-h1 : z-h1+h2;
  float h = (dh21 < dh12) ? h1 + dh21 * amt : h1 - dh12 * amt;
  if (h < 0.0f) h += z;
  else if (h > z) h -= z;
  colorMode(HSB);
  return color(h, lerp(s1, s2, amt), lerp(b1, b2, amt));
}
////////////////////////////// COLOR SWAP //////////////////////////////////
boolean colSwap;
public void colorSwap(float spd) {
  int t = PApplet.parseInt(millis()/70*spd % 2);
  int colA = c;
  int colB = flash;
  if ( t == 0) {
    colSwap = true;
    c = colB;
    flash = colA;
  } else colSwap = false;
} 
////////////////////////////// COLOR FLIP //////////////////////////////////
boolean colFlip;
boolean colorFlipped;
public void colorFlip(boolean toggle) {
  int colA = c;
  int colB = flash;
  if (toggle) {
    colorFlipped = true;
    c = colB;
    flash = colA;
  } else colorFlipped = false;
}


///////////////////////////////////////// CLASH COLOR SETUP /////////////////////////////////
int clash, clash1, clash2, clash12, clashed;
public void clash(float func) { 
  int flashHalf = lerpColor(c, flash, 0.75f);
  int cHalf = lerpColor(c, flash, 0.25f); 

  clash = lerpColorHSB(cHalf, flashHalf, func);     ///// MOVING, HALF RNAGE BETWEEN C and FLASH
  clash1 = lerpColorHSB(cHalf, flashHalf, 1-func);            ///// MOVING, HALF RANGE BETWEEN FLASH and C
  clash2 = lerpColorHSB(flash, c, func);          ///// MOVING, FULL RANGE BETWEEN C and FLASH
  clash12 = lerpColorHSB(flash, c, 1-func);          ///// MOVING, FULL RANGE BETWEEN FLASH and C
  clashed = lerpColor(c, flash, 0.5f);    ///// STATIC - HALFWAY BETWEEN C and FLASH
}
/////////////////////////////////////// COLOR ARRAY SETUP ////////////////////////////////////////
int col[] = new int[15];
public void colorArray() {
  col[0] = purple; 
  col[1] = pink; 
  col[2] = orange1; 
  col[3] = aqua;
  col[4] = yell;
  col[5] = bloo;
  col[6] = purple;
  col[7] = grin;
  col[8] = orange;
  col[9] = aqua;
  col[10] = pink;
  col[11] = purple;
  col[12] = orange;
  col[13] = orange1;
  col[14] = teal;
  
}
/////////////////////////// COLOR SETUP CHOSE COLOUR VALUES ///////////////////////////////////////////////
int red, pink, yell, grin, bloo, purple, teal, orange, aqua, white, black;
int red1, pink1, yell1, grin1, bloo1, purple1, teal1, aqua1, orange1;
int red2, pink2, yell2, grin2, bloo2, purple2, teal2, aqua2, orange2;
public void colorSetup() {
  colorMode(HSB, 360, 100, 100);
  white = color(0, 0, 80);
  black = color(0, 0, 0);

  float alt = 0;
  float sat = 100;
  aqua = color(150+alt, sat, 100);
  pink = color(323+alt, sat, 90);
  bloo = color(239+alt, sat, 100);
  yell = color(50+alt, sat, 100);
  grin = color(115+alt, sat, 100);
  orange = color(34.02f+alt, sat, 90);
  purple = color(290+alt, sat, 70);
  teal = color(170+alt, sat, 85);
  red = color(7+alt, sat, 100);
  // colors that aren't affected by color swap
  float sat1 = 100;
  aqua1 = color(190+alt, 80, 100);
  pink1 = color(323-alt, sat1, 90);
  bloo1 = color(239-alt, sat1, 100);
  yell1 = color(50-alt, sat1, 100);
  grin1 = color(160-alt, sat1, 100);
  orange1 = color(34.02f-alt, sat1, 90);
  purple1 = color(290-alt, sat1, 70);
  teal1 = color(170-alt, sat1, 85);
  red1 = color(15-alt, sat1, 100);
  /// alternative colour similar to original for 2 colour blends
  float sat2 = 100;
  alt = +6;
  aqua2 = color(190-alt, 80, 100);
  pink2 = color(323-alt, sat2, 90);
  bloo2 = color(239-alt, sat2, 100);
  yell2 = color(50-alt, sat2, 100);
  grin2 = color(160-alt, sat2, 100);
  orange2 = color(34.02f-alt, sat2, 90);
  purple2 = color(290-alt, sat2, 70);
  teal2 = color(170-alt, sat2, 85);
  red2 = color(15-alt, sat2, 100);
}
/////////////////////////////////// FUNCTION AND ALPHA ARRAYS //////////////////////////////////////////////
float alph[][] = new float[7][4];
float fct[][] = new float[8][4];
float sineFast, sineSlow, sine, d, e, stutter;
float timer[] = new float[6];
public void arrayDraw() {
  float tm = 0.05f+(noize/50);
  timer[2] += beatSlider;            

  for (int i = 0; i<timer.length; i++) timer[i] += tm;

  timer[3] += (0.3f*5);
  //timer[5] *=1.2;
  sine = map(sin(timer[0]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineFast = map(sin(timer[5]), -1, 1, 0, 1);            //// 0-1-1-0 standard sine wave
  sineSlow = map(sin(timer[1]/4), -1, 1, 0, 1);         //// 0-1-1-0 slow sine wave
  d = map(sin(timer[2] % HALF_PI), 0, 1, 1, 0);   //// 1-0-0-1 zero then 1 and then jump back to 0
  e = sin(timer[3] % HALF_PI);                    //// 0-1-0-1 one and then 0 jump back to one
  if (cc[102] > 0)   stutter = map(sin(timer[4]*cc[2]*8), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave
  else stutter = map(sin(timer[4]*50), -1, 1, 0, 1);        //// 0-1-1-0 fast jitter sine wave

  //// array of functions
  ///////////////////////////////////// add BS and PS
  fct[0] = pulzs;         
  fct[1] = beats;        
  fct[2] = pulzsSlow; 
  for (int i = 0; i < 4; i++) {
    fct[3][i] = (beatsSlow[i]*0.99f)+(0.01f*stutter);
    fct[4][i] = (0.99f*pulzs[i])+(stutter*pulzs[i]*0.01f);       
    fct[5][i] = (0.99f*beatsSlow[i])+(stutter*pulzs[i]*0.01f);
  }
  fct[6] = pulzsSlow;
  fct[7] = beatsSlow;

  //// array of alphas
  alph[0] = beats;
  alph[1] = pulzs;
  for (int i = 0; i < 4; i++) {
    alph[2][i] = beats[i]+(0.05f*stutter);
    alph[3][i] =(0.8f*beats[i])+(stutter*pulzs[i]*0.2f);
    alph[4][i] = (0.8f*pulzs[i])+(beats[i]*0.2f*stutter);
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
float avgtime, avgvolume;
float weightedsum, weightedcnt;
float beatAlpha;
public void beats() {             ////// BEAT DETECT THROUGHOUT SKETCH ///////
  beatTimer++;
  beatAlpha=0.2f;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  if (beatDetect.isOnset()) {
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
    for (int i = 0; i < beats.length; i++) beats[i]*=pow(beatSlider*(0.001f+cc[5]), (1/avgtime)); //  changes rate alpha fades out!!
    for (int i = 0; i < beats.length; i++) {
      if (beatCounter % 4 != i) beats[i]*=pow(beatSlider/3*(0.001f+cc[5]), (1/avgtime));                               //  else if beat is 1,2 or 3 decay faster
    }
  } else { 
    beat*=0.95f;
    for (int i = 0; i < beats.length; i++) beats[i]*=0.95f;
  }
  if (beat < 0.8f) beat *= 0.98f;

  for (int i = 0; i < pulzs.length; i++) pulzs[i] = 1-beats[i];
  for (int i = 0; i < beatsFast.length; i++) beatsFast[i] *=0.9f;
  for (int i = 0; i < pulzsFast.length; i++) pulzsFast[i] = 1-beatsFast[i];

  for (int i = 0; i < beatsSlow.length; i++) beatsSlow[i] -= 0.05f;
  for (int i = 0; i < pulzsSlow.length; i++) pulzsSlow[i] = 1-beatsSlow[i];

  pulz = 1-beat;                     /// p is opposite of b
  beatFast *=0.7f;                 
  pulzFast = 1-pulzFast;            /// bF is oppiste of pF

  beatSlow -= 0.05f;
  pulzSlow = 1-beatSlow;

  float end = 0.01f;
  if (beat < end) beat = end;
  for (int i = 0; i < beats.length; i++) if (beats[i] < end) beats[i] = end;

  if (pulzFast > 1) pulzFast = 1;
  if (beatFast < end) beatFast = end;
  for (int i = 0; i < beatsFast.length; i++) if (beatsFast[i] < end) beatsFast[i] = end;
  for (int i = 0; i < pulzsFast.length; i++) if (pulzsFast[i] > 1) pulzsFast[i] = 1;

  if (beatSlow < 0.4f+(noize1*0.2f)) beatSlow = 0.4f+(noize1*0.2f);
  for (int i = 0; i < beatsSlow.length; i++) if (beatsSlow[i] < end) beatsSlow[i] = end;
  if (pulzSlow > 1) pulzSlow = 1;
  for (int i = 0; i < pulzsSlow.length; i++) if (pulzsSlow[i] > 1) pulzsSlow[i] = 1;
} 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// KEYBOARD COMMANDS //////////////////////////////////// 
boolean test, work, info, play, stop, hold, hold1, one, two, three, four, five, six, seven, eight, nine, zero, minus, plus, space, shift, colBeat;
boolean[] keyP = new boolean[128];
boolean[] keyT = new boolean[128];
int keyNum;
public void keyPressed() {  
  /////////////////////////////// RIG KEY FUNCTIONS ////////////////////////
  if (key == 'n') visualisation = (visualisation+1)%11;             //// STEP FORWARD TO NEXT RIG VIZ+ 1)&1
  if (key == 'b') visualisation -=1;             //// STEP BACK TO PREVIOUS RIG VIZ
  if (visualisation <0) visualisation = 10;
  if (key == 'm') rigBgr = (rigBgr+1)%7;         //// CYCLE THROUGH RIG BACKGROUNDS


  //int mod = (swap % steps + steps) % steps; /// code to always produce a positive number to allow reverse wrap around


  /////////////////////////////// ROOF KEY FUNCTIONS ////////////////////////
  if (key == 'h') visualisation1 = (visualisation1+1)%11;             //// STEP FORWARD TO NEXT RIG VIZ
  if (key == 'g') visualisation1 -= 1;   //// STEP BACK TO PREVIOUS RIG VIZ
  if (visualisation1 <0) visualisation1 = 10;
  if (key == 'j') roofBgr = (roofBgr+1)%7;        //// CYCLE THROUGH ROOF BACKGROUNDS


  if (key == ',') {                            //// CYCLE THROUGH FUNCS
    fc = (fc+1)%fct.length; 
    fc1 = (fc1+1)%fct.length;
  }  
  if (key == '.') {                            //// CYCLE THROUGH ALPHAS
    af = (af+1)%alph.length; 
    af1 = (af1+1)%alph.length;
  }   
  if (key == 'c') co = (co+1)%col.length;      //// CYCLE THROUGH COLORS
  if (key == 'v') co1 = (co1+1)%col.length;


  //// SHIFT KEY TO SWITCH BETWEEN TOGGLE or HOLD key functions
  if (key == CODED) {
    switch(keyCode) {
    case SHIFT:
      shift = !shift;
      break;
    }
  }
  /// loops to change keyP[] to true when pressed, false when released to give hold control
  for (int i = 32; i <=63; i++) {
    // char n = char(i);
    if (key == PApplet.parseChar(i)) keyP[i]=true;
    if (keyP[i]) {
      fill(300);
      textSize(18);
      textAlign(CENTER);
      text("key press: " + i, ix, 20); //// ptint onscreen ASCII number for key pressed
      //println(i);  //// print key
    }
  }
  for (int i = 91; i <=127; i++) {
    //  char n = char(i);
    if (key == PApplet.parseChar(i)) keyP[i]=true;
    if (keyP[i]) {
      fill(300);
      textSize(18);
      textAlign(CENTER);
      text("key press: " + i, ix, 20);
      //println(i);  //// print key
    }
  }

  for (int i = 32; i <=63; i++) {
    //  char n = char(i);
    if (key == PApplet.parseChar(i)) {
      keyT[i] = !keyT[i];
      println(key, i, keyT[i]);  //// print key
    }
  }

  for (int i = 91; i <=127; i++) {
    if (key == PApplet.parseChar(i)) {
      keyT[i] = !keyT[i];
      println(key, i, keyT[i]);  //// print key
    }
  }


  /// switches for function  control
  switch(key) {
  case 'q':
    info = !info;
    break;
  case 't':
    test = !test;
    break;
  case 'w':
    work = !work;
    break;
  case '[':
    hold = !hold;
    break;
  case ']':
    hold1 = !hold1;
    break;
  case ';':
    colFlip = !colFlip;
    break;
  case 'l':
    colBeat = !colBeat;
    break;
  }
  /// TOGGLE KEYS active when SHIFT is FALSE ////
  if (!shift) {
    switch(key) {
    case '1':
      one = !one;
      break;
    case '2':
      two = !two;
      break;
    case '3':
      three = !three;
      break;
    case '4':
      four = !four;
      break;
    case '5':
      five = !five;
      break;
    case '6':
      six = !six;
      break;
    case '7':
      seven = !seven;
      break;
    case '8':
      eight = !eight;
      break;
    case '9':
      nine = !nine;
      break;
    case '0':
      zero = !zero;
      break;
    case '-':
      minus = !minus;
      break;
    case '+':
      plus = !plus;
      break;
    case ' ':
      space = !space;
      break;
    }
  } else if (shift) {
    one = false;
    two = false;
    three = false;
    four = false;
    five = false;
    six = false;
    seven = false;
    eight = false;
    nine = false; 
    zero = false;
    space = false;
    minus = false;
    plus = false;
  }
}

public void keyReleased()
{
  /// loop to change key[] to false when released to give hold control
  for (int i = 32; i <=63; i++) {
    char n = PApplet.parseChar(i);
    if (key == n) keyP[i]=false;
  }
  for (int i = 91; i <=127; i++) {
    char n = PApplet.parseChar(i);
    if (key == n) keyP[i]=false;
  }
} 

///////////////////////////////////////// MIDI FUNCTIONS ///////////////////////////////////////////
float pad[] = new float[64];
public void noteOn(Note note) {
  println();
  println("BUTTON: ", +note.pitch);

  if (+note.pitch > 99 && +note.pitch < 104) pad[0] = (+note.pitch);
  if (+note.pitch > 108 && +note.pitch < 112) pad[0] = (+note.pitch);
  if (+note.pitch > 103 && +note.pitch < 108)  pad[1] = (+note.pitch);
  if (+note.pitch > 112 && +note.pitch < 117)  pad[1] = (+note.pitch);
  if (+note.pitch > 108 && +note.pitch < 111)  pad[2] = (+note.pitch);
  if (+note.pitch > 112 && +note.pitch < 115)  pad[3] = (+note.pitch);
}

public void controllerChange(int channel, int number, int value) {
  cc[number] = map(value, 0, 127, 0, 1);
  println();
  println("CC: ", number, "....", map(value, 0, 127, 0, 1));
  //spd = 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// PAUSE ///////////////////////////////////////////////////
float pause;
public void pause(int pau) {
  if (beatDetect.isOnset()) {
    pause = 0;
    time[4] = millis()/1000;
  }
  if (beatDetect.isOnset() == false) {
    if (millis()/1000 - time[4] >= pau) {
      pause +=1;
      time[4] = millis()/1000;
    }
  }
  if (pause > 0) {
    beat  = d;
    for (int i = 0; i < beats.length; i++) if (beatCounter % 4 == i)  beats[i] = d;
    pulz = e;
    if (millis()/1000 - time[5] >= 4) {
      beatCounter +=1%120;
      time[5] = millis()/1000;  //// also update the stored time
    }
  }
}

/////////////////////////////////////////////// OSKP///////////////////////////////////////////
float osk1, oskP, timer1;
public void oskPulse() {
  osk1 += 0.01f;                ////// length of time for loop /////
  timer1 = log(map (sin(osk1), -1, 1, 0.1f, 10000));
  timer1 += timer1;
  oskP = map(sin(timer1), -1, 1, 0, 1);
}
////////////////////////////////////////////// NOIZE ////////////////////////////////////////////
float noize, noize1, noize2, noize12;
public void noize() {
  float dx = millis() * 0.0001f;
  float z = millis() * 0.0001f;

  noize = sin(10 * (noise(dx * 0.01f, 0.01f, z) - 0.4f));
  noize2 = cos(10 * (noise(dx * 0.01f, 0.01f, z) - 0.4f));
  noize1 = map(noize, -1, 1, 0, 1);
  noize12 = map(noize1, -1, 1, 1, 0);
}
/* KEY FUNCTIONS
 
 'c' toggles on/off the info
 'b' steps the animations backwards 
 'n' steps the animations forward
 'm' changes the backgrounds
 ',' changes the function
 '.' changes the alpha
 '/' changes the colours
 'l' toggle colour change on beat
 ';' toggle swaps color c/flash
 ''' swaps color c/flash - press and hold
 '\' color swap
 '[' viz hold - stops the timer counting down for next viz change
 ']' color hold - stops the timer counting down for next colour change
 'q' toggles mouse coordiantes and moveable dot
 't' toggle TEST - cycles though all colours to test LEDs
 'w' toggle WORK LIGHTS - all WHITE 
 'a' toggle colorSteps - changes colour in pairs or not
 
 */
public void frameRateInfo(float x, float y) {
  textAlign(LEFT);
  textSize(18);
  fill(360);  
  text(PApplet.parseInt(frameRate) + " fps", x, y); // framerate display
  //frame.setTitle(int(frameRate) + " fps"); //framerate as title
}

public void onScreenInfo() {
  toggleInfo(width/2+90, 20);
  fill(300+(60*stutter));
  textAlign(RIGHT);
  text("RIG PANEL", mw-5, my-(mh/2)+20);
  text("ROOF PANEL", mw+rw-5, ry-(rh/2)+20);

  textAlign(LEFT);
  textSize(18);
  fill(360);
  float x = 10;
  float y = 20;

  /////// SHOW INFO ABOUT CURRENT ARRAY SELECTION ////
  fill(flash, 300);
  textSize(18);
  y = h-sh+20;
  ///////////// rig info
  text("viz: " + visualisation, x, y);
  text("bkgrnd: " + rigBgr, x, y+20);
  text("func's: " + fc + " / " + fc1, x+100, y);
  text("alph's: " + af + " / " + af1, x+100, y+20);
  //////////// roof info
  x = x+rx-(rw/2);
  text("viz1: " + visualisation1, x, y);
  text("bkgrnd1: " + roofBgr, x, y+20);

  //if (keyT[115]) {
  /////////// info about PLAYWITHYOURSELF functions
  y = 20;
  x=width-5;
  textAlign(RIGHT);
  fill(c, 300);
  ///// NEXT VIZ IN....
  String sec = nf(PApplet.parseInt(vizTime - (millis()/1000 - time[0])) % 60, 2, 0);
  int min = PApplet.parseInt(vizTime - (millis()/1000 - time[0])) /60 % 60;
  text("next viz in: "+min+":"+sec, x, y);
  ///// NEXT COLOR CHANGE IN....
  sec = nf(PApplet.parseInt(colTime - (millis()/1000 - time[3])) %60, 2, 0);
  min = PApplet.parseInt(colTime - (millis()/1000 - time[3])) /60 %60;
  text("next color in: "+ min+":"+sec, x, y+20);
  text("c-" + co + "  " + "flash-" + co1, x, y+40);
  text("counter: " + counter, x, y+60);
  //}

  ////////////// booth lights info
  textSize(12);
  textAlign(CENTER);
  text("BOOTH", boothX+10, boothY-10);
  fill(flash);
  text("DIG", boothX+10, boothY+20);

  /////  LABLELS to show what PVectors are what 
  textSize(12);
  textAlign(CENTER);
  //for (int i = 1; i <ball.length; i+=3) text("BALL", ballP[i].x+12, int(ballP[i].y) +15);   /// Ball Position info
  for (int i = 0; i <shld.length; i++) text(i, shldP[i][0].x, shldP[i][0].y+4);                 /// SHIELD POSTION INFO

  // moving rectangle displays alpha and functions
  textSize(12);
  textAlign(CENTER);
  text("FUNCTION", (mw-50)/2, h-10);
  rect((mw-50)*func, height-15, 10, 10); // moving rectangle to show current function
  fill(c, 360);
  text("ALPHA", (mw-50)/2, h);
  rect((mw-50)*bt, height-5, 10, 10); // moving rectangle to show current alpha

  // sequencer
  fill(flash);
  int dist = 20;
  y = 80;
  for (int i = 0; i<(ih-sh)/dist-(y/dist); i++) if (PApplet.parseInt(beatCounter%(dist-(y/dist))) == i) rect(ix-(iw/2)+10, 10+i*dist+y, 10, 10);
  fill(c, 100);
  for (int i = 0; i<(ih-sh)/dist-(y/dist); i++) rect(ix-(iw/2)+10, 10+i*dist+y, 10, 10);

  // beats[] visulization
  y=10;
  dist = 15;
  for (int i = 0; i<beats.length; i++) {
    if (beatCounter % 4 == i) fill(flash1,360);
    else fill(c1, 100);
    rect((ix-(iw/2)+10)+(beats[i]*100), y+(dist*i), 10, 10);
    
    // rects to show pulzs[]
    //    if (beatCounter % 4 == i) fill(clash1);
    //    else fill(clashed, 100);
    //    rect((ix-(iw/2)+10)+(pulzs[i]*100), y+(dist*i), 10, 10);

    fill(c1, 65);
    rect((ix-(iw/2)+10)+(50), y+(dist*i), 110, 10);
  }

  // text to show no audio
  if (pause >0) { 
    textAlign(RIGHT);
    textSize(20); 
    fill(300);
    text("NO AUDIO!!", w-5, h-2);
  }

  if (info) {
    /////// DISPLAY MOUSE COORDINATES
    textAlign(LEFT);
    fill(c);  
    ellipse(mouseX, mouseY+10, 5, 5);
    textSize(14);
    text( " x" + mouseX + " y" + mouseY, mouseX, mouseY );
  }
}

public void colorInfo() {
  ///// RECTANGLES TO SHOW BEAT DETECTION AND CURRENT COLOURS /////
  y = height-5;

  //fill(flash);
  //textAlign(RIGHT);
  //text("STEPS "+ colStepper, mw-2, y-20);

  fill(col[co1]);          
  rect(mw-20, y, 10, 10);        // rect to show CURRENT color FLASH 
  fill(col[(co1+1)%col.length]);
  rect(mw-7.5f, y, 10, 10);       // rect to show NEXT color FLASH1
  fill(col[co]);
  rect(mw-20, y-10, 10, 10);     // rect to show CURRENT color C 
  fill(col[(co+1)%col.length]);
  rect(mw-7.5f, y-10, 10, 10);    // rect to show NEXT color C 
  fill(360, beat*360); 
  rect(mw-32.5f, y, 10, 10);      // rect to show B alpha
  fill(360, bt*360); 
  rect(mw-32.5f, y-10, 10, 10);   // rect to show CURRENT alpha
}

public void toggleInfo(float xpos, float ypos) {
  textSize(18);
  textAlign(CENTER);
  float x = 20;
  float y = 0;

  //if (one)    text("1", xpos+(x*1), ypos+(y*1));
  //if (two)    text("2", xpos+(x*2), ypos+(y*2));
  //if (three)  text("3", xpos+(x*3), ypos+(y*3));
  //if (four)   text("4", xpos+(x*4), ypos+(y*4));
  //if (five)   text("5", xpos+(x*5), ypos+(y*5));
  //if (six)    text("6", xpos+(x*6), ypos+(y*6));
  //if (seven)  text("7", xpos+(x*7), ypos+(y*7));
  //if (eight)  text("8", xpos+(x*8), ypos+(y*8));
  //if (nine)   text("9", xpos+(x*9), ypos+(y*9));
  //if (zero)   text("0", xpos+(x*10), ypos+(y*10));

  //if (shift)   text("SHIFT!!", xpos+(x*6), ypos+(y*1));
  textAlign(RIGHT);
  y = 180;
  x = w-5;
  fill(50);
  if (hold)  fill(300+(60*stutter));
  text("[ = VIZ HOLD", x, y);
  fill(50);
  if (hold1) fill(300+(60*stutter));
  text("] = COL HOLD", x, y+20);
  y +=20;
  fill(50);
  if (keyT[107]) fill(300+(60*stutter));
  text("K = shimmer", x, y+40);
  fill(50);
  if (!colSwap) fill(300+(60*stutter));
  text("| = color swap", x, y+60);
  fill(50);
  if (colorFlipped) fill(300+(60*stutter));
  text("; / ' = color flip", x, y+80);
  fill(50);
  if (colBeat) fill(300+(60*stutter));
  text("L = color beat", x, y+100);
  y+=20;
  fill(50);
  if (keyT[120]) fill(300+(60*stutter));
  text("X = B/P/B2/B2", x, y+120);
  fill(50);
  if (keyT[122]) fill(300+(60*stutter));
  text("Z = viz flip", x, y+140);
}
//////////////////////////////////////// LOAD IMAGES ///////////////////////////
PImage bar1, flames; 
public void loadImages() {
  flames = loadImage("1.jpg");
  bar1 = loadImage("bar1.png");
}
//////////////////////////// AUDIO SETUP ////////////////////////////////////







Minim minim;
AudioInput in;
BeatDetect beatDetect;

public void audioSetup(int sensitivity) {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  beatDetect = new BeatDetect();
  beatDetect.setSensitivity(sensitivity);

  beatAlpha=0.2f;//this affects how quickly code adapts to tempo changes 0.2 averages
  // the last 10 onsets  0.02 would average the last 100
  weightedsum=0;
  weightedcnt=0;
  avgtime=0;
  avgvolume = 0;
}
////////////////////////////////// SETUP SKETCH DRAWING NORMALS ////////////////////////
public void drawingSetup() {
  myFont = createFont("Lucida Sans Unicode", 18);
  textFont(myFont);
  textSize(18);
  colorMode(HSB, 360, 100, 100);
  blendMode(BLEND);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  noStroke();
  strokeWeight(20);
  //hint(DISABLE_OPTIMIZED_STROKE);
}
/////////////////////// LOAD GRAPHICS FOR VISULISATIONS AND COLOR LAYERS //////////////////////////////
//import processing.core.PApplet*;
//import processing.core.PConstants*;
//import static processing.core.PConstants.*;

PGraphics vis[] = new PGraphics[9];
PGraphics bg[] = new PGraphics[7];
PGraphics colorPreview[] = new PGraphics[bg.length];
PGraphics vizPreview[] = new PGraphics[11];

PGraphics rigWindow, roofWindow, pg, infoWindow, rigColourLayer, roofColourLayer;

public void loadGraphics() {
  //////////////////////////////// VIS GRAPHICS ///////////////////
  for ( int i = 0; i< vis.length; i++ ) {
    vis[i] = createGraphics(PApplet.parseInt(mw*1.2f), PApplet.parseInt(mh*1.2f), P2D);
    vis[i].beginDraw();
    vis[i].colorMode(HSB, 360, 100, 100);
    vis[i].blendMode(ADD);
    vis[i].ellipseMode(RADIUS);
    vis[i].rectMode(CENTER);
    vis[i].imageMode(CENTER);
    vis[i].noStroke();
    vis[i].noFill();
    vis[i].endDraw();
  }

  //////////////////////////////// rig subwindow  ///////////////////
  rigWindow = createGraphics(mw, mh, P2D);
  rigWindow.beginDraw();
  rigWindow.colorMode(HSB, 360, 100, 100);
  rigWindow.imageMode(CENTER);
  rigWindow.rectMode(CENTER);
  rigWindow.endDraw();
  //////////////////////////////// rig colour layer  ///////////////////
  rigColourLayer = createGraphics(mw, mh, P2D);
  rigColourLayer.beginDraw();
  rigColourLayer.colorMode(HSB, 360, 100, 100);
  rigColourLayer.imageMode(CENTER);
  rigColourLayer.rectMode(CENTER);
  rigColourLayer.endDraw();
  //////////////////////////////// roof subwindow  ///////////////////
  roofWindow = createGraphics(mw, mh, P2D);
  roofWindow.beginDraw();
  roofWindow.colorMode(HSB, 360, 100, 100);
  roofWindow.imageMode(CENTER);
  roofWindow.rectMode(CENTER);
  roofWindow.endDraw();
  //////////////////////////////// roof colour layer  ///////////////////
  roofColourLayer = createGraphics(mw, mh, P2D);
  roofColourLayer.beginDraw();
  roofColourLayer.colorMode(HSB, 360, 100, 100);
  roofColourLayer.imageMode(CENTER);
  roofColourLayer.rectMode(CENTER);
  roofColourLayer.endDraw();
  //////////////////////////////// info subwindow  ///////////////////
  infoWindow = createGraphics(iw, ih, P2D);
  infoWindow.beginDraw();
  infoWindow.colorMode(HSB, 360, 100, 100);
  infoWindow.ellipseMode(RADIUS);
  infoWindow.imageMode(CENTER);
  infoWindow.rectMode(CENTER);
  infoWindow.endDraw();

  for ( int n = 0; n<vizPreview.length; n++) {
    vizPreview[n] = createGraphics(mw, mh, P2D);
    vizPreview[n].beginDraw();
    vizPreview[n].colorMode(HSB, 360, 100, 100);
    vizPreview[n].ellipseMode(RADIUS);
    vizPreview[n].imageMode(CENTER);
    vizPreview[n].rectMode(CENTER);
    vizPreview[n].endDraw();
  }

  //////////////////////////////// color preview  ///////////////////
  for ( int n = 0; n<colorPreview.length; n++) {
    colorPreview[n] = createGraphics(40, 40, P2D);
    colorPreview[n].beginDraw();
    colorPreview[n].colorMode(HSB, 360, 100, 100);
    colorPreview[n].ellipseMode(RADIUS);
    colorPreview[n].imageMode(CENTER);
    colorPreview[n].rectMode(CENTER);
    colorPreview[n].endDraw();
  }
  ///////////////////////////// COLOR LAYER / BG GRAPHICS ////////////////////////////
  for ( int n = 0; n<bg.length; n++) {
    bg[n] = createGraphics(mw, mh, P2D);
    bg[n].beginDraw();
    bg[n].colorMode(HSB, 360, 100, 100);
    bg[n].ellipseMode(RADIUS);
    bg[n].rectMode(CENTER);
    bg[n].imageMode(CENTER);
    bg[n].noStroke();
    bg[n].noFill();
    bg[n].endDraw();
  }
  ///////////////////////////// SHIELD CONTROL GRAPHICS /////////////////////
  pg  = createGraphics(mw, mh, P2D);
  pg.beginDraw();
  pg.colorMode(HSB, 360, 100, 100);
  pg.ellipseMode(RADIUS);
  pg.rectMode(CENTER);
  pg.imageMode(CENTER);
  pg.noStroke();
  pg.noFill();
  pg.endDraw();
}
///////////////////////////////////// LOAD GRAPHICS FOR SHADER LAYERS //////////////////////
PGraphics pass1[] = new PGraphics[9];
PGraphics blured[] = new PGraphics[9];

PShader blur;
PGraphics src;
int blury, prevblury;

public void loadShaders(int blury) {
  blur.set("blurSize", blury);
  blur.set("sigma", 10.0f);  

  src = createGraphics(mw, mh, P3D); 
  for (int i = 0; i < pass1.length; i++) {
    pass1[i] = createGraphics(PApplet.parseInt(mw*1.2f), PApplet.parseInt(mh*1.2f), P2D);
    pass1[i].noSmooth();
    pass1[i].imageMode(CENTER);
    pass1[i].beginDraw();
    pass1[i].noStroke();
    pass1[i].endDraw();
  }
  for (int i = 0; i < blured.length; i++) {
    blured[i] = createGraphics(PApplet.parseInt(mw*1.2f), PApplet.parseInt(mh*1.2f), P2D);
    blured[i].noSmooth();
    blured[i].beginDraw();
    blured[i].imageMode(CENTER);
    blured[i].noStroke();
    blured[i].endDraw();
  }
}
/////////////////////////////////// DONUT ////////////////////////////////////
public PGraphics donut(int n, int col, float stroke, float sz, float sz1, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    vis[n].ellipse(0, 0, 2+(sz)/2, 2+(sz1)/2);
    vis[n].popMatrix();
    vis[n].endDraw();

    blur.set("horizontalPass", 0);
    pass1[n].beginDraw();            
    pass1[n].shader(blur); 
    pass1[n].imageMode(CENTER);
    pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
    pass1[n].endDraw();
    blur.set("horizontalPass", 1);
    blured[n].beginDraw();            
    blured[n].shader(blur);  
    blured[n].imageMode(CENTER);
    blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
    blured[n].endDraw();
  } 
  catch (AssertionError e) {
    println(e);
    println(visualisation, col, stroke, sz, sz1, func, alph);
  }
  return blured[n];
}

public PGraphics flowerOfLife(int n, int col, float stroke, float sz, float sz1, float alph, float alph1) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].strokeWeight(-stroke);
    vis[n].stroke(360*alph);
    vis[n].pushMatrix();
    vis[n].blendMode(LIGHTEST);
    vis[n].translate(vis[n].width*0.08f, vis[n].height*0.08f);
    for (int i =0; i<9; i+=2) vis[n].ellipse(shld[i][0].x, shld[i][0].y, 2+(sz)/2, 2+(sz1)/2);
    vis[n].stroke(360*alph1);
    for (int i =1; i<9; i+=2) vis[n].ellipse(shld[i][0].x, shld[i][0].y, 2+(sz)/2, 2+(sz1)/2);

    vis[n].ellipse(shld[3][0].x, shld[3][0].y, 2+(sz)/2, 2+(sz1)/2);
    vis[n].ellipse(shld[5][0].x, shld[5][0].y, 2+(sz)/2, 2+(sz1)/2);

    vis[n].stroke(360*alph1);

    vis[n].ellipse(shld[1][2].x, shld[1][2].y, 2+(sz)/2, 2+(sz1)/2);
    vis[n].ellipse(shld[4][2].x, shld[4][2].y, 2+(sz)/2, 2+(sz1)/2);
    vis[n].ellipse(shld[7][2].x, shld[7][2].y, 2+(sz)/2, 2+(sz1)/2);
    vis[n].blendMode(NORMAL);

    vis[n].popMatrix();
    vis[n].endDraw();

    blur.set("horizontalPass", 0);
    pass1[n].beginDraw();            
    pass1[n].shader(blur); 
    pass1[n].imageMode(CENTER);
    pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
    pass1[n].endDraw();
    blur.set("horizontalPass", 1);
    blured[n].beginDraw();            
    blured[n].shader(blur);  
    blured[n].imageMode(CENTER);
    blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
    blured[n].endDraw();
  } 
  catch (AssertionError e) {
    println(e);
    println(visualisation, col, stroke, sz, sz1, func, alph);
  }
  return blured[n];
  //return vis[n];
}

/////////////////////////////////// DONUT ////////////////////////////////////
public PGraphics solidNut(int n, int col, float stroke, float sz, float sz1, float alph) {
  //
  try {
    vis[n].beginDraw();
    vis[n].colorMode(HSB, 360, 100, 100);
    vis[n].background(0);
    vis[n].noStroke();
    vis[n].fill(360*alph);
    vis[n].pushMatrix();
    vis[n].translate(vis[n].width/2, vis[n].height/2);
    vis[n].ellipse(0, 0, 2+(sz)/2, 2+(sz1)/2);
    vis[n].popMatrix();
    vis[n].endDraw();

    blur.set("horizontalPass", 0);
    pass1[n].beginDraw();            
    pass1[n].shader(blur); 
    pass1[n].imageMode(CENTER);
    pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
    pass1[n].endDraw();
    blur.set("horizontalPass", 1);
    blured[n].beginDraw();            
    blured[n].shader(blur);  
    blured[n].imageMode(CENTER);
    blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
    blured[n].endDraw();
  } 
  catch (AssertionError e) {
    println(e);
    println(visualisation, col, stroke, sz, sz1, func, alph);
  }
  return blured[n];
}

//////////////////////////// STAR ////////////////////////////////
public PGraphics star(int n, float wide, float high, float rotate, int col, float stroke, float alph) {
  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].pushMatrix();
  vis[n].strokeWeight(-stroke);
  vis[n].stroke(360*alph);
  vis[n].noFill();
  vis[n].translate(vis[n].width/2, vis[n].height/2);
  vis[n].rotate(radians((40*tweakSlider)+rotate));
  vis[n].ellipse(0, 0, wide, high);
  vis[n].rotate(radians(120));
  vis[n].ellipse(0, 0, wide, high);
  vis[n].rotate(radians(120));
  vis[n].ellipse(0, 0, wide, high);
  vis[n].popMatrix();
  vis[n].noStroke();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();            
  pass1[n].shader(blur);  
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw();            
  blured[n].shader(blur);  
  blured[n].image(pass1[n], blured[n].width/2, blured[n].height/2);
  blured[n].endDraw();    
  return blured[n];
}

public PGraphics lockIt(int n, float func, float func1, float alph, float alph1) {

  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].imageMode(CENTER);
  vis[n].pushMatrix();
  vis[n].translate(vis[2].width/2, vis[2].height/2);

  float rotate = func;
  float rotBeats = 12;
  if (beatCounter%rotBeats < rotBeats/4) rotate = -func;
  if (beatCounter%rotBeats < rotBeats/8) rotate = -func1;

  float end = radians(-12.5f);
  float start = radians(0);

  float  big = 50+(func*100);
  float small = 90;
  float add = smallShieldRad*4;
  if (func > 0.8f) add = 0;

  float y = (shldP[0][2].y)-my;             // distance from center

  vis[n].rotate(end);
  vis[n].rotate(radians(rotate*(360/4+start)));

  vis[n].rotate(radians(360/9*3));
  vis[n].tint(col1, 360*alph1);
  vis[n].image(bar1, 0, y, big, 20+add);
  vis[n].tint(col1, 360*alph);

  vis[n].image(bar1, 00, bigShieldRad/2, small, bigShieldRad*1.2f);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph1);
  vis[n].image(bar1, 0, y, big, 20+add);
  vis[n].tint(col1, 360*alph);

  vis[n].image(bar1, 0, bigShieldRad/2, small, bigShieldRad*1.2f);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph1);
  vis[n].image(bar1, 0, y, big, 20+add);
  vis[n].tint(col1, 360*alph);

  vis[n].image(bar1, 0, bigShieldRad/2, small, bigShieldRad*1.2f);


  y = (shldP[0][0].y)-my;
  //vis[n].rotate(radians(360/9));
  vis[n].tint(col1, 360*alph);
  //vis[n].image(bar1, 0, y, big/2, medShieldRad*1.8);
  vis[n].image(bar1, 0, y, small, medShieldRad*1.8f);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph);
  //vis[n].image(bar1, 0, y, big/2, medShieldRad*1.8); 
  vis[n].image(bar1, 0, y, small, medShieldRad*1.8f);

  vis[n].rotate(radians(360/3));
  vis[n].tint(col1, 360*alph);
  //vis[n].image(bar1, 0, y, big/2, medShieldRad*1.8);
  vis[n].image(bar1, 0, y, small, medShieldRad*1.8f);

  vis[n].noTint();
  vis[n].popMatrix();
  vis[n].endDraw();
  return vis[n];
}

float rot1;
public PGraphics spin(int n, float rad, float func, float rotate, float alph) {
  if (beatCounter%2 == 1) rot1 = (rot1 +2) % 360;
  if (beatCounter%2 == 0) rot1 = (rot1 -2) % 360;
  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].pushMatrix();
  vis[n].translate(vis[2].width/2, vis[2].height/2);
  vis[n].rotate(radians(rot1*rotate));
  vis[n].strokeWeight(-20);
  vis[n].stroke(360*alph);
  vis[n].arc(0, 0, rad, rad, radians(0), radians(90*func), OPEN);
  vis[n].arc(0, 0, rad, rad, radians(180), radians(180+(90*func)), OPEN);
  vis[n].stroke(360*alph);
  vis[n].arc(0, 0, rad, rad, radians(90), radians(90+(90*func)), OPEN);
  vis[n].arc(0, 0, rad, rad, radians(270), radians(270+(90*func)), OPEN);
  vis[n].popMatrix();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();   
  pass1[n].shader(blur); 
  pass1[n].imageMode(CENTER);
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw(); 
  blured[n].imageMode(CENTER);
  blured[n].shader(blur);  
  blured[n].image(vis[n], blured[n].width/2, blured[n].height/2);
  blured[n].endDraw();    

  return vis[n];
}

////////////////////////////////////////////////////////////// PULSE ///////////////////////////////////////////
public PGraphics pulse(int n, int col1, int col2, float alph) {
  float r = red(color(col1));
  float g = green(color(col1));
  float b = blue(color(col1));

  float r1 = red(color(col2));
  float g1 = green(color(col2));
  float b1 = blue(color(col2));

  float t = millis() * 0.0004f;
  randomSeed(0);
  src.beginDraw();
  src.noStroke();
  src.colorMode(RGB);
  src.background(r, r, b);
  src.fill(255, 200);
  src.blendMode(NORMAL);

  src.directionalLight(r, r, r, -1, 0, 0.4f);
  src.directionalLight(g/1.5f, g/1.5f, g/1.5f, -1, 0, 0.2f);
  src.directionalLight(b1/1.5f, b1/1.5f, b1/1/5, -1, 1, 0);
  src.directionalLight(r1, g1, b1, 1, 1, 0);

  // Lots of rotating cubes
  for (int i = 0; i < 80; i++) {
    src.pushMatrix();

    // This part is the chaos demon.
    src.translate(map(noise(random(1000), t * 0.07f), 0, 1, -width, width*2), 
      map(noise(random(1000), t * 0.07f), 0, 1, -height, height*2), 0);

    // Progression of time
    src.rotateX(t * 0.4f + randomGaussian());
    src.rotateY(t * 0.0122222f + randomGaussian());

    // But of course.
    src.box(height * abs(0.2f + 0.2f * randomGaussian()));
    src.popMatrix();
  }

  // Separable blur filter
  src.colorMode(HSB, 360, 100, 100);
  src.endDraw();

  imageMode(CENTER);

  blur.set("horizontalPass", 0);
  pass1[n].imageMode(CENTER);

  pass1[n].beginDraw();   
  pass1[n].shader(blur);  
  pass1[n].image(src, pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();

  blur.set("horizontalPass", 1);
  blured[n].beginDraw();            
  blured[n].shader(blur);  
  blured[n].imageMode(CORNER);
  blured[n].image(pass1[n], 0, 0);
  blured[n].endDraw();   
  colorMode(HSB, 360, 100, 100);
  return blured[n];
}

public PGraphics rush(int n, int col, int col1, float wide, float high, float func, float alph) {
  float moveA;
  float strt = wide/2;
  if (beatCounter % 8 > 3)  moveA = strt+((mw-(strt*2))*func);
  else  moveA = mw-strt-((mw-(strt*2))*func);

  vis[n].beginDraw();
  vis[n].background(0);
  vis[n].noStroke();
  vis[n].fill(col, 360*alph);
  vis[n].rect( moveA, vis[n].height/2, wide, high);
  vis[n].noFill();
  vis[n].endDraw();

  blur.set("horizontalPass", 0);
  pass1[n].beginDraw();            
  pass1[n].shader(blur);  
  pass1[n].image(vis[n], pass1[n].width/2, pass1[n].height/2);
  pass1[n].endDraw();
  blur.set("horizontalPass", 1);
  blured[n].beginDraw();            
  blured[n].shader(blur);  
  blured[n].image(pass1[n], 0, 0, vis[n].width/2, vis[n].height/2);
  blured[n].endDraw();    
  return blured[n];
}

ControlFrame cf;

float vizTimeSlider, colorSwapSlider, colorTimerSlider, bgDimmer, boothDimmer, digDimmer, roofPulse, backParsSlider, backDropSlider, cansSlider, movesSlider;
float cansPulse, cans1Pulse, cans2Pluse, cans3Pulse, speedSlider, tweakSlider, testSlider3, blurSlider, rigDimmer, multiViz1, multiViz2, multiViz3;
float shimmerSlider, beatSlider, boothParSlider, backParSlider, secondVizSlider, roofDimmer;

class ControlFrame extends PApplet {

  int controlW, controlH;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    controlW=_w;
    controlH=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(controlW, controlH);
  }

  public void setup() {
    surface.setAlwaysOnTop(true);
    surface.setLocation(surfacePositionX, surfacePositionY+parent.height);

    //drawingSetup();
    myFont = createFont("Lucida Sans", 18);
    textFont(myFont);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    imageMode(CENTER);
    noStroke();

    cp5 = new ControlP5(this);

    // slider colours
    int act = 0xff07E0D3;
    int act1 = 0xff00FC84;
    int bac = 0xff370064;
    int bac1 = 0xff225F01;
    int slider = 0xffE07F07;
    int slider1 = 0xffE0D607;
    /// font for slider info
    //PFont pfont = createFont("Abadi MT Condensed Light", 16, true);  // what the fuk?!
    //ControlFont font = new ControlFont(pfont);

    float x = 10;
    float y = 20;
    int wide = 80;           // x size of sliders
    int high = 14;           // y size of slider
    float row = high +4;     // distance between rows
    float clm = 210;         // distance between coloms

    //////////////////////////////// FIRST COLOUM OF SLIDERS
    cp5.addSlider("vizTimeSlider") // name used throughout sketch to link to slider
      .plugTo(parent, "vizTimeSlider")
      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.5f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("colorTimerSlider")
      .plugTo(parent, "colorTimerSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.45f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("colorSwapSlider")
      .plugTo(parent, "colorSwapSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.9f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    ////////////////////////////////// 2nd coloum of sliders
    cp5.addSlider("boothDimmer")
      .plugTo(parent, "boothDimmer")
      .setPosition(x+clm, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.32f)    // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("digDimmer")
      .plugTo(parent, "digDimmer")

      .setPosition(x+clm, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.32f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("rigDimmer")
      .plugTo(parent, "rigDimmer")
      .setPosition(x+clm, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(dimmer) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;

    ////////////// set x to start of 2nd panel
    //x = x+rx-(rw/2);
    x +=clm+clm;

    ///////////////////////////////// third coloum of sliders
    cp5.addSlider("bgDimmer")
      .plugTo(parent, "bgDimmer")

      .setPosition(x, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(1)    // start value []ppof slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("shimmerSlider")
      .plugTo(parent, "shimmerSlider")
      .setPosition(x, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.3f) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("beatSlider")
      .plugTo(parent, "beatSlider")
      .setPosition(x, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0.85f) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;

    /////////////////////////////// FOURTH coloum of sliders
    cp5.addSlider("secondVizSlider")
      .plugTo(parent, "secondVizSlider")
      .setPosition(x+clm, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(1) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    cp5.addSlider("tweakSlider")
      .plugTo(parent, "tweakSlider")
      .setPosition(x+clm, y+row)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0) // start value of slider
      .setColorActive(act) 
      .setColorBackground(bac) 
      .setColorForeground(slider) 
      ;
    cp5.addSlider("blurSlider")
      .plugTo(parent, "blurSlider")
      .setPosition(x+clm, y+row*2)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(1) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;


    clm+=clm;
    /////////////////////////////// FITH coloum of sliders
    cp5.addSlider("roofDimmer")
      .plugTo(parent, "roofDimmer")
      .setPosition(x+clm, y)
      .setSize(wide, high)
      //.setFont(font)
      .setRange(0, 1)
      .setValue(0) // start value of slider
      .setColorActive(act1) 
      .setColorBackground(bac1) 
      .setColorForeground(slider1) 
      ;
    //cp5.addSlider("tweakSlider")
    //  .plugTo(parent, "tweakSlider")
    //  .setPosition(x+clm, y+row)
    //  .setSize(wide, high)
    //  //.setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0) // start value of slider
    //  .setColorActive(act) 
    //  .setColorBackground(bac) 
    //  .setColorForeground(slider) 
    //  ;
    //cp5.addSlider("blurSlider")
    //  .plugTo(parent, "blurSlider")
    //  .setPosition(x+clm, y+row*2)
    //  .setSize(wide, high)
    //  //.setFont(font)
    //  .setRange(0, 1)
    //  .setValue(1) // start value of slider
    //  .setColorActive(act1) 
    //  .setColorBackground(bac1) 
    //  .setColorForeground(slider1) 
    //  ;


    ///////////////////////////////// FIFTH coloum of sliders
    //cp5.addSlider("multiViz1")
    //  .setPosition(x+clm+clm+clm+clm, y)
    //  .setSize(wide, high)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0)    // start value of slider
    //  .setColorActive(act) 
    //  .setColorBackground(bac) 
    //  .setColorForeground(slider) 
    //  ;
    //// extra slider f0r pulse
    //cp5.addSlider("multiViz2")
    //  .setPosition(x+clm+clm+clm+clm, y+row)
    //  .setSize(wide, high)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0) // start value of slider
    //  .setColorActive(act1) 
    //  .setColorBackground(bac1) 
    //  .setColorForeground(slider1) 
    //  ;
    //cp5.addSlider("multiViz3")
    //  .setPosition(x+clm+clm+clm+clm, y+row*2)
    //  .setSize(wide, high)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0) // start value of slider
    //  .setColorActive(act) 
    //  .setColorBackground(bac) 
    //  .setColorForeground(slider) 
    //  ;


    /////////////////////// test sliders to change variables vertical 
    //cp5.addSlider("speedSlider")
    //  .setPosition(5, 130)
    //  .setSize(high, wide)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0.5) // start value of slider
    //  .setColorActive(act1) 
    //  .setColorBackground(bac1) 
    //  .setColorForeground(slider1) 
    //  ;
    //cp5.addSlider("tweakSlider")
    //  .setPosition(5, 230)
    //  .setSize(high, wide)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0.2) // start value of slider
    //  .setColorActive(act) 
    //  .setColorBackground(bac) 
    //  .setColorForeground(slider) 
    //  ;
    //cp5.addSlider("testSlider3")
    //  .setPosition(5, 530)
    //  .setSize(high, wide)
    //  .setFont(font)
    //  .setRange(0, 1)
    //  .setValue(0.5) // start value of slider
    //  .setColorActive(act1) 
    //  .setColorBackground(bac1) 
    //  .setColorForeground(slider1) 
    //  ;
  }

  public void draw() {
    background(0);
    fill(c);
    rect(ww, 0, w, 2);


    //if (keyT[97]) {
    //  y = 80;
    //  x=20;
    //  textAlign(LEFT);
    //  fill(c, 300);
    //  ///// NEXT VIZ IN....
    //  String sec = nf(int(vizTime - (millis()/1000 - time[0])) % 60, 2, 0);
    //  int min = int(vizTime - (millis()/1000 - time[0])) /60 % 60;
    //  text("next viz in: "+min+":"+sec, x, y);
    //  ///// NEXT COLOR CHANGE IN....
    //  sec = nf(int(colTime - (millis()/1000 - time[3])) %60, 2, 0);
    //  min = int(colTime - (millis()/1000 - time[3])) /60 %60;
    //  text("color change in: "+ min+":"+sec, x, y+20);
    //  text("c-" + co + "  " + "flash-" + co1, x, y+40);
    //  text("counter: " + counter, x, y+60);
    //}
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "pickle_shields_august_19" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
