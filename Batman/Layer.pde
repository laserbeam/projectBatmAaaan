/**
 * A colection of objects to be updated and drawn, just to separate spme stuff
 * from Level.
 */
class Layer {
  ArrayList<GameObject> entities;
  Layer() {
    entities = new ArrayList<GameObject>();
  }

  /** Same as ArrayList.add */
  void add( GameObject go ) {
    entities.add( go );
  }

  /** Same as ArrayList.get */
  GameObject get( int i ) {
    return entities.get( i );
  }

  /** Same as ArrayList.size */
  int size() {
    return entities.size();
  }

  /** Update all the objects in the Layer. */
  void update() {
    for ( int i = entities.size()-1; i >= 0; i-- ) {
      GameObject ent = entities.get( i );
      ent.update();
      if ( ent.isDead ) {
        entities.remove( i );
      }
    }   
  }

  /** Draw all the object in the Layer. */
  void draw( float offX, float offY ) {
    for ( int i = 0; i < entities.size(); i++ ) {
      entities.get(i).draw(offX, offY);
    }
  }
};
