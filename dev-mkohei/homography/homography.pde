import processing.video.*;
Capture cam;


PImage pimg;

void setup() {
  size(displayWidth, displayHeight);
  
  pimg = loadImage("../../src/test-imgs/test3.jpg");
  
  String[] cameras = Capture.list();
  for (String str: cameras) println(str);
  cam = new Capture(this, cameras[3]);
  cam.start();
}

void draw() {
  background(0);
  if (cam.available() == true) {
    cam.read();
    //cam.resize(648, 486);
  }
  
  image(cam, 0, 0);
  
  println(mouseX, mouseY);
  
  //(x,y)=
  //(158,103),(549,103),
  //(190,295),(520,300)
  
}


  
  