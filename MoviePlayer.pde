import processing.video.*;

class MoviePlayer implements MovieMode {
  static final String MOVIEFILENAME = "movie2.bin";
  static final int NFRAMES = 1400;
  static final int FRAMEDELAY = 2;

  PGraphics vBuff;
  PApplet parent;
  
  String movieFile;
  Movie myMovie;

  MoviePlayer(PApplet p, String mf) {
    parent = p;
    movieFile = mf;
  }

  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, P2D);
    vBuff.smooth();
    vBuff.colorMode(RGB, MAXCOLOR);
    //vBuff.smooth();
    myMovie = new Movie(parent, movieFile);
    //myMovie = new Movie(parent, "station.mov");
    //myMovie = new Movie(parent, "dancephd2.mov");
    myMovie.loop();
    
  }
  
  void movieEvent(Movie myMovie) {
    myMovie.read();
  }
  
  void update() {
    //vBuff.image(myMovie, 0, 0, PLEDWIDTH, PLEDHEIGHT);
  }

  void draw() {
    vBuff.beginDraw();
    vBuff.image(myMovie, 0, 0, PLEDWIDTH, PLEDHEIGHT);
    vBuff.endDraw();
    vBuff.loadPixels();
    //println(red(vBuff.pixels[2]));
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = vBuff.pixels[j*PLEDWIDTH + i];
        /*
        pantsLEDs[i][j] = color(
            MAXCOLOR * red(vBuff.pixels[j*PLEDWIDTH + i]),
            MAXCOLOR * green(vBuff.pixels[j*PLEDWIDTH + i]),
            MAXCOLOR * blue(vBuff.pixels[j*PLEDWIDTH + i]));
        */
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
