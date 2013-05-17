/**
 * Reads keeps track of level progression and lets us jump through levels.
 * @todo: handle exceptions
 */
class LevelManager {
  String[] levelNames;

  private int _findPos( String item ) {
    for ( int i = 0; i < levelNames.length; ++i ) {
      if ( levelNames[i] == item ) return i;
    }
    return -1;
  }

  /**
   * Creates a LevelManager and loads a list of levels from a txt file (one
   * level name per line).
   */
  LevelManager( String levelsFile ) {
    String[] aux = loadStrings( levelsFile );
    levelNames = new String[aux.length];
    for ( int i = 0; i < aux.length; ++i ) {
      levelNames[ i ] = "maps/" + aux[ i ] + ".tmx";
    }
  }

  LevelManager() {
    this( "maps/levels.txt" );
  }

  /**
   * Get the next level
   * @return: creates a new Level and returns it.
   */
  Level nextLevel( String currentLevelName ) {
    int pos = _findPos( currentLevelName );
    if (pos+1 >= levelNames.length) return null;
    return get( pos+1 );
  }

  /**
   * Get the ith Level.
   * @param i: the number of the level (first level is 0).
   * @return: creates a new Level and returns it.
   */
  Level get( int i ) {
    return new Level( levelNames[ i ] );

  }
};
