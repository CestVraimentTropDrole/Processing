Game game;

boolean leftPressed1 = false;
boolean rightPressed1 = false;
boolean leftPressed2 = false;
boolean rightPressed2 = false;

void setup()
{
    fullScreen();
    game = new Game();
}

void draw()
{
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

void keyPressed()
{
    if (!game.gameOver) {
      if (key == 'q') leftPressed1 = true;
      if (key == 'd') rightPressed1 = true;

      if (keyCode == LEFT) leftPressed2 = true;
      if (keyCode == RIGHT) rightPressed2 = true;


      if (key == 'z') game.player1.jump();
      if (key == 's') game.player1.crouch(true);
      if (key == ' ') game.player1.shoot();

      if (keyCode == UP) game.player2.jump();
      if (keyCode == DOWN) game.player2.crouch(true);
      if (key == '0') game.player2.shoot();
    }
    if (key == 'r' && game.gameOver) game.reset();
}

void keyReleased()
{
    if (key == 'q') leftPressed1 = false;
    if (key == 'd') rightPressed1 = false;

    if (keyCode == LEFT) leftPressed2 = false;
    if (keyCode == RIGHT) rightPressed2 = false;

    if (key == 's') game.player1.crouch(false);
    if (keyCode == DOWN) game.player2.crouch(false);
}