/**
* DestroyPlateform - Gestion d'un événement de destruction et de respawn d'une plateforme
*
* Constantes de configuration de la destruction de plateformes
**/
class DestroyPlateform extends Event {
    static final int WARNING_DURATION = 90;        // Durée de l'avertissement (~1.5 sec)
    static final int RESPAWN_DELAY = 300;          // Délai avant le respawn (5 secondes à 60 FPS)
    static final int WARNING_ALPHA = 150;          // Transparence de l'avertissement
    static final color WARNING_COLOR = #FF0000;    // Couleur de l'avertissement (rouge)

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private Arena arena;                // L'arène où se trouve la plateforme
    private Platform platform;          // La plateforme à détruire
    private int timer;                  // Timer avant la destruction
    private boolean warning;            // Phase d'avertissement
    private boolean destroyed;          // Statut de la plateforme
    private int respawnTimer;           // Timer pour le respawn

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'événement de destruction
    * @param arena L'arène où se trouve la plateforme
    * @param platform La plateforme à détruire
    **/
    DestroyPlateform(Arena arena, Platform platform)
    {
        this.arena = arena;
        this.platform = platform;
        this.timer = WARNING_DURATION;
        this.warning = true;
        this.destroyed = false;
        this.respawnTimer = 0;
    }

    void update()
    {
        if (!destroyed) {
            handleWarningPhase();
        } else {
            handleRespawnPhase();
        }
    }

    void display()
    {
        if (warning && frameCount % 10 < 5) {
            fill(WARNING_COLOR, WARNING_ALPHA);
            rect(platform.x, platform.y, platform.w, platform.h);
        }
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void handleWarningPhase()
    {
        timer--;
        if (timer <= 0) {
            destroy();
        }
    }

    private void handleRespawnPhase()
    {
        respawnTimer++;
        if (respawnTimer >= RESPAWN_DELAY) {
            respawn();
        }
    }

    private void destroy()
    {
        arena.platforms.remove(platform);
        destroyed = true;
        warning = false;
        respawnTimer = 0;
    }

    private void respawn()
    {
        Platform respawnedPlatform = new Platform(platform.x, platform.y, platform.w, platform.h, platform.isMain, arena.currentMap);
        arena.platforms.add(respawnedPlatform);
        destroyed = false;
        respawnTimer = 0;
    }
}