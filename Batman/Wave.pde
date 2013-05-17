final boolean WAVE_DEBUG_DRAW = false;
final int DECAY_NONE = 0;
final int DECAY_ROOT = 1;
/**
 * Wave.
 * This could be made a proper subclass of GameObject soon, right now waves use
 * a lot of vector math and I don't want to disturb their slumber. 
 */
class Wave extends GameObject {
  float radius;
  PVector center;
  PVector startCP; // CP stands for Control Point
  PVector endCP;
  float limit;
  float energy;
  int _decayMode; 
  protected float _dir;
  protected PVector _dStartCP; // delta
  protected PVector _dEndCP;
  protected float _startAngle;
  protected float _endAngle;

  /**
   * Create a Wave.
   * @param xpos: X coordinate of the center.
   * @param ypos: Y coordinate of the center.
   * @param dir: The direction of the wave (radians).
   * @param theta: The angle of the wave (radians, how wide the wave will be).
   * @param limit: The maximum range of the wave. 
   * @param energy: The starting energy.
   */
  Wave( float xpos, float ypos, float dir, float theta, float limit, float energy ) {
    this.center = new PVector( xpos, ypos );
    this._dir = dir;
    this.radius = 3;
    this.limit = limit;
    this._startAngle = dir - theta/2;
    this._endAngle = dir + theta/2;
    this.alpha = 100;
    float a1 = _startAngle;
    float a2 = _endAngle;
    if ( _startAngle < -PI ) { _startAngle += TWO_PI; _endAngle += TWO_PI; }
    // println("angles: " + a1 + " " + a2 + " " + _startAngle + " " + _endAngle);
    // if ( _endAngle)
    // if (_endAngle < _startAngle) _endAngle += TWO_PI;
    this.startCP = new PVector( xpos + radius*cos( _startAngle ), ypos + radius*sin( _startAngle ) );
    this.endCP = new PVector( xpos + radius*cos( _endAngle ), ypos + radius*sin( _endAngle ) );
    this._dStartCP = new PVector( WAVESPEED*cos( _startAngle ), WAVESPEED*sin( _startAngle ) );
    this._dEndCP = new PVector( WAVESPEED*cos( _endAngle ), WAVESPEED*sin( _endAngle ) );
    this.isDead = false;
    this.energy = energy;
    this._decayMode = DECAY_ROOT;
  }

  Wave( float xpos, float ypos, float dir, float theta, float limit ) {
    this( xpos, ypos, dir, theta, limit, WAVE_MAX_ENERGY );
  }

  Wave( float xpos, float ypos, float dirAngle, float limit ) {
    this( xpos, ypos, dirAngle, WAVE_DEFAULT_ANGLE, limit );    
  }

  Wave( float xpos, float ypos, float dirAngle ) {
    this( xpos, ypos, dirAngle, WAVE_DEFAULT_ANGLE, WAVE_DEFAULT_MAX_RADIUS );
  }

  // // creates a reflected wave
  // // THIS IS CURRENTLY UNTESTED, DO NOT USE YET
  // Wave( float centerx, float centery, float startx, float starty, float radius, PVector normal, float limit) {
  //   // PVector incident = new PVector( startx-centerx, starty-centery );
  //   // float d = incident.dot(normal);
  //   // PVector reflect = normal.get();
  //   // reflect.mult(2*d);
  //   // reflect.sub(incident);
  //   this.center = new PVector( centerx, centery );
  //   this.radius = radius;
  //   this.limit = limit;
  //   this.alpha = 100;
  //   this.startCP = new PVector( startx, starty );
  //   this.endCP = new PVector( startx, starty );
  //   this._dStartCP = new PVector( normal.y, -normal.x );
  //   this._dStartCP.mult(WAVESPEED);
  //   this._dEndCP = new PVector( -normal.y, normal.x );
  //   this._dEndCP.mult(WAVESPEED);
  //   this._startAngle = 0;
  //   this.isDead = false;
  //   this._endAngle = 0;
  //   this._dir = atan2( normal.y, normal.x );

  //   println(""+centerx+" "+centery+" "+normal.x+" "+normal.y);
  // }


  /**
   * Moves a wave
   * TODO: Update Control Point speeds... if these points don't move radial from
   * the center of the wave (ex. on a wave's reflection), they don't have
   * constant velocity
   */
  void update() {
    radius = radius + WAVESPEED;
    startCP.add(_dStartCP);
    endCP.add(_dEndCP);
    if ( _decayMode != DECAY_NONE ) {
      energy = applyDecay( energy, WAVE_DECAY_FACTOR, 1 );
    }
    alpha = 200*max(0.05, energy-0.1);
    if (radius > limit || energy <= 0.01) {
      isDead = true;
      // println("Wave is dead! at radius: " + radius);
    }
    updateCPAngles();
  }

  /**
   * Get a copy of the wave.
   * @return: A new Wave from this one.
   * WARNING! This looks buggy, I don't think it's used and one should expect
   * bugs when using it.
   */
  Wave copy() {
    Wave w = new Wave( center.x, center.y, _dir );
    w.setControlPoints( startCP, endCP, _dEndCP, _dStartCP );
    w.radius = radius;
    w.energy = energy;
    w.updateCPAngles();
    return w;
  }

  /**
   * Set the control points for the Wave.
   * @param startCP: Control point for the start of the Wave.
   * @param endCP: Control point for the end of the Wave.
   * @param dStartCP: Velocity for the start of the Wave.
   * @param dEndCP: Velocity point for the end of the Wave.
   */
  void setControlPoints( PVector startCP, PVector endCP, PVector dStartCP, PVector dEndCP ) {
    this.startCP = startCP.get();
    this.endCP = endCP.get();
    this._dStartCP = dStartCP.get();
    this._dEndCP = dEndCP.get();
  }

  /**
   * Update the angle at which the control points move.
   * Was supposed to be useful for reflected waves.
   */
  protected void updateCPAngles() {
    PVector startV = new PVector( startCP.x - center.x, startCP.y - center.y );
    PVector endV = new PVector( endCP.x - center.x, endCP.y - center.y );
    _startAngle = atan2(startV.y, startV.x);
    _endAngle = atan2(endV.y, endV.x);
    if ( _endAngle < _startAngle ) { _endAngle += TWO_PI; }
    startV.normalize();
    startV.mult(WAVESPEED);
    _dStartCP = projectToVector( startV, _dStartCP );
    endV.normalize();
    endV.mult(WAVESPEED);
    _dEndCP = projectToVector( endV, _dEndCP );
    // _dStartCP.x = WAVESPEED*cos( _startAngle );
    // _dStartCP.y = WAVESPEED*sin( _startAngle );
    // _dEndCP.x = WAVESPEED*cos( _endAngle );
    // _dEndCP.y = WAVESPEED*sin( _endAngle );
  }

  /**
   * Render the wave
   * Note that some configuration on how to draw these waves is set in Level.pde as it applies to all waves
   * @param offX: The X offset of the level.
   * @param offY: The Y offset of the level.
   */
  void draw( float offX, float offY) {
    noFill();
    if (WAVE_DEBUG_DRAW) {
      strokeWeight(1);
      stroke(255,0,0);
      line(center.x, center.y, startCP.x, startCP.y);
      stroke(0,255,0);
      line(center.x, center.y, endCP.x, endCP.y);
    }
    // strokeWeight(radius/100);
    stroke(255, 255, 255, this.alpha);
    arc(offX+center.x, offY+center.y, radius, radius, _startAngle, _endAngle);
  }

  /**
   * Check if a certain angle is contained within the limits of the Wave.
   * @param angle: The angle to check for.
   * @return: true if the angle is within the wave limits
   */
  boolean containsAngle( float angle ) {
    if ( _startAngle <= angle && angle <= _endAngle ||
         _startAngle <= angle+TWO_PI && angle+TWO_PI <= _endAngle ) return true;
    return false;
  }

  // Returns true if the wave is colliding a wall
  // TODO: change this so it only returns true if the wall is in the right angle
  // for the wave to collide it, should also check wall diagonals (or the wall
  // should do that)

  // WaveCollision collidesWallForReflection( Wall wall ) {
    
  // }

  /**
   * Check for collision with a GameObject.
   * @param go: The GameObject to check with.
   * @return: true if the object is hit by the wave now.
   */
  boolean collidesGameObject( GameObject go ) {
    float d = dist( center.x, center.y, go.x, go.y ) - radius;
    if ( -go.size < d && d < 1 ) {
      if ( containsAngle( atan2( go.y-center.y, go.x-center.x )))
        return true;
      return false;
    }
    return false;
  }

  /**
   * Set the energy for the wave
   * @param energy: the new energy.
   */
  void setEnergy( float energy ) {
    this.energy = energy;
  }
};

/**
 * Object that stores a bunch of data on wave collisions to be able to mathematically reflect the wave
 */
class WaveCollision {
  PVector normal;
  PVector loc;

  WaveCollision( PVector loc, PVector normal ) {
    this.loc = loc.get();
    this.normal = normal.get();
  }
};
