/**
 * ResourceManager.
 * Handles ingame assets, so they aren't loaded in memory twice.
 */
class ResourceManager {

  HashMap resources = new HashMap();

  /**
   * Get an image from a file, if the image was already loaded get it from the
   * ResourceManager.
   * @param filename: The filename for the image.
   * @return: The image contained in that file.
   */
  PImage getImage( String filename ) {
    if ( resources.containsKey( filename ) ) {
      return (PImage) resources.get( filename );
    }
    PImage img = loadImage( filename );
    resources.put( filename, img );
    return img;
  }
};