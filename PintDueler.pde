class PintDueler implements MovieMode {
  static final String MOVIEFILENAME = "dueler01.bin";
  static final int NFRAMES = 3000;
  static final int FRAMEDELAY = 2;
  static final int MINMONOCOUNTER = 20;
  static final int MAXMONOCOUNTER = 200;
  static final float SPEEDDIVISOR = 4000.0;
  
  color curr1Color;
  color curr2Color;
  color targ1Color;  
  color targ2Color;  
  int counter1;
  int counter2;
  float x1, y1;
  float x2, y2;
  float x1rate, y1rate;
  float x2rate, y2rate;

  void setup() {
    curr1Color = chooseColor();
    curr2Color = chooseColor();
    chooseNewTarget1();
    chooseNewTarget2();
    x1 = random(PLEDWIDTH);
    y1 = random(PLEDHEIGHT);
    x2 = random(PLEDWIDTH);
    y2 = random(PLEDHEIGHT);
    x1rate = random(PLEDWIDTH / SPEEDDIVISOR);
    y1rate = random(PLEDHEIGHT / SPEEDDIVISOR);
    x2rate = random(PLEDWIDTH / SPEEDDIVISOR);
    y2rate = random(PLEDHEIGHT / SPEEDDIVISOR);
  }
  
  void update() {
    counter1 -= 1;
    if (counter1 < 1) {
      chooseNewTarget1();
    }
    counter2 -= 1;
    if (counter2 < 1) {
      chooseNewTarget2();
    }
    /*
    x1 = (x1 + x1rate) % PLEDWIDTH;
    y1 = (y1 + y1rate) % PLEDHEIGHT;
    x2 = (x2 + x2rate) % PLEDWIDTH;
    y2 = (y2 + y2rate) % PLEDHEIGHT;
    */
    x1 = (PLEDWIDTH-1)*(0.22*sin(x1rate*frameCount+PI/2)+0.25);
    y1 = (PLEDHEIGHT-1)*(0.22*sin(y1rate*frameCount+PI)+0.25);
    x2 = (PLEDWIDTH-1)*(0.22*sin(x2rate*frameCount)+0.75);
    y2 = (PLEDHEIGHT-1)*(0.22*sin(y2rate*frameCount)+0.75);
    float deltaRed1 = (red(targ1Color) - red(curr1Color)) / counter1; 
    float deltaGreen1 = (green(targ1Color) - green(curr1Color)) / counter1; 
    float deltaBlue1 = (blue(targ1Color) - blue(curr1Color)) / counter1;
    curr1Color = color(
          red(curr1Color) + deltaRed1, 
          green(curr1Color) + deltaGreen1, 
          blue(curr1Color) + deltaBlue1); 
    float deltaRed2 = (red(targ2Color) - red(curr2Color)) / counter2; 
    float deltaGreen2 = (green(targ2Color) - green(curr2Color)) / counter2; 
    float deltaBlue2 = (blue(targ2Color) - blue(curr2Color)) / counter2;
    curr2Color = color(
          red(curr2Color) + deltaRed2, 
          green(curr2Color) + deltaGreen2, 
          blue(curr2Color) + deltaBlue2); 
  }

  void draw() {
    
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        float lx = 0;
        float ly = 0;
        float mx = 0;
        float my = 0;
        float xi = (float) i;
        float yj = (float) j;
        //if (x1 < x2) {
          if (xi < x1) {
            lx = dist(xi, 0, x1, 0);
            mx = dist(x1, 0, x2 - PLEDWIDTH, 0);
          } else if ((xi > x1) && (xi < x2)) {
            lx = dist(xi, 0, x1, 0);
            mx = dist(x1, 0, x2, 0);
          } else if (xi > x2) {
            lx = dist(xi, 0, x1 + PLEDWIDTH, 0);
            mx = dist(x1 + PLEDWIDTH, 0, x2, 0);            
          }
//        } else {
//          if (xi < x2) {
//            lx = dist(xi, 0, x1 - PLEDWIDTH, 0);
//            mx = dist(x1 - PLEDWIDTH, 0, x2, 0);
//          } else if ((xi > x2) && (xi < x1)) {
//            lx = dist(xi, 0, x1, 0);
//            mx = dist(x1, 0, x2, 0);
//          } else if (xi > x1) {
//            lx = dist(xi, 0, x1, 0);
//            mx = dist(x1, 0, x2 + PLEDWIDTH, 0);            
//          }
        //}
        if (y1 < y2) {
          if (yj < y1) {
            ly = dist(yj, 0, y1, 0);
            my = dist(y1, 0, y2 - PLEDHEIGHT, 0);
          } else if ((yj > y1) && (yj < y2)) {
            ly = dist(yj, 0, y1, 0);
            my = dist(y1, 0, y2, 0);
          } else if (yj > y2) {
            ly = dist(yj, 0, y1 + PLEDHEIGHT, 0);
            my = dist(y1 + PLEDHEIGHT, 0, y2, 0);            
          }
        } else {
          if (yj < y2) {
            ly = dist(yj, 0, y1 - PLEDHEIGHT, 0);
            my = dist(y1 - PLEDHEIGHT, 0, y2, 0);
          } else if ((yj > y2) && (yj < y1)) {
            ly = dist(yj, 0, y1, 0);
            my = dist(y1, 0, y2, 0);
          } else if (yj > y1) {
            ly = dist(yj, 0, y1, 0);
            my = dist(y1, 0, y2 + PLEDHEIGHT, 0);            
          }
        }
          
        //float xt1 = ((x1 < x2) ?  
        //float d2p1 = dist(xi, yj, x1, y1);
        //float d2p2 = dist(xi, yj, x2, y2);
        //float minDist = min(d2p1, d2p2);
        //float maxDist = max(d2p1, d2p2);
        pantsLEDs[i][j] = lerpColor(curr1Color, curr2Color, dist(lx,ly,0,0) / dist(mx,my,0,0) );
        //if (j < PLEDHEIGHT/2) {
        //  pantsLEDs[i][j] = curr1Color;
        //} else {
        //  pantsLEDs[i][j] = curr2Color;
        //} 
      }
    }  
    //pantsLEDs[(int)x1][(int)y1] = color(255);    
    //pantsLEDs[(int)x2][(int)y2] = color(0);    
  }
  
  void chooseNewTarget1() {
    targ1Color = color(random(MAXCOLOR), random(MAXCOLOR), random(MAXCOLOR));
    counter1 = (int) random(MINMONOCOUNTER, MAXMONOCOUNTER);
  }

  void chooseNewTarget2() {
    targ2Color = color(random(MAXCOLOR), random(MAXCOLOR), random(MAXCOLOR));
    counter2 = (int) random(MINMONOCOUNTER, MAXMONOCOUNTER);
  }

  String getMovieFileName() {
    return MOVIEFILENAME;
  }

  int getNFrames() {
    return NFRAMES;
  }

  int getFrameDelay() {
    return FRAMEDELAY;
  }

}
