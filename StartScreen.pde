class StartScreen {
  boolean active;
  GameManager game;
  
  StartScreen(GameManager gameInstance) {
    active = true;
    game = gameInstance;
  }
  
  boolean isActive() {
    return active;
  }

  void draw() {
    background(0);
    fill(255);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("Hey Man ", width / 2, height / 3);
    textSize(32);
    text("Appuyez sur Espace pour jouer", width / 2, height / 2);
    drawStartButton();
  }

  void drawStartButton() {
    fill(0, 255, 0);
    rect(width / 2 - 100, height / 2 + 50, 200, 50);
    fill(0);
    textSize(24);
    text("START", width / 2, height / 2 + 75);
  }

  void mousePressed() {
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
        mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
      active = false;  // Passe à l'écran de jeu
      game.startGame(); // Lance le jeu en appelant une méthode start dans Game
    }
  }
}
