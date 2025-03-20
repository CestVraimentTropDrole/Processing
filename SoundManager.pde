/**
* SoundManager - Gestion du système audio du jeu
*
* Constantes de configuration audio
**/
class SoundManager {
    /**
    * Variables d'état internes
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

    void loadMusic(String file)
    {
        if (player != null) { //S'il y a déjà une musique qui se joue
            player.close(); //Elle s'arrête
        }
        player = minim.loadFile(file); //Chargement de la musique
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

    void stopMusic()
    {
        if (player != null && player.isPlaying()) {
            player.close();
        }
    }

    void playWeaponSound(String soundFile)
    {
        AudioPlayer soundEffect = minim.loadFile(soundFile);

        if (soundEffect != null) {
            soundEffect.rewind();
            soundEffect.play();
        }
    }
}
