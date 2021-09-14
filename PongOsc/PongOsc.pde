import geomerative.*;
import xyscope.*;
import ddf.minim.*;

XYscope xy, xy1;

RShape grp; 
RPoint[][] pointPaths;

float x1 = width*.5;  // ball position
float y1 = height*.5;

float ballSize = 10;

float x1Speed = 12;  // ball speed
float y1Speed = 9;

float rSpeed = 14;  // racket speed

float racketWidth = 50;

float rX = width*.2;    // player 1 position
float rY = height*.5;

float r2X = 780;    // player 2 position
float r2Y = height*.5;

boolean player1scores = false;
boolean player2scores = false;

boolean gameRunning = false;

boolean keyz[] = new boolean [4];

String txtString = "";

int player1score = 0;
int player2score = 0;

long tiempoSalida;
void setup() {
  xy = new XYscope(this, "");

  RG.init(this);

  size(800, 800);
  frameRate(60);
  background(10, 10, 10);
  //rectMode(CENTER);
  tiempoSalida= millis();
}

void draw() {
  background(0);

  if (gameRunning == true) {
    xy.clearWaves();
    xy.ellipseDetail(9);

    grp = RG.getText(txtString, "SF.ttf", width/2, CENTER); 
    grp.centerIn(g, 300);
    RG.setPolygonizer(RG.UNIFORMSTEP);
    RG.setPolygonizerStep(1);
    pointPaths = grp.getPointsInPaths();

    xy.rect(0, 0, width, height);
    xy.rect(0, 0, width, height);

    fill(0, 255, 0);

    // ball
    noStroke();
    fill(0, 255, 0);
    xy.ellipse(x1, y1, ballSize, ballSize);

    x1 = x1 + x1Speed;
    y1 = y1 + y1Speed;


    // net  
    for (float i=10; i<=height; i+=83) {
      xy.rect(width*.5, i, 5, 30);
    }

    if (tiempoSalida >= millis()) {
      text("PLAYER 1 WINS", (width/2)-152, height/2);
      delay(2000);
    }

    if (player1scores == true) {
      fill(0, 255, 0);
      textSize(40);
      text("PLAYER 1 WINS", (width/2)-152, height/2);
      player1score++;
      player1scores = false;
      x1 = width-100;
      y1 = random(100, height-100);
      x1Speed = -4;
      tiempoSalida = millis() + 2000;
    }

    if (player2scores == true) {
      fill(0, 255, 0);
      textSize(40);
      text("PLAYER 2 WINS", (width/2)-152, height/2);
      player2score++;
      player2scores = false;
      x1 = 100;
      y1 = random(100, height-100);
      x1Speed = 4;
      tiempoSalida = millis() + 2000;
    }

    // canvas upper and lower colliders
    if (y1 >= height - ballSize/2) {
      y1Speed *= -1;
    }
    if (y1 <= 0 + ballSize/2) {
      y1Speed *= -1;
    }

    // hitting racket 1
    if (x1 >= rX-5-(ballSize/2) && x1 <= rX+5+(ballSize/2) && y1 >= rY-racketWidth-(ballSize/2)&&y1 <= rY+racketWidth+(ballSize/2)) { 
      x1Speed *= -1;
    }  

    // hitting racket 2
    if (x1 >= r2X-5-(ballSize/2) && x1 <= r2X+5+(ballSize/2) && y1 >= r2Y-racketWidth-(ballSize/2) && y1 <= r2Y+racketWidth+(ballSize/2)) { 
      x1Speed *= -1;
    }

    // ball over the right border
    if (x1 > width+(ballSize/2)) {
      player1scores = true;
      player2scores = false;
    }

    // ball over the left border
    if (x1 < 0-(ballSize/2)) {
      player2scores = true;
      player1scores = false;
    }

    //controls
    if (keyPressed) {

      // move racket 1
      if (rY <= height ) {
        if (rY >= 0 ) {
          if (keyz[0]) { 
            rY -= rSpeed;
          } 
          if (keyz[1]) {
            rY += rSpeed;
          } else {
            rY += 0;
          }
        } else {
          rY=.01;
        }
      } else {
        rY= height - .01;
      }

      // move racket 2
      if (r2Y <= height ) {
        if (r2Y >= 0 ) {
          if (keyz[2]) { 
            r2Y -= rSpeed;
          } 
          if (keyz[3]) {
            r2Y += rSpeed;
          } else {
            r2Y += 0;
          }
        } else {
          r2Y=.01;
        }
      } else {
        r2Y= height - .01;
      }
    }


    //racket 1
    xy.beginShape();
    xy.vertex(rX-5, rY-racketWidth);
    xy.vertex(rX+5, rY-racketWidth);
    xy.vertex(rX+5, rY+racketWidth);
    xy.vertex(rX-5, rY+racketWidth);
    xy.endShape();

    //racket 2
    xy.beginShape();
    xy.vertex(r2X+5, r2Y+racketWidth);
    xy.vertex(r2X-5, r2Y+racketWidth);
    xy.vertex(r2X-5, r2Y-racketWidth);
    xy.vertex(r2X+5, r2Y-racketWidth);
    xy.endShape();


    //scores
    pushMatrix();
    translate(width*.5, height*.05); 
    if (pointPaths != null) { // only draw if we have points 
      for (int i = 0; i < pointPaths.length; i++) { 
        xy.beginShape(); 
        for (int j=0; j < pointPaths[i].length; j++) { 
          xy.vertex(pointPaths[i][j].x, pointPaths[i][j].y);
        } 
        xy.endShape();
      }
    } 
    popMatrix();

    xy.buildWaves();
    xy.drawAll();

    txtString = player1score+"    "+player2score;

    if ( player1score == 11 || player2score == 11) {
      player1score = 0;
      player2score = 0;
      gameRunning = false;
    }
  } else {
    xy.clearWaves(); 

    grp = RG.getText(txtString, "SF.ttf", width/2, CENTER); 
    grp.centerIn(g, 200);
    RG.setPolygonizer(RG.UNIFORMSTEP);
    RG.setPolygonizerStep(10);
    pointPaths = grp.getPointsInPaths();

    pushMatrix();
    translate(width/2, height/2); 
    if (pointPaths != null) {
      for (int i = 0; i < pointPaths.length; i++) { 
        xy.beginShape(); 
        for (int j=0; j < pointPaths[i].length; j++) { 
          xy.vertex(pointPaths[i][j].x, pointPaths[i][j].y);
        } 
        xy.endShape();
      }
    } 
    popMatrix();
    txtString = "PONG";

    xy.buildWaves();
    xy.drawWave();
    xy.drawXY();
    if (mousePressed) {
      gameRunning= true;
    }
  }
}

void keyPressed() {
  if (key == 'a')  keyz[0] = true;
  if (key == 'z')  keyz[1] = true;
  if (keyCode == UP)  keyz[2] = true;
  if (keyCode == DOWN)  keyz[3] = true;
}

void keyReleased() {
  if (key == 'a')  keyz[0] = false;
  if (key == 'z')  keyz[1] = false;
  if (keyCode == UP)  keyz[2] = false;
  if (keyCode == DOWN)  keyz[3] = false;
}
