class Cancer implements MovieMode {
  static final String DEFAULTMOVIEFILENAME = "cancerb1.bin";
  static final int NFRAMES = 1000;
  static final int FRAMEDELAY = 5;
  static final int NHISTORY = 99;

  PGraphics vBuff;
  int cancerMode;
  String movieFileName;

  float currentMode;
  int currentCount; 
  int cancerColorMode;
  int currentWriteFrame, currentReadFrameOffset; 
  color cancerArray[][];
  float brightArray[];
  float xPos, yPos;
  float xMaxGrow, yMaxGrow;
  
  Cancer() {
    movieFileName = DEFAULTMOVIEFILENAME;
  }
  
  Cancer(int cancerMode) {
    this.cancerMode = cancerMode;
    movieFileName = "cancer" + cancerMode + ".bin";
    cancerColorMode = (int) random(5);
  }
 
  void setup() {
    vBuff = createGraphics(PLEDWIDTH, PLEDHEIGHT);
    vBuff.beginDraw();
    vBuff.colorMode(RGB, MAXCOLOR);
    vBuff.strokeWeight(1.0);
    vBuff.smooth();
    vBuff.endDraw();

    currentCount = 0; 
    currentWriteFrame = 0; 
    currentReadFrameOffset = 0;
    cancerArray = new color[ NHISTORY ][ PLEDWIDTH*PLEDHEIGHT ];
    brightArray = new float[ PLEDWIDTH*PLEDHEIGHT ];
    //currentMode = random( 0.0, 1.0 );
    currentMode = cancerMode;
  
    float chance = random(100);
    for( int jY = 0; jY < PLEDHEIGHT; jY++ ) {
      for( int jX = 0; jX < PLEDWIDTH; jX++ ) {
        float baseDotColor = random(0.2 * MAXCOLOR, 0.7 * MAXCOLOR);
        for( int jF = 0; jF < NHISTORY; jF++ ) {
          float oneColor = ( ( MAXCOLOR*( NHISTORY - 1 - jF ) )/( 1.0*NHISTORY ) + baseDotColor ) % MAXCOLOR;
          color aColor;
          if (chance < 40) {
            aColor = color( oneColor, 0, 0 );
          } else if (chance < 80 ) {
            aColor = color( 0, oneColor, 0 );
          } else {
            aColor = color( oneColor, 0, oneColor );
          }            
          cancerArray[ jF ][ iGray( jX, jY ) ] = aColor;
        }
      }
    }
  
    xPos = PLEDWIDTH/2.0;
    yPos = PLEDHEIGHT/2.0;
 
    xMaxGrow = random(0.05, 0.25);
    yMaxGrow = random(0.05, 0.25);
  }


  void update() { 
    currentCount += 1;
    currentWriteFrame = currentCount%NHISTORY;
    if (random(100) < 0.2) {
      cancerColorMode = (int) random(5);
    }
    //println( "currentWriteFrame = " + currentWriteFrame + " currentReadFrameOffset = " + currentReadFrameOffset );

    color smallColorChange =
          color((((cancerColorMode == 0) || (cancerColorMode == 3) || (cancerColorMode == 4)) 
                      ? random(0.02 * MAXCOLOR) : 0), 
                ((cancerColorMode == 1) || (cancerColorMode == 3) ? random(0.02 * MAXCOLOR) : 0), 
                ((cancerColorMode == 2) || (cancerColorMode == 4) ? random(0.02 * MAXCOLOR) : 0));
    for (int jX = 0; jX < PLEDWIDTH; jX++ ) {
      for (int jY = 0; jY < PLEDHEIGHT; jY++ ) {
        xPos = ( xPos + random( -1.0*xMaxGrow, xMaxGrow ) + 1.0*PLEDWIDTH ) % ( 1.0*PLEDWIDTH);
        yPos = ( yPos + random( -1.0*yMaxGrow, yMaxGrow ) + 1.0*PLEDHEIGHT ) % ( 1.0*PLEDHEIGHT);
        cancerArray[ currentWriteFrame ][ iGray( int( xPos ), int( yPos ) ) ] = 
              color((((cancerColorMode == 0) || (cancerColorMode == 3) || (cancerColorMode == 4))  
                      ? random(0.0, 0.3 * MAXCOLOR) : green(cancerArray[ currentWriteFrame ][ iGray( jX, jY ) ])), 
                    ((cancerColorMode == 1) || (cancerColorMode == 3) 
                      ? random(0.0, 0.3 * MAXCOLOR) : blue(cancerArray[ currentWriteFrame ][ iGray( jX, jY ) ])), 
                    ((cancerColorMode == 2) || (cancerColorMode == 4) 
                      ? random(0.0, 0.3 * MAXCOLOR) : red(cancerArray[ currentWriteFrame ][ iGray( jX, jY ) ])));
        color oldValue;
        //println(" jX, jY = " + jX + ", " + jY );
        if ( 0.5 > currentMode ) {
          oldValue = cancerArray[ currentWriteFrame ][ iGray( jX, jY ) ];
        } else {
          oldValue = cancerArray[ ( currentWriteFrame + NHISTORY - 1 ) % NHISTORY ][ iGray( jX, jY ) ];
        }
        cancerArray[ currentWriteFrame ][ iGray( jX, jY ) ] = oldValue + smallColorChange;
      }
    }
    
    vBuff.beginDraw();
    vBuff.loadPixels();
    if( currentCount < NHISTORY ) {
      currentReadFrameOffset = 0;
    } else if ( random( 0.0, 1.0 ) < 0.1 ) {
      currentReadFrameOffset = int( random( 0, NHISTORY - 1 ) );
    }
    arrayCopy( cancerArray[ ( currentWriteFrame + currentReadFrameOffset )%NHISTORY ], vBuff.pixels );
 
    for ( int i = 0; i < PLEDWIDTH*PLEDHEIGHT; i++ )
    {
      brightArray[ i ] = brightness( vBuff.pixels[ i ] );
    }
   
    vBuff.updatePixels();
    vBuff.endDraw();
  }

  void draw() {
    //vBuff.fill(MAXCOLOR);
    //vBuff.rect(6, 5, 3, 2);
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
    return movieFileName;
  }

  int getNFrames() {
    return NFRAMES;
  }

  int getFrameDelay() {
    return FRAMEDELAY;
  }

}
