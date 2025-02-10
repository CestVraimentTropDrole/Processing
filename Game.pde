class Game {
    Player player1;
    Player player2;
    Arena arena;
    boolean gameOver;
    PImage playerSprite1, playerSprite2;
    PImage bulletSimple, bulletLaser, bulletArrow, bulletLong;
    PImage p1Life, p2Life;
    PImage gunSprite, pistolSprite, blasterSprite, bowSprite;
    ArrayList<Weapon> weapons;
    int weaponSpawnTimer = 0;
    final int WEAPON_SPAWN_DELAY = 100; // 10 secondes (60 frames * 10)
    final int WEAPON_LIFETIME = 5000; // 5 secondes (ms)
    PImage[] numbers, imageDamage;

    Game(Minim minim)
    {
        playerSprite1 = loadImage("assets/sprites/red/player_idle.png");
        playerSprite2 = loadImage("assets/sprites/yellow/player_idle.png");
        gunSprite = loadImage("assets/sprites/gun/ak47.png");
        pistolSprite = loadImage("assets/sprites/gun/gunsimple.png");
        blasterSprite = loadImage("assets/sprites/gun/blaster.png");
        bowSprite = loadImage("assets/sprites/gun/bow.png");
        p1Life = loadImage("assets/sprites/red/life.png");
        p2Life = loadImage("assets/sprites/yellow/life.png");
        bulletSimple = loadImage("assets/sprites/bullet/simple.png");
        bulletLaser = loadImage("assets/sprites/bullet/laser.png");
        bulletArrow = loadImage("assets/sprites/bullet/arrow.png");
        bulletLong = loadImage("assets/sprites/bullet/long.png");

        // Charge les assets des chiffres pour l'UI
        numbers = new PImage[12];
        for (int i=0; i < 10; i++) {
            numbers[i] = loadImage("assets/sprites/damage/"+i+".png");
        }
        numbers[10] = loadImage("assets/sprites/damage/percent.png"); //Image du %
        numbers[11] = loadImage("assets/sprites/damage/comma.png"); //Image de la ,

        weapons = new ArrayList<Weapon>();
        PImage player1Sprite = playerSprite1.copy();
        PImage player2Sprite = playerSprite2.copy();
        bulletSimple.resize(20, 20);
        bulletLaser.resize(20, 20);
        bulletArrow.resize(20, 20);
        bulletLong.resize(20, 20);

        arena = new Arena(width, height, minim);
        player1 = new Player(width/4, height - 200, player1Sprite, bulletSimple, color(0, 255, 0), 1);
        player2 = new Player(3*width/4, height - 200, player2Sprite, bulletSimple, color(255, 0, 0), -1);
        player1.arena = arena;
        player2.arena = arena;
        gameOver = false;
    }

    void startGame()
    {
        // Initialisation du jeu
        gameOver = false;
        player1.score = 0;
        player2.score = 0;
        player1.lives = 3;
        player2.lives = 3;
        player1.reset();
        player2.reset();
    }

    void checkGameState()
    {
        if (player1.lives <= 0 || player2.lives <= 0) {
            gameOver = true;
        }
    }

    void update()
    {
        if (!gameOver) {
            player1.update();
            player2.update();
            checkCollisions();
            updateWeapons();
            weaponSpawnTimer++;
            if (weaponSpawnTimer >= WEAPON_SPAWN_DELAY) {
                spawnRandomWeapon();
                weaponSpawnTimer = 0;
            }
            for (Weapon weapon : weapons) {
                if (weapon.canPickup(player1) && keyPressed && key == ' ') {
                    weapon.pickup(player1);
                }
                if (weapon.canPickup(player2) && keyPressed && key == '0') {
                    weapon.pickup(player2);
                }
            }
        }
    }

    void spawnRandomWeapon()
    {
        Platform platform = arena.platforms.get((int)random(arena.platforms.size()));
        float weaponX = random(platform.x + 30, platform.x + platform.w - 30);
        float weaponY = platform.y - 60;

        Weapon newWeapon;
        float rand = random(1);
        if (rand < 0.25) {
            newWeapon = new Gun(weaponX, weaponY, gunSprite, bulletLong);  // AK47 avec balles longues
        } else if (rand < 0.5) {
            newWeapon = new Pistol(weaponX, weaponY, pistolSprite, bulletSimple);  // Pistolet avec balles simples
        } else if (rand < 0.75) {
            newWeapon = new Blaster(weaponX, weaponY, blasterSprite, bulletLaser);  // Blaster avec laser
        } else {
            newWeapon = new Bow(weaponX, weaponY, bowSprite, bulletArrow);  // Arc avec flèches
        }
        newWeapon.spawnTime = millis();
        weapons.add(newWeapon);
    }

    void updateWeapons()
    {
        for (int i = weapons.size() - 1; i >= 0; i--) {
            Weapon weapon = weapons.get(i);
            if (!weapon.isPickedUp) {
                long timeAlive = millis() - weapon.spawnTime;
                if (timeAlive > WEAPON_LIFETIME) {
                    weapon.fadeOut();
                    if (weapon.getRenderer().getAlpha() <= 0) {
                        weapons.remove(i);
                    }
                }
            }
        }
    }

    void draw()
    {
        background(200);
        arena.draw();

        if (!gameOver) {
            displayScore();
            for (Weapon weapon : weapons) {
                if (!weapon.isPickedUp) {
                    weapon.draw();
                }
            }
            player1.draw();
            player2.draw();
        } else {
            displayGameOver();
        }
    }

    void displayPercent(float playerDamage)
    {
        String damage = str(playerDamage); // Transforme les dégâts du joueur en chaine de caractères
        int[] digits = new int[damage.length()+1]; // Créé le tableau de chiffres
        imageDamage = new PImage[digits.length]; // Initialise le tableau d'images

        for (int i=0; i<damage.length(); i++) {
            digits[i] = int(damage.charAt(i)) - 48;
            if (digits[i] >= 0 && digits[i] <= 9) {
                imageDamage[i] = numbers[digits[i]];
            } else if (digits[i] == -2) { //La virgule = -2 après le charAt -48
                imageDamage[i] = numbers[11];
            }
        }
        imageDamage[damage.length()] = numbers[10]; //Puis ajout de l'image du % à la fin
    }

    void displayScore()
    {
        final int MARGIN = 100;
        final int SPRITE_SPACING = 40;
        final int LIVES_VERTICAL_OFFSET = 40;

        // Joueur 1 (gauche)
        displayPercent(player1.damagePercent);
        for (int i = 0; i < imageDamage.length; i++) {
            image(imageDamage[i], MARGIN + i * SPRITE_SPACING, 50);
        }
        for (int i = 0; i < player1.lives; i++) {
            image(p1Life, MARGIN + i * SPRITE_SPACING, 50 + LIVES_VERTICAL_OFFSET);
        }

        // Joueur 2 (droite)
        displayPercent(player2.damagePercent);
        float totalWidth = imageDamage.length * SPRITE_SPACING;
        float startX = width - MARGIN - totalWidth;

        for (int i = 0; i < imageDamage.length; i++) {
            image(imageDamage[i], startX + i * SPRITE_SPACING, 50);
        }
        for (int i = 0; i < player2.lives; i++) {
            image(p2Life, startX + i * SPRITE_SPACING, 50 + LIVES_VERTICAL_OFFSET);
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
        text("'R' pour relancer, 'H' pour retour", width/2 - 90, height/2 + 50);
    }

    void checkCollisions()
    {
        // Collisions balles/joueurs
        int hitIndex1 = player1.bullet.checkHit(player2);
        if (hitIndex1 >= 0) {
            handleHit(player1, player2, hitIndex1);
            player1.bullet.removeBullet(hitIndex1);
        }

        int hitIndex2 = player2.bullet.checkHit(player1);
        if (hitIndex2 >= 0) {
            handleHit(player2, player1, hitIndex2);
            player2.bullet.removeBullet(hitIndex2);
        }

        // Vérification de la mort des joueurs
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

    void handleHit(Player attacker, Player target, int bulletIndex)
    {
        // Utilise les dégâts configurés dans l'arme
        float baseDamage = attacker.bullet.getDamageForBullet(bulletIndex);
    
        // Arrondir à un chiffre après la virgule pour l'affichage
        baseDamage = round(baseDamage * 10) / 10.0;
    
        float baseKnockback = 5;

        // Direction du knockback
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
    }
}
