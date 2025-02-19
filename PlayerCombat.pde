/**
* PlayerCombat - Gestion du combat du joueur
*
* Constantes de configuration du combat
**/
class PlayerCombat {
    static final float KNOCKBACK_MULTIPLIER = 0.1;      // Multiplicateur de recul
    static final int NORMAL_KNOCKBACK_DURATION = 15;    // Durée du recul normal
    static final int DEATH_KNOCKBACK_DURATION = 30;     // Durée du recul mortel
    static final float BASE_HORIZONTAL_KNOCKBACK = 5;   // Force de recul horizontale de base
    static final float BASE_VERTICAL_KNOCKBACK = 1;     // Force de recul verticale de base
    static final float DEATH_DAMAGE_THRESHOLD = 100;    // Seuil de dégâts pour la mort
    static final float SHIELD_BREAK_MULTIPLIER = 1.5f;  // Multiplicateur de dégâts sur shield break

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private final Shield shield;               // Bouclier du joueur
    private final Bullet bullet;               // Gestionnaire des projectiles
    private Weapon currentWeapon;              // Arme équipée
    private float damagePercent;               // Pourcentage de dégâts
    private boolean isDeathKnockback;          // État de recul mortel
    private int knockbackTimer;                // Durée restante du recul

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du PlayerCombat
    * @param bulletSprite Sprite des projectiles
    * @param player Référence au joueur pour le bouclier
    **/
    PlayerCombat(PImage bulletSprite, Player player)
    {
        this.shield = new Shield(player);
        this.bullet = new Bullet(bulletSprite);
        reset();
    }

    void update(PVector vel, PlayerMovement movement)
    {
        if (movement.isInKnockback()) {
            knockbackTimer--;
            if (!isDeathKnockback && knockbackTimer <= 0) {
                movement.setInKnockback(false);
                vel.x = 0;
                if (vel.y < 0) {
                    vel.y = 0;
                }
            }
        }
        shield.update();
        bullet.update();
        bullet.updateReload();
    }

    void draw(PVector pos, PImage currentSprite)
    {
        if (currentWeapon != null) {
            currentWeapon.draw();
        }
        float shieldX = pos.x + currentSprite.width/2;
        float shieldY = pos.y + currentSprite.height/2;
        shield.draw(shieldX, shieldY);
        bullet.draw();
    }

    void takeDamage(float damage, float knockback, int direction, PVector vel, PlayerMovement movement)
    {
        if (!shield.isActive) {
            applyDamage(damage, knockback, direction, vel, movement);
        } else {
            handleShieldDamage(damage, knockback, direction, vel, movement);
        }
    }

    void shoot(PVector pos, float spriteWidth, float spriteHeight, int facing)
    {
        if (currentWeapon != null) {
            bullet.fire(pos.x + spriteWidth/2, pos.y + spriteHeight/2, facing);
        }
    }

    void equip(Weapon weapon)
    {
        currentWeapon = weapon;
    }

    void activateShield()
    {
        shield.activate();
    }

    void deactivateShield()
    {
        shield.deactivate();
    }

    void reset()
    {
        damagePercent = 0;
        isDeathKnockback = false;
        knockbackTimer = 0;
        currentWeapon = null;
        shield.currentSize = shield.MAX_SIZE;
        shield.deactivate();
        bullet.reset();
    }

    // Getters
    float getDamagePercent() { return damagePercent; }
    boolean isInDeathKnockback() { return isDeathKnockback; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void applyDamage(float damage, float knockback, int direction, PVector vel, PlayerMovement movement)
    {
        damagePercent += damage;
        if (damagePercent >= DEATH_DAMAGE_THRESHOLD) {
            applyDeathKnockback(direction, vel, movement);
        } else {
            applyNormalKnockback(direction, vel, movement);
        }
    }

    private void applyDeathKnockback(int direction, PVector vel, PlayerMovement movement)
    {
        vel.x = BASE_HORIZONTAL_KNOCKBACK * 3.2 * direction;
        vel.y = -BASE_VERTICAL_KNOCKBACK * 4;
        knockbackTimer = DEATH_KNOCKBACK_DURATION;
        isDeathKnockback = true;
        movement.setInKnockback(true);
        movement.setJumping(true);
    }

    private void applyNormalKnockback(int direction, PVector vel, PlayerMovement movement)
    {
        float multiplier = 1 + (damagePercent * KNOCKBACK_MULTIPLIER);
        vel.x = BASE_HORIZONTAL_KNOCKBACK * multiplier * direction;
        vel.y = -BASE_VERTICAL_KNOCKBACK * multiplier;
        knockbackTimer = NORMAL_KNOCKBACK_DURATION;
        isDeathKnockback = false;
        movement.setInKnockback(true);
        movement.setJumping(true);
    }

    private void handleShieldDamage(float damage, float knockback, int direction, PVector vel, PlayerMovement movement)
    {
        shield.currentSize -= damage * 2;
        if (shield.currentSize <= shield.MIN_SIZE) {
            shield.deactivate();
            takeDamage(damage * SHIELD_BREAK_MULTIPLIER, knockback * SHIELD_BREAK_MULTIPLIER, direction, vel, movement);
        }
    }
}