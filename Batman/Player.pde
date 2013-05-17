/**
 * The Player.
 *
 * @todo: make this, right now a Unit is a player, but we should subclass a bit.
 */
class Player extends Unit {

  boolean shootingEnabled = true;
  float energy = 1;

  Player( float freq, float x, float y ) {
    super( freq, x, y );
    lightUp( WAVE_MAX_ENERGY );
    img = new Sprite();
    img.setImages( ANIMATION_IDLE, RESOURCE_MANAGER.getImage( "assets/player.png" ) );

  }
  
  void update() {
    if ( !XBOX_ACTIONS_CONTROLLER ) return;
      energy = min ( 1, energy + PLAYER_RECHARGE_RATE );
      if ( energy == 1 ) shootingEnabled = true;
  }

  boolean drainEnergy ( float waveEnergy ) {
    if ( !XBOX_ACTIONS_CONTROLLER ) return true;
    if ( !shootingEnabled ) return false;
    float e = max ( 0, energy - PLAYER_DISCHARGE_FACTOR * waveEnergy );
    if ( e == 0 ) {
      shootingEnabled = false;
    }
    if ( !shootingEnabled ) return false;
    energy = e;
    return true;
  }


};
