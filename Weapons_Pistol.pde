class Pistol extends Weapon {
    Pistol(float x, float y, PImage sprite, PImage bulletSprite) {
        // x, y, sprite, bulletSprite, bulletSpeed, cooldown, maxAmmo, damage
        super(x, y, sprite, bulletSprite, 12, 400, 12, 2.0f);
        // Pistolet : vitesse moyenne, cadence moyenne, peu de munitions
        // Style : arme de base, polyvalent
    }
}