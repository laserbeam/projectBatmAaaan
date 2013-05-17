// final float DIM_DECAY_FACTOR = 1;
color getFreqColor( float freq ) {
  if (freq == 440) return color(0, 180, 40);
  return color(0, 80, 230);
}

/**
 * Base object for all game elements that would be on the screen.
 */
class GameObject {
  /** Frequency of the object. THIS IS NOT USED, just for the color thing, but was designed to have a different meaning, should it be removed?*/
  float freq;
  /** Position. */
  float x, y;
  /** Direction */
  float dir;
  /** Opacity. */
  float alpha;
  /** Base color. Should be removed eventually and probably everything should draw images */
  float r, g, b;
  /** The size of the object. Used in collisions. */
  float size;
  /** Minimum transparency. */
  float minAlpha;
  /** Death flag, Level should remove objects that have this set to true. */
  boolean isDead;
  /** The rate at which objects transparency decreases. */
  float dimRate;
  
  Sprite img = null;
  String name = "";
  
  /**
   * Create a GameObject
   * @param freq: The frequency of the unit.
   * @param x: The x position.
   * @param y: The y position.
   */
  GameObject( float freq, float x, float y ) {
    this.isDead = false;
    this.freq = freq;
    this.alpha = WALL_MIN_ALPHA;
    this.minAlpha = WALL_MIN_ALPHA;
    color c = getFreqColor( freq );
    this.r = red(c);
    this.g = green(c);
    this.b = blue(c);
    this.x = x;
    this.y = y;
    this.dir = 0;
    this.dimRate = WALL_FADE_RATE;
    this.size = PLAYERSIZE;
  }
  
  GameObject() {
    this( DEFAULT_FREQUENCY, 0, 0 );
  }

  /** Update method. */
  void update() {}

  /**
   * Decrease the brightness of the object.
   */
  void dim() {
    // this.alpha = max( this.alpha-dimRate, minAlpha );
    alpha = max( minAlpha, applyDecay( alpha, WALL_FADE_RATE, WALL_MAX_ALPHA) );
  }

  /**
   * Kill the object. Sets the isDead flag true, Object should then be removed by level.
   */
  void kill() {
    isDead = true;
  }

  /**
   * Render the Object to the screen.
   * Assume GameObject has an Image. All objects rendered differently should
   * overload draw.
   * @param offX: The X offset of the level.
   * @param offY: The Y offset of the level.
   */
  void draw( float offX, float offY ) {
    if ( img != null ) {
      img.draw( offX+x, offY+y, alpha, dir+HALF_PI );
    }
  }
  
  /**
   * Called on collisions with waves.
   * WARNING! Can be called on consecutive frames by the same wave!!!
   * @param energy: The ammount of energy the wave has at the moment of collision.
   */
  void lightUp( float energy ) {
    this.alpha = max( this.alpha, WALL_MAX_ALPHA*energy );
  }

  /**
   * Called on collisions with waves.
   * @deprecated: Waves now send the energy parameter and this is here for backup
   * just in case code exists that wasn't updated to handle energy.
   */
  void lightUp() {
    lightUp( WAVE_MAX_ENERGY );
  }
  
  /**
   * Move the object with some offset.
   * @param x: Distance on the X axis.
   * @param y: Distance on the Y axis.
   * @return: true if the object has collided something.
   * Objects that don't check collisions on move should return false.
   */
  boolean move( float x, float y ) {
    this.x += x;
    this.y += y;
    return false;
  }
  
  /**
   * Getter for this.x.
   * return: the value of this.x.
   */
  float get_x() {
    return this.x;
  }

  /**
   * Getter for this.y.
   * return: the value of this.y.
   */
  float get_y() {
    return this.y;
  }

  /**
   * GameObject to GameObject collisions.
   *
   * Assume the other game object is a square and return true if this collides
   * with that square. Subclasses can override this, but should still treat
   * other as if it were a square. Note that depending on implementation
   * A.collidesSimple(B) and B.collidesSimple(A) may give different results.
   * Allways assume A is the object with more complex collision code and call
   * A.collidesSimple(B). (Exmaple, Waves collide in a different way.)
   *
   * @param other: The object to check against.
   * @return: true if there is a collision.
   */
  boolean collidesSimple( GameObject other ) {
    float x1 = abs( this.x - other.x );
    float y1 = abs( this.y - other.y );
    if (x1 <= ( this.size + other.size ) / 2 &&
        y1 <= ( this.size + other.size ) / 2 ) {
      return true;
    }
    return false;
  }
};

