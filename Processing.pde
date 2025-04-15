/**
* Processing - Point d'entrée principal du jeu
*
* Fichier principal qui contient les méthodes requises par Processing
* Ce fichier ne peut pas contenir de classe car il est lui-même une classe implicite
**/

import ddf.minim.*;

// Instance principale du contrôleur
GameController gameController;

/**
* Configuration initiale
* Méthode appelée une fois au démarrage
**/
void setup()
{
    fullScreen();
    gameController = new GameController(this);
}

/**
* Boucle principale
* Méthode appelée à chaque frame
**/
void draw()
{
    gameController.update();
}

/**
* Gestion des touches pressées
* @param key Touche alphanumérique pressée
* @param keyCode Code de la touche spéciale pressée
**/
void keyPressed()
{
    gameController.handleKeyPressed(key, keyCode);
}

/**
* Gestion des touches relâchées
* @param key Touche alphanumérique relâchée
* @param keyCode Code de la touche spéciale relâchée
**/
void keyReleased()
{
    gameController.handleMovementKeyReleased(key, keyCode);
}
