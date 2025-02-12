/**
 * Event - Classe représentant les événements dans le jeu.
 * Cette classe sert de base pour d'autres événements spécifiques
 *
 * Variables d'état et méthodes communes à tous les événements.
 */
abstract class Event {
    /** Variables d'état de l'événement */
    protected boolean finished = false;  // Indique si l'événement est terminé

    abstract void update();

    abstract void display();
}
