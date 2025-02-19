/**
* Bullet - Système de tir principal
*
* Constantes de configuration du système de tir
**/
class Bullet {
    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private final BulletManager manager;        // Gestionnaire des projectiles actifs
    private final PImage defaultSprite;         // Sprite par défaut des projectiles
    private PImage currentSprite;               // Sprite actuellement utilisé pour les nouveaux tirs
    private float currentSpeed;                 // Vitesse actuelle des nouveaux projectiles
    private float currentDamage;                // Dégâts actuels des nouveaux projectiles
    private int currentCooldown;                // Délai actuel entre les tirs
    private int currentAmmo;                    // Nombre de munitions restantes
    private int maxAmmo;                        // Capacité maximale en munitions
    private boolean isReloading;                // Indique si l'arme est en cours de rechargement
    private long lastShotTime;                  // Timestamp du dernier tir effectué
    private long reloadStartTime;               // Timestamp du début du rechargement
    private int reloadDuration;                 // Durée totale d'un rechargement

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du système de tir
    * @param bulletSprite Sprite par défaut des projectiles
    **/
    Bullet(PImage bulletSprite)
    {
        manager = new BulletManager();
        defaultSprite = currentSprite = bulletSprite;
        currentSpeed = BulletProperties.DEFAULT_SPEED;
        currentDamage = BulletProperties.DEFAULT_DAMAGE;
        currentCooldown = BulletProperties.DEFAULT_COOLDOWN;
        maxAmmo = currentAmmo = BulletProperties.DEFAULT_AMMO;
        reloadDuration = BulletProperties.DEFAULT_RELOAD_TIME;
        isReloading = false;
        lastShotTime = 0;
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
        currentSprite = sprite;
        currentSpeed = speed;
        currentDamage = damage;
        currentCooldown = cooldown;
    }

    void resetProperties()
    {
        currentSprite = defaultSprite;
        currentSpeed = BulletProperties.DEFAULT_SPEED;
        currentDamage = BulletProperties.DEFAULT_DAMAGE;
        currentCooldown = BulletProperties.DEFAULT_COOLDOWN;
        currentAmmo = maxAmmo;
        isReloading = false;
        reloadDuration = BulletProperties.DEFAULT_RELOAD_TIME;
    }


    boolean canShoot()
    {
        return millis() - lastShotTime >= currentCooldown && currentAmmo > 0 && !isReloading;
    }

    void fire(float x, float y, int direction)
    {
        if (canShoot()) {
            BulletProperties props = new BulletProperties(currentSpeed, currentDamage, currentSprite);
            manager.addBullet(new PVector(x, y), direction, props);
            lastShotTime = millis();
            currentAmmo--;
        }
    }

    float getDamageForBullet(int index)
    {
        return currentDamage;
    }

    int checkHit(Player target)
    {
        return manager.checkCollision(target);
    }

    void removeBullet(int index)
    {
        manager.removeBullet(index);
    }

    void update()
    {
        manager.update();
    }

    void draw()
    {
        manager.draw();
    }

    void reset()
    {
        manager.clear();
        resetProperties();
    }
}