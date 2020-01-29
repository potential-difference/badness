import codeanticode.syphon.*;

OPC opc;
PImage img;
SyphonClient client;

void setup()
{
  size(800, 800, P2D);
  surface.setAlwaysOnTop(true);
  frameRate(30);
  println("Press ESC to exit, d to list the connected server.\n");

  // List Syphon Clients
  println("Available Syphon servers:");
  println(SyphonClient.listServers());

  // Create syhpon client to receive frames
  // from the first available running server: 
  client = new SyphonClient(this);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Draw the pixels on the screen
  opc.showLocations(true);

  /* ledGrid(index, stripLength, numStrips, x, y, ledSpacing, stripSpacing, angle, zigzag)
   - Place a rigid grid of LEDs on the screen
   - index: Number for the first LED in the grid, starting with zero
   - stripLength: How long is each strip in the grid?
   - numStrips: How many strips of LEDs make up the grid?
   - x, y: Center location, in pixels
   - ledSpacing: Spacing between LEDs, in pixels
   - stripSpacing: Spacing between strips, in pixels
   - angle: Angle, in radians. Positive is clockwise. 0 has pixels in a strip going left-to-right and strips going top-to-bottom.
   - zigzag: true = Every other strip is reversed, false = All strips are non-reversed */

  // 64 strips going right to left, each strip 50, 25 top to bottom 25 to top
  //opc.ledStrip(0, 21, width/2 + 30, ((height/2) + 200), width / 70.0, 90, false);

  opc.ledGrid(0, 64, 16, width/2, height/2, width / 70.0, height/20.0, 11, false);
}

void draw()
{
  background(0);
  if (client.newFrame()) {
    img = client.getImage(img);
    if (img != null) {
      image(img, 0, 0, img.width, img.height);
    }
  }
}

void keyPressed() {
  if (key == ESC) {
    client.stop();
  } else if (key == 'd') {
    try {
      println("Connected to:");
      println(client.getServerName());
    } 
    catch (Exception e) {
      println(e);
    }
  }
}
