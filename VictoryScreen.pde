/**
* VictoryScreen - Animation de l'écran de victoire style Smash Bros
*/
class VictoryScreen {
    // Constantes d'animation
    static final int PHASE_DURATION = 60;           // Durée de chaque phase
    static final float WINNER_FINAL_SCALE = 2.5f;   // Échelle finale du gagnant
    static final float LOSER_FINAL_SCALE = 0.8f;    // Échelle finale du perdant

    // Phases d'animation
    private static final int PHASE_START = 0;       // Écran noir
    private static final int PHASE_WINNER = 1;      // Entrée du gagnant
    private static final int PHASE_LOSER = 2;       // Entrée du perdant
    private static final int PHASE_FINAL = 3;       // Position finale
    private Player winner;
    private Player loser;
    private int currentPhase;
    private float phaseProgress;
    private PFont victoryFont;
    private boolean showReturnText;
    private float textAlpha;

    VictoryScreen() {
        reset();
        victoryFont = createFont("Arial Bold", 48);
    }

    void startAnimation(Player winner, Player loser) {
        this.winner = winner;
        this.loser = loser;
        this.currentPhase = PHASE_START;
        this.phaseProgress = 0;
        this.showReturnText = false;
        this.textAlpha = 0;
    }

    void update() {
        phaseProgress += 1.0f / PHASE_DURATION;
        if (phaseProgress >= 1.0) {
            phaseProgress = 0;
            currentPhase++;
            if (currentPhase > PHASE_FINAL) {
                showReturnText = true;
            }
        }
        if (showReturnText) {
            textAlpha = min(textAlpha + 5, 255);
        }
    }

    void draw() {
        background(0);
        switch(currentPhase) {
            case PHASE_START:
                drawStartPhase();
                break;
            case PHASE_WINNER:
                drawWinnerPhase();
                break;
            case PHASE_LOSER:
                drawWinnerPhase();
                drawLoserPhase();
                break;
            default:
                drawFinalPhase();
                break;
        }
        if (showReturnText) {
            textFont(createFont("Arial", 24));
            textAlign(CENTER, BOTTOM);
            fill(255, textAlpha);
            text("Appuyez sur H pour revenir au menu", width/2, height - 30);
        }
    }

    private void drawStartPhase() {
        float alpha = easeInOut(phaseProgress) * 255;
        fill(0, alpha);
        rect(0, 0, width, height);
    }

    private void drawWinnerPhase() {
        pushMatrix();
        float scale = lerp(0.1, WINNER_FINAL_SCALE, easeOutBack(phaseProgress));
        float xPos = width/2;
        float yPos = height/2;

        translate(xPos, yPos);
        scale(scale);
        translate(-winner.animator.getWidth()/2, -winner.animator.getCurrentHeight()/2);
        winner.animator.draw(new PVector(0, 0), 1);
        textFont(victoryFont);
        textAlign(CENTER, TOP);
        fill(255, min(phaseProgress * 255, 255));
        text("WINNER", 0, -100);
        popMatrix();
    }

    private void drawLoserPhase() {
        pushMatrix();
        float scale = lerp(0.1, LOSER_FINAL_SCALE, easeOutBack(phaseProgress));
        float xPos = width * 0.8f;
        float yPos = height * 0.7f;
        translate(xPos, yPos);
        scale(scale);
        translate(-loser.animator.getWidth()/2, -loser.animator.getCurrentHeight()/2);
        loser.animator.draw(new PVector(0, 0), -1);
        popMatrix();
    }

    private void drawFinalPhase() {
        pushMatrix();
        translate(width/2, height/2);
        scale(WINNER_FINAL_SCALE);
        translate(-winner.animator.getWidth()/2, -winner.animator.getCurrentHeight()/2);
        winner.animator.draw(new PVector(0, 0), 1);
        popMatrix();
        pushMatrix();
        translate(width * 0.8f, height * 0.7f);
        scale(LOSER_FINAL_SCALE);
        translate(-loser.animator.getWidth()/2, -loser.animator.getCurrentHeight()/2);
        loser.animator.draw(new PVector(0, 0), -1);
        popMatrix();
        textFont(victoryFont);
        textAlign(CENTER, TOP);
        fill(255);
        text("WINNER", width/2, height/2 - 200);
    }

    void reset() {
        winner = null;
        loser = null;
        currentPhase = PHASE_START;
        phaseProgress = 0;
        showReturnText = false;
        textAlpha = 0;
    }

    private float easeOutBack(float x)
    {
        float c1 = 1.70158;
        float c3 = c1 + 1;
        return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2);
    }

    private float easeInOut(float x) {
        return x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
    }
}