class Shield {
    float maxSize = 150;
    float currentSize;
    float minSize = 0;           // Une taille minimum plus grande pour éviter de casser trop facilement (si besoin)
    float shrinkRate = 1.0;       // Plus rapide pour une meilleure réactivité
    float rechargeRate = 1.0;     // Recharge beaucoup plus rapide
    float alpha = 150;
    boolean isActive = false;
    Player owner;

    Shield(Player player)
    {
        this.owner = player;
        currentSize = maxSize;
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
            currentSize = max(minSize, currentSize - shrinkRate);
            if (currentSize <= minSize) {
                // Au lieu de désactiver complètement, on garde le shield minimal (si besoin)
                currentSize = minSize;
            }
        } else {
            currentSize = min(maxSize, currentSize + rechargeRate);
        }
    }

    void draw(float x, float y)
    {
        if (isActive) {
            noFill();
            stroke(owner.col, alpha);
            strokeWeight(3);
            circle(x, y, currentSize);
            noStroke();
        }
    }
}