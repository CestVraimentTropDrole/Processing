/**
* StartScreen - Gestion de l'écran de démarrage du jeu
*
* Constantes de configuration du menu
**/
class StartScreen {
    static final float OPTIONS_Y = 700;            // Position verticale des options
    static final float VS_Y_OFFSET = -80;          // Décalage vers le haut pour l'option VS
    static final float SHAKE_AMOUNT = 2;           // Intensité du tremblement
    static final float ICON_SIZE = 320;            // Taille des icônes
    static final float ICON_HOVER_SIZE = 360;      // Taille des icônes en survol
    static final float ICON_SPACING = 450;         // Espacement entre les icônes

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private boolean active;                       // État d'affichage du menu
    private GameManager game;                     // Référence au gestionnaire de jeu
    private final String[] menuOptions;           // Options du menu
    private int selectedOption;                   // Option actuellement sélectionnée
    private MapSelector mapSelector;              // Sélecteur de map
    private PImage backgroundImage;               // Image de fond du menu
    private PImage[] menuIcons;                   // Tableau d'icônes pour les options du menu

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
        this.mapSelector = new MapSelector(game);
        loadAssets();
    }

    void draw()
    {
        if (mapSelector.isActive()) {
            mapSelector.draw();
        } else if (active) {
            image(backgroundImage, 0, 0, width, height);
            drawMenuOptions();
        }
    }

    void handleKeyPressed(char key, int keyCode)
    {
        if (mapSelector.isActive()) {
            mapSelector.handleKeyPressed(key, keyCode);
        } else {
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
    }

    void mousePressed()
    {
        if (mapSelector.isActive()) {
            mapSelector.mousePressed();
        } else {
            float startX = width/2 - ((menuOptions.length-1) * ICON_SPACING/2);
            for (int i = 0; i < menuOptions.length; i++) {
                float x = startX + (i * ICON_SPACING);
                float iconSize = (i == selectedOption) ? ICON_HOVER_SIZE : ICON_SIZE;
                float y = OPTIONS_Y;
                if (i == 1) {
                    y += VS_Y_OFFSET;
                }
                if (mouseX > x - iconSize/2 && mouseX < x + iconSize/2 &&
                    mouseY > y - iconSize/2 && mouseY < y + iconSize/2) {
                    selectedOption = i;
                    selectCurrentOption();
                    break;
                }
            }
        }
    }

    boolean isActive()
    {
        if (!game.active) {
            active = false;
            return false;
        }
        return active || mapSelector.isActive();
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void loadAssets()
    {
        backgroundImage = loadImage("assets/sprites/background/menus/background_modeselect.png");
        backgroundImage.resize(width, height);
        menuIcons = new PImage[menuOptions.length];
        menuIcons[0] = loadImage("assets/sprites/ui/icon_solo.png");
        menuIcons[1] = loadImage("assets/sprites/ui/icon_vs.png");
        menuIcons[2] = loadImage("assets/sprites/ui/icon_train.png");
        for (int i = 0; i < menuIcons.length; i++) {
            menuIcons[i].resize((int)ICON_SIZE, (int)ICON_SIZE);
        }
    }

    private void drawMenuOptions()
    {
        float startX = width/2 - ((menuOptions.length-1) * ICON_SPACING/2);
        for (int i = 0; i < menuOptions.length; i++) {
            float x = startX + (i * ICON_SPACING);
            boolean isSelected = (i == selectedOption);
            float y = OPTIONS_Y;
            if (i == 1) {
                y += VS_Y_OFFSET;
            }
            if (isSelected) {
                drawSelectedIcon(x, y, i);
            } else {
                drawNormalIcon(x, y, i);
            }
            fill(255);
            textSize(24);
            textAlign(CENTER, CENTER);
            text(menuOptions[i], x, y + (isSelected ? ICON_HOVER_SIZE/2 + 30 : ICON_SIZE/2 + 30));
        }
    }

    private void drawNormalIcon(float x, float y, int iconIndex)
    {
        imageMode(CENTER);
        image(menuIcons[iconIndex], x, y, ICON_SIZE, ICON_SIZE);
        imageMode(CORNER);
    }

    private void drawSelectedIcon(float x, float y, int iconIndex)
    {
        float shakeX = random(-SHAKE_AMOUNT, SHAKE_AMOUNT);
        float shakeY = random(-SHAKE_AMOUNT, SHAKE_AMOUNT);

        imageMode(CENTER);
        image(menuIcons[iconIndex], x + shakeX, y + shakeY, ICON_HOVER_SIZE, ICON_HOVER_SIZE);
        imageMode(CORNER);
    }

    private void selectCurrentOption()
    {
        switch(selectedOption) {
            case 0:  // BAGAR
                mapSelector.activate(0);
                break;
            case 1:  // 1V1
                mapSelector.activate(1);
                break;
            case 2:  // TRAIN
                mapSelector.activate(2);
                break;
        }
    }
}