/**
 * A buffer implemented as a queue.
 * Stores float values, should use Templates to make it a bit more flexible.
 * Used for debugging and for storing historical data in MicrophoneController.
 *
 * A BufferQueue has a fixed capacity and will start overwriting old items when
 * it excedes this limit.
 */
class BufferQueue {
  float[] buffer;
  int cap;
  int start;
  int end;
  int size;

  /**
   * Create a buffer of fixed capacity.
   * @param capacity: The number of elements that can fit in the buffer.
   */
  BufferQueue( int capacity ) {
    buffer = new float[capacity];
    start = 0;
    end = 0;
    size = 0;
    cap = capacity;
  }

  /**
   * Add a value to the buffer.
   * @param item: The value to be added.
   */
  void add( float item ) {
    buffer[end] = item;
    end = ( end + 1 ) % cap;
    size++;
    if ( end == start ) {
      start = ( start + 1 ) % cap;
      size--;
    }
  }

  /**
   * Get the ith value in the buffer.
   * @param i: The position in the buffer.
   * @return: The value at the ith position in the buffer.
   */
  float get( int i ) {
    if ( i >= size ) return -1;
    return buffer[ ( i + start ) % cap ];
  }
  /**
   * Get the last value in the buffer.
   * @return: The value last added to the buffer.
   */
  float getLast() {
    if ( size == 0 ) return -1;
    return get( size-1 );
  }

}