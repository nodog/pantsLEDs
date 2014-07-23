class Imaginer implements MovieMode {
  static final String MOVIEFILENAME = "imgnr1.bin";
  static final int NFRAMES = 3000;
  static final int FRAMEDELAY = 3;
  
  PGraphics vBuff;
  PImage img;
  float dx;
  float dy;
  float maxDX;
  float maxDY;
  float t;
  float fdx, fdy;
  float fphix, fphiy;
  float aphix, aphiy;
  float fphic;
    
  Imaginer(String fileName) {
    img = loadImage(fileName);
    println(fileName);
  }

  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, JAVA2D);
    vBuff.colorMode(HSB, MAXCOLOR);
    vBuff.smooth();
    dx = 0;
    dy = 0;
    maxDX = 2*img.width - PLEDWIDTH;
    maxDY = 2*img.height - PLEDHEIGHT;
    fdx = random(0.001,0.01);
    fdy = random(0.001,0.01);
    //fc = random(0.01,0.1);
    fphix = random(0.01,0.1);
    fphiy = random(0.01,0.1);
    aphix = random(0.01,0.1);
    aphiy = random(0.01,0.1);
    fphic = random(0.01,0.02);
  }
  
  void update() {
    t = frameCount * FRAMEDELAY / 100.0;
    float phix = aphix*sin(TWO_PI * fphix * t);
    float phiy = aphiy*cos(TWO_PI * fphiy * t);
    float aphix, aphiy;

    dx = maxDX / 2 * sin(TWO_PI * (fdx * t + phix)) + maxDX / 2;
    dy = maxDY / 2 * sin(TWO_PI * (fdy * t + phiy)) + maxDY / 2;
    vBuff.image(img, -dx, -dy, 2*img.width, 2*img.height); 
  }

  void draw() {
    float phic = MAXCOLOR / 2 * sin(TWO_PI * fphic * t) + MAXCOLOR / 2; 
    vBuff.colorMode(RGB, MAXCOLOR);
    vBuff.loadPixels();
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        // color rotate
        float[] rgbVals = new float[3];
        rgbVals = myHSBtoRGB(((hue(vBuff.pixels[j*PLEDWIDTH + i]) + phic) % MAXCOLOR),
              saturation(vBuff.pixels[j*PLEDWIDTH + i]), 
              //0.75*brightness(vBuff.pixels[j*PLEDWIDTH + i]) + 0.25*MAXCOLOR, 
              brightness(vBuff.pixels[j*PLEDWIDTH + i]), 
              MAXCOLOR);
            
        pantsLEDs[i][j] = color(rgbVals[0], rgbVals[1], rgbVals[2]);
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
