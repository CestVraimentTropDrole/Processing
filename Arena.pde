/**
* Arena - Gestion de l'environnement de jeu et des collisions
*
* Constantes de configuration de l'arène
**/
class Arena {
    static final float DEATH_OFFSET = 200;           // Distance sous l'écran pour la zone de mort
    static final float DEATH_LINE_OFFSET = 50;       // Décalage de la ligne de mort visuelle
    static final float DEATH_BOUNDARY = 500;         // Limite horizontale de mort
    static final float MAIN_PLATFORM_HEIGHT = 300;   // Hauteur de la plateforme principale
    static final float MAIN_PLATFORM_WIDTH = 0.6f;   // Largeur relative de la plateforme principale
    static final float SIDE_PLATFORM_WIDTH = 0.2f;   // Largeur relative des plateformes secondaires
    static final color DEATH_LINE_COLOR = #FF0000;   // Couleur de la ligne de mort
    static final int DEATH_LINE_ALPHA = 100;         // Transparence de la ligne de mort

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private final float width, height;               // Dimensions de l'arène
    private final float deathY;                      // Position Y de la zone de mort
    private final ArrayList<Platform> platforms;     // Liste des plateformes
    private PImage background;                       // Image de fond
    private SoundManager soundManager;               // Son de l'arène
    private String currentMap;                       // Map actuelle

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'arène
    * @param w Largeur de l'arène
    * @param h Hauteur de l'arène
    * @param minim Gestionnaire audio pour la musique et les sons
    * @param mapName Nom de la map à charger
    **/
    Arena(float w, float h, Minim minim, String mapName)
    {
        this.width = w;
        this.height = h;
        this.deathY = height + DEATH_OFFSET;
        this.platforms = new ArrayList<Platform>();
        this.currentMap = mapName;
        this.soundManager = new SoundManager(minim);

        loadMapAssets(mapName);
        setupPlatforms();
    }

    void draw()
    {
        background(background);
        for (Platform platform : platforms) {
            platform.draw();
        }
        drawDeathLine();
        soundManager.startMusic();
    }

    boolean checkPlayerDeath(Player player)
    {
        return player.pos.y > deathY + DEATH_OFFSET || player.pos.x < -DEATH_BOUNDARY || player.pos.x > width + DEATH_BOUNDARY;
    }

    void handlePlayerCollision(Player player)
    {
        boolean onAnyPlatform = false;
        float spriteHeight = player.animator.getCurrentHeight();

        for (Platform platform : platforms) {
            if (platform.isOnPlatform(player.pos.x, player.pos.y, spriteHeight, player.vel.y)) {
                player.pos.y = platform.y - spriteHeight;
                player.vel.y = 0;
                player.movement.setJumping(false);
                player.movement.resetJumpCount();
                onAnyPlatform = true;
                break;
            }
        }
        if (!onAnyPlatform && !player.movement.isJumping()) {
            player.movement.setJumping(true);
        }
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void loadMapAssets(String mapName)
    {
        String basePath = "assets/sprites/background/" + mapName + "/";
        background = loadImage(basePath + mapName + ".png");
        background.resize((int)width, (int)height);

        String musicPath = "assets/musics/" + mapName + ".mp3";
        soundManager.playMusic(musicPath);
    }

    private void createSidePlatform(float xPosition, float yOffset, float width)
    {
        platforms.add(new Platform(this.width * xPosition - width/2, this.height - yOffset, width, 25, false, currentMap));
    }

    private void setupPlatforms()
    {
        float mainPlatformWidth = width * MAIN_PLATFORM_WIDTH;
        float sidePlatformWidth = width * SIDE_PLATFORM_WIDTH;

        platforms.add(new Platform(width/2 - mainPlatformWidth/2, height - MAIN_PLATFORM_HEIGHT, mainPlatformWidth, 40, true, currentMap));
        createSidePlatform(0.2f, 500, sidePlatformWidth);
        createSidePlatform(0.8f, 500, sidePlatformWidth);
        createSidePlatform(0.5f, 700, sidePlatformWidth);
    }

    private void drawDeathLine()
    {
        noFill();
        stroke(DEATH_LINE_COLOR, DEATH_LINE_ALPHA);
        line(0, deathY - DEATH_LINE_OFFSET, width, deathY - DEATH_LINE_OFFSET);
    }
}