/**
* EventManager - Gestion des événements aléatoires du jeu
*
* Constantes de configuration des événements
**/
class EventManager {
    static final int EVENT_INTERVAL = 900;          // Intervalle entre les événements
    static final int BOMB_INTERVAL = 1;             // Intervalle entre les bombes
    static final int MAX_BOMBS = 10;                // Nombre maximum de bombes
    static final float PLATFORM_MARGIN = 20.0f;     // Marge pour le spawn des bombes

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private final GameManager gameManager;          // Référence au gestionnaire de jeu
    private int eventTimer;                         // Compteur pour les événements
    private int bombTimer;                          // Compteur pour les bombes

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'EventManager
    * @param gameManager Référence au gestionnaire de jeu
    **/
    EventManager(GameManager gameManager)
    {
        this.gameManager = gameManager;
        this.eventTimer = 0;
        this.bombTimer = 0;
    }

    void update()
    {
        eventTimer++;
        if (eventTimer > EVENT_INTERVAL) {
            triggerRandomEvent();
            eventTimer = 0;
        }
        updateEvents();
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void triggerRandomEvent()
    {
        int rand = int(random(4));

        switch (rand) {
            case 0:
                spawnBombSequence();
                break;
            case 1:
                destroyRandomPlatform();
                break;
            case 2:
                spawnLaser();
                break;
        }
    }

    private void spawnBombSequence()
    {
        for (int i = 0; i <= MAX_BOMBS; i++) {
            bombTimer++;
            if (bombTimer >= BOMB_INTERVAL) {
                Platform platform = getRandomPlatform();
                if (platform != null) {
                    float bombX = random(platform.x + PLATFORM_MARGIN, platform.x + platform.w - PLATFORM_MARGIN);
                    float bombTargetY = platform.y - 10;
                    gameManager.events.add(new Bomb(bombX, bombTargetY, gameManager.player1, gameManager.player2));
                }
                bombTimer = 0;
            }
        }
    }

    private void destroyRandomPlatform()
    {
        if (!gameManager.arena.platforms.isEmpty()) {
            Platform platformToDestroy = getRandomPlatform();
            if (platformToDestroy != null) {
                gameManager.events.add(new DestroyPlateform(gameManager.arena, platformToDestroy));
            }
        }
    }

    private void spawnLaser()
    {
        gameManager.events.add(new Laser(gameManager.player1, gameManager.player2));
    }

    private Platform getRandomPlatform()
    {
        if (gameManager.arena.platforms.isEmpty())
            return null;
        int index = (int)random(gameManager.arena.platforms.size());
        return gameManager.arena.platforms.get(index);
    }

    private void updateEvents()
    {
        for (int i = gameManager.events.size() - 1; i >= 0; i--) {
            Event e = gameManager.events.get(i);
            e.update();
            if (e.finished) {
                gameManager.events.remove(i);
            }
        }
    }
}