class Matrixer implements MovieMode {
  static final String MOVIEFILENAME = "matrixer.bin";
  static final int NFRAMES = 4000;
  static final int FRAMEDELAY = 4;
  static final int NCOLORS = 24;
  static final int FADEALPHA = MAXCOLOR/16;

  PGraphics vBuff;

  ArrayList<Pulse> pulses = new ArrayList<Pulse>();
  color[] colors = new color[NCOLORS]; 

  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT);
    vBuff.beginDraw();
    vBuff.colorMode(RGB, MAXCOLOR);
    vBuff.smooth();
    vBuff.endDraw();
    
    resetColors();

    if (SPACED) {
      for (int i = 0; i < PLEDWIDTH / 2; i++) {
        Pulse p = new Pulse();
        pulses.add(p);
        p.setup(i * 2);
      }
    } else {
      for (int i = 0; i < PLEDWIDTH; i++) {
        Pulse p = new Pulse();
        pulses.add(p);
        p.setup(i);
      }
    }
 }
 
 void resetColors() {
   int colTheme;
   if (random(100) < 50 ) {
     colTheme = (int) random(MAXCOLORTHEME) + 1;
   } else if (random(100) < 25) {
     colTheme = 1;
   } else {
     colTheme = 2;
   }
     
   for (int i = 0; i < NCOLORS; i++ ) {
     colors[i] = chooseColor(colTheme);
   }
 }
  
  void update() {
    if (random(100) < 0.2) {
      resetColors();
    }
    for (Pulse p : pulses) {
      p.update();
    }
  }

  void draw() {
    vBuff.beginDraw();
    vBuff.fill(0, 0, 0, FADEALPHA);
    vBuff.rect(0, 0, PLEDWIDTH, PLEDHEIGHT);

    vBuff.loadPixels();

    for (Pulse p : pulses) {
      p.draw();
    }
    
    vBuff.updatePixels();
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = vBuff.pixels[j*PLEDWIDTH + i];
      }
    }
    vBuff.endDraw();
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

  // -------------------------------------------------------------
  private class Pulse {
    
    final static int MAXNCOLPULSES = 6;
    final static int MINNCOLPULSES = 2;
    int i;
    int j;
    float [] ys;
    float [] rates;
    float rate;
    int [] pulseColorIs;
    int nColPulses;
    
    Pulse() {
    }
 
    void setup(int i) {
      this.i = i;
      nColPulses = (int) random(MINNCOLPULSES, MAXNCOLPULSES + 1);
      ys = new float[nColPulses];
      rates = new float[nColPulses];
      pulseColorIs = new int[nColPulses];
      for (int k = 0; k < nColPulses; k++) {
        ys[k] = restartPos();
        //rates[k] = newRate();
        pulseColorIs[k] = (int) random(NCOLORS);
      }
      rate = newRate();
    }
 
    float newRate() {
      return random(0.1, 1.0);
    }
    
    float restartPos() {
      return random(-2.0, PLEDHEIGHT);
    }
 
    void update() {
      for (int k = 0; k < nColPulses; k++) {
        if ((ys[k] + rate) < PLEDHEIGHT) {
          if (random(100) < 50) {
            ys[k] += rate;        
          }
        } else {
          ys[k] -= PLEDHEIGHT + random(2.0);
          //rates[k] = newRate();
          rate = newRate();
        }
      }
    }
    
    void draw() {
      for (int k = 0; k < nColPulses; k++) {
        j = (int) ys[k];
        if ((j >= 0) && (j < PLEDHEIGHT)) {
          vBuff.pixels[iGray(i, j)] = colors[pulseColorIs[k]];
        }
      }
      //vBuff.updatePixels();
    }
    
  }
}
