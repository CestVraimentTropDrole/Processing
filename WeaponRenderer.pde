/**
* WeaponRenderer - Gestion du rendu graphique des armes
*
* Constantes de configuration du rendu
**/
class WeaponRenderer {
    static final float LEFT_OFFSET = 0.10f;     // Décalage gauche
    static final float RIGHT_OFFSET = 0.90f;    // Décalage droit
    static final float HEIGHT_OFFSET = 0.56f;   // Décalage vertical
    static final float RELOAD_ANGLE = 45;       // Angle en rechargement
    static final int RELOAD_TINT = 128;         // Teinte en rechargement

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private final PImage sprite;                // Sprite de l'arme
    private float alpha;                        // Transparence actuelle
    private boolean isFading;                   // État de disparition

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du WeaponRenderer
    * @param sprite Sprite de l'arme à afficher
    * @param alpha Niveau de transparence initial
    * @param isFading État initial de la disparition progressive
    **/
    WeaponRenderer(PImage sprite)
    {
        this.sprite = sprite;
        this.alpha = WeaponProperties.DEFAULT_ALPHA;
        this.isFading = false;
    }

    void fadeOut()
    {
        isFading = true;
        alpha -= WeaponProperties.FADE_RATE;
        alpha = max(0, alpha);
    }

    void draw(float x, float y, Player owner, boolean isPickedUp)
    {
        if (!isPickedUp) {
            drawGroundWeapon(x, y);
            return;
        }
        if (owner != null) {
            drawEquippedWeapon(owner);
        }
    }

    float getAlpha()
    {
        return alpha;
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void drawGroundWeapon(float x, float y)
    {
        if (isFading) {
            tint(255, alpha);
        }
        image(sprite, x, y);
        noTint();
    }

    private void drawEquippedWeapon(Player owner)
    {
        pushMatrix();
        if (owner.combat.bullet.isReloading) {
            drawReloadingWeapon(owner);
        } else {
            drawNormalWeapon(owner);
        }
        popMatrix();
    }

    private void drawReloadingWeapon(Player owner)
    {
        float baseX = owner.pos.x + owner.animator.getWidth() * (owner.movement.getFacing() < 0 ? LEFT_OFFSET : RIGHT_OFFSET);
        float baseY = owner.pos.y + owner.animator.getCurrentHeight() * HEIGHT_OFFSET;

        translate(baseX, baseY);
        if (owner.movement.getFacing() < 0) {
            scale(-1, 1);
        }
        rotate(radians(RELOAD_ANGLE));
        tint(RELOAD_TINT);
        translate(-sprite.width/2, -sprite.height/2);
        image(sprite, 0, 0);
        noTint();
    }

    private void drawNormalWeapon(Player owner)
    {
        float baseX = owner.pos.x + owner.animator.getWidth() * (owner.movement.getFacing() < 0 ? LEFT_OFFSET : RIGHT_OFFSET);
        float baseY = owner.pos.y + owner.animator.getCurrentHeight() * HEIGHT_OFFSET;

        translate(baseX, baseY);
        if (owner.movement.getFacing() < 0) {
            scale(-1, 1);
            image(sprite, -sprite.width/2, -sprite.height/2);
        } else {
            image(sprite, -sprite.width/2, -sprite.height/2);
        }
    }
}