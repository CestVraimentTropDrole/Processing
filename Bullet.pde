class Bullet {
    PVector pos, vel;
    PImage sprite;
    boolean active;
    float speed = 15;
    ArrayList<PVector> bullets;
    ArrayList<Integer> directions;
 
    Bullet(PImage bulletSprite)
    {
        sprite = bulletSprite;
        bullets = new ArrayList<PVector>();
        directions = new ArrayList<Integer>();
    }
    
    void fire(float x, float y, int direction)
    {
        bullets.add(new PVector(x, y));
        directions.add(direction);
    }
    
    void update()
    {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            PVector bullet = bullets.get(i);
            bullet.x += speed * directions.get(i);
            if (bullet.x < 0 || bullet.x > width) {
                bullets.remove(i);
                directions.remove(i);
            }
        }
    }
    
    boolean hits(Player target)
    {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            PVector bullet = bullets.get(i);
            if (bullet.x > target.pos.x && bullet.x < target.pos.x + target.sprite.width && bullet.y > target.pos.y && bullet.y < target.pos.y + target.sprite.height) {
                bullets.remove(i);
                directions.remove(i);
                return true;
            }
        }
        return false;
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