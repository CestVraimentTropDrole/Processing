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
    static final int COUNTDOWN_START = 3;           // Compte à rebours initial
    static final int COUNTDOWN_FRAME_DURATION = 60; // Durée d'un frame du compte à rebours
    static final float COUNTDOWN_SCALE = 3.0f;      // Échelle du texte du compte à rebours

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private Player player1;                                     // Joueur 1
    private Player player2;                                     // Joueur 2
    private Arena arena;                                        // Arène de jeu
    private boolean gameOver;                                   // État de fin de partie
    private ArrayList<Weapon> weapons;                          // Liste des armes en jeu
    private AssetManager assets;                                // Gestionnaire des ressources
    private WeaponSpawner weaponSpawner;                        // Gestionnaire d'apparition des armes
    private UIManager uiManager;                                // Gestionnaire de l'interface
    private int countdownValue;
    private int countdownTimer;
    private boolean isCountingDown;
    private boolean gameStarted;
    private VictoryScreen victoryScreen;
    private int eventTimer = 0;                                 // Compteur pour les événements
    private int eventInterval = 900;                            // Intervalle entre les événements
    private ArrayList<Event> events = new ArrayList<Event>();   // Liste des événements
    private int bombTimer = 0;                                  // Compteur pour les bombes
    private int bombInterval = 1;                               // Intervalle entre les bombes

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
        victoryScreen = new VictoryScreen();
        gameOver = false;
    }

    void startGame()
    {
        reset();
        countdownValue = COUNTDOWN_START;
        countdownTimer = COUNTDOWN_FRAME_DURATION;
        isCountingDown = true;
    }

    void update()
    {
        if (!gameOver) {
            if (isCountingDown) {
                updateCountdown();
            } else if (gameStarted) {
                updatePlayers();
                checkCollisions();
                weaponSpawner.update();
                handleWeaponPickups();
                eventTimer++;
                if (eventTimer > eventInterval) {
                    triggerRandomEvent();
                    eventTimer = 0;
                }
                for (int i = events.size() - 1; i >= 0; i--) {
                    Event e = events.get(i);
                    e.update();
                    if (e.finished) {
                        events.remove(i);
                    }
                }
            }
        } else {
            victoryScreen.update();
        }
    }

    void draw()
    {
        if (!gameOver) {
            background(200);
            arena.draw();
            uiManager.displayScore(player1, player2);
            drawWeapons();
            player1.draw();
            player2.draw();
            if (isCountingDown && countdownValue > 0) {
                pushMatrix();
                imageMode(CENTER);
                translate(width/2, height/2);
                scale(COUNTDOWN_SCALE);
                image(assets.getNumbers()[countdownValue], 0, 0);
                imageMode(CORNER);
                popMatrix();
            }
            for (Event e : events) {
                e.display();
            }
        } else {
            victoryScreen.draw();
        }
    }

    void triggerRandomEvent()
    {
        int rand = int(random(4));

        switch (rand) {
            case 0:
                for (int i=0; i<= 10; i++) {
                    bombTimer++;
                    Platform platform = arena.platforms.get((int)random(arena.platforms.size()));
                    float bombX = random(platform.x + 20, platform.x + platform.w - 20);
                    float bombTargetY = platform.y - 10;
                    if (bombTimer >= bombInterval) {
                        events.add(new Bomb(bombX, bombTargetY, player1, player2));
                        bombTimer = 0;
                    }
                }
                break;
            case 1:
                if (!arena.platforms.isEmpty()) {
                    int index = (int)random(arena.platforms.size());
                    Platform platformToDestroy = arena.platforms.get(index);
                    if (platformToDestroy == null) return; {
                        events.add(new DestroyPlateform(arena, platformToDestroy));
                    }
                }
                break;
            case 2:
                events.add(new Laser(player1, player2));
                break;
        }
    }

    void reset()
    {
        resetPlayers();
        weapons.clear();
        events.clear();
        eventTimer = 0;
        bombTimer = 0;
        gameOver = false;
        isCountingDown = false;
        gameStarted = false;
        victoryScreen.reset();
    }

    // Getters
    boolean hasGameStarted() { return gameStarted; }
    boolean isCountingDown() { return isCountingDown; }

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

        player1.setPlatforms(arena.platforms);
        player2.setPlatforms(arena.platforms);
    }

    private void setupArena(Minim minim)
    {
        arena = new Arena(width, height, minim);
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

    private void updateCountdown()
    {
        countdownTimer--;
        if (countdownTimer <= 0) {
            countdownValue--;
            countdownTimer = COUNTDOWN_FRAME_DURATION;
            if (countdownValue < 1) {
                isCountingDown = false;
                gameStarted = true;
            }
        }
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
