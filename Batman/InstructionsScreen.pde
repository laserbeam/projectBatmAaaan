class InstructionsScreen extends State {
  private PImage _img;
  private float x, y;
  void init() {
    if ( XBOX_ACTIONS_CONTROLLER ) {
      _img = RESOURCE_MANAGER.getImage( "assets/Instructions_Controller.png" );
    } else {
      _img = RESOURCE_MANAGER.getImage( "assets/Instructions_Microphone.png" );
    }
    x = floor( ((width/SCALE_RATIO - _img.width) / 2) + _img.width/2 );
    y = floor( ((height/SCALE_RATIO - _img.height) / 2) + _img.height/2 );
  }

  void input() {
    InputEvent e = InputManager.getEvent();
    while ( e != null ) {
      switch ( e.code ) {
        case EV_START_GAME:
          Level x = LEVEL_MANAGER.get( 0 );
          StateManager.swapState(x);
          break;
        case EV_END_STATE:
          StateManager.popState();
          break;
      }
      e = InputManager.getEvent();
    }
  }

  void draw() {
    background(255);
    noTint();
    image( _img, x, y );
  }
};
