/**
* Credits - Affichage des crédits du jeu
*
* Constantes de configuration des contrôles
**/
class Credits {
    private boolean active;
    private String credits_text;

    Credits() {
        active = false;
        // Je vais bien trouver un moyen d'ouvrir un fichier texte et le convertir en String parce que là mdr c'est affreux bigup à celui qui lit
        credits_text = ("Une production MMI2 & Studio Cacabox \n Shadow Wizard Money Gang \n\n CRÉDITS \n Chef de projet : Haloys aka le petit indien \n Programmeurs : Fabien, Evan, Tim \n\n Remerciements spéciaux : \n Mathieu Tom et le Benge \n Le légendaire 3-0 Houzet VS Carron en 20 secondes \n Les neuilles \n Ceux qui ont testé \n Le type qui zyeute mon écran de pc là je te vois");
    }

    void draw() {
        if (!active) { 
            return; 
        }

        fill(0,0,0);
        rect(0,0, width, height);

        fill(255,255,255);
        textFont(createFont("Arial", 24));
        textAlign(CENTER, CENTER);
        text(credits_text, width/2, height/2);
    }

    void activate() {
        active = true;
    }
    void desactivate() {
        active = false;
    }

    // Getters
    boolean isActive() { return active; }
}