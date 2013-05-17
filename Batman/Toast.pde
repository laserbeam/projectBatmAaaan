final int TOAST_DEFAULT_W = 500;
final int TOAST_DEFAULT_H = -1;
final int TOAST_DEFAULT_X = 150;
final int TOAST_DEFAULT_Y = 500;
/**
 * Display text to users in a "toast" floating on the screen.
 * The name is taken from the Android SDK, don't blame me, blame them, I'm just
 * used to calling those floating pieces of texts Toasts.
 */
class Toast extends GameObject {
  ArrayList<String> lines;
  float w, h;
  int timeLeft;

  Toast( String txt, float time, float x, float y, float w, float h ) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    timeLeft = (int) (FRAME_RATE * time);
    _buildLines( txt );
    if ( h == -1 ) {
      this.h = 15 * lines.size();
    }
    println("h: "+h);
    this.alpha = 0;
  }

  Toast( String txt, float time, float x, float y ) {
    this( txt, time, x, y, TOAST_DEFAULT_W, TOAST_DEFAULT_H );
  }

  Toast( String txt, float time ) {
    this( txt, time, TOAST_DEFAULT_X, TOAST_DEFAULT_Y, TOAST_DEFAULT_W, TOAST_DEFAULT_H );
  }

  void _buildLines( String txt ) {
    textSize(12);
    String[] words = split( txt, ' ' );
    float lineWidth = 0;
    float spaceWidth = textWidth( ' ' );
    lines = new ArrayList<String>();
    String oneLine = "";
    for( String word : words ) {
      float wordWidth = textWidth( word );
      if ( lineWidth + wordWidth + spaceWidth < w ) {
        oneLine = oneLine + ' ' + word;
        lineWidth += wordWidth + spaceWidth;
      } else {
        lines.add( oneLine );
        oneLine = "";
        lineWidth = 0;
      }
    }

    if ( oneLine != "" ) lines.add( oneLine );
  }

  void update() {
    timeLeft -= 1;
    if ( timeLeft <= 190/26) {
      alpha = max( alpha - 26, 0 );
    } else {
      alpha = min( alpha + 26, 190 );
    }
    if ( timeLeft <= 0 ) kill();
  }

  /**
   * Override lightUp so it doesn't do anything when waves collide a toast.
   */
  void lightUp() {};

  /**
   * Draw the toast.
   * parameters are ignored, I'm just adding them there as the toast will be a
   * a GameObject in Entities.
   */
  void draw( float offX, float offY ) {
    textSize(12);
    stroke( 50, 50, 50, alpha );
    fill( 0, 0, 0, alpha );
    rect( x+(w/2)-1, y+(h/2)-13, w+4, h+8 );
    fill( 255, alpha );
    for( int i = 0; i < lines.size(); ++i ) {
      text( lines.get(i), x, y+(15*i) );
    }
  }
};
