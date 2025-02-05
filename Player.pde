class Player {
    PVector pos, vel;
    PImage sprite;
    PImage originalSprite;
    color col;
    int direction, score;
    float speed = 15;
    float normalHeight, crouchHeight;
    boolean isJumping, isCrouching;
    Bullet bullet;
    int facing;
    int jumpCount = 0;
    int maxJumps = 2;
    float jumpForce = -15;
    int lives = 3;  
    float damagePercent = 0;
    float knockbackMultiplier = 0.1;
    boolean isInKnockback = false;
    int knockbackTimer = 0;
    boolean isDeathKnockback = false;
    boolean isCrouchingState;
    Arena arena;

    // Dash properties
    float dashDistance;
    boolean isDashing = false;
    int dashCooldown = 500;
    long lastDashTime = 0;
    float dashVelocity = 0;
    float distanceDashed = 0;
    int dashTimer = 0;
  
    Player(float x, float y, PImage playerSprite, PImage bulletSprite, color c, int dir)
    {
        pos = new PVector(x, y);
        vel = new PVector();
        originalSprite = playerSprite.copy();
        sprite = playerSprite;
        col = c;
        direction = dir;
        facing = dir;
        bullet = new Bullet(bulletSprite);
        normalHeight = sprite.height;
        crouchHeight = normalHeight * 0.6;
        dashDistance = sprite.width * 2;
        reset();
    }

    void dash(boolean left, boolean right)
    {
        if (isCrouching || isDashing || (millis() - lastDashTime < dashCooldown)) 
            return;
        
        float dashSpeed = 25;
        float dashDistance = 300;
        dashTimer = 15;
        
        if (left) {
            dashVelocity = -dashSpeed;
            facing = -1;
        } else if (right) {
            dashVelocity = dashSpeed;
            facing = 1;
        } else {
            dashVelocity = facing * dashSpeed;
        }
        
        isDashing = true;
        distanceDashed = 0;
        lastDashTime = millis();
    }

    void update()
    {
        if (isInKnockback) {
            knockbackTimer--;
            // Si c'est un knockback de mort, pas de contrôle possible
            if (!isDeathKnockback && knockbackTimer <= 0) {
                isInKnockback = false;
                vel.x = 0;  // Arrête net le knockback horizontal
                if (vel.y < 0) {  // Si le joueur monte encore
                    vel.y = 0;    // On arrête la montée
                }
            }
        }
        applyPhysics();
        bullet.update();
    }

    void applyPhysics()
    {
        if (isDashing) {
            distanceDashed += abs(dashVelocity);
            if (distanceDashed >= 300) {
                isDashing = false;
                vel.x = 0;
            } else {
                vel.x = dashVelocity;
            }
        }
        
        if (isJumping && !isInKnockback && !isDashing) {
            vel.y += 0.6;
        }
        pos.add(vel);
    }

    void takeDamage(float damage, float knockback, int direction)
    {
        damagePercent += damage;
        float baseHorizontalKnockback = 5;
        float baseVerticalKnockback = 1;
        
        // Knockback spécial de mort au-dessus de 100%
        if (damagePercent >= 100) {
            baseHorizontalKnockback = 16;
            baseVerticalKnockback = 4;
            knockbackTimer = 30;
            isDeathKnockback = true;  // Active le mode "mort"
        } else {
            float multiplier = 1 + (damagePercent * knockbackMultiplier);
            knockbackTimer = 15;
            isDeathKnockback = false;
        }
        
        if (isDeathKnockback) {
            // Trajectoire plus dramatique pour la mort
            vel.x = baseHorizontalKnockback * direction;
            vel.y = -baseVerticalKnockback;
        } else {
            // Knockback normal
            float multiplier = 1 + (damagePercent * knockbackMultiplier);
            vel.x = baseHorizontalKnockback * multiplier * direction;
            vel.y = -baseVerticalKnockback * multiplier;
        }
        isInKnockback = true;
        isJumping = true;
    }
    
    void move(float dx)
    {
        if (!isInKnockback) {
            pos.x += dx * speed;
            if (dx < 0) facing = -1;
            if (dx > 0) facing = 1;
        }
    }
    
    void jump()
    {
        if (jumpCount < maxJumps) {
            // Fait sauter le joueur et augmenter le nombre de sauts pour pas spam saut et littéralement voler
            vel.y = jumpForce;
            isJumping = true;
            jumpCount++;
        }
    }
    
    void shoot()
    {
        // Tirer une balle dans la direction que le joueur fait face
        bullet.fire(pos.x + sprite.width/2, pos.y + sprite.height/2, facing);
    }
    
    void handleArenaCollision(Arena arena)
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
        pushMatrix();
        if (facing < 0) {
            // Dessiner le sprite du joueur en le retournant horizontalement pour créer un effet de miroir
            translate(pos.x + sprite.width, pos.y);
            scale(-1, 1);
            image(sprite, 0, 0);
        } else {
            image(sprite, pos.x, pos.y);
        }
        popMatrix();
        bullet.draw();
    }
        
    void crouch(boolean crouching)
    {
        if (isCrouchingState == crouching) {
            return;
        }

        isCrouchingState = crouching;
        isCrouching = crouching;
        
        if (crouching) {
            sprite = originalSprite.copy();  // Utilise une nouvelle copie
            sprite.resize(sprite.width, int(crouchHeight));
            pos.y += (normalHeight - crouchHeight);
        } else {
            // Vérifie s'il y a de la place pour se relever
            float newY = pos.y - (normalHeight - crouchHeight);
            boolean canStand = true;
            
            // Vérifie les collisions avec les plateformes
            for (Platform p : arena.platforms) {
                if (newY < p.y + p.h && newY + normalHeight > p.y &&
                    pos.x + sprite.width > p.x && pos.x < p.x + p.w) {
                    canStand = false;
                    break;
                }
            }
            
            if (canStand) {
                sprite = originalSprite.copy();  // Restaure le sprite original
                pos.y = newY;
            } else {
                // Si on ne peut pas se relever, on reste accroupi
                isCrouchingState = true;
                isCrouching = true;
            }
        }
    }

    void reset()
    {
        // Ca reset tout ses stats en gros
        pos.y = height - 500;
        pos.x = direction == 1 ? width/4 : 3*width/4;
        vel.set(0, 0);
        isJumping = false;
        jumpCount = 0;
        isCrouching = false;
        sprite = originalSprite.copy();
        normalHeight = sprite.height;
        crouchHeight = normalHeight * 0.6;
        bullet.reset();
        facing = direction;
        damagePercent = 0;
        isInKnockback = false;
        knockbackTimer = 0;
        isDeathKnockback = false;
        isCrouchingState = false;
    }
}
