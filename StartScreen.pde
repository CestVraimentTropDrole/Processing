/**
* StartScreen - Gestion de l'écran de démarrage du jeu
*
* Constantes de configuration de l'interface
**/
class StartScreen {
    static final color BACKGROUND_COLOR = #000000;                            // Couleur de fond
    static final color TEXT_COLOR = #FFFFFF;                                  // Couleur du texte
    static final color BUTTON_COLOR = #00FF00;                                // Couleur du bouton
    static final int TITLE_SIZE = 48;                                         // Taille du titre
    static final int SUBTITLE_SIZE = 32;                                      // Taille du sous-titre
    static final int BUTTON_TEXT_SIZE = 24;                                   // Taille du texte du bouton
    static final float TITLE_Y_RATIO = 1.0/3.0;                               // Position Y relative du titre
    static final float BUTTON_WIDTH = 200;                                    // Largeur du bouton
    static final float BUTTON_HEIGHT = 50;                                    // Hauteur du bouton
    static final String TITLE_TEXT = "Hey Man";                               // Texte du titre
    static final String SUBTITLE_TEXT = "Appuyez sur Espace pour jouer";      // Texte du sous-titre
    static final String BUTTON_TEXT = "START";                                // Texte du bouton

    /**
    * Variables d'état de l'écran
    * @private Accessibles uniquement dans cette classe
    **/
    private boolean active;                            // État d'activation de l'écran
    private final GameManager game;                    // Référence au gestionnaire de jeu

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'écran de démarrage
    * @param gameInstance Référence au gestionnaire de jeu
    **/
    StartScreen(GameManager gameInstance)
    {
        this.active = true;
        this.game = gameInstance;
    }

    boolean isActive()
    {
        return active;
    }

    void draw()
    {
        background(BACKGROUND_COLOR);
        drawTexts();
        drawStartButton();
    }

    void mousePressed()
    {
        checkButtonClick();
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void drawTexts()
    {
        fill(TEXT_COLOR);
        textAlign(CENTER, CENTER);
        textSize(TITLE_SIZE);
        text(TITLE_TEXT, width/2, height * TITLE_Y_RATIO);
        textSize(SUBTITLE_SIZE);
        text(SUBTITLE_TEXT, width/2, height/2);
    }

    private void drawStartButton()
    {
        float buttonX = width/2 - BUTTON_WIDTH/2;
        float buttonY = height/2 + 50;

        fill(BUTTON_COLOR);
        rect(buttonX, buttonY, BUTTON_WIDTH, BUTTON_HEIGHT);
        fill(BACKGROUND_COLOR);
        textSize(BUTTON_TEXT_SIZE);
        text(BUTTON_TEXT, width/2, buttonY + BUTTON_HEIGHT/2);
    }

    private void checkButtonClick()
    {
        float buttonX = width/2 - BUTTON_WIDTH/2;
        float buttonY = height/2 + 50;

        if (mouseX > buttonX && mouseX < buttonX + BUTTON_WIDTH &&
            mouseY > buttonY && mouseY < buttonY + BUTTON_HEIGHT) {
            startGame();
        }
    }

    private void startGame()
    {
        active = false;
        game.startGame();
    }
}