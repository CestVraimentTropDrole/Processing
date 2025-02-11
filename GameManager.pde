/**
* GameManager - Gestion principale du jeu
*
* Constantes de configuration du jeu
**/
class GameManager {
    static final int DEFAULT_LIVES = 3;           // Nombre de vies initiales
    static final int WIN_SCORE = 3;               // Score nécessaire pour gagner
    static final float P1_START_X = 0.25f;        // Position X relative du joueur 1
    static final float P2_START_X = 0.75f;        // Position X relative du joueur 2
    static final float PLAYER_START_Y = 200.0f;   // Distance du bas de l'écran pour le spawn
    static final color P1_COLOR = #00FF00;        // Couleur du joueur 1 (vert)
    static final color P2_COLOR = #FF0000;        // Couleur du joueur 2 (rouge)

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private Player player1;                      // Joueur 1
    private Player player2;                      // Joueur 2
    private Arena arena;                         // Arène de jeu
    private boolean gameOver;                    // État de fin de partie
    private ArrayList<Weapon> weapons;           // Liste des armes en jeu
    private AssetManager assets;                 // Gestionnaire des ressources
    private WeaponSpawner weaponSpawner;        // Gestionnaire d'apparition des armes
    private UIManager uiManager;                 // Gestionnaire de l'interface

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du GameManager
    * @param minim Gestionnaire audio pour la musique et les sons
    **/
    GameManager(Minim minim)
    {
        initializeManagers(minim);
        initializePlayers();
        setupArena(minim);
        gameOver = false;
    }

    void startGame()
    {
        gameOver = false;
        resetPlayers();
    }

    void update()
    {
        if (!gameOver) {
            updatePlayers();
            checkCollisions();
            weaponSpawner.update();
            handleWeaponPickups();
        }
    }

    void draw()
    {
        background(200);
        arena.draw();

        if (!gameOver) {
            uiManager.displayScore(player1, player2);
            drawWeapons();
            player1.draw();
            player2.draw();
        } else {
            uiManager.displayGameOver(player1, player2);
        }
    }

    void reset()
    {
        resetPlayers();
        gameOver = false;
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void initializeManagers(Minim minim)
    {
        assets = new AssetManager();
        weapons = new ArrayList<Weapon>();
        setupArena(minim);
        weaponSpawner = new WeaponSpawner(weapons, assets, arena.platforms);
        uiManager = new UIManager(assets.getNumbers(), assets.getP1Life(), assets.getP2Life());
    }

    private void initializePlayers()
    {
        player1 = new Player(width * P1_START_X, height - PLAYER_START_Y, assets.getPlayerSprite1(), assets.getBulletSimple(), P1_COLOR, 1);
        player2 = new Player(width * P2_START_X, height - PLAYER_START_Y, assets.getPlayerSprite2(), assets.getBulletSimple(), P2_COLOR, -1);
    }

    private void setupArena(Minim minim)
    {
        arena = new Arena(width, height, minim);
        if (player1 != null) player1.arena = arena;
        if (player2 != null) player2.arena = arena;
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
        int hitIndex = shooter.bullet.checkHit(target);

        if (hitIndex >= 0) {
            handleHit(shooter, target, hitIndex);
            shooter.bullet.removeBullet(hitIndex);
        }
    }

    private void checkPlayerDeaths()
    {
        if (arena.checkPlayerDeath(player1)) handleDeath(player1, player2);
        if (arena.checkPlayerDeath(player2)) handleDeath(player2, player1);
    }

    private void checkArenaCollisions()
    {
        player1.handleArenaCollision(arena);
        player2.handleArenaCollision(arena);
    }

    private void handleHit(Player attacker, Player target, int bulletIndex)
    {
        float baseDamage = attacker.bullet.getDamageForBullet(bulletIndex);
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
        }
    }
}