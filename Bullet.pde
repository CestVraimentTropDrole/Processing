class Bullet {
    PVector pos, vel;
    PImage sprite;
    boolean active;
    float speed = 15;
    ArrayList<PVector> bullets;
    ArrayList<Integer> directions;
    long lastShotTime = 0;
    int cooldownDuration = 500;
 
    Bullet(PImage bulletSprite)
    {
        sprite = bulletSprite;
        bullets = new ArrayList<PVector>();
        directions = new ArrayList<Integer>();
    }
    
    boolean canShoot()
    {
        return millis() - lastShotTime >= cooldownDuration;
    }
    
    void fire(float x, float y, int direction)
    {
        if (canShoot()) {
            bullets.add(new PVector(x, y));
            directions.add(direction);
            lastShotTime = millis();
        }
    }
    
    void update()
    {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            PVector bullet = bullets.get(i);
            bullet.x += speed * directions.get(i);
            if (bullet.x < -50 || bullet.x > width + 50) {
                bullets.remove(i);
                directions.remove(i);
            }
        }
    }
    
    int checkHit(Player target)
    {
        for (int i = 0; i < bullets.size(); i++) {
            PVector bullet = bullets.get(i);
            if (bullet.x > target.pos.x && bullet.x < target.pos.x + target.sprite.width && 
                bullet.y > target.pos.y && bullet.y < target.pos.y + target.sprite.height) {
                return i;  // Retourne l'index de la balle qui touche
            }
        }
        return -1;  // Aucune balle n'a touché
    }
    
    void removeBullet(int index)
    {
        if (index >= 0 && index < bullets.size()) {
            bullets.remove(index);
            directions.remove(index);
        }
    }
    
    void draw()
    {
        for (PVector bullet : bullets) {
            image(sprite, bullet.x, bullet.y);
        }
    }

    boolean isActive()
    {
        return !bullets.isEmpty();
    }

    void reset()
    {
        bullets.clear();
        directions.clear();
    }
}