/**
* Gun - Arme de type mitraillette avec tir rapide
*
* Constantes de configuration de l'arme
**/
class Gun extends Weapon {
    static final float BULLET_SPEED = 20;     // Vitesse des projectiles
    static final float FIRE_RATE = 300;       // Délai entre les tirs
    static final int AMMO_CAPACITY = 6;       // Capacité en munitions
    static final float MIN_DAMAGE = 4.0f;     // Dégâts minimum
    static final float MAX_DAMAGE = 6.0f;     // Dégâts maximum
    static final int RELOAD_TIME = 1500;      // Temps de rechargement

    /**
    * Constructeur de la mitraillette
    * @param x Position X initiale de l'arme
    * @param y Position Y initiale de l'arme
    * @param sprite Sprite de l'arme
    * @param bulletSprite Sprite des projectiles
    * @param bulletSpeed Vitesse des projectiles
    * @param fireRate Délai entre les tirs
    * @param maxAmmo Capacité en munitions
    * @param minDamage Dégâts minimum
    * @param maxDamage Dégâts maximum
    * @param reloadTime Temps de rechargement
    **/
    Gun(float x, float y, PImage sprite, PImage bulletSprite)
    {
        super(x, y, sprite, bulletSprite, BULLET_SPEED, FIRE_RATE, AMMO_CAPACITY, MIN_DAMAGE, MAX_DAMAGE, RELOAD_TIME);
    }
}