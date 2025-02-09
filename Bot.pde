class Bot {
    Player player;
    Player target;
    int difficulty;

    float shootRange;
    float minDistance;
    int thinkDelay;
    float jumpChance;
    float platformJumpChance;
    float moveChance;
    float reactionTime;
    boolean perfectAim;

    int thinkTimer = 0;
    int patrolTimer = 0;
    boolean isPatrollingRight = true;
    float lastX = 0;
    int stuckCounter = 0;
    float edgeMargin = 30;

    Bot(Player botPlayer, Player targetPlayer, int diff)
    {
        player = botPlayer;
        target = targetPlayer;
        lastX = player.pos.x;
        setDifficulty(diff);
    }

    void setDifficulty(int diff)
    {
        difficulty = diff;
        switch(difficulty) {
            case 0: // FACILE
                shootRange = 300;
                minDistance = 250;
                thinkDelay = 45;
                jumpChance = 0.01;
                platformJumpChance = 0.02;
                moveChance = 0.2;
                reactionTime = 30;
                perfectAim = false;
                break;

            case 1: // NORMAL
                shootRange = 400;
                minDistance = 200;
                thinkDelay = 30;
                jumpChance = 0.02;
                platformJumpChance = 0.05;
                moveChance = 0.3;
                reactionTime = 20;
                perfectAim = false;
                break;

            case 2: // DUR
                shootRange = 500;
                minDistance = 150;
                thinkDelay = 15;
                jumpChance = 0.03;
                platformJumpChance = 0.08;
                moveChance = 0.4;
                reactionTime = 10;
                perfectAim = true;
                break;

            case 3: // HARDCORE
                shootRange = 600;
                minDistance = 100;
                thinkDelay = 1;  // Réaction instantanée
                jumpChance = 0.05;
                platformJumpChance = 0.1;
                moveChance = 0.5;
                reactionTime = 1;
                perfectAim = true;
                break;
        }
    }

    void update()
    {
        thinkTimer++;
        patrolTimer++;

        // Check si le bot est bloqué
        if (abs(player.pos.x - lastX) < 1) {
            stuckCounter++;
            if (stuckCounter > 60) { // Si il est bloqué pendant 1 seconde
                player.jump();
                stuckCounter = 0;
            }
        } else {
            stuckCounter = 0;
        }
        lastX = player.pos.x;

        if (thinkTimer >= thinkDelay) {
            thinkTimer = 0;
            think();
        }

        // Comportement autonome quand le joueur est loin (Prototype)
        float distance = abs(player.pos.x - target.pos.x);

        if (distance > shootRange * 1.5) {
            patrol();
        }

        if (!player.isJumping) {
            if (difficulty == 3) {
                float bulletDistance = checkIncomingBullets();
                if (bulletDistance > 0 && bulletDistance < 200) {
                    player.jump();
                }
            } else if (random(1) < jumpChance || stuckCounter > 30) {
                player.jump();
            }
        }

        if (canShoot()) {
            player.shoot();
        }
    }

    float checkIncomingBullets()
    {
        float closestBullet = -1;

        for (PVector bullet : target.bullet.bullets) {
            if (abs(bullet.y - player.pos.y) < 50) {
                float distance = abs(bullet.x - player.pos.x);
                if (closestBullet == -1 || distance < closestBullet) {
                    closestBullet = distance;
                }
            }
        }
        return closestBullet;
    }

    void patrol()
    {
        // Move tout seul si t'es loin (Prototype)
        if (patrolTimer > 120) { // Change de direction toutes les 2 secondes
            isPatrollingRight = !isPatrollingRight;
            patrolTimer = 0;
        }

        // Évite de sortir de l'écran
        if (player.pos.x < 100) {
            isPatrollingRight = true;
        } else if (player.pos.x > width - 100) {
            isPatrollingRight = false;
        }

        move(isPatrollingRight ? 1 : -1);

        if (random(1) < jumpChance * 2) {
            player.jump();
        }
    }

    boolean canShoot()
    {
        float distance = abs(player.pos.x - target.pos.x);

        if (distance < shootRange) {
            boolean targetOnRight = target.pos.x > player.pos.x;
            if (difficulty == 3) {
                float predictedX = target.pos.x + target.vel.x * 10;
                targetOnRight = predictedX > player.pos.x;
            }

            return ((targetOnRight && player.facing > 0) || (!targetOnRight && player.facing < 0));
        }
        return false;
    }

    void think()
    {
        float dx = target.pos.x - player.pos.x;
        float distance = abs(dx);

        if (difficulty == 3) {
            // Mode Hardcore
            float optimalDistance = (shootRange + minDistance) / 2;

            if (distance < 50) { // Trop proche
                move(dx > 0 ? -1 : 1);
            } else if (abs(distance - optimalDistance) > 10) {
                move(distance > optimalDistance ? -1 : 1);
            } else {
                stop();
            }
        } else {
            // Comportement normal avec variations selon la difficulté
            if (distance > shootRange) {
                move(dx > 0 ? 1 : -1);
            } else if (distance < minDistance) {
                move(dx > 0 ? -1 : 1);
            } else if (random(1) < moveChance) {
                move(dx > 0 ? 1 : -1);
            } else {
                patrol(); // Patrouille quand à distance correcte
            }
        }
    }

    void move(float direction)
    {
        if (direction < 0) {
            leftPressed2 = true;
            rightPressed2 = false;
        } else {
            rightPressed2 = true;
            leftPressed2 = false;
        }
    }

    void stop()
    {
        leftPressed2 = false;
        rightPressed2 = false;
    }
}