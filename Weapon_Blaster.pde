class Blaster extends Weapon {
    Blaster(float x, float y, PImage sprite, PImage bulletSprite) {
        // Blaster : équilibré avec un twist futuriste
        super(x, y, sprite, bulletSprite, 18, 300, 15, 2.5f);
        // Blaster : vitesse moyenne-haute, munitions moyennes, dégâts moyens-hauts
        // Style : arme futuriste, polyvalent avec un avantage sur les dégâts
    }
}