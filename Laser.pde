class Laser extends Event {
    float x; // Position du laser
    float widthLaser = 30; // Largeur du laser
    float speed; // Vitesse aléatoire
    boolean movingRight; // Direction du laser
    boolean warning = true; // Phase d'avertissement
    int warningTime = 90; // Temps d'avertissement (~1.5 sec)
    boolean active = false; // Activation du laser
    int duration = 300; // Temps avant la fin du laser (~5 sec)
    Player p1, p2;

    Laser(Player p1, Player p2) {
        this.p1 = p1;
        this.p2 = p2;
        this.x = random(width * 0.2, width * 0.8); // Spawn aléatoire
        this.movingRight = random(1) > 0.5; // Départ à gauche ou à droite
        this.speed = random(3, 6); // Vitesse plus modérée
    }

    void update() {
        if (warning) {
            warningTime--;
            if (warningTime <= 0) {
                warning = false;
                active = true;
            }
        } else if (active) {
            duration--;
            if (duration <= 0) {
                finished = true; // Disparaît après la durée
            }

            // Déplacement horizontal
            x += movingRight ? speed : -speed;
            
            // Rebond aux bords
            if (x <= 200 || x >= width - (widthLaser+200)) {
                movingRight = !movingRight;
            }

            checkHit();
        }
    }

    void checkHit() {
        if (active) {
            if (abs(p1.pos.x - x) < widthLaser / 2) {
                p1.takeDamage(30, 15, (p1.pos.x < x) ? -1 : 1);
            }
            if (abs(p2.pos.x - x) < widthLaser / 2) {
                p2.takeDamage(30, 15, (p2.pos.x < x) ? -1 : 1);
            }
        }
    }

    void display() {
        if (warning) {
            stroke(255, 255, 0, 200); // Jaune pour l’avertissement
            strokeWeight(3);
            if (frameCount % 10 < 5) { // Clignotement rapide
                line(x, 0, x, height);
            }
        } else if (active) {
            stroke(255, 0, 0); // Rouge pour le laser actif
            strokeWeight(6);
            line(x, 0, x, height);
        }
        strokeWeight(1);
    }
}
