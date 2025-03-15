/**
* DummyController - Gestion du mode d'entraînement avec un dummy
*
* Constantes de configuration du dummy
**/
class DummyController {
    static final float RESET_DAMAGE_THRESHOLD = 100.0f; // Seuil de dégâts pour réinitialiser le dummy
    static final float SPAWN_Y_OFFSET = 50.0f;          // Décalage vers le bas pour le spawn

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private Player dummy;                // Référence au joueur contrôlé comme dummy
    private PVector initialPosition;     // Position initiale pour la réinitialisation
    private boolean isDummyMode;         // État d'activation du mode dummy

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du DummyController
    * @param player Référence au joueur à transformer en dummy
    **/
    DummyController(Player player)
    {
        this.dummy = player;
        this.isDummyMode = false;
    }

    void activate()
    {
        isDummyMode = true;
        dummy.lives = GameManager.DEFAULT_LIVES;
        dummy.setDummyMode(true);
        dummy.pos.y += SPAWN_Y_OFFSET;
        initialPosition = new PVector(dummy.pos.x, dummy.pos.y);
        dummy.movement.reset();
    }

    void deactivate()
    {
        isDummyMode = false;
        dummy.lives = GameManager.DEFAULT_LIVES;
        dummy.setDummyMode(false);
    }

    void update()
    {
        if (!isDummyMode)
            return;
        dummy.vel.x = 0;
        dummy.vel.y = 0;
        if (isDummyOutOfBounds() || dummy.getDamagePercent() >= RESET_DAMAGE_THRESHOLD) {
            resetDummy();
        }
    }

    boolean isActive()
    {
        return isDummyMode;
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private boolean isDummyOutOfBounds()
    {
        return dummy.pos.y > height + Arena.DEATH_OFFSET || dummy.pos.x < -Arena.DEATH_BOUNDARY || dummy.pos.x > width + Arena.DEATH_BOUNDARY;
    }

    private void resetDummy()
    {
        dummy.pos.x = initialPosition.x;
        dummy.pos.y = initialPosition.y;
        dummy.combat.reset();
        dummy.lives = GameManager.DEFAULT_LIVES;
    }
}