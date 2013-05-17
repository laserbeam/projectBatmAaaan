/**
 * MainMenu.
 *
 * A State for the MainMenu. It's built as a Level for improved sexyness.
 */
class MainMenu extends Level {
  /** Will spawn new waves every 'counter' frames. */
  int counter;

  /**
   * Create the MainMenu.
   */
  MainMenu() {
    super( "maps/MainMenu.tmx" );
    offX = floor( ((width/SCALE_RATIO - 800) / 2 + WALLSIZE/2) );
    offY = floor( ((height/SCALE_RATIO - 560) / 2 + WALLSIZE/2) );
    currentPlayer.alpha = 0;
    counter = 24;
    for ( int i = 0; i < w; i++ ) {
      for ( int j = 0; j < h; j++ ) {
        if ( map[i][j] != null ) map[i][j].minAlpha = 15;
      }
    }
    ui.enabled = false;
  }

  /**
   * Process input.
   */
  void input() {
    InputEvent e = InputManager.getEvent();
    while ( e != null ) {
      // EV_MOVE SHOULD BE REMOVED! It's there to test as no controllers sends EV_ACTION_TRIGGER yet.
      switch ( e.code ) {
        case EV_ACTION_TRIGGER: // Shout to start the game.
          if (e.x < 0.9) break;
        case EV_START_GAME:
        // case EV_MOVE: // this is how you make OR in a switch case statement
          // Level x = LEVEL_MANAGER.get( 0 );
          // Level x = new Level("maps/BreakAndSwitch.tmx");
          StateManager.pushState( LEVEL_MANAGER.get( 0 ) );
          // StateManager.pushState( new InstructionsScreen() ); // Only use this with an XboxController!!!
          break;
        case EV_END_STATE:
          println("ENDSTATE");
          StateManager.popState();
          // The missing break is intentional for now, when exiting the main menu the game should stop.
          // Quickest way to do it this way now.
        case EV_EXIT_GAME:
          exitGame();          
          break;
      }
      e = InputManager.getEvent();
    }
  }

  /**
   * Process frame update.
   */
  void update() {
    if ( counter == 55 ) {
      counter = 0;
      Wave w = spawnWave( -offX+width/SCALE_RATIO/2, -offY, PI/2, PI, width+height);
      w.alpha = 100;
      w._decayMode = DECAY_NONE;
    }
    counter++;
    super.update();
  }

  /**
   * Render.
   */
  void draw() {
    super.draw();
  }
};
