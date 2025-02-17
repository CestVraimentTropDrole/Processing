/**
* Player - Représente un joueur dans le jeu
*
* Constantes de configuration du joueur
**/
class Player {
    /**
    * Variables d'état du joueur
    * @private Accessibles uniquement dans cette classe
    **/
    private PlayerMovement movement;
    private PlayerCombat combat;
    private PlayerAnimator animator;
    private ArrayList<Platform> platforms = new ArrayList<>();
    private PVector pos, vel;
    private Arena arena;
    private int lives = 3;
    public color col;
    public int score = 0;

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
        movement.setCrouching(crouching, pos, vel);
        animator.crouch(pos, crouching);
    }

    void takeDamage(float damage, float knockback, int direction)
    {
        combat.takeDamage(damage, knockback, direction, vel, movement);
    }

    void shoot()
    {
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
        arena.handlePlayerCollision(this);
        if (arena.checkPlayerDeath(this)) {
            lives--;
            if (lives <= 0) {
                lives = 0;
            }
            reset();
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