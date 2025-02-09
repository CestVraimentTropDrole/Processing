class Blaster extends Weapon {
    Blaster(float x, float y, PImage sprite, PImage bulletSprite) {
        // x, y, sprite, bulletSprite, bulletSpeed, BulletSpeed, Cooldown beetween shot, maxAmmo, minDamage, maxDamage, reloadTime
        super(x, y, sprite, bulletSprite, 30, 200, 24, 1.0f, 3.0f 1500);
        // Blaster : vitesse haute, munitions hautes, dégâts bas
    }
}