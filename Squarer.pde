class Squarer implements MovieMode {
  static final String MOVIEFILENAME = "squarer.bin";
  static final int NFRAMES = 3000;
  static final int FRAMEDELAY = 5;

  PGraphics vBuff;
  boolean bEvens;

  float   flipTimer;
  float   flipLength;

  float   rotation;
  float   rotationRate;

  float   changeTimer;
  float   changeInterval;

  int     rectSpacing;

  float   backgroundPulse;
  float   backgroundPulseRate;

  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT, JAVA2D);
    vBuff.colorMode(RGB, MAXCOLOR);
    //vBuff.stroke(MAXCOLOR);
    //vBuff.fill(MAXCOLOR);
    vBuff.strokeWeight(2);
    vBuff.smooth();
    
    bEvens = true;
    flipLength = 0.1f;
    flipTimer = random(flipLength);

    rotation = random(360.0);
    rotationRate = PI/8;
    changeInterval = 0.5f;
    changeTimer = random(changeInterval);
    rectSpacing = 4;
    backgroundPulse = random(360.0);
    backgroundPulseRate = PI/4;
  }
  
  void update() { 
    float dt = 0.4*1.f / frameRate;
    flipTimer += dt;
    rotation += dt * rotationRate;
    if ( rotation > TWO_PI ) {
      rotation -= TWO_PI;
    }
    changeTimer += dt; 
  
    backgroundPulse += dt * backgroundPulseRate;
    if ( backgroundPulse > TWO_PI ) {
      backgroundPulse -= TWO_PI;
    }
  
    color aColor = color(MAXCOLOR * (sin(backgroundPulse)*0.5 + 0.5f), 
          MAXCOLOR * (sin(backgroundPulse + TWO_PI*2/3)*0.5 + 0.5f), MAXCOLOR * (sin(backgroundPulse + TWO_PI/3)*0.5 + 0.5f));
    color bColor = color(
          MAXCOLOR/2 * (sin(-2*backgroundPulse + TWO_PI/3)*0.5 + 0.5f) + MAXCOLOR/2,          
          MAXCOLOR/2 * (sin(-2*backgroundPulse)*0.5 + 0.5f) + MAXCOLOR/2, 
          MAXCOLOR/2 * (sin(-3*backgroundPulse + TWO_PI*2/3)*0.5 + 0.5f) + MAXCOLOR/2 
          );
    color cColor = color(
          MAXCOLOR/2 * (sin(1.5*backgroundPulse + TWO_PI/3)*0.5 + 0.5f),          
          MAXCOLOR/2 * (sin(-1*backgroundPulse)*0.5 + 0.5f), 
          MAXCOLOR/2 * (sin(2.3*backgroundPulse + TWO_PI*2/3)*0.5 + 0.5f) 
          );
    vBuff.background(cColor);
    
    //vBuff.noSmooth();
    vBuff.noFill();
    vBuff.stroke(bColor);
    vBuff.rectMode(RADIUS);
    vBuff.pushMatrix();
    vBuff.translate( PLEDWIDTH/2 + sin(rotation) * 2.f, PLEDHEIGHT/2 + cos(rotation) * 2.f );
    vBuff.rotate( rotation );
  
    int i = bEvens ? 4 : 3;
    for( ; i <= PLEDWIDTH; i+=rectSpacing ) {
      vBuff.rect( 0, 0, i, i );
    }
  
    i = bEvens ? 4 : 3;
    vBuff.stroke(aColor, 128);
    vBuff.rotate( -rotation * 2 );
    for( ; i <= PLEDWIDTH; i+=rectSpacing ) {
      vBuff.rect( 0, 0, i, i );
    }
  
    if ( flipTimer > flipLength ) {
      bEvens = !bEvens;
      flipTimer = 0.f;
    }
  
    if ( changeTimer > changeInterval ) {
      flipLength = random( 0.05f, 0.15f );
      rotationRate = random( PI, PI/4 );
      changeInterval = random( 0.2f, 0.5f );
      rectSpacing += 1;
      if ( rectSpacing > 8 ) {
        rectSpacing = 4;
      }
      changeTimer = 0.f;
    }
  
    /*peggy.canvas.loadPixels();
  
    for ( int i2 = 0; i2 < peggy.nXLeds*peggy.nYLeds; i2++ )
    {
      brightArray[ i2 ] = brightness( peggy.canvas.pixels[ i2 ] );
    }
    */
    //arraySounder.setSpectrum( brightArray );
  
    vBuff.popMatrix();
  }

  void draw() {
    //vBuff.fill(MAXCOLOR);
    //vBuff.rect(6, 5, 3, 2);
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
