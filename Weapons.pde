/**
* Weapon - Classe principale de gestion des armes
**/
class Weapon {
    /**
    * Variables d'état de l'arme
    * @private Accessibles uniquement dans cette classe
    **/
    private final WeaponProperties properties;  // Propriétés de l'arme
    private final WeaponRenderer renderer;      // Gestionnaire de rendu
    private final PImage bulletSprite;          // Sprite des projectiles
    private float x, y;                         // Position
    private boolean isPickedUp;                 // État de ramassage
    private Player owner;                       // Propriétaire
    private int currentAmmo;                    // Munitions actuelles
    private long spawnTime;                     // Temps d'apparition

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'arme
    * @param x Position X initiale
    * @param y Position Y initiale
    * @param weaponSprite Sprite de l'arme
    * @param bulletSprite Sprite des projectiles
    * @param bulletSpeed Vitesse des projectiles
    * @param cooldown Délai entre les tirs
    * @param maxAmmo Capacité en munitions
    * @param minDamage Dégâts minimum
    * @param maxDamage Dégâts maximum
    * @param reloadTime Temps de rechargement
    **/
    Weapon(float x, float y, PImage weaponSprite, PImage bulletSprite, float bulletSpeed, float cooldown, int maxAmmo, float minDamage, float maxDamage, int reloadTime)
    {
        this.x = x;
        this.y = y;
        this.bulletSprite = bulletSprite;
        this.properties = new WeaponProperties(bulletSpeed, cooldown, maxAmmo, minDamage, maxDamage, reloadTime);
        this.renderer = new WeaponRenderer(weaponSprite);
        this.currentAmmo = properties.getMaxAmmo();
        this.isPickedUp = false;
        this.owner = null;
    }

    void draw()
    {
        renderer.draw(x, y, owner, isPickedUp);
    }

    void fadeOut()
    {
        renderer.fadeOut();
    }

    boolean canPickup(Player player)
    {
        return !isPickedUp && abs(player.pos.x - x) < WeaponProperties.PICKUP_RADIUS && abs(player.pos.y - y) < WeaponProperties.PICKUP_RADIUS;
    }

    void pickup(Player player)
    {
        if (canPickup(player)) {
            isPickedUp = true;
            owner = player;
            player.equip(this);
            setupBulletProperties();
        }
    }

    void shoot()
    {
        if (canShoot()) {
            owner.bullet.setBulletProperties(bulletSprite, properties.getBulletSpeed(), getRandomDamage(), (int)properties.getCooldown());
            owner.shoot();
            currentAmmo--;

            if (currentAmmo <= 0) {
                dropWeapon();
            }
        }
    }

    // Getters
    WeaponRenderer getRenderer() { return renderer; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private boolean canShoot()
    {
        return owner != null && owner.bullet.canShoot() && currentAmmo > 0;
    }

    private float getRandomDamage()
    {
        return random(properties.getMinDamage(), properties.getMaxDamage());
    }

    private void setupBulletProperties()
    {
        owner.bullet.setBulletProperties(bulletSprite, properties.getBulletSpeed(), getRandomDamage(), (int)properties.getCooldown());
        owner.bullet.maxAmmo = properties.getMaxAmmo();
        owner.bullet.currentAmmo = properties.getMaxAmmo();
        owner.bullet.reloadDuration = properties.getReloadTime();
    }

    private void dropWeapon()
    {
        owner.bullet.resetProperties();
        owner.currentWeapon = null;
        owner = null;
        isPickedUp = false;
    }
}