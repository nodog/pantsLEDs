class Plasmer implements MovieMode {
  static final String MOVIEFILENAME = "plasmer.bin";
  static final int NFRAMES = 4000;
  static final int FRAMEDELAY = 2;

  float xc;
  float yc;
  int timeDisplacement;
  int pixelSize;
  float ft;
  float f1, f2;
  float fx1, fx2, fx3;
  float fy1, fy2, fy3;
  float frd1, fgr1, fbl1;
  float frd2, fgr2, fbl2;
  float a1, a2, a3, a4, a5, a6, at;

  PGraphics vBuff;
  
  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, JAVA2D);
    vBuff.colorMode(RGB, MAXCOLOR);
    //vBuff.stroke(MAXCOLOR);
    //vBuff.fill(MAXCOLOR);
    //vBuff.strokeWeight(2);
    vBuff.smooth();

    ft = random( 2 );
    f1 = random( 1 );
    f2 = random( 1 );
    frd1 = random( 2 );
    fgr1 = random( 2 );
    fbl1 = random( 2 );
    frd2 = random( 2 );
    fgr2 = random( 2 );
    fbl2 = random( 2 );
    fy1 = random( 2 );
    fy2 = random( 2 );
    fy3 = random( 2 );
    fx1 = random( 2 );
    fx2 = random( 2 );
    fx3 = random( 2 );
    a1 = 2*(int) random(2) - 1.0;
    a2 = 2*(int) random(2) - 1.0;
    a3 = 2*(int) random(2) - 1.0;
    a4 = 2*(int) random(2) - 1.0;
    a5 = 2*(int) random(2) - 1.0;
    a6 = 2*(int) random(2) - 1.0;
    at = random( 3 ) + 1.5;
    
  }
  
  void update() { 
    timeDisplacement = frameCount;
    
    vBuff.loadPixels();
  
    vBuff.fill(0, 16);
    vBuff.rect(0, 0, PLEDWIDTH, PLEDHEIGHT);
 
    //float t = sin(TWO_PI * ft * 1.0 * timeDisplacement / NFRAMES);
    float t = at*timeDisplacement/NFRAMES;

    // Plasma algorithm
    for (int i = 0; i < PLEDWIDTH; i++)
    {
      for (int j = 0; j < PLEDHEIGHT; j++)
      {
        float x = (1.0*i)/PLEDWIDTH;
        float y = (1.0*j)/PLEDHEIGHT;
        float phi = (sin(TWO_PI * (x + f1 * t) ) - sin(TWO_PI * (y - f2 * t)));
        float t2 = (sin(TWO_PI * fx3 * t));
        float rd = MAXCOLOR*cos(TWO_PI*(a1*fx1*x - frd1 * t2 + phi))*cos(TWO_PI*(a4*fy1*y + frd2 * t - phi));
        float gr = MAXCOLOR*cos(TWO_PI*(a2*fx2*x + fgr1 * t - phi))*cos(TWO_PI*(a5*fy2*y - fgr2 * t2 + phi));
        float bl = MAXCOLOR*cos(TWO_PI*(a3*fx3*x - fbl1 * t2 + phi))*cos(TWO_PI*(a6*fy3*y + fbl2 * t - phi));
        
        vBuff.pixels[i+j*PLEDWIDTH] = color(rd/2+MAXCOLOR/2, gr/2+MAXCOLOR/2, bl/2+MAXCOLOR/2);
      }
    }   
    vBuff.updatePixels();
  }

  void draw() {
    //vBuff.fill(MAXCOLOR);
    //vBuff.rect(6, 5, 3, 2);
    vBuff.loadPixels();
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = vBuff.pixels[j*PLEDWIDTH + i];
      }
    }
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
