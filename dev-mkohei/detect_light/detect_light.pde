final static int COLOR_RED    =1;
final static int COLOR_GREEN  =2;
final static int COLOR_BLUE   =3;
final static int COLOR_YELLOW =4;
final static int COLOR_CYAN   =5;
final static int COLOR_MAGENTA=6;
final static int COLOR_WHITE  =7;
final static int COLOR_BLACK  =0;


PImage pimg;
int imgW=640, imgH=350;

void setup() {
  //size(displayWidth, displayHeight);
  //size(640, 426);
  size(1280, 700);
  
  pimg = loadImage("../../src/test-imgs/test3.jpg");
  println(pimg.width, pimg.height);
  
  pimg = pimg.get(0, 0, imgW, imgH);
  
  image(pimg, 0, 0);
  
  noLoop();
}

void draw() {
  background(0);
  image(pimg, 0, 0);
  
  loadPixels();
  float r, g, b;
  for (int y=0; y<imgH; y++) {
    for (int x=0; x<imgW; x++) {
      int idx = y*imgW + x;
      
      // extract
      r = red  (pimg.pixels[idx]);
      g = green(pimg.pixels[idx]);
      b = blue (pimg.pixels[idx]);
      
      // draw
      // origin | red
      // green  | blue
      pixels[(y+0)   *width+(x+imgW)] = color(r);
      pixels[(y+imgH)*width+(x+0)   ] = color(g);
      pixels[(y+imgH)*width+(x+imgW)] = color(b);
      /*
      int ccode = whatColor(pimg.pixels[idx]);
      if (ccode==COLOR_RED)   pixels[(y+0)   *width+(x+imgW)] = color(255);
      if (ccode==COLOR_GREEN) pixels[(y+imgH)*width+(x+0)   ] = color(255);
      if (ccode==COLOR_BLUE)  pixels[(y+imgH)*width+(x+imgW)] = color(255);
      */
    }
  }
  updatePixels();
}



int whatColor(int c) {
  float r=red(c), g=green(c), b=blue(c);
  boolean R,G,B;
  
  // TODO: threshold
  R = r > 127;
  G = g > 127;
  B = b > 127;
  
  if      ( R & !G & !B) return COLOR_RED;
  else if (!R &  G & !B) return COLOR_GREEN;
  else if (!R & !G &  B) return COLOR_BLUE;
  else if ( R &  G & !B) return COLOR_YELLOW;
  else if (!R &  G &  B) return COLOR_CYAN;
  else if ( R & !G &  B) return COLOR_MAGENTA;
  else if ( R &  G &  B) return COLOR_WHITE;
  else if (!R & !G & !B) return COLOR_BLACK;
  return COLOR_BLACK;
}