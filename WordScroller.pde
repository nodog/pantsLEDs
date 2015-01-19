class WordScroller implements MovieMode {
  static final String MOVIEFILENAME = "wrdscrll.bin";
  //static final int NFRAMES = 1000;
  static final int FRAMEDELAY = 2;
  PGraphics vBuff;           // used for processing drawing
  //PFont fontA;               // font used by text
  String message;
  float mWidth;
  float blankWidth = PLEDWIDTH;
  int nFrames;
  color color1, color2;

  WordScroller(String message) {
    this.message = message;
    println(message);
  }
  
  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT);
    vBuff.beginDraw();
    vBuff.colorMode(RGB, MAXCOLOR);
    PFont fontA = loadFont("Arial-Black-48.vlw");
    vBuff.textFont(fontA, 14);
    vBuff.smooth();
    //vBuff.fill(0);
    //vBuff.rect(6,5,4,3);
    mWidth = vBuff.textWidth(message);
    vBuff.endDraw();
    nFrames = 4 * ((int) mWidth);
    //println(" " + nFrames + " " + mWidth);
    color1 = chooseColor();
    color2 = chooseColor();
  }
  
  void update() {
    color interC = lerpColor(color1, color2, 1.0 * frameCount / nFrames);
    //float myRed = MAXCOLOR - ( (MAXCOLOR/2)*(frameCount%(nFrames + 1))/nFrames);
    //float myBlue = MAXCOLOR/2 + ( (MAXCOLOR/2)*(frameCount%(nFrames + 1))/nFrames);
    //vBuff.fill(myRed, 0, myBlue);
    vBuff.beginDraw();
    vBuff.fill(interC);
    vBuff.background( 10, 10, 30);
    //vBuff.text("TEAM AWESOMEPANTS", (-frameCount*0.25 + 25), 9);
    vBuff.text(message, ((-1.0 * frameCount / nFrames) * (mWidth + 1.5 * blankWidth) + blankWidth), 9);
    vBuff.endDraw();
  }

  void draw() {
    vBuff.beginDraw();
    vBuff.loadPixels();
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
    //return NFRAMES;

    return nFrames;
  }

  int getFrameDelay() {
    return FRAMEDELAY;
  }

}
