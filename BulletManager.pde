/**
* BulletManager - Gestionnaire des projectiles actifs
**/
class BulletManager {
    // Constantes de configuration
    static final float BULLET_DESPAWN_DISTANCE = 50;  // Distance à laquelle les projectiles disparaissent de l'écran

    /**
    * Variables d'état du gestionnaire
    * @private Accessibles uniquement dans cette classe
    **/
    private final ArrayList<PVector> positions;      // Liste des positions de tous les projectiles actifs
    private final ArrayList<Integer> directions;     // Liste des directions de tous les projectiles actifs
    private final ArrayList<BulletProperties> properties;  // Liste des propriétés de chaque projectile

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du gestionnaire
    **/
    BulletManager()
    {
        positions = new ArrayList<PVector>();
        directions = new ArrayList<Integer>();
        properties = new ArrayList<BulletProperties>();
    }

    void addBullet(PVector pos, int direction, BulletProperties props)
    {
        positions.add(pos.copy());
        directions.add(direction);
        properties.add(props);
    }

    void update()
    {
        for (int i = positions.size() - 1; i >= 0; i--) {
            PVector pos = positions.get(i);
            BulletProperties props = properties.get(i);
            pos.x += props.getSpeed() * directions.get(i);
            if (isOutOfBounds(pos)) {
                removeBullet(i);
            }
        }
    }

    int checkCollision(Player target)
    {
        for (int i = 0; i < positions.size(); i++) {
            PVector pos = positions.get(i);
            if (isHitting(pos, target)) {
                return i;
            }
        }
        return -1;
    }

    void draw()
    {
        for (int i = 0; i < positions.size(); i++) {
            PVector pos = positions.get(i);
            BulletProperties props = properties.get(i);
            image(props.getSprite(), pos.x, pos.y);
        }
    }

    void removeBullet(int index)
    {
        if (isValidIndex(index)) {
            positions.remove(index);
            directions.remove(index);
            properties.remove(index);
        }
    }

    void clear()
    {
        positions.clear();
        directions.clear();
        properties.clear();
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private boolean isOutOfBounds(PVector pos)
    {
        return pos.x < -BULLET_DESPAWN_DISTANCE || pos.x > width + BULLET_DESPAWN_DISTANCE;
    }

    private boolean isHitting(PVector bulletPos, Player target)
    {
        return bulletPos.x > target.pos.x && bulletPos.x < target.pos.x + target.sprite.width && bulletPos.y > target.pos.y && bulletPos.y < target.pos.y + target.sprite.height;
    }

    private boolean isValidIndex(int index)
    {
        return index >= 0 && index < positions.size();
    }
}