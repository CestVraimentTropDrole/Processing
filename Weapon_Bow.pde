class Bow extends Weapon {
    Bow(float x, float y, PImage sprite, PImage bulletSprite) {
        // x, y, sprite, bulletSprite, bulletSpeed, BulletSpeed, Cooldown beetween shot, maxAmmo, minDamage, maxDamage, reloadTime
        super(x, y, sprite, bulletSprite, 20, 3000, 8, 6.0f, 10.0f, 1500);
        // Arc : tir lent, peu de munitions, gros dégâts
    }
}