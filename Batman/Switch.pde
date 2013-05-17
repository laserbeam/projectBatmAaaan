/**
 * Interface for any object that must be activated.
 * Objects that can be triggered by a switch must be Activatable.
 */
public interface Activateable {
  void activate();
}

/**
 * Switch.
 *
 * Simple Switch that is triggered by collision with the player.
 */
class Switch extends GameObject {
  boolean wasTriggered = false;
  ArrayList<Activateable> targets;

  /**
   * Create a Switch.
   */
  Switch() {
    super();
    wasTriggered = false;
    targets = new ArrayList<Activateable>();
    this.r = 150;
    this.g = 60;
    this.b = 20;
    dimRate /= 3;
  }

  /**
   * Create a Switch.
   * @param x: X coordinate.
   * @param y: Y coordinate.
   */
  Switch( float x, float y ) {
    this();
    this.x = x;
    this.y = y;
  }

  /**
   * Update the Switch.
   */
  void update() {
    super.update();
    dim();
    if ( !wasTriggered && this.collidesSimple( ((Level)currentState).currentPlayer ) ) {
      activate();
    }
  }

  /**
   * Add a target to be activated by the Switch.
   * @param target: An Activatable object to be triggered.
   */
  void addTarget( Activateable target ) {
    targets.add( target );
  }

  /**
   * Render the Object to the screen.
   * @param offX: The X offset of the level.
   * @param offY: The Y offset of the level.
   */
  void draw( float offX, float offY ) {
    if (img != null) {
      super.draw( offX, offY );
      return;
    }
    noStroke();
    fill( this.r, this.g, this.b, this.alpha);
    ellipse( x+offX, y+offY, this.size/2, this.size/2);
  }

  /**
   * Activate the switch and trigger all its targets.
   */
  void activate() {
    for ( int i = 0; i < targets.size(); i++ ) {
      targets.get( i ).activate();
    }
    wasTriggered = true;
    ((Level)currentState).spawnWave( x, y, 0, TWO_PI-0.001, 150 );
    METRICS_LOGGER.logEvent("Activated", this.name);
  }
};
