/**
* MapSelector - Menu de sélection des maps
*
* Constantes de configuration du sélecteur de map
**/
class MapSelector {
    static final float TITLE_Y_POSITION = 200;     // Position verticale du titre
    static final float OPTIONS_Y = 600;            // Position verticale des options
    static final float SHAKE_AMOUNT = 2;           // Intensité du tremblement
    static final float MAP_PREVIEW_SIZE = 250;     // Taille des aperçus de map
    static final float MAP_HOVER_SIZE = 300;       // Taille des aperçus en survol

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
    private PImage backgroundImage;                // Image de fond du sélecteur

    class MapOption {
        String name;
        String folderName;
        PImage preview;

        MapOption(String name, String folderName)
        {
            this.name = name;
            this.folderName = folderName;
            String previewPath = "assets/sprites/background/" + folderName + "/" + folderName + ".png";

            preview = loadImage(previewPath);
            preview.resize((int)MAP_PREVIEW_SIZE, (int)MAP_PREVIEW_SIZE);
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

        backgroundImage = loadImage("assets/sprites/background/menus/background_modeselect.png");
        backgroundImage.resize(width, height);
    }

    void activate(int gameMode)
    {
        this.active = true;
        this.gameMode = gameMode;
        this.selectedOption = 0;
    }

    void draw()
    {
        image(backgroundImage, 0, 0, width, height);
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
        float startX = width/2 - ((mapOptions.size()-1) * optionSpacing/2);

        for (int i = 0; i < mapOptions.size(); i++) {
            float x = startX + (i * optionSpacing);
            float previewSize = (i == selectedOption) ? MAP_HOVER_SIZE : MAP_PREVIEW_SIZE;
            if (mouseX > x - previewSize/2 && mouseX < x + previewSize/2 &&
                mouseY > OPTIONS_Y - previewSize/2 && mouseY < OPTIONS_Y + previewSize/2) {
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
    private void drawMapOptions()
    {
        float startX = width/2 - ((mapOptions.size()-1) * optionSpacing/2);

        for (int i = 0; i < mapOptions.size(); i++) {
            float x = startX + (i * optionSpacing);
            boolean isSelected = (i == selectedOption);

            if (isSelected) {
                drawSelectedMapPreview(x, OPTIONS_Y, mapOptions.get(i));
            } else {
                drawNormalMapPreview(x, OPTIONS_Y, mapOptions.get(i));
            }
            fill(255);
            textSize(32);
            textAlign(CENTER, CENTER);
            text(mapOptions.get(i).name, x, OPTIONS_Y + (isSelected ? MAP_HOVER_SIZE/2 + 40 : MAP_PREVIEW_SIZE/2 + 40));
        }
    }

    private void drawNormalMapPreview(float x, float y, MapOption mapOption)
    {
        imageMode(CENTER);
        noFill();
        stroke(255);
        strokeWeight(2);
        rect(x - MAP_PREVIEW_SIZE/2, y - MAP_PREVIEW_SIZE/2, MAP_PREVIEW_SIZE, MAP_PREVIEW_SIZE);
        image(mapOption.preview, x, y, MAP_PREVIEW_SIZE, MAP_PREVIEW_SIZE);
        imageMode(CORNER);
    }

    private void drawSelectedMapPreview(float x, float y, MapOption mapOption)
    {
        float shakeX = random(-SHAKE_AMOUNT, SHAKE_AMOUNT);
        float shakeY = random(-SHAKE_AMOUNT, SHAKE_AMOUNT);

        imageMode(CENTER);
        noFill();
        stroke(255);
        strokeWeight(4);
        rect(x + shakeX - MAP_HOVER_SIZE/2, y + shakeY - MAP_HOVER_SIZE/2, MAP_HOVER_SIZE, MAP_HOVER_SIZE);
        image(mapOption.preview, x + shakeX, y + shakeY, MAP_HOVER_SIZE, MAP_HOVER_SIZE);
        imageMode(CORNER);
    }

    private void selectCurrentMap()
    {
        MapOption selectedMap = mapOptions.get(selectedOption);
        game.startGame(selectedMap.folderName);
        active = false;
    }
}