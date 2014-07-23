class WhoreDueler implements MovieMode {
  static final String MOVIEFILENAME = "dueler01.bin";
  static final int NFRAMES = 3000;
  static final int FRAMEDELAY = 2;
  static final int MINMONOCOUNTER = 20;
  static final int MAXMONOCOUNTER = 200;
  
  color curr1Color;
  color curr2Color;
  color targ1Color;  
  color targ2Color;  
  int counter1;
  int counter2;
  int mode;
  
  //WhoreDueler() {
  //  WhoreDueler(0);
  //}
  
  WhoreDueler(int mode) {
    this.mode = mode;
  }

  void setup() {
    curr1Color = color(0);
    curr2Color = color(0);
    chooseNewTarget1();
    chooseNewTarget2();
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
        if (0 == mode) {
          pantsLEDs[i][j] = lerpColor(curr1Color, curr2Color, 1.0 * j / PLEDHEIGHT);
        } else {
          pantsLEDs[i][j] = lerpColor(curr1Color, curr2Color, 1.0 * i / PLEDWIDTH);
        }          
        //if (j < PLEDHEIGHT/2) {
        //  pantsLEDs[i][j] = curr1Color;
        //} else {
        //  pantsLEDs[i][j] = curr2Color;
        //} 
      }
    }      
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
