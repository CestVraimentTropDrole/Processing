class Weapon {
    PImage sprite;
    PImage bulletSprite;
    float x, y;
    boolean isPickedUp = false;
    Player owner = null;
    float bulletSpeed;
    float cooldown;
    int maxAmmo;
    int currentAmmo;
    float minDamage;
    float maxDamage;
    int reloadTime;
    long spawnTime;
    float alpha = 255;
    boolean isFading = false;

    Weapon(float x, float y, PImage weaponSprite, PImage bulletSprite, float bulletSpeed, float cooldown, int maxAmmo, float minDamage, float maxDamage, int reloadTime)
    {
        this.x = x;
        this.y = y;
        this.sprite = weaponSprite;
        this.bulletSprite = bulletSprite;
        this.bulletSpeed = bulletSpeed;
        this.cooldown = cooldown;
        this.maxAmmo = maxAmmo;
        this.currentAmmo = maxAmmo;
        this.minDamage = minDamage;
        this.maxDamage = maxDamage;
        this.reloadTime = reloadTime;
    }

    void fadeOut()
    {
        isFading = true;
        alpha -= 5;
        alpha = max(0, alpha);
    }

    void draw()
    {
        if (!isPickedUp) {
            if (isFading) {
                tint(255, alpha);
            }
            image(sprite, x, y);
            noTint();
            return;
        }

        if (owner != null) {
            pushMatrix();
            if (owner.bullet.isReloading) {
                float baseX = owner.pos.x + owner.sprite.width * (owner.facing < 0 ? 0.10f : 0.90f);
                float baseY = owner.pos.y + owner.sprite.height * 0.56f;

                translate(baseX, baseY);
                if (owner.facing < 0) {
                    scale(-1, 1); // Ajout du scale pour le côté gauche
                }
                rotate(radians(45));
                tint(128);
                translate(-sprite.width/2, -sprite.height/2);
                image(sprite, 0, 0);
                noTint();
            } else {
                // Position normale - inchangée
                if (owner.facing < 0) {
                    // Face à gauche
                    float baseX = owner.pos.x + owner.sprite.width * 0.10f;
                    float baseY = owner.pos.y + owner.sprite.height * 0.56f;
                    translate(baseX, baseY);
                    scale(-1, 1);
                    image(sprite, -sprite.width/2, -sprite.height/2);
                } else {
                    // Face à droite
                    float baseX = owner.pos.x + owner.sprite.width * 0.90f;
                    float baseY = owner.pos.y + owner.sprite.height * 0.56f;
                    translate(baseX, baseY);
                    image(sprite, -sprite.width/2, -sprite.height/2);
                }
            }
            popMatrix();
        }
    }

    boolean canPickup(Player player)
    {
        float pickupRadius = 100;
        return !isPickedUp && abs(player.pos.x - x) < pickupRadius && abs(player.pos.y - y) < pickupRadius;
    }

    float getRandomDamage()
    {
        return random(minDamage, maxDamage);
    }

    void pickup(Player player)
    {
        if (canPickup(player)) {
            isPickedUp = true;
            owner = player;
            player.equip(this);
            owner.bullet.setBulletProperties(
                this.bulletSprite,
                this.bulletSpeed,
                this.getRandomDamage(),
                (int)this.cooldown
            );
            owner.bullet.maxAmmo = this.maxAmmo;
            owner.bullet.currentAmmo = this.maxAmmo;
            owner.bullet.reloadDuration = this.reloadTime;
        }
    }

    void shoot()
    {
        if (owner != null && owner.bullet.canShoot() && currentAmmo > 0) {
            owner.bullet.setBulletProperties(
                this.bulletSprite,
                this.bulletSpeed,
                this.getRandomDamage(),
                (int)this.cooldown
            );
            owner.shoot();
            currentAmmo--;

            if (currentAmmo <= 0) {
                owner.bullet.resetProperties();
                owner.currentWeapon = null;
                owner = null;
                isPickedUp = false;
            }
        }
    }
}