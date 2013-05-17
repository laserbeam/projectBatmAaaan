/**
 * Doors are a kind of Wall that can be opened when activated().
 */
class Door extends Wall implements Activateable {
  boolean deathAnimation = false;
  float auxy;
  float auxdelay;

  /**
   * Create a Door.
   * @param shape: The shape of the wall
   * @param freq: The frequency of the wall. TODO: remove frequency from objects.
   * @param x: The x position.
   * @param y: The y position.
   */
  Door( int shape, float freq, float x, float y ) {
    super( shape, freq, x, y );
    this.r = 200;
    this.b = 20;
    this.g = 20;
    this.auxy = 0;
    this.auxdelay = 0;
  }

  /**
   * Upadte method. If the door was opened it animates it a bit, and then kills it.
   */
  void update() {
    super.update();
    if ( deathAnimation ) {
      this.auxdelay--;
      lightUp( WAVE_MAX_ENERGY );
      if ( this.auxdelay <= 0 ) {
        float p = 30 + auxy;
        p = applyDecay( p, 2, 30 );
        this.auxy = -30 + p;
        dim();
        dim();
        dim();
        dim();
        if ( this.auxy <= -30 ) this.kill();
      } else {
        lightUp();
      }
    }
  }

  void draw( float offX, float offY ) {
    super.draw( offX, offY + auxy );
  }

  void lightUp( float energy ) {
    if ( !deathAnimation ) {
      super.lightUp( energy );
    }
  }

  /**
   * Activate the door and open it.
   * Sends a blast of energy, just for kicks :).
   */
  void activate() {
    lightUp( WAVE_MAX_ENERGY );
    deathAnimation = true;
    auxdelay = random(2, 30);
  }
};
