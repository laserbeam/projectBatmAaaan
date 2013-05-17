
/**
 * InputManager.
 *
 * Handles a set of controllers and maintains an event queue.
 * There should be only one event queue, but we may have multiple controllers
 * adding events here. Movement with the xbox and actions with a microphone maybe?
 *
 * (static means there's no instances of this class btw... there's only one of these bastards)
 *
 * You can add InputEvents to the InputManager from anywhere in the code, not just
 * from Controllers.
 */
static class InputManager {
  static ArrayList<InputEvent> eventQueue = new ArrayList<InputEvent>();
  static ArrayList<Controller> controllers = new ArrayList<Controller>();

  /** 
   * Get the latest event, or null if there are no events left.
   */
  static InputEvent getEvent() {
    if ( eventQueue.size() < 1 ) return null;
    InputEvent event = eventQueue.get( 0 );
    eventQueue.remove( 0 );
    return event;
  }

  /**
   * Adds an event to the queue. Should be generally called by subclasses of controller.
   * @param event: The event to be added.
   */
  static void addEvent( InputEvent event ) {
    eventQueue.add( event );
  }

  /**
   * Update all the controllers.
   */
  static void updateControllers() {
    for ( int i = 0; i < controllers.size(); i++ ) {
      controllers.get( i ).update();
    }
  }

  /**
   * Add a controller to the InputManager.
   * @param c: The Controller.
   */
  static void addController( Controller c ) {
    controllers.add( c );
  }

  /**
   * Key release event. This method is triggered when a key is released and passed
   * on to all KeyboardControllers that support the method.
   *
   * This works similar to message passing instead of method calling.
   */
  static void keyReleased() {
    for ( int i = 0; i < controllers.size(); i++ ) {
      try {
        KeyboardController c = (KeyboardController) controllers.get( i );
        c.keyReleased();
      } catch (Exception e) {}
    }
  }

  /**
   * Key press event. This method is triggered when a key is pressed and passed
   * on to all KeyboardControllers that support the method.
   *
   * This works similar to message passing instead of method calling.
   */
  static void keyPressed() {
    for ( int i = 0; i < controllers.size(); i++ ) {
      try {
        KeyboardController c = (KeyboardController) controllers.get( i );
        c.keyPressed();
      } catch (Exception e) {}
    }
  }

  /**
   * Empties the event queue. This should be called when States are changed to flush
   * any pending events that should have been processed in the previous State.
   */
  static void clearEventQueue() {
    eventQueue.clear();
  }

  static void closeAll() {
    for ( int i = 0; i < controllers.size(); ++i ) {
      controllers.get( i ).close();
    }
  }
};

