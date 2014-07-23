public class Fireflier implements MovieMode {
  static final String MOVIEFILENAME = "frflys2.bin";
  static final int NFRAMES = 8000;
  static final int FRAMEDELAY = 6;
  static final int NFLIES = 25;
  static final int FADEALPHA = MAXCOLOR/16;

  ArrayList<Firefly> flies = new ArrayList<Firefly>();
  PGraphics vBuff;
  int flyColorTheme;
  
  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, JAVA2D);
    vBuff.colorMode(RGB, MAXCOLOR);
    vBuff.noSmooth();
    vBuff.ellipseMode(CENTER);

    flyColorTheme = (int) random(MAXCOLORTHEME) + 1;
    for (int i = 0; i < NFLIES; i++) {
      Firefly f = new Firefly();
      flies.add(f);
    }
  }
  
  void update() {
    if (random(100) < 0.1) {   
      flyColorTheme = (int) random(MAXCOLORTHEME) + 1;
      for (Firefly f : flies) {
        f.chooseNewColor();
      }
    }
    for (Firefly f : flies) {
      f.update();
    }
  }
  
  void draw() {
    vBuff.fill(0, 0, 0, FADEALPHA);
    //vBuff.fill(0);
    vBuff.noStroke();
    vBuff.rect(0, 0, PLEDWIDTH, PLEDHEIGHT);

    vBuff.loadPixels();
    for (Firefly f : flies) {
      f.draw();
    }
    vBuff.updatePixels();
    vBuff.loadPixels();
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = vBuff.pixels[iGray(i, j)];
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

  //------------------------------------------------
  private class Firefly {
    float x;
    float y;
    color c;
    
    Firefly() {
      super();
      x = (SPACED ? random(PLEDWIDTH/2) : random(PLEDWIDTH));
      y = random(PLEDHEIGHT);
      chooseNewColor();
      //println( flyColorTheme + " " );
    }
    
    void chooseNewColor() {
      c = chooseColor(flyColorTheme);     
    }
    
    void update() {
      x += random(2.0) - 1.0;
      if (x < 0) {
        x += (SPACED ? PLEDWIDTH / 2 : PLEDWIDTH);
      }
      if (x > (SPACED ? PLEDWIDTH / 2 : PLEDWIDTH)) {
        x -= (SPACED ? PLEDWIDTH/2 : PLEDWIDTH);
      }
      y += random(2.0) - 1.0;
      if (y < 0) {
        y += PLEDHEIGHT;
      }
      if (y > PLEDHEIGHT) {
        y -= PLEDHEIGHT;
      }

      //println( " " + x + " " + y );
    }
    
    void draw() {
      int i = (SPACED ? 2 * (int) (x) : (int) (x));
      int j = (int) y;
      //vBuff.stroke(chooseColor(colorTheme));
      if (random(100) < 6) {
        vBuff.pixels[iGray(i, j)] = c;
      } else {
        vBuff.pixels[iGray(i, j)] = lerpColor(color(0), c, 0.1); //color(MAXCOLOR/8, MAXCOLOR/8, MAXCOLOR/8);
      }
        //vBuff.updatePixels();
      //vBuff.ellipse(x, y, 0.1, 0.1);
    }
  
  } 
}
