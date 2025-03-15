/**
* VictoryScreen - Animation de l'écran de victoire style Smash Bros
*
* Constantes de configuration de l'animation
**/
class VictoryScreen {
    static final int PHASE_DURATION = 60;           // Durée de chaque phase
    static final float WINNER_SCALE = 1.8f;         // Échelle du gagnant
    static final float LOSER_SCALE = 0.8f;          // Échelle du perdant
    static final float WINNER_ENTRY_ROTATION = 720; // Rotation d'entrée du gagnant (2 tours)

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private static final int PHASE_START = 0;       // Phase initiale (écran noir)
    private static final int PHASE_WINNER = 1;      // Phase d'entrée du gagnant
    private static final int PHASE_LOSER = 2;       // Phase d'entrée du perdant
    private static final int PHASE_FINAL = 3;       // Phase finale
    private Player winner;                          // Référence au joueur gagnant
    private Player loser;                           // Référence au joueur perdant
    private int currentPhase;                       // Phase actuelle de l'animation
    private float phaseProgress;                    // Progression de la phase actuelle
    private boolean showReturnText;                 // Affichage du texte de retour
    private float textAlpha;                        // Transparence du texte de retour
    private float winnerRotation;                   // Angle de rotation du gagnant
    private PImage backgroundImage;                 // Image de fond pour l'écran de victoire
    private boolean active;                         // Indique si l'écran de victoire est actif

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'écran de victoire
    **/
    VictoryScreen()
    {
        active = false;
        reset();
        loadAssets();
    }

    void startAnimation(Player winner, Player loser)
    {
        this.winner = winner;
        this.loser = loser;
        this.currentPhase = PHASE_START;
        this.phaseProgress = 0;
        this.showReturnText = false;
        this.textAlpha = 0;
        this.winnerRotation = WINNER_ENTRY_ROTATION;
        this.active = true;
    }

    void update()
    {
        if (!active) return;
        
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
        if (currentPhase == PHASE_WINNER) {
            winnerRotation = lerp(WINNER_ENTRY_ROTATION, 0, easeOutElastic(phaseProgress));
        }
    }

    void draw()
    {
        if (!active)
            return;
        background(0);
        if (currentPhase >= PHASE_FINAL) {
            image(backgroundImage, 0, 0, width, height);
        }
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

    void reset()
    {
        active = false;
        currentPhase = PHASE_START;
        phaseProgress = 0;
        showReturnText = false;
        textAlpha = 0;
        winnerRotation = WINNER_ENTRY_ROTATION;
    }
    boolean isActive() {
        return active;
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void loadAssets()
    {
        backgroundImage = loadImage("assets/sprites/background/victory/victory_screen.png");
        backgroundImage.resize(width, height);
    }

    private void drawStartPhase()
    {
        float alpha = easeInOut(phaseProgress) * 255;
        fill(0, alpha);
        rect(0, 0, width, height);
    }

    private void drawWinnerPhase()
    {
        if (winner == null)
            return;
        float scale = lerp(0.1, WINNER_SCALE, easeOutBack(phaseProgress));
        float xPos = width * 0.5f;
        float yPos = height * 0.55f;

        pushMatrix();
        translate(xPos, yPos);
        rotate(radians(winnerRotation));
        scale(scale);
        translate(-winner.animator.getWidth()/2, -winner.animator.getCurrentHeight()/2);
        winner.animator.draw(new PVector(0, 0), 1);
        popMatrix();
    }

    private void drawLoserPhase()
    {
        if (loser == null)
            return;
        float scale = lerp(0.1, LOSER_SCALE, easeOutBack(phaseProgress));
        float xPos = width * 0.87f;
        float yPos = height * 0.77f;

        pushMatrix();
        translate(xPos, yPos);
        scale(scale);
        translate(-loser.animator.getWidth()/2, -loser.animator.getCurrentHeight()/2);
        loser.animator.draw(new PVector(0, 0), -1);
        popMatrix();
    }

    private void drawFinalPhase()
    {
        if (winner == null || loser == null)
            return;
        float xPosWinner = width * 0.5f;
        float yPosWinner = height * 0.55f;
        float xPosLoser = width * 0.87f;
        float yPosLoser = height * 0.77f;

        pushMatrix();
        translate(xPosWinner, yPosWinner);
        scale(WINNER_SCALE);
        translate(-winner.animator.getWidth()/2, -winner.animator.getCurrentHeight()/2);
        winner.animator.draw(new PVector(0, 0), 1);
        popMatrix();
        pushMatrix();
        translate(xPosLoser, yPosLoser);
        scale(LOSER_SCALE);
        translate(-loser.animator.getWidth()/2, -loser.animator.getCurrentHeight()/2);
        loser.animator.draw(new PVector(0, 0), -1);
        popMatrix();
    }

    private float easeOutBack(float x)
    {
        float c1 = 1.70158;
        float c3 = c1 + 1;
        return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2);
    }

    private float easeInOut(float x)
    {
        return x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
    }

    private float easeOutElastic(float x)
    {
        float c4 = (2 * PI) / 3;
        return x == 0 ? 0 : x == 1 ? 1 : pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
    }
}
