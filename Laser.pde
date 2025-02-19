/**
* Laser - Gestion de l'événement laser, son déplacement, ses collisions
*
* Constantes de configuration du Laser
**/
class Laser extends Event {
    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private float x;                      // Position x du laser
    private float widthLaser = 30;        // Largeur du laser
    private float speed;                  // Vitesse aléatoire du laser
    private boolean movingRight;          // Direction de déplacement du laser
    private boolean warning = true;       // Phase d'avertissement de l'apparition du laser
    private int warningTime = 90;         // Temps d'avertissement (1.5 secondes)
    private boolean active = false;       // Activation du laser
    private int duration = 300;           // Durée de vie du laser (5 secondes)
    private Player p1, p2;                // Références aux joueurs 1 et 2

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur pour initialiser un laser
    * @param p1 Référence au joueur 1
    * @param p2 Référence au joueur 2
    **/
    Laser(Player p1, Player p2)
    {
        this.p1 = p1;
        this.p2 = p2;
        this.x = random(width * 0.2, width * 0.8);
        this.movingRight = random(1) > 0.5;
        this.speed = random(3, 6);
    }

    void update()
    {
        if (warning) {
            warningTime--;
            if (warningTime <= 0) {
                warning = false;
                active = true;
            }
        } else if (active) {
            duration--;
            if (duration <= 0) {
                finished = true;
            }
            x += movingRight ? speed : -speed;
            if (x <= 200 || x >= width - (widthLaser + 200)) {
                movingRight = !movingRight;
            }
            checkHit();
        }
    }

    void checkHit()
    {
        if (active) {
            if (abs(p1.pos.x - x) < widthLaser / 2) {
                p1.takeDamage(30, 15, (p1.pos.x < x) ? -1 : 1);
            }
            if (abs(p2.pos.x - x) < widthLaser / 2) {
                p2.takeDamage(30, 15, (p2.pos.x < x) ? -1 : 1);
            }
        }
    }

    void display()
    {
        if (warning) {
            stroke(255, 255, 0, 200);
            strokeWeight(3);
            if (frameCount % 10 < 5) {
                line(x, 0, x, height);
            }
        } else if (active) {
            stroke(255, 0, 0);
            strokeWeight(6);
            line(x, 0, x, height);
        }
        strokeWeight(1);
    }
}