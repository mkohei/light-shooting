// 数字の順番にポインタを合わせるゲーム
// 時間を競う？

import processing.video.*;
Capture cam;

final int camW=640, camH=426;

//PImage bg;
int[] bg, diff; 

// state
final int STATE_CALIB = -1;
final int STATE_WAIT = 0;
final int STATE_PLAY = 1;
final int STATE_RESULT = 2;
int state;

// parameters
//int H = 1080, W = 1920;
int H=900, W=1600;

// game parameters
final int END = 20;
//final int targetR = 60; // or 30
final int targetR = 50;
final int targetD = targetR * 2;

float starttime, endtime;

int[][] targetMass;
int targetCnt;
float pointX, pointY;


// -----------------
// ----- setup -----
// -----------------
void setup() {
  //size(1920, 1080);
  size(1600, 900);
  
  String[] cameras = Capture.list();
  for (String str: cameras) println(str);
  cam = new Capture(this, cameras[3]);
  //cam = new Capture(this, 648, 486);
  //cam = new Capture(this);
  
  cam.start(); 
  
  reset();
}

void reset() {
  //state = STATE_WAIT;
  state = STATE_CALIB;
  
  targetMass = new int[H/targetD][W/targetD];
  int y,x;
  for (int i=0; i<END; i++) {
    do {
      y = int(random(H/targetD)-1);
      x = int(random(W/targetD)-1);
    } while (targetMass[y][x] != 0);
    targetMass[y][x] = i+1; 
  }
  
  targetCnt = 0;
}



// ----------------
// ----- draw -----
// ----------------
void draw() {
  if (cam.available() == true) {
    cam.read();
    //cam.resize(648, 486);
  }
  
  if (state==STATE_WAIT) drawWait();
  else if (state==STATE_PLAY) drawPlay();
  else if (state==STATE_RESULT) drawResult();
  else if (state==STATE_CALIB) drawCalib();
  else ;
}

void drawCalib() {
  background(0);
  //image(cam, 0, 0, cam.width, cam.height);
  //bg = get(0, 0, cam.width, cam.height);
  bg = cam.pixels;
  if (bg != null) {
    diff = new int[bg.length];
    println(bg[1000]);
  }
}

void drawWait() {
  background(0);
  
  fill(0,0,255);
  
  textAlign(CENTER, CENTER);
  
  textSize(targetR/2);
  text("Pless anything key to start", width/2, height/2);
  
}

void drawPlay() {
  background(0);
  
  updateTargetCnt();
  drawTargets();
  
  println();
  println("x,y", pointX, pointY); 
  fill(0,255,0);
  noStroke();
  ellipse(pointX, pointY, 10, 10);
  
}

void drawTargets() {
  color c = color(0, 0, 255);
  
  stroke(c);
  strokeWeight(5);
  
  textAlign(CENTER, CENTER);
  textSize(targetR);
  for (int y=0; y<H/targetD; y++) {
    for (int x=0; x<W/targetD; x++) {
      if (targetMass[y][x] == 0) ;
      else if (targetMass[y][x] > targetCnt) {
        noFill();
        ellipse(targetR + x*targetD, targetR + y*targetD, targetD, targetD);
        fill(c);
        text(targetMass[y][x], targetR + x*targetD, targetR + y*targetD);
      } 
    }
  }
}

// TODO:
void getPoint() {
  float TH = cos(PI/4);
  
  //image(cam, 0, 0);
  
  loadPixels();

  //diff
  int idx;
  int cnt=0;
  float dr,dg,db,ave,len;
  float xx=0,yy=0;
  //for (int y=0; y<cam.height; y++) {
  for (int y=250; y<670; y++) {
    //for (int x=0; x<cam.width; x++) {
      for (int x=300; x<1120; x++) {
  
      idx = y*cam.width + x;
      
      // color vec
      dr = red(cam.pixels[idx]) - red(bg[idx]);
      dg = green(cam.pixels[idx]) - green(bg[idx]);
      db = blue(cam.pixels[idx]) - blue(bg[idx]);
      // zero-mean
      ave = (dr + dg + db) / 3;
      dr -= ave;
      dg -= ave;
      db -= ave;
      // normalize
      len = sqrt( pow(dr,2)+pow(dg,2)+pow(db,2) );
      dr /= len;
      dg /= len;
      db /= len;
      
      // ideal red vector
      float a1=1-1/3, a2=-1/3, a3=-1/3;
  
      // dot
      float dot = a1*dr + a2*dg + a3*db;
      float a = map(dot, -1, 1, 0, 255);
      //pixels[y*width+x] = color(a);
      if (dot >= TH && len>30) {
        //set(x,y,color(0,255,0));
        pixels[y*width+x] = color(0,255,0);
        xx+=x;
        yy+=y;
        cnt++;
      }
    }
  }
  if (cnt>0) {
    float a=2.33392818E+00, b=-2.99221562E-01, c=-6.49849389E+02;
    float d=-5.55801837E-03, e=2.22876537E+00, f=-5.64377859E+02;
    xx/=cnt;
    yy/=cnt;
    pointX = xx*a + yy*b + c;
    pointY = xx*d + yy*e + f; 
  } else {
    pointX=-1;
    pointY=-1;
  }
  print(cnt);
  //updatePixels();
}

void updateTargetCnt() {
  getPoint();
  for (int y=0; y<H/targetD; y++) {
    for (int x=0; x<W/targetD; x++) {
      if (targetMass[y][x] == targetCnt+1) {
        
        if (pow(x*targetD+targetR-pointX,2)+pow(y*targetD+targetR-pointY,2)<pow(targetR,2)) targetCnt++;
        if (targetCnt==END) {
          endtime = millis();
          state = STATE_RESULT;
        }
        
      }
    }
  }
}




void drawResult() {
  background(0);
  
  fill(0,0,255);
  
  textAlign(CENTER, CENTER);
  textSize(targetR);
  text(endtime-starttime + " [msec]", width/2, height/2);
  
  textSize(targetR/2);
  text("Pless anything key to reset", width/2, height/2 + targetD);
 
}

void keyTyped() {
  if (state==STATE_WAIT) state=STATE_PLAY;
  else if (state==STATE_RESULT) reset();
  else if (state==STATE_CALIB) state=STATE_WAIT;
}