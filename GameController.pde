/**
* GameController - Contrôleur principal du jeu
*
* Constantes de configuration des contrôles
**/
class GameController {
    // Contrôles Joueur 1
    static final char KEY_P1_LEFT = 'q';          // Déplacement gauche J1
    static final char KEY_P1_RIGHT = 'd';         // Déplacement droite J1
    static final char KEY_P1_JUMP = 'z';          // Saut J1
    static final char KEY_P1_CROUCH = 's';        // Accroupissement J1
    static final char KEY_P1_SHOOT = ' ';         // Tir J1
    static final char KEY_P1_DASH = 'e';          // Dash J1
    static final char KEY_P1_RELOAD = 'r';        // Rechargement J1
    static final char KEY_P1_SHIELD = 'a';        // Bouclier J1

    // Contrôles Joueur 2
    static final int KEY_P2_LEFT = LEFT;          // Déplacement gauche J2
    static final int KEY_P2_RIGHT = RIGHT;        // Déplacement droite J2
    static final int KEY_P2_JUMP = UP;            // Saut J2
    static final int KEY_P2_CROUCH = DOWN;        // Accroupissement J2
    static final char KEY_P2_SHOOT = '0';         // Tir J2
    static final char KEY_P2_DASH = 'l';          // Dash J2
    static final char KEY_P2_RELOAD = 'p';        // Rechargement J2
    static final char KEY_P2_SHIELD = 'm';        // Bouclier J2

    // Contrôles globaux
    static final char KEY_RESTART = 'r';          // Redémarrer la partie
    static final char KEY_HOME = 'h';             // Retour au menu
    static final char KEY_START = ' ';            // Démarrer la partie

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private GameManager gameManager;              // Gestionnaire principal du jeu
    private StartScreen startScreen;              // Écran d'accueil
    private Minim minim;                          // Gestionnaire audio

    // États des touches de déplacement
    private boolean leftPressed1 = false;         // Touche gauche J1
    private boolean rightPressed1 = false;        // Touche droite J1
    private boolean leftPressed2 = false;         // Touche gauche J2
    private boolean rightPressed2 = false;        // Touche droite J2

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du GameController
    * @param processingSketch Référence au sketch Processing principal
    **/
    GameController(PApplet processingSketch)
    {
        initializeGame(processingSketch);
    }

    void update()
    {
        if (startScreen.isActive()) {
            startScreen.draw();
        } else {
            updateGame();
            updatePlayerMovements();
        }
    }

    void handleKeyPressed(char key, int keyCode)
    {
        if (startScreen.isActive()) {
            startScreen.handleKeyPressed(key, keyCode);
            if (!startScreen.isActive()) {
                gameManager.arena.soundManager.startMusic();
            }
        } else {
            handleGameInput(key, keyCode);
        }
    }

    void handleKeyReleased(char key, int keyCode)
    {
        handleMovementKeyReleased(key, keyCode);
        handleActionKeyReleased(key, keyCode);
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void initializeGame(PApplet processingSketch)
    {
        minim = new Minim(processingSketch);
        gameManager = new GameManager(minim);
        startScreen = new StartScreen(gameManager);
    }

    private void updateGame()
    {
        gameManager.update();
        gameManager.draw();
    }

    private void updatePlayerMovements()
    {
        if (!gameManager.isCountingDown() && gameManager.hasGameStarted()) {
            updatePlayer1Movement();
            updatePlayer2Movement();
        }
    }

    private void updatePlayer1Movement()
    {
        if (leftPressed1 && !rightPressed1) gameManager.player1.move(-1);
        if (rightPressed1 && !leftPressed1) gameManager.player1.move(1);
    }

    private void updatePlayer2Movement()
    {
        if (leftPressed2 && !rightPressed2) gameManager.player2.move(-1);
        if (rightPressed2 && !leftPressed2) gameManager.player2.move(1);
    }

    private void handleGameInput(char key, int keyCode)
    {
        handleGameStateKeys(key);
        handleMovementKeyPressed(key, keyCode);
        handleActionKeyPressed(key, keyCode);
    }

    private void handleGameStateKeys(char key)
    {
        if (gameManager.gameOver) {
            if (key == KEY_RESTART) {
                gameManager.reset();
            } else if (key == KEY_HOME) {
                startScreen.active = true;
                gameManager.reset();
            }
        }
    }

    private void handleMovementKeyPressed(char key, int keyCode)
    {
        // Joueur 1
        if (key == KEY_P1_LEFT) leftPressed1 = true;
        if (key == KEY_P1_RIGHT) rightPressed1 = true;

        // Joueur 2
        if (keyCode == KEY_P2_LEFT) leftPressed2 = true;
        if (keyCode == KEY_P2_RIGHT) rightPressed2 = true;
    }

    private void handleActionKeyPressed(char key, int keyCode)
    {
        if (!gameManager.isCountingDown() && gameManager.hasGameStarted()) {
            // Actions Joueur 1
            if (key == KEY_P1_JUMP) gameManager.player1.jump();
            if (key == KEY_P1_CROUCH) gameManager.player1.crouch(true);
            if (key == KEY_P1_SHOOT) gameManager.player1.shoot();
            if (key == KEY_P1_DASH) gameManager.player1.dash(leftPressed1, rightPressed1);
            if (key == KEY_P1_RELOAD) gameManager.player1.combat.bullet.startReload();
            if (key == KEY_P1_SHIELD) gameManager.player1.activateShield();

            // Actions Joueur 2
            if (keyCode == KEY_P2_JUMP) gameManager.player2.jump();
            if (keyCode == KEY_P2_CROUCH) gameManager.player2.crouch(true);
            if (key == KEY_P2_SHOOT) gameManager.player2.shoot();
            if (key == KEY_P2_DASH) gameManager.player2.dash(leftPressed2, rightPressed2);
            if (key == KEY_P2_RELOAD) gameManager.player2.combat.bullet.startReload();
            if (key == KEY_P2_SHIELD) gameManager.player2.activateShield();
        }
    }

    private void handleMovementKeyReleased(char key, int keyCode)
    {
        // Joueur 1
        if (key == KEY_P1_LEFT) leftPressed1 = false;
        if (key == KEY_P1_RIGHT) rightPressed1 = false;

        // Joueur 2
        if (keyCode == KEY_P2_LEFT) leftPressed2 = false;
        if (keyCode == KEY_P2_RIGHT) rightPressed2 = false;
    }

    private void handleActionKeyReleased(char key, int keyCode)
    {
        // Joueur 1
        if (key == KEY_P1_CROUCH) gameManager.player1.crouch(false);
        if (key == KEY_P1_SHIELD) gameManager.player1.deactivateShield();

        // Joueur 2
        if (keyCode == KEY_P2_CROUCH) gameManager.player2.crouch(false);
        if (key == KEY_P2_SHIELD) gameManager.player2.deactivateShield();
    }
}