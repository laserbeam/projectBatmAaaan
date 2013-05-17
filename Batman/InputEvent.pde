// Event codes.
final int EV_MOVE = 1;
final int EV_ACTION_TRIGGER = 2;
final int EV_ROTATE = 3;
final int EV_END_STATE = 4;
final int EV_SWITCH_WAVE = 5;
final int EV_START_GAME = 6;
final int EV_EXIT_GAME = 0xDEADBEEF; // that's just a big number that looks sexy :D

/**
 * Holds an input event.
 * 
 * Some events are probably going to have some parameters as well, like movement
 * could have a velocity x and y. If you need more parameters just add them here
 * and change the constructors if needed.
 *
 * Parameters can mean anything and are event dependent. InputEvent does not
 * assume anything about them and defaults them to 0!
 */
class InputEvent {
  int code;
  float x;
  float y;
  /**
   * Create an input event
   *
   * @param code: The event codes, add more events at the top of the file.
   * @param x: The first parameter for the event.
   * @param y: The second parameter for the event.
   */
  InputEvent( int code, float x, float y ) {
    this.code = code;
    this.x = x;
    this.y = y;
  }

  InputEvent( int code ) {
    this( code, 0, 0 );
  }

  InputEvent( int code, float x ) {
    this( code, x, 0 );
  }
};
