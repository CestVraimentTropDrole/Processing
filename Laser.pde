class Laser extends Event {
    float x, y; // Position du laser
    float widthLaser = 30; // Largeur du laser
    float speed; // Vitesse du laser
    boolean movingRight; // Direction du laser (horizontal seulement)
    boolean warning = true; // Phase d'avertissement
    int warningTime = 90; // Temps d'avertissement (~1.5 sec)
    boolean active = false; // Activation du laser
    int duration = 300; // Temps avant la fin du laser (~5 sec)
    Player p1, p2;
    boolean isHorizontal; // Détermine si le laser est horizontal ou vertical

    // Constructeur pour le laser horizontal ou vertical
    Laser(float y, Player p1, Player p2, boolean isHorizontal) {
        this.p1 = p1;
        this.p2 = p2;
        this.isHorizontal = isHorizontal;
        
        if (isHorizontal) {
            this.x = random(width * 0.2, width * 0.8); // Spawn horizontal aléatoire
            this.movingRight = random(1) > 0.5; // Départ à gauche ou à droite
            this.speed = random(3, 6); // Vitesse plus modérée
        } else {
            this.y = y; // Position verticale initiale
            this.speed = 5; // Vitesse verticale fixe
        }
    }

    void update() {
        if (warning) {
            warningTime--;
            if (warningTime <= 0) {
                warning = false;
                active = true;
            }
        } else if (active) {
            if (isHorizontal) {
                // Déplacement horizontal
                x += movingRight ? speed : -speed;
                
                // Rebond aux bords
                if (x <= 200 || x >= width - (widthLaser + 200)) {
                    movingRight = !movingRight;
                }
            } else {
                // Déplacement vertical
                y += speed;
                if (y > height) {
                    finished = true; // Fin du laser après qu'il dépasse l'écran
                }
            }

            // Vérifier les collisions
            checkHit();
            
            // Durée d'activation du laser
            duration--;
            if (duration <= 0) {
                finished = true;
            }
        }
    }

    void checkHit() {
        if (active) {
            if (isHorizontal) {
                // Vérification des collisions horizontalement
                if (abs(p1.pos.x - x) < widthLaser / 2) {
                    p1.takeDamage(30, 15, (p1.pos.x < x) ? -1 : 1);
                }
                if (abs(p2.pos.x - x) < widthLaser / 2) {
                    p2.takeDamage(30, 15, (p2.pos.x < x) ? -1 : 1);
                }
            } else {
                // Vérification des collisions verticalement
                if (abs(p1.pos.y - y) < 10) {
                    p1.takeDamage(40, 20, (p1.pos.x < width / 2) ? -1 : 1);
                }
                if (abs(p2.pos.y - y) < 10) {
                    p2.takeDamage(40, 20, (p2.pos.x < width / 2) ? -1 : 1);
                }
            }
        }
    }

    void display() {
        if (warning) {
            stroke(255, 255, 0, 200); // Jaune pour l’avertissement
            strokeWeight(3);
            if (frameCount % 10 < 5) { // Clignotement rapide
                if (isHorizontal) {
                    line(x, 0, x, height); // Laser horizontal
                } else {
                    line(0, y, width, y); // Laser vertical
                }
            }
        } else if (active) {
            stroke(255, 0, 0); // Rouge pour le laser actif
            strokeWeight(6);
            if (isHorizontal) {
                line(x, 0, x, height); // Laser horizontal
            } else {
                line(0, y, width, y); // Laser vertical
            }
        }
        strokeWeight(1); // Remettre à la valeur par défaut
    }
}
