/**
* Shield - Gestion du bouclier des joueurs
*
* Constantes de configuration du bouclier
**/
class Shield {
    static final float MAX_SIZE = 150;        // Taille maximale du bouclier
    static final float MIN_SIZE = 0;          // Taille minimale du bouclier
    static final float SHRINK_RATE = 1.0;     // Vitesse de réduction du bouclier
    static final float RECHARGE_RATE = 1.0;   // Vitesse de recharge du bouclier
    static final float STROKE_WEIGHT = 3;     // Épaisseur du trait du bouclier
    static final float SHIELD_ALPHA = 150;    // Transparence du bouclier

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private float currentSize;   // Taille actuelle du bouclier
    private boolean isActive;    // État d'activation du bouclier
    private final Player owner;  // Référence au joueur propriétaire

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du shield
    * @param player Référence au joueur propriétaire du bouclier
    * @param currentSize Taille actuelle du bouclier initialisée à MAX_SIZE
    * @param isActive État d'activation initial du bouclier (false par défaut)
    **/
    Shield(Player player)
    {
        owner = player;
        currentSize = MAX_SIZE;
        isActive = false;
    }

    void activate()
    {
        isActive = true;
    }

    void deactivate()
    {
        isActive = false;
    }

    void update()
    {
        if (isActive) {
            shrinkShield();
        } else {
            rechargeShield();
        }
    }

    void draw(float x, float y)
    {
        if (!isActive)
            return;
        drawShieldCircle(x, y);
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void shrinkShield()
    {
        currentSize = max(MIN_SIZE, currentSize - SHRINK_RATE);
    }

    private void rechargeShield()
    {
        currentSize = min(MAX_SIZE, currentSize + RECHARGE_RATE);
    }

    private void drawShieldCircle(float x, float y)
    {
        noFill();
        stroke(owner.col, SHIELD_ALPHA);
        strokeWeight(STROKE_WEIGHT);
        circle(x, y, currentSize);
        noStroke();
    }
}