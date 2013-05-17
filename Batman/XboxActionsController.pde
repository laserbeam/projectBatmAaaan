import procontroll.*;
// THIS IMPLEMENTATION IS INCOMPLETE!

/**
 * XboxMovement setup for Xbox Controller only play.
 */
class XboxActionsController extends Controller {
  ControllIO controlIO = null;
  ControllDevice xboxController;
  ControllSlider LT, RT;
  ControllButton Buttons[];
  ControllButton LB, RB;
  ControllButton A, B, X, Y;
  private int _counter;
  private float _waveShape;

  XboxActionsController() {
    controlIO = ControllIO.getInstance(Batman.this);
    // xboxController = controlIO.getDevice("XBOX 360 For Windows (Controller)");
    // This fixes our xbox controller name issue
    for ( int i = 0; i < controlIO.getNumberOfDevices(); ++i ) {
      ControllDevice device = controlIO.getDevice(i);
      String s = device.getName();
      if ( match(s, "(x|X)(b|B)(o|O)(x|X)") != null ) {
        xboxController = controlIO.getDevice(i);
        break;
      }
    }
    this.LT = xboxController.getSlider(4);
    this.Buttons = new ControllButton[3];
    this.Buttons[0] = xboxController.getButton(0); //A
    this.Buttons[1] = xboxController.getButton(2); //X
    this.Buttons[2] = xboxController.getButton(3); //Y
    this.A = xboxController.getButton(0);
    this.B = xboxController.getButton(1);
    this.X = xboxController.getButton(2);
    this.Y = xboxController.getButton(3);
    this.LB = xboxController.getButton(4);
    this.RB = xboxController.getButton(5);
    // _counter = 0;
    _waveShape = .5;
  }

  // Incomplete right now
  /**
   * Update the controller and send events.
   */
  void update() {
    if ( this.X.pressed() ) _waveShape = 0;
    if ( this.A.pressed() ) _waveShape = .7;
    if ( this.B.pressed() ) _waveShape = 1;
    if ( LT.getValue() > 0.1 ) {
      float value = LT.getValue();
      // Shout when pressing right button
      // if ( !RB.pressed() ) value = map( value, 0, 1, 0, 0.4 );
      InputManager.addEvent( new InputEvent( EV_ACTION_TRIGGER, min(1, value+random(0, 0.1)), _waveShape ));
      // _counter = 0;
    }

    // ++_counter;
  }
  
  void close() {
    xboxController.close();
  }
  
};

