/**
* UIManager - Gestion de l'interface utilisateur
*
* Constantes de configuration de l'interface
**/
class UIManager {
    static final int MARGIN = 100;                  // Marge horizontale pour les scores
    static final int SPRITE_SPACING = 64;           // Espacement entre les sprites
    static final int LIVES_VERTICAL_OFFSET = 48;    // Décalage vertical des vies
    static final int SCORE_Y = 50;                  // Position Y des scores
    static final int DECIMAL_CODE = -2;             // Code pour la virgule décimale

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private PImage[] numbers;      // Chiffres pour l'affichage des scores
    private PImage p1Life, p2Life; // Icônes de vie des joueurs

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur de l'UIManager
    * @param numbers Tableau des sprites des chiffres
    * @param p1Life Sprite de vie du joueur 1
    * @param p2Life Sprite de vie du joueur 2
    **/
    UIManager(PImage[] numbers, PImage p1Life, PImage p2Life)
    {
        if (numbers == null || p1Life == null || p2Life == null) {
            throw new IllegalArgumentException("UIManager: paramètres ne peuvent pas être null");
        }

        this.numbers = numbers;
        this.p1Life = p1Life;
        this.p2Life = p2Life;
    }

    void displayScore(Player player1, Player player2)
    {
        if (player1 == null || player2 == null)
            return;

        displayPlayerScore(player1, true);
        displayPlayerScore(player2, false);
    }

    void displayTimer(int sec, int dec)
    {
        String secStr = str(sec);
        float[] timeArray = new float[secStr.length() + 2];

        for (int i=0; i<secStr.length(); i++) {
            timeArray[i] = float(str(secStr.charAt(i)));
        }
        timeArray[secStr.length()] = -2;
        timeArray[secStr.length() + 1] = dec;

        int spacing = ((secStr.length() + 2) * SPRITE_SPACING) / 2;

        drawDigits(timeArray, float(width/2 - spacing));
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void displayPlayerScore(Player player, boolean isLeftSide)
    {
        float[] percentDigits = processPercentDigits(player.combat.damagePercent);
        float startX = calculateStartX(percentDigits.length, isLeftSide);

        drawDigits(percentDigits, startX);
        drawPercentSymbol(startX, percentDigits.length);
        displayPlayerLives(player, startX, isLeftSide);
    }

    private float calculateStartX(int digitCount, boolean isLeftSide)
    {
        return isLeftSide ? MARGIN : width - MARGIN - (digitCount * SPRITE_SPACING);
    }

    private void drawDigits(float[] digits, float startX)
    {
        for (int i = 0; i < digits.length; i++) {
            int digit = (int)digits[i];
            float x = startX + i * SPRITE_SPACING;

            if (digit >= 0 && digit <= 9) {
                image(numbers[digit], x, SCORE_Y);
            } else if (digit == DECIMAL_CODE) {
                image(numbers[11], x, SCORE_Y);
            }
        }
    }

    private void drawPercentSymbol(float startX, int digitCount)
    {
        image(numbers[10], startX + digitCount * SPRITE_SPACING, SCORE_Y);
    }

    private float[] processPercentDigits(float percent)
    {
        percent = Math.round(percent * 10) / 10.0;
        String percentStr = str(percent);
        float[] digits = new float[percentStr.length()];

        for (int i = 0; i < percentStr.length(); i++) {
            digits[i] = percentStr.charAt(i) == '.' ? DECIMAL_CODE : float(str(percentStr.charAt(i)));
        }
        return digits;
    }

    private void displayPlayerLives(Player player, float startX, boolean isLeftSide)
    {
        PImage lifeSprite = isLeftSide ? p1Life : p2Life;
        float y = SCORE_Y + LIVES_VERTICAL_OFFSET;

        for (int i = 0; i < player.lives; i++) {
            image(lifeSprite, startX + i * SPRITE_SPACING, y);
        }
    }
}
