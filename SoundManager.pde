/**
* SoundManager - Gestion du système audio du jeu
*
* Constantes de configuration audio
**/
class SoundManager {
    /**
    * Variables d'état audio
    * @private Accessibles uniquement dans cette classe
    **/
    private final Minim minim;            // Moteur audio
    private AudioPlayer player;           // Lecteur audio en cours

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du SoundManager
    * @param minimRef Référence au moteur audio Minim
    **/
    SoundManager(Minim minimRef)
    {
        this.minim = minimRef;
    }

    void playMusic(String file)
    {
        if (player != null) {
            player.close();
        }
        player = minim.loadFile(file);
        if (player != null) {
            player.loop();
        }
        player.pause();
    }

    void startMusic()
    {
        if (player != null && !player.isPlaying()) {
            player.play();
        }
    }
}