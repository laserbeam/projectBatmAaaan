/**
 * Keyboard Controller.
 *
 * A controller setup that handles keyboard presses.
 * WARNIGN: Processing limitation, multiple keys can not be pressed at once!
 */
class KeyboardController extends Controller {
  // ControllDevice keyboard;
  boolean _UP, _DOWN, _LEFT, _RIGHT;

  KeyboardController() {
    _UP = false;
    _LEFT = false;
    _DOWN = false;
    _RIGHT = false;
  }

  /**
   * Update the controller.
   */
  void update() {
    // checks if a key is down on the keyboard not if it was pressed this frame
    
    float dirX = 0;
    float dirY = 0;
    if (_UP) dirY -= 5;
    if (_DOWN) dirY += 5;
    if (_LEFT) dirX -= 5;
    if (_RIGHT) dirX += 5;

    if ( dirX == 0 && dirY == 0 ) return;
    if ( dirX != 0 && dirY != 0 ) {
      dirX *= tan(radians(45));
      dirY *= tan(radians(45));
    }

    InputManager.addEvent( new InputEvent( EV_MOVE, dirX, dirY ) );

  }

  /**
   * Method called when a key is released. The InputManager should take care of this.
   */
  void keyReleased() {
    switch (key) {
      case ESC:
        InputManager.addEvent( new InputEvent( EV_END_STATE ));
        break;
      case 'w':
      case 'W':
        _UP = false;
        break;
      case 's':
      case 'S':
        _DOWN = false;
        break;
      case 'a':
      case 'A':
        _LEFT = false;
        break;
      case 'd':
      case 'D':
        _RIGHT = false;
        break;
    }
  }

  void keyPressed() {
    switch (key) {
      case 'w':
      case 'W':
        _UP = true;
        break;
      case 's':
      case 'S':
        _DOWN = true;
        break;
      case 'a':
      case 'A':
        _LEFT = true;
        break;
      case 'd':
      case 'D':
        _RIGHT = true;
        break;
    }
  }

  // void close() {
  //   keyboard.close();
  // }
};
