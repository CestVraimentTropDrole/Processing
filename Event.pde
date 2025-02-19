/**
* Event - Classe représentant les événements dans le jeu.
*
* Constantes de configuration des événements
**/
abstract class Event {
    /** Variables d'état de l'événement */
    protected boolean finished = false;

    abstract void update();

    abstract void display();
}
