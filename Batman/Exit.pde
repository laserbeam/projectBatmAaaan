/**
 * The Exit from the Level.
 * When Walking over this, the player completes the level.
 */
class Exit extends Switch {
  Exit() {
    super();
    ArrayList<PImage> aList = new ArrayList<PImage>();
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitA (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitB (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitC (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitD (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitE (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitF (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitG (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitH (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitI (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitJ (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitK (Custom).png" ) );
    aList.add( RESOURCE_MANAGER.getImage( "assets/ExitL (Custom).png" ) );
    img = new Sprite();
    img.setDuration(1./20);
    img.setImages( ANIMATION_IDLE, aList );
  }

  Exit( float x, float y ) {
    this();
    this.x = x;
    this.y = y;
  }

  /**
   * Triggered on player collision (from Switch update).
   */
  void activate() {
    this.dimRate = 0;
    this.lightUp(1);
    Level l = (Level)StateManager.getCurrentState();
    l.finishLevel( x, y );
    wasTriggered = true;
    METRICS_LOGGER.logEvent("Activated", "Exit");
  }
};
