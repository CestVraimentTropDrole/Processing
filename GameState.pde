/**
* GameState - Gestion de l'état du jeu et de son rendu
*
* Constantes de configuration de l'état du jeu
**/
class GameState {
    static final float COUNTDOWN_SCALE = 3.0f;      // Échelle du texte du compte à rebours
    static final int COUNTDOWN_START = 3;           // Compte à rebours initial
    static final int COUNTDOWN_FRAME_DURATION = 60; // Durée d'un frame du compte à rebours

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private int countdownValue;                     // Valeur actuelle du compte à rebours
    private int countdownTimer;                     // Timer pour le compte à rebours
    private boolean isCountingDown;                 // État du compte à rebours
    private boolean gameStarted;                    // État du jeu
    private final GameManager gameManager;          // Référence au gestionnaire de jeu
    private final EventManager eventManager;        // Gestionnaire des événements

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du GameState
    * @param gameManager Référence au gestionnaire de jeu
    **/
    GameState(GameManager gameManager)
    {
        this.gameManager = gameManager;
        this.eventManager = new EventManager(gameManager);
        reset();
    }

    void update()
    {
        if (!gameManager.gameOver) {
            if (isCountingDown) {
                updateCountdown();
            } else if (gameStarted) {
                updateGameplay();
            }
        } else {
            gameManager.victoryScreen.update();
        }
    }

    void draw()
    {
        if (!gameManager.gameOver) {
            drawGameplay();
            drawCountdown();
            drawEvents();
        } else {
            gameManager.victoryScreen.draw();
        }
    }

    void startCountdown()
    {
        countdownValue = COUNTDOWN_START;
        countdownTimer = COUNTDOWN_FRAME_DURATION;
        isCountingDown = true;
        gameStarted = false;
    }

    void reset()
    {
        countdownValue = COUNTDOWN_START;
        countdownTimer = COUNTDOWN_FRAME_DURATION;
        isCountingDown = false;
        gameStarted = false;
    }

    // Getters
    boolean hasGameStarted() { return gameStarted; }
    boolean isCountingDown() { return isCountingDown; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void updateGameplay()
    {
        gameManager.updatePlayers();
        gameManager.checkCollisions();
        gameManager.weaponSpawner.update();
        gameManager.handleWeaponPickups();
        eventManager.update();
    }

    private void drawGameplay()
    {
        background(200);
        gameManager.arena.draw();
        gameManager.uiManager.displayScore(gameManager.player1, gameManager.player2);
        gameManager.drawWeapons();
        gameManager.player1.draw();
        gameManager.player2.draw();
    }

    private void drawCountdown()
    {
        if (isCountingDown && countdownValue > 0) {
            pushMatrix();
            imageMode(CENTER);
            translate(width/2, height/2);
            scale(COUNTDOWN_SCALE);
            image(gameManager.assets.getNumbers()[countdownValue], 0, 0);
            imageMode(CORNER);
            popMatrix();
        }
    }

    private void drawEvents()
    {
        for (Event e : gameManager.events) {
            e.display();
        }
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
}