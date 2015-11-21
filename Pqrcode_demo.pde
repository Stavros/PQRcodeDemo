import processing.video.*;
import pqrcode.*;

/*
 QRcode reader + URL extractor
 Generate images and a text file with url from a QRcode generator such as
 http://qrcode.kaywa.com/ and put them in this sketch's
 data folder.
 Press spacebar to read from the camera, generate an image,
 and scan for barcodes.  Press f to read from a file and scan.
 Press s for camera settings.
 Press x to save url into a text file.
 Created Oct 2012
 by Stavros Kalapothas (stavros@ubinet.gr)
 based on the code from Tom Igoe / Daniel Shiffman (http://shiffman.net/p5/qrcode-processing/)
 */

Capture video;                                 // instance of the video capture library
String statusMsg = "Waiting for an image";     // a string to return messages:

// Decoder object from prdecoder library
Decoder decoder;

void setup() {
  size(1280, 720);
  video = new Capture(this, 1280, 720);
  // Create a decoder object
  decoder = new Decoder(this);

  // Create a font with the second font available to the system:
  PFont myFont = createFont(PFont.list()[2], 14);
  textFont(myFont);  
}

// When the decoder object finishes
// this method will be invoked.
void decoderEvent(Decoder decoder) {
  statusMsg = decoder.getDecodedString(); 
}

void captureEvent(Capture video) {
  video.read();
}

// This method gets a decoded string and
// performs a string to array transformation
// in order to save it to a file.
void saveURL() {
  String urldata=decoder.getDecodedString();
  println(urldata);
  String[] url = new String[1];
  url[0] = urldata+"";
  saveStrings("url.txt", url);
}

void draw() {
  background(0);
 
  // Display video
  image(video, 0, 0);
  // Display status
  text(statusMsg, 10, height-4);
  
  // If we are currently decoding
  if (decoder.decoding()) {
    // Display the image being decoded
    PImage show = decoder.getImage();
    image(show,0,0,show.width/4,show.height/4); 
    statusMsg = "Decoding image";
    for (int i = 0; i < (frameCount/2) % 10; i++) statusMsg += ".";
   
  }

}

void keyReleased() {
  String code = "";
  // Depending on which key is hit, do different things:
  switch (key) {
  case ' ':        // Spacebar takes a picture and tests it:
    // copy it to the PImage savedFrame:
    PImage savedFrame = createImage(video.width,video.height,RGB);
    savedFrame.copy(video, 0,0,video.width,video.height,0,0,video.width,video.height);
    savedFrame.updatePixels();
    // Decode savedFrame
    decoder.decodeImage(savedFrame);
    break;
  case 'f':    // f runs a test on a file
    PImage preservedFrame = loadImage("qrcode.png");
    // Decode file
    decoder.decodeImage(preservedFrame);
    break;
  case 's':      // s opens the settings page for this capture device:
    video.settings();
    break;
  case 'x':     // x saves the url text from QRcode
    // Save URL text from  decoded image
    saveURL();
    break;
  }
}


