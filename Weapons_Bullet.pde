class Bullet {
    PVector pos;
    PImage currentBulletSprite;
    PImage defaultBulletSprite;
    float currentSpeed = 15;
    float currentDamage;
    int currentCooldown;
    ArrayList<PVector> bullets;
    ArrayList<Integer> directions;
    ArrayList<BulletProperties> bulletProps;
    long lastShotTime = 0;
    int cooldownDuration = 500;
    int currentAmmo = 10;
    int maxAmmo = 10;
    boolean isReloading = false;
    long reloadStartTime = 0;
    int reloadDuration = 2000;
    float damage = 1.0;

    class BulletProperties {
        float speed;
        float damage;
        PImage sprite;

        BulletProperties(float speed, float damage, float cooldown, PImage sprite) {
            this.speed = speed;
            this.damage = damage;
            this.sprite = sprite;
        }
    }

    Bullet(PImage bulletSprite)
    {
        this.defaultBulletSprite = bulletSprite;
        this.currentBulletSprite = bulletSprite;
        this.currentSpeed = 15;
        bullets = new ArrayList<PVector>();
        directions = new ArrayList<Integer>();
        bulletProps = new ArrayList<BulletProperties>();
        currentAmmo = maxAmmo;
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

    void setBulletProperties(PImage sprite, float speed, float damage, int cooldown)
    {
        this.currentBulletSprite = sprite;
        this.currentSpeed = speed;
        this.currentDamage = damage;
        this.currentCooldown = cooldown;
    }

    void resetProperties()
    {
        this.currentBulletSprite = this.defaultBulletSprite;
        this.currentSpeed = 15;
        this.currentDamage = 1.0f;
        this.currentCooldown = 500;
        this.currentAmmo = this.maxAmmo;
        this.isReloading = false;
        this.reloadDuration = 2000;
    }

    boolean canShoot()
    {
        return millis() - lastShotTime >= currentCooldown && currentAmmo > 0 && !isReloading;
    }

    void fire(float x, float y, int direction)
    {
        if (canShoot()) {
            bullets.add(new PVector(x, y));
            directions.add(direction);
            bulletProps.add(new BulletProperties(
                currentSpeed,
                currentDamage,
                currentCooldown,
                currentBulletSprite
            ));
            lastShotTime = millis();
            currentAmmo--;
        }
    }

    float getDamageForBullet(int index)
    {
        if (index >= 0 && index < bulletProps.size()) {
            return bulletProps.get(index).damage;
        }
        return currentDamage;
    }

    void update()
    {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            PVector bullet = bullets.get(i);
            BulletProperties props = bulletProps.get(i);
            bullet.x += props.speed * directions.get(i);
            if (bullet.x < -50 || bullet.x > width + 50) {
                bullets.remove(i);
                directions.remove(i);
                bulletProps.remove(i);
            }
        }
    }

    int checkHit(Player target)
    {
        for (int i = 0; i < bullets.size(); i++) {
            PVector bullet = bullets.get(i);
            if (bullet.x > target.pos.x && bullet.x < target.pos.x + target.sprite.width && bullet.y > target.pos.y && bullet.y < target.pos.y + target.sprite.height) {
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
            bulletProps.remove(index);
        }
    }

    void draw()
    {
        for (int i = 0; i < bullets.size(); i++) {
            PVector bullet = bullets.get(i);
            BulletProperties props = bulletProps.get(i);
            image(props.sprite, bullet.x, bullet.y);
        }
    }

    void reset()
    {
        bullets.clear();
        directions.clear();
        bulletProps.clear();
        resetProperties();
    }
}