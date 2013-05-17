/**
 * Keyboard Controller.
 *
 * A controller setup that handles keyboard presses.
 * WARNIGN: Processing limitation, multiple keys can not be pressed at once!
 */
class KeyboardController extends Controller {
  ControllIO controlIO = null;
  ControllDevice keyboard;
  ControllButton _UP, _DOWN, _LEFT, _RIGHT;

  KeyboardController() {
    controlIO = ControllIO.getInstance(Batman.this);
    for ( int i = 0; i < controlIO.getNumberOfDevices(); ++i ) {
      ControllDevice device = controlIO.getDevice(i);
      String s = device.getName();
      if ( match(s, "(k|K)eyboard") != null ) {
        keyboard = controlIO.getDevice(i);
        break;
      }
    }
    keyboard.printButtons();
    _UP = keyboard.getButton("W");
    _LEFT = keyboard.getButton("A");
    _DOWN = keyboard.getButton("S");
    _RIGHT = keyboard.getButton("D");
  }

  /**
   * Update the controller.
   */
  void update() {
    // checks if a key is down on the keyboard not if it was pressed this frame
    
    float dirX = 0;
    float dirY = 0;
    if (_UP.pressed()) dirY -= 5;
    if (_DOWN.pressed()) dirY += 5;
    if (_LEFT.pressed()) dirX -= 5;
    if (_RIGHT.pressed()) dirX += 5;

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
    }
  }

  void close() {
    keyboard.close();
  }
};
