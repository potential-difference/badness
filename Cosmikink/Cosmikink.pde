WLED[] lovel = new WLED[1];
WLED wled,wled2;
//WLED[] hals = new WLED[5];
PImage img, mappingImg;

int w, ww, h, hh;
//import codeanticode.syphon.*;

//SyphonClient client;

void setup()
{
  size(1280, 720, P2D);
  w = width;
  h = height;
  ww = w >> 1;  // half of width
  hh = h >> 1;  // half of height

  surface.setAlwaysOnTop(true);
 
  // List Syphon Clients
 // println("Available Syphon servers:");
 // println(SyphonClient.listServers());
  
  // Create syhpon client to receive frames
  // from the first available running server: 
  //client = new SyphonClient(this);
  
  mappingImg = loadImage("cosmikink.png");
  
  //hals[0] = new WLED(this, "192.168.8.11",21324);
  //hals[1] = new WLED(this, "192.168.8.12",21324);
  //hals[2] = new WLED(this, "192.168.8.13",21324);
  //hals[3] = new WLED(this, "192.168.8.14",21324);
  //hals[4] = new WLED(this, "192.168.8.15",21324);
  
  wled = new WLED(this, "192.168.8.11", 21324);

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
    //void ledEllipse(int index, int count, float x, float y, float xArc, float yArc, float angle)
 
  // BOTTOM CENTER MAPPING //
  wled.ledEllipse(0, 10, 837, 560, 7, 7, 360);
  wled.ledEllipse(10, 20, 782, 575, 14, 14, 360);
  wled.ledEllipse(30, 126, 640, 582, 95, 25, 360);
  wled.ledEllipse(156, 20, 497, 575, 14, 14, 360);
  wled.ledEllipse(176, 10, 442, 560, 7, 7, 360);

  // LEFT MIDDLE MAPPING //
  wled.ledEllipse(200, 10, 303, 447, 7, 7, 360);
  wled.ledEllipse(210, 20, 289, 407, 14, 14, 360);
  wled.ledEllipse(230, 44, 282, 340, 18, 30, 360);
  wled.ledEllipse(274, 20, 289, 275, 14, 14, 360);
  wled.ledEllipse(294, 10, 303, 235, 7, 7, 360);
  
  // TOP CENTER MAPPING //
  wled.ledEllipse(400, 10, 837, 121, 7, 7, 360);
  wled.ledEllipse(410, 20, 782, 108, 14, 14, 360);
  wled.ledEllipse(430, 126, 640, 100, 95, 25, 360);
  wled.ledEllipse(556, 20, 497, 108, 14, 14, 360);
  wled.ledEllipse(576, 10, 442, 121, 7, 7, 360);
  
  // RIGHT MIDDLE MAPPING //
  wled.ledEllipse(600, 10, 976, 447, 7, 7, 360);
  wled.ledEllipse(610, 20, 991, 407, 14, 14, 360);
  wled.ledEllipse(630, 44, 998, 340, 18, 30, 360);
  wled.ledEllipse(674, 20, 991, 275, 14, 14, 360);
  wled.ledEllipse(694, 10, 976, 235, 7, 7, 360);
  
  // BIG GUY IN THE MIDDLE //
  wled.ledEllipse(800,150, ww, hh-20, 425, 310, 360); 


  //float ht = 10;
  //float offset_delta = (height - 20) / (hals.length);

  //for (WLED h :hals){
  //  h.ledStrip(0,110, width/2, ht, width / 110.0, 0, false);
  //  ht += offset_delta;
  //  println("offset: ",ht);
  //}
    
}

void draw()
{
    //while (!client.newFrame()){delay(1);} //don't do anything without a new frame

    background(0);  
    //image(mappingImg, 0, 0, width, height); // draw mapping image overlay
    
    /*
    if (img != null) {
      img = client.getImage(img);
      image(img, 0, 0, width, height);  
    }else{println("received empty image");}
    //  println(millis()/1000);
    */

  fill(255);
  text("FPS "+ frameRate,20,20); // print framerate to screen
  text(" x" + mouseX + " y" + mouseY, 20,40); // print mouse coords to screen
  
}
