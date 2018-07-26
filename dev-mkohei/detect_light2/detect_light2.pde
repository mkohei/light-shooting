PImage pimg;
int imgW=640, imgH=350;

void setup() {
  //size(displayWidth, displayHeight);
  //size(640, 426);
  size(1280, 700);
  
  pimg = loadImage("../../src/test-imgs/test3.jpg");
  println(pimg.width, pimg.height);
  
  pimg = pimg.get(0, 0, imgW, imgH);
  
  noLoop();
}



void draw() {
  background(0);
  image(pimg, 0, 0);
  
  loadPixels();
  
  int pidx, ridx;
  for (int y=0; y<imgH; y++) {
    for (int x=0; x<imgW; x++) {
      pidx = y*pimg.width + x;
      ridx = (y*width) + (x+pimg.width);
      
      //if (isRed(pimg.pixels[pidx])) pixels[ridx] = color(255);
      pixels[ridx] = color(map(isRed(pimg.pixels[pidx]), -1, 1, 0, 255));
    }
  }
  updatePixels();
}


//boolean isRed(int c) {
float isRed(int c) {
  float TH = cos(PI/8);
  
  float r=red(c), g=green(c), b=blue(c);
  // zero-mean
  float ave = (r+g+b) / 3;
  r -= ave;
  g -= ave;
  b -= ave;
  // normalize
  float len = sqrt( pow(r,2)+pow(g,2)+pow(b,2) );
  r /= len;
  g /= len;
  b /= len;
  
  // ideal red vector
  float a1=1-1/3, a2=-1/3, a3=-1/3;
  
  // dot
  float dot = a1*r + a2*g + a3*b;
  print(dot);
  
  //return dot >= TH;
  return dot;
}