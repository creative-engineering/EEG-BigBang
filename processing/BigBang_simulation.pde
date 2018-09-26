import ddf.minim.*;
import oscP5.*;
import java.awt.*;
OscP5 oscP5;
Minim minim;
AudioSample Explotion;

PFont f;
String message  = "Congratulations! You reached the end of the universe.                          ";
String message1 = "  You successfully caused the universe to expand into a state of heat death!   ";
String message2 = "  You successfully caused the universe to contract back into a big crunch.     ";
String message3 = "    This simulation will restart in 5 seconds...                               ";

String StanbyMessage  = "Establishing contact"   ;
String StanbyMessage1 = "Establishing contact."  ;
String StanbyMessage2 = "Establishing contact.." ;
String StanbyMessage3 = "Establishing contact...";
String StanbyMessage4 = "- Please rearrange headset -"  ;

String Text1 = "This is a simulation of the universe from start to finish!";
String Text2 = "By using your mind, you determine the fate of the universe";
String Text3 = "To expand the universe - Try relaxing";
String Text4 = "To contract the universe - Try concentrating";
String Text5 = "The simulation will begin in 3 seconds!";

PFont f1;
PFont f2;
PFont f3;
PFont f4;
PFont f5;

boolean flag1 = true;
boolean flag2 = true;
boolean standbyFlag = true;
boolean signalFlag = true;

float emergeArea;
float speed = 0;
float incrementSpeed = 0;
float incrementArea = 100;

float currentAttention;
float currentMeditation;
float currentSignal = 1;

float attThreshold = 55.0;
float medThreshold = 60.0;

int textCounter = 0;
int fixCounter = 0;
int aniCounter = 0;
int endTextCounter = 0;
int standbyCounter = 0;
int starAmount = 800;
int attCount = 0;
int medCount = 0;

Letter[] letters;
Letter[] letters1;
Letter[] letters2;
Letter[] letters3;

ArrayList Stars;

void setup() {
  fullScreen();
  //size(1200, 900);
  // frameRate(24);

  reset();
}

void draw() {

  if (currentSignal > 0) {
    if (standbyFlag == true) {

      standbyCounter++;

      if (standbyCounter == 1) {
        background(0);
        textFont(f1);
        text(StanbyMessage, 120, 700);
      }
      if (standbyCounter == 70) {
        background(0);
        textFont(f1);
        text(StanbyMessage1, 120, 700);
      }
      if (standbyCounter == 140) {
        background(0);
        textFont(f1);
        text(StanbyMessage2, 120, 700);
      }
      if (standbyCounter == 210) {
        background(0);
        textFont(f1);
        text(StanbyMessage3, 120, 700);
      }
      if (standbyCounter == 280) {
        standbyCounter = 0;
        standbyFlag = false;
      }
    }
    if (standbyFlag == false) {
      background(0);
      textFont(f1);
      text(StanbyMessage4, 120, 700);
      standbyCounter++;
      if (standbyCounter == 120) {
        standbyCounter = 0;
        standbyFlag = true;
      }
    }
  } else if (currentSignal == 0 ) {

    infoText();
    soundOn();

    if (textCounter > 1000 && flag1 == true && flag2 == true) {

      println(incrementArea);

      if (fixCounter > 50 && fixCounter < 250) {
        incrementSpeed = incrementSpeed +  0.06;
        incrementArea = incrementArea - 0.495;
      }

      fixCounter++;
      //incrementArea -= 0.001;

      if (currentAttention > attThreshold && fixCounter > 400 ) {
        incrementSpeed = incrementSpeed - 0.05;
        incrementArea = incrementArea + 0.02;
        attCount++;
      }

      if (currentMeditation > medThreshold && fixCounter > 400) {
        incrementArea = incrementArea - 0.01;
        incrementSpeed = incrementSpeed +  0.05;
        medCount++;
      }

      emergeArea = incrementArea;
      speed = incrementSpeed;
      print("Speed:");
      println(speed);
      println();
      background(0);
      translate(width/2, height/2);

      for (int i = 0; i < Stars.size(); i++) {
        Star s = Stars.get(i);
        s.update();
        s.show();
      }

      // Det er her afslutter programmet og leder videre til den konkluderende tekst //
      if (attCount > 300 && incrementArea > 12 && incrementSpeed < -8) {
        flag2 = false;
      }
      if (medCount > 300 && incrementArea < 0.0) {
        flag1 = false;
      }
    } else if (flag2 == false) {

      endTextCounter ++;
      background(0);
      for (int i = 0; i < letters.length; i++) {
        letters[i].display();
        letters[i].home();

        if (endTextCounter > 200) {
          letters2[i].display1();
          letters2[i].home();
        }
        if (endTextCounter > 550) {
          letters3[i].display3();
          letters3[i].home();

          if (endTextCounter > 1000) {
            reset();
          }
        }
      }
    } else if (flag1 == false) {

      endTextCounter ++;
      background(0);
      for (int y = 0; y < letters.length; y++) {
        letters[y].display();
        letters[y].home();

        if (endTextCounter > 200) {
          letters1[y].display1();
          letters1[y].home();

          if (endTextCounter > 550) {
            letters3[y].display3();
            letters3[y].home();

            if (endTextCounter > 1000) {
              reset();
            }
          }
        }
      }
      // saveFrame();
    }
  }
}

void reset() {

  resetValues();

  oscP5 = new OscP5(this, 7771); // Start listening for incoming messages at port 7771

  f = createFont("Georgia", 36);
  textFont(f);

  letters =  new Letter[message. length()];
  letters1 = new Letter[message1.length()];
  letters2 = new Letter[message2.length()];
  letters3 = new Letter[message3.length()];

  Stars = new ArrayList();

  ///////////////////////////////// Sound //////////////////////////////////////////////////////////

  minim = new Minim(this);
  Explotion = minim.loadSample( "Explosion.wav", 512);

  for (int x = 0; x < starAmount; x++) {
    Stars.add(new Star());
  }

  int x = 80;
  int w = 80;
  int v = 80;
  int q = 80;

  for (int i = 0; i < message.length (); i++) {
    letters[i] = new Letter(x, height/2, message.charAt(i));
    x += textWidth(message.charAt(i));
  }
  for (int i = 0; i < message1.length (); i++) {
    letters1[i] = new Letter(w, height/2, message1.charAt(i));
    w += textWidth(message1.charAt(i));
  }
  for (int i = 0; i < message2.length (); i++) {
    letters2[i] = new Letter(v, height/2, message2.charAt(i));
    v += textWidth(message2.charAt(i));
  }
  for (int i = 0; i < message3.length (); i++) {
    letters3[i] = new Letter(q, height/2, message3.charAt(i));
    q += textWidth(message3.charAt(i));
  }

  f1 = createFont("Georgia", 40);
  f2 = createFont("Georgia", 68);
}

void oscEvent(OscMessage theMessage) {
  // Print the address and typetag of the message to the console
  // println("OSC Message received! The address pattern is " + theMessage.addrPattern() + ". The typetag is: " + theMessage.typetag());

  // Check for Attention messages only
  if (theMessage.checkAddrPattern("/attention") == true) {
    currentAttention = theMessage.get(0).floatValue();
    println("Attention: " + currentAttention);
  }

  if (theMessage.checkAddrPattern("/signal") == true) {
    currentSignal= theMessage.get(0).floatValue();
    println("Signal: " + currentSignal);
  }
  if (theMessage.checkAddrPattern("/meditation") == true) {
    currentMeditation = theMessage.get(0).floatValue();
    println("Mmeditation: " + currentMeditation);
    println();
  }
}

class Letter {

  char letter;
  float homex, homey;
  float x, y;
  float theta;

  Letter (float x_, float y_, char letter_) {
    homex = x = x_;
    homey = y = y_;
    x = random(width);
    y = random(height);
    theta = random(TWO_PI);
    letter = letter_;
  }

  // Display the letter
  void display() {
    fill(255);
    textAlign(LEFT);
    pushMatrix();
    translate(x, y);
    text(letter, 0, 200);
    popMatrix();
  }

  void display1() {
    fill(255);
    textAlign(LEFT);
    pushMatrix();
    translate(x, y);
    text(letter, 0, 245);
    popMatrix();
  }

  void display3() {
    fill(255);
    textAlign(LEFT);
    pushMatrix();
    translate(x, y);
    text(letter, 0, 290);
    popMatrix();
  }

  // Return the letter home using lerp!
  void home() {
    x = lerp(x, homex, 0.05);
    y = lerp(y, homey, 0.05);
  }
}

class Star {

  float x;
  float y;
  float z;
  float sx;
  float sy;
  float r;
  float h;

  float pz;

  Star() {
    x = width/2;
    y = height/2;
    z = random(width);
    pz = z;
  }

  void update () {
    z = z - speed;
    if (z < 1) {
      z = width;
      x = random(-width/(emergeArea*1.8), width/(emergeArea*1.8));
      y = random(-height/emergeArea, height/emergeArea);
      pz = z;
    }
  }

  void show() {

    if (speed >= 0) {
      sx = map(x / z, 0, 1, 0, width);
      sy = map(y / z, 0, 1, 0, height);
      r = map(z, 0, width, 10, 0);

      fill(255);
      noStroke();
      ellipse(sx, sy, r, r);
    }

    if (speed < 0) {

      sx = map(x / z, 1, 0, width, 0);
      sy = map(y / z, 1, 0, height, 0);
      h = map(z, width, 0, 0, 10);

      fill(255);
      noStroke();
      ellipse(sx, sy, h, h);

      if (h < 0 && speed < -7) {
        for (int i = 0; i < Stars.size(); i++) {
          Stars.remove(i);
        }
      }
    }
  }
}

void soundOn() {
  if (textCounter == 1000) {
    Explotion.trigger();
  }
}

void infoText() {

  textCounter++;

  if (textCounter < 200) {
    background(0);
    textFont(f1);
    //textSize(24);
    text(Text1, 120, 700);
  } else if (textCounter > 200 && textCounter < 400) {
    background(0);
    textFont(f1);
    //textSize(24);
    text(Text2, 120, 700);
  } else if (textCounter > 400 && textCounter < 600) {
    background(0);
    textFont(f1);
    //textSize(24);
    text(Text3, 120, 700);
  } else if (textCounter > 600 && textCounter < 800) {
    background(0);
    textFont(f1);
    //textSize(24);
    text(Text4, 120, 700);
  } else if (textCounter > 800 && textCounter < 1000) {
    background(0);
    textFont(f1);
    //textSize(24);
    text(Text5, 120, 700);
  }
}

void resetValues() {
  background(0);
  textCounter = 0;
  fixCounter = 0;
  endTextCounter = 0;
  flag1 = true;
  flag2 = true;
  incrementSpeed = 0;
  incrementArea = 100;
  speed = 0;
}
