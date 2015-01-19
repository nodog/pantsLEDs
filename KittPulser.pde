class KittPulser implements MovieMode {
  static final String MOVIEFILENAME = "kittpls1.bin";
  static final int NFRAMES = 8000;
  static final int FRAMEDELAY = 6;
  static final int NCOLORS = 6;
  static final int FADEALPHA = MAXCOLOR/4;

  PGraphics vBuff;

  ArrayList<Pulse> pulses = new ArrayList<Pulse>();
  color[] colors = new color[NCOLORS]; 

  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT);
    vBuff.beginDraw();
    vBuff.colorMode(RGB, MAXCOLOR);
    vBuff.smooth();
    vBuff.endDraw();
    
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
    
  void update() {
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
    
    int i;
    int j;
    int myState;
    float y;
    float rate;
    color pulseColor;
    
    Pulse() {
    }
 
    void setup(int i) {
      this.i = i;
      y = random(PLEDHEIGHT);
      newRate();
      pulseColor = chooseColor((int) random(MAXCOLORTHEME) + 1);
    }
 
    void newRate() {
      rate = random(0.5, 1) * (2 * ((int) random(2)) - 1);
    }
 
    void update() {
      if (((y + rate) > 0) && ((y + rate) < (PLEDHEIGHT))) {
        y += rate;        
      } else {
        rate = -1.0 * rate;
      }
      if (random(100) < 1) {      
        pulseColor = chooseColor((int) random(MAXCOLORTHEME) + 1);
        newRate();
      }
    }
    
    void draw() {
      //for (int k = 0; k < PLEDHEIGHT; k++ ) {
        //vBuff.pixels[iGray(i, k)] = color(0);
        //pantsLEDs[i][k] = color(0);
      //}
      j = (int) y;
      vBuff.pixels[iGray(i, j)] = color(pulseColor);
      //pantsLEDs[i][j] = color(pulseColor);
      vBuff.updatePixels();
    }
  }
}
