/**
* Blaster - Arme de type laser avec tir rapide
*
* Constantes de configuration de l'arme
**/
class Blaster extends Weapon {
    static final float BULLET_SPEED = 30;     // Vitesse des projectiles
    static final float FIRE_RATE = 200;       // Délai entre les tirs
    static final int AMMO_CAPACITY = 24;      // Capacité en munitions
    static final float MIN_DAMAGE = 1.0f;     // Dégâts minimum
    static final float MAX_DAMAGE = 3.0f;     // Dégâts maximum
    static final int RELOAD_TIME = 1500;      // Temps de rechargement

    /**
    * Constructeur du blaster
    * @param x Position X initiale de l'arme
    * @param y Position Y initiale de l'arme
    * @param sprite Sprite de l'arme
    * @param bulletSprite Sprite des projectiles
    **/
    Blaster(float x, float y, PImage sprite, PImage bulletSprite)
    {
        super(x, y, sprite, bulletSprite, BULLET_SPEED, FIRE_RATE, AMMO_CAPACITY, MIN_DAMAGE, MAX_DAMAGE, RELOAD_TIME);
    }
}