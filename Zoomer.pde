class Zoomer implements MovieMode {
  static final String MOVIEFILENAME = "zoomer2.bin";
  static final int NFRAMES = 100;
  static final int FRAMEDELAY = 2;
  static final int ZOOMMODE = 0;
  static final float MAXGLITCHCHANCE = 0;

  color [] cVector = new color[PLEDWIDTH * PLEDHEIGHT];  

  int glitchTimer;
  int glitchChance;
  int colorTheme;
  int sparseDist;
  
  void setup() {
    for (int k = 0; k < PLEDWIDTH * PLEDHEIGHT; k++ ) {
      cVector[k] = color(0);
    }        
    newZoomValues();
  }
  
  void newZoomValues() {
    glitchTimer = (int) random(600) + 200;
    glitchChance = (int) random(MAXGLITCHCHANCE);
    colorTheme = (int) random(MAXCOLORTHEME + 1);
    //colorTheme = 20;
    sparseDist = (int) random(PLEDWIDTH/8) + 1;
  }
  
  void update() {
   glitchTimer -= 1;
     //println(" " + glitchTimer + " " + colorTheme);
   if (glitchTimer == 0) {
     newZoomValues(); 
   }
   if (random(100) > glitchChance) {
     if ((frameCount / sparseDist) != ((frameCount + 1) / sparseDist)) {   
       cVector[0] = chooseColor(colorTheme);
     } else {
        cVector[0] = chooseColor(0);
     }
     for (int k = PLEDWIDTH * PLEDHEIGHT - 1; k > 0; k-- ) {
       cVector[k] = cVector[k-1];
     }    
   }
 }

  void draw() {
    if (ZOOMMODE == 1) {
      for (int i = 0; i < PLEDWIDTH; i++ ) {
        for (int j = 0; j < PLEDHEIGHT; j++ ) {
          if ((j / 2) == ((j + 1) / 2)) {
            pantsLEDs[i][j] = cVector[iGray(i, j)];
          } else {
            pantsLEDs[(PLEDWIDTH - 1) - i][j] = cVector[iGray(i, j)]; 
          }
        }
      }
    } else {
      if (SPACED) {
        for (int j = 0; j < PLEDHEIGHT; j++ ) {
          for (int i = 0; i < PLEDWIDTH; i = i + 2 ) {
            if (((i / 2) / 2) == (((i + 2) / 2) / 2)) {
              pantsLEDs[i][j] = cVector[iGray2(i/2, j)];
            } else {
              pantsLEDs[i][(PLEDHEIGHT - 1) - j] = cVector[iGray2(i/2, j)]; 
            }
          }
        }
      } else {
        for (int j = 0; j < PLEDHEIGHT; j++ ) {
          for (int i = 0; i < PLEDWIDTH; i = i + 1 ) {
            if ((i / 2) == ((i + 1) / 2)) {
              pantsLEDs[i][j] = cVector[iGray2(i, j)];
            } else {
              pantsLEDs[i][(PLEDHEIGHT - 1) - j] = cVector[iGray2(i, j)]; 
            }
          }
        }        
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
