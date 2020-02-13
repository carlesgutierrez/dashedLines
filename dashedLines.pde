////////////////////////////////////////////////////////////////////////
//sublines of HLine
class SinLines {

  //dash intermitente mod 2
  float dashCounter;
  float yPos = 0;
  int alphaColor = 200; 
  int alphaStroke = 0; 
  int w; // Width of entire wave 
  float initXspacing = 25;//50; // High number LOW sinus resolution, less RECTS , Lower number -> HIGH sinus resolution MORE RECTS ---- TODO Low Screen Resolutions will make Crash the app, set 5 or 10 instead 100 or 50!!!!!!!!! ----
  float xspacing = initXspacing;
  float velTheta;// = random(0.04,0.1);

  float theta;// = random(0,1);//0.0; // Start angle at 0 
  //float amplitude = 75.0; // Height of wave
  float period = 500.0; // How many pixels before the wave repeats 
  float dx; // Value for incrementing X, a function of period and xspacing 
  float[] xvalues; // Using an array to store height values for the wave 

  int lineType = -1;

  SinLines(float _yPos, float _s, int _id) {
    yPos = _yPos;
    if(bLogVerbose)println("constructor SinLines y = "+str(yPos));
    if(bLogVerbose)println("constructor SinLines xspacing = "+str(xspacing));

    w = width;//+16;
    dx = (TWO_PI / period) * xspacing;
    if(bLogVerbose)println("constructor SinLines dx = "+str(dx));
    xvalues = new float[w/int(xspacing)];
    theta = 0;
    velTheta = _s;
    lineType = _id;
  }

  //better method find dash XY points 
  void updateDashLine() {
  }

  //we do a wave and save points when sin Y is -1 or +1
  void calcWave() {
    // Increment theta (try different values for 'angular velocity' here 
    theta += velTheta;//0.02; 
    float deltaTheta = 0;//map(mouseX, 0, width, 0,50);
    // For every x value, calculate a y value with sine function 
    float x = theta - deltaTheta; 
    for (int i = 0; i < xvalues.length; i++) { 
      xvalues[i] = x*xspacing;
      x+=dx;
    }

    xspacing = map(mouseX, 0, width, 10, 100);
    dx = (TWO_PI / period) * xspacing;
    float myPeriod = map(xspacing, 10, 100, 5, 500);
    period = myPeriod;//500.0;

    //updateInsideParticle();
  } 

  void drawDashedLine(int i) {

    //noFill();
    //line dash 
    if (lineType==1) {
      fill(color1, alphaColor);
      stroke(color1, alphaStroke);
    } else if (lineType ==2) {
      fill(color2, alphaColor);
      stroke(color2, alphaStroke);
    } else if (lineType ==3) {
      fill(color3, alphaColor);
      stroke(color3, alphaStroke);
    } else {
      fill(color3, alphaColor);
      stroke(grayColor, alphaStroke);
    }

    //dashed lines
    //if(i>0 && (i%2==0))line(xvalues[i-1],yPos, xvalues[i], yPos);

    //continous lines
    //if(i>0)line(xvalues[i-1],yPos, xvalues[i], yPos);

    //creative round rects
    //if(i>0 && (i%2==0))rect(xvalues[i-1],yPos, xvalues[i] - xvalues[i-1],yPos, hRect);
    //if(i>0 && (i%2==0))rect(xvalues[i-1],yPos, xvalues[i] - xvalues[i-1], yPos, 100);

    //fixed h rect
    //perspective effect
    //if(i>0 && (i%2==0))rect(xvalues[i-1],yPos, xvalues[i] - xvalues[i-1], hRect);

    //rotating cube

    pushMatrix();
    if (i>0 && (i%2==0))translate(-xvalues[i]+(xvalues[i] - xvalues[i-1])*.5, -yPos); //width*.5,height*.5);
    if (i>0 && (i%2==0))rotate(theta*.001);//dx);
    if (i>0 && (i%2==0))translate(xvalues[i]+(xvalues[i] - xvalues[i-1])*.5, yPos); //width*.5,height*.5);
    if (i>0 && (i%2==0))rect(xvalues[i-1], yPos, xvalues[i] - xvalues[i-1], hRect);
    popMatrix();
  }

  void renderWave() {
    
    /*
    // Shame lienes but moving at Y as circles or .... 
    for (int x = 0; x < xvalues.length; x++) { 
      ellipse(x*xspacing, yPos+xvalues[x], 16, 16);
    } */

    dashCounter = 0;
    int xLength = xvalues.length;
    for (int i = 0; i < xLength; i++) { 

      if (i != 0) {
        drawDashedLine(i);
      } else {
        //The head?
        //print("==0");
      }

      //head
      if (velTheta <0) {
        if (i==0) {
          if (lineType ==1)stroke(color1);
          else if (lineType ==2)stroke(color2);
          else if (lineType ==3)stroke(color3);
          else stroke(grayColor);

          fill(bkColor);
          if(bDrawHeads)ellipse(xvalues[i], yPos, 40, 40);
        }
      } else {
        if (i == xvalues.length-1) {
          if (lineType ==1)stroke(color1);
          else if (lineType ==2)stroke(color2);
          else if (lineType ==3)stroke(color3);
          else stroke(grayColor);

          fill(bkColor);
          if(bDrawHeads)ellipse(xvalues[i], yPos, 40, 40);
        }
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
//main line class
class HLine { 

  int idTypeLine = int(random(0, 3));
  float xpos, ypos, speed;
  SinLines mySinLines;

  HLine (float x, float y, float s) { 
    xpos = x;
    float dir = random(1);
    if (dir>0.5) speed = s*1;
    else speed = s*-1;
    if (y>=0)ypos = y;
    else {
      ypos = random(10, height - 10);
    }

    //large = random(100, 400);
    mySinLines = new SinLines(ypos, speed, idTypeLine);
    if(bLogVerbose)print("mySinLines ->");
    if(bLogVerbose)println("ypos = "+ str(ypos) + " speed = " + str(speed) + " idTypeLine = " + str(idTypeLine));
  } 

  void update() {
    //my dashed sin line
    mySinLines.calcWave();
    mySinLines.renderWave();
    
    //if(bLogVerbose)print("update ->");
    //if(bLogVerbose)println("mySinLines.xvalues.length = "+ str(mySinLines.xvalues.length));
    

    if (speed>0) {
      if (mySinLines.xvalues[0] > width) {
        mySinLines.theta = -mySinLines.xvalues.length*2;
      }
    } else {
      if (mySinLines.xvalues[mySinLines.xvalues.length-1] < 0) {
        mySinLines.theta = mySinLines.xvalues.length*2;
      }
    }
  }
} 




////////////////////////////////////////////////////////////////////////////////////////////////////
//Main Sketch
import codeanticode.syphon.*;
SyphonServer server;

int circleBaseSize = 512; // change this to make the touche circles bigger\smaller.
Boolean bLogVerbose = true;
Boolean bDrawHeads = false;
// Declare and construct two objects (h1, h2) from the
int numLines = 10;

HLine[] lines;
float rectAngle = 0;

///////////Colors
int blueDarkColor;
int lilaDarkColor;
//int yelowColor;
int greenCyanColor;
int grayColor;
int whiteColor;
int blackColor;
//color vars
int bkColor;
int color1, color2, color3;
float hRect;

void setupColors() {
  blueDarkColor = #3E3E59;
  lilaDarkColor = #3D1B3A;
  greenCyanColor = #75C79D;
  grayColor = #7A8582;
  whiteColor = #FFFFFF;
  blackColor = #000000;

  //bk
  bkColor = blackColor; //whiteColor; //lilaDarkColor;
  color1 = greenCyanColor;
  color2 = lilaDarkColor;
  color3 = grayColor;
}


//------------------------------
void setup() { 
  //size(32, 140); //fachada Agbar?
  size(1024, 768, P3D); 
  //fullScreen();
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  
  frameRate(30); 
  strokeWeight(4);
  setupColors();

  float yaux = height/numLines; // + height/numLines*0.5;
  hRect=int(yaux);
  print("yaux = ");
  print(yaux);
  print("hRect = ");
  println(hRect);

  lines = new HLine[numLines];

  for (int i=0; i<numLines; i++) {
    float y = i * height/numLines + height/float(numLines)*0.5;//50+ i*50;
    print("y = ");
    println(y);
    lines[i] = new HLine(1, y, random(0.04, 0.1));//random(0,1000), random(2.0, 10)
  }
  
  println("Setup Done");
} 

//-----------------------------
void draw() { 
  background(bkColor, 10); 

  for (int i=0; i<numLines; i++) {
    lines[i].update();
  }
 
  server.sendScreen();
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
//////////
 //Android Interaction Touch
 
 import android.view.MotionEvent;   
 
 void infoCircle(float x, float y, float siz, int id) {
 // What is drawn on sceen when touched. 
 float diameter = circleBaseSize * siz;
 noFill();
 ellipse(x, y, diameter, diameter);
 fill(0,255,0);
 ellipse(x, y, 8, 8); 
 text( ("ID:"+ id + " " + int(x) + ", " + int(y) ), x-128, y-64); 
 } 
 
 
 //----------------------------------------------------------------------------------------- 
 // Override Processing's surfaceTouchEvent, which will intercept all 
 // screen touch events. This code only runs when the screen is touched. 
 public boolean surfaceTouchEvent(MotionEvent me) { 
 // Number of places on the screen being touched: 
 int numPointers = me.getPointerCount(); 
 for(int i=0; i < numPointers; i++) {
 int pointerId = me.getPointerId(i);
 float x = me.getX(i);
 float y = me.getY(i);
 float siz = me.getSize(i);
 infoCircle(x, y, siz, pointerId);
 } 
 // If you want the variables for motionX/motionY, mouseX/mouseY etc. 
 // to work properly, you'll need to call super.surfaceTouchEvent(). 
 return super.surfaceTouchEvent(me);
 }
 
 */
