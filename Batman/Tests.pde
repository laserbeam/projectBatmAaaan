// This file is used to either run tests related to the other files OR random
// tests to see how Processing does stuff.

// Test to see where an angle is 0, which way angles increase in value and how
// they get converted to degrees.
// Should be called from draw()
void TESTprocessingAngles() {
  background(0, 0, 0);
  float x = width/2;
  float y = height/2;
  float radius = dist(x, y, mouseX, mouseY);
  // float start = HALF_PI/2;
  // float end = TWO_PI - HALF_PI/2;
  
  float start = 2*TWO_PI-HALF_PI/2;
  float end = 2*TWO_PI+HALF_PI;

  float angle = atan2(mouseY - y, mouseX - x);
  float a2 = angle;
  if (a2 < end) a2 = a2+TWO_PI;
  boolean between = false;
  
  if (start <= angle && angle <= end ||
      start <= angle+TWO_PI && angle+TWO_PI <= end) between = true;

  if (between) {
    fill(0, 200, 0);
  } else {
    fill(200, 0, 0);
  }
  arc(x, y, radius, radius, start, end);
  fill(0, 0, 200, 180);
  arc(x, y, radius, radius, end, a2);
  noFill();
  stroke(255);
  ellipse(x, y, 5, 5);
  ellipse(x, y, radius, radius);
  line(x, y, mouseX, mouseY);
  fill(255);
  text("angle(rad): " + angle, 1, 10 );
  text("angle(deg): " + degrees(angle), 1, 23 );
  text("radius: " + radius, 1, 36 );
  text("start: " + start, 1, 49 );
  text("end: " + end, 1, 62 );
  text("a2: " + a2, 1, 75 );  
}

class Test extends State {
  void init(){}
  void update(){}
  void draw(){}
  void mousePress( float x, float y ){}
  void keyPress(){}
};

class TESTWallShapes extends Test {
  Level clevel;
  void init() {
    clevel = new Level(5, 1);
    clevel.map[0][0] = new Wall( 1, 440, 0*16, 0 );
    clevel.map[1][0] = new Wall( 2, 440, 1*16, 0 );
    clevel.map[2][0] = new Wall( 3, 440, 2*16, 0 );
    clevel.map[3][0] = new Wall( 4, 440, 3*16, 0 );
    clevel.map[4][0] = new Wall( 5, 440, 4*16, 0 );
    clevel.offX = width/2-100;
    clevel.offY = height/2-100;
    printWall( clevel.map[0][0] );
    printWall( clevel.map[1][0] );
    printWall( clevel.map[2][0] );
    printWall( clevel.map[3][0] );
    printWall( clevel.map[4][0] );
  }
  void draw() {
    clevel.update();
    clevel.draw();
  }
  void mousePress( float x, float y ) {
    clevel.spawnWave( -10, -10 );
  }
  void printWall( Wall wall ) {
    float[] poly = wall.getPolygon();
    print("Polygon:");
    for (int i = 0; i<poly.length; i++) {
      print(" " + poly[i]);
    }
    print("\n");
  }
};

class TESTVectorMath extends Test {
  PVector a, b, ab;
  void init() {
    a = new PVector(width/2, height/2);
    b = a.get();
    b.add( new PVector(100, 100) );
    // a.add( new PVector(-100, -100) );
    ab = b.get();
    ab.sub(a);
  }
  void draw() {
    PVector m = new PVector(mouseX, mouseY);
    PVector c = m.get();
    c.sub(a);
    PVector proj = projectToVector( c, ab );
    background(0);
    noFill();
    stroke(255, 255, 255, 50);
    line(a.x, a.y, b.x, b.y);
    ellipse(m.x, m.y, 5, 5);
    ellipse(a.x, a.y, 3, 3);
    stroke(255, 0, 0);
    line(a.x, a.y, a.x+proj.x, a.y+proj.y);
    stroke(0, 255, 0);
    line(m.x, m.y, a.x+proj.x, a.y+proj.y);

    text("A: " + a.x + " " + a.y, 1, 10 );
    text("B: " + b.x + " " + b.y, 1, 23 );
    text("Mouse: " + mouseX + " " + mouseY, 1, 36 );
    text("Proj: " + proj.x + " " + proj.y, 1, 49 );
    text("distToLine: " + distToVector( m, a, b), 1, 62 );
    // text("a2: " + a2, 1, 75 );  
  }
};

class TESTOneWallMap extends Test {
  Level clevel;
  void init() {
    clevel = new Level("maps/rectWall.tmx");
  }
  void update() {
    clevel.update();
  }
  void draw() {
    clevel.draw();
  }
  void mousePress( float x, float y ) {
    clevel.spawnWave(width/2, height/2);
  }
};

class TESTWallCircleCollision extends Test {
  Level clevel;
  Wall w;
  float radius;
  void init() {
    clevel = new Level(1, 1);
    w = new Wall( 1, 440, 0, 0);
    clevel.map[0][0] = w;
    radius = 200;
    clevel.offX = 200;
    clevel.offY = 200;
  }
  void update() {
    clevel.update();
  }
  void draw() {
    clevel.draw();
    Collision c = w.collidesWithCircle( mouseX-clevel.offX, mouseY-clevel.offY, radius );
    // PVector proj = projectToVector( new PVector(  ) );
    stroke(128, 128, 128, 128);
    ellipse(mouseX, mouseY, radius, radius);
    if ( c!=null ) {
      c.normal.mult(20);
      stroke(255, 0, 0);
      ellipse(c.x+clevel.offX, c.y+clevel.offY, 2, 2);
      line( c.x+clevel.offX, c.y+clevel.offY,
            c.x+clevel.offX+c.normal.x, c.y+clevel.offY+c.normal.y );
      stroke(0, 0, 255);
      line( c._x1+clevel.offX, c._y1+clevel.offY, c._x2+clevel.offX, c._y2+clevel.offY );
      
    }
  }
  void mousePress( float x, float y ) {
    clevel.spawnWave(width/2, height/2);
  }
  void printWall( Wall wall ) {
    float[] poly = wall.getPolygon();
    print("Polygon:");
    for (int i = 0; i<poly.length; i++) {
      print(" " + poly[i]);
    }
    print("\n");
  }
}