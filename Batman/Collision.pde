/**
 * Object that stores a bunch of data on collisions/
 * Where they happened, and the normal of the collision/
 */
class Collision {
  /** The point of collision .*/
  float x, y;
  /** A normalised vector perpendicular to the collided object. */
  PVector normal;
  float _x1, _x2, _y1, _y2;
  /** The distance between the colliding object and the collision point.*/
  float distance;

  /**
   * Create a Collision
   * @param x: The X coordinate.
   * @param y: The Y coordinate.
   * @param normal: The normal vector from the collided object.
   * @param distance: The distance between the colliding object and the collision point.
   */
  Collision( float x, float y, PVector normal, float distance ) {
    this.x = x;
    this.y = y;
    this.normal = normal.get();
    this.normal.normalize();
    this.distance = distance;
  }
};
