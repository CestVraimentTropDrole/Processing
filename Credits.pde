/**
* Credits - Affichage des crédits du jeu
*
* Constantes de configuration des contrôles
**/
class Credits {
    private boolean active;

    Credits() {
        active = false;
    }

    void draw() {
        if (!active) { 
            return; 
        }

        textFont(createFont("Arial", 24));
        textAlign(CENTER, LEFT);
        text("CRÉDITS !!!", 100, 100);
    }

    void activate() {
        active = true;
        println("Crédits : Activés");
    }
    void desactivate() {
        active = false;
        println("Crédits : Désactivés");
    }

    // Getters
    boolean isActive() { return active; }
}