/**
* GameState - Gestion de l'état du jeu et de son rendu
*
* Constantes de configuration de l'état du jeu
**/
class GameState {
    static final float COUNTDOWN_SCALE = 0.8f;      // Échelle réduite du texte du compte à rebours
    static final int COUNTDOWN_START = 3;           // Compte à rebours initial
    static final int COUNTDOWN_FRAME_DURATION = 60; // 60 frames = 1 seconde à 60 FPS
    static final int GO_DURATION = 60;              // Durée d'affichage du "GO"

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private int countdownValue;                     // Valeur actuelle du compte à rebours
    private int countdownTimer;                     // Timer pour le compte à rebours
    private boolean isCountingDown;                 // État du compte à rebours
    private boolean showingGo;                      // État d'affichage du "GO"
    private boolean gameStarted;                    // État du jeu
    private final GameManager gameManager;          // Référence au gestionnaire de jeu
    private final EventManager eventManager;        // Gestionnaire des événements
    private int startTime;                          // Moment où la partie commence
    private int seconde, dixieme;                   // Valeurs du timer

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
        showingGo = false;
        gameStarted = false;
    }

    void reset()
    {
        countdownValue = COUNTDOWN_START;
        countdownTimer = COUNTDOWN_FRAME_DURATION;
        isCountingDown = false;
        showingGo = false;
        gameStarted = false;
    }

    // Getters
    boolean hasGameStarted() { return gameStarted; }
    boolean isCountingDown() { return isCountingDown || showingGo; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void updateGameplay()
    {
        gameManager.player1.update();
        if (gameManager.gameMode != GameManager.MODE_TRAIN) {
            gameManager.player2.update();
        }
        gameManager.checkCollisions();
        gameManager.weaponSpawner.update();
        gameManager.handleWeaponPickups();
        eventManager.update();
        updateTimer();
    }

    private void drawGameplay()
    {
        background(200);
        gameManager.arena.draw();
        gameManager.uiManager.displayScore(gameManager.player1, gameManager.player2);
        gameManager.uiManager.displayTimer(seconde, dixieme);
        gameManager.drawWeapons();
        gameManager.player1.draw();
        gameManager.player2.draw();
    }

    private void drawCountdown()
    {
        if (isCountingDown || showingGo) {
            pushMatrix();
            imageMode(CENTER);
            translate(width/2, height/6);
            scale(COUNTDOWN_SCALE);

            String filename;
            if (showingGo) {
                filename = "go.png";
            } else if (countdownValue > 0) {
                filename = countdownValue + "_counter.png";
            } else {
                return;
            }
            image(loadImage("assets/sprites/ui/" + filename), 0, 0);
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
            if (countdownValue > 0) {
                countdownValue--;
                countdownTimer = COUNTDOWN_FRAME_DURATION;
                if (countdownValue == 0) {
                    showingGo = true;
                    countdownTimer = GO_DURATION;
                }
            } else if (showingGo) {
                showingGo = false;
                isCountingDown = false;
                gameStarted = true;
                startTime = millis();
            }
        }
    }

    private void updateTimer()
    {
        int timer = 0;
        if (gameStarted) {
            timer = millis() - startTime;
            seconde = timer / 1000;
            dixieme = (timer / 100) % 10;
        }
    }
}