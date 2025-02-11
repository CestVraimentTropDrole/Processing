/**
* PlayerMovement - Gestion des mouvements du joueur
*
* Constantes de configuration du mouvement
**/
class PlayerMovement {
    static final float SPEED = 15;            // Vitesse de déplacement
    static final float GRAVITY = 0.6;         // Force de gravité
    static final float JUMP_FORCE = -15;      // Force du saut
    static final int MAX_JUMPS = 2;           // Nombre maximum de sauts
    static final float DASH_SPEED = 25;       // Vitesse du dash
    static final float DASH_DISTANCE = 300;   // Distance du dash
    static final int DASH_COOLDOWN = 500;     // Temps de recharge du dash
    static final float MAX_FALL_SPEED = 20;   // Vitesse maximale de chute

    /**
    * Variables d'état de mouvement
    * @private Accessibles uniquement dans cette classe
    **/
    private boolean isDashing;                // État du dash
    private boolean isJumping;                // État du saut
    private boolean isInKnockback;            // État du knockback
    private boolean isCrouching;              // État accroupi
    private int jumpCount;                    // Nombre de sauts effectués
    private int facing;                       // Direction du regard
    private float distanceDashed;             // Distance parcourue en dash
    private float dashVelocity;               // Vitesse actuelle du dash
    private long lastDashTime;                // Dernier dash effectué

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du système de mouvement
    * @param initialFacing Direction initiale du regard
    **/
    PlayerMovement(int initialFacing)
    {
        facing = initialFacing;
        reset();
    }

    void update(PVector pos, PVector vel)
    {
        updateDash(pos, vel);
        if (!isCrouching || isJumping) {
            applyPhysics(pos, vel);
        }
    }

    void move(PVector pos, float dx)
    {
        if (!isInKnockback) {
            pos.x += dx * SPEED;
            facing = (dx < 0) ? -1 : 1;
        }
    }

    void jump(PVector vel)
    {
        if (jumpCount < MAX_JUMPS) {
            vel.y = JUMP_FORCE;
            isJumping = true;
            jumpCount++;
        }
    }

    void dash(boolean left, boolean right)
    {
        if (canDash()) {
            initiateDash(left, right);
        }
    }

    void setCrouching(boolean state, PVector pos, PVector vel)
    {
        isCrouching = state;
        if (state && !isJumping) {
            vel.y = 0;
        }
    }

    void reset()
    {
        isDashing = false;
        isJumping = false;
        isInKnockback = false;
        isCrouching = false;
        jumpCount = 0;
        lastDashTime = 0;
        dashVelocity = 0;
        distanceDashed = 0;
    }

    // Getters
    int getFacing() { return facing; }
    boolean isJumping() { return isJumping; }
    boolean isCrouching() { return isCrouching; }
    boolean isInKnockback() { return isInKnockback; }

    // Setters
    void setJumping(boolean state) { isJumping = state; }
    void setInKnockback(boolean state) { isInKnockback = state; }
    void resetJumpCount() { jumpCount = 0; }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private boolean canDash()
    {
        return !isCrouching && !isDashing && (millis() - lastDashTime >= DASH_COOLDOWN);
    }

    private void initiateDash(boolean left, boolean right)
    {
        if (left) {
            dashVelocity = -DASH_SPEED;
            facing = -1;
        } else if (right) {
            dashVelocity = DASH_SPEED;
            facing = 1;
        } else {
            dashVelocity = facing * DASH_SPEED;
        }
        isDashing = true;
        distanceDashed = 0;
        lastDashTime = millis();
    }

    private void updateDash(PVector pos, PVector vel)
    {
        if (isDashing) {
            distanceDashed += abs(dashVelocity);
            if (distanceDashed >= DASH_DISTANCE) {
                isDashing = false;
                vel.x = 0;
            } else {
                vel.x = dashVelocity;
            }
        }
    }

    private void applyPhysics(PVector pos, PVector vel)
    {
        if (!isDashing) {
            vel.y = min(vel.y + GRAVITY, MAX_FALL_SPEED);
        }
        pos.add(vel);
    }
}