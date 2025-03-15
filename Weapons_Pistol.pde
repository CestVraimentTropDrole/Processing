/**
* Pistol - Arme de type pistolet avec équilibre dégâts/vitesse
*
* Constantes de configuration de l'arme
**/
class Pistol extends Weapon {
    static final float BULLET_SPEED = 12;     // Vitesse des projectiles
    static final float FIRE_RATE = 400;       // Délai entre les tirs
    static final int AMMO_CAPACITY = 12;      // Capacité en munitions
    static final float MIN_DAMAGE = 4.0f;     // Dégâts minimum
    static final float MAX_DAMAGE = 6.0f;     // Dégâts maximum
    static final int RELOAD_TIME = 1500;      // Temps de rechargement


    /**
    * Constructeur du pistolet
    * @param x Position X initiale de l'arme
    * @param y Position Y initiale de l'arme
    * @param sprite Sprite de l'arme
    * @param bulletSprite Sprite des projectiles
    **/
    Pistol(float x, float y, PImage sprite, PImage bulletSprite)
    {
        super(x, y, sprite, bulletSprite, BULLET_SPEED, FIRE_RATE, AMMO_CAPACITY, MIN_DAMAGE, MAX_DAMAGE, RELOAD_TIME);
    }
}