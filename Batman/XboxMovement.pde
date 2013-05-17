import procontroll.*;
// THIS IMPLEMENTATION IS INCOMPLETE!

/**
 * XboxMovementController setup for Xbox Controller only play.
 */
class XboxMovementController extends Controller {
  ControllIO controlIO = null;
  ControllDevice xboxController;
  ControllSlider LSx, LSy, RSx, RSy;
  ControllButton BACK, START;
  private float _startOld, _backOld;

  XboxMovementController() {
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
    this.LSy = xboxController.getSlider(0);
    this.LSx = xboxController.getSlider(1);
    this.RSx = xboxController.getSlider(3);
    this.RSy = xboxController.getSlider(2);
    this.START = xboxController.getButton(7);
    this._startOld = 0;
    this.BACK = xboxController.getButton(6);
    this._backOld = 0;
  }

  /**
   * Update the controller and send events.
   */
  void update() {
    // Check for movement
    float x=0, y=0;
    if ( LSx.getValue() >= 0.2 || LSx.getValue() <= -0.2 ) x = LSx.getValue();
    if ( LSy.getValue() >= 0.2 || LSy.getValue() <= -0.2 ) y = LSy.getValue();
    if ( x != 0 || y != 0 ) InputManager.addEvent( new InputEvent( EV_MOVE, x*5, y*5 ));

    // Rotation
    x = 0; y = 0;
    if ( RSx.getValue() >= 0.5 || RSx.getValue() <= -0.5 ||
         RSy.getValue() >= 0.5 || RSy.getValue() <= -0.5 ) {
      x = RSx.getValue();
      y = RSy.getValue();
    }
    if ( x != 0 || y != 0 ) InputManager.addEvent( new InputEvent( EV_ROTATE, atan2(y,x), 0 ));

    if (this.BACK.getValue() > this._backOld) {
      InputManager.addEvent( new InputEvent( EV_END_STATE ));
    }

    if (this.START.getValue() > this._startOld) {
      InputManager.addEvent( new InputEvent( EV_START_GAME ));
    }

    this._backOld = this.BACK.getValue();
    this._startOld = this.START.getValue();
  }

  void close() {
    xboxController.close();
  }
  
};

// void mainController(){
//   counter ++;
//   for (int i = 0; i <= 2; i++){
//     if (counter >= 60){
//       PressChecker(Buttons[i], i);
//     }
//   }
//   if ((isntTouching(posX + LSx.getValue(), posY)) && ((LSx.getValue() >= 0.2) || (LSx.getValue() <= -0.2))) {
//     posX = posX + LSx.getValue();
//   }
//   if ((isntTouching(posX, posY + LSy.getValue()))&& ((LSx.getValue() >= 0.2) || (LSx.getValue() <= -0.2))){
//     posY = posY + LSy.getValue();
//   }
//   if ((RSx.getValue() > 0.1) || (RSx.getValue() < -0.1)){
//     rotX = RSx.getValue();
//   }
//   if ((RSy.getValue() > 0.1) || (RSy.getValue() < -0.1)){
//     rotY = RSy.getValue();
//   }
//   println("X: " + (rotX+posX) + " Y: " + (rotY+posY));
//   fill(255,255,255);
//   stroke(255);
//   ellipse(posX,posY,fat,fat);
//   stroke (255,0,255);
//   line(posX,posY,rotX*20+posX,rotY*20+posY);
// }

// boolean isntTouching(float xpos, float ypos){
//   int newX = int(xpos)/WALLSIZE;
//   int newY = int(ypos)/WALLSIZE;
//   if (currentLevel.map[newX][newY] != null){
//     float distance = dist(xpos, currentLevel.map[newX][newY].x, ypos, currentLevel.map[newX][newY].y);
//     if (distance > pow(WALLSIZE, 2)){
//       return true;
//     }else{
//       return false;
//     }
//   }else{
//     return true;
//   }
// }

// void PressChecker(ControllButton butt, int index){
//   if ((butt.pressed()) && (LT.getValue() > 0)){
//           pressed(LT.getValue()*200, index);
//           counter = 0;
//         }
// }

// void pressed (float sizeMax, int type){ //sizeMax is based on LT or volume of sound;
//   //waves.add(new Wave(x, y, sizeMax, type));    //type is based on key pressed or frequency of sound;
//   currentLevel.waves.add( new Wave( posX, posY, atan2( rotY, rotX)));;
// }
