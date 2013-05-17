/**
 * Holds images for animations (and is able to draw itself).
 * @todo: Exception handling.
 */

final int ANIMATION_IDLE = 0;
final int ANIMATION_WALKING = 1;
final int DISTINCT_ANIMATIONS = 2;

class Sprite {
  ArrayList< ArrayList<PImage> > images;
  private float _rate = 1;
  private float _counter = 0;
  int currentAnim;
  Sprite() {
    images = new ArrayList< ArrayList<PImage> >();
    for ( int i = 0; i < DISTINCT_ANIMATIONS; ++i) {
      images.add( new ArrayList<PImage>() );
    }
    setAnimation( ANIMATION_IDLE );
  }

  void setAnimation( int animCode ) {
    if ( images.get(animCode).isEmpty() ) return;
    currentAnim = animCode;
    _counter = 0;
  }

  void setImages( int animCode, ArrayList<PImage> frames ) {
    images.get(animCode).clear();
    images.get(animCode).addAll( frames );
  }

  void setImages( int animCode, PImage frame ) {
    images.get(animCode).clear();
    images.get(animCode).add( frame );
  }

  /**
   * Set the duration of a frame.
   * @param t: The length a frame will displayed in seconds. Set as -1 for one
   * image per frame.
   *
   */
  void setDuration( float t ) {
    if ( t <= 0 ) {
      _rate = 1;
      return;
    }
    _rate = t * FRAME_RATE;
  }

  void draw( float x, float y ) {
    image( getFrame(), x, y );
  }

  void draw( float x, float y, float alpha, float rot ) {
    pushMatrix();
    imageMode( CENTER );
    tint(255, alpha);
    translate( x, y );
    rotate( rot );
    image( getFrame(), 0, 0 );
    popMatrix();
    _counter++;
    if ((_counter/_rate) >= images.get(currentAnim).size()) {
      _counter -= images.get(currentAnim).size() * _rate;
    }
  }

  PImage getFrame() {
    return images.get(currentAnim).get( (int)(_counter/_rate) );
  }


};
