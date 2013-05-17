/******
 * This file contains some utility functions (genrally math) to be used all
 * over the place.
 ******/

/**
 * Get the distance from a point to a segment.
 * @param x: X coordinate for Point
 * @param y: Y coordinate for Point
 * @param x1: X coordinate for Segment end A
 * @param y1: Y coordinate for Segment end A
 * @param x2: X coordinate for Segment end B
 * @param y2: Y coordinate for Segment end B
 */

float log2( float n ) {
  return log(n)/log(2);
}

float distToSegment( float x, float y, float x1, float y1, float x2, float y2 ) {
  float d1 = dist(x, y, x1, y1);
  float d2 = dist(x, y, x2, y2);
  PVector proj = projectToVector( new PVector( x-x1, y-y1 ),
                                  new PVector( x2-x1, y2-y1 ));
  proj.x += x1;
  proj.y += y1;
  if ( abs(abs(x2-x1) - abs(x2-proj.x) - abs(proj.x-x1)) < 0.001 &&
       abs(abs(y2-y1) - abs(y2-proj.y) - abs(proj.y-y1)) < 0.001 ) {
    return dist( x, y, proj.x, proj.y );
    // d1 = distToVector( new PVector(x, y), new PVector(x1, y1), new PVector(x2, y2));
    // return d1;
  }
  return min(d1, d2);
}

/**
 * Get the distance from a point to a line defined by 2 points (uses vectors).
 * @param p: A vector for the Point
 * @param a: A vector for the Segment end A
 * @param b: A vector for the Segment end B
 */
float distToVector( PVector p, PVector a, PVector b ) {
  // (a-p) - ((a-p).n)n where n = b-a is the vector from point P to the line AB 
  PVector n = b.get();
  n.sub(a);
  PVector x = a.get();
  x.sub(p);
  x.sub( projectToVector(x, n) );
  return x.mag();
}

/**
 * Returns the projection of a vector on another.
 * @param source: The vector which is projected.
 * @param target: The vector which source is projected onto.
 */
PVector projectToVector( PVector source, PVector target ) {
  PVector res = target.get();
  // res.normalize();
  // println("source: "+source.dot(target));
  res.mult( (source.dot(target))/(target.dot(target)) );
  return res;
}

/**
 * Apply accelerating decay to a value (slower when it's close to max and fast
 * decay as it approaches 0).
 */
float applyDecay( float value, float rate, float max ) {
  return max( 0, value - rate*sqrt(value/max) );
}