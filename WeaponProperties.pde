/**
* WeaponProperties - Configuration des propriétés d'une arme
*
* Constantes de configuration des armes
**/
class WeaponProperties {
    static final float DEFAULT_ALPHA = 255;    // Transparence par défaut
    static final float FADE_RATE = 5;          // Vitesse de disparition
    static final float PICKUP_RADIUS = 100;    // Rayon de ramassage

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private final float bulletSpeed;           // Vitesse des projectiles
    private final float cooldown;              // Délai entre les tirs
    private final int maxAmmo;                 // Capacité maximale en munitions
    private final float minDamage;             // Dégâts minimum
    private final float maxDamage;             // Dégâts maximum
    private final int reloadTime;              // Temps de rechargement

    /**
    * Constructeur des propriétés
    * @param bulletSpeed Vitesse des projectiles
    * @param cooldown Délai entre les tirs
    * @param maxAmmo Capacité en munitions
    * @param minDamage Dégâts minimum
    * @param maxDamage Dégâts maximum
    * @param reloadTime Temps de rechargement
    **/
    WeaponProperties(float bulletSpeed, float cooldown, int maxAmmo, float minDamage, float maxDamage, int reloadTime)
    {
        this.bulletSpeed = bulletSpeed;
        this.cooldown = cooldown;
        this.maxAmmo = maxAmmo;
        this.minDamage = minDamage;
        this.maxDamage = maxDamage;
        this.reloadTime = reloadTime;
    }

    // Getters
    float getBulletSpeed() { return bulletSpeed; }
    float getCooldown() { return cooldown; }
    int getMaxAmmo() { return maxAmmo; }
    float getMinDamage() { return minDamage; }
    float getMaxDamage() { return maxDamage; }
    int getReloadTime() { return reloadTime; }
}