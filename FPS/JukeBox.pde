class JukeBox {
  AudioPlayer song;
  
  float duration;
  JukeBox() {}
  
  void Stop() {
    if(song == null) {
      return;
    }
    song.pause();
  }
  
  void Play(AudioPlayer newSong) {
    if(song != null) {
      song.pause();
    }
    song = newSong;
    song.loop();
  }
}
