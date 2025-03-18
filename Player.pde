/**
* Player - Représente un joueur dans le jeu
*
* Constantes de configuration du joueur
**/
class Player {
    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private PlayerMovement movement;                            // Gestionnaire de mouvement du joueur
    private PlayerCombat combat;                                // Gestionnaire de combat du joueur
    private PlayerAnimator animator;                            // Gestionnaire d'animation du joueur
    private ArrayList<Platform> platforms = new ArrayList<>();  // Liste des plateformes pour la collision
    private PVector pos, vel;                                   // Position et vélocité du joueur
    private Arena arena;                                        // Arène dans laquelle le joueur évolue
    private boolean isDummy = false;                            // Indique si le joueur est un dummy en mode entraînement
    private int lives = 3;                                      // Nombre de vies restantes
    public color col;                                           // Couleur du joueur
    public int score = 0;                                       // Score du joueur

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du joueur
    * @param x Position X initiale
    * @param y Position Y initiale
    * @param playerSprite Sprite du joueur
    * @param bulletSprite Sprite des projectiles
    * @param c Couleur du joueur
    * @param dir Direction initiale
    **/
    Player(float x, float y, PImage playerSprite, PImage bulletSprite, color c, int dir)
    {
        pos = new PVector(x, y);
        vel = new PVector();
        movement = new PlayerMovement(dir);
        combat = new PlayerCombat(bulletSprite, this);
        animator = new PlayerAnimator(playerSprite, platforms);
        this.col = c;
    }

    void update()
    {
        movement.update(pos, vel);
        combat.update(vel, movement);
    }

    void move(float dx)
    {
        movement.move(pos, dx);
    }

    void jump()
    {
        movement.jump(vel);
    }

    void dash(boolean left, boolean right)
    {
        movement.dash(left, right);
    }

    void crouch(boolean crouching)
    {
        if (arena != null && arena.gameManager != null && (arena.gameManager.isCountingDown() || !arena.gameManager.hasGameStarted())) {
            return;
        }
        if (isDummy) {
            return;
        }
        movement.setCrouching(crouching, pos, vel);
        animator.crouch(pos, crouching);
    }

    void setDummyMode(boolean isDummy)
    {
        this.isDummy = isDummy;
    }

    void takeDamage(float damage, float knockback, int direction)
    {
        if (isDummy) {
            combat.damagePercent += damage;
        } else {
            combat.takeDamage(damage, knockback, direction, vel, movement);
        }
    }

    void shoot()
    {
        if (combat.currentWeapon != null) {
            if (arena != null && arena.soundManager != null) {
                arena.soundManager.playWeaponSound("pistol");
            }
        }
        combat.shoot(pos, animator.getWidth(), animator.getCurrentHeight(), movement.getFacing());
    }

    void equip(Weapon weapon)
    {
        combat.equip(weapon);
    }

    void activateShield()
    {
        combat.activateShield();
    }

    void deactivateShield()
    {
        combat.deactivateShield();
    }

    void setArena(Arena arena)
    {
        this.arena = arena;
    }

    void setPlatforms(ArrayList<Platform> platforms)
    {
        this.platforms.clear();
        this.platforms.addAll(platforms);
    }

    void handleArenaCollision()
    {
        if (!isDummy) {
            arena.handlePlayerCollision(this);
            if (arena.checkPlayerDeath(this)) {
                lives--;
                if (lives <= 0) {
                    lives = 0;
                }
                reset();
            }
        } else {
            boolean onAnyPlatform = false;
            float spriteHeight = animator.getCurrentHeight();
            for (Platform platform : platforms) {
                if (platform.isOnPlatform(pos.x, pos.y, spriteHeight, vel.y)) {
                    pos.y = platform.y - spriteHeight;
                    vel.y = 0;
                    onAnyPlatform = true;
                    break;
                }
            }
        }
    }

    void draw()
    {
        animator.draw(pos, movement.getFacing());
        combat.draw(pos, animator.getSprite());
    }

    void reset()
    {
        pos.y = height - 700;
        if (movement.getInitialFacing() == 1) {
            pos.x = width * 0.19;
        } else {
            pos.x = width * 0.77;
        }
        movement.reset();
        combat.reset();
        animator.reset();
        vel.set(0, 0);
    }

    // Getters
    float getDamagePercent() { return combat.getDamagePercent(); }
    boolean isJumping() { return movement.isJumping(); }
    boolean isCrouching() { return movement.isCrouching(); }
    boolean isInKnockback() { return movement.isInKnockback(); }
}