/**
* Bomb - Gestion de l'événement bombe, de sa chute, de l'explosion et de ses effets
*
* Constantes de configuration de la bombe
**/
class Bomb extends Event {
    static final float FALL_SPEED = 5;             // Vitesse de chute de la bombe
    static final int EXPLOSION_TIMER = 60;         // Timer d'explosion (~1 sec)
    static final float EXPLOSION_RADIUS = 80;      // Zone d'effet de l'explosion
    static final float EXPLOSION_DAMAGE = 20;      // Dégâts infligés par l'explosion
    static final float EXPLOSION_KNOCKBACK = 10;   // Force du knockback lors de l'explosion
    static final float EXPLOSION_OFFSET = 30;      // Décalage vertical du centre de l'explosion
    static final float BOMB_SIZE = 40;             // Taille de la bombe
    static final int BLINK_RATE = 10;              // Vitesse de clignotement
    static final float VERTICAL_OFFSET = -50;      // Position de départ au-dessus de l'écran

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private float x, y;                   // Position actuelle de la bombe
    private float targetY;                // Position cible d'atterrissage
    private boolean landed;               // État d'atterrissage
    private boolean exploded;             // État d'explosion
    private int explosionTimer;           // Compteur avant explosion
    private Player p1, p2;                // Références aux joueurs

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de la bombe
    * @param x La position X de la bombe
    * @param targetY La position Y où la bombe doit toucher le sol
    * @param p1 Référence au joueur 1
    * @param p2 Référence au joueur 2
    **/
    Bomb(float x, float targetY, Player p1, Player p2)
    {
        this.x = x;
        this.y = VERTICAL_OFFSET;
        this.targetY = targetY;
        this.p1 = p1;
        this.p2 = p2;
        this.landed = false;
        this.exploded = false;
        this.explosionTimer = EXPLOSION_TIMER;
    }

    void update()
    {
        if (!landed) {
            updateFall();
        } else {
            updateExplosionTimer();
        }
    }

    void display()
    {
        if (!exploded) {
            drawBomb();
        } else {
            drawExplosion();
        }
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void updateFall()
    {
        y += FALL_SPEED;
        if (y >= targetY) {
            y = targetY;
            landed = true;
        }
    }

    private void updateExplosionTimer()
    {
        explosionTimer--;
        if (explosionTimer <= 0) {
            explode();
        }
    }

    private void explode()
    {
        exploded = true;
        float explosionY = y - EXPLOSION_OFFSET;

        applyExplosionDamage(p1, explosionY);
        applyExplosionDamage(p2, explosionY);
        finished = true;
    }

    private void applyExplosionDamage(Player player, float explosionY)
    {
        if (isPlayerInExplosionRange(player, explosionY)) {
            int direction = (player.pos.x < x) ? -1 : 1;
            player.takeDamage(EXPLOSION_DAMAGE, EXPLOSION_KNOCKBACK, direction);
        }
    }

    private boolean isPlayerInExplosionRange(Player player, float explosionY)
    {
        return abs(player.pos.x - x) < EXPLOSION_RADIUS && abs(player.pos.y - explosionY) < EXPLOSION_RADIUS * 1.5;
    }

    private void drawBomb()
    {
        fill(frameCount % BLINK_RATE < BLINK_RATE/2 ? color(255, 0, 0) : color(255, 150, 0));
        ellipse(x, y, BOMB_SIZE, BOMB_SIZE);
    }

    private void drawExplosion()
    {
        fill(255, 165, 0, 150);
        ellipse(x, y, EXPLOSION_RADIUS * 3, EXPLOSION_RADIUS * 3);
    }
}