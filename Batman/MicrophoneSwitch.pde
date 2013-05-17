/**
 * A switch which you have to scream into as a player for it to trigger.
 */
class MicrophoneSwitch extends Switch {

  /** The current charge. */
  float charge = 0;
  /** The rate at which the object discharges. */
  float discharge = WAVE_DISCHARGE_RATE;
  /** Compensate for the same wave hitting the object in consecutive frames. */
  int hitImune = 0;

  /**
   * Create a MicrophoneSwitch.
   */
  MicrophoneSwitch() {
    super();
    this.r = 102;
    this.g = 0;
    this.b = 153;
  }

  /**
   * Create a MicrophoneSwitch.
   * @param x: The x coordinate.
   * @param y: The y coordinate.
   */
  MicrophoneSwitch( float x, float y) {
    this();
    this.x = x;
    this.y = y;
  }

  /**
   * Update.
   * The MicrophoneSwitch will activate its targets from here when the charge is
   * larger than 1. 
   */
  void update() {
    // super.update();
    dim();
    if (!wasTriggered && charge >= 1) activate();
    charge = max( 0, charge - discharge );
    hitImune = max( 0, hitImune-1 );
  }

  void draw( float offX, float offY ) {
    noStroke();
    fill( this.r, this.g, this.b, this.alpha);
    ellipse( x+offX, y+offY, this.size/2, this.size/2);
    fill( this.r+20, this.g+20, this.b+20, this.alpha);
    if ( !wasTriggered ) {
      ellipse( x+offX, y+offY, this.size*charge/2, this.size*charge/2);
    } else {
      ellipse( x+offX, y+offY, this.size/2, this.size/2);
    }

  }

  /**
   * Triggered when a wave hits the object. Charges the MicrophoneSwitch.
   */
  void lightUp( float energy ) {
    super.lightUp( energy );
    if (hitImune == 0) {
      charge += WAVE_CHARGE_FACTOR*energy*energy;
      hitImune = 4;
    }
  }

};
