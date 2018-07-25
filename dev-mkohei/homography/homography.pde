PImage pimg;

void setup() {
  size(displayWidth, displayHeight);
  
  pimg = loadImage("../../src/test-imgs/test3.jpg");
}

void draw() {
  background(0);
  image(pimg, 0, 0);
  
  println(mouseX, mouseY);
  
  //(x,y)=
  //(158,103),(549,103),
  //(190,295),(520,300)
  
}


  
  