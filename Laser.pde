class Laser extends Event {
    float y;
    float speed = 5;
    boolean active = true;
    Player p1, p2;
    
    Laser(float y, Player p1, Player p2) {
        this.y = y;
        this.p1 = p1;
        this.p2 = p2;
    }

    void update() {
        if (active) {
            y += speed;
            checkHit();
            if (y > height) {
                finished = true;
            }
        }
    }

    void checkHit() {
        if (abs(p1.pos.y - y) < 10) {
            p1.takeDamage(40, 20, (p1.pos.x < width / 2) ? -1 : 1);
        }
        if (abs(p2.pos.y - y) < 10) {
            p2.takeDamage(40, 20, (p2.pos.x < width / 2) ? -1 : 1);
        }
    }

    void display() {
        stroke(255, 0, 0);
        strokeWeight(6);
        line(0, y, width, y);
        strokeWeight(1);
    }
}
