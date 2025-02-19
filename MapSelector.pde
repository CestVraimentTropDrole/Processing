/**
* MapSelector - Menu de sélection des maps
*
* Constantes de configuration du sélecteur de map
**/
class MapSelector {
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
    private boolean active;                        // État d'affichage du menu
    private GameManager game;                      // Référence au gestionnaire de jeu
    private ArrayList<MapOption> mapOptions;       // Options de maps disponibles
    private int selectedOption;                    // Option actuellement sélectionnée
    private float optionSpacing;                   // Espacement entre les options
    private int gameMode;                          // Mode de jeu sélectionné

    class MapOption {
        String name;
        String folderName;
        PImage preview;

        MapOption(String name, String folderName)
        {
            this.name = name;
            this.folderName = folderName;
        }
    }

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du sélecteur de map
    * @param gameInstance Référence au gestionnaire de jeu principal
    **/
    MapSelector(GameManager gameInstance)
    {
        this.game = gameInstance;
        this.active = false;
        this.selectedOption = 0;
        this.optionSpacing = width / 3;

        mapOptions = new ArrayList<MapOption>();
        mapOptions.add(new MapOption("BATTLEFIELD", "battlefield"));
        mapOptions.add(new MapOption("BAGARCITY", "bagarcity"));
    }

    void activate(int gameMode)
    {
        this.active = true;
        this.gameMode = gameMode;
        this.selectedOption = 0;
    }

    void draw()
    {
        background(0);
        drawTitle();
        drawMapOptions();
    }

    void handleKeyPressed(char key, int keyCode)
    {
        switch(keyCode) {
            case LEFT:
                selectedOption = (selectedOption - 1 + mapOptions.size()) % mapOptions.size();
                break;
            case RIGHT:
                selectedOption = (selectedOption + 1) % mapOptions.size();
                break;
            default:
                if (key == ' ') {
                    selectCurrentMap();
                }
                break;
        }
    }

    void mousePressed()
    {
        for (int i = 0; i < mapOptions.size(); i++) {
            float x = width/2 - ((mapOptions.size()-1) * optionSpacing/2) + (i * optionSpacing);
            if (mouseX > x - 75 && mouseX < x + 75 &&
                mouseY > OPTIONS_Y - 25 && mouseY < OPTIONS_Y + 25) {
                selectedOption = i;
                selectCurrentMap();
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
        text("SELECT MAP", width/2, TITLE_Y_POSITION);
    }

    private void drawMapOptions()
    {
        textSize(48);
        float startX = width/2 - ((mapOptions.size()-1) * optionSpacing/2);

        for (int i = 0; i < mapOptions.size(); i++) {
            float x = startX + (i * optionSpacing);
            if (i == selectedOption) {
                drawShakingAngles(x, OPTIONS_Y);
            } else {
                drawStaticAngles(x, OPTIONS_Y);
            }
            fill(255);
            noStroke();
            text(mapOptions.get(i).name, x, OPTIONS_Y);
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

    private void selectCurrentMap()
    {
        MapOption selectedMap = mapOptions.get(selectedOption);
        game.startGame(selectedMap.folderName);
        active = false;
    }
}