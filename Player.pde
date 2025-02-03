class Player {
  int x, y, speed;
  color couleur;
  float bulletX, bulletY;
  boolean bulletActive;
  char moveLeft, moveRight;

  Player(int startX, int startY, color c) {
    x = startX;
    y = startY;
    couleur = c;
    speed = 5;
    bulletActive = false;
  }

  void move(int leftKey, int rightKey) {
    if (keyPressed) {
        if (keyCode == leftKey && x > 5 && !(x - speed < player2.x + 50 && x > player2.x )) { 
            x -= speed;  // Déplacer à gauche si pas de collision
        } 
        else if (keyCode == rightKey && x + 50 < width - 5 && !(x + speed + 50 > player1.x && x < player1.x)) { 
            x += speed;  // Déplacer à droite si pas de collision
        }
    }
  }



  void shoot() {
    if (!bulletActive) {
      bulletX = x + 25; // Positionner la balle au centre du joueur
      bulletY = y;
      bulletActive = true;
    }
  }

  void updateBullet() {
    if (bulletActive) {
      bulletX += bulletSpeed;  // Déplacement de la balle vers la droite
      // Si la balle sort de l'écran, réinitialiser
      if (bulletX < 0 || bulletX > width) {
        resetBullet();
      }
    }
  }

  void resetBullet() {
    bulletActive = false;
  }

  void display() {
    fill(couleur);
    rect(x, y, 50, 150); // Affichage du joueur
  }

  void displayBullet() {
    if (bulletActive) {
      fill(255, 255, 0); // Couleur jaune pour les balles
      ellipse(bulletX, bulletY, 10, 10); // Affichage de la balle
    }
  }

  void reset() {
    x = (couleur == color(0, 255, 0)) ? 10 : 735; // Réinitialiser la position du joueur
    y = 440;
  }
}
