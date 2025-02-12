/**
* AIPlayer - Classe de joueur contrôlé par l'ordinateur
*
* Constantes de comportement de l'IA
**/
class AIPlayer extends Player {
    static final float SHOOT_DISTANCE = 400;            // Distance optimale de tir
    static final float DODGE_DISTANCE = 300;            // Distance de détection du danger
    static final float MIN_SAFE_DISTANCE = 150;         // Distance minimale de sécurité
    static final float PLATFORM_EDGE_MARGIN = 50;       // Marge de sécurité des plateformes
    static final long WEAPON_ATTEMPT_TIMEOUT = 3000;    // Temps maximum pour tenter d'atteindre une arme

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private Player target;
    private ArrayList<Weapon> availableWeapons;
    private long lastDecisionTime;
    private long lastJumpTime;
    private long lastPositionChangeTime;
    private float lastTargetX;
    private boolean isDodging;
    private boolean isRepositioning;
    private int moveDirection;
    private AIConfiguration config;

    /**
    * Méthodes publiques - Interface externe
    **/

    // Classe interne pour l'analyse des armes
    private class WeaponTarget {
        Weapon weapon;
        float distance;
        float heightDiff;
        boolean requiresDoubleJump;

        /**
        * Constructeur de l'analyse des armes
        * @param w Arme à analyser
        * @param d Distance à l'arme
        * @param h Différence de hauteur à l'arme
        * @param dj Nécessite un double saut
        */
        WeaponTarget(Weapon w, float d, float h, boolean dj)
        {
            weapon = w;
            distance = d;
            heightDiff = h;
            requiresDoubleJump = dj;
        }
    }

    /**
    * Constructeur de l'IA
    * @param x Position X initiale
    * @param y Position Y initiale
    * @param playerSprite Sprite du joueur
    * @param bulletSprite Sprite des projectiles
    * @param c Couleur du joueur
    * @param dir Direction initiale
    * @param target Joueur cible
    **/
    AIPlayer(float x, float y, PImage playerSprite, PImage bulletSprite, color c, int dir, Player target)
    {
        super(x, y, playerSprite, bulletSprite, c, dir);
        this.target = target;
        this.lastDecisionTime = millis();
        this.lastJumpTime = millis();
        this.lastPositionChangeTime = millis();
        this.lastTargetX = target.pos.x;
        this.isDodging = false;
        this.isRepositioning = false;
        this.moveDirection = 1;

        // Initialiser avec une configuration par défaut (niveau moyen)
        this.config = new AIConfiguration();
    }

    void setDifficulty(String level)
    {
        switch(level.toLowerCase()) {
            case "easy":
                config.setEasyDifficulty();
                break;
            case "medium":
                config.setMediumDifficulty();
                break;
            case "hard":
                config.setHardDifficulty();
                break;
            default:
                config.setMediumDifficulty();
        }
    }

    public void setAvailableWeapons(ArrayList<Weapon> weapons)
    {
        this.availableWeapons = weapons;
    }

    @Override
    void update()
    {
        super.update();
        checkForDanger();
        if (millis() - lastDecisionTime > config.decisionInterval) {
            updateBehavior();
            lastDecisionTime = millis();
        }
        preventFalling();
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private WeaponTarget analyzeWeaponAccessibility(Weapon weapon)
    {
        float distance = abs(weapon.x - pos.x);
        float heightDiff = pos.y - weapon.y;
        boolean needsDoubleJump = heightDiff > 150;
        return new WeaponTarget(weapon, distance, heightDiff, needsDoubleJump);
    }

    private int getWeaponPriority(Weapon weapon)
    {
        if (weapon instanceof Blaster)
            return 4;
        if (weapon instanceof Gun)
            return 3;
        if (weapon instanceof Pistol)
            return 2;
        if (weapon instanceof Bow)
            return 1;
        return 0;
    }

    private boolean shouldSwitchWeapon(Weapon newWeapon)
    {
        if (combat.currentWeapon == null)
            return true;
        return getWeaponPriority(newWeapon) > getWeaponPriority(combat.currentWeapon);
    }

    private void findAndGetWeapon()
    {
        if (availableWeapons == null)
            return;
        WeaponTarget bestTarget = null;
        long currentTime = millis();
        int currentPriority = combat.currentWeapon != null ? getWeaponPriority(combat.currentWeapon) : 0;
        if (currentTime - lastPositionChangeTime > WEAPON_ATTEMPT_TIMEOUT) {
            isRepositioning = true;
            lastPositionChangeTime = currentTime;
            return;
        }
        for (Weapon weapon : availableWeapons) {
            if (!weapon.isPickedUp) {
                int weaponPriority = getWeaponPriority(weapon);
                if (weaponPriority > currentPriority) {
                    WeaponTarget target = analyzeWeaponAccessibility(weapon);
                    if (bestTarget == null || weaponPriority > getWeaponPriority(bestTarget.weapon) || (weaponPriority == getWeaponPriority(bestTarget.weapon) && target.distance < bestTarget.distance)) {
                        bestTarget = target;
                    }
                }
            }
        }

        if (bestTarget != null) {
            move(bestTarget.weapon.x > pos.x ? 1 : -1);
            if (bestTarget.heightDiff > 0) {
                if (bestTarget.requiresDoubleJump) {
                    if (movement.isJumping() && millis() - lastJumpTime > 200) {
                        jump();
                        lastJumpTime = millis();
                    }
                    else if (!movement.isJumping() && millis() - lastJumpTime > 1000) {
                        jump();
                        lastJumpTime = millis();
                    }
                }
                else if (millis() - lastJumpTime > 1000) {
                    jump();
                    lastJumpTime = millis();
                }
            }
            if (bestTarget.weapon.canPickup(this)) {
                bestTarget.weapon.pickup(this);
                lastPositionChangeTime = millis();
            }
        }
    }

    private void checkForDanger()
    {
        if (target.combat.bullet == null || target.combat.bullet.manager == null)
            return;
        if (random(1) > config.dodgeProbability)
            return;
        if (random(1) < config.reactionDelay)
            return;
        boolean dangerDetected = false;
        float botHeight = animator.getCurrentHeight();

        for (int i = 0; i < target.combat.bullet.manager.positions.size(); i++) {
            PVector bulletPos = target.combat.bullet.manager.positions.get(i);
            float bulletDistX = abs(bulletPos.x - pos.x);
            float bulletDistY = abs(bulletPos.y - (pos.y + botHeight/2));
            if (bulletDistX < DODGE_DISTANCE && bulletDistY < botHeight * 1.5) {
                dangerDetected = true;
                    handleDodge(bulletPos);
                break;
            }
        }
        if (!dangerDetected) {
            deactivateShield();
            isDodging = false;
        }
    }

    private void handleDodge(PVector bulletPos)
    {
        Platform currentPlatform = null;
        for (Platform platform : platforms) {
            if (pos.x >= platform.x && pos.x <= platform.x + platform.w && pos.y + animator.getCurrentHeight() >= platform.y && pos.y + animator.getCurrentHeight() <= platform.y + platform.h) {
                currentPlatform = platform;
                break;
            }
        }
        if (currentPlatform != null) {
            float platformCenter = currentPlatform.x + (currentPlatform.w / 2);
            float distanceToCenter = abs(pos.x - platformCenter);
            if (pos.x < currentPlatform.x + currentPlatform.w * 0.3 || pos.x > currentPlatform.x + currentPlatform.w * 0.7) {
                moveDirection = (pos.x < platformCenter) ? 1 : -1;
                dash(moveDirection < 0, moveDirection > 0);
            } else {
                activateShield();
            }
        } else {
            Platform nearest = findNearestPlatform();
            if (nearest != null) {
                float platformCenter = nearest.x + (nearest.w / 2);
                moveDirection = (pos.x < platformCenter) ? 1 : -1;
                    dash(moveDirection < 0, moveDirection > 0);
            }
        }
        isDodging = true;
    }

    private void updateBehavior()
    {
        if (isDodging)
            return;
        findAndGetWeapon();
        if (millis() - lastPositionChangeTime > 2000) {
            isRepositioning = true;
            moveDirection = (random(1) > 0.5) ? 1 : -1;
            lastPositionChangeTime = millis();
        }
        if (combat.currentWeapon != null) {
            fight();
        }
    }

    private void fight()
    {
        float distanceToTarget = target.pos.x - pos.x;
        float verticalDistance = target.pos.y - pos.y;

        if (abs(distanceToTarget) > SHOOT_DISTANCE || abs(distanceToTarget) < MIN_SAFE_DISTANCE) {
            float idealDistance = (SHOOT_DISTANCE + MIN_SAFE_DISTANCE) / 2;
            move(abs(distanceToTarget) > idealDistance ? (distanceToTarget > 0 ? 1 : -1) : (distanceToTarget > 0 ? -1 : 1));
        }
        if (!isDodging && combat.currentWeapon != null) {
            if (abs(verticalDistance) < SHOOT_DISTANCE / 2 && random(1) < config.accuracy) {
                shoot();
            }
        }
        if (!movement.isJumping() && millis() - lastJumpTime > 1500 && random(1) < 0.2) {
            jump();
            lastJumpTime = millis();
        }
        if (combat.bullet != null && combat.bullet.currentAmmo < (combat.bullet.maxAmmo * config.reloadThreshold)) {
            combat.bullet.startReload();
            if (random(1) < config.shieldUseProbability) {
                activateShield();
            }
        }
        lastTargetX = target.pos.x;
    }

    private void preventFalling()
    {
        Platform currentPlatform = null;
        float botHeight = animator.getCurrentHeight();
        float futureX = pos.x + (moveDirection * PLATFORM_EDGE_MARGIN);

        for (Platform platform : platforms) {
            if (pos.x >= platform.x && pos.x <= platform.x + platform.w &&
                pos.y + botHeight >= platform.y && pos.y + botHeight <= platform.y + platform.h) {
                currentPlatform = platform;
                break;
            }
        }
        if (currentPlatform != null) {
            boolean hasPlatformAhead = false;
            float edgeX = moveDirection > 0 ? currentPlatform.x + currentPlatform.w : currentPlatform.x;
            float distanceToEdge = abs(pos.x - edgeX);

            for (Platform platform : platforms) {
                if (platform == currentPlatform)
                    continue;
                boolean reachableHeight = abs(platform.y - currentPlatform.y) < 100;
                boolean inReachableDistance = moveDirection > 0 ? (platform.x > pos.x && platform.x - pos.x < 200) : (platform.x + platform.w < pos.x && pos.x - (platform.x + platform.w) < 200);
                if (reachableHeight && inReachableDistance) {
                    hasPlatformAhead = true;
                    break;
                }
            }
            if (distanceToEdge < PLATFORM_EDGE_MARGIN && !hasPlatformAhead && !movement.isJumping()) {
                moveDirection *= -1;
                move(moveDirection);
                pos.x += moveDirection * 10;
            }

            if (distanceToEdge < 20) {
                pos.x = moveDirection > 0 ? currentPlatform.x + currentPlatform.w - PLATFORM_EDGE_MARGIN : currentPlatform.x + PLATFORM_EDGE_MARGIN;
            }
        } else if (!movement.isJumping()) {
            Platform nearestPlatform = findNearestPlatform();
            if (nearestPlatform != null) {
                float centerX = nearestPlatform.x + nearestPlatform.w/2;
                moveDirection = pos.x < centerX ? 1 : -1;
                move(moveDirection);
                if (nearestPlatform.y < pos.y) {
                    jump();
                }
            }
        }
    }

    private Platform findNearestPlatform()
    {
        Platform nearest = null;
        float minDistance = Float.MAX_VALUE;

        for (Platform platform : platforms) {
            float platformCenterX = platform.x + platform.w/2;
            float distance = abs(pos.x - platformCenterX);
            if (distance < minDistance) {
                minDistance = distance;
                nearest = platform;
            }
        }
        return nearest;
    }
}