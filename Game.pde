class Game {
    Player player1;
    Player player2;
    Arena arena;
    boolean gameOver;
    PImage playerSprite;
    PImage bulletSprite;
  
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
        fill(0);
        text("J1: " + player1.score, 50, 50);
        text("J2: " + player2.score, width - 150, 50);
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
        if (player1.bullet.isActive() && player1.bullet.hits(player2)) {
            handleHit(player1, player2);
        }
        if (player2.bullet.isActive() && player2.bullet.hits(player1)) {
            handleHit(player2, player1);
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
        attacker.score++;
        target.reset();
        attacker.bullet.reset();
        if (attacker.score >= 3) 
            gameOver = true;
    }
  
    void reset()
    {
        player1.reset();
        player2.reset();
        player1.score = 0;
        player2.score = 0;
        gameOver = false;
    }
}