/**
 * StateManager.
 *
 * Singleton that handles states. States are added into a stack, updates are
 * done only on the top state, and when that state is removed the StateManager
 * returns to the previous one.
 */
static class StateManager {
  /** A stack of States. */
  static ArrayList<State> states = new ArrayList<State>();
  /** A pointer to the top State. */
  static State currentState = null;

  /**
   * @return: The current state
   */
  static State getCurrentState() {
    return currentState;
  }

  /**
   * Add a State to sthe stack.
   * @param state: The State to be added.
   */
  static void pushState( State state ) {
    if (state == null) return;
    state.init();
    currentState = state;
    states.add(state);
  }

  /**
   * Remove a state from the stack.
   * @return: the current state after the removal.
   */
  static State popState() {
    InputManager.clearEventQueue();
    println("size: "+states.size());
    states.remove(states.size()-1);
    if (states.size() < 1) currentState = null;
    else currentState = states.get(states.size()-1);
    return currentState;
  }

  /**
   * Replaces the state at the top of the stack with a new one.
   * @param state: The new State.
   * @return: The state previously on top of the stack.
   */
  static State swapState( State state ) {
    State s = popState();
    pushState( state );
    return s;
  }
};