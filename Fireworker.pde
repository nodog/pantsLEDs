class Fireworker implements MovieMode {
  static final String MOVIEFILENAME = "frwrkr1.bin";
  static final int NFRAMES = 4000;
  static final int FRAMEDELAY = 3;
  
  PGraphics vBuff;

  private class Work {
    PVector pos;
    float   age;
    float   sz;
    color   cl;
  }
  
  float maxWorkAge = 2.f;
  float workSpeed = 15.f;

  ArrayList<Work> works;

  float timeUntilNextWork;
  
  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, JAVA2D);
    vBuff.colorMode(RGB, MAXCOLOR);
    //vBuff.stroke(MAXCOLOR);
    //vBuff.fill(MAXCOLOR);
    //vBuff.strokeWeight(2);
    vBuff.smooth();
    
    works = new ArrayList<Work>();
    timeUntilNextWork = 0;
  }

  void drawWorkParticle( Work w, float d, float th ) {
    th += random( -0.2, 0.2 );
    vBuff.ellipse( w.pos.x + cos(th)*d, w.pos.y + sin(th)*d, w.sz, w.sz );
  }
  
  void update() { 
    timeUntilNextWork -= 1.f / frameRate;
    if ( timeUntilNextWork <= 0 ) {
      Work w = new Work();
      w.pos = new PVector( random( 4, PLEDWIDTH - 4 ), random( 2, PLEDHEIGHT - 2 ) );
      w.age = 0.f;
      w.sz = random( 1, 2 );
      //w.cl = chooseColor(5);
      w.cl = chooseColor();
      works.add( w );
    
      timeUntilNextWork = random( 0.25f, 1.25f );
    }
  
    vBuff.noStroke();
    vBuff.fill( 0.0, 16 );
    vBuff.rect( 0, 0, PLEDWIDTH, PLEDHEIGHT );
  
    for( int i = 0; i < works.size(); ++i ) {
      Work w = works.get(i);
      float d = workSpeed * w.age;
      vBuff.fill( w.cl );
      //peg.canvas.fill( 0, 1.f, 1.f - w.age / maxWorkAge );
      drawWorkParticle( w, d, PI/5 );
      drawWorkParticle( w, d, 2*PI/5 );
      drawWorkParticle( w, d, 3*PI/5 );
      drawWorkParticle( w, d, 4*PI/5 );
      drawWorkParticle( w, d, 5*PI/5 );
      drawWorkParticle( w, d, 6*PI/5 );
      drawWorkParticle( w, d, 7*PI/5 );
      drawWorkParticle( w, d, 8*PI/5 );
      drawWorkParticle( w, d, 9*PI/5 );
      drawWorkParticle( w, d, 10*PI/5);
    
      w.age += 1.f / frameRate;
      if ( w.age > maxWorkAge ) {
        works.remove( w );
        --i;
      }
    }
  }

  void draw() {
    vBuff.loadPixels();
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = vBuff.pixels[j*PLEDWIDTH + i];
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
