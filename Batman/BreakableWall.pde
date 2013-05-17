// A breakable wall. This guy should get smashed when screaming loudly into it.
/**
 * BreakableWall
 *
 * A special kind of Wall that can break when screamed into.
 */
class BreakableWall extends Wall {
  boolean deathAnimation = false;
  float health;
  float recharge = WAVE_DISCHARGE_RATE;
  float maxHealth = 1;
  int hitImune = 0;
  float vx = 0, vy = 0;


  /**
   * Create a BreakableWall.
   * @param shape: The shape of the wall
   * @param freq: The frequency of the wall. TODO: remove frequency from objects.
   * @param x: The x position.
   * @param y: The y position.
   */
  BreakableWall( int shape, float freq, float x, float y ) {
    super( shape, freq, x, y );
    this.r = 20;
    this.b = 200;
    this.g = 20;
    health = maxHealth;
  }

  /**
   * Update. Recharges the health and calls super.update()/
   */
  void update() {
    super.update();
    if (health <= 0) {
      deathAnimation = true;
    }
    if ( deathAnimation && alpha < 1 ) {
      this.kill();
    }
    health = min( maxHealth, health+recharge );
    hitImune = max( 0, hitImune-1 );
    if ( deathAnimation ) {
      dim();
      dim();
    }
  }

  /**
   * Render the Wall.
   * @param offX: The X offset of the level.
   * @param offY: The Y offset of the level.
   *
   * Suggestion, to make walls vibrate one could add a random value to offx and
   * offy when passed to super.draw().
   */
  void draw( float offX, float offY ) {
    if ( !deathAnimation ) {
      vx = random(-7, 7)*(1-health);
      vy = random(-7, 7)*(1-health);
    }
    super.draw( offX + vx, offY + vy );
  }

  /**
   * Called when a wave collides with this object.
   * @param energy: The ammount of energy the wave has at the moment of collision.
   * @todo: fine tune this.
   */
  void lightUp( float energy ) {
    if ( deathAnimation ) return;
    super.lightUp( energy );
    if (hitImune == 0) {
      health -= WAVE_CHARGE_FACTOR*energy*energy;
      hitImune = 4;
    }
  }
};
