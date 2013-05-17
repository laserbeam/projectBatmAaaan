class UserInterface {

  float waveDrawSomething;
  boolean enabled;

  UserInterface() {
    waveDrawSomething = 0;
    enabled = true;
  }

  void draw( Player currentPlayer ) {
    if ( !enabled ) return;
    if ( !XBOX_ACTIONS_CONTROLLER ) return;
    fill(40, 150, 70, 120);
    noStroke();
    arc(50, 50, 30, 30, HALF_PI, HALF_PI+(PI+HALF_PI)*currentPlayer.energy, PIE );
    fill(40, 150, 70, 100*waveDrawSomething);
    arc(50, 50, 5+25*waveDrawSomething, 5+25*waveDrawSomething, HALF_PI-TWO_PI+(PI+HALF_PI)*currentPlayer.energy, HALF_PI, PIE);
    waveDrawSomething -= 0.09;
  }

  void waveSpawned( float waveEnergy ) {
    waveDrawSomething = waveEnergy;
  }


    
};
