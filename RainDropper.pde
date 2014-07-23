class RainDropper implements MovieMode {
  static final String MOVIEFILENAME = "raindrps.bin";
  static final int NFRAMES = 3000;
  static final int FRAMEDELAY = 2;
  static final int MINBLANKCOUNTER = 20;
  static final int MAXBLANKCOUNTER = 100;
  static final int MINBUILDCOUNTER = 50;
  static final int MAXBUILDCOUNTER = 200;
  static final int MAXFALLCOUNTER = 15;

  ArrayList<Drop> drops = new ArrayList<Drop>();  

  void setup() {
    for (int i = 0; i < PLEDWIDTH; i++) {
      Drop d = new Drop();
      d.setup(i);
      drops.add(d);
    }
  }
  
  void update() {
    for (Drop d : drops) {
      d.update();
    }
  }

  void draw() {
    for (Drop d : drops) {
      d.draw();
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

  // -------------------------------------------------------------
  private class Drop {
    
    int i;
    int j;
    int myState;
    int blankCounter;
    int buildCounter;
    int fallCounter;
    color dropColor;
    
    Drop() {
    }
 
    void setup(int i) {
      this.i = i;
      j = (int) random(PLEDHEIGHT);
      myState = 0;
      blankCounter = (int) random(MINBLANKCOUNTER, MAXBLANKCOUNTER);     
    }
 
    void update() {
      switch (myState) {
        case 0: // blank
          dropColor = color(0);
          j = 0;
          blankCounter -= 1;
          if (blankCounter == 0) {
            myState = 1;
            buildCounter = (int) random(MINBUILDCOUNTER, MAXBUILDCOUNTER);     
          }
          break;
        case 1: // building
          float colRamp = ((MAXBUILDCOUNTER - buildCounter) * MAXCOLOR) / MAXBUILDCOUNTER;
          dropColor = color(0, 0, colRamp);
          j = 0;
          buildCounter -= 1;          
          if (buildCounter == 0) {
            myState = 2;
            fallCounter = MAXFALLCOUNTER;     
          }          
          break;
        case 2: // falling
          dropColor = color(MAXCOLOR/2, MAXCOLOR/2, MAXCOLOR);
          j = ((MAXFALLCOUNTER - fallCounter) * PLEDHEIGHT) / MAXFALLCOUNTER;
          fallCounter -= 1;
          if (fallCounter == 0) {
            myState = 0;
            blankCounter = (int) random(MINBLANKCOUNTER, MAXBLANKCOUNTER);     
          }         
          break;
        default:
          break;
      }
    }
    
    void draw() {
      for (int k = 0; k < PLEDHEIGHT; k++ ) {
        pantsLEDs[i][k] = color(0);
      }
      pantsLEDs[i][j] = color(dropColor);
    }
  }
}
