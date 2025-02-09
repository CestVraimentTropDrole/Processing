class Shield {
    static final float MAX_SIZE = 150;
    static final float MIN_SIZE = 0;
    static final float SHRINK_RATE = 1.0;
    static final float RECHARGE_RATE = 1.0;

    float currentSize;
    float alpha = 150;
    boolean isActive = false;
    Player owner;

    Shield(Player player)
    {
        this.owner = player;
        currentSize = MAX_SIZE;
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
            currentSize = max(MIN_SIZE, currentSize - SHRINK_RATE);
            if (currentSize <= MIN_SIZE) {
                // Au lieu de désactiver complètement, on garde le shield minimal (si besoin)
                currentSize = MIN_SIZE;
            }
        } else {
            currentSize = min(MAX_SIZE, currentSize + RECHARGE_RATE);
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