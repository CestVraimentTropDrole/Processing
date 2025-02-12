class Bomb extends Event {
    float x, y;
    float targetY;  // Position de la plateforme
    float speed = 5; // Vitesse de chute
    boolean landed = false;
    boolean exploded = false;
    int explosionTimer = 60; // Temps avant explosion après atterrissage (~1 sec)
    
    float explosionRadius = 80; // Zone d'effet de la bombe
    float explosionDamage = 20; // Dégâts infligés
    float explosionKnockback = 10; // Force du knockback
    Player p1, p2; // Références aux joueurs


    
    Bomb(float x, float targetY, Player p1, Player p2) {
        this.x = x;
        this.y = -50; // Spawn en haut de l'écran
        this.targetY = targetY;
        this.p1 = p1;
        this.p2 = p2;
    }

    void update() {
        if (!landed) {
            y += speed;  // La bombe tombe
            if (y >= targetY) {  // Quand elle touche la plateforme
                y = targetY;
                landed = true;
            }
        } else {
            explosionTimer--;
            if (explosionTimer <= 0) {
                explode();
            }
        }
    }

    void explode() {
        exploded = true;
        println("💥 BOOM !");
    
        // Correction : déplace légèrement l'explosion vers le haut
        float explosionY = y-30; // Ajuste la hauteur d'explosion
    
        // Vérifie si les joueurs sont dans la zone d'explosion
        if (abs(p1.pos.x - x) < explosionRadius && abs(p1.pos.y - explosionY) < explosionRadius * 1.5) {
            p1.takeDamage(explosionDamage, explosionKnockback, (p1.pos.x < x) ? -1 : 1);
        }
        if (abs(p2.pos.x - x) < explosionRadius && abs(p2.pos.y - explosionY) < explosionRadius * 1.5) {
            p2.takeDamage(explosionDamage, explosionKnockback, (p2.pos.x < x) ? -1 : 1);
        }
    
        finished = true;
    }



    void display() {
        if (!exploded) {
            fill(frameCount % 10 < 5 ? color(255, 0, 0) : color(255, 150, 0)); // Clignotement rouge/orange
            ellipse(x, y, 40, 40);
        } else {
            fill(255, 165, 0, 150); // Explosion orange transparente
            ellipse(x, y, explosionRadius * 3, explosionRadius * 3);
        }
    }

}
