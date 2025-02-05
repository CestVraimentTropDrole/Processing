class Game {
    Player player1;
    Player player2;
    Arena arena;
    boolean gameOver;
    PImage playerSprite;
    PImage bulletSprite;
    Bot bot;
  
    Game()
    {
        playerSprite = loadImage("assets/sprites/player.png");
        bulletSprite = loadImage("assets/sprites/bullet.png");
        PImage player1Sprite = playerSprite.copy();
        PImage player2Sprite = playerSprite.copy();
        player1Sprite.resize(50, 150);
        player2Sprite.resize(50, 150);
        bulletSprite.resize(20, 20);
        
        arena = new Arena(width, height); // Utilise la taille de l'écran littéralement donc faites gaffe !
        player1 = new Player(width/4, height - 200, player1Sprite, bulletSprite, color(0, 255, 0), 1);
        player2 = new Player(3*width/4, height - 200, player2Sprite, bulletSprite, color(255, 0, 0), -1);
        player1.arena = arena;
        player2.arena = arena;
        //bot = new Bot(player2, player1, 3);
        gameOver = false;
    }


    void checkGameState()
    {
        if (player1.score <= 0 || player2.score <= 0) {
            gameOver = true;
        }
    }
    
    void update()
    {
            if (!gameOver) {
                player1.update();
                player2.update();
                //bot.update();
                checkCollisions();
            }
    }
    
    void draw()
    {
        background(200);
        arena.draw();
    
        if (!gameOver) {
            displayScore();
            player1.draw();
            player2.draw();
        } else {
            displayGameOver();
        }
    }
  
    void displayScore()
    {
        textSize(32);
        
        // Joueur 1 (gauche)
        fill(0, 255, 0);
        text(nf(player1.damagePercent, 0, 1) + "%", 50, 50);  // Pourcentage
        for (int i = 0; i < player1.lives; i++) {
            text("<3", 50 + i * 40, 90);
        }
        
        // Joueur 2 (droite)
        fill(255, 0, 0);
        text(nf(player2.damagePercent, 0, 1) + "%", width - 150, 50);
        for (int i = 0; i < player2.lives; i++) {
            text("<3", width - 150 + i * 40, 90);
        }
    }
  
    void handleDeath(Player deadPlayer, Player winner)
    {
        deadPlayer.lives--;
        winner.score++;
        deadPlayer.reset();
        if (deadPlayer.lives <= 0 || winner.score >= 3) {
            gameOver = true;
        }
    }

    void displayGameOver()
    {
        textSize(32);
        fill(0);
        String winner = (player1.lives <= 0) ? "J2" : "J1";
        text(winner + " gagne!", width/2 - 100, height/2);
        textSize(16);
        text("'R' pour relancer", width/2 - 75, height/2 + 50);
    }
  
    void checkCollisions()
    {
        // Collisions balles/joueurs
        int hitIndex1 = player1.bullet.checkHit(player2);
        if (hitIndex1 >= 0) {
            handleHit(player1, player2);
            player1.bullet.removeBullet(hitIndex1);
        }
        
        int hitIndex2 = player2.bullet.checkHit(player1);
        if (hitIndex2 >= 0) {
            handleHit(player2, player1);
            player2.bullet.removeBullet(hitIndex2);
        }
        
        // Check si tu tombes
        if (arena.checkPlayerDeath(player1)) {
            handleDeath(player1, player2);
        }
        if (arena.checkPlayerDeath(player2)) {
            handleDeath(player2, player1);
        }
        
        // Collisions joueurs/arène
        player1.handleArenaCollision(arena);
        player2.handleArenaCollision(arena);
    }

    void handleHit(Player attacker, Player target)
    {
        float baseDamage = random(1, 4);  // Dégâts aléatoires entre 1% et 4%
        float baseKnockback = 5;  // Knockback de base
        
        // Direction du knockback (opposée à l'attaquant)
        int knockbackDirection = (attacker.pos.x < target.pos.x) ? 1 : -1;
        
        target.takeDamage(baseDamage, baseKnockback, knockbackDirection);
    }
  
    void reset()
    {
        player1.reset();
        player2.reset();
        player1.score = 0;
        player2.score = 0;
        gameOver = false;
        //bot.stop();
    }
}