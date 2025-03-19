/**
* AssetManager - Gestion des ressources graphiques du jeu
*
* Constantes de configuration des assets
**/
class AssetManager {
    static final int BULLET_SIZE = 20;                      // Taille des projectiles
    static final int NUMBER_COUNT = 10;                     // Nombre de chiffres à charger
    static final int SPECIAL_CHARS = 2;                     // Nombre de caractères spéciaux (%, ,)
    static final String ASSETS_PATH = "assets/sprites/";    // Chemin de base des assets
    static final String MUSICS_PATH = "assets/musics/weapons/";     // Chemin de base des soundeffects

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private PImage playerSprite1, playerSprite2;    // Sprites des joueurs
    private PImage p1Life, p2Life;                  // Icônes de vie des joueurs
    private PImage bulletSimple, bulletLaser;       // Projectiles simples et laser
    private PImage bulletArrow, bulletLong;         // Projectiles flèches et longs
    private PImage gunSprite, pistolSprite;         // Sprites des armes à feu
    private PImage blasterSprite, bowSprite;        // Sprites des armes spéciales
    private PImage[] numbers;                       // Chiffres pour l'affichage des dégâts
    private String soundPistol, soundGun, soundBow, soundLaser; // Noms de fichiers des soundeffects

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'AssetManager
    * Charge et initialise toutes les ressources graphiques
    **/
    AssetManager()
    {
        loadPlayerAssets();
        loadWeaponAssets();
        loadBulletAssets();
        loadSoundEffects();
        loadUIAssets();
        resizeAssets();
    }

    // Getters pour les assets des joueurs
    PImage getPlayerSprite1() { return playerSprite1; }
    PImage getPlayerSprite2() { return playerSprite2; }
    PImage getP1Life() { return p1Life; }
    PImage getP2Life() { return p2Life; }

    // Getters pour les assets des projectiles
    PImage getBulletSimple() { return bulletSimple; }
    PImage getBulletLaser() { return bulletLaser; }
    PImage getBulletArrow() { return bulletArrow; }
    PImage getBulletLong() { return bulletLong; }

    // Getters pour les assets des armes
    PImage getGunSprite() { return gunSprite; }
    PImage getPistolSprite() { return pistolSprite; }
    PImage getBlasterSprite() { return blasterSprite; }
    PImage getBowSprite() { return bowSprite; }

    // Getters pour les sound effects
    String getPistolSound() { return soundPistol; }
    String getGunSound() { return soundGun; }
    String getBowSound() { return soundBow; }
    String getLaserSound() { return soundLaser; }

    // Getter pour les assets UI
    PImage[] getNumbers() { return numbers; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void loadPlayerAssets()
    {
        playerSprite1 = loadImage(ASSETS_PATH + "red/player_idle.png");
        playerSprite2 = loadImage(ASSETS_PATH + "yellow/player_idle.png");
        p1Life = loadImage(ASSETS_PATH + "red/life.png");
        p2Life = loadImage(ASSETS_PATH + "yellow/life.png");
    }

    private void loadWeaponAssets()
    {
        gunSprite = loadImage(ASSETS_PATH + "gun/ak47.png");
        pistolSprite = loadImage(ASSETS_PATH + "gun/gunsimple.png");
        blasterSprite = loadImage(ASSETS_PATH + "gun/blaster.png");
        bowSprite = loadImage(ASSETS_PATH + "gun/bow.png");
    }

    private void loadBulletAssets()
    {
        bulletSimple = loadImage(ASSETS_PATH + "bullet/simple.png");
        bulletLaser = loadImage(ASSETS_PATH + "bullet/laser.png");
        bulletArrow = loadImage(ASSETS_PATH + "bullet/arrow.png");
        bulletLong = loadImage(ASSETS_PATH + "bullet/long.png");
    }

    private void loadSoundEffects()
    {
        soundPistol = MUSICS_PATH + "gunsimple.mp3";
        soundGun = MUSICS_PATH + "ak47.mp3";
        soundBow = MUSICS_PATH + "bow.mp3";
        soundLaser = MUSICS_PATH + "blaster.mp3";
    }

    private void loadUIAssets()
    {
        numbers = new PImage[NUMBER_COUNT + SPECIAL_CHARS];
        for (int i = 0; i < NUMBER_COUNT; i++) {
            numbers[i] = loadImage(ASSETS_PATH + "damage/" + i + ".png");
        }
        numbers[10] = loadImage(ASSETS_PATH + "damage/percent.png"); // %
        numbers[11] = loadImage(ASSETS_PATH + "damage/comma.png");   // ,
    }

    private void resizeAssets()
    {
        bulletSimple.resize(BULLET_SIZE, BULLET_SIZE);
        bulletLaser.resize(BULLET_SIZE, BULLET_SIZE);
        bulletArrow.resize(BULLET_SIZE, BULLET_SIZE);
        bulletLong.resize(BULLET_SIZE, BULLET_SIZE);
    }
}