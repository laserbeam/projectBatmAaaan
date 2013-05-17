class Speaker extends GameObject implements Activateable {

  //float charge = 0;
  //float discharge = 0.002;
  //int hitImune = 0;
  boolean isOn;
  boolean wasTriggered = false;
  int lightInterval = 40;
  int lightIntervalCounter = 0;

  Speaker() {
    super();
    this.isOn = false;
    this.r = 200;
    this.g = 0;
    this.b = 200;
  }

  Speaker( float x, float y) {
    this();
    this.x = x;
    this.y = y;
  }

  void activate() {
    if (this.isOn) {this.isOn = false;}
    else {this.isOn = true;}
  }

  void draw( float offX, float offY ) {
    noStroke();
    fill( this.r, this.g, this.b, this.alpha);
    ellipse( x+offX, y+offY, this.size/2, this.size/2);
  }

  void update() {
    // super.update();
    dim();
    //if (!wasTriggered && charge >= 1) activate();
    //charge = max( 0, charge - discharge );
    //hitImune = max( 0, hitImune-1 );
    if (this.isOn) {
      lightIntervalCounter += 1;
      if (lightIntervalCounter == lightInterval) {
        lightIntervalCounter = 0;
        Wave w = ((Level)currentState).spawnWave( x, y, 0, TWO_PI-0.001, 200 );
        w.setEnergy(0.5);
      }
    }
  }

  void lightUp( float energy ) {
    super.lightUp( energy );
    //if (hitImune == 0) {
    //  charge += 0.3;
    //  hitImune = 4;
    //}
  }

};