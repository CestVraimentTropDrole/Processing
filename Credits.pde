/**
* Credits - Affichage des crédits du jeu
*
* Constantes de configuration des contrôles
**/
class Credits {
    static final String CREDITS_PATH = "data/sprites/menus/credits.png";
    static final int CREDITS_TIMER = 50000;

    private boolean active;         // État des crédits
    private PImage credits_img;
    private float imgRatio, imgWidth, imgHeight;
    private int startTimer, time;
    private float percent;
    private boolean finished;

    Credits() {
        active = false;
        finished = false;
        startTimer = 0;
        percent = 0.0;

        credits_img = loadImage(CREDITS_PATH);
        imgRatio = (float) credits_img.height / credits_img.width;
        imgWidth = width;
        imgHeight = imgWidth * imgRatio;
    }

    void draw() {
        if (!active)
            return;

        percent = calculateTime(startTimer);

        if (percent >= 1.0) {
            desactivate();
        }

        float yOffset = -(imgHeight - height) * percent;
        image(credits_img, 0, yOffset, imgWidth, imgHeight);
    }

    void activate() {
        active = true;
        startTimer = millis();
        finished = false;
    }
    void desactivate() {
        active = false;
        finished = true;
    }

    // Getters
    boolean isActive() { return active; }
    boolean isFinished() { return finished; }

    // Setters
    void setFinished() { finished = false; }


    private float calculateTime(int startTimer) {
        float elapsed = (float)(millis() - startTimer);  // Cast explicite en float
        float percentTimer = elapsed / CREDITS_TIMER;

        return constrain(percentTimer, 0.0, 1.0);
    }
}
