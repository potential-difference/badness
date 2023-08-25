package ch.bildspur.artnet.test;

import ch.bildspur.artnet.ArtNetClient;
import processing.core.PApplet;


public class ReceiveArtNetSketch extends PApplet {
    public static void main(String... args) {
        ReceiveArtNetSketch sketch = new ReceiveArtNetSketch();
        sketch.run();
    }

    public void run()
    {
        runSketch();
    }

    ArtNetClient artnet = new ArtNetClient();

    @Override
    public void settings()
    {
        size(500, 500, FX2D);
    }

    @Override
    public void setup()
    {
        artnet.start("127.0.0.1");
    }

    @Override
    public void draw() {
       byte[] data = artnet.readDmxData(0, 0);
       background(color(data[0] & 0xFF, data[1] & 0xFF, data[2] & 0xFF));
    }

    @Override
    public void stop() {
        artnet.stop();
    }


    int toRGB(byte red, byte green, byte blue)
    {
        return color(red, green, blue);
    }
}
