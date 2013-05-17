/**
 * MouseController to handle mouse events.
 */
class MouseController extends Controller 
  {
  Level level;
  Player currentPlayer;
  // private int _counter;
  /**
   * Update.
   */
  void update() 
  {
    try {
      level = (Level) StateManager.getCurrentState();
    } catch (ClassCastException e) { // Mouse controller shouldn't know stuff about level...
      return;
    }
    currentPlayer = level.get_currentPlayer();
    PVector p = level.getScreenXY(currentPlayer);
    InputManager.addEvent( new InputEvent( EV_ROTATE, atan2(mouseY-p.y,mouseX-p.x), 0 ));
    if ( mousePressed && (mouseButton == LEFT))
    {
      InputManager.addEvent( new InputEvent( EV_START_GAME ));
    }
  }

  /**
   * Christian, this is never actually triggered, if you really need this (it
   * won't be used in the final game anyway, and I'm not sure what you need here) 
   */
  void keyReleased() {
    switch (key) {
      case ESC:
        InputManager.addEvent( new InputEvent( EV_END_STATE ));
        break;
    }
  }
};
