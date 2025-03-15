/**
* GameManager - Gestion principale du jeu
*
* Constantes de configuration du jeu
**/
class GameManager {
    static final int DEFAULT_LIVES = 3;             // Nombre de vies initiales
    static final int WIN_SCORE = 3;                 // Score nécessaire pour gagner
    static final float P1_START_X = 0.19f;          // Position X relative du joueur 1
    static final float P2_START_X = 0.77f;          // Position X relative du joueur 2
    static final float PLAYER_START_Y = 700.0f;     // Distance du bas de l'écran pour le spawn
    static final color P1_COLOR = #00FF00;          // Couleur du joueur 1 (vert)
    static final color P2_COLOR = #FF0000;          // Couleur du joueur 2 (rouge)

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private Player player1;                  // Joueur 1
    private Player player2;                  // Joueur 2
    private Arena arena;                     // Arène de jeu
    private boolean gameOver;                // État de fin de partie
    private ArrayList<Weapon> weapons;       // Liste des armes en jeu
    private AssetManager assets;             // Gestionnaire des ressources
    private WeaponSpawner weaponSpawner;     // Gestionnaire d'apparition des armes
    private UIManager uiManager;             // Gestionnaire de l'interface
    private VictoryScreen victoryScreen;     // Écran de victoire
    private GameState gameState;             // Gestionnaire d'état du jeu
    private ArrayList<Event> events;         // Liste des événements
    private Minim minim;                     // Gestionnaire audio
    private String currentMapName;           // Nom de la map actuelle
    private boolean active = true;           // État d'activation du jeu

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du GameManager
    * @param minim Gestionnaire audio pour la musique et les sons
    **/
    GameManager(Minim minim)
    {
        this.minim = minim;
        this.currentMapName = "battlefield";
        initializeGame();
    }

    void startGame(String mapName)
    {
        this.currentMapName = mapName;
        this.active = false;
        reset();
        setupArena(mapName);
        initializePlayers();

        if (weaponSpawner == null) {
            weaponSpawner = new WeaponSpawner(weapons, assets, arena.platforms);
        } else {
            weaponSpawner = new WeaponSpawner(weapons, assets, arena.platforms);
        }
        if (gameState == null) {
            gameState = new GameState(this);
        }
        gameState.startCountdown();
    }

    void update()
    {
        if (gameState != null) {
            gameState.update();
        } else {
            println("ERREUR: gameState est null!");
        }
    }

    void draw()
    {
        if (gameState != null) {
            gameState.draw();
        } else {
            println("ERREUR: gameState est null!");
        }
    }

    void reset()
    {
        if (victoryScreen != null) {
            victoryScreen.reset();
        }
        gameOver = false;
        if (arena != null && arena.soundManager != null) {
            arena.soundManager.stopMusic();
        }
        if (player1 != null && player2 != null) {
            resetPlayers();
        }
        if (weapons != null) {
            weapons.clear();
        }
        if (events != null) {
            events.clear();
        }
        if (gameState != null) {
            gameState.reset();
        }
    }

    // Getters
    boolean hasGameStarted() { return gameState != null && gameState.hasGameStarted(); }
    boolean isCountingDown() { return gameState != null && gameState.isCountingDown(); }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void initializeGame()
    {
        assets = new AssetManager();
        weapons = new ArrayList<Weapon>();
        events = new ArrayList<Event>();
        setupArena(currentMapName);
        initializePlayers();
        weaponSpawner = new WeaponSpawner(weapons, assets, arena.platforms);
        uiManager = new UIManager(assets.getNumbers(), assets.getP1Life(), assets.getP2Life());
        victoryScreen = new VictoryScreen();
        gameState = new GameState(this);
        gameOver = false;
    }

    private void initializePlayers()
    {
        player1 = new Player(width * P1_START_X, height - PLAYER_START_Y, assets.getPlayerSprite1(), assets.getBulletSimple(), P1_COLOR, 1);
        player2 = new Player(width * P2_START_X, height - PLAYER_START_Y, assets.getPlayerSprite2(), assets.getBulletSimple(), P2_COLOR, -1);

        player1.setPlatforms(arena.platforms);
        player2.setPlatforms(arena.platforms);
    }

    private void setupArena(String mapName)
    {
        arena = new Arena(width, height, this.minim, mapName);
        if (player1 != null) player1.setPlatforms(arena.platforms);
        if (player2 != null) player2.setPlatforms(arena.platforms);
    }

    private void updatePlayers()
    {
        player1.update();
        player2.update();
    }

    private void resetPlayers()
    {
        player1.score = 0;
        player2.score = 0;
        player1.lives = DEFAULT_LIVES;
        player2.lives = DEFAULT_LIVES;
        player1.reset();
        player2.reset();
    }

    private void drawWeapons()
    {
        for (Weapon weapon : weapons) {
            if (!weapon.isPickedUp) {
                weapon.draw();
            }
        }
    }

    private void handleWeaponPickups()
    {
        for (Weapon weapon : weapons) {
            if (weapon.canPickup(player1) && keyPressed && key == ' ') {
                weapon.pickup(player1);
            }
            if (weapon.canPickup(player2) && keyPressed && key == '0') {
                weapon.pickup(player2);
            }
        }
    }

    private void checkCollisions()
    {
        checkBulletCollisions();
        checkPlayerDeaths();
        checkArenaCollisions();
    }

    private void checkBulletCollisions()
    {
        checkPlayerBulletCollision(player1, player2);
        checkPlayerBulletCollision(player2, player1);
    }

    private void checkPlayerBulletCollision(Player shooter, Player target)
    {
        int hitIndex = shooter.combat.bullet.checkHit(target);

        if (hitIndex >= 0) {
            handleHit(shooter, target, hitIndex);
            shooter.combat.bullet.removeBullet(hitIndex);
        }
    }

    private void checkPlayerDeaths()
    {
        if (arena.checkPlayerDeath(player1)) handleDeath(player1, player2);
        if (arena.checkPlayerDeath(player2)) handleDeath(player2, player1);
    }

    private void checkArenaCollisions()
    {
        player1.setArena(arena);
        player2.setArena(arena);
        player1.handleArenaCollision();
        player2.handleArenaCollision();
    }

    private void handleHit(Player attacker, Player target, int bulletIndex)
    {
        float baseDamage = attacker.combat.bullet.getDamageForBullet(bulletIndex);
        float baseKnockback = 5;
        int knockbackDirection = (attacker.pos.x < target.pos.x) ? 1 : -1;

        baseDamage = round(baseDamage * 10) / 10.0;
        target.takeDamage(baseDamage, baseKnockback, knockbackDirection);
    }

    private void handleDeath(Player deadPlayer, Player winner)
    {
        deadPlayer.lives--;
        winner.score++;
        deadPlayer.reset();

        if (deadPlayer.lives <= 0 || winner.score >= WIN_SCORE) {
            gameOver = true;
            victoryScreen.startAnimation(winner, deadPlayer);
        }
    }
}