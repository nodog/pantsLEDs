class MonoRoller implements MovieMode {
  static final String MOVIEFILENAME = "monoroll.bin";
  static final int NFRAMES = 3000;
  static final int FRAMEDELAY = 5;
  static final int MINMONOCOUNTER = 20;
  static final int MAXMONOCOUNTER = 200;
  
  color currMonoColor;       // current color for monochrome rolling
  color targMonoColor;       // target color for monochrome rolling  
  int monoCounter;           // counter for monochrome rolling 

  void setup() {
    currMonoColor = color(0);
    chooseNewTarget();
  }
  
  void update() {
    monoCounter -= 1;
    if (monoCounter < 1) {
      chooseNewTarget();
    }
    float deltaRed = (red(targMonoColor) - red(currMonoColor)) / monoCounter; 
    float deltaGreen = (green(targMonoColor) - green(currMonoColor)) / monoCounter; 
    float deltaBlue = (blue(targMonoColor) - blue(currMonoColor)) / monoCounter;
    currMonoColor = color(
          red(currMonoColor) + deltaRed, 
          green(currMonoColor) + deltaGreen, 
          blue(currMonoColor) + deltaBlue); 
  }

  void draw() {
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = currMonoColor;
      }
    }      
  }
  
  void chooseNewTarget() {
    targMonoColor = color(random(MAXCOLOR), random(MAXCOLOR), random(MAXCOLOR));
    monoCounter = (int) random(MINMONOCOUNTER, MAXMONOCOUNTER);
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
