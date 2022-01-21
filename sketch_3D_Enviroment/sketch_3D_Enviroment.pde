import java.awt.Robot;

color black = #000000;
color white = #FFFFFF;
color steelblue = #7092BE;

PImage MossyStone;
PImage OakTop, OakSide;
PImage Sand;

int gridSize;
PImage map;

Robot rbt;

boolean skipFrame;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  MossyStone = loadImage("Mossy_Stone.png");
  OakTop = loadImage("OakTop.png");
  OakSide = loadImage("Oak.png");
  Sand = loadImage("Sand.png");
  
  wkey = akey = skey = dkey= false;
  eyeX = width/2;
  eyeY = 3 * height/4;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  upX = 0;
  upY = 1;
  upZ = 0;
  leftRightHeadAngle = radians(90);
  upDownHeadAngle = 0;
  noCursor();
  try {
    rbt = new Robot();
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  
  map = loadImage("map.png");
  gridSize = 200;
  skipFrame = false;
}

void draw() {
  background(0);
  //spotLight(255,255,255, eyeX, eyeY, eyeZ, focusX, focusY, focusZ, PI, 1);
  pointLight(255,255,255, eyeX, eyeY, eyeZ);
  
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ + PI/4, upX, upY, upZ);
  drawFloor(-8000,8000,height,gridSize);
  drawMap();
  drawFocalPoint();
  controlCamera();

}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(1);
  popMatrix();
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, Sand, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}

void drawMap() {
  for (int x = 0; x < map.width; x ++) {
    for (int y = 0; y < map.height; y ++) {
      color c = map.get(x,y);
      if (c == steelblue) {
        texturedCube(x * gridSize - 4000, height - gridSize, y * gridSize - 4000, MossyStone, gridSize);
        texturedCube(x * gridSize - 4000, height - 2 * gridSize, y * gridSize - 4000, MossyStone, gridSize);
        texturedCube(x * gridSize - 4000, height - 3 * gridSize, y * gridSize - 4000, MossyStone, gridSize);
      }
      if (c == black) {
        texturedCube(x * gridSize - 4000, height - gridSize, y * gridSize - 4000, OakTop, OakSide, OakTop, gridSize);
        texturedCube(x * gridSize - 4000, height - 2 * gridSize, y * gridSize - 4000, OakTop, OakSide, OakTop, gridSize);
        texturedCube(x * gridSize - 4000, height - 3 * gridSize, y * gridSize - 4000, OakTop, OakSide, OakTop, gridSize);
      }
    }
  }
}

void controlCamera() {
   
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  } 
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle - PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle + PI/2)*10;
  }
  
  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (pmouseX - mouseX) * 0.005;
    upDownHeadAngle = upDownHeadAngle + (mouseY -pmouseY) * 0.005;
  }
  
  if (upDownHeadAngle > PI/2.1) upDownHeadAngle = PI/2.1;
  if (upDownHeadAngle < -PI/2.1) upDownHeadAngle = -PI/2.1;
  
  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ - sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  
  if (mouseX > width-2) {
    rbt.mouseMove(2, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
  
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'D' || key == 'd') dkey = true;
  if (key == 'S' || key == 's') skey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'D' || key == 'd') dkey = false;
  if (key == 'S' || key == 's') skey = false;
}
