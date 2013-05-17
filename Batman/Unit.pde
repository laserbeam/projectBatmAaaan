/**
 * A Unit that's supposed to move around, and not go through walls.
 */
class Unit extends GameObject {

  Unit( float freq, float x, float y ) {
    super(freq,x,y);
    this.size = PLAYERSIZE;
    this.dir = 0;
  }
  
  
  /**
   * Move the unit and stop it from going into walls.
   * NOTE! The unit is considered to be a circle!
   * @param x: Distance on the X axis.
   * @param y: Distance on the Y axis.
   */
  boolean move( float x, float y ) {
    this.x += x;
    this.y += y;
    if ( ((Level)currentState).collidesSimple( this )) {
      Collision c = ((Level)currentState).collidesWithCircle( this );
      if (c == null) return false;
      PVector n = new PVector ( x, y );
      PVector displace = c.normal.get();
      displace.mult( this.size/2 - c.distance );
      this.x += displace.x;
      this.y += displace.y;
      return true;
    }
    return false;
  }
};
