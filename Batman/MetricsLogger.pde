class MetricsLogger {
  private PrintWriter _output;
  private String _t;
  MetricsLogger() {
    if (!LOG_METRICS) return;
    int s = second();
    int m = minute();
    int h = hour()
;    int d = day();
    int mon = month();
    String date = String.valueOf(mon)+String.valueOf(d)+String.valueOf(h)+String.valueOf(m)+String.valueOf(s);
    _output = createWriter(METRICS_PATH + "session" + date + ".csv");
    logConfig();
  }

  private void _updateTime() {
    _t = String.valueOf( ((float)millis())/1000 );
  }

  void logConfig() {
    if (!LOG_METRICS) return;
    _output.println("MicrophoneEnabled,"+String.valueOf(AUDIO_INPUT_ENABLED));
    _output.println("XboxActionsEnabled,"+String.valueOf(XBOX_ACTIONS_CONTROLLER));
    _output.println("FullscreenMode,"+String.valueOf(FULLSCREEN_MODE));
  }

  void logNewLevel( Level L ) {
    if (!LOG_METRICS) return;
    _updateTime();
    _output.println("NewLevel,"+_t+","+L.name);
  }

  void logFinishLevel( Level L ) {
    if (!LOG_METRICS) return;
    _updateTime();
    _output.println("FinishLevel,"+_t+","+L.name);
  }

  void logExitLevel( Level L ) {
    if (!LOG_METRICS) return;
    _updateTime();
    _output.println("ExitLevel,"+_t+","+L.name);
  }

  void logEvent( String tag, String value ) {
    if (!LOG_METRICS) return;
    _updateTime();
    String s = tag+","+_t+","+value;
    _output.println(s);
  }

  void logGameState( Level L ) {
    if (!LOG_METRICS) return;
    _updateTime();
    _output.println("Pos,"+_t+","+L.currentPlayer.x+","+L.currentPlayer.y);
    int draw_cell_start_x, draw_cell_start_y;
    int draw_cell_end_x, draw_cell_end_y;
    int total_cell_count = 0;
    int visible_cell_count = 0;
    draw_cell_start_x = min(L.w,max(0,-L.offX/WALLSIZE));
    draw_cell_start_y = min(L.h,max(0,-L.offY/WALLSIZE));
    draw_cell_end_x = max(0,min(L.w,draw_cell_start_x+(width/WALLSIZE)+2));
    draw_cell_end_y = max(0,min(L.h,draw_cell_start_y+(height/WALLSIZE)+2));
    for ( int x = draw_cell_start_x; x<draw_cell_end_x; x++ ) {
      for ( int y = draw_cell_start_y; y<draw_cell_end_y; y++ ) {
        if ( L.map[x][y] != null ) {
          ++total_cell_count;
          if ( L.map[x][y].alpha > 10 ) ++visible_cell_count;
        }
      }
    }    
    _output.println("MapVis,"+_t+","+visible_cell_count+","+total_cell_count);
  }

  void close() {
    if (!LOG_METRICS) return;
    _output.flush();
    _output.close();
  }
};