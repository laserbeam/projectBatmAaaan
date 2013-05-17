/**
 * Basic enemy that moves in some direction until it hits a wall, then moves backward.
 */
class Enemy extends Unit {
  float movedir;
  float speed;

  /**
   * Create an Enemy.
   * @param freq: The frequency of the unit. TODO: remove frequency from objects.
   * @param x: The x position.
   * @param y: The y position.
   * @param speed: The speed of the enemy.
   * @param movedir: The direction towards which the enemy moves.
   */  
  Enemy( float freq, float x, float y, float speed, float movedir ) {
    super(freq,x,y);
    this.speed = speed;
    this.movedir = movedir;
  }

  /**
   * Updates and moves the Enemy.
   */
  void update() {
    float dx = cos(this.movedir)*this.speed;
    float dy = sin(this.movedir)*this.speed;
    boolean collision = this.move(dx,dy);
    if (collision) {
      movedir += PI;
      if (movedir > TWO_PI) {
        movedir -= TWO_PI;
      }
    }
    dim();
  }

  void draw( float offX, float offY ) {
    if ( img != null ) { 
      super.draw( offX, offY );
      return;
    }
    noFill();
    strokeWeight(1);
    stroke(this.r, this.g, this.b, this.alpha);
    ellipse( offX + this.x, offY + this.y, this.size/2, this.size/2 );
    stroke(255, 0, 0, this.alpha);
    if (DEBUG_MODE) {
      line ( offX + this.x, offY + this.y,
             offX + this.x + (20*cos(dir)), offY + this.y + (20*sin(dir)));
    }
  }
};
