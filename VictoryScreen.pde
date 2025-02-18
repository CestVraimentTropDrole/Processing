/**
* VictoryScreen - Animation de l'écran de victoire style Smash Bros
*
* Constantes de configuration de l'animation
**/
class VictoryScreen {
    static final int PHASE_DURATION = 60;           // Durée de chaque phase
    static final float WINNER_FINAL_SCALE = 2.5f;   // Échelle finale du gagnant
    static final float LOSER_FINAL_SCALE = 0.8f;    // Échelle finale du perdant
    static final float RANK_TEXT_SIZE = 32;         // Taille du texte des rangs
    static final float WINNER_ENTRY_ROTATION = 720; // Rotation d'entrée du gagnant (2 tours)

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private static final int PHASE_START = 0;       // Phase initiale (écran noir)
    private static final int PHASE_WINNER = 1;      // Phase d'entrée du gagnant
    private static final int PHASE_LOSER = 2;       // Phase d'entrée du perdant
    private static final int PHASE_FINAL = 3;       // Phase finale avec les rangs
    private Player winner;                          // Référence au joueur gagnant
    private Player loser;                           // Référence au joueur perdant
    private int currentPhase;                       // Phase actuelle de l'animation
    private float phaseProgress;                    // Progression de la phase actuelle
    private PFont victoryFont;                      // Police d'écriture de victoire
    private boolean showReturnText;                 // Affichage du texte de retour
    private float textAlpha;                        // Transparence du texte de retour
    private float winnerRotation;                   // Angle de rotation du gagnant
    private float rankTextAlpha;                    // Transparence des textes de rang

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'écran de victoire
    **/
    VictoryScreen()
    {
        reset();
        victoryFont = createFont("Arial Bold", 48);
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
        this.rankTextAlpha = 0;
    }

    void update()
    {
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
        if (currentPhase == PHASE_FINAL) {
            rankTextAlpha = min(rankTextAlpha + 8, 255);
        }
        if (currentPhase == PHASE_WINNER) {
            winnerRotation = lerp(WINNER_ENTRY_ROTATION, 0, easeOutElastic(phaseProgress));
        }
    }

    void draw()
    {
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

    void reset()
    {
        winner = null;
        loser = null;
        currentPhase = PHASE_START;
        phaseProgress = 0;
        showReturnText = false;
        textAlpha = 0;
        winnerRotation = WINNER_ENTRY_ROTATION;
        rankTextAlpha = 0;
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement dans cette classe
    **/
    private void drawStartPhase()
    {
        float alpha = easeInOut(phaseProgress) * 255;
        fill(0, alpha);
        rect(0, 0, width, height);
    }

    private void drawWinnerPhase()
    {
        float scale = lerp(0.1, WINNER_FINAL_SCALE, easeOutBack(phaseProgress));
        float xPos = width/2;
        float yPos = height/2;

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
        float scale = lerp(0.1, LOSER_FINAL_SCALE, easeOutBack(phaseProgress));
        float xPos = width * 0.8f;
        float yPos = height * 0.7f;

        pushMatrix();
        translate(xPos, yPos);
        scale(scale);
        translate(-loser.animator.getWidth()/2, -loser.animator.getCurrentHeight()/2);
        loser.animator.draw(new PVector(0, 0), -1);
        popMatrix();
    }

    private void drawFinalPhase()
    {
        float xPosWinner = width/2;
        float yPosWinner = height/2;
        float xPosLoser = width * 0.8f;
        float yPosLoser = height * 0.7f;

        pushMatrix();
        translate(xPosWinner, yPosWinner);
        scale(WINNER_FINAL_SCALE);
        translate(-winner.animator.getWidth()/2, -winner.animator.getCurrentHeight()/2);
        winner.animator.draw(new PVector(0, 0), 1);
        popMatrix();
        pushMatrix();
        translate(xPosLoser, yPosLoser);
        scale(LOSER_FINAL_SCALE);
        translate(-loser.animator.getWidth()/2, -loser.animator.getCurrentHeight()/2);
        loser.animator.draw(new PVector(0, 0), -1);
        popMatrix();
        textFont(victoryFont);
        fill(255, rankTextAlpha);
        textSize(RANK_TEXT_SIZE);
        textAlign(LEFT, CENTER);
        float winnerTextX = xPosWinner + (winner.animator.getWidth() * WINNER_FINAL_SCALE / 2);
        text("1er", winnerTextX, yPosWinner);
        textSize(RANK_TEXT_SIZE * LOSER_FINAL_SCALE);
        float loserTextX = xPosLoser + (loser.animator.getWidth() * LOSER_FINAL_SCALE / 2);
        text("2ème", loserTextX, yPosLoser);
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