class Weapon
{
    PImage sprite;
    PImage bulletSprite;
    float x, y;
    boolean isPickedUp = false;
    Player owner = null;
    float bulletSpeed;
    float cooldown;
    
    Weapon(float x, float y, PImage weaponSprite, PImage bulletSprite, float bulletSpeed, float cooldown)
    {
        this.x = x;
        this.y = y;
        this.sprite = weaponSprite;
        this.bulletSprite = bulletSprite;
        this.bulletSpeed = bulletSpeed;
        this.cooldown = cooldown;
    }
    
    void draw()
    {
        if (!isPickedUp) {
            image(sprite, x, y);
        }
    }
    
    boolean canPickup(Player player)
    {
        float pickupRadius = 100;
        return !isPickedUp && 
               abs(player.pos.x - x) < pickupRadius && 
               abs(player.pos.y - y) < pickupRadius;
    }
    
    void pickup(Player player)
    {
        if (canPickup(player)) {
            isPickedUp = true;
            owner = player;
            player.equip(this);
        }
    }

    void shoot()
    {
        if (owner != null && owner.bullet.canShoot()){
            owner.bullet.setBulletSprite(this.bulletSprite);
            owner.bullet.speed = this.bulletSpeed;
            owner.bullet.cooldownDuration = (int)this.cooldown;
            owner.shoot();
        }
    }
}