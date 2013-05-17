/**
 * Handles initialization of levels.
 * Pulled out of Level as it's long and tedious...
 * Plus there are a lot of magic values in here.
 *
 * @todo: make this more flexible to mapping, right now the level designer has
 * to knwow some things related to the internals of this file.
 */
class LevelFactory {

  /**
   * Initialize a Level from a file.
   * @param L: The Level to be initialized.
   * @param filename: The .xml file where we read the data.
   */
  void initLevel( Level L, String filename ) {
    XML xml = loadXML( filename );
    XML[] layers = xml.getChildren( "layer" );
    XML[] tilesets = xml.getChildren( "tileset" );
    XML[] objectgroups = xml.getChildren( "objectgroup" );

    int w = layers[0].getInt( "width" );
    int h = layers[0].getInt( "height" );
    initLevel( L, w, h );
    L.currentPlayer = null;
    
    addWallsFromXML( L, layers[0] );
    if ( objectgroups.length > 0 ) {
      addObjectsFromXML( L, objectgroups[0] );
    }
    
    if (L.currentPlayer == null) {
      L.currentPlayer = new Player(440,350,350);
    }
  }

  /**
   * Initializes the containers of a level and their size.
   * @param L: The Level to be initialized.
   * @param w: The width of the Level.
   * @param h: The height of the Level.
   */
  void initLevel( Level L, int w, int h ) {
    L.w = w;
    L.h = h;
    L.map = new Wall[w][h];
    L.waves = new Layer();
    L.entities = new Layer();
    L.entities2 = new Layer();
    L.decorations = new Layer();
    L.ui = new UserInterface();
  }

  /**
   * Adds the walls from an XML object.
   * @param L: The Level to be initialized.
   * @param layer: An XML object which should be a tile layer from Tiled.
   */
  void addWallsFromXML( Level L, XML layer ) {
    XML[] stuff = layer.getChildren( "data" );
    XML[] tiles = stuff[0].getChildren( "tile" );
    for (int i = 0; i < tiles.length; i++) {
      int gid = tiles[i].getInt( "gid" );
      if ( gid != 0 ) {
        int x = i%L.w;
        int y = i/L.w;
        if ( 1 <= gid && gid <= 5 ) {
          L.map[x][y] = new Wall( gid, 440, x*WALLSIZE, y*WALLSIZE );
        } else if ( 6 <= gid && gid <= 10 ) {
          L.map[x][y] = new BreakableWall( gid-5, 440, x*WALLSIZE, y*WALLSIZE);
        }
      }
    }
  }

  /**
   * Adds GameObjects from an XML object.
   * @param L: The Level to be initialized.
   * @param objectgroup: An XML object which should be an object layer from Tiled.
   */
  void addObjectsFromXML( Level L, XML objectgroup ) {
    XML[] objects = objectgroup.getChildren( "object" );

    // Add the player, switches and enemies
    ArrayList<GameObject> tempList = new ArrayList<GameObject>();
    for ( int i = 0; i < objects.length; i++ ) {
      XML o = objects[i];
      if ( !o.hasAttribute( "gid" ) ) continue; // Skip ButtonLines
      int gid = o.getInt( "gid" );
      if ( gid < 26 ) continue;
      float x = o.getFloat( "x" ) + WALLSIZE/2;
      float y = o.getFloat( "y" ) + WALLSIZE/2 - PLAYERSIZE;
      switch ( gid ) {
      case 26 :
        L.currentPlayer = new Player( 440, x, y );
        break;
      case 27 :
        Switch s = new Switch( x, y );
        s.name = o.getString( "name" );
        tempList.add( s );
        break;
      case 28 :
        MicrophoneSwitch m = new MicrophoneSwitch( x, y );
        m.name = o.getString( "name" );
        tempList.add( m );
        break;
      case 29 :
        Exit ex = new Exit( x, y );
        ex.name = o.getString( "name" );
        tempList.add( ex );
        break;
      case 31 :
        Enemy e = new Enemy( 440, x, y,5,0 );
        e.name = o.getString( "name" );
        tempList.add( e );
        break;
      }
    }

    // Lights
    for ( int i = 0; i < objects.length; i++) {
      XML o = objects[i];
      if ( !o.hasAttribute( "gid" ) ) continue;
      int gid = o.getInt( "gid" );
      if ( gid == 30 )
      {
        String n = o.getChild( "properties/property" ).getString( "value" );
        float x = o.getFloat( "x" ) + WALLSIZE/2;
        float y = o.getFloat( "y" ) + WALLSIZE/2 - PLAYERSIZE;
        Speaker sp = new Speaker( x, y );
        sp.name = o.getString( "name" );
        tempList.add( sp );
        for ( int j = 0; j < tempList.size(); j++ ) {
          if ( tempList.get(j).name.equals(n) ) {
            ((Switch)tempList.get(j)).addTarget( sp );
          }
        }
      }
    }

    for ( int i = 0; i < tempList.size(); i++ ) L.entities.add( tempList.get(i) );
    
    // Then add dorrs, as they depend on switches
    for ( int i = 0; i < objects.length; i++) {
      XML o = objects[i];
      if ( !o.hasAttribute("gid")) {
        println("o: "+o+o.getString("type"));
        if ( o.getString("type").equals("Line") ) {
          String n = o.getChild( "properties/property" ).getString( "value" );
          String valueString = o.getChild( "polyline" ).getString( "points" );
          for ( int j = 0; j < tempList.size(); j++ ) {
            println("j: "+j+ " "+ tempList.size());
            println("tem: "+tempList.get(j).name);
            if ( n.equals(tempList.get(j).name )){
              ButtonLine bl = new ButtonLine( tempList.get(j), valueString );
              L.entities2.add(bl);
              ((Switch)tempList.get(j)).addTarget(bl);
              break;
            }
          }
        }
        continue;
      }
      int gid = o.getInt( "gid" );
      if ( gid > 25 ) continue;
      int x = o.getInt( "x" );
      int y = o.getInt( "y" ) - WALLSIZE;
      String n = o.getChild( "properties/property" ).getString( "value" );
      if ( 11 <= gid && gid <= 15 ) {
        Door d = new Door( gid-10, 440, x, y );
        for ( int j = 0; j < tempList.size(); j++ ) {
          if ( tempList.get(j).name != null &&
               tempList.get(j).name.equals(n) ) {
            ((Switch)tempList.get(j)).addTarget( d );
          }
        }
        L.map[(int)x/WALLSIZE][(int)y/WALLSIZE] = d;
      }
    }

  }
};
