/* CONFIGURATION */
// SCREEN
final int SCREEN_WIDTH = 800; // Only used in windowed mode
final int SCREEN_HEIGHT = 600; // Only used in windowed mode
// Use width and height to get screen dimaensions.
// Those variables are defined by Processsing
float SCALE_RATIO;
final boolean FULLSCREEN_MODE = false;
final boolean DEBUG_MODE = false;
final boolean LOW_QUALITY = false;
final float FRAME_RATE = 30; // WARNING! changing this affects gameplay speed!
// GRID
final int WALLSIZE = 16;
final int PLAYERSIZE = 2*WALLSIZE;
// PLAYER
final float PLAYER_RECHARGE_RATE = 0.019;
final float PLAYER_DISCHARGE_FACTOR = 0.041;
// WALL
final float WALL_MIN_ALPHA = 0; // Use 0 in the final game to make all walls invisible
final float WALL_FADE_RATE = 6.7; // Amount of alpha value reduced each frame
final float WALL_MAX_ALPHA = 255; // Maximum alpha value used when lighting up walls
// WAVE
final float WAVESPEED = 7;
final float WAVE_DEFAULT_MAX_RADIUS = 350;
final float WAVE_DEFAULT_ANGLE = radians(70);
final float WAVE_MAX_ENERGY = 1; // should be 1, 1 is max 0 is min
final float WAVE_DECAY_FACTOR = 0.014; // smaller values make wave energy drop slower
final float WAVE_CHARGE_FACTOR = 0.55; // multiplied to wave energy when charging an object
final float WAVE_DISCHARGE_RATE = 0.009; // the rate at which game objects recharge or discharge
// AUDIO
final boolean AUDIO_INPUT_ENABLED = true;
final boolean XBOX_ACTIONS_CONTROLLER = false; // DO NOT CHANGE this now, there is no gamepad mode anymore, but this is still used in logic somewhere, until cleanup takes place this should stay here.
final boolean AUDIO_OUTPUT_ENABLED = false; // This is not used at the moment
// MICROPHONE
float MIN_AMPLITUDE_THRESHOLD = 0.009;
float MAX_AMPLITUDE_THRESHOLD = 0.14;
float MIN_PITCH = 130;
float MAX_PITCH = 260;
// MISC
final int DEFAULT_FREQUENCY = 440;
final boolean MOUSE_CONTROLLER = true;
final int WAVE_EMIT_DELAY = 10;
final boolean LOG_METRICS = false; // This was used only for testing, just ignore.
final String METRICS_PATH = "log/";

/*********************/
State currentState;
LevelFactory LEVEL_FACTORY;
ResourceManager RESOURCE_MANAGER;
LevelManager LEVEL_MANAGER;
MetricsLogger METRICS_LOGGER;

/**
 * Initialization method. Called by processing once at the beginning of the
 * execution.
 */
void setup() {

  LEVEL_FACTORY = new LevelFactory();
  RESOURCE_MANAGER = new ResourceManager();
  LEVEL_MANAGER = new LevelManager();
  METRICS_LOGGER = new MetricsLogger();

  if (FULLSCREEN_MODE) {
    size(displayWidth, displayHeight);
    SCALE_RATIO = min( (float)displayHeight/SCREEN_HEIGHT, (float)displayWidth/SCREEN_WIDTH );
  } else {
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
    SCALE_RATIO = 1;
  }
  if (LOW_QUALITY) {
    noSmooth();
  }
  frameRate( FRAME_RATE );
  ellipseMode(RADIUS);
  rectMode(CENTER);
  currentState = new MainMenu();
  StateManager.pushState( currentState );
  noFill();
  InputManager.addController( new KeyboardController() );
  if ( AUDIO_INPUT_ENABLED ) {
    InputManager.addController( new MicrophoneController() );
  }
  if ( MOUSE_CONTROLLER ) {
    InputManager.addController( new MouseController() );
  }
}

/**
 * Update method. Called by processing every frame.
 */
void draw() {
  // Compensate for different resolutions
  scale(SCALE_RATIO);
  currentState = StateManager.getCurrentState();
  // Process input from controllers
  InputManager.updateControllers();
  // Use the input now stored in InputManager the game
  currentState.input();
  // Perform state update
  currentState.update();
  // Draw the state
  currentState.draw();
  
  // Draw framerate
  if (DEBUG_MODE) {
    fill(255);
    text("FPS: " + frameRate, 1, height-1);
  }
}

/**
 * Called by processing at the beginning of the game to enable or disable fullscreen mode.
 * @return: true if the game should run fullscreen.
 */
boolean sketchFullScreen() {
  return FULLSCREEN_MODE;
}

/**
 * Method called by processing when a key is released.
 */
void keyReleased() {
  InputManager.keyReleased();
}

/**
 * Method called by processing when a key is pressed.
 */
void keyPressed() {
  // EVIL HACK! take control of the escape key and stop processing from exiting.
  if (key == ESC) key += 2000;
  // if (key == 'x') InputManager.addEvent( new InputEvent( EV_ACTION_TRIGGER, WAVE_MAX_ENERGY ));
  InputManager.keyPressed();
}

void exitGame() {
  InputManager.closeAll();
  METRICS_LOGGER.close();
  exit();
}