/**
 * processing
 * amills
 * 2012-04-23
 *
 * pantsLEDs
 * displays (and eventually generates video data files) for the TAP pantsLEDs
 */

/*
  * future modes: 3 dot color fade wander, rain, radar, bouncing ball, plasma, pong, mario, text, fire, game of life
 *    capeshading, sines, moving fireflier, moonrise/sunset, breakout, buildings(windows), nibbles, tunnel zoom, symmetry
 */

import java.awt.Color;

// contstants
final static int MODE = 22;
final static boolean HSYMMETRY = false;
final static boolean GATEMODE = false;
final static boolean SPACED = false;
final static int PLEDWIDTH = 15; // 72 for gate mode + spaced, 48 !gate + spaced, 15 for !gate + !spaced 
final static boolean BLUEGLITCH = false;
final static int NBLUEGLITCHES = 50;
final static boolean FASTRENDER = false;
final static int PLEDPIXMULT = 53;
final static int COLORTHEME = 7;
final static int MAXCOLORTHEME = 20;
final static boolean MOVIEWRITE = false;
final static int PLEDHEIGHT = 10;
final static int NRGB = 3;
final static int MAXCOLOR = 255;
final static int TWOMAXCOLOR = 2*MAXCOLOR;
final static int FASTROLLRATE = 8;
final static float[] SLOWRGBRATE = {
  0.4, 0.5, 0.6
};
final static float COLORSTEP = 1.0;
final static String MOVIEDIR = "patterns/";
final static int FRAMENOTICE = 100;

// global variables
int mode;
color pantsLEDs[][];       // final color values for pantsLEDs
int blueDPLEDs[][];        // dummy PLEDs for blue glitching
float dPLEDs[][][];        // dummy PLEDs for calculations (RGB)
float colorOffset;           // offset of color for rolling colors
DisposeHandler dh;         // to help with final saving of bytes
String movieFileName;      // movie
int movieIntData[];        // to hold the movie data until the write
int nFrames;               // number of frames in the movie
int frameDelay;            // 1/100ths of a second to display each frame
int iJump = (SPACED ? 2 : 1);  // 
color rollColorV;          //
color rollColorH;          //
int rollXDir;              //
int rollYDir;              //
float [] regrbl;
PGraphics vBuff;           // used for processing drawing
PFont fontA;               // font used by text
String myText;             // something to print out
int colorTheme;
float randHue;
Fireflier fireflier;       
MonoRoller monoRoller;   
RainDropper rainDropper;   
KittPulser kittPulser;     
Wavezer wavezer;         
Fireworker fireworker;     
Cancer cancer;            
Plasmer plasmer;         
Squarer squarer;          
Imaginer imaginer;         
WordScroller wordScroller;
Zoomer zoomer;
Matrixer matrixer;
WhoreDueler whoreDueler;
PintDueler pintDueler;
MoviePlayer moviePlayer;

void setup() {
  size(PLEDWIDTH * PLEDPIXMULT + 1, PLEDHEIGHT * PLEDPIXMULT + 1, P2D);
  vBuff = createGraphics( PLEDWIDTH, PLEDHEIGHT, P2D );
  pantsLEDs = new color[PLEDWIDTH][PLEDHEIGHT];
  dPLEDs = new float[NRGB][PLEDWIDTH][PLEDHEIGHT];
  blueDPLEDs = new int[PLEDWIDTH][PLEDHEIGHT];
  for (int i = 0; i < PLEDWIDTH; i++) {
    for (int j = 0; j < PLEDHEIGHT; j++) {
      for (int k = 0; k < NRGB; k++ ) {
        dPLEDs[k][i][j] = random(0, TWOMAXCOLOR);
      }
    }
  }
  setupBlueGlitch();    
  //strokeWeight(0);
  //noStroke();
  colorTheme = COLORTHEME;
  rectMode(CORNERS);
  colorMode(RGB, MAXCOLOR);
  vBuff.colorMode(RGB, MAXCOLOR);
  randHue = random(MAXCOLOR);
  //frameRate(20);

  dh = new DisposeHandler(this);
  movieIntData = new int [0];

  switch (MODE) {
  case 0: // black/white random // not for !spaced
    movieFileName = "bwrandom.bin";
    nFrames = 200;
    frameDelay = 10;
    break; 
  case 1: 
    movieFileName = "clrrndm3.bin";
    nFrames = 8000;
    frameDelay = 2;
    //colorTheme = (int) random(MAXCOLORTHEME) + 1;
    colorTheme = (int) random(3) + 1;
    for (int i = 0; i < PLEDWIDTH; i = i + iJump) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = chooseColor(colorTheme);
      }
    }  
    break; 
  case 2: 
    movieFileName = "ramphdh3.bin";
    nFrames = 400;
    frameDelay = 4;
    regrbl = myHSBtoRGB(random(MAXCOLOR), MAXCOLOR, MAXCOLOR, MAXCOLOR);
    rollColorH = color(regrbl[0], regrbl[1], regrbl[2]);
    regrbl = myHSBtoRGB(random(MAXCOLOR), MAXCOLOR, MAXCOLOR, MAXCOLOR);
    rollColorV = color(regrbl[0], regrbl[1], regrbl[2]);
    rollXDir = (2 * (int) random(2.0)) - 1;
    rollYDir = (2 * (int) random(2.0)) - 1;
    break;
  case 3: 
    movieFileName = "rampsff3.bin";
    nFrames = 400;
    frameDelay = 5;
    regrbl = myHSBtoRGB(random(MAXCOLOR), MAXCOLOR, MAXCOLOR, MAXCOLOR);
    rollColorH = color(regrbl[0], regrbl[1], regrbl[2]);
    regrbl = myHSBtoRGB(random(MAXCOLOR), MAXCOLOR, MAXCOLOR, MAXCOLOR);
    rollColorV = color(regrbl[0], regrbl[1], regrbl[2]);
    rollXDir = (2 * (int) random(2.0)) - 1;
    rollYDir = (2 * (int) random(2.0)) - 1;
    break;
  case 4: 
    movieFileName = "slowchng.bin";
    nFrames = 3407;
    frameDelay = 3;
    colorTheme = (int) random(MAXCOLORTHEME) + 1;
    for (int i = 0; i < PLEDWIDTH; i++) {
      for (int j = 0; j < PLEDHEIGHT; j++) {
        color tempColor = chooseColor(colorTheme);
        dPLEDs[0][i][j] = green(tempColor);
        dPLEDs[1][i][j] = blue(tempColor);
        dPLEDs[2][i][j] = red(tempColor);
      }
    }
    break;
  case 5: 
    zoomer = new Zoomer(); 
    movieFileName = zoomer.getMovieFileName();
    nFrames = zoomer.getNFrames();
    frameDelay = zoomer.getFrameDelay();
    zoomer.setup();
    break;
  case 6:
    fireflier = new Fireflier(); 
    movieFileName = fireflier.getMovieFileName();
    nFrames = fireflier.getNFrames();
    frameDelay = fireflier.getFrameDelay();
    fireflier.setup();
    break;
  case 7: 
    monoRoller = new MonoRoller();
    movieFileName = monoRoller.getMovieFileName();
    nFrames = monoRoller.getNFrames();
    frameDelay = monoRoller.getFrameDelay();
    monoRoller.setup();
    break;
  case 8: 
    rainDropper = new RainDropper();
    movieFileName = rainDropper.getMovieFileName();
    nFrames = rainDropper.getNFrames();
    frameDelay = rainDropper.getFrameDelay();
    rainDropper.setup();
    break;
  case 9: 
    kittPulser = new KittPulser();
    movieFileName = kittPulser.getMovieFileName();
    nFrames = kittPulser.getNFrames();
    frameDelay = kittPulser.getFrameDelay();
    kittPulser.setup();
    break;
  case 10: 
    wavezer = new Wavezer();
    movieFileName = wavezer.getMovieFileName();
    nFrames = wavezer.getNFrames();
    frameDelay = wavezer.getFrameDelay();
    wavezer.setup();
    break;
  case 11: 
    fireworker = new Fireworker();
    movieFileName = fireworker.getMovieFileName();
    nFrames = fireworker.getNFrames();
    frameDelay = fireworker.getFrameDelay();
    fireworker.setup();
    break;
  case 12: 
    cancer = new Cancer(0);
    movieFileName = cancer.getMovieFileName();
    nFrames = cancer.getNFrames();
    frameDelay = cancer.getFrameDelay();
    cancer.setup();
    break;
  case 13: 
    cancer = new Cancer(1);
    movieFileName = cancer.getMovieFileName();
    nFrames = cancer.getNFrames();
    frameDelay = cancer.getFrameDelay();
    cancer.setup();
    break;
  case 14: 
    plasmer = new Plasmer();
    movieFileName = plasmer.getMovieFileName();
    nFrames = plasmer.getNFrames();
    frameDelay = plasmer.getFrameDelay();
    plasmer.setup();
    break;
  case 15: 
    squarer = new Squarer();
    movieFileName = squarer.getMovieFileName();
    nFrames = squarer.getNFrames();
    frameDelay = squarer.getFrameDelay();
    squarer.setup();
    break;
  case 16: 
    imaginer = new Imaginer("dianaSatanEyes-mut-big.jpg");
    movieFileName = imaginer.getMovieFileName();
    nFrames = imaginer.getNFrames();
    frameDelay = imaginer.getFrameDelay();
    imaginer.setup();
    break;
  case 17: 
    //imaginer = new Imaginer("dianaSatanEyes.jpg");
    //imaginer = new Imaginer("rotsnake.gif");
    imaginer = new Imaginer("bkPurp0155.png");
    //imaginer = new Imaginer("00854_coloredcurves_2560x1600.jpg");
    //imaginer = new Imaginer("fire.jpg");
    //imaginer = new Imaginer("videocard-back.jpg");
    //imaginer = new Imaginer("xubuntu-jmak-hardy.png");
    //imaginer = new Imaginer("SPFW08___Toy_Monsta_Pattern_by_dchan.jpg");
    
    movieFileName = imaginer.getMovieFileName();
    nFrames = imaginer.getNFrames();
    frameDelay = imaginer.getFrameDelay();
    imaginer.setup();
    break;
  case 18: 
    //wordScroller = new WordScroller("Duck Eggs and Fluffy Entrails");
    //wordScroller = new WordScroller("Bug and Emily taught me many things about the way to treat people.");
    //wordScroller = new WordScroller("team awesomepants");
    //wordScroller = new WordScroller("cheese puffs and liturgy");
    wordScroller = new WordScroller("Welcome to Umami Village!  --  Team Awesomepants -- " + 
        "The Guild of Calamitous Intent -- Serious Camp -- Battle Royale with Cheese -- The Playce -- Spread Eagle's Nest ");
    wordScroller.setup();
    
    movieFileName = wordScroller.getMovieFileName();
    nFrames = wordScroller.getNFrames();
    frameDelay = wordScroller.getFrameDelay();
    break;
  case 19: 
    matrixer = new Matrixer();
    matrixer.setup();
    movieFileName = matrixer.getMovieFileName();
    nFrames = matrixer.getNFrames();
    frameDelay = matrixer.getFrameDelay();
    break;
  case 20: 
    whoreDueler = new WhoreDueler(1);
    whoreDueler.setup();
    movieFileName = whoreDueler.getMovieFileName();
    nFrames = whoreDueler.getNFrames();
    frameDelay = whoreDueler.getFrameDelay();
    break;
  case 21: 
    pintDueler = new PintDueler();
    pintDueler.setup();
    movieFileName = pintDueler.getMovieFileName();
    nFrames = pintDueler.getNFrames();
    frameDelay = pintDueler.getFrameDelay();
    break;
  case 22: 
    moviePlayer = new MoviePlayer(this, "station.mov");
    moviePlayer.setup();
    movieFileName = moviePlayer.getMovieFileName();
    nFrames = moviePlayer.getNFrames();
    frameDelay = moviePlayer.getFrameDelay();
    break;
  default:
    break;
  }
 
  if (FASTRENDER) {
    frameRate(100);
  } else {
    frameRate((int) (100 / frameDelay));
  }
  addMovieHeader();
}

void setupBlueGlitch() {
  for (int i = 0; i < PLEDWIDTH; i++ ) {
    for (int j = 0; j < PLEDHEIGHT; j++ ) {
      blueDPLEDs[i][j] = 1;
    }
  }
  for (int k = 0; k < NBLUEGLITCHES; k++) {
    int i = (int) random(PLEDWIDTH);
    int j = (int) random(PLEDHEIGHT);
    blueDPLEDs[i][j] = 0;
  }
}

void draw() {

  colorOffset = colorOffset + COLORSTEP;

  switch (MODE) {
  case 0: // black/white random
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        pantsLEDs[i][j] = color((int) random(0, MAXCOLOR));
      }
    }
    break;
  case 1: // color random
    {
      if (random(100) < 0.2 ) {
        colorTheme = (int) random(MAXCOLORTHEME) + 1;
        //colorTheme = (int) random(3) + 1;
      } 
      for (int k = 0; k < 3; k++ ) {
        int i;
        i = (SPACED ? 2 * (int) random(PLEDWIDTH/2) : (int) random(PLEDWIDTH));
        int j = (int) random(PLEDHEIGHT);
        //pantsLEDs[i][j] = chooseColor(colorTheme);
        pantsLEDs[i][j] = chooseColor(20);
      }
    }
    break;
  case 2: // color roll x and y
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        float iBlend = (1.0 * i / PLEDWIDTH + rollXDir * frameCount / 100.0 ) % 1.0;
        while (iBlend < 0.0) {
          iBlend += 1.0;
        }
        float jBlend = (1.0 * j / PLEDHEIGHT + rollYDir * frameCount / 100.0 ) % 1.0;
        while (jBlend < 0.0) {
          jBlend += 1.0;
        }
        pantsLEDs[i][j] = blendColor(
          lerpColor(color(0), rollColorH, iBlend),
          lerpColor(color(0), rollColorV, jBlend),
          ADD);
      }
    }
    break;
  case 3: // color roll x and y with no edges
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
                float iBlend = (1.0 * i / PLEDWIDTH + rollXDir * frameCount / 100.0 ) % 1.0;
        while (iBlend < 0.0) {
          iBlend += 1.0;
        }
        float jBlend = (1.0 * j / PLEDHEIGHT + rollYDir * frameCount / 100.0 ) % 1.0;
        while (jBlend < 0.0) {
          jBlend += 1.0;
        }
        iBlend = abs(2.0 * iBlend - 1.0);
        jBlend = abs(2.0 * jBlend - 1.0);
/*
        float iBlend = abs(2.0 * ((1.0 * i / PLEDWIDTH + rollXDir * frameCount / 100.0 ) % 1.0) - 1.0);
        while (iBlend < 0.0) {
          iBlend += 1.0;
        }
        float jBlend = abs(2.0 * ((1.0 * j / PLEDHEIGHT + rollYDir * frameCount / 100.0 ) % 1.0) - 1.0);
        while (jBlend < 0.0) {
          jBlend += 1.0;
        }
*/
        pantsLEDs[i][j] = blendColor(
          lerpColor(color(0), rollColorH, iBlend),
          lerpColor(color(0), rollColorV, jBlend),
          ADD);
/*
        pantsLEDs[i][j] = blendColor( 
          lerpColor(color(0), rollColorH, abs(2.0 * ((1.0 * i / PLEDWIDTH + rollXDir * frameCount / 100.0 ) % 1.0) - 1.0)),
          lerpColor(color(0), rollColorV, abs(2.0 * ((1.0 * j / PLEDHEIGHT + rollYDir * frameCount / 100.0 ) % 1.0) - 1.0)),
          ADD);        
        /*
        dPLEDs[0][i][j] = ((j * TWOMAXCOLOR / PLEDHEIGHT) + (FASTROLLRATE * colorOffset)) % TWOMAXCOLOR;
        dPLEDs[1][i][j] = ((i * TWOMAXCOLOR / PLEDWIDTH) + (FASTROLLRATE * colorOffset)) % TWOMAXCOLOR;
        dPLEDs[2][i][j] = MAXCOLOR;          

        pantsLEDs[i][j] = color( 
        abs(dPLEDs[0][i][j] - 1.0 * MAXCOLOR), 
        abs(dPLEDs[1][i][j] - 1.0 * MAXCOLOR), 
        abs(dPLEDs[2][i][j] - 1.0 * MAXCOLOR));
        */
      }
    }       
    break;
  case 4: // very slowly rotating colors
    for (int i = 0; i < PLEDWIDTH; i++ ) {
      for (int j = 0; j < PLEDHEIGHT; j++ ) {
        for (int k = 0; k < NRGB; k++) {
          dPLEDs[k][i][j] = (dPLEDs[k][i][j] + SLOWRGBRATE[k]) % TWOMAXCOLOR;
        }          
        pantsLEDs[i][j] = color( 
        abs(dPLEDs[0][i][j] - 1.0*MAXCOLOR), 
        abs(dPLEDs[1][i][j] - 1.0*MAXCOLOR), 
        abs(dPLEDs[2][i][j] - 1.0*MAXCOLOR));
      }
    }
    break;            
  case 5:
    zoomer.update();
    zoomer.draw();
    break;
  case 6:
    fireflier.update();
    fireflier.draw();
    break;
  case 7:
    monoRoller.update();
    monoRoller.draw();
    break;        
  case 8:
    rainDropper.update();
    rainDropper.draw();
    break;        
  case 9:
    kittPulser.update();
    kittPulser.draw();
    break;  
  case 10:
    wavezer.update();
    wavezer.draw();
    break;        
  case 11:
    fireworker.update();
    fireworker.draw();
    break;        
  case 12:
    cancer.update();
    cancer.draw();
    break;        
  case 13:
    cancer.update();
    cancer.draw();
    break;        
  case 14:
    plasmer.update();
    plasmer.draw();
    break;        
  case 15:
    squarer.update();
    squarer.draw();
    break;        
  case 16:
    imaginer.update();
    imaginer.draw();
    break;        
  case 17:
    imaginer.update();
    imaginer.draw();
    break;        
  case 18:
    wordScroller.update();
    wordScroller.draw();
    break;        
  case 19:
    matrixer.update();
    matrixer.draw();
    break;        
  case 20:
    whoreDueler.update();
    whoreDueler.draw();
    break;        
  case 21:
    pintDueler.update();
    pintDueler.draw();
    break;        
  case 22:
    moviePlayer.update();
    moviePlayer.draw();
    break;        
 default:
    break;
  }
  if (HSYMMETRY) {
    if ((PLEDWIDTH / 2) == ((PLEDWIDTH + 1) / 2)) {
      for (int i = 0; i < PLEDWIDTH/2; i++) {
        for (int j = 0; j < PLEDHEIGHT; j++) {
          pantsLEDs[(PLEDWIDTH - 2) - i][j] = pantsLEDs[i][j];
        }
      }
    } else {
      for (int i = 0; i < PLEDWIDTH / 2 + 1; i++) {
        for (int j = 0; j < PLEDHEIGHT; j++) {
          pantsLEDs[(PLEDWIDTH - 1) - i][j] = pantsLEDs[i][j];
        }
      }
    }
  }
  if (BLUEGLITCH) {
    blueGlitch();
  }
  displayPLEDs();
  addMovieFrame();

  if ((frameCount / FRAMENOTICE ) != ((frameCount + 1) / FRAMENOTICE)) {
    println((frameCount + 1 ) + " frames drawn.");
  }
  if (frameCount == nFrames ) {
    println(frameCount + " frames drawn.");
    exit();
  }
}

void blueGlitch() {
  if (random(100) < 0.1) {
    setupBlueGlitch();
  }
  for (int i = 0; i < PLEDWIDTH; i++) {
    for (int j = 0; j < PLEDHEIGHT; j++) {
      pantsLEDs[i][j] = color(red(pantsLEDs[i][j]), green(pantsLEDs[i][j]), 
      blueDPLEDs[i][j] * blue(pantsLEDs[i][j]));
    }
  }
}

color chooseColor(int colorTheme) {
  this.colorTheme = colorTheme;
  return chooseColor();
}

color chooseColor() {
  color tmp;
  float re, gr, bl;
  float[] regrbl = new float[3];
  float[] hues;
  switch (colorTheme) {
    case 0:
      tmp = color(0, 0, 0);
      break;
    case 1:
      tmp = color(MAXCOLOR / 2 + random(MAXCOLOR / 2), 0, 0);
      break;
    case 2:
      tmp = color(0, MAXCOLOR / 2 + random(MAXCOLOR / 2), 0);
      break;
    case 3:
      tmp = color(0, 0, MAXCOLOR / 2 + random(MAXCOLOR / 2));
      break;
    case 4:      
      do {
        re = random(MAXCOLOR);
        gr = random(MAXCOLOR);
        bl = random(MAXCOLOR);
      } while ((re < (MAXCOLOR / 2)) && (gr < (MAXCOLOR / 2)) && (bl < (MAXCOLOR / 2)));
      tmp = color(re, gr, bl);
      break;
    case 5:
      re = random(MAXCOLOR / 3);
      gr = random(MAXCOLOR / 3);
      bl = random(MAXCOLOR / 3);
      float chance = random( 100 );
      if (chance < 30) {
        gr += 2 * MAXCOLOR / 3;
      } else if (chance < 80) {
        re += 2 * MAXCOLOR / 3;
        bl += 2 * MAXCOLOR / 3;
      } else {
        bl += 2 * MAXCOLOR / 3;
      }
      tmp = color(re, gr, bl);
      break;
    case 6:
      tmp = color(MAXCOLOR / 2 + random(MAXCOLOR / 2),
                  MAXCOLOR / 2 + random(MAXCOLOR / 2),
                  MAXCOLOR / 2 + random(MAXCOLOR / 2));
      break;
    case 7:
      hues = new float[] {0.75, 0.42, 0.09};
      regrbl = myHSBtoRGB(MAXCOLOR*(hues[(int) random(hues.length)] + random(-0.03, 0.03)),
                        MAXCOLOR * (0.35 + random(0.5)), 
                        250, MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 8:  // kronik mode
      hues = new float[] {0.1, 0.6};
      regrbl = myHSBtoRGB(MAXCOLOR*(hues[(int) random(hues.length)] + random(-0.01, 0.01)),
                        MAXCOLOR * (0.85 + random(0.15)), 
                        250, MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 9: 
      hues = new float[] {0.999, 0.58, 0.42};
      regrbl = myHSBtoRGB((MAXCOLOR*(hues[(int) random(hues.length)] + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.85 + random(0.15)), 
                        250, MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
     case 10: 
      hues = new float[] {0.999, 0.5, 0.33, 0.83};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.95 + random(0.05)), 
                        250, MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
     case 11: 
      hues = new float[] {0.999 + 0.17, 0.25 + 0.17, 0.5 + 0.17, 0.75 + 0.17};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.65 + random(0.15)), 
                        random(MAXCOLOR/2, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
     case 12: 
      hues = new float[] {0.999 + 0.08, 0.25 + 0.08, 0.5 + 0.08, 0.75 + 0.08};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.95 + random(0.05)), 
                        random(MAXCOLOR/2, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
     case 13: 
      hues = new float[] {0.999, 0.25, 0.5, 0.75};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.95 + random(0.05)), 
                        random(MAXCOLOR/2, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
     case 14: 
      hues = new float[] {0.999, 0.333, 0.666};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.95 + random(0.05)), 
                        random(MAXCOLOR/2, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 15: 
      hues = new float[] {0.333, 0.833};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.85 + random(0.15)), 
                        random(MAXCOLOR*0.6, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 16: 
      hues = new float[] {0.666, 0.08, 0.25};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.65 + random(0.15)), 
                        random(MAXCOLOR*0.8, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 17: 
      hues = new float[] {0.5, 0.08, 0.92};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.65 + random(0.15)), 
                        random(MAXCOLOR*0.8, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 18: 
      hues = new float[] {0.833, 0.25, 0.42};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.85 + random(0.15)), 
                        random(MAXCOLOR*0.6, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 19: 
      hues = new float[] {0.25, 0.666, 0.833};
      regrbl = myHSBtoRGB((MAXCOLOR*(myArtToComp(hues[(int) random(hues.length)]) + random(-0.01, 0.01)))%MAXCOLOR,
                        MAXCOLOR * (0.85 + random(0.15)), 
                        random(MAXCOLOR*0.6, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;
    case 20:
      if (random(100) < 0.1) {
        randHue = random(MAXCOLOR);
      }
      regrbl = myHSBtoRGB(randHue,
                        MAXCOLOR * (0.6 + random(0.4)), 
                        random(MAXCOLOR*0.4, MAXCOLOR),
                        MAXCOLOR); 
      tmp = color(regrbl[0], regrbl[1], regrbl[2]);
      break;      
   default:
      tmp = color(MAXCOLOR, 0, 0);
      break;
  }
  return tmp;
}

float myArtToComp(float h) {
  if (h < 0.33) {
    return map(h, 0.0, 0.33, 0.0, 0.167);    
  } else if (h < 0.5) {
    return map(h, 0.33, 0.5, 0.167, 0.33);
  } else if (h < 0.67) {
    return map(h, 0.5, 0.67, 0.33, 0.67);
  } else {
    return h;
  }
}

float[] myRGBtoHSB( float r, float g, float b, int MAXCOLOR) {
  float[] hsbvals = new float[3]; 
  Color.RGBtoHSB((int) r, (int) g, (int) b, hsbvals);
  for (int i = 0; i < hsbvals.length; i++ ) {
    hsbvals[i] *= MAXCOLOR;
  }
  return hsbvals;
}

float[] myHSBtoRGB( float h, float s, float b, int MAXCOLOR) {
  float[] rgbvals = new float[3];
  int bigColor = Color.HSBtoRGB( h/MAXCOLOR, s/MAXCOLOR, b/MAXCOLOR);
  //java.awt.Color(bigColor);
  rgbvals[0] = (float) ((bigColor & 0xff0000) >> 16);
  rgbvals[1] = (float) ((bigColor & 0xff00) >> 8);
  rgbvals[2] = (float) (bigColor & 0xff);
  return rgbvals;
}

int iGray( int iX, int iY ) {
  return iY*PLEDWIDTH + iX;
}

int iGray2( int iX, int iY ) {
  return iY + iX * PLEDHEIGHT;
}

void stop()
{
  println("In stop");
  super.stop();
}

// Displays the pantsLEDs to the screen
void displayPLEDs() {  
  background(0);
  for (int i = 0; i < PLEDWIDTH; i += iJump) {
    //println( i );
    for (int j = 0; j < PLEDHEIGHT; j++) {
      if (GATEMODE) {
        if ((i < (PLEDWIDTH / 3)) || (i >= (2 * PLEDWIDTH / 3))) {
          fill(color(
            (int) (red(pantsLEDs[i][j])%(MAXCOLOR + 1)), 
            (int) (green(pantsLEDs[i][j])%(MAXCOLOR + 1)), 
            (int) (blue(pantsLEDs[i][j])%(MAXCOLOR + 1))));
          rect(i * PLEDPIXMULT, j * PLEDPIXMULT, ((i + 1) * PLEDPIXMULT), ((j + 1) * PLEDPIXMULT));
        }
      } else {
        fill(color(
          (int) (red(pantsLEDs[i][j])%(MAXCOLOR + 1)), 
          (int) (green(pantsLEDs[i][j])%(MAXCOLOR + 1)), 
          (int) (blue(pantsLEDs[i][j])%(MAXCOLOR + 1))));
        rect(i * PLEDPIXMULT, j * PLEDPIXMULT, ((i + 1) * PLEDPIXMULT), ((j + 1) * PLEDPIXMULT));
      }
      //if (((i + 1)/2) != (i/2)) {
      //  fill( 0 );
      //  rect(i * PLEDPIXMULT, j * PLEDPIXMULT, ((i + 1) * PLEDPIXMULT), ((j + 1) * PLEDPIXMULT));
      //}
    }
  }
}
/*
HEADER section (16 bytes):
 4 bytes: magic number, 0xDEADBEEF (used to check that it's the right file type)
 2 bytes: file type / version number (just 0x1 to start with)
 2 bytes: number of pixels in the display
 2 bytes: number of frames in the animation
 2 bytes: number of ticks (1/100 of a second) between frames (e.g. 33
 fps = 3 ticks)
 4 bytes: number of additional header bytes
 
 FRAMES section (3*npixels*nframes bytes):
 Each frame is just raw pixel data, one byte per color:  RGBRGBRGB...
 */

// writes the pantsLEDs header to the file
void addMovieHeader() {
  // little endianness make this strangely oriented
  int arraySize = (SPACED ? PLEDWIDTH * PLEDHEIGHT / 2 : PLEDWIDTH * PLEDHEIGHT);
  if (GATEMODE) {
    arraySize = 2 * arraySize / 3;
  }
  int [] headerInts = {
    0xef, 0xbe, 0xad, 0xde, 
    0x01, 0x00, 
    arraySize, 0x00, 
    nFrames & 0xff, (nFrames & 0xff00) >> 8, 
    frameDelay, 0x00, 
    16, 0x00, 0x00, 0x00
  };

  println("Frames to draw according to header = " + nFrames);

  movieIntData = concat(movieIntData, headerInts);
}

// writes a pantsLEDs frame to the file
void addMovieFrame() {
  int [] frameInts;
  int mFrames = (SPACED ? PLEDWIDTH*PLEDHEIGHT*NRGB/2 : PLEDWIDTH*PLEDHEIGHT*NRGB );
  if (GATEMODE) {
    frameInts = new int [2*mFrames/3];
  } else {
    frameInts = new int [mFrames];
  }
    
  int iFrame = 0;
  int j = 0;
  int jStep = 1;

  for (int i = 0; i < PLEDWIDTH; i = i + iJump) {

    while ( (j >= 0) && (j < PLEDHEIGHT)) {
      //println( "i, j, jStep, frameI = " + i + ", " + j + ", " + jStep + ", " + iFrame );      

      //FRAMES section (3*npixels*nframes bytes):
      //Each frame is just raw pixel data, one byte per color:  RGBRGBRGB...
      if (GATEMODE) {
        if ((i < (PLEDWIDTH / 3)) || (i >= (2 * PLEDWIDTH / 3))) {
          frameInts[iFrame++] = (int) red(pantsLEDs[i][j]);
          frameInts[iFrame++] = (int) green(pantsLEDs[i][j]);
          frameInts[iFrame++] = (int) blue(pantsLEDs[i][j]);
        }
      } else {
          frameInts[iFrame++] = (int) red(pantsLEDs[i][j]);
          frameInts[iFrame++] = (int) green(pantsLEDs[i][j]);
          frameInts[iFrame++] = (int) blue(pantsLEDs[i][j]);
      }
      j += jStep;
    }
    jStep *= -1;
    j += jStep;
  }

  movieIntData = concat(movieIntData, frameInts);
}

public class DisposeHandler {
  DisposeHandler(PApplet pa) {
    pa.registerDispose(this);
  }

  public void dispose() {
    if ((frameCount - 1) == nFrames) {
      String fullPathMovieFile = MOVIEDIR + movieFileName;
      println("Writing movie .bin file: " + fullPathMovieFile);
      byte [] movieByteData = new byte [movieIntData.length];
      for (int i = 0; i < movieIntData.length; i++) {
        movieByteData[i] = (byte) movieIntData[i];
      }
      saveBytes(fullPathMovieFile, movieByteData);
    } 
    else {
      println((frameCount - 1) + " frames drawn of " + nFrames + ", so no movie written.");
    }
    println("Done.");
  }
}

