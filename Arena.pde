class Arena {
    float width, height;
    ArrayList<Platform> platforms;
    float deathY;
    PImage background;

    Arena(float w, float h)
    {
        width = w;
        height = h;
        deathY = height + 200;
        platforms = new ArrayList<Platform>();
        setupPlatforms();
        background = loadImage("assets/sprites/bg_bg1.png");
        background.resize((int)width,(int)height);
    }

    void setupPlatforms()
    {
        // Plateforme principale plus large et plus haute
        float mainPlatformWidth = width * 0.6;
        platforms.add(new Platform(width/2 - mainPlatformWidth/2, height - 300, mainPlatformWidth, 40, true));

        // Plateformes flottantes plus grandes
        float smallPlatformWidth = width * 0.2;
        // Plateformes latérales
        platforms.add(new Platform(width * 0.2 - smallPlatformWidth/2, height - 500, smallPlatformWidth, 25, false));
        platforms.add(new Platform(width * 0.8 - smallPlatformWidth/2, height - 500, smallPlatformWidth, 25, false));
        // Plateforme centrale du haut
        platforms.add(new Platform(width/2 - smallPlatformWidth/2, height - 700, smallPlatformWidth, 25, false));
    }

    void draw()
    {
        // Fond
        background(background);
        
        // Plateformes
        for (Platform p : platforms) {
            p.draw();
        }

        // Zone de mort (indicateur visuel)
        noFill();
        stroke(255, 0, 0, 100);
        line(0, deathY - 50, width, deathY - 50);
    }

    boolean checkPlayerDeath(Player player)
    {
        // Mort si très loin de l'écran
        return player.pos.y > deathY + 300 || player.pos.x < -500 || player.pos.x > width + 500;
    }

    void handlePlayerCollision(Player player)
    {
        boolean onAnyPlatform = false;

        for (Platform p : platforms) {
            if (p.isOnPlatform(player.pos.x, player.pos.y, player.sprite.height, player.vel.y)) {
                player.pos.y = p.y - player.sprite.height;
                player.vel.y = 0;
                player.isJumping = false;
                player.jumpCount = 0;
                onAnyPlatform = true;
                break;
            }
        }

        if (!onAnyPlatform && !player.isJumping) {
            player.isJumping = true;
        }
    }
}
