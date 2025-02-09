class Bow extends Weapon {
    Bow(float x, float y, PImage sprite, PImage bulletSprite) {
        // Arc : lent mais puissant
        super(x, y, sprite, bulletSprite, 15, 800, 8, 4.0f);
        // Arc : tir lent, peu de munitions, gros dégâts
        // Style : arme de précision
    }
}