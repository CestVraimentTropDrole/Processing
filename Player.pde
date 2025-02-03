class Player {
    PVector pos, vel;
    PImage sprite;
    color col;
    int direction, score;
    float speed = 5;
    float normalHeight, crouchHeight;
    boolean isJumping, isCrouching;
    Bullet bullet;
    int facing;
    int jumpCount = 0;
    int maxJumps = 2;
    float jumpForce = -15;
    int lives = 3;  
  
    Player(float x, float y, PImage playerSprite, PImage bulletSprite, color c, int dir)
    {
        pos = new PVector(x, y);
        vel = new PVector();
        sprite = playerSprite;
        col = c;
        direction = dir;
        facing = dir;
        bullet = new Bullet(bulletSprite);
        reset();
    }
    
    void update()
    {
        applyPhysics();
        bullet.update();
    }
    
    void applyPhysics()
    {
        if (isJumping) {
            // Applique de la gravitas pour faire comme un vrai double saut
            vel.y += 0.8;
        }
        pos.add(vel);
    }
    
    void move(float dx)
    {
        pos.x += dx * speed;
        if (dx < 0) facing = -1;
        if (dx > 0) facing = 1;
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
    
    void reset()
    {
        // Ca reset tout ses stats en gros
        pos.y = height - 500;
        pos.x = direction == 1 ? width/4 : 3*width/4;
        vel.set(0, 0);
        isJumping = false;
        jumpCount = 0;
        isCrouching = false;
        normalHeight = sprite.height;
        crouchHeight = normalHeight * 0.6;
        bullet.reset();
        facing = direction;
    }
    
    void crouch(boolean crouching)
    {
        isCrouching = crouching;
        if (crouching) {
            // Réduire la taille du sprite et ajuster la position du joueur pour faire genre il sneak
            sprite.resize(sprite.width, int(crouchHeight));
            pos.y += normalHeight - crouchHeight;
        } else {
            // Et inversement pour le faire revenir a la normale
            sprite.resize(sprite.width, int(normalHeight));
            pos.y -= normalHeight - crouchHeight;
        }
    }
} 