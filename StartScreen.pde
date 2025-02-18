/**
* StartScreen - Gestion de l'écran de démarrage du jeu
*
* Constantes de configuration du menu
**/
class StartScreen {
    static final float TITLE_Y_POSITION = 200;     // Position verticale du titre
    static final float OPTIONS_Y = 600;            // Position verticale des options
    static final float ANGLE_WIDTH = 20;           // Largeur des angles de sélection
    static final float ANGLE_HEIGHT = 20;          // Hauteur des angles de sélection
    static final float BOX_WIDTH = 150;            // Largeur de la boîte de sélection
    static final float BOX_HEIGHT = 50;            // Hauteur de la boîte de sélection
    static final float SHAKE_AMOUNT = 2;           // Intensité du tremblement

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private boolean active;                       // État d'affichage du menu
    private GameManager game;                     // Référence au gestionnaire de jeu
    private final String[] menuOptions;           // Options du menu
    private int selectedOption;                   // Option actuellement sélectionnée
    private float optionSpacing;                  // Espacement entre les options

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du menu de démarrage
    * @param gameInstance Référence au gestionnaire de jeu principal
    **/
    StartScreen(GameManager gameInstance)
    {
        this.game = gameInstance;
        this.active = true;
        this.menuOptions = new String[]{"BAGAR", "1V1", "TRAIN"};
        this.selectedOption = 0;
        this.optionSpacing = width / 4;
    }

    void draw()
    {
        background(0);
        drawTitle();
        drawMenuOptions();
    }

    void handleKeyPressed(char key, int keyCode)
    {
        switch(keyCode) {
            case LEFT:
                selectedOption = (selectedOption - 1 + menuOptions.length) % menuOptions.length;
                break;
            case RIGHT:
                selectedOption = (selectedOption + 1) % menuOptions.length;
                break;
            default:
                if (key == ' ') {
                    selectCurrentOption();
                }
                break;
        }
    }

    void mousePressed()
    {
        for (int i = 0; i < menuOptions.length; i++) {
            float x = optionSpacing + (i * optionSpacing);
            if (mouseX > x - 75 && mouseX < x + 75 &&
                mouseY > OPTIONS_Y - 25 && mouseY < OPTIONS_Y + 25) {
                selectedOption = i;
                selectCurrentOption();
                break;
            }
        }
    }

    boolean isActive()
    {
        return active;
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void drawTitle()
    {
        fill(255);
        textSize(48);
        textAlign(CENTER, CENTER);
        text("SHADOW WIZARD", width/2, TITLE_Y_POSITION);
        text("MONEY GAME", width/2, TITLE_Y_POSITION + 60);
    }

    private void drawMenuOptions()
    {
        textSize(48);
        for (int i = 0; i < menuOptions.length; i++) {
            float x = optionSpacing + (i * optionSpacing);
            if (i == selectedOption) {
                drawShakingAngles(x, OPTIONS_Y);
            } else {
                drawStaticAngles(x, OPTIONS_Y);
            }
            fill(255);
            noStroke();
            text(menuOptions[i], x, OPTIONS_Y);
        }
    }

    private void drawStaticAngles(float x, float y)
    {
        stroke(255);
        strokeWeight(2);
        noFill();

        line(x - BOX_WIDTH/2, y - BOX_HEIGHT/2, x - BOX_WIDTH/2 + ANGLE_WIDTH, y - BOX_HEIGHT/2);
        line(x - BOX_WIDTH/2, y - BOX_HEIGHT/2, x - BOX_WIDTH/2, y - BOX_HEIGHT/2 + ANGLE_HEIGHT);

        line(x + BOX_WIDTH/2 - ANGLE_WIDTH, y + BOX_HEIGHT/2, x + BOX_WIDTH/2, y + BOX_HEIGHT/2);
        line(x + BOX_WIDTH/2, y + BOX_HEIGHT/2 - ANGLE_HEIGHT, x + BOX_WIDTH/2, y + BOX_HEIGHT/2);
    }

    private void drawShakingAngles(float x, float y)
    {
        stroke(255);
        strokeWeight(2);
        noFill();

        float shakeX = random(-SHAKE_AMOUNT, SHAKE_AMOUNT);
        float shakeY = random(-SHAKE_AMOUNT, SHAKE_AMOUNT);

        line(x - BOX_WIDTH/2 + shakeX, y - BOX_HEIGHT/2 + shakeY, x - BOX_WIDTH/2 + ANGLE_WIDTH + shakeX, y - BOX_HEIGHT/2 + shakeY);
        line(x - BOX_WIDTH/2 + shakeX, y - BOX_HEIGHT/2 + shakeY, x - BOX_WIDTH/2 + shakeX, y - BOX_HEIGHT/2 + ANGLE_HEIGHT + shakeY);

        line(x + BOX_WIDTH/2 - ANGLE_WIDTH + shakeX, y + BOX_HEIGHT/2 + shakeY, x + BOX_WIDTH/2 + shakeX, y + BOX_HEIGHT/2 + shakeY);
        line(x + BOX_WIDTH/2 + shakeX, y + BOX_HEIGHT/2 - ANGLE_HEIGHT + shakeY, x + BOX_WIDTH/2 + shakeX, y + BOX_HEIGHT/2 + shakeY);
    }

    private void selectCurrentOption()
    {
        switch(selectedOption) {
            case 0:  // BAGAR
                println("BAGAR selected - Placeholder");
                break;
            case 1:  // 1V1
                active = false;
                game.startGame();
                break;
            case 2:  // TRAIN
                println("TRAIN selected - Placeholder");
                break;
        }
    }
}