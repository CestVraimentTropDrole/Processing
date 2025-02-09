class Pistol extends Weapon {
    Pistol(float x, float y, PImage sprite, PImage bulletSprite) {
        // x, y, sprite, bulletSprite, bulletSpeed, BulletSpeed, Cooldown beetween shot, maxAmmo, minDamage, maxDamage, reloadTime
        super(x, y, sprite, bulletSprite, 12, 400, 12, 4.0f, 6.0f, 1500);
        // Pistolet : vitesse moyenne, cadence moyenne, munitions hautes, dégâts moyens
    }
}