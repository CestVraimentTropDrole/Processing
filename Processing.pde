Game game;
StartScreen startScreen;

boolean leftPressed1 = false;
boolean rightPressed1 = false;
boolean leftPressed2 = false;
boolean rightPressed2 = false;

void setup()
{
    fullScreen();
    game = new Game();
    startScreen = new StartScreen(game);  // Passer l'instance de game à StartScreen
}

void draw()
{
    if (startScreen.isActive()) {
        startScreen.draw();  // Afficher l'écran d'accueil
    } else {
        game.update();
        game.draw();
    
      // Joueur 1
    if (leftPressed1 && !rightPressed1) 
        game.player1.move(-1);
    if (rightPressed1 && !leftPressed1) 
        game.player1.move(1);
  
    // Joueur 2
    if (leftPressed2 && !rightPressed2) 
        game.player2.move(-1);
    if (rightPressed2 && !leftPressed2) 
        game.player2.move(1);
  }
}

void keyPressed()
{
    if (startScreen.isActive()) {
        // Si l'écran d'accueil est actif et qu'on appuie sur Espace, on lance le jeu
        if (key == ' ') {
            startScreen.active = false;
            game.startGame();  // Démarre le jeu
        }
      } else {
        if (key == 'r' && game.gameOver) {
            game.reset();  // Recommence la partie
        } else if (key == 'h' && game.gameOver) {
            startScreen.active = true;  // Retour à l'écran d'accueil
            game.reset();  // Réinitialise la partie
        }

        if (key == 'q') leftPressed1 = true;
        if (key == 'd') rightPressed1 = true;

        if (keyCode == LEFT) leftPressed2 = true;
        if (keyCode == RIGHT) rightPressed2 = true;

        if (key == 'z') game.player1.jump();
        if (key == 's') game.player1.crouch(true);
        if (key == ' ') game.player1.shoot();
        if (key == 'e') game.player1.dash(leftPressed1, rightPressed1);
        if (key == 'r') game.player1.bullet.startReload();
        if (key == 'a') game.player1.activateShield();

        if (keyCode == UP) game.player2.jump();
        if (keyCode == DOWN) game.player2.crouch(true);
        if (key == '0') game.player2.shoot();
        if (key == 'l') game.player2.dash(leftPressed2, rightPressed2);
        if (key == 'p') game.player2.bullet.startReload();
        if (key == 'm') game.player2.activateShield();
    }
}

void keyReleased()
{
    if (key == 'q') leftPressed1 = false;
    if (key == 'd') rightPressed1 = false;

    if (keyCode == LEFT) leftPressed2 = false;
    if (keyCode == RIGHT) rightPressed2 = false;

    if (key == 's') game.player1.crouch(false);
    if (keyCode == DOWN) game.player2.crouch(false);

    if (key == 'a') game.player1.deactivateShield();
    if (key == 'm') game.player2.deactivateShield();
}