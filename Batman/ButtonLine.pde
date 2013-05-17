class ButtonLine extends GameObject implements Activateable {
  float[] xes;
  float[] yes;
  boolean wasTriggered = false;
  ButtonLine( GameObject parent, String valueString ) {
    super();
    this.x = parent.x;
    this.y = parent.y;
    this.r = parent.r;
    this.g = parent.g;
    this.b = parent.b;
    String[] coords = split(valueString, ' ');
    xes = new float[coords.length];
    yes = new float[coords.length];
    for ( int i = 0; i < coords.length; ++i ) {
      String[] p = split(coords[i], ',');
      xes[i] = float(p[0]) + this.x;
      yes[i] = float(p[1]) + this.y;
    }
    println("LINE_MADE");
  }

  void update() {
    super.update();
    dim();
    dim();
  }

  void lightUp( float energy ) {
    if (!wasTriggered) super.lightUp( energy );
  }

  void activate() {
    wasTriggered = true;
    super.lightUp(1);
  }

  void draw( float offX, float offY ) {
    for ( int i = 0; i < xes.length-1; ++i ) {
      strokeWeight(2);
      stroke(this.r, this.g, this.b, this.alpha);
      line( xes[i]+offX, yes[i]+offY, xes[i+1]+offX, yes[i+1]+offY);
      strokeWeight(1);
    }
  }
};
