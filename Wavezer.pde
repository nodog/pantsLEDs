class Wavezer implements MovieMode {
  static final String MOVIEFILENAME = "wavezer.bin";
  static final int NFRAMES = 1600;
  static final int FRAMEDELAY = 5;

  float phi1;
  float modPhi1;
  float modPhiFreq1;
  float modScale1;

  float phi2;
  float modPhi2;
  float modPhiFreq2;
  float modScale2;
  
  PGraphics vBuff;
  
  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, JAVA2D);
    vBuff.colorMode(RGB, MAXCOLOR);
    //vBuff.stroke(MAXCOLOR);
    //vBuff.fill(MAXCOLOR);
    vBuff.strokeWeight(2);
    vBuff.smooth();

    modScale1 = 40;
    modPhi1 = 0;
    modPhiFreq1 = 0.05 * 360;
    phi1 = 0;
    modScale2 = 50;
    modPhi2 = 0;
    modPhiFreq2 = 0.07 * 360;
    phi2 = 0;
  }
  
  void update() { 
    vBuff.background( 0 );
                
    modPhi1 = modPhi1 + modPhiFreq1 / frameRate; 
    float myVal1 = sin(radians(modPhi1));
    phi1 += modScale1 * myVal1; 
    phi1 = phi1%360;
  
    modPhi2 = modPhi2 + modPhiFreq2 / frameRate; 
    float myVal2 = sin(radians(modPhi2));
    phi2 += modScale2 * myVal2; 
    phi2 = phi2%360;
  
    //vBuff.fill(255);
    for (int x = 0; x < PLEDWIDTH; x++ )
    {
      float amp = PLEDHEIGHT / 2 - 0.5;
      float theta1 = map(x, 0, PLEDWIDTH,  0, 360+(180*myVal1));
      float theta2 = map(x+1, 0, PLEDWIDTH, 0, 360+(180*myVal1));
      float y1 = amp * sin(radians(theta1 + phi1));
      float y2 = amp * sin(radians(theta2 + phi1));
    
      float theta3 = map(x, 0, PLEDWIDTH,  0, 360+(180*myVal2));
      float theta4 = map(x+1, 0, PLEDWIDTH, 0, 360+(180*myVal2));
      float y3 = amp * sin(radians(theta3 + phi2 ));
      float y4 = amp * sin(radians(theta4 + phi2 ));
    
      float eqOffset = PLEDHEIGHT / 2 - 0.5;
      vBuff.stroke(MAXCOLOR, 0, 0);
      vBuff.line(x, (int) y1 + eqOffset, x + 1, (int) y2 + eqOffset);

      vBuff.stroke(0, 0, MAXCOLOR);    
      vBuff.line(x, (int) y3 + eqOffset, x + 1, (int) y4 + eqOffset);
 
    }
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
