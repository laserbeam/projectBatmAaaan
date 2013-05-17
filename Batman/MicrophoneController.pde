import ddf.minim.*;
import ddf.minim.analysis.*;

/**
 * Controller to handle voice input.
 */
class MicrophoneController extends Controller {

  McLeodPitchMethod mpm;
  Minim minim;
  AudioInput input;
  FFT fft;
  int buffSize;
  float maxRms = 0;
  BufferQueue volHist;
  BufferQueue pitchHist;
  protected final int _vhsize = 128;
  private int _counter;
  private float _lastPitch;

  /**
   * Create a MicrophoneControler. Also initialzies MPM.
   */
  MicrophoneController() {
    minim = new Minim( Batman.this );
    input = minim.getLineIn();
    buffSize = input.bufferSize();
    fft = new FFT( buffSize, input.sampleRate() );
    volHist = new BufferQueue( _vhsize );
    pitchHist = new BufferQueue( _vhsize );
    mpm = new McLeodPitchMethod( input.sampleRate(), buffSize );
    println("buffSize: "+buffSize);
    _lastPitch = 0;
  }

  /**
   * Update.
   */
  void update() {
    float rms = 0;
    for ( int i = 0; i < buffSize; i++ ) {
      rms += input.mix.get( i ) * input.mix.get( i );
    }
    rms /= buffSize;
    rms = sqrt( rms );
    // println("rms: "+rms+ " " + maxRms);
    maxRms = max( rms, maxRms );
    volHist.add( rms );

    // First few buffers are empty (probably before the microphone is initialized)
    // This causes divide by 0 errors in MPM.
    if ( rms > 0 ) {
      PitchDetectionResult pdr = mpm.getPitch( input.mix.toArray() );
      // Store the pitches 
      if (pdr.pitch != -1) {
        pitchHist.add( pdr.pitch );
        _lastPitch = pdr.pitch;
      }
      else try {
        pitchHist.add( 0 );
      } catch(IndexOutOfBoundsException e) {};
    
    }
    
    if ( rms > MIN_AMPLITUDE_THRESHOLD ) {
      float amplitude = map( rms, MIN_AMPLITUDE_THRESHOLD, MAX_AMPLITUDE_THRESHOLD, 0, 1 );
      float wavePitch = map( _lastPitch, MIN_PITCH, MAX_PITCH, 0, 1 );
      if (wavePitch < 0) wavePitch = 0;
      if (wavePitch > 1) wavePitch = 1;
      if (amplitude > 1) amplitude = 1;
      InputManager.addEvent( new InputEvent( EV_ACTION_TRIGGER, amplitude, wavePitch ));
    }

    // Debugging some pitch and drawing a line
    // Note background(0) must not show up in the draw method of the state where one wants tot est this.
    // background(0);
    // stroke(0, 255, 255);
    // for ( int i = 0; i < pitchHist.size - 1; i++ ) {
    //   line ( 3*i, pitchHist.get(i),
    //          3*(i+1), pitchHist.get(i+1) );
    // }
  }
};