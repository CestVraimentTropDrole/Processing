/**
* BulletProperties - Configuration des propriétés d'un projectile
**/
class BulletProperties {
    // Constantes par défaut
    static final float DEFAULT_SPEED = 15.0f;        // Vitesse par défaut des projectiles
    static final float DEFAULT_DAMAGE = 1.0f;        // Dégâts par défaut des projectiles
    static final int DEFAULT_COOLDOWN = 500;         // Temps de recharge par défaut entre les tirs (ms)
    static final int DEFAULT_AMMO = 10;              // Nombre de munitions par défaut
    static final int DEFAULT_RELOAD_TIME = 2000;     // Temps de rechargement par défaut (ms)

    /**
    * Variables d'état du projectile
    * @private Accessibles uniquement dans cette classe
    **/
    private final float speed;      // Vitesse de déplacement du projectile
    private final float damage;     // Quantité de dégâts infligés à l'impact
    private final PImage sprite;    // Image représentant le projectile

    /**
    * Constructeur des propriétés
    * @param speed Vitesse du projectile
    * @param damage Dégâts du projectile
    * @param sprite Apparence du projectile
    **/
    BulletProperties(float speed, float damage, PImage sprite)
    {
        this.speed = speed;
        this.damage = damage;
        this.sprite = sprite;
    }

    // Getters
    float getSpeed() { return speed; }
    float getDamage() { return damage; }
    PImage getSprite() { return sprite; }
}