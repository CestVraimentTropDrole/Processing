class Gun extends Weapon {
    Gun(float x, float y, PImage sprite, PImage bulletSprite) {
        // x, y, sprite, bulletSprite, bulletSpeed, BulletSpeed, Cooldown beetween shot, maxAmmo, minDamage, maxDamage, reloadTime
        super(x, y, sprite, bulletSprite, 20, 300, 6, 4.0f, 6.0f, 1500);
        // Mitraillette : tir assez rapide, munitions moyennes, dégâts moyens
    }
}