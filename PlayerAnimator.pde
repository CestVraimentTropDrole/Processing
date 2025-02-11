/**
* PlayerAnimator - Gestion des animations et sprites du joueur
*
* Constantes de configuration de l'animation
**/
class PlayerAnimator {
    static final float CROUCH_HEIGHT_RATIO = 0.6f;  // Ratio de la hauteur en position accroupie

    /**
    * Variables d'état de l'animation
    * @private Accessibles uniquement dans cette classe
    **/
    private PImage sprite;                    // Sprite actuel
    private final PImage originalSprite;      // Sprite original non modifié
    private final float normalHeight;         // Hauteur normale
    private final float crouchHeight;         // Hauteur accroupie
    private ArrayList<Platform> platforms;    // Référence aux plateformes pour les collisions

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du PlayerAnimator
    * @param initialSprite Sprite initial du joueur
    * @param platformList Liste des plateformes pour la gestion des collisions
    **/
    PlayerAnimator(PImage initialSprite, ArrayList<Platform> platformList)
    {
        this.originalSprite = initialSprite.copy();
        this.sprite = initialSprite.copy();
        this.normalHeight = sprite.height;
        this.crouchHeight = normalHeight * CROUCH_HEIGHT_RATIO;
        this.platforms = platformList;
    }

    void draw(PVector pos, int facing)
    {
        pushMatrix();
        if (facing < 0) {
            translate(pos.x + sprite.width, pos.y);
            scale(-1, 1);
            image(sprite, 0, 0);
        } else {
            image(sprite, pos.x, pos.y);
        }
        popMatrix();
    }

    boolean crouch(PVector pos, boolean crouching)
    {
        if (crouching) {
            return applyCrouch(pos);
        } else {
            return attemptStand(pos);
        }
    }

    void reset()
    {
        sprite = originalSprite.copy();
    }

    // Getters
    float getNormalHeight() { return normalHeight; }
    float getCrouchHeight() { return crouchHeight; }
    float getCurrentHeight() { return sprite.height; }
    float getWidth() { return sprite.width; }
    PImage getSprite() { return sprite; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private boolean applyCrouch(PVector pos)
    {
        float oldHeight = sprite.height;

        sprite = originalSprite.copy();
        sprite.resize(sprite.width, int(crouchHeight));

        if (oldHeight != crouchHeight) {
            pos.y += (normalHeight - crouchHeight);
        }
        return true;
    }

    private boolean attemptStand(PVector pos)
    {
        float newY = pos.y - (normalHeight - crouchHeight);

        if (canStandAt(pos.x, newY)) {
            sprite = originalSprite.copy();
            pos.y = newY;
            return true;
        }
        return false;
    }

    private boolean canStandAt(float x, float newY)
    {
        for (Platform p : platforms) {
            if (checkPlatformCollision(p, x, newY)) {
                return false;
            }
        }
        return true;
    }

    private boolean checkPlatformCollision(Platform p, float x, float newY)
    {
        return newY < p.y + p.h && newY + normalHeight > p.y && x + sprite.width > p.x && x < p.x + p.w;
    }
}