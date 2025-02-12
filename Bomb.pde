/**
 * Bomb - Gestion de l'événement bombe, de sa chute, de l'explosion et de ses effets.
 * Cette classe gère la chute de la bombe, l'explosion et l'application des dégâts et knockback aux joueurs.
 *
 * Variables d'état et méthodes de gestion de l'événement de bombe.
 */
class Bomb extends Event {
    /** Position de la bombe */
    float x, y;                    // Position actuelle de la bombe
    float targetY;                 // Position de la plateforme où la bombe doit atterrir

    /** Vitesse et états de la bombe */
    float speed = 5;               // Vitesse de chute de la bombe
    boolean landed = false;        // Statut de la bombe (si elle a touché le sol ou non)
    boolean exploded = false;      // Statut de la bombe (si elle a explosé ou non)
    int explosionTimer = 60;       // Timer avant l'explosion après l'atterrissage (~1 sec)

    /** Paramètres de l'explosion */
    float explosionRadius = 80;    // Zone d'effet de l'explosion
    float explosionDamage = 20;    // Dégâts infligés par l'explosion
    float explosionKnockback = 10; // Force du knockback lors de l'explosion

    /** Références aux joueurs pour appliquer les dégâts */
    Player p1, p2;                // Joueurs 1 et 2 pour vérifier si ils sont affectés par l'explosion

    /**
     * Constructeur de la bombe.
     * @param x La position X de la bombe
     * @param targetY La position Y où la bombe doit toucher le sol (plateforme)
     * @param p1 Référence au joueur 1
     * @param p2 Référence au joueur 2
     */
    Bomb(float x, float targetY, Player p1, Player p2) {
        this.x = x;
        this.y = -50; // La bombe spawn juste au-dessus de l'écran
        this.targetY = targetY;
        this.p1 = p1;
        this.p2 = p2;
    }

    /**
     * Met à jour l'état de la bombe.
     * Gère la chute de la bombe et son explosion après un certain délai.
     */
    void update() {
        if (!landed) {
            y += speed;  // La bombe chute à une certaine vitesse
            if (y >= targetY) {  // Si elle atteint la plateforme
                y = targetY;
                landed = true;  // Marquer comme étant "atterrie"
            }
        } else {
            explosionTimer--;  // Décrémenter le timer avant l'explosion
            if (explosionTimer <= 0) {
                explode();  // Déclencher l'explosion si le timer atteint zéro
            }
        }
    }

    /**
     * Déclenche l'explosion de la bombe.
     * Applique les dégâts et le knockback aux joueurs dans la zone d'explosion.
     */
    void explode() {
        exploded = true;  // Marquer la bombe comme ayant explosé
    
        float explosionY = y - 30;  // Ajuste la hauteur de l'explosion
    
        // Vérifie si les joueurs sont dans la zone d'effet de l'explosion
        if (abs(p1.pos.x - x) < explosionRadius && abs(p1.pos.y - explosionY) < explosionRadius * 1.5) {
            p1.takeDamage(explosionDamage, explosionKnockback, (p1.pos.x < x) ? -1 : 1);  // Dégâts à p1
        }
        if (abs(p2.pos.x - x) < explosionRadius && abs(p2.pos.y - explosionY) < explosionRadius * 1.5) {
            p2.takeDamage(explosionDamage, explosionKnockback, (p2.pos.x < x) ? -1 : 1);  // Dégâts à p2
        }
    
        finished = true;  // Marquer l'événement comme terminé
    }

    /**
     * Affiche l'état de la bombe à l'écran.
     * Affiche la bombe tombante avant l'explosion et l'explosion après l'impact.
     */
    void display() {
        if (!exploded) {
            fill(frameCount % 10 < 5 ? color(255, 0, 0) : color(255, 150, 0));
            ellipse(x, y, 40, 40);
        } else {
            fill(255, 165, 0, 150);
            ellipse(x, y, explosionRadius * 3, explosionRadius * 3);
        }
    }
}
