class Gun extends Weapon {
    Gun(float x, float y, PImage sprite, PImage bulletSprite) {
        // AK47 : rapide mais moins précis
        super(x, y, sprite, bulletSprite, 25, 150, 30, 1.5f);
        // Mitraillette : tir rapide, beaucoup de munitions, dégâts moyens
        // Style : arme d'assaut, agressif
    }
}