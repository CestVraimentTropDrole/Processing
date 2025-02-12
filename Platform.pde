/**
* Platform - Gestion des plateformes dans l'arène de jeu
*
* Constantes de configuration des plateformes
**/
class Platform {
    static final color MAIN_PLATFORM_COLOR = #8B4513;    // Couleur plateforme principale
    static final color SIDE_PLATFORM_COLOR = #A0522D;    // Couleur plateformes secondaires
    private final PImage platform;                        //Image de la plateforme

    /**
    * Variables d'état de la plateforme
    * @private Accessibles uniquement dans cette classe
    **/
    private final float x, y;          // Position de la plateforme
    private final float w, h;          // Dimensions de la plateforme
    private final boolean isMain;      // Type de plateforme

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de la plateforme
    * @param x Position X de la plateforme
    * @param y Position Y de la plateforme
    * @param w Largeur de la plateforme
    * @param h Hauteur de la plateforme
    * @param isMain Définit si c'est la plateforme principale
    **/
    Platform(float x, float y, float w, float h, boolean isMain)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.isMain = isMain;

        String type = (isMain ? "main" : "simple");
        platform = loadImage("assets/sprites/background/platform_" +type+ ".png"); // Charge l'image de la plateforme
        platform.resize((int)this.w, (int)this.h); // Redimensionne l'image à la taille de la plateforme
    }

    void draw()
    {
        image(platform,x,y); // Affiche la plateforme
    }

    boolean isOnPlatform(float px, float py, float ph, float vy)
    {
        boolean horizontalCollision = px + 50 > x && px < x + w;
        boolean verticalCollision = py + ph > y && py + ph < y + h && vy >= 0;

        return horizontalCollision && verticalCollision;
    }
}
