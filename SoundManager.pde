class SoundManager {
  Minim minim;
  AudioPlayer player;
  
  SoundManager(Minim minimRef) {
    this.minim = minimRef;
  }
  
  void playMusic (String file) {
    if (player != null) {
      player.close(); // Ferme l'ancienne musique
    }
    player = minim.loadFile(file);
    
    if (player != null) {
      player.loop();
    } 
    player.pause(); // Si on ne veut pas lancer la musique tout de suite
  }
  
  void startMusic() {
    if (player != null) {
      if (!player.isPlaying()) {
        player.play();
      }
    }
  }
}
