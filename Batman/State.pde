/**
 * A game state. Could be a menu, a congratulations screen, some fancy
 * transition, a level etc.
 */
abstract class State {
  String name;
  void init(){} // Called when a state is loaded by the state manager
  void update(){} // Update the objects contained in this state
  void draw(){} // Draw the state
  void input(){} // Process input from this state
};

