/**
 * A wall in the game.
 * Also contains a polygon for collision data.
 */
class Wall extends GameObject {
  int shape;
  float[] poly;
  float minAlpha;

  // Wall constructor, takes a shape and a resonace frequency besides XY
  /**
   * Create a Wall.
   * @param shape: The shape of the wall (code between 1 and 5)
   * @param x: X coordinate
   * @param y: Y coordinate
   */
  Wall( int shape, float freq, float x, float y ) {
    super(freq,x,y);
    this.shape = shape;
    this.size = WALLSIZE;
    switch ( shape ) {
      case 1:
        this.poly = new float[8];
        break;
      default:
        this.poly = new float[6];
        break;
    }
    _computePolygon();
  }

  /**
   * Update, decreases the alpha of the wall and makes it less visible after a wave passes through.
   */
  void update() {
    super.update();
    dim();
  }

  /**
   * Drawing the wall
   */
  void draw( float offX, float offY ) {
    fill( this.r, this.g, this.b, this.alpha );
    noStroke();
    switch ( shape ){
      case 1 :
        rect( offX+this.x, offY+this.y, this.size, this.size );
        break;
      default : // All the triangles
        triangle( offX+poly[0], offY+poly[1],
                  offX+poly[2], offY+poly[3],
                  offX+poly[4], offY+poly[5] );
        break;
    }
  }

  /**
   * Returns a float array describing a polygon with the corners of the wall
   * {x1, y1, x2, y2, x3, y3...}
   */
  float[] getPolygon() {
    return poly;
  }

  /**
   * Compute the polygon required for collisions.
   * Also, you don't get code uglier than this...
   * Nope... now it'a worse, you have to look for pluses and minutes to see differences
   * @param shape: The shape of the wall (code between 1 and 5)
   */
  private void _computePolygon() {
    switch ( shape ) {
      case 1 :
        poly[0] = x-WALLSIZE/2; poly[1] = y-WALLSIZE/2;
        poly[2] = x+WALLSIZE/2; poly[3] = y-WALLSIZE/2;
        poly[4] = x+WALLSIZE/2; poly[5] = y+WALLSIZE/2;
        poly[6] = x-WALLSIZE/2; poly[7] = y+WALLSIZE/2;
        break;
      case 2 :
        poly[0] = x-WALLSIZE/2; poly[1] = y-WALLSIZE/2;
        poly[2] = x+WALLSIZE/2; poly[3] = y+WALLSIZE/2;
        poly[4] = x-WALLSIZE/2; poly[5] = y+WALLSIZE/2;
        break;
      case 3 :
        poly[0] = x-WALLSIZE/2; poly[1] = y-WALLSIZE/2;
        poly[2] = x+WALLSIZE/2; poly[3] = y-WALLSIZE/2;
        poly[4] = x-WALLSIZE/2; poly[5] = y+WALLSIZE/2;
        break;
      case 4 :
        poly[0] = x-WALLSIZE/2; poly[1] = y-WALLSIZE/2;
        poly[2] = x+WALLSIZE/2; poly[3] = y-WALLSIZE/2;
        poly[4] = x+WALLSIZE/2; poly[5] = y+WALLSIZE/2;
        break;
      case 5 :
        poly[0] = x+WALLSIZE/2; poly[1] = y-WALLSIZE/2;
        poly[2] = x+WALLSIZE/2; poly[3] = y+WALLSIZE/2;
        poly[4] = x-WALLSIZE/2; poly[5] = y+WALLSIZE/2;
        break;
    }
  }

  /**
   * This gives precise collision between a wall (polygon) and a circle.
   * @param cx: The X coordiante of the circle's center.
   * @param cy: The Y coordiante of the circle's center.
   * @param radius: The radius of the circle.
   * @return: Collision data of the collision or null if no collision takes place.
   */
  Collision collidesWithCircle( float centerx, float centery, float radius ) {
    float minDist = 999999;
    int which = 0;
    int j, k;
    // Get the length to the corners
    for ( int i = 0; i < poly.length; i += 2 ) {
      j = i;
      k = ( j+2 ) % poly.length;
      float d = distToSegment( centerx, centery,
                               poly[j], poly[j+1],
                               poly[k], poly[k+1] );
      if ( d < minDist ) {
        minDist = d;
        which = j;
      }
    }
    if ( minDist > radius ) return null;

    // Compute the length to the closest segment of the polygon
    j = which;
    k = ( which+2 ) % poly.length;
    Collision c;
    if ( dist( centerx, centery, poly[j], poly[j+1]) == minDist ) {
      c = new Collision( poly[j], poly[j+1],
                        new PVector( centerx-poly[j], centery-poly[j+1] ), minDist);
    } else if ( dist( centerx, centery, poly[k], poly[k+1]) == minDist ) {
      c = new Collision( poly[k], poly[k+1],
                        new PVector( centerx-poly[k], centery-poly[k+1] ), minDist);
    } else {
      PVector proj = projectToVector( new PVector( centerx-poly[j], centery-poly[j+1] ),
                                      new PVector( poly[k]-poly[j], poly[k+1]-poly[j+1] ));
      c = new Collision( poly[j]+proj.x, poly[j+1]+proj.y,
                         new PVector( centerx-proj.x-poly[j], centery-proj.y-poly[j+1] ), minDist);
    }
    return c;
  }

  /**
   * I don't think these 2 are used anymore, must check...
   */
  protected float getWidth() {
    return WALLSIZE;
  }

  protected float getHeight() {
    return WALLSIZE;
  }
};
