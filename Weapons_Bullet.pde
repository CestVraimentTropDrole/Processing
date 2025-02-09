class Bullet {
    PVector pos;
    PImage currentBulletSprite; // Renamed from bulletSprite
    PImage defaultBulletSprite; // Store the default sprite
    float speed = 15;
    ArrayList<PVector> bullets;
    ArrayList<Integer> directions;
    ArrayList<PImage> bulletSprites; // New: Store sprite for each bullet
    long lastShotTime = 0;
    int cooldownDuration = 500;
    int currentAmmo = 10;
    int maxAmmo = 10;
    boolean isReloading = false;
    long reloadStartTime = 0;
    int reloadDuration = 2000;
    float damage = 1.0;

    Bullet(PImage bulletSprite)
    {
        this.defaultBulletSprite = bulletSprite;
        this.currentBulletSprite = bulletSprite;
        bullets = new ArrayList<PVector>();
        directions = new ArrayList<Integer>();
        bulletSprites = new ArrayList<PImage>(); // Initialize the sprite list
        currentAmmo = maxAmmo;
    }

    void setBulletSprite(PImage newSprite)
    {
        this.currentBulletSprite = newSprite;
    }

    void resetBulletSprite()
    {
        this.currentBulletSprite = this.defaultBulletSprite;
    }

    void setBulletDamage(float newDamage)
    {
        this.damage = newDamage;
    }

    boolean canShoot()
    {
        return millis() - lastShotTime >= cooldownDuration && currentAmmo > 0 && !isReloading;
    }

    void startReload()
    {
        if (!isReloading && currentAmmo < maxAmmo) {
            isReloading = true;
            reloadStartTime = millis();
        }
    }

    void updateReload()
    {
        if (isReloading && millis() - reloadStartTime >= reloadDuration) {
            currentAmmo = maxAmmo;
            isReloading = false;
        }
    }

    void fire(float x, float y, int direction)
    {
        if (canShoot()) {
            bullets.add(new PVector(x, y));
            directions.add(direction);
            bulletSprites.add(currentBulletSprite); // Store the current sprite for this bullet
            lastShotTime = millis();
            currentAmmo--;
        }
    }

    void update()
    {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            PVector bullet = bullets.get(i);
            bullet.x += speed * directions.get(i);
            if (bullet.x < -50 || bullet.x > width + 50) {
                bullets.remove(i);
                directions.remove(i);
                bulletSprites.remove(i);
            }
        }
    }

    int checkHit(Player target)
    {
        for (int i = 0; i < bullets.size(); i++) {
            PVector bullet = bullets.get(i);
            if (bullet.x > target.pos.x && bullet.x < target.pos.x + target.sprite.width && 
                bullet.y > target.pos.y && bullet.y < target.pos.y + target.sprite.height) {
                return i;  // Retourne l'index de la balle qui touche
            }
        }
        return -1;  // Aucune balle n'a touché
    }

    void removeBullet(int index)
    {
        if (index >= 0 && index < bullets.size()) {
            bullets.remove(index);
            directions.remove(index);
            bulletSprites.remove(index);
        }
    }

    void draw()
    {
        for (int i = 0; i < bullets.size(); i++) {
            PVector bullet = bullets.get(i);
            PImage sprite = bulletSprites.get(i);
            image(sprite, bullet.x, bullet.y);
        }
    }

    boolean isActive()
    {
        return !bullets.isEmpty();
    }

    void reset()
    {
        bullets.clear();
        directions.clear();
        bulletSprites.clear();
        resetBulletSprite();
    }
}